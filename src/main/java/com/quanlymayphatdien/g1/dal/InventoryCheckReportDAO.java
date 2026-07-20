package com.quanlymayphatdien.g1.dal;

import com.quanlymayphatdien.g1.entity.InventoryCheckReportItem;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class InventoryCheckReportDAO extends BaseReportDAO {

    public int countInventoryCheckReport(Integer warehouseId, int month, int year) {
        return countWithParams(
                "SELECT COUNT(*) FROM inventory_check ic"
                + " JOIN inventory_check_detail icd ON icd.check_id = ic.id"
                + " WHERE DATE(ic.created_at) >= ? AND DATE(ic.created_at) <= ?"
                + (warehouseId != null ? " AND ic.warehouse_id = ?" : ""),
                params(month, year, warehouseId));
    }

    public List<InventoryCheckReportItem> getInventoryCheckReport(Integer warehouseId, int month, int year, int page, int pageSize) {
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
        return queryInventoryCheckReport(sql, month, year, warehouseId, page, pageSize);
    }

    public List<InventoryCheckReportItem> getAllInventoryCheckReport(Integer warehouseId, int month, int year) {
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
        return queryInventoryCheckReport(sql, month, year, warehouseId, -1, -1);
    }

    private List<InventoryCheckReportItem> queryInventoryCheckReport(String sql, int month, int year,
            Integer warehouseId, int page, int pageSize) {
        List<InventoryCheckReportItem> list = new ArrayList<>();
        List<Object> params = new ArrayList<>();
        params.add(firstDay(month, year));
        params.add(lastDay(month, year));
        if (warehouseId != null) params.add(warehouseId);
        if (page > 0 && pageSize > 0) {
            params.add(pageSize);
            params.add((page - 1) * pageSize);
        }
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
}
