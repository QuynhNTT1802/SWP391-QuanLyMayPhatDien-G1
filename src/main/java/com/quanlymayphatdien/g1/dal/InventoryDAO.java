/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package com.quanlymayphatdien.g1.dal;

import com.quanlymayphatdien.g1.entity.Inventory;
import java.sql.*;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

/**
 *
 * @author FPTShop
 */
public class InventoryDAO extends DBContext implements I_DAO<Inventory> {

    public List<Inventory> findByWarehouseId(int warehouseId) {
        List<Inventory> list = new ArrayList<>();
        String sql = "SELECT i.*, g.model AS generator_model "
                + "FROM inventory i "
                + "JOIN generator g ON i.generator_id = g.id "
                + "WHERE i.warehouse_id = ?";
        try {
            connection = getConnection();
            statement = connection.prepareStatement(sql);
            statement.setInt(1, warehouseId);
            resultSet = statement.executeQuery();
            while (resultSet.next()) {
                list.add(getFromResultSet(resultSet));
            }
        } catch (SQLException e) {
            System.out.println(e.getMessage());
        }
        return list;
    }

    public List<Inventory> findWithFilters(Integer warehouseId, String search,
            boolean outOfStock, Integer minYears, int page, int pageSize) {
        List<Inventory> list = new ArrayList<>();
        StringBuilder sql = new StringBuilder(
                "SELECT i.*, g.model AS generator_model, "
                + "w.name AS warehouse_name, "
                + "(SELECT c.name FROM generator_category gc "
                + "  JOIN category c ON gc.category_id = c.id "
                + "  WHERE gc.generator_id = g.id AND c.type = 'brand' LIMIT 1) AS generator_brand, "
                + "sc.first_import_at "
                + "FROM inventory i "
                + "JOIN generator g ON i.generator_id = g.id "
                + "JOIN warehouse w ON i.warehouse_id = w.warehouse_id "
                + "LEFT JOIN (SELECT warehouse_id, generator_id, MIN(created_at) AS first_import_at "
                + "             FROM stock_card WHERE transaction_type = 'IMPORT' "
                + "             GROUP BY warehouse_id, generator_id) sc "
                + "  ON sc.warehouse_id = i.warehouse_id AND sc.generator_id = i.generator_id "
                + "WHERE w.status <> 'locked' ");
        List<Object> params = new ArrayList<>();
        if (warehouseId != null) {
            sql.append("AND i.warehouse_id = ? ");
            params.add(warehouseId);
        }
        if (search != null && !search.trim().isEmpty()) {
            sql.append("AND (g.model LIKE ? OR EXISTS ("
                    + "  SELECT 1 FROM generator_category gc "
                    + "  JOIN category c ON gc.category_id = c.id "
                    + "  WHERE gc.generator_id = g.id AND c.type = 'brand' AND c.name LIKE ?"
                    + ")) ");
            String like = "%" + search.trim() + "%";
            params.add(like);
            params.add(like);
        }
        if (outOfStock) {
            sql.append("AND i.quantity = 0 ");
        }
        if (minYears != null) {
            sql.append("AND sc.first_import_at IS NOT NULL "
                    + "AND sc.first_import_at <= (CURDATE() - INTERVAL ? YEAR) ");
            params.add(minYears);
        }
        sql.append("ORDER BY w.name, g.model LIMIT ? OFFSET ?");
        params.add(pageSize);
        params.add((page - 1) * pageSize);
        try {
            connection = getConnection();
            statement = connection.prepareStatement(sql.toString());
            for (int i = 0; i < params.size(); i++) {
                statement.setObject(i + 1, params.get(i));
            }
            resultSet = statement.executeQuery();
            while (resultSet.next()) {
                Inventory inv = getFromResultSet(resultSet);
                try { inv.setWarehouseName(resultSet.getString("warehouse_name")); } catch (SQLException ignored) {}
                try {
                    Timestamp ts = resultSet.getTimestamp("first_import_at");
                    if (ts != null) inv.setFirstImportAt(ts.toLocalDateTime());
                } catch (SQLException ignored) {}
                list.add(inv);
            }
        } catch (SQLException e) {
            System.out.println(e.getMessage());
        }
        return list;
    }

    public int countWithFilters(Integer warehouseId, String search,
            boolean outOfStock, Integer minYears) {
        StringBuilder sql = new StringBuilder(
                "SELECT COUNT(*) FROM inventory i "
                + "JOIN generator g ON i.generator_id = g.id "
                + "JOIN warehouse w ON i.warehouse_id = w.warehouse_id "
                + "LEFT JOIN (SELECT warehouse_id, generator_id, MIN(created_at) AS first_import_at "
                + "             FROM stock_card WHERE transaction_type = 'IMPORT' "
                + "             GROUP BY warehouse_id, generator_id) sc "
                + "  ON sc.warehouse_id = i.warehouse_id AND sc.generator_id = i.generator_id "
                + "WHERE w.status <> 'locked' ");
        List<Object> params = new ArrayList<>();
        if (warehouseId != null) {
            sql.append("AND i.warehouse_id = ? ");
            params.add(warehouseId);
        }
        if (search != null && !search.trim().isEmpty()) {
            sql.append("AND (g.model LIKE ? OR EXISTS ("
                    + "  SELECT 1 FROM generator_category gc "
                    + "  JOIN category c ON gc.category_id = c.id "
                    + "  WHERE gc.generator_id = g.id AND c.type = 'brand' AND c.name LIKE ?"
                    + ")) ");
            String like = "%" + search.trim() + "%";
            params.add(like);
            params.add(like);
        }
        if (outOfStock) {
            sql.append("AND i.quantity = 0 ");
        }
        if (minYears != null) {
            sql.append("AND sc.first_import_at IS NOT NULL "
                    + "AND sc.first_import_at <= (CURDATE() - INTERVAL ? YEAR) ");
            params.add(minYears);
        }
        try {
            connection = getConnection();
            statement = connection.prepareStatement(sql.toString());
            for (int i = 0; i < params.size(); i++) {
                statement.setObject(i + 1, params.get(i));
            }
            resultSet = statement.executeQuery();
            if (resultSet.next()) {
                return resultSet.getInt(1);
            }
        } catch (SQLException e) {
            System.out.println(e.getMessage());
        }
        return 0;
    }

    public int countByWarehouseId(int warehouseId) {
        String sql = "SELECT COUNT(*) FROM inventory WHERE warehouse_id = ?";
        try {
            connection = getConnection();
            statement = connection.prepareStatement(sql);
            statement.setInt(1, warehouseId);
            resultSet = statement.executeQuery();
            if (resultSet.next()) {
                return resultSet.getInt(1);
            }
        } catch (SQLException e) {
            System.out.println(e.getMessage());
        }
        return 0;
    }

    public Inventory findByWarehouseAndGenerator(int warehouseId, int generatorId) {
        String sql = "SELECT * FROM inventory WHERE warehouse_id = ? AND generator_id = ?";
        try {
            connection = getConnection();
            statement = connection.prepareStatement(sql);
            statement.setInt(1, warehouseId);
            statement.setInt(2, generatorId);
            resultSet = statement.executeQuery();
            if (resultSet.next()) {
                return getFromResultSet(resultSet);
            }
        } catch (SQLException e) {
            System.out.println(e.getMessage());
        }
        return null;
    }

    public boolean updateQuantity(Connection conn, int warehouseId, int generatorId, int quantityChange)
            throws SQLException {
        String sql = "INSERT INTO inventory (warehouse_id, generator_id, quantity) "
                + "VALUES (?, ?, ?) "
                + "ON DUPLICATE KEY UPDATE quantity = quantity + ?, updated_at = CURRENT_TIMESTAMP";
        PreparedStatement ps = conn.prepareStatement(sql);
        ps.setInt(1, warehouseId);
        ps.setInt(2, generatorId);
        ps.setInt(3, quantityChange);
        ps.setInt(4, quantityChange);
        return ps.executeUpdate() > 0;
    }

    @Override
    public List<Inventory> findAll() {
        throw new UnsupportedOperationException("Not supported yet."); // Generated from nbfs://nbhost/SystemFileSystem/Templates/Classes/Code/GeneratedMethodBody
    }

    @Override
    public boolean update(Inventory t) {
        throw new UnsupportedOperationException("Not supported yet."); // Generated from nbfs://nbhost/SystemFileSystem/Templates/Classes/Code/GeneratedMethodBody
    }

    @Override
    public boolean delete(Inventory t) {
        throw new UnsupportedOperationException("Not supported yet."); // Generated from nbfs://nbhost/SystemFileSystem/Templates/Classes/Code/GeneratedMethodBody
    }

    @Override
    public int insert(Inventory t) {
        throw new UnsupportedOperationException("Not supported yet."); // Generated from nbfs://nbhost/SystemFileSystem/Templates/Classes/Code/GeneratedMethodBody
    }

    @Override
    public Inventory getFromResultSet(ResultSet rs) throws SQLException {
        Inventory inv = new Inventory();
        inv.setInventoryId(rs.getInt("inventory_id"));
        inv.setWarehouseId(rs.getInt("warehouse_id"));
        inv.setGeneratorId(rs.getInt("generator_id"));
        inv.setQuantity(rs.getInt("quantity"));
        // joined fields
        try {
            inv.setGeneratorModel(rs.getString("generator_model"));
        } catch (SQLException ignored) {
        }
        try {
            inv.setGeneratorBrand(rs.getString("generator_brand"));
        } catch (SQLException ignored) {
        }
        return inv;
    }

}
