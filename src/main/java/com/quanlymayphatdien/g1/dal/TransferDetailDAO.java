package com.quanlymayphatdien.g1.dal;

import com.quanlymayphatdien.g1.utils.LogModule;
import com.quanlymayphatdien.g1.entity.TransferDetail;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.sql.Types;
import java.util.ArrayList;
import java.util.List;

/**
 *
 * @author FPTShop
 */
public class TransferDetailDAO extends DBContext implements I_DAO<TransferDetail> {

    @Override
    public List<TransferDetail> findAll() {
        List<TransferDetail> list = new ArrayList<>();
        String sql = "SELECT td.*, g.model AS generator_model "
                   + "FROM transfer_detail td "
                   + "LEFT JOIN generator g ON td.generator_id = g.id "
                   + "ORDER BY td.transfer_detail_id ASC";
        try {
            connection = getConnection();
            statement = connection.prepareStatement(sql);
            resultSet = statement.executeQuery();
            while (resultSet.next()) {
                list.add(getFromResultSet(resultSet));
            }
        } catch (SQLException e) {
            com.quanlymayphatdien.g1.utils.SystemLogger.error(LogModule.SYSTEM, "Loi Ngoai Le",
                    e.getMessage() != null ? e.getMessage() : e.getClass().getName(), e);
        } finally {
            closeResources();
        }
        return list;
    }

    public List<TransferDetail> findByTransferId(int transferId) {
        List<TransferDetail> list = new ArrayList<>();
        String sql = "SELECT td.*, g.model AS generator_model "
                   + "FROM transfer_detail td "
                   + "LEFT JOIN generator g ON td.generator_id = g.id "
                   + "WHERE td.transfer_id = ? "
                   + "ORDER BY td.transfer_detail_id ASC";
        try {
            connection = getConnection();
            statement = connection.prepareStatement(sql);
            statement.setInt(1, transferId);
            resultSet = statement.executeQuery();
            while (resultSet.next()) {
                list.add(getFromResultSet(resultSet));
            }
        } catch (SQLException e) {
            com.quanlymayphatdien.g1.utils.SystemLogger.error(LogModule.SYSTEM, "Loi Ngoai Le",
                    e.getMessage() != null ? e.getMessage() : e.getClass().getName(), e);
        } finally {
            closeResources();
        }
        return list;
    }

    public boolean deleteByTransferId(int transferId) {
        String sql = "DELETE FROM transfer_detail WHERE transfer_id = ?";
        try {
            connection = getConnection();
            statement = connection.prepareStatement(sql);
            statement.setInt(1, transferId);
            return statement.executeUpdate() > 0;
        } catch (SQLException e) {
            com.quanlymayphatdien.g1.utils.SystemLogger.error(LogModule.SYSTEM, "Loi Ngoai Le",
                    e.getMessage() != null ? e.getMessage() : e.getClass().getName(), e);
        } finally {
            closeResources();
        }
        return false;
    }

    @Override
    public boolean update(TransferDetail d) {
        String sql = "UPDATE transfer_detail SET generator_id = ?, serial_number = ?, "
                   + "quantity = ?, note = ? WHERE transfer_detail_id = ?";
        try {
            connection = getConnection();
            statement = connection.prepareStatement(sql);
            statement.setInt(1, d.getGeneratorId());
            if (d.getSerialNumber() != null && !d.getSerialNumber().trim().isEmpty()) {
                statement.setString(2, d.getSerialNumber().trim());
            } else {
                statement.setNull(2, Types.VARCHAR);
            }
            statement.setInt(3, d.getQuantity());
            if (d.getNote() != null && !d.getNote().trim().isEmpty()) {
                statement.setString(4, d.getNote().trim());
            } else {
                statement.setNull(4, Types.VARCHAR);
            }
            statement.setInt(5, d.getTransferDetailId());
            return statement.executeUpdate() > 0;
        } catch (SQLException e) {
            com.quanlymayphatdien.g1.utils.SystemLogger.error(LogModule.SYSTEM, "Loi Ngoai Le",
                    e.getMessage() != null ? e.getMessage() : e.getClass().getName(), e);
        } finally {
            closeResources();
        }
        return false;
    }

    @Override
    public boolean delete(TransferDetail d) {
        String sql = "DELETE FROM transfer_detail WHERE transfer_detail_id = ?";
        try {
            connection = getConnection();
            statement = connection.prepareStatement(sql);
            statement.setInt(1, d.getTransferDetailId());
            return statement.executeUpdate() > 0;
        } catch (SQLException e) {
            com.quanlymayphatdien.g1.utils.SystemLogger.error(LogModule.SYSTEM, "Loi Ngoai Le",
                    e.getMessage() != null ? e.getMessage() : e.getClass().getName(), e);
        } finally {
            closeResources();
        }
        return false;
    }

    @Override
    public int insert(TransferDetail d) {
        String sql = "INSERT INTO transfer_detail (transfer_id, generator_id, serial_number, quantity, note) "
                   + "VALUES (?, ?, ?, ?, ?)";
        try {
            connection = getConnection();
            statement = connection.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS);
            statement.setInt(1, d.getTransferId());
            statement.setInt(2, d.getGeneratorId());
            if (d.getSerialNumber() != null && !d.getSerialNumber().trim().isEmpty()) {
                statement.setString(3, d.getSerialNumber().trim());
            } else {
                statement.setNull(3, Types.VARCHAR);
            }
            statement.setInt(4, d.getQuantity());
            if (d.getNote() != null && !d.getNote().trim().isEmpty()) {
                statement.setString(5, d.getNote().trim());
            } else {
                statement.setNull(5, Types.VARCHAR);
            }
            statement.executeUpdate();
            resultSet = statement.getGeneratedKeys();
            if (resultSet.next()) {
                return resultSet.getInt(1);
            }
        } catch (SQLException e) {
            com.quanlymayphatdien.g1.utils.SystemLogger.error(LogModule.SYSTEM, "Loi Ngoai Le",
                    e.getMessage() != null ? e.getMessage() : e.getClass().getName(), e);
        } finally {
            closeResources();
        }
        return -1;
    }

    public int batchInsert(Connection conn, List<TransferDetail> details) throws SQLException {
        String sql = "INSERT INTO transfer_detail (transfer_id, generator_id, serial_number, quantity, note) "
                   + "VALUES (?, ?, ?, ?, ?)";
        try (PreparedStatement ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            for (TransferDetail d : details) {
                ps.setInt(1, d.getTransferId());
                ps.setInt(2, d.getGeneratorId());
                if (d.getSerialNumber() != null && !d.getSerialNumber().trim().isEmpty()) {
                    ps.setString(3, d.getSerialNumber().trim());
                } else {
                    ps.setNull(3, Types.VARCHAR);
                }
                ps.setInt(4, d.getQuantity());
                if (d.getNote() != null && !d.getNote().trim().isEmpty()) {
                    ps.setString(5, d.getNote().trim());
                } else {
                    ps.setNull(5, Types.VARCHAR);
                }
                ps.addBatch();
            }
            ps.executeBatch();
        }
        return -1;
    }

    @Override
    public TransferDetail getFromResultSet(ResultSet rs) throws SQLException {
        TransferDetail d = new TransferDetail();
        d.setTransferDetailId(rs.getInt("transfer_detail_id"));
        d.setTransferId(rs.getInt("transfer_id"));
        d.setGeneratorId(rs.getInt("generator_id"));
        d.setSerialNumber(rs.getString("serial_number"));
        d.setQuantity(rs.getInt("quantity"));
        d.setNote(rs.getString("note"));
        try {
            d.setGeneratorModel(rs.getString("generator_model"));
        } catch (SQLException ignored) {
        }
        return d;
    }
}