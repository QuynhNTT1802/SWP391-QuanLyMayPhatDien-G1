/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package com.quanlymayphatdien.g1.dal;

import com.quanlymayphatdien.g1.entity.LiquidationDetail;
import com.quanlymayphatdien.g1.utils.SystemLogger;
import java.math.BigDecimal;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

/**
 *
 * @author LENOVO
 */
public class LiquidationDetailDAO extends DBContext implements I_DAO<LiquidationDetail> {

    @Override
    public List<LiquidationDetail> findAll() {
        throw new UnsupportedOperationException("Not supported yet."); // Generated from nbfs://nbhost/SystemFileSystem/Templates/Classes/Code/GeneratedMethodBody
    }

    @Override
    public boolean update(LiquidationDetail t) {
         String sql = "update liquidation_detail set liquidation_price = ? where liquidation_detail_id = ? ";
         try (Connection c = getConnection()) {
             PreparedStatement p = c.prepareStatement(sql);
             p.setBigDecimal(1, t.getLiquidationPrice());
             p.setInt(2, t.getLiquidationDetailId());
             return p.executeUpdate() > 0;
         } catch (Exception e) {
             SystemLogger.error("Thanh lý", "Lỗi update detail liquidation", e.getMessage(), e);
         }
         return false;
    }

    @Override
    public boolean delete(LiquidationDetail t) {
        throw new UnsupportedOperationException("Not supported yet."); // Generated from nbfs://nbhost/SystemFileSystem/Templates/Classes/Code/GeneratedMethodBody
    }

    @Override
    public int insert(LiquidationDetail t) {
        String sql = "insert into liquidation_detail(liquidation_id, generator_id, serial_number, original_price, liquidation_price) "
                + "values (?, ? ,? ,? ,?)";
        try (Connection c = getConnection()) {
            PreparedStatement p = c.prepareStatement(sql);
            p.setInt(1, t.getLiquidationId());
            p.setInt(2, t.getGeneratorId());
            p.setString(3, t.getSerialNumber());
            p.setBigDecimal(4, t.getOriginalPrice());

            if (t.getLiquidationPrice() != null) {
                p.setBigDecimal(5, t.getLiquidationPrice());

            } else {
                p.setNull(5, java.sql.Types.DECIMAL);
            }

            return p.executeUpdate() > 0 ? 1 : 0;
        } catch (Exception e) {
            SystemLogger.error("Thanh lý", "Lỗi khi thêm detail cho liquidation", e.getMessage(), e);
        }
        return -1;

    }

    @Override
    public LiquidationDetail getFromResultSet(ResultSet rs) throws SQLException {
        LiquidationDetail d = new LiquidationDetail();
        d.setLiquidationDetailId(rs.getInt("liquidation_detail_id"));
        d.setLiquidationId(rs.getInt("liquidation_id"));
        d.setGeneratorId(rs.getInt("generator_id"));
        d.setSerialNumber(rs.getString("serial_number"));
        d.setOriginalPrice(rs.getBigDecimal("original_price"));
        d.setLiquidationPrice(rs.getBigDecimal("liquidation_price"));
        try {
            d.setGeneratorModelName(rs.getString("generator_model_name"));
        } catch (SQLException e) {
            SystemLogger.error("Thanh lý", "Lỗi lấy thông tin của liquidation detail", e.getMessage(), e);

        }
        return d;
    }
    
    public List<LiquidationDetail> findByLiquidationId(int liquidationId) {
        List<LiquidationDetail> list = new ArrayList<>();
        String sql = "select ld.*, g.model as generator_model_name "
                   + "from liquidation_detail ld "
                   + "join generator g on ld.generator_id = g.id "
                   + "where ld.liquidation_id = ?";
        try (Connection c = getConnection()) {
            PreparedStatement p = c.prepareStatement(sql);
            p.setInt(1, liquidationId);
            try (ResultSet rs  = p.executeQuery()) {
                while(rs.next()) {
                    list.add(getFromResultSet(rs));
                }
            }
        } catch (Exception e) {
            SystemLogger.error("Thanh lý", "Lỗi findByLiquidationId", e.getMessage(), e);
        }
        return list;
    }

    public boolean deleteByLiquidationId(int liquidationId) {
        String sql = "DELETE FROM liquidation_detail WHERE liquidation_id = ?";
        try (Connection c = getConnection()) {
            PreparedStatement p = c.prepareStatement(sql);
            p.setInt(1, liquidationId);
            return p.executeUpdate() >= 0;
        } catch (Exception e) {
            SystemLogger.error("Thanh lý", "Lỗi deleteByLiquidationId", e.getMessage(), e);
        }
        return false;
    }

}
