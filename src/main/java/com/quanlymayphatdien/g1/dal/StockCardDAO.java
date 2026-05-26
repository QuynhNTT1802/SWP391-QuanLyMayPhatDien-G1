/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package com.quanlymayphatdien.g1.dal;

import com.quanlymayphatdien.g1.entity.StockCard;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.*;
import java.util.List;

/**
 *
 * @author FPTShop
 */
public class StockCardDAO extends DBContext implements I_DAO<StockCard> {

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
    public int insert(StockCard t) {
        throw new UnsupportedOperationException("Not supported yet."); // Generated from nbfs://nbhost/SystemFileSystem/Templates/Classes/Code/GeneratedMethodBody
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
        // Field join - có thể không có
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
        return sc;
    }
}


