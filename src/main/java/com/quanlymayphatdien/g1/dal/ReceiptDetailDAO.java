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
        String sql = "SELECT rd.*, g.model AS generator_model "
                + "FROM receipt_detail rd "
                + "JOIN generator g ON rd.generator_id = g.id "
                + "WHERE rd.receipt_id = ?";
        try (Connection c = getConnection(); PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setInt(1, receiptId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    list.add(getFromResultSet(rs));
                }
            }
        } catch (SQLException e) {
            com.quanlymayphatdien.g1.utils.SystemLogger.error("He thong", "Loi Ngoai Le", e.getMessage() != null ? e.getMessage() : e.getClass().getName(), e);
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
        String sql = "INSERT INTO receipt_detail (receipt_id, generator_id, serial_number, quantity, note) "
                + "VALUES (?, ?, ?, ?, ?)";
        try (Connection c = getConnection(); PreparedStatement ps = c.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            ps.setInt(1, rd.getReceiptId());
            ps.setInt(2, rd.getGeneratorId());
            ps.setString(3, rd.getSerialNumber());
            ps.setInt(4, rd.getQuantity());
            ps.setString(5, rd.getNote());
            ps.executeUpdate();
            try (ResultSet rs = ps.getGeneratedKeys()) {
                if (rs.next()) {
                    return rs.getInt(1);
                }
            }
        } catch (SQLException e) {
            com.quanlymayphatdien.g1.utils.SystemLogger.error("He thong", "Loi Ngoai Le", e.getMessage() != null ? e.getMessage() : e.getClass().getName(), e);
        }
        return -1;
    }

    public int batchInsert(Connection conn, List<ReceiptDetail> details) throws SQLException {
        String sql = "INSERT INTO receipt_detail (receipt_id, generator_id, serial_number, quantity, note) "
                + "VALUES (?, ?, ?, ?, ?)";
        try (Connection c = getConnection(); PreparedStatement ps = c.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            for (ReceiptDetail rd : details) {
                ps.setInt(1, rd.getReceiptId());
                ps.setInt(2, rd.getGeneratorId());
                ps.setString(3, rd.getSerialNumber());
                ps.setInt(4, rd.getQuantity());
                ps.setString(5, rd.getNote());
                ps.addBatch();
            }
            ps.executeBatch();
        } catch (SQLException e) {
            com.quanlymayphatdien.g1.utils.SystemLogger.error("He thong", "Loi Ngoai Le", e.getMessage() != null ? e.getMessage() : e.getClass().getName(), e);
        }
        return -1;
    }

    @Override
    public ReceiptDetail getFromResultSet(ResultSet rs) throws SQLException {
        ReceiptDetail rd = new ReceiptDetail();
        rd.setReceiptDetailId(rs.getInt("receipt_detail_id"));
        rd.setReceiptId(rs.getInt("receipt_id"));
        rd.setGeneratorId(rs.getInt("generator_id"));
        rd.setSerialNumber(rs.getString("serial_number"));
        rd.setQuantity(rs.getInt("quantity"));
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
