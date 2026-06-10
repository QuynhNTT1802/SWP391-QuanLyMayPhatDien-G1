/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package com.quanlymayphatdien.g1.dal;

import com.quanlymayphatdien.g1.entity.ReceiptDetail;
import com.quanlymayphatdien.g1.entity.Warehouse;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;

/**
 *
 * @author FPTShop
 */
public class ReceiptDetailDAO extends DBContext implements I_DAO<ReceiptDetail> {

    @Override
    public List<ReceiptDetail> findAll() {
        throw new UnsupportedOperationException("Not supported yet."); // Generated from nbfs://nbhost/SystemFileSystem/Templates/Classes/Code/GeneratedMethodBody
    }

    public List<ReceiptDetail> findByReceiptId(int receiptId) {
        List<ReceiptDetail> list = new ArrayList<>();
        String sql = "SELECT rd.*, g.model AS generator_model, g.unit_price AS generator_price "
                + "FROM receipt_detail rd "
                + "LEFT JOIN generator g ON rd.generator_id = g.id "
                + "WHERE rd.receipt_id = ?";
        try (Connection c = getConnection(); PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setInt(1, receiptId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    list.add(getFromResultSet(rs));
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    @Override
    public boolean update(ReceiptDetail t) {
        throw new UnsupportedOperationException("Not supported yet."); // Generated from nbfs://nbhost/SystemFileSystem/Templates/Classes/Code/GeneratedMethodBody
    }

    @Override
    public boolean delete(ReceiptDetail t) {
        throw new UnsupportedOperationException("Not supported yet."); // Generated from nbfs://nbhost/SystemFileSystem/Templates/Classes/Code/GeneratedMethodBody
    }

    @Override
    public int insert(ReceiptDetail rd) {
        String sql = "INSERT INTO receipt_detail (receipt_id, generator_id, serial_number, quantity, unit_price, note) "
                + "VALUES (?, ?, ?, ?, ?, ?)";
        try (Connection c = getConnection(); PreparedStatement ps = c.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            ps.setInt(1, rd.getReceiptId());
            ps.setInt(2, rd.getGeneratorId());
            ps.setString(3, rd.getSerialNumber());
            ps.setInt(4, rd.getQuantity());
            if (rd.getUnitPrice() != null) {
                ps.setBigDecimal(5, rd.getUnitPrice());
            } else {
                ps.setNull(5, java.sql.Types.DECIMAL);
            }
            ps.setString(6, rd.getNote());
            ps.executeUpdate();
            try (ResultSet rs = ps.getGeneratedKeys()) {
                if (rs.next()) {
                    return rs.getInt(1);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return -1;
    }

    public int batchInsert(Connection conn, List<ReceiptDetail> details) throws SQLException {
        String sql = "INSERT INTO receipt_detail (receipt_id, generator_id, serial_number, quantity, unit_price, note) "
                + "VALUES (?, ?, ?, ?, ?, ?)";
        try (PreparedStatement ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            for (ReceiptDetail rd : details) {
                ps.setInt(1, rd.getReceiptId());
                ps.setInt(2, rd.getGeneratorId());
                ps.setString(3, rd.getSerialNumber());
                ps.setInt(4, rd.getQuantity());
                if (rd.getUnitPrice() != null) {
                    ps.setBigDecimal(5, rd.getUnitPrice());
                } else {
                    ps.setNull(5, java.sql.Types.DECIMAL);
                }
                ps.setString(6, rd.getNote());
                ps.addBatch();
            }
            ps.executeBatch();
        }
        return -1;
    }

    public boolean isSerialExists(Connection conn, String serialNumber) throws SQLException {
        String sql = "SELECT COUNT(*) FROM receipt_detail WHERE serial_number = ?";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, serialNumber);
            try (ResultSet rs = ps.executeQuery()) {
                return rs.next() && rs.getInt(1) > 0;
            }
        }
    }

    public List<String> findSerialsByReceiptIdAndGenerator(int receiptId, int generatorId) {
        List<String> list = new ArrayList<>();
        String sql = "SELECT serial_number FROM receipt_detail WHERE receipt_id = ? AND generator_id = ? ORDER BY receipt_detail_id";
        try (Connection c = getConnection(); PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setInt(1, receiptId);
            ps.setInt(2, generatorId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    list.add(rs.getString("serial_number"));
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    @Override
    public ReceiptDetail getFromResultSet(ResultSet rs) throws SQLException {
        ReceiptDetail rd = new ReceiptDetail();
        rd.setReceiptDetailId(rs.getInt("receipt_detail_id"));
        rd.setReceiptId(rs.getInt("receipt_id"));
        rd.setGeneratorId(rs.getInt("generator_id"));
        rd.setSerialNumber(rs.getString("serial_number"));
        rd.setQuantity(rs.getInt("quantity"));
        try {
            rd.setUnitPrice(rs.getBigDecimal("unit_price"));
        } catch (SQLException ignored) {
        }
        rd.setNote(rs.getString("note"));

        try {
            rd.setGeneratorModel(rs.getString("generator_model"));
        } catch (SQLException ignored) {
        }
        try {
            rd.setGeneratorBrand(rs.getString("generator_brand"));
        } catch (SQLException ignored) {
        }
        return rd;
    }

}
