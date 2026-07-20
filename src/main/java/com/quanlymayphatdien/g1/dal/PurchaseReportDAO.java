package com.quanlymayphatdien.g1.dal;

import com.quanlymayphatdien.g1.entity.PurchaseOrder;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class PurchaseReportDAO extends BaseReportDAO {

    public int countPurchaseReport(Integer warehouseId, int month, int year) {
        return countWithParams(
                "SELECT COUNT(*) FROM purchase_order po"
                + " WHERE DATE(po.created_at) >= ? AND DATE(po.created_at) <= ?"
                + (warehouseId != null ? " AND po.warehouse_id = ?" : ""),
                params(month, year, warehouseId));
    }

    public List<PurchaseOrder> getPurchaseReport(Integer warehouseId, int month, int year, int page, int pageSize) {
        return queryPurchaseOrders(warehouseId, month, year, page, pageSize);
    }

    public List<PurchaseOrder> getAllPurchaseReport(Integer warehouseId, int month, int year) {
        return queryPurchaseOrders(warehouseId, month, year, -1, -1);
    }

    public List<Object[]> getPurchaseExcelData(Integer warehouseId, int month, int year) {
        String sql = "SELECT po.po_code, w.name, po.period,"
                + " g.model, pod.final_quantity, u.name,"
                + " DATE_FORMAT(po.created_at, '%d/%m/%Y'), po.status"
                + " FROM purchase_order po"
                + " JOIN warehouse w ON po.warehouse_id = w.warehouse_id"
                + " JOIN user u ON po.created_by = u.id"
                + " JOIN purchase_order_detail pod ON pod.po_id = po.po_id"
                + " JOIN generator g ON pod.generator_id = g.id"
                + " WHERE DATE(po.created_at) >= ? AND DATE(po.created_at) <= ?"
                + (warehouseId != null ? " AND po.warehouse_id = ?" : "")
                + " ORDER BY po.created_at DESC";
        return queryFlat(sql, params(month, year, warehouseId));
    }

    private List<PurchaseOrder> queryPurchaseOrders(Integer warehouseId, int month, int year, int page, int pageSize) {
        List<PurchaseOrder> list = new ArrayList<>();
        String sql = "SELECT po.*, w.name AS warehouse_name, u.name AS created_by_name,"
                + " GROUP_CONCAT(CONCAT(g.model, '|', pod.final_quantity, '|', COALESCE(pod.unit_price, 0)) SEPARATOR '; ') AS detail_info"
                + " FROM purchase_order po"
                + " LEFT JOIN warehouse w ON po.warehouse_id = w.warehouse_id"
                + " LEFT JOIN user u ON po.created_by = u.id"
                + " LEFT JOIN purchase_order_detail pod ON pod.po_id = po.po_id"
                + " LEFT JOIN generator g ON pod.generator_id = g.id"
                + " WHERE DATE(po.created_at) >= ? AND DATE(po.created_at) <= ?"
                + (warehouseId != null ? " AND po.warehouse_id = ?" : "")
                + " GROUP BY po.po_id"
                + " ORDER BY po.created_at DESC"
                + (page > 0 && pageSize > 0 ? " LIMIT ? OFFSET ?" : "");
        try {
            connection = getConnection();
            statement = connection.prepareStatement(sql);
            int idx = 1;
            statement.setString(idx++, firstDay(month, year));
            statement.setString(idx++, lastDay(month, year));
            if (warehouseId != null) statement.setInt(idx++, warehouseId);
            if (page > 0 && pageSize > 0) {
                statement.setInt(idx++, pageSize);
                statement.setInt(idx++, (page - 1) * pageSize);
            }
            resultSet = statement.executeQuery();
            while (resultSet.next()) {
                PurchaseOrder po = new PurchaseOrder();
                po.setPoId(resultSet.getInt("po_id"));
                po.setPoCode(resultSet.getString("po_code"));
                po.setPeriod(resultSet.getString("period"));
                if (resultSet.getDate("period_start") != null) {
                    po.setPeriodStart(resultSet.getDate("period_start").toLocalDate());
                }
                if (resultSet.getDate("period_end") != null) {
                    po.setPeriodEnd(resultSet.getDate("period_end").toLocalDate());
                }
                po.setWarehouseId(resultSet.getInt("warehouse_id"));
                po.setWarehouseName(resultSet.getString("warehouse_name"));
                po.setCreatedBy(resultSet.getInt("created_by"));
                po.setCreatedByName(resultSet.getString("created_by_name"));
                po.setStatus(resultSet.getString("status"));
                po.setTotalQuantity(resultSet.getInt("total_quantity"));
                if (resultSet.getTimestamp("created_at") != null) {
                    po.setCreatedAt(resultSet.getTimestamp("created_at").toLocalDateTime());
                }
                list.add(po);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            closeResources();
        }
        return list;
    }
}
