package com.quanlymayphatdien.g1.dal;

import com.quanlymayphatdien.g1.entity.LiquidationDetail;
import com.quanlymayphatdien.g1.utils.SystemLogger;
import com.quanlymayphatdien.g1.utils.LogModule;
import java.math.BigDecimal;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class LiquidationDetailDAO extends DBContext implements I_DAO<LiquidationDetail> {

    @Override
    public List<LiquidationDetail> findAll() {
        throw new UnsupportedOperationException("Not supported yet.");
    }

    @Override
    public boolean update(LiquidationDetail t) {
         String sql = "update liquidation_detail set liquidation_price = ? where liquidation_detail_id = ? ";
         try {
             connection = getConnection();
             statement = connection.prepareStatement(sql);
             statement.setBigDecimal(1, t.getLiquidationPrice());
             statement.setInt(2, t.getLiquidationDetailId());
             return statement.executeUpdate() > 0;
         } catch (Exception e) {
             SystemLogger.error(LogModule.LIQUIDATION, "Lỗi update detail liquidation", e.getMessage(), e);
         } finally {
             closeResources();
         }
         return false;
    }

    @Override
    public boolean delete(LiquidationDetail t) {
        throw new UnsupportedOperationException("Not supported yet.");
    }

    @Override
    public int insert(LiquidationDetail t) {
        String sql = "insert into liquidation_detail(liquidation_id, generator_id, serial_number, original_price, liquidation_price) "
                + "values (?, ? ,? ,? ,?)";
        try {
            connection = getConnection();
            statement = connection.prepareStatement(sql);
            statement.setInt(1, t.getLiquidationId());
            statement.setInt(2, t.getGeneratorId());
            statement.setString(3, t.getSerialNumber());
            statement.setBigDecimal(4, t.getOriginalPrice());

            if (t.getLiquidationPrice() != null) {
                statement.setBigDecimal(5, t.getLiquidationPrice());

            } else {
                statement.setNull(5, java.sql.Types.DECIMAL);
            }

            return statement.executeUpdate() > 0 ? 1 : 0;
        } catch (Exception e) {
            SystemLogger.error(LogModule.LIQUIDATION, "Lỗi khi thêm detail cho liquidation", e.getMessage(), e);
        } finally {
            closeResources();
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
            SystemLogger.error(LogModule.LIQUIDATION, "Lỗi lấy thông tin của liquidation detail", e.getMessage(), e);

        }
        try {
            d.setCondition(rs.getString("condition"));
        } catch (SQLException ignored) {
        }
        return d;
    }
    
    public List<LiquidationDetail> findByLiquidationId(int liquidationId) {
        List<LiquidationDetail> list = new ArrayList<>();
        String sql = "select ld.*, g.model as generator_model_name, i.condition "
                   + "from liquidation_detail ld "
                   + "join generator g on ld.generator_id = g.id "
                   + "left join inventory i on ld.serial_number = i.serial_number "
                   + "where ld.liquidation_id = ?";
        try {
            connection = getConnection();
            statement = connection.prepareStatement(sql);
            statement.setInt(1, liquidationId);
            resultSet = statement.executeQuery();
            while(resultSet.next()) {
                list.add(getFromResultSet(resultSet));
            }
        } catch (Exception e) {
            SystemLogger.error(LogModule.LIQUIDATION, "Lỗi findByLiquidationId", e.getMessage(), e);
        } finally {
            closeResources();
        }
        return list;
    }

    public boolean deleteByLiquidationId(int liquidationId) {
        String sql = "DELETE FROM liquidation_detail WHERE liquidation_id = ?";
        try {
            connection = getConnection();
            statement = connection.prepareStatement(sql);
            statement.setInt(1, liquidationId);
            return statement.executeUpdate() >= 0;
        } catch (Exception e) {
            SystemLogger.error(LogModule.LIQUIDATION, "Lỗi deleteByLiquidationId", e.getMessage(), e);
        } finally {
            closeResources();
        }
        return false;
    }

    public void deleteByLiquidationId(Connection conn, int liquidationId) throws SQLException {
        String sql = "DELETE FROM liquidation_detail WHERE liquidation_id = ?";
        try (PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, liquidationId);
            stmt.executeUpdate();
        }
    }

    public int insert(Connection conn, LiquidationDetail t) throws SQLException {
        String sql = "insert into liquidation_detail(liquidation_id, generator_id, serial_number, original_price, liquidation_price) "
                + "values (?, ? ,? ,? ,?)";
        try (PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, t.getLiquidationId());
            stmt.setInt(2, t.getGeneratorId());
            stmt.setString(3, t.getSerialNumber());
            stmt.setBigDecimal(4, t.getOriginalPrice());

            if (t.getLiquidationPrice() != null) {
                stmt.setBigDecimal(5, t.getLiquidationPrice());
            } else {
                stmt.setNull(5, java.sql.Types.DECIMAL);
            }

            return stmt.executeUpdate() > 0 ? 1 : 0;
        }
    }

}
