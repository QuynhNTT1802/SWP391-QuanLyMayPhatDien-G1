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
