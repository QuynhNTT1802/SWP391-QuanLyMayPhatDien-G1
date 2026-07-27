package com.quanlymayphatdien.g1.dal;

import com.quanlymayphatdien.g1.entity.InventoryReportItem;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;

public class InventoryReportDAO extends BaseReportDAO {

    private final StockCardDAO stockCardDAO = new StockCardDAO();

    private String searchModelClause(String search, List<Object> params) {
        if (search == null || search.trim().isEmpty()) return "";
        params.add("%" + search.trim() + "%");
        return " AND g.model LIKE ?";
    }

    public int countInventoryReport(Integer warehouseId, int month, int year, String search) {
        List<Object> params = new ArrayList<>();
        params.add(lastDay(month, year));
        if (warehouseId != null) {
            params.add(warehouseId);
            params.add(warehouseId);
        }
        String searchWhere = searchModelClause(search, params);
        String sql = "SELECT COUNT(DISTINCT t.warehouse_id, t.generator_id) FROM ("
                + "SELECT DISTINCT warehouse_id, generator_id FROM stock_card"
                + " WHERE DATE(created_at) <= ?"
                + (warehouseId != null ? " AND warehouse_id = ?" : "")
                + " UNION SELECT DISTINCT i.warehouse_id, i.generator_id FROM inventory i"
                + " WHERE i.status = 'IN_STOCK'"
                + (warehouseId != null ? " AND i.warehouse_id = ?" : "")
                + ") t"
                + " JOIN generator g ON t.generator_id = g.id"
                + searchWhere;
        return countWithParams(sql, params);
    }

    public Map<String, Object> getInventorySummary(Integer warehouseId, int month, int year) {
        Map<String, Object> summary = new java.util.HashMap<>();
        String firstDay = firstDay(month, year);
        String nextDay = nextDay(month, year);
        Map<String, Integer> openMap = stockCardDAO.getBalanceSnapshot(warehouseId, firstDay);
        Map<String, Integer> closeMap = stockCardDAO.getBalanceSnapshot(warehouseId, nextDay);
        int totalOpen = openMap.values().stream().mapToInt(Integer::intValue).sum();
        int totalClose = closeMap.values().stream().mapToInt(Integer::intValue).sum();
        summary.put("totalOpen", totalOpen);
        summary.put("totalSerials", totalClose);
        summary.put("totalModels", (int) closeMap.keySet().stream()
                .map(k -> k.split("_")[1])
                .distinct()
                .count());

        int totalImport = 0, totalExport = 0;
        Map<String, int[]> ieMap = getImportExportMap(warehouseId, month, year);
        for (int[] ie : ieMap.values()) {
            totalImport += ie[0];
            totalExport += ie[1];
        }
        summary.put("totalImport", totalImport);
        summary.put("totalExport", totalExport);
        return summary;
    }

    private Map<String, int[]> getImportExportMap(Integer warehouseId, int month, int year) {
        Map<String, int[]> ieMap = new java.util.HashMap<>();
        List<Object> params = new ArrayList<>();
        params.add(firstDay(month, year));
        params.add(nextDay(month, year));
        String sql = "SELECT warehouse_id, generator_id, transaction_type, SUM(quantity_change) AS total_qty"
                + " FROM stock_card"
                + " WHERE created_at >= ? AND created_at < ?"
                + (warehouseId != null ? " AND warehouse_id = ?" : "")
                + " GROUP BY warehouse_id, generator_id, transaction_type";
        if (warehouseId != null) params.add(warehouseId);
        try {
            connection = getConnection();
            statement = connection.prepareStatement(sql);
            for (int i = 0; i < params.size(); i++)
                statement.setObject(i + 1, params.get(i));
            resultSet = statement.executeQuery();
            while (resultSet.next()) {
                String key = resultSet.getInt("warehouse_id") + "_" + resultSet.getInt("generator_id");
                int qty = resultSet.getInt("total_qty");
                String type = resultSet.getString("transaction_type");
                int[] ie = ieMap.getOrDefault(key, new int[]{0, 0});
                if ("IMPORT".equals(type) || "TRANSFER_IN".equals(type)) ie[0] += qty;
                else if ("EXPORT".equals(type) || "TRANSFER_OUT".equals(type)) ie[1] += Math.abs(qty);
                ieMap.put(key, ie);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            closeResources();
        }
        return ieMap;
    }

    public List<Object[]> trendInventory(Integer warehouseId, int year) {
        List<Object> p = new ArrayList<>();
        p.add(year);
        if (warehouseId != null) p.add(warehouseId);
        return queryFlat(
            "SELECT DATE_FORMAT(created_at,'%Y-%m'),"
            + " SUM(CASE WHEN transaction_type IN ('IMPORT','TRANSFER_IN') THEN quantity_change ELSE 0 END),"
            + " SUM(CASE WHEN transaction_type IN ('EXPORT','TRANSFER_OUT') THEN -quantity_change ELSE 0 END)"
            + " FROM stock_card WHERE YEAR(created_at)=?"
            + (warehouseId != null ? " AND warehouse_id=?" : "")
            + " GROUP BY 1 ORDER BY 1", p);
    }

    public List<InventoryReportItem> getInventoryReport(Integer warehouseId, int month, int year, int page, int pageSize, String search) {
        return queryInventoryReport(warehouseId, month, year, page, pageSize, search);
    }

    public List<InventoryReportItem> getAllInventoryReport(Integer warehouseId, int month, int year) {
        return queryInventoryReport(warehouseId, month, year, -1, -1, null);
    }

    private List<InventoryReportItem> queryInventoryReport(Integer warehouseId, int month, int year, int page, int pageSize, String search) {
        String firstDay = firstDay(month, year);
        String nextDay = nextDay(month, year);

        Map<String, Integer> openMap = stockCardDAO.getBalanceSnapshot(warehouseId, firstDay);
        Map<String, Integer> closeMap = stockCardDAO.getBalanceSnapshot(warehouseId, nextDay);
        Map<String, int[]> ieMap = getImportExportMap(warehouseId, month, year);

        List<Object> params = new ArrayList<>();
        params.add(nextDay);
        if (warehouseId != null) {
            params.add(warehouseId);
            params.add(warehouseId);
        }
        String searchWhere = searchModelClause(search, params);
        String baseSql = baseGeneratorSql(warehouseId) + searchWhere;
        List<InventoryReportItem> list = new ArrayList<>();
        baseSql += (page < 0 ? " ORDER BY w.name, g.model" : "")
                + (page > 0 && pageSize > 0 ? " LIMIT ? OFFSET ?" : "");
        if (page > 0 && pageSize > 0) {
            params.add(pageSize);
            params.add((page - 1) * pageSize);
        }
        try {
            connection = getConnection();
            statement = connection.prepareStatement(baseSql);
            for (int i = 0; i < params.size(); i++) {
                statement.setObject(i + 1, params.get(i));
            }
            resultSet = statement.executeQuery();
            while (resultSet.next()) {
                String key = resultSet.getInt("warehouse_id") + "_" + resultSet.getInt("generator_id");
                InventoryReportItem item = new InventoryReportItem();
                item.setWarehouseId(resultSet.getInt("warehouse_id"));
                item.setWarehouseName(resultSet.getString("warehouse_name"));
                item.setGeneratorId(resultSet.getInt("generator_id"));
                item.setModel(resultSet.getString("model"));
                item.setBrand(resultSet.getString("brand"));
                item.setOpenQuantity(openMap.getOrDefault(key, 0));
                int[] ie = ieMap.getOrDefault(key, new int[]{0, 0});
                item.setImportQuantity(ie[0]);
                item.setExportQuantity(ie[1]);
                item.setCloseQuantity(closeMap.getOrDefault(key, 0));
                list.add(item);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            closeResources();
        }
        return list;
    }

    private String baseGeneratorSql(Integer warehouseId) {
        return "SELECT DISTINCT t.warehouse_id, t.generator_id, g.model, COALESCE(br.name, '') AS brand, w.name AS warehouse_name"
                + " FROM ("
                + "  SELECT warehouse_id, generator_id FROM stock_card WHERE created_at < ?"
                + (warehouseId != null ? " AND warehouse_id = ?" : "")
                + "  UNION"
                + "  SELECT warehouse_id, generator_id FROM inventory WHERE status = 'IN_STOCK'"
                + (warehouseId != null ? " AND warehouse_id = ?" : "")
                + " ) t"
                + " JOIN generator g ON t.generator_id = g.id"
                + " JOIN warehouse w ON t.warehouse_id = w.warehouse_id"
                + " LEFT JOIN generator_category gc_br ON gc_br.generator_id = g.id"
                + "  AND gc_br.category_id IN (SELECT id FROM category WHERE type = 'brand')"
                + " LEFT JOIN category br ON gc_br.category_id = br.id";
    }
}
