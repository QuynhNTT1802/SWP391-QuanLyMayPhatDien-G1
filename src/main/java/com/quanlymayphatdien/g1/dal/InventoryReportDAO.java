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
        String nextDay = nextDay(month, year);
        Map<String, Integer> closeMap = stockCardDAO.getBalanceSnapshot(warehouseId, nextDay);
        int totalSerials = closeMap.values().stream().mapToInt(Integer::intValue).sum();
        summary.put("totalSerials", totalSerials);
        summary.put("totalModels", (int) closeMap.keySet().stream()
                .map(k -> k.split("_")[1])
                .distinct()
                .count());
        return summary;
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
