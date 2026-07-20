/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package com.quanlymayphatdien.g1.dal;

import com.quanlymayphatdien.g1.entity.InventoryCheckReportItem;
import com.quanlymayphatdien.g1.entity.InventoryReportItem;
import com.quanlymayphatdien.g1.entity.PurchaseOrder;
import com.quanlymayphatdien.g1.entity.Receipt;
import com.quanlymayphatdien.g1.entity.SaleOrder;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.time.LocalDate;
import java.util.ArrayList;
import java.util.List;

/**
 *
 * @author Aadmin
 */
public class ReportDAO extends DBContext{

    private static String firstDay(int month, int year) {
        return String.format("%04d-%02d-01", year, month);
    }
    private static String lastDay(int month, int year) {
        return LocalDate.of(year, month, 1).plusMonths(1).minusDays(1).toString();
    }
    private static String nextDay(int month, int year) {
        return LocalDate.of(year, month, 1).plusMonths(1).toString();
    }

    public int countInventoryReport(Integer warehouseId, int month, int year) {
        String firstDay = firstDay(month, year);
        String lastDay = lastDay(month, year);
        String sql = "SELECT COUNT(DISTINCT t.warehouse_id, t.generator_id) FROM ("
                + "SELECT DISTINCT warehouse_id, generator_id FROM stock_card"
                + " WHERE DATE(created_at) <= ?"
                + (warehouseId != null ? " AND warehouse_id = ?" : "")
                + " UNION SELECT DISTINCT i.warehouse_id, i.generator_id FROM inventory i"
                + " WHERE i.status = 'IN_STOCK'"
                + (warehouseId != null ? " AND i.warehouse_id = ?" : "")
                + ") t";
        List<Object> params = new ArrayList<>();
        params.add(lastDay);
        if (warehouseId != null) {
            params.add(warehouseId);
            params.add(warehouseId);
        }
        return countWithParams(sql, params);
    }
    
    public List<InventoryReportItem> getInventoryReport(Integer warehouseId, int month, int year, int page, int pageSize) {
        return queryInventoryReport(buildInventorySql(warehouseId), warehouseId, month, year, page, pageSize);
    }
    
    public List<InventoryReportItem> getAllInventoryReport(Integer warehouseId, int month, int year) {
        return queryInventoryReport(buildInventorySql(warehouseId) + " ORDER BY w.name, g.model",
                warehouseId, month, year, -1, -1);
    }
    
    private String buildInventorySql(Integer warehouseId) {
        return "SELECT t.warehouse_id, w.name AS warehouse_name,"
                + " t.generator_id, g.model,"
                + " COALESCE(br.name, '') AS brand,"
                + " COALESCE(open_qty, 0) AS open_qty,"
                + " COALESCE(close_qty, 0) AS close_qty"
                + " FROM ("
                + "  SELECT DISTINCT warehouse_id, generator_id FROM stock_card"
                + "  WHERE created_at < ?"
                + (warehouseId != null ? " AND warehouse_id = ?" : "")
                + "  UNION SELECT DISTINCT i.warehouse_id, i.generator_id FROM inventory i"
                + "  WHERE i.status = 'IN_STOCK'"
                + (warehouseId != null ? " AND i.warehouse_id = ?" : "")
                + " ) t"
                + " JOIN generator g ON t.generator_id = g.id"
                + " JOIN warehouse w ON t.warehouse_id = w.warehouse_id"
                + " LEFT JOIN generator_category gc_br ON gc_br.generator_id = g.id"
                + "  AND gc_br.category_id IN (SELECT id FROM category WHERE type = 'brand')"
                + " LEFT JOIN category br ON gc_br.category_id = br.id"
                + " LEFT JOIN ("
                + "  SELECT sc1.warehouse_id, sc1.generator_id, sc1.quantity_after AS open_qty"
                + "  FROM stock_card sc1"
                + "  WHERE sc1.stock_card_id IN ("
                + "   SELECT MAX(sc2.stock_card_id) FROM stock_card sc2"
                + "   WHERE sc2.warehouse_id = sc1.warehouse_id"
                + "    AND sc2.generator_id = sc1.generator_id"
                + "    AND sc2.created_at < ?"
                + "   GROUP BY sc2.warehouse_id, sc2.generator_id"
                + "  )"
                + " ) open_t ON open_t.warehouse_id = t.warehouse_id AND open_t.generator_id = t.generator_id"
                + " LEFT JOIN ("
                + "  SELECT sc3.warehouse_id, sc3.generator_id, sc3.quantity_after AS close_qty"
                + "  FROM stock_card sc3"
                + "  WHERE sc3.stock_card_id IN ("
                + "   SELECT MAX(sc4.stock_card_id) FROM stock_card sc4"
                + "   WHERE sc4.warehouse_id = sc3.warehouse_id"
                + "    AND sc4.generator_id = sc3.generator_id"
                + "    AND sc4.created_at < ?"
                + "   GROUP BY sc4.warehouse_id, sc4.generator_id"
                + "  )"
                + " ) close_t ON close_t.warehouse_id = t.warehouse_id AND close_t.generator_id = t.generator_id";
    }
    
    public int countImportReport(Integer warehouseId, int month, int year) {
        return countWithParams(
                "SELECT COUNT(*) FROM receipt r WHERE r.receipt_type = 'IMPORT' AND r.status = 'COMPLETED'"
                + " AND DATE(r.created_at) >= ? AND DATE(r.created_at) <= ?"
                + (warehouseId != null ? " AND r.warehouse_id = ?" : ""),
                params(month, year, warehouseId));
    }

    public int countExportReport(Integer warehouseId, int month, int year) {
        return countWithParams(
                "SELECT COUNT(*) FROM receipt r WHERE r.receipt_type = 'EXPORT'"
                + " AND DATE(r.created_at) >= ? AND DATE(r.created_at) <= ?"
                + (warehouseId != null ? " AND r.warehouse_id = ?" : ""),
                params(month, year, warehouseId));
    }

    public List<Receipt> getImportReport(Integer warehouseId, int month, int year, int page, int pageSize) {
        return queryImportReceipts(warehouseId, month, year, page, pageSize);
    }

    public List<Receipt> getAllImportReport(Integer warehouseId, int month, int year) {
        return queryImportReceipts(warehouseId, month, year, -1, -1);
    }

    public List<Receipt> getExportReport(Integer warehouseId, int month, int year, int page, int pageSize) {
        return queryExportReceipts(warehouseId, month, year, page, pageSize);
    }

    public List<Receipt> getAllExportReport(Integer warehouseId, int month, int year) {
        return queryExportReceipts(warehouseId, month, year, -1, -1);
    }

    private List<Object> params(int month, int year, Integer warehouseId) {
        List<Object> p = new ArrayList<>();
        p.add(firstDay(month, year));
        p.add(lastDay(month, year));
        if (warehouseId != null) p.add(warehouseId);
        return p;
    }

    private String detailInfoSubquery() {
        return " (SELECT GROUP_CONCAT(CONCAT(g.model, '|', i2.serial_number) SEPARATOR '; ')"
                + "  FROM receipt_detail rd"
                + "  JOIN inventory i2 ON rd.inventory_id = i2.inventory_id"
                + "  JOIN generator g ON i2.generator_id = g.id"
                + "  WHERE rd.receipt_id = r.receipt_id) AS detail_info";
    }

    private List<Receipt> queryImportReceipts(Integer warehouseId, int month, int year, int page, int pageSize) {
        List<Receipt> list = new ArrayList<>();
        String sql = "SELECT r.*, w.name AS warehouse_name, u.name AS created_by_name,"
                + " po.po_code AS purchase_order_code," + detailInfoSubquery()
                + " FROM receipt r"
                + " LEFT JOIN warehouse w ON r.warehouse_id = w.warehouse_id"
                + " LEFT JOIN user u ON r.created_by = u.id"
                + " LEFT JOIN purchase_order po ON r.purchase_order_id = po.po_id"
                + " WHERE r.receipt_type = 'IMPORT' AND r.status = 'COMPLETED'"
                + " AND DATE(r.created_at) >= ? AND DATE(r.created_at) <= ?"
                + (warehouseId != null ? " AND r.warehouse_id = ?" : "")
                + " ORDER BY r.created_at DESC"
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
                Receipt r = mapReceipt(resultSet);
                r.setPurchaseOrderCode(resultSet.getString("purchase_order_code"));
                list.add(r);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            closeResources();
        }
        return list;
    }

    private List<Receipt> queryExportReceipts(Integer warehouseId, int month, int year, int page, int pageSize) {
        List<Receipt> list = new ArrayList<>();
        String sql = "SELECT r.*, w.name AS warehouse_name, u.name AS created_by_name,"
                + " so.order_code, c.name AS customer_name," + detailInfoSubquery()
                + " FROM receipt r"
                + " LEFT JOIN warehouse w ON r.warehouse_id = w.warehouse_id"
                + " LEFT JOIN user u ON r.created_by = u.id"
                + " LEFT JOIN sale_order so ON r.order_id = so.order_id"
                + " LEFT JOIN customer c ON so.customer_id = c.id"
                + " WHERE r.receipt_type = 'EXPORT'"
                + " AND DATE(r.created_at) >= ? AND DATE(r.created_at) <= ?"
                + (warehouseId != null ? " AND r.warehouse_id = ?" : "")
                + " ORDER BY r.created_at DESC"
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
                Receipt r = mapReceipt(resultSet);
                r.setOrderCode(resultSet.getString("order_code"));
                r.setCustomerName(resultSet.getString("customer_name"));
                list.add(r);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            closeResources();
        }
        return list;
    }

    private Receipt mapReceipt(ResultSet rs) throws SQLException {
        Receipt r = new Receipt();
        r.setReceiptId(rs.getInt("receipt_id"));
        r.setReceiptCode(rs.getString("receipt_code"));
        r.setReceiptType(rs.getString("receipt_type"));
        r.setWarehouseId(rs.getInt("warehouse_id"));
        r.setWarehouseName(rs.getString("warehouse_name"));
        r.setCreatedBy(rs.getInt("created_by"));
        r.setCreatedByName(rs.getString("created_by_name"));
        r.setStatus(rs.getString("status"));
        r.setNote(rs.getString("note"));
        r.setOrderId((Integer) rs.getObject("order_id"));
        r.setPurchaseOrderId((Integer) rs.getObject("purchase_order_id"));
        if (rs.getTimestamp("created_at") != null) {
            r.setCreatedAt(rs.getTimestamp("created_at").toLocalDateTime());
        }
        return r;
    }
    
    public int countInventoryCheckReport(Integer warehouseId, int month, int year) {
        String firstDay = firstDay(month, year);
        String lastDay = lastDay(month, year);
        String sql = "SELECT COUNT(*) FROM inventory_check ic"
                + " JOIN inventory_check_detail icd ON icd.check_id = ic.id"
                + " WHERE DATE(ic.created_at) >= ? AND DATE(ic.created_at) <= ?"
                + (warehouseId != null ? " AND ic.warehouse_id = ?" : "");
        List<Object> params = new ArrayList<>();
        params.add(firstDay);
        params.add(lastDay);
        if (warehouseId != null) {
            params.add(warehouseId);
        }
        return countWithParams(sql, params);
    }
    
    public List<InventoryCheckReportItem> getInventoryCheckReport(Integer warehouseId, int month, int year, int page, int pageSize) {
        String firstDay = firstDay(month, year);
        String lastDay = lastDay(month, year);
        String sql = "SELECT ic.id AS check_id, ic.check_code, ic.warehouse_id, w.name AS warehouse_name,"
                + " ic.status, u.name AS created_by_name,"
                + " ic.started_at, ic.completed_at,"
                + " icd.generator_id, g.model AS generator_model,"
                + " icd.system_quantity, icd.actual_quantity,"
                + " (COALESCE(icd.system_quantity, 0) - COALESCE(icd.actual_quantity, 0)) AS discrepancy"
                + " FROM inventory_check ic"
                + " JOIN inventory_check_detail icd ON icd.check_id = ic.id"
                + " JOIN generator g ON icd.generator_id = g.id"
                + " LEFT JOIN warehouse w ON ic.warehouse_id = w.warehouse_id"
                + " LEFT JOIN user u ON ic.created_by = u.id"
                + " WHERE DATE(ic.created_at) >= ? AND DATE(ic.created_at) <= ?"
                + (warehouseId != null ? " AND ic.warehouse_id = ?" : "")
                + " ORDER BY ic.created_at DESC, ic.check_code"
                + " LIMIT ? OFFSET ?";
        List<Object> params = new ArrayList<>();
        params.add(firstDay);
        params.add(lastDay);
        if (warehouseId != null) {
            params.add(warehouseId);
        }
        params.add(pageSize);
        params.add((page - 1) * pageSize);
        return queryInventoryCheckReport(sql, params);
    }
    
    public List<InventoryCheckReportItem> getAllInventoryCheckReport(Integer warehouseId, int month, int year) {
        String firstDay = firstDay(month, year);
        String lastDay = lastDay(month, year);
        String sql = "SELECT ic.id AS check_id, ic.check_code, ic.warehouse_id, w.name AS warehouse_name,"
                + " ic.status, u.name AS created_by_name,"
                + " ic.started_at, ic.completed_at,"
                + " icd.generator_id, g.model AS generator_model,"
                + " icd.system_quantity, icd.actual_quantity,"
                + " (COALESCE(icd.system_quantity, 0) - COALESCE(icd.actual_quantity, 0)) AS discrepancy"
                + " FROM inventory_check ic"
                + " JOIN inventory_check_detail icd ON icd.check_id = ic.id"
                + " JOIN generator g ON icd.generator_id = g.id"
                + " LEFT JOIN warehouse w ON ic.warehouse_id = w.warehouse_id"
                + " LEFT JOIN user u ON ic.created_by = u.id"
                + " WHERE DATE(ic.created_at) >= ? AND DATE(ic.created_at) <= ?"
                + (warehouseId != null ? " AND ic.warehouse_id = ?" : "")
                + " ORDER BY ic.created_at DESC, ic.check_code";
        List<Object> params = new ArrayList<>();
        params.add(firstDay);
        params.add(lastDay);
        if (warehouseId != null) {
            params.add(warehouseId);
        }
        return queryInventoryCheckReport(sql, params);
    }
    
    public int countPurchaseReport(Integer warehouseId, int month, int year) {
        String firstDay = firstDay(month, year);
        String lastDay = lastDay(month, year);
        String sql = "SELECT COUNT(*) FROM purchase_order po"
                + " WHERE DATE(po.created_at) >= ? AND DATE(po.created_at) <= ?"
                + (warehouseId != null ? " AND po.warehouse_id = ?" : "");
        List<Object> params = new ArrayList<>();
        params.add(firstDay);
        params.add(lastDay);
        if (warehouseId != null) {
            params.add(warehouseId);
        }
        return countWithParams(sql, params);
    }
    
    public List<PurchaseOrder> getPurchaseReport(Integer warehouseId, int month, int year, int page, int pageSize) {
        return queryPurchaseOrders(buildPurchaseSql(warehouseId, false), warehouseId, month, year, page, pageSize);
    }
    
    public List<PurchaseOrder> getAllPurchaseReport(Integer warehouseId, int month, int year) {
        return queryPurchaseOrders(buildPurchaseSql(warehouseId, true), warehouseId, month, year, -1, -1);
    }
    
    private String buildPurchaseSql(Integer warehouseId, boolean allRows) {
        return "SELECT po.*, w.name AS warehouse_name, u.name AS created_by_name,"
                + " GROUP_CONCAT(CONCAT(g.model, '|', pod.final_quantity, '|', COALESCE(pod.unit_price, 0)) SEPARATOR '; ') AS detail_info"
                + " FROM purchase_order po"
                + " LEFT JOIN warehouse w ON po.warehouse_id = w.warehouse_id"
                + " LEFT JOIN user u ON po.created_by = u.id"
                + " LEFT JOIN purchase_order_detail pod ON pod.po_id = po.po_id"
                + " LEFT JOIN generator g ON pod.generator_id = g.id"
                + " WHERE DATE(po.created_at) >= ? AND DATE(po.created_at) <= ?"
                + (warehouseId != null ? " AND po.warehouse_id = ?" : "")
                + " GROUP BY po.po_id"
                + " ORDER BY po.created_at DESC";
    }
    
    public int countSalesReport(int month, int year) {
        String firstDay = firstDay(month, year);
        String lastDay = lastDay(month, year);
        String sql = "SELECT COUNT(*) FROM sale_order so"
                + " WHERE DATE(so.created_at) >= ? AND DATE(so.created_at) <= ?";
        List<Object> params = new ArrayList<>();
        params.add(firstDay);
        params.add(lastDay);
        return countWithParams(sql, params);
    }
    
    public List<SaleOrder> getSalesReport(int month, int year, int page, int pageSize) {
        return querySaleOrders(buildSalesSql(false), month, year, page, pageSize);
    }
    
    public List<SaleOrder> getAllSalesReport(int month, int year) {
        return querySaleOrders(buildSalesSql(true), month, year, -1, -1);
    }
    
    private String buildSalesSql(boolean allRows) {
        return "SELECT so.*, c.name AS customer_name, u.name AS created_by_name,"
                + " GROUP_CONCAT(CONCAT(g.model, '|', od.quantity, '|', od.unit_price) SEPARATOR '; ') AS detail_info"
                + " FROM sale_order so"
                + " LEFT JOIN customer c ON so.customer_id = c.id"
                + " LEFT JOIN user u ON so.created_by = u.id"
                + " LEFT JOIN order_detail od ON od.order_id = so.order_id"
                + " LEFT JOIN generator g ON od.generator_id = g.id"
                + " WHERE DATE(so.created_at) >= ? AND DATE(so.created_at) <= ?"
                + " GROUP BY so.order_id"
                + " ORDER BY so.created_at DESC";
    }
    
    private int countWithParams(String sql, List<Object> params) {
        try {
            connection = getConnection();
            statement = connection.prepareStatement(sql);
            for (int i = 0; i < params.size(); i++) {
                statement.setObject(i + 1, params.get(i));
            }
            resultSet = statement.executeQuery();
            if (resultSet.next()) {
                return resultSet.getInt(1);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            closeResources();
        }
        return 0;
    }
    
    private List<InventoryReportItem> queryInventoryReport(String baseSql, Integer warehouseId,
            int month, int year, int page, int pageSize) {
        List<InventoryReportItem> list = new ArrayList<>();
        String firstDay = firstDay(month, year);
        String nextDay = nextDay(month, year);
        StringBuilder sql = new StringBuilder(baseSql);
        List<Object> params = new ArrayList<>();
        params.add(nextDay);
        if (warehouseId != null) {
            params.add(warehouseId);
            params.add(warehouseId);
        }
        params.add(firstDay);
        params.add(nextDay);
        if (page > 0 && pageSize > 0) {
            sql.append(" LIMIT ? OFFSET ?");
            params.add(pageSize);
            params.add((page - 1) * pageSize);
        }
        try {
            connection = getConnection();
            statement = connection.prepareStatement(sql.toString());
            for (int i = 0; i < params.size(); i++) {
                statement.setObject(i + 1, params.get(i));
            }
            resultSet = statement.executeQuery();
            while (resultSet.next()) {
                InventoryReportItem item = new InventoryReportItem();
                item.setWarehouseId(resultSet.getInt("warehouse_id"));
                item.setWarehouseName(resultSet.getString("warehouse_name"));
                item.setGeneratorId(resultSet.getInt("generator_id"));
                item.setModel(resultSet.getString("model"));
                item.setBrand(resultSet.getString("brand"));
                item.setOpenQuantity(resultSet.getInt("open_qty"));
                item.setCloseQuantity(resultSet.getInt("close_qty"));
                list.add(item);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            closeResources();
        }
        return list;
    }
    
    private List<InventoryCheckReportItem> queryInventoryCheckReport(String sql, List<Object> params) {
        List<InventoryCheckReportItem> list = new ArrayList<>();
        try {
            connection = getConnection();
            statement = connection.prepareStatement(sql);
            for (int i = 0; i < params.size(); i++) {
                statement.setObject(i + 1, params.get(i));
            }
            resultSet = statement.executeQuery();
            while (resultSet.next()) {
                InventoryCheckReportItem item = new InventoryCheckReportItem();
                item.setCheckId(resultSet.getInt("check_id"));
                item.setCheckCode(resultSet.getString("check_code"));
                item.setWarehouseId(resultSet.getInt("warehouse_id"));
                item.setWarehouseName(resultSet.getString("warehouse_name"));
                item.setStatus(resultSet.getString("status"));
                item.setCreatedByName(resultSet.getString("created_by_name"));
                if (resultSet.getTimestamp("started_at") != null) {
                    item.setStartedAt(resultSet.getTimestamp("started_at").toLocalDateTime());
                }
                if (resultSet.getTimestamp("completed_at") != null) {
                    item.setCompletedAt(resultSet.getTimestamp("completed_at").toLocalDateTime());
                }
                item.setGeneratorId(resultSet.getInt("generator_id"));
                item.setGeneratorModel(resultSet.getString("generator_model"));
                item.setSystemQuantity(resultSet.getInt("system_quantity"));
                item.setActualQuantity(resultSet.getInt("actual_quantity"));
                item.setDiscrepancy(resultSet.getInt("discrepancy"));
                list.add(item);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            closeResources();
        }
        return list;
    }
    

    
    private List<PurchaseOrder> queryPurchaseOrders(String baseSql, Integer warehouseId,
            int month, int year, int page, int pageSize) {
        List<PurchaseOrder> list = new ArrayList<>();
        String firstDay = firstDay(month, year);
        String lastDay = lastDay(month, year);
        StringBuilder sql = new StringBuilder(baseSql);
        List<Object> params = new ArrayList<>();
        params.add(firstDay);
        params.add(lastDay);
        if (warehouseId != null) {
            params.add(warehouseId);
        }
        if (page > 0 && pageSize > 0) {
            sql.append(" LIMIT ? OFFSET ?");
            params.add(pageSize);
            params.add((page - 1) * pageSize);
        }
        try {
            connection = getConnection();
            statement = connection.prepareStatement(sql.toString());
            for (int i = 0; i < params.size(); i++) {
                statement.setObject(i + 1, params.get(i));
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
    
    private List<SaleOrder> querySaleOrders(String baseSql, int month, int year, int page, int pageSize) {
        List<SaleOrder> list = new ArrayList<>();
        String firstDay = firstDay(month, year);
        String lastDay = lastDay(month, year);
        StringBuilder sql = new StringBuilder(baseSql);
        List<Object> params = new ArrayList<>();
        params.add(firstDay);
        params.add(lastDay);
        if (page > 0 && pageSize > 0) {
            sql.append(" LIMIT ? OFFSET ?");
            params.add(pageSize);
            params.add((page - 1) * pageSize);
        }
        try {
            connection = getConnection();
            statement = connection.prepareStatement(sql.toString());
            for (int i = 0; i < params.size(); i++) {
                statement.setObject(i + 1, params.get(i));
            }
            resultSet = statement.executeQuery();
            while (resultSet.next()) {
                SaleOrder so = new SaleOrder();
                so.setOrderId(resultSet.getInt("order_id"));
                so.setOrderCode(resultSet.getString("order_code"));
                so.setCustomerId(resultSet.getInt("customer_id"));
                so.setCreatedByName(resultSet.getString("created_by_name"));
                so.setStatus(resultSet.getString("status"));
                so.setTotalAmount(resultSet.getDouble("total_amount"));
                if (resultSet.getTimestamp("created_at") != null) {
                    so.setCreatedAt(resultSet.getTimestamp("created_at"));
                }
                if (resultSet.getTimestamp("order_date") != null) {
                    so.setOrderDate(resultSet.getTimestamp("order_date"));
                }
                try {
                    com.quanlymayphatdien.g1.entity.Customer c = new com.quanlymayphatdien.g1.entity.Customer();
                    c.setName(resultSet.getString("customer_name"));
                    so.setCustomer(c);
                } catch (Exception e) {
                }
                list.add(so);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            closeResources();
        }
        return list;
    }
    
    public List<Object[]> getImportExcelData(Integer warehouseId, int month, int year) {
        String firstDay = firstDay(month, year);
        String lastDay = lastDay(month, year);
        String sql = "SELECT r.receipt_code, DATE_FORMAT(r.created_at, '%d/%m/%Y'), w.name,"
                + " g.model, i2.serial_number, u.name"
                + " FROM receipt r"
                + " JOIN warehouse w ON r.warehouse_id = w.warehouse_id"
                + " JOIN user u ON r.created_by = u.id"
                + " JOIN receipt_detail rd ON rd.receipt_id = r.receipt_id"
                + " JOIN inventory i2 ON rd.inventory_id = i2.inventory_id"
                + " JOIN generator g ON i2.generator_id = g.id"
                + " WHERE r.receipt_type = 'IMPORT' AND r.status = 'COMPLETED'"
                + " AND DATE(r.created_at) >= ? AND DATE(r.created_at) <= ?"
                + (warehouseId != null ? " AND r.warehouse_id = ?" : "")
                + " ORDER BY r.created_at DESC";
        List<Object> params = new ArrayList<>();
        params.add(firstDay);
        params.add(lastDay);
        if (warehouseId != null) {
            params.add(warehouseId);
        }
        return queryFlat(sql, params);
    }
    
    public List<Object[]> getExportExcelData(Integer warehouseId, int month, int year) {
        String firstDay = firstDay(month, year);
        String lastDay = lastDay(month, year);
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
                + " WHERE r.receipt_type = 'EXPORT' AND r.status = 'COMPLETED'"
                + " AND DATE(r.created_at) >= ? AND DATE(r.created_at) <= ?"
                + (warehouseId != null ? " AND r.warehouse_id = ?" : "")
                + " ORDER BY r.created_at DESC";
        List<Object> params = new ArrayList<>();
        params.add(firstDay);
        params.add(lastDay);
        if (warehouseId != null) {
            params.add(warehouseId);
        }
        return queryFlat(sql, params);
    }
    
    public List<Object[]> getPurchaseExcelData(Integer warehouseId, int month, int year) {
        String firstDay = firstDay(month, year);
        String lastDay = lastDay(month, year);
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
        List<Object> params = new ArrayList<>();
        params.add(firstDay);
        params.add(lastDay);
        if (warehouseId != null) {
            params.add(warehouseId);
        }
        return queryFlat(sql, params);
    }
    
    public List<Object[]> getSalesExcelData(int month, int year) {
        String firstDay = firstDay(month, year);
        String lastDay = lastDay(month, year);
        String sql = "SELECT so.order_code, DATE_FORMAT(so.created_at, '%d/%m/%Y'),"
                + " c.name, g.model, od.quantity, od.unit_price,"
                + " (od.quantity * od.unit_price), u.name, so.status"
                + " FROM sale_order so"
                + " JOIN user u ON so.created_by = u.id"
                + " LEFT JOIN customer c ON so.customer_id = c.id"
                + " JOIN order_detail od ON od.order_id = so.order_id"
                + " JOIN generator g ON od.generator_id = g.id"
                + " WHERE DATE(so.created_at) >= ? AND DATE(so.created_at) <= ?"
                + " ORDER BY so.created_at DESC";
        List<Object> params = new ArrayList<>();
        params.add(firstDay);
        params.add(lastDay);
        return queryFlat(sql, params);
    }
    
    private List<Object[]> queryFlat(String sql, List<Object> params) {
        List<Object[]> result = new ArrayList<>();
        try {
            connection = getConnection();
            statement = connection.prepareStatement(sql);
            for (int i = 0; i < params.size(); i++) {
                statement.setObject(i + 1, params.get(i));
            }
            resultSet = statement.executeQuery();
            int colCount = resultSet.getMetaData().getColumnCount();
            while (resultSet.next()) {
                Object[] row = new Object[colCount];
                for (int i = 0; i < colCount; i++) {
                    row[i] = resultSet.getObject(i + 1);
                }
                result.add(row);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            closeResources();
        }
        return result;
    }
}
