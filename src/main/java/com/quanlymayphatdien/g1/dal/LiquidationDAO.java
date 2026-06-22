package com.quanlymayphatdien.g1.dal;

import com.quanlymayphatdien.g1.entity.Liquidation;
import com.quanlymayphatdien.g1.utils.SystemLogger;
import com.quanlymayphatdien.g1.utils.LogModule;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;

public class LiquidationDAO extends DBContext implements I_DAO<Liquidation> {

    @Override
    public Liquidation getFromResultSet(ResultSet rs) throws SQLException {
        Liquidation l = new Liquidation();
        l.setLiquidationId(rs.getInt("liquidation_id"));
        l.setLiquidationCode(rs.getString("liquidation_code"));
        l.setCreatedBy(rs.getInt("created_by"));
        l.setStatus(rs.getString("status"));
        l.setReasonId(rs.getInt("reason_id"));
        l.setWarehouseId(rs.getInt("warehouse_id"));
        l.setCustomerId(rs.getObject("customer_id", Integer.class));

        l.setManagerReviewedBy(rs.getObject("manager_reviewed_by", Integer.class));
        l.setManagerReviewedAt(rs.getObject("manager_reviewed_at", LocalDateTime.class));
        l.setCeoReviewedBy(rs.getObject("ceo_reviewed_by", Integer.class));
        l.setCeoReviewedAt(rs.getObject("ceo_reviewed_at", LocalDateTime.class));
        l.setCeoFeedbackId(rs.getObject("ceo_feedback_id", Integer.class));
        l.setManagerFeedbackId(rs.getObject("manager_feedback_id", Integer.class));
        l.setConvertedReceiptId(rs.getObject("converted_receipt_id", Integer.class));

        l.setCreatedAt(rs.getObject("created_at", LocalDateTime.class));
        l.setUpdatedAt(rs.getObject("updated_at", LocalDateTime.class));

        try {
            l.setCreatedByName(rs.getString("created_by_name"));

            l.setReasonName(rs.getString("reason_name"));

            l.setCeoFeedbackName(rs.getString("ceo_feedback_name"));

            l.setManagerFeedbackName(rs.getString("manager_feedback_name"));

            l.setWarehouseName(rs.getString("warehouse_name"));

            l.setCustomerName(rs.getString("customer_name"));

            l.setCustomerPhone(rs.getString("customer_phone"));

            l.setCustomerEmail(rs.getString("customer_email"));

            l.setCustomerAddress(rs.getString("customer_address"));

            int dc = rs.getInt("detail_count");
            if (!rs.wasNull()) {
                l.setDetailCount(dc);
            }

            l.setTotalOriginalPrice(rs.getBigDecimal("total_original_price"));

            l.setTotalLiquidationPrice(rs.getBigDecimal("total_liquidation_price"));
        } catch (Exception e) {
            e.printStackTrace();
        }

        return l;
    }

    @Override
    public List<Liquidation> findAll() {
        List<Liquidation> list = new ArrayList<>();
        String sql = "SELECT l.*, u.name AS created_by_name, c.name AS reason_name, w.name AS warehouse_name, "
                + "cu.name AS customer_name, cu.phone AS customer_phone, cu.email AS customer_email, cu.address AS customer_address "
                + "FROM liquidation l "
                + "JOIN user u ON l.created_by = u.id "
                + "JOIN category c ON l.reason_id = c.id "
                + "JOIN warehouse w ON l.warehouse_id = w.warehouse_id "
                + "LEFT JOIN customer cu ON l.customer_id = cu.id "
                + "ORDER BY l.created_at DESC";
        try {
            connection = getConnection();
            statement = connection.prepareStatement(sql);
            resultSet = statement.executeQuery();
            while (resultSet.next()) {
                list.add(getFromResultSet(resultSet));
            }
        } catch (Exception e) {
            SystemLogger.error(LogModule.LIQUIDATION, "Lỗi lấy danh sách", e.getMessage(), e);
        } finally {
            closeResources();
        }
        return list;
    }

    public int countTotal(String search, String status, Integer createdBy) {
        StringBuilder sql = new StringBuilder("SELECT COUNT(*) FROM liquidation l JOIN user u ON l.created_by = u.id WHERE 1=1");
        List<Object> params = new ArrayList<>();
        if (createdBy != null) {
            sql.append(" AND l.created_by = ?");
            params.add(createdBy);
        }
        if (search != null && !search.trim().isEmpty()) {
            sql.append(" AND (l.liquidation_code LIKE ? OR u.name LIKE ?)");
            params.add("%" + search.trim() + "%");
            params.add("%" + search.trim() + "%");
        }
        if (status != null && !status.trim().isEmpty()) {
            sql.append(" AND l.status = ?");
            params.add(status);
        }
        try {
            connection = getConnection();
            statement = connection.prepareStatement(sql.toString());
            for (int i = 0; i < params.size(); i++) {
                statement.setObject(i + 1, params.get(i));
            }
            resultSet = statement.executeQuery();
            if (resultSet.next()) {
                return resultSet.getInt(1);
            }
        } catch (Exception e) {
            SystemLogger.error(LogModule.LIQUIDATION, "Lỗi countTotal", e.getMessage(), e);
        } finally {
            closeResources();
        }
        return 0;
    }

    public List<Liquidation> findWithPagination(int limit, int offset, String search, String status, Integer createdBy) {
        List<Liquidation> list = new ArrayList<>();
        StringBuilder sql = new StringBuilder("SELECT l.*, u.name AS created_by_name, c.name AS reason_name, w.name AS warehouse_name, cu.name AS customer_name, cu.phone AS customer_phone, cu.email AS customer_email, cu.address AS customer_address, mf.name AS manager_feedback_name, f.name AS ceo_feedback_name, agg.detail_count, agg.total_original_price, agg.total_liquidation_price FROM liquidation l JOIN user u ON l.created_by = u.id JOIN category c ON l.reason_id = c.id JOIN warehouse w ON l.warehouse_id = w.warehouse_id LEFT JOIN customer cu ON l.customer_id = cu.id LEFT JOIN category mf ON l.manager_feedback_id = mf.id LEFT JOIN category f ON l.ceo_feedback_id = f.id LEFT JOIN (SELECT liquidation_id, COUNT(*) AS detail_count, SUM(original_price) AS total_original_price, SUM(liquidation_price) AS total_liquidation_price FROM liquidation_detail GROUP BY liquidation_id) agg ON agg.liquidation_id = l.liquidation_id WHERE 1=1");
        List<Object> params = new ArrayList<>();
        if (createdBy != null) {
            sql.append(" AND l.created_by = ?");
            params.add(createdBy);
        }
        if (search != null && !search.trim().isEmpty()) {
            sql.append(" AND (l.liquidation_code LIKE ? OR u.name LIKE ?)");
            params.add("%" + search.trim() + "%");
            params.add("%" + search.trim() + "%");
        }
        if (status != null && !status.trim().isEmpty()) {
            sql.append(" AND l.status = ?");
            params.add(status);
        }
        sql.append(" ORDER BY l.created_at DESC LIMIT ? OFFSET ?");
        params.add(limit);
        params.add(offset);

        try {
            connection = getConnection();
            statement = connection.prepareStatement(sql.toString());
            for (int i = 0; i < params.size(); i++) {
                statement.setObject(i + 1, params.get(i));
            }
            resultSet = statement.executeQuery();
            while (resultSet.next()) {
                list.add(getFromResultSet(resultSet));
            }
        } catch (Exception e) {
            SystemLogger.error(LogModule.LIQUIDATION, "Lỗi findWithPagination", e.getMessage(), e);
        } finally {
            closeResources();
        }
        return list;
    }

    public Map<String, Integer> getKpiCounts(Integer createdBy) {
        Map<String, Integer> kpis = new java.util.HashMap<>();
        String sql = "SELECT status, COUNT(*) FROM liquidation";
        if (createdBy != null) {
            sql += " WHERE created_by = ?";
        }
        sql += " GROUP BY status";
        try {
            connection = getConnection();
            statement = connection.prepareStatement(sql);
            if (createdBy != null) {
                statement.setInt(1, createdBy);
            }
            resultSet = statement.executeQuery();
            while (resultSet.next()) {
                kpis.put(resultSet.getString(1), resultSet.getInt(2));
            }
        } catch (Exception e) {
            SystemLogger.error(LogModule.LIQUIDATION, "Lỗi getKpiCounts", e.getMessage(), e);
        } finally {
            closeResources();
        }
        return kpis;
    }

    public Liquidation findById(int id) {
        String sql = "SELECT l.*, u.name AS created_by_name, c.name AS reason_name, f.name AS ceo_feedback_name, "
                + "mf.name AS manager_feedback_name, w.name AS warehouse_name, "
                + "cu.name AS customer_name, cu.phone AS customer_phone, cu.email AS customer_email, cu.address AS customer_address, "
                + "agg.detail_count, agg.total_original_price, agg.total_liquidation_price "
                + "FROM liquidation l "
                + "JOIN user u ON l.created_by = u.id "
                + "JOIN category c ON l.reason_id = c.id "
                + "JOIN warehouse w ON l.warehouse_id = w.warehouse_id "
                + "LEFT JOIN customer cu ON l.customer_id = cu.id "
                + "LEFT JOIN category f ON l.ceo_feedback_id = f.id "
                + "LEFT JOIN category mf ON l.manager_feedback_id = mf.id "
                + "LEFT JOIN (SELECT liquidation_id, COUNT(*) AS detail_count, SUM(original_price) AS total_original_price, SUM(liquidation_price) AS total_liquidation_price FROM liquidation_detail GROUP BY liquidation_id) agg ON agg.liquidation_id = l.liquidation_id "
                + "WHERE l.liquidation_id = ?";
        try {
            connection = getConnection();
            statement = connection.prepareStatement(sql);
            statement.setInt(1, id);
            resultSet = statement.executeQuery();
            if (resultSet.next()) {
                return getFromResultSet(resultSet);
            }
        } catch (Exception e) {
            SystemLogger.error(LogModule.LIQUIDATION, "Lỗi findById", e.getMessage(), e);
        } finally {
            closeResources();
        }
        return null;
    }

    public boolean updateStatus(int liquidationId, String status, int reviewerId, String role, Integer receiptId) {
        String sql = "UPDATE liquidation SET status = ?, updated_at = ?";
        if (role.equals("manager")) {
            sql += ", manager_reviewed_by = ?, manager_reviewed_at = ?";
        } else if (role.equals("ceo")) {
            sql += ", ceo_reviewed_by = ?, ceo_reviewed_at = ?, converted_receipt_id = ?";
        }
        sql += " WHERE liquidation_id = ?";

        try {
            connection = getConnection();
            statement = connection.prepareStatement(sql);
            statement.setString(1, status);
            LocalDateTime now = LocalDateTime.now();
            statement.setObject(2, now);

            if (role.equals("manager")) {
                statement.setInt(3, reviewerId);
                statement.setObject(4, now);
                statement.setInt(5, liquidationId);
            } else if (role.equals("ceo")) {
                statement.setInt(3, reviewerId);
                statement.setObject(4, now);
                if (receiptId != null) {
                    statement.setInt(5, receiptId);
                } else {
                    statement.setNull(5, java.sql.Types.INTEGER);
                }
                statement.setInt(6, liquidationId);
            } else {
                statement.setInt(3, liquidationId);
            }
            return statement.executeUpdate() > 0;
        } catch (Exception e) {
            SystemLogger.error(LogModule.LIQUIDATION, "Lỗi updateStatus", e.getMessage(), e);
        } finally {
            closeResources();
        }
        return false;
    }

    public boolean updateReject(int liquidationId, int ceoId, int feedbackId) {
        return updateCeoReject(liquidationId, ceoId, feedbackId, false);
    }

    public boolean updateCeoReject(int liquidationId, int ceoId, int feedbackId, boolean isPermanent) {
        String status = isPermanent ? "REJECTED_BY_CEO" : "CEO_REQUEST_EDIT";
        String sql = "UPDATE liquidation SET status = ?, ceo_reviewed_by = ?, ceo_reviewed_at = ?, ceo_feedback_id = ?, updated_at = ? WHERE liquidation_id = ?";
        try {
            connection = getConnection();
            statement = connection.prepareStatement(sql);
            LocalDateTime now = LocalDateTime.now();
            statement.setString(1, status);
            statement.setInt(2, ceoId);
            statement.setObject(3, now);
            statement.setInt(4, feedbackId);
            statement.setObject(5, now);
            statement.setInt(6, liquidationId);
            return statement.executeUpdate() > 0;
        } catch (Exception e) {
            SystemLogger.error(LogModule.LIQUIDATION, "Lỗi updateCeoReject", e.getMessage(), e);
        } finally {
            closeResources();
        }
        return false;
    }

    public boolean updateManagerReject(int liquidationId, int managerId, int feedbackId, boolean isPermanent) {
        String status = isPermanent ? "REJECTED_BY_MANAGER" : "MANAGER_REQUEST_EDIT";
        String sql = "UPDATE liquidation SET status = ?, manager_reviewed_by = ?, manager_reviewed_at = ?, manager_feedback_id = ?, updated_at = ? WHERE liquidation_id = ?";
        try {
            connection = getConnection();
            statement = connection.prepareStatement(sql);
            LocalDateTime now = LocalDateTime.now();
            statement.setString(1, status);
            statement.setInt(2, managerId);
            statement.setObject(3, now);
            statement.setInt(4, feedbackId);
            statement.setObject(5, now);
            statement.setInt(6, liquidationId);
            return statement.executeUpdate() > 0;
        } catch (Exception e) {
            SystemLogger.error(LogModule.LIQUIDATION, "Lỗi updateManagerReject", e.getMessage(), e);
        } finally {
            closeResources();
        }
        return false;
    }

    public boolean updateReasonAndStatus(int liquidationId, int reasonId, String targetStatus) {
        String sql = "UPDATE liquidation SET reason_id = ?, status = ?, "
                + "manager_feedback_id = NULL, manager_reviewed_by = NULL, manager_reviewed_at = NULL, "
                + "ceo_feedback_id = NULL, ceo_reviewed_by = NULL, ceo_reviewed_at = NULL, "
                + "updated_at = ? WHERE liquidation_id = ?";
        try {
            connection = getConnection();
            statement = connection.prepareStatement(sql);
            statement.setInt(1, reasonId);
            statement.setString(2, targetStatus);
            statement.setObject(3, LocalDateTime.now());
            statement.setInt(4, liquidationId);
            return statement.executeUpdate() > 0;
        } catch (Exception e) {
            SystemLogger.error(LogModule.LIQUIDATION, "Lỗi updateReasonAndStatus", e.getMessage(), e);
        } finally {
            closeResources();
        }
        return false;
    }

    public boolean updateReasonAndStatus(Connection conn, int liquidationId, int reasonId, String targetStatus) throws SQLException {
        String sql = "UPDATE liquidation SET reason_id = ?, status = ?, "
                + "manager_feedback_id = NULL, manager_reviewed_by = NULL, manager_reviewed_at = NULL, "
                + "ceo_feedback_id = NULL, ceo_reviewed_by = NULL, ceo_reviewed_at = NULL, "
                + "updated_at = ? WHERE liquidation_id = ?";
        try (PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, reasonId);
            stmt.setString(2, targetStatus);
            stmt.setObject(3, LocalDateTime.now());
            stmt.setInt(4, liquidationId);
            return stmt.executeUpdate() > 0;
        }
    }

    public boolean updateCustomer(int liquidationId, int customerId) {
        String sql = "UPDATE liquidation SET customer_id = ? WHERE liquidation_id = ?";
        try {
            connection = getConnection();
            statement = connection.prepareStatement(sql);
            statement.setInt(1, customerId);
            statement.setInt(2, liquidationId);
            return statement.executeUpdate() > 0;
        } catch (Exception e) {
            SystemLogger.error(LogModule.LIQUIDATION, "Lỗi updateCustomer", e.getMessage(), e);
        } finally {
            closeResources();
        }
        return false;
    }

    public boolean updateCancel(int liquidationId) {
        String sql = "UPDATE liquidation SET status = 'CANCELLED', updated_at = ? WHERE liquidation_id = ?";
        try {
            connection = getConnection();
            statement = connection.prepareStatement(sql);
            statement.setObject(1, LocalDateTime.now());
            statement.setInt(2, liquidationId);
            return statement.executeUpdate() > 0;
        } catch (Exception e) {
            SystemLogger.error(LogModule.LIQUIDATION, "Lỗi updateCancel", e.getMessage(), e);
        } finally {
            closeResources();
        }
        return false;
    }

    @Override
    public boolean update(Liquidation t) {
        return false;
    }

    @Override
    public boolean delete(Liquidation t) {
        return false;
    }

    @Override
    public int insert(Liquidation t) {
        String sql = "INSERT INTO liquidation (liquidation_code, created_by, status, reason_id, warehouse_id, customer_id, created_at, updated_at) "
                + "VALUES (?, ?, 'PENDING_MANAGER', ?, ?, ?, ?, ?)";
        try {
            connection = getConnection();
            statement = connection.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS);
            statement.setString(1, t.getLiquidationCode());
            statement.setInt(2, t.getCreatedBy());
            statement.setInt(3, t.getReasonId());
            statement.setInt(4, t.getWarehouseId());
            if (t.getCustomerId() != null) {
                statement.setInt(5, t.getCustomerId());
            } else {
                statement.setNull(5, java.sql.Types.INTEGER);
            }
            LocalDateTime now = LocalDateTime.now();
            statement.setObject(6, now);
            statement.setObject(7, now);
            if (statement.executeUpdate() > 0) {
                resultSet = statement.getGeneratedKeys();
                if (resultSet.next()) {
                    return resultSet.getInt(1);
                }
            }
        } catch (Exception e) {
            SystemLogger.error(LogModule.LIQUIDATION, "Lỗi tạo đơn", e.getMessage(), e);
        } finally {
            closeResources();
        }
        return -1;
    }
}
