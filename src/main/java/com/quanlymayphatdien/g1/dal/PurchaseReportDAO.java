package com.quanlymayphatdien.g1.dal;

import com.quanlymayphatdien.g1.entity.PurchaseOrder;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class PurchaseReportDAO extends BaseReportDAO {

    private String searchClause(String search, List<Object> params) {
        if (search == null || search.trim().isEmpty()) return "";
        params.add("%" + search.trim() + "%");
        params.add("%" + search.trim() + "%");
        return " AND (po.po_code LIKE ? OR g.model LIKE ?)";
    }

    public int countPurchaseReport(Integer warehouseId, int month, int year, String search) {
        List<Object> params = new ArrayList<>();
        params.add(firstDay(month, year));
        params.add(lastDay(month, year));
        if (warehouseId != null) params.add(warehouseId);
        String searchWhere = searchClause(search, params);
        return countWithParams(
                "SELECT COUNT(*) FROM purchase_order po"
                + " JOIN purchase_order_detail pod ON pod.po_id = po.po_id"
                + " JOIN generator g ON pod.generator_id = g.id"
                + " WHERE DATE(po.created_at) >= ? AND DATE(po.created_at) <= ?"
                + (warehouseId != null ? " AND po.warehouse_id = ?" : "")
                + searchWhere,
                params);
    }

    public List<PurchaseOrder> getPurchaseReport(Integer warehouseId, int month, int year, int page, int pageSize, String search) {
        return queryPurchaseOrders(warehouseId, month, year, page, pageSize, search);
    }

    public List<PurchaseOrder> getAllPurchaseReport(Integer warehouseId, int month, int year) {
        return queryPurchaseOrders(warehouseId, month, year, -1, -1, null);
    }

    public List<Object[]> trendPurchase(Integer warehouseId, int year) {
        List<Object> p = new ArrayList<>();
        p.add(year);
        if (warehouseId != null) p.add(warehouseId);
        return queryFlat(
            "SELECT DATE_FORMAT(po.created_at,'%Y-%m'),COALESCE(SUM(pod.final_quantity*pod.unit_price),0)"
            + " FROM purchase_order po"
            + " LEFT JOIN purchase_order_detail pod ON pod.po_id=po.po_id"
            + " WHERE YEAR(po.created_at)=?"
            + (warehouseId != null ? " AND po.warehouse_id=?" : "")
            + " GROUP BY 1 ORDER BY 1", p);
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

    public Map<String, Object> getPurchaseSummary(Integer warehouseId, int month, int year) {
        Map<String, Object> summary = new HashMap<>();
        List<Object> params = new ArrayList<>();
        params.add(firstDay(month, year));
        params.add(lastDay(month, year));
        if (warehouseId != null) params.add(warehouseId);

        String totalSql = "SELECT COALESCE(SUM(pod.final_quantity * pod.unit_price), 0) AS total_amount"
                + " FROM purchase_order po"
                + " JOIN purchase_order_detail pod ON pod.po_id = po.po_id"
                + " WHERE DATE(po.created_at) >= ? AND DATE(po.created_at) <= ?"
                + (warehouseId != null ? " AND po.warehouse_id = ?" : "");
        try {
            connection = getConnection();
            statement = connection.prepareStatement(totalSql);
            for (int i = 0; i < params.size(); i++) {
                statement.setObject(i + 1, params.get(i));
            }
            resultSet = statement.executeQuery();
            if (resultSet.next()) {
                summary.put("totalAmount", resultSet.getDouble("total_amount"));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            closeResources();
        }

        String topSql = "SELECT g.model, SUM(pod.final_quantity) AS total_qty"
                + " FROM purchase_order po"
                + " JOIN purchase_order_detail pod ON pod.po_id = po.po_id"
                + " JOIN generator g ON pod.generator_id = g.id"
                + " WHERE DATE(po.created_at) >= ? AND DATE(po.created_at) <= ?"
                + (warehouseId != null ? " AND po.warehouse_id = ?" : "")
                + " GROUP BY g.id, g.model ORDER BY total_qty DESC LIMIT 1";
        try {
            connection = getConnection();
            statement = connection.prepareStatement(topSql);
            for (int i = 0; i < params.size(); i++) {
                statement.setObject(i + 1, params.get(i));
            }
            resultSet = statement.executeQuery();
            if (resultSet.next()) {
                summary.put("topModel", resultSet.getString("model"));
                summary.put("topModelQty", resultSet.getInt("total_qty"));
            } else {
                summary.put("topModel", "");
                summary.put("topModelQty", 0);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            closeResources();
        }
        return summary;
    }

    private List<PurchaseOrder> queryPurchaseOrders(Integer warehouseId, int month, int year, int page, int pageSize, String search) {
        List<PurchaseOrder> list = new ArrayList<>();
        List<Object> params = new ArrayList<>();
        params.add(firstDay(month, year));
        params.add(lastDay(month, year));
        if (warehouseId != null) params.add(warehouseId);
        String searchWhere = searchClause(search, params);
        String sql = "SELECT po.*, w.name AS warehouse_name, u.name AS created_by_name,"
                + " GROUP_CONCAT(DISTINCT s.name SEPARATOR ', ') AS supplier_name,"
                + " COALESCE(SUM(pod.final_quantity * pod.unit_price), 0) AS total_amount"
                + " FROM purchase_order po"
                + " LEFT JOIN warehouse w ON po.warehouse_id = w.warehouse_id"
                + " LEFT JOIN user u ON po.created_by = u.id"
                + " LEFT JOIN purchase_order_detail pod ON pod.po_id = po.po_id"
                + " LEFT JOIN generator g ON pod.generator_id = g.id"
                + " LEFT JOIN import_proposal ip ON ip.purchase_order_id = po.po_id"
                + " LEFT JOIN supplier s ON s.id = ip.supplier_id"
                + " WHERE DATE(po.created_at) >= ? AND DATE(po.created_at) <= ?"
                + (warehouseId != null ? " AND po.warehouse_id = ?" : "")
                + searchWhere
                + " GROUP BY po.po_id"
                + " ORDER BY po.created_at DESC"
                + (page > 0 && pageSize > 0 ? " LIMIT ? OFFSET ?" : "");
        try {
            connection = getConnection();
            statement = connection.prepareStatement(sql);
            int idx = 1;
            for (int i = 0; i < params.size(); i++) {
                statement.setObject(idx++, params.get(i));
            }
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
                po.setSupplierName(resultSet.getString("supplier_name"));
                po.setTotalAmount(resultSet.getDouble("total_amount"));
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
