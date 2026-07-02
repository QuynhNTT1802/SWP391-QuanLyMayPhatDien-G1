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
}
