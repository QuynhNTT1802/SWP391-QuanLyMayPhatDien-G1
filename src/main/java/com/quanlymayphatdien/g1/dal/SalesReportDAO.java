package com.quanlymayphatdien.g1.dal;

import com.quanlymayphatdien.g1.entity.SaleOrder;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class SalesReportDAO extends BaseReportDAO {

    private String searchClause(String search, List<Object> params) {
        if (search == null || search.trim().isEmpty()) return "";
        params.add("%" + search.trim() + "%");
        params.add("%" + search.trim() + "%");
        params.add("%" + search.trim() + "%");
        return " AND (so.order_code LIKE ? OR c.name LIKE ? OR g.model LIKE ?)";
    }

    public int countSalesReport(int month, int year, String search) {
        List<Object> params = new ArrayList<>();
        params.add(firstDay(month, year));
        params.add(lastDay(month, year));
        String searchWhere = searchClause(search, params);
        return countWithParams(
                "SELECT COUNT(*) FROM sale_order so"
                + " LEFT JOIN customer c ON so.customer_id = c.id"
                + " JOIN order_detail od ON od.order_id = so.order_id"
                + " JOIN generator g ON od.generator_id = g.id"
                + " WHERE DATE(so.created_at) >= ? AND DATE(so.created_at) <= ?"
                + searchWhere,
                params);
    }

    public List<SaleOrder> getSalesReport(int month, int year, int page, int pageSize, String search) {
        return querySaleOrders(month, year, page, pageSize, search);
    }

    public List<SaleOrder> getAllSalesReport(int month, int year) {
        return querySaleOrders(month, year, -1, -1, null);
    }

    public List<Object[]> trendSales(int year) {
        List<Object> p = new ArrayList<>();
        p.add(year);
        return queryFlat(
            "SELECT DATE_FORMAT(so.created_at,'%Y-%m'),COALESCE(SUM(so.total_amount),0)"
            + " FROM sale_order so WHERE YEAR(so.created_at)=?"
            + " GROUP BY 1 ORDER BY 1", p);
    }

    public List<Object[]> getSalesExcelData(int month, int year) {
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
        return queryFlat(sql, params(month, year, null));
    }

    public Map<String, Object> getSalesSummary(int month, int year) {
        Map<String, Object> summary = new HashMap<>();
        List<Object> params = new ArrayList<>();
        params.add(firstDay(month, year));
        params.add(lastDay(month, year));

        String totalSql = "SELECT COALESCE(SUM(so.total_amount), 0) AS total_amount"
                + " FROM sale_order so"
                + " WHERE DATE(so.created_at) >= ? AND DATE(so.created_at) <= ?";
        try {
            connection = getConnection();
            statement = connection.prepareStatement(totalSql);
            statement.setString(1, firstDay(month, year));
            statement.setString(2, lastDay(month, year));
            resultSet = statement.executeQuery();
            if (resultSet.next()) {
                summary.put("totalAmount", resultSet.getDouble("total_amount"));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            closeResources();
        }

        String topSql = "SELECT g.model, SUM(od.quantity) AS total_qty"
                + " FROM sale_order so"
                + " JOIN order_detail od ON od.order_id = so.order_id"
                + " JOIN generator g ON od.generator_id = g.id"
                + " WHERE DATE(so.created_at) >= ? AND DATE(so.created_at) <= ?"
                + " GROUP BY g.id, g.model ORDER BY total_qty DESC LIMIT 1";
        try {
            connection = getConnection();
            statement = connection.prepareStatement(topSql);
            statement.setString(1, firstDay(month, year));
            statement.setString(2, lastDay(month, year));
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

    private List<SaleOrder> querySaleOrders(int month, int year, int page, int pageSize, String search) {
        List<SaleOrder> list = new ArrayList<>();
        List<Object> params = new ArrayList<>();
        params.add(firstDay(month, year));
        params.add(lastDay(month, year));
        String searchWhere = searchClause(search, params);
        String sql = "SELECT so.*, c.name AS customer_name, u.name AS created_by_name,"
                + " GROUP_CONCAT(CONCAT(g.model, '|', od.quantity, '|', od.unit_price) SEPARATOR '; ') AS detail_info"
                + " FROM sale_order so"
                + " LEFT JOIN customer c ON so.customer_id = c.id"
                + " LEFT JOIN user u ON so.created_by = u.id"
                + " LEFT JOIN order_detail od ON od.order_id = so.order_id"
                + " LEFT JOIN generator g ON od.generator_id = g.id"
                + " WHERE DATE(so.created_at) >= ? AND DATE(so.created_at) <= ?"
                + searchWhere
                + " GROUP BY so.order_id"
                + " ORDER BY so.created_at DESC"
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
}
