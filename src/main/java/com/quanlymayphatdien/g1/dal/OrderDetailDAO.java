/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package com.quanlymayphatdien.g1.dal;

import com.quanlymayphatdien.g1.entity.OrderDetail;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

/**
 *
 * @author Phuong Linh
 */
public class OrderDetailDAO extends DBContext implements I_DAO<OrderDetail> {

    @Override
    public List<OrderDetail> findAll() {
        List<OrderDetail> list = new ArrayList<>();
        String sql = "SELECT * FROM order_detail";
        try {
            connection = getConnection();
            statement = connection.prepareStatement(sql);
            resultSet = statement.executeQuery();
            while (resultSet.next()) {
                list.add(getFromResultSet(resultSet));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            closeResources();
        }
        return list;
    }

    public List<OrderDetail> findByOrderId(int orderId) {
        List<OrderDetail> list = new ArrayList<>();
        String sql = "SELECT * FROM order_detail WHERE order_id = ?";
        try {
            connection = getConnection();
            statement = connection.prepareStatement(sql);
            statement.setInt(1, orderId);
            resultSet = statement.executeQuery();
            while (resultSet.next()) {
                list.add(getFromResultSet(resultSet));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            closeResources();
        }
        return list;
    }
    
    public List<OrderDetail> findGeneratorById(int orderId) {
        List<OrderDetail> list = new ArrayList<>();
         String sql = "SELECT od.*, g.model, g.power_rating, g.frequency, g.weight, g.status FROM order_detail od "
               + "JOIN generator g ON od.generator_id = g.id "
               + "WHERE od.order_id = ?";
        try {
            connection = getConnection();
            statement = connection.prepareStatement(sql);
            statement.setInt(1, orderId);
            resultSet = statement.executeQuery();
            while (resultSet.next()) {
                OrderDetail d = getFromResultSet(resultSet);
                d.setGeneratorModel(resultSet.getString("model"));
                d.setGeneratorPower(resultSet.getString("power_rating"));
                d.setGeneratorFreq(resultSet.getString("frequency"));
                d.setGeneratorWeight(resultSet.getString("weight"));
                d.setGeneratorStatus(resultSet.getString("status"));
                list.add(d);
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            closeResources();
        }
        return list;
    }

    @Override
    public boolean update(OrderDetail t) {
        throw new UnsupportedOperationException("Not supported yet."); // Generated from nbfs://nbhost/SystemFileSystem/Templates/Classes/Code/GeneratedMethodBody
    }

    @Override
    public boolean delete(OrderDetail t) {
        String sql = "DELETE FROM order_detail WHERE order_id = ?";
        try {
            connection = getConnection();
            statement = connection.prepareStatement(sql);
            statement.setInt(1, t.getOrderId());
            statement.executeUpdate();
            return true;
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            closeResources();
        }
        return false;
    }

    @Override
    public int insert(OrderDetail d) {
        String sql = "INSERT INTO order_detail (order_id, generator_id, quantity, unit_price, note) "
                + "VALUES (?, ?, ?, ?, ?)";
        try {
            connection = getConnection();
            statement = connection.prepareStatement(sql, java.sql.Statement.RETURN_GENERATED_KEYS);
            statement.setInt(1, d.getOrderId());
            statement.setInt(2, d.getGeneratorId());
            statement.setInt(3, d.getQuantity());
            statement.setDouble(4, d.getUnitPrice());
            statement.setString(5, d.getNote());
            statement.executeUpdate();
            resultSet = statement.getGeneratedKeys();
            if (resultSet.next()) {
                return resultSet.getInt(1);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            closeResources();
        }
        return -1;
    }

    public boolean insertBatch(List<OrderDetail> list) {
        String sql = "INSERT INTO order_detail (order_id, generator_id, quantity, unit_price, note) "
                + "VALUES (?, ?, ?, ?, ?)";
        try (Connection conn = getConnection()) {
            conn.setAutoCommit(false); 
            try (PreparedStatement ps = conn.prepareStatement(sql)) {
                for (OrderDetail d : list) {
                    ps.setInt(1, d.getOrderId());
                    ps.setInt(2, d.getGeneratorId());
                    ps.setInt(3, d.getQuantity());
                    ps.setDouble(4, d.getUnitPrice());
                    ps.setString(5, d.getNote());
                    ps.addBatch(); 
                }
                ps.executeBatch();
                conn.commit();     
                return true;
            } catch (SQLException e) {
                conn.rollback(); 
                e.printStackTrace();
                return false;
            } finally {
                conn.setAutoCommit(true);
            }
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    @Override
    public OrderDetail getFromResultSet(ResultSet resultSet) throws SQLException {
        OrderDetail d = new OrderDetail();
        d.setOrderDetailId(resultSet.getInt("order_detail_id"));
        d.setOrderId(resultSet.getInt("order_id"));
        d.setGeneratorId(resultSet.getInt("generator_id"));
        d.setQuantity(resultSet.getInt("quantity"));
        d.setUnitPrice(resultSet.getDouble("unit_price"));
        d.setNote(resultSet.getString("note"));
        return d;
    }
    
    public boolean deleteByOrderId(int orderId) {
        String sql = "DELETE FROM order_detail WHERE order_id = ?";
        try {
            connection = getConnection();
            statement = connection.prepareStatement(sql);
            statement.setInt(1, orderId);
            statement.executeUpdate();
            return true;
        } catch (Exception e) {
            System.out.println(e.getMessage());
        } finally {
            closeResources();
        }
        return false;
    }
}