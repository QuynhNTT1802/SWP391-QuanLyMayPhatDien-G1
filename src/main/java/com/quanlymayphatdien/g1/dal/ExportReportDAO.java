package com.quanlymayphatdien.g1.dal;

import com.quanlymayphatdien.g1.entity.ReceiptDetailReportItem;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class ExportReportDAO extends BaseReportDAO {

    private String searchClause(String search, List<Object> params) {
        if (search == null || search.trim().isEmpty()) return "";
        params.add("%" + search.trim() + "%");
        params.add("%" + search.trim() + "%");
        params.add("%" + search.trim() + "%");
        params.add("%" + search.trim() + "%");
        return " AND (r.receipt_code LIKE ? OR g.model LIKE ? OR i2.serial_number LIKE ? OR c.name LIKE ?)";
    }

    public int countExportReport(Integer warehouseId, int month, int year, String search) {
        List<Object> params = new ArrayList<>();
        params.add(firstDay(month, year));
        params.add(lastDay(month, year));
        if (warehouseId != null) params.add(warehouseId);
        String searchWhere = searchClause(search, params);
        return countWithParams(
                "SELECT COUNT(*) FROM receipt r"
                + " JOIN receipt_detail rd ON rd.receipt_id = r.receipt_id"
                + " JOIN inventory i2 ON rd.inventory_id = i2.inventory_id"
                + " JOIN generator g ON i2.generator_id = g.id"
                + " LEFT JOIN sale_order so ON r.order_id = so.order_id"
                + " LEFT JOIN customer c ON so.customer_id = c.id"
                + " WHERE r.receipt_type = 'EXPORT'"
                + " AND DATE(r.created_at) >= ? AND DATE(r.created_at) <= ?"
                + (warehouseId != null ? " AND r.warehouse_id = ?" : "")
                + searchWhere,
                params);
    }

    public List<ReceiptDetailReportItem> getExportReport(Integer warehouseId, int month, int year, int page, int pageSize, String search) {
        return queryExportReportDetail(warehouseId, month, year, page, pageSize, search);
    }

    public List<ReceiptDetailReportItem> getAllExportReport(Integer warehouseId, int month, int year) {
        return queryExportReportDetail(warehouseId, month, year, -1, -1, null);
    }

    public List<Object[]> trendExport(Integer warehouseId, int year) {
        List<Object> p = new ArrayList<>();
        p.add(year);
        if (warehouseId != null) p.add(warehouseId);
        return queryFlat(
            "SELECT DATE_FORMAT(r.created_at,'%Y-%m'),COUNT(*)"
            + " FROM receipt r WHERE r.receipt_type='EXPORT'"
            + " AND YEAR(r.created_at)=?"
            + (warehouseId != null ? " AND r.warehouse_id=?" : "")
            + " GROUP BY 1 ORDER BY 1", p);
    }

    public List<Object[]> getExportExcelData(Integer warehouseId, int month, int year) {
        String sql = "SELECT r.receipt_code, DATE_FORMAT(r.created_at, '%d/%m/%Y'), w.name,"
                + " c.name, g.model, i2.serial_number, u.name"
                + " FROM receipt r"
                + " JOIN warehouse w ON r.warehouse_id = w.warehouse_id"
                + " JOIN user u ON r.created_by = u.id"
                + " LEFT JOIN sale_order so ON r.order_id = so.order_id"
                + " LEFT JOIN customer c ON so.customer_id = c.id"
                + " JOIN receipt_detail rd ON rd.receipt_id = r.receipt_id"
                + " JOIN inventory i2 ON rd.inventory_id = i2.inventory_id"
                + " JOIN generator g ON i2.generator_id = g.id"
                + " WHERE r.receipt_type = 'EXPORT'"
                + " AND DATE(r.created_at) >= ? AND DATE(r.created_at) <= ?"
                + (warehouseId != null ? " AND r.warehouse_id = ?" : "")
                + " ORDER BY r.created_at DESC";
        return queryFlat(sql, params(month, year, warehouseId));
    }

    private List<ReceiptDetailReportItem> queryExportReportDetail(Integer warehouseId, int month, int year, int page, int pageSize, String search) {
        List<ReceiptDetailReportItem> list = new ArrayList<>();
        List<Object> params = new ArrayList<>();
        params.add(firstDay(month, year));
        params.add(lastDay(month, year));
        if (warehouseId != null) params.add(warehouseId);
        String searchWhere = searchClause(search, params);
        String sql = "SELECT r.receipt_id, r.receipt_code, r.created_at, w.name AS warehouse_name,"
                + " g.model, i2.serial_number, u.name AS created_by_name, r.status,"
                + " r.order_id, so.order_code, c.name AS customer_name"
                + " FROM receipt r"
                + " JOIN warehouse w ON r.warehouse_id = w.warehouse_id"
                + " JOIN user u ON r.created_by = u.id"
                + " JOIN receipt_detail rd ON rd.receipt_id = r.receipt_id"
                + " JOIN inventory i2 ON rd.inventory_id = i2.inventory_id"
                + " JOIN generator g ON i2.generator_id = g.id"
                + " LEFT JOIN sale_order so ON r.order_id = so.order_id"
                + " LEFT JOIN customer c ON so.customer_id = c.id"
                + " WHERE r.receipt_type = 'EXPORT'"
                + " AND DATE(r.created_at) >= ? AND DATE(r.created_at) <= ?"
                + (warehouseId != null ? " AND r.warehouse_id = ?" : "")
                + searchWhere
                + " ORDER BY r.created_at DESC, r.receipt_code"
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
                ReceiptDetailReportItem item = new ReceiptDetailReportItem();
                item.setReceiptId(resultSet.getInt("receipt_id"));
                item.setReceiptCode(resultSet.getString("receipt_code"));
                if (resultSet.getTimestamp("created_at") != null)
                    item.setCreatedAt(resultSet.getTimestamp("created_at").toLocalDateTime());
                item.setWarehouseName(resultSet.getString("warehouse_name"));
                item.setModel(resultSet.getString("model"));
                item.setSerialNumber(resultSet.getString("serial_number"));
                item.setCreatedByName(resultSet.getString("created_by_name"));
                item.setStatus(resultSet.getString("status"));
                try { item.setOrderId(resultSet.getInt("order_id")); } catch (SQLException ignored) {}
                item.setOrderCode(resultSet.getString("order_code"));
                item.setCustomerName(resultSet.getString("customer_name"));
                list.add(item);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            closeResources();
        }
        return list;
    }
}
