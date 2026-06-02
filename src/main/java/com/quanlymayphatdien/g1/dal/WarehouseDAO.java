/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package com.quanlymayphatdien.g1.dal;

import com.quanlymayphatdien.g1.entity.Warehouse;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.List;

/**
 *
 * @author FPTShop
 */
public class WarehouseDAO extends DBContext implements I_DAO<Warehouse> {

    @Override
    public List<Warehouse> findAll() {
        List<Warehouse> list = new ArrayList<>();
        String sql = "SELECT w.*, COALESCE(SUM(i.quantity), 0) AS total_inventory "
                + "FROM warehouse w "
                + "LEFT JOIN inventory i ON w.warehouse_id = i.warehouse_id "
                + "WHERE w.status = 'active' "
                + "GROUP BY w.warehouse_id ";
        try (Connection c = getConnection(); PreparedStatement ps = c.prepareStatement(sql); ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                list.add(getFromResultSet(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    public Warehouse findById(int id) {
        String sql = "SELECT w.*, COALESCE(SUM(i.quantity), 0) AS total_inventory "
                + "FROM warehouse w "
                + "LEFT JOIN inventory i ON w.warehouse_id = i.warehouse_id "
                + "Where w.warehouse_id = ?"
                + "GROUP BY w.warehouse_id ";
        try (Connection c = getConnection(); PreparedStatement ps = c.prepareStatement(sql); ResultSet rs = ps.executeQuery()) {
            ps.setInt(1, id);
            while (rs.next()) {
                return getFromResultSet(rs);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    @Override
    public boolean update(Warehouse w) {
        List<Warehouse> list = new ArrayList<>();
        String sql = "UPDATE `warehousedb`.`warehouse`\n"
                + "SET\n"
                + "name = ?,\n"
                + "address = ?,\n"
                + "description = ?,\n"
                + "status = ?,\n"
                + "WHERE warehouse_id = ?;";
        try (Connection c = getConnection(); PreparedStatement ps = c.prepareStatement(sql); ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                ps.setString(1, w.getName());
                ps.setString(2, w.getAddress());
                ps.setString(3, w.getDescription());
                ps.setString(4, w.getStatus());
                return ps.executeUpdate() > 0;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    @Override
    public boolean delete(Warehouse t) {
        throw new UnsupportedOperationException("Not supported yet."); // Generated from nbfs://nbhost/SystemFileSystem/Templates/Classes/Code/GeneratedMethodBody
    }

    @Override
    public int insert(Warehouse t) {
        throw new UnsupportedOperationException("Not supported yet."); // Generated from nbfs://nbhost/SystemFileSystem/Templates/Classes/Code/GeneratedMethodBody
    }

    @Override
    public Warehouse getFromResultSet(ResultSet rs) throws SQLException {
        Warehouse w = new Warehouse();
        w.setWarehouseId(rs.getInt("warehouse_id"));
        w.setName(rs.getString("name"));
        w.setAddress(rs.getString("address"));
        w.setDescription(rs.getString("description"));
        w.setStatus(rs.getString("status"));

        Timestamp ca = rs.getTimestamp("created_at");
        if (ca != null) {
            w.setCreatedAt(ca.toLocalDateTime());
        }

        Timestamp ua = rs.getTimestamp("created_at");
        if (ua != null) {
            w.setCreatedAt(ua.toLocalDateTime());
        }

        try {
            w.setTotalInventory(rs.getInt("total_inventory"));
        } catch (SQLException ignored) {
        }
        return w;
    }

}
