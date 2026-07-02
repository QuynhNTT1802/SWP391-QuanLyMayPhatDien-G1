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
}
