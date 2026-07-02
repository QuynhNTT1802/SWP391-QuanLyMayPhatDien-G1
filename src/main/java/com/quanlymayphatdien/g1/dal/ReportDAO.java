/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package com.quanlymayphatdien.g1.dal;

import com.quanlymayphatdien.g1.entity.InventoryReportItem;
import java.time.LocalDate;
import java.util.ArrayList;
import java.util.List;

/**
 *
 * @author Aadmin
 */
public class ReportDAO extends DBContext{
    public int countInventoryReport(Integer warehouseId, int month, int year) {
        String firstDay = String.format("%04d-%02d-01", year, month);
        String lastDay = LocalDate.of(year, month, 1).plusMonths(1).minusDays(1).toString();
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
                + " COALESCE(imp_qty, 0) AS import_qty,"
                + " COALESCE(exp_qty, 0) AS export_qty,"
                + " COALESCE(open_qty, 0) + COALESCE(imp_qty, 0) - COALESCE(exp_qty, 0) AS close_qty"
                + " FROM ("
                + "  SELECT DISTINCT warehouse_id, generator_id FROM stock_card"
                + "  WHERE DATE(created_at) <= ?"
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
                + "    AND DATE(sc2.created_at) < ?"
                + "   GROUP BY sc2.warehouse_id, sc2.generator_id"
                + "  )"
                + " ) open_t ON open_t.warehouse_id = t.warehouse_id AND open_t.generator_id = t.generator_id"
                + " LEFT JOIN ("
                + "  SELECT warehouse_id, generator_id, SUM(quantity_change) AS imp_qty"
                + "  FROM stock_card"
                + "  WHERE transaction_type = 'IMPORT'"
                + "   AND DATE(created_at) >= ? AND DATE(created_at) <= ?"
                + "  GROUP BY warehouse_id, generator_id"
                + " ) imp_t ON imp_t.warehouse_id = t.warehouse_id AND imp_t.generator_id = t.generator_id"
                + " LEFT JOIN ("
                + "  SELECT warehouse_id, generator_id, SUM(quantity_change) AS exp_qty"
                + "  FROM stock_card"
                + "  WHERE transaction_type = 'EXPORT'"
                + "   AND DATE(created_at) >= ? AND DATE(created_at) <= ?"
                + "  GROUP BY warehouse_id, generator_id"
                + " ) exp_t ON exp_t.warehouse_id = t.warehouse_id AND exp_t.generator_id = t.generator_id";
    }
    
    public int countImportReport(Integer warehouseId, int month, int year) {
        return countReceiptByType("IMPORT", warehouseId, month, year);
    }
    
    public int countExportReport(Integer warehouseId, int month, int year) {
        return countReceiptByType("EXPORT", warehouseId, month, year);
    }
    
    public List<Receipt> getImportReport(Integer warehouseId, int month, int year, int page, int pageSize) {
        return queryReceipts(buildReceiptSql("IMPORT", warehouseId, false), warehouseId, month, year, page, pageSize);
    }
    
    public List<Receipt> getAllImportReport(Integer warehouseId, int month, int year) {
        return queryReceipts(buildReceiptSql("IMPORT", warehouseId, true), warehouseId, month, year, -1, -1);
    }
    
    public List<Receipt> getExportReport(Integer warehouseId, int month, int year, int page, int pageSize) {
        return queryReceipts(buildReceiptSql("EXPORT", warehouseId, false), warehouseId, month, year, page, pageSize);
    }
    
    public List<Receipt> getAllExportReport(Integer warehouseId, int month, int year) {
        return queryReceipts(buildReceiptSql("EXPORT", warehouseId, true), warehouseId, month, year, -1, -1);
    }
    
    private int countReceiptByType(String type, Integer warehouseId, int month, int year) {
        String firstDay = String.format("%04d-%02d-01", year, month);
        String lastDay = LocalDate.of(year, month, 1).plusMonths(1).minusDays(1).toString();
        String sql = "SELECT COUNT(*) FROM receipt r"
                + " WHERE r.receipt_type = ? AND r.status = 'COMPLETED'"
                + " AND DATE(r.created_at) >= ? AND DATE(r.created_at) <= ?"
                + (warehouseId != null ? " AND r.warehouse_id = ?" : "");
        List<Object> params = new ArrayList<>();
        params.add(type);
        params.add(firstDay);
        params.add(lastDay);
        if (warehouseId != null) {
            params.add(warehouseId);
        }
        return countWithParams(sql, params);
    }
    
    private String buildReceiptSql(String type, Integer warehouseId, boolean allRows) {
        String select = "SELECT r.*, w.name AS warehouse_name, u.name AS created_by_name,";
        String from = " FROM receipt r"
                + " LEFT JOIN warehouse w ON r.warehouse_id = w.warehouse_id"
                + " LEFT JOIN user u ON r.created_by = u.id";
        String groupBy = "";
        if ("IMPORT".equals(type)) {
            select += " po.po_code AS purchase_order_code,"
                    + " (SELECT GROUP_CONCAT(CONCAT(g.model, '|', i2.serial_number) SEPARATOR '; ')"
                    + "  FROM receipt_detail rd"
                    + "  JOIN inventory i2 ON rd.inventory_id = i2.inventory_id"
                    + "  JOIN generator g ON i2.generator_id = g.id"
                    + "  WHERE rd.receipt_id = r.receipt_id) AS detail_info";
            from += " LEFT JOIN purchase_order po ON r.purchase_order_id = po.po_id";
        } else {
            select += " so.order_code, c.name AS customer_name,"
                    + " (SELECT GROUP_CONCAT(CONCAT(g.model, '|', i2.serial_number) SEPARATOR '; ')"
                    + "  FROM receipt_detail rd"
                    + "  JOIN inventory i2 ON rd.inventory_id = i2.inventory_id"
                    + "  JOIN generator g ON i2.generator_id = g.id"
                    + "  WHERE rd.receipt_id = r.receipt_id) AS detail_info";
            from += " LEFT JOIN sale_order so ON r.order_id = so.order_id"
                    + " LEFT JOIN customer c ON so.customer_id = c.id";
        }
        String where = " WHERE r.receipt_type = '" + type + "' AND r.status = 'COMPLETED'"
                + " AND DATE(r.created_at) >= ? AND DATE(r.created_at) <= ?"
                + (warehouseId != null ? " AND r.warehouse_id = ?" : "");
        String order = " ORDER BY r.created_at DESC";
        return select + from + where + order;
    }
    
    public int countInventoryCheckReport(Integer warehouseId, int month, int year) {
        String firstDay = String.format("%04d-%02d-01", year, month);
        String lastDay = LocalDate.of(year, month, 1).plusMonths(1).minusDays(1).toString();
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
        String firstDay = String.format("%04d-%02d-01", year, month);
        String lastDay = LocalDate.of(year, month, 1).plusMonths(1).minusDays(1).toString();
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
        String firstDay = String.format("%04d-%02d-01", year, month);
        String lastDay = LocalDate.of(year, month, 1).plusMonths(1).minusDays(1).toString();
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
}
