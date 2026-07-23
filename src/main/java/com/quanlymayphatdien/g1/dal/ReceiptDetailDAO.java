/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package com.quanlymayphatdien.g1.dal;

import com.quanlymayphatdien.g1.entity.ReceiptDetail;
import java.math.BigDecimal;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;

public class ReceiptDetailDAO extends DBContext implements I_DAO<ReceiptDetail> {

    @Override
    public List<ReceiptDetail> findAll() {
        throw new UnsupportedOperationException("Not supported yet.");
    }

    public List<ReceiptDetail> findByReceiptId(int receiptId) {
        List<ReceiptDetail> list = new ArrayList<>();
        String sql = "SELECT rd.*, i.serial_number, i.generator_id, i.condition, "
                   + "       g.model AS generator_model, g.description AS generator_name, "
                   + "       g.power_rating, g.frequency, g.weight, g.status AS generator_status, "
                   + "       (SELECT c.name FROM generator_category gc "
                   + "          JOIN category c ON gc.category_id = c.id "
                   + "          WHERE gc.generator_id = g.id AND c.type = 'brand' LIMIT 1) AS generator_brand "
                   + "FROM receipt_detail rd "
                   + "JOIN inventory i ON rd.inventory_id = i.inventory_id "
                   + "LEFT JOIN generator g ON i.generator_id = g.id "
                   + "WHERE rd.receipt_id = ?";
        try {
            connection = getConnection();
            statement = connection.prepareStatement(sql);
            statement.setInt(1, receiptId);
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

    @Override
    public boolean update(ReceiptDetail t) {
        throw new UnsupportedOperationException("Not supported yet.");
    }

    @Override
    public boolean delete(ReceiptDetail t) {
        throw new UnsupportedOperationException("Not supported yet.");
    }

    @Override
    public int insert(ReceiptDetail rd) {
        String sql = "INSERT INTO receipt_detail (receipt_id, inventory_id, note) "
                   + "VALUES (?, ?, ?)";
        try {
            connection = getConnection();
            statement = connection.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS);
            statement.setInt(1, rd.getReceiptId());
            statement.setInt(2, rd.getInventoryId());
            statement.setString(3, rd.getNote());
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

    public int batchInsert(Connection conn, List<ReceiptDetail> details) throws SQLException {
        String sql = "INSERT INTO receipt_detail (receipt_id, inventory_id, note) "
                   + "VALUES (?, ?, ?)";
        try (PreparedStatement ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            for (ReceiptDetail rd : details) {
                ps.setInt(1, rd.getReceiptId());
                ps.setInt(2, rd.getInventoryId());
                ps.setString(3, rd.getNote());
                ps.addBatch();
            }
            ps.executeBatch();
        }
        return -1;
    }

    public List<Integer> findInventoryIdsByReceiptAndGenerator(int receiptId, int generatorId) {
        List<Integer> list = new ArrayList<>();
        String sql = "SELECT rd.inventory_id FROM receipt_detail rd "
                   + "JOIN inventory i ON rd.inventory_id = i.inventory_id "
                   + "WHERE rd.receipt_id = ? AND i.generator_id = ? "
                   + "ORDER BY rd.receipt_detail_id";
        try {
            connection = getConnection();
            statement = connection.prepareStatement(sql);
            statement.setInt(1, receiptId);
            statement.setInt(2, generatorId);
            resultSet = statement.executeQuery();
            while (resultSet.next()) {
                list.add(resultSet.getInt("inventory_id"));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            closeResources();
        }
        return list;
    }

    public List<Integer> findInventoryIdsByReceiptId(int receiptId) {
        List<Integer> list = new ArrayList<>();
        String sql = "SELECT inventory_id FROM receipt_detail WHERE receipt_id = ?";
        try {
            connection = getConnection();
            statement = connection.prepareStatement(sql);
            statement.setInt(1, receiptId);
            resultSet = statement.executeQuery();
            while (resultSet.next()) {
                list.add(resultSet.getInt("inventory_id"));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            closeResources();
        }
        return list;
    }
    
    public BigDecimal findPurchasePriceByPrice(String serialNumber) throws SQLException {
          String sql = "SELECT rd.unit_price FROM receipt_detail rd "
            + "JOIN receipt r ON rd.receipt_id = r.receipt_id "
            + "WHERE rd.serial_number = ? AND r.receipt_type = 'IMPORT' "
            + "ORDER BY r.created_at DESC LIMIT 1";
          try {
              connection = getConnection();
              statement = connection.prepareStatement(sql);
              statement.setString(1, serialNumber);
              resultSet = statement.executeQuery();
              if (resultSet.next()) {
                  return resultSet.getBigDecimal("unit_price");
              }
          } catch(Exception e) {
              e.printStackTrace();
          } finally {
              closeResources();
          }
          return null;
    }
    
    

    @Override
    public ReceiptDetail getFromResultSet(ResultSet rs) throws SQLException {
        ReceiptDetail rd = new ReceiptDetail();
        rd.setReceiptDetailId(rs.getInt("receipt_detail_id"));
        rd.setReceiptId(rs.getInt("receipt_id"));
        rd.setInventoryId(rs.getInt("inventory_id"));
        try {
            rd.setNote(rs.getString("note"));
        } catch (SQLException ignored) {
        }
        try {
            rd.setSerialNumber(rs.getString("serial_number"));
        } catch (SQLException ignored) {
        }
        try {
            rd.setGeneratorId(rs.getInt("generator_id"));
        } catch (SQLException ignored) {
        }
        try {
            rd.setGeneratorModel(rs.getString("generator_model"));
        } catch (SQLException ignored) {
        }
        try {
            rd.setGeneratorBrand(rs.getString("generator_brand"));
        } catch (SQLException ignored) {
        }
        try {
            rd.setCondition(rs.getString("condition"));
        } catch (SQLException ignored) {
        }
        try {
            rd.setGeneratorPower(rs.getString("power_rating"));
        } catch (SQLException ignored) {
        }
        try {
            rd.setGeneratorFreq(rs.getString("frequency"));
        } catch (SQLException ignored) {
        }
        try {
            rd.setGeneratorWeight(rs.getString("weight"));
        } catch (SQLException ignored) {
        }
        try {
            rd.setGeneratorStatus(rs.getString("generator_status"));
        } catch (SQLException ignored) {
        }
        try {
            rd.setGeneratorName(rs.getString("generator_name"));
        } catch (SQLException ignored) {
        }
        return rd;
    }
}

