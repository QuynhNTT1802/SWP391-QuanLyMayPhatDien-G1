/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package com.quanlymayphatdien.g1.dal;

import com.quanlymayphatdien.g1.entity.StockCard;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.*;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;

/**
 *
 * @author FPTShop
 */
public class StockCardDAO extends DBContext implements I_DAO<StockCard> {

    public List<StockCard> findByWarehouseAndGenerator(int warehouseId, int generatorId) {
        List<StockCard> list = new ArrayList<>();
        String sql = "SELECT sc.*, w.name AS warehouse_name, "
                + "g.model AS generator_model, r.receipt_code, u.name AS created_by_name "
                + "FROM stock_card sc "
                + "LEFT JOIN warehouse w ON sc.warehouse_id = w.warehouse_id "
                + "LEFT JOIN generator g ON sc.generator_id = g.id "
                + "LEFT JOIN receipt r ON sc.receipt_id = r.receipt_id "
                + "LEFT JOIN user u ON sc.created_by = u.id "
                + "WHERE sc.warehouse_id = ? AND sc.generator_id = ? "
                + "ORDER BY sc.created_at DESC";
        try (Connection c = getConnection(); PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setInt(1, warehouseId);
            ps.setInt(2, generatorId);
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

    public List<StockCard> findWithFilters(Integer warehouseId, Integer generatorId,
            String typeFilter, String fromDate, String toDate,
            int page, int pageSize) {
        List<StockCard> list = new ArrayList<>();
        StringBuilder sql = new StringBuilder(
                "SELECT sc.*, w.name AS warehouse_name, "
                + "g.model AS generator_model, r.receipt_code, u.name AS created_by_name "
                + "FROM stock_card sc "
                + "LEFT JOIN warehouse w ON sc.warehouse_id = w.warehouse_id "
                + "LEFT JOIN generator g ON sc.generator_id = g.id "
                + "LEFT JOIN receipt r ON sc.receipt_id = r.receipt_id "
                + "LEFT JOIN user u ON sc.created_by = u.id "
                + "WHERE 1=1 ");
        List<Object> params = new ArrayList<>();
        if (warehouseId != null) {
            sql.append("AND sc.warehouse_id = ? ");
            params.add(warehouseId);
        }
        if (generatorId != null) {
            sql.append("AND sc.generator_id = ? ");
            params.add(generatorId);
        }
        if (typeFilter != null && !typeFilter.isEmpty()) {
            sql.append("AND sc.transaction_type = ? ");
            params.add(typeFilter);
        }
        if (fromDate != null && !fromDate.isEmpty()) {
            sql.append("AND DATE(sc.created_at) >= ? ");
            params.add(fromDate);
        }
        if (toDate != null && !toDate.isEmpty()) {
            sql.append("AND DATE(sc.created_at) <= ? ");
            params.add(toDate);
        }
        sql.append("ORDER BY sc.created_at DESC LIMIT ? OFFSET ?");
        params.add(pageSize);
        params.add((page - 1) * pageSize);
        try (Connection c = getConnection(); PreparedStatement ps = c.prepareStatement(sql.toString())) {
            for (int i = 0; i < params.size(); i++) {
                ps.setObject(i + 1, params.get(i));
            }
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

    public int countWithFilters(Integer warehouseId, Integer generatorId,
            String typeFilter, String fromDate, String toDate) {
        StringBuilder sql = new StringBuilder("SELECT COUNT(*) FROM stock_card sc WHERE 1=1 ");
        List<Object> params = new ArrayList<>();
        if (warehouseId != null) {
            sql.append("AND sc.warehouse_id = ? ");
            params.add(warehouseId);
        }
        if (generatorId != null) {
            sql.append("AND sc.generator_id = ? ");
            params.add(generatorId);
        }
        if (typeFilter != null && !typeFilter.isEmpty()) {
            sql.append("AND sc.transaction_type = ? ");
            params.add(typeFilter);
        }
        if (fromDate != null && !fromDate.isEmpty()) {
            sql.append("AND DATE(sc.created_at) >= ? ");
            params.add(fromDate);
        }
        if (toDate != null && !toDate.isEmpty()) {
            sql.append("AND DATE(sc.created_at) <= ? ");
            params.add(toDate);
        }
        try (Connection c = getConnection(); PreparedStatement ps = c.prepareStatement(sql.toString())) {
            for (int i = 0; i < params.size(); i++) {
                ps.setObject(i + 1, params.get(i));
            }
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }

    public int insert(Connection conn, StockCard sc) throws SQLException {
        String sql = "INSERT INTO stock_card "
                + "(warehouse_id, generator_id, receipt_id, transaction_type, "
                + "quantity_change, quantity_after, reference_note, created_at, created_by) "
                + "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)";
        try (PreparedStatement ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            ps.setInt(1, sc.getWarehouseId());
            ps.setInt(2, sc.getGeneratorId());
            if (sc.getReceiptId() != null) {
                ps.setInt(3, sc.getReceiptId());
            } else {
                ps.setNull(3, Types.INTEGER);
            }
            ps.setString(4, sc.getTransactionType());
            ps.setInt(5, sc.getQuantityChange());
            ps.setInt(6, sc.getQuantityAfter());
            ps.setString(7, sc.getReferenceNote());
            LocalDateTime now = sc.getCreatedAt() != null ? sc.getCreatedAt() : LocalDateTime.now();
            ps.setTimestamp(8, Timestamp.valueOf(now));
            if (sc.getCreatedBy() != null) {
                ps.setInt(9, sc.getCreatedBy());
            } else {
                ps.setNull(9, Types.INTEGER);
            }
            ps.executeUpdate();
            try (ResultSet rs = ps.getGeneratedKeys()) {
                if (rs.next()) {
                    return rs.getInt(1);
                }
            }
        }
        return -1;
    }

    @Override
    public List<StockCard> findAll() {
        throw new UnsupportedOperationException("Not supported yet."); // Generated from nbfs://nbhost/SystemFileSystem/Templates/Classes/Code/GeneratedMethodBody
    }

    @Override
    public boolean update(StockCard t) {
        throw new UnsupportedOperationException("Not supported yet."); // Generated from nbfs://nbhost/SystemFileSystem/Templates/Classes/Code/GeneratedMethodBody
    }

    @Override
    public boolean delete(StockCard t) {
        throw new UnsupportedOperationException("Not supported yet."); // Generated from nbfs://nbhost/SystemFileSystem/Templates/Classes/Code/GeneratedMethodBody
    }

    @Override
    public int insert(StockCard sc) {
        try (Connection c = getConnection()) {
            return insert(c, sc);   // gọi method bên trên
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return -1;
    }

    @Override
    public StockCard getFromResultSet(ResultSet rs) throws SQLException {
        StockCard sc = new StockCard();
        sc.setStockCardId(rs.getInt("stock_card_id"));
        sc.setWarehouseId(rs.getInt("warehouse_id"));
        sc.setGeneratorId(rs.getInt("generator_id"));
        sc.setReceiptId((Integer) rs.getObject("receipt_id"));
        sc.setTransactionType(rs.getString("transaction_type"));
        sc.setQuantityChange(rs.getInt("quantity_change"));
        sc.setQuantityAfter(rs.getInt("quantity_after"));
        sc.setReferenceNote(rs.getString("reference_note"));
        Timestamp ca = rs.getTimestamp("created_at");
        if (ca != null) {
            sc.setCreatedAt(ca.toLocalDateTime());
        }
        sc.setCreatedBy((Integer) rs.getObject("created_by"));
        try {
            sc.setWarehouseName(rs.getString("warehouse_name"));
        } catch (SQLException ignored) {
        }
        try {
            sc.setGeneratorModel(rs.getString("generator_model"));
        } catch (SQLException ignored) {
        }
        try {
            sc.setReceiptCode(rs.getString("receipt_code"));
        } catch (SQLException ignored) {
        }
        try {
            sc.setCreatedByName(rs.getString("created_by_name"));
        } catch (SQLException ignored) {
        }
        return sc;
    }
}
