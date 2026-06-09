package com.quanlymayphatdien.g1.dal;

import com.quanlymayphatdien.g1.entity.Liquidation;
import com.quanlymayphatdien.g1.utils.SystemLogger;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;

public class LiquidationDAO extends DBContext implements I_DAO<Liquidation> {


    @Override
    public Liquidation getFromResultSet(ResultSet rs) throws SQLException {
        Liquidation l = new Liquidation();
        l.setLiquidationId(rs.getInt("liquidation_id"));
        l.setLiquidationCode(rs.getString("liquidation_code"));
        l.setCreatedBy(rs.getInt("created_by"));
        l.setStatus(rs.getString("status"));
        l.setReasonId(rs.getInt("reason_id"));

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
        } catch (Exception e) {
        }
        try {
            l.setReasonName(rs.getString("reason_name"));
        } catch (Exception e) {
        }
        try {
            l.setCeoFeedbackName(rs.getString("ceo_feedback_name"));
        } catch (Exception e) {
        }
        try {
            l.setManagerFeedbackName(rs.getString("manager_feedback_name"));
        } catch (Exception e) {
        }

        return l;
    }

    @Override
    public List<Liquidation> findAll() {
        List<Liquidation> list = new ArrayList<>();
        String sql = "SELECT l.*, u.name AS created_by_name, c.name AS reason_name "
                + "FROM liquidation l "
                + "JOIN user u ON l.created_by = u.id "
                + "JOIN category c ON l.reason_id = c.id "
                + "ORDER BY l.created_at DESC";
        try (Connection c = getConnection(); PreparedStatement p = c.prepareStatement(sql); ResultSet rs = p.executeQuery()) {
            while (rs.next()) {
                list.add(getFromResultSet(rs));
            }
        } catch (Exception e) {
            SystemLogger.error("Liquidation", "Lỗi lấy danh sách", e.getMessage(), e);
        }
        return list;
    }

    public int countTotal(String search, String status) {
        StringBuilder sql = new StringBuilder("SELECT COUNT(*) FROM liquidation l JOIN user u ON l.created_by = u.id WHERE 1=1");
        List<Object> params = new ArrayList<>();
        if (search != null && !search.trim().isEmpty()) {
            sql.append(" AND (l.liquidation_code LIKE ? OR u.name LIKE ?)");
            params.add("%" + search.trim() + "%");
            params.add("%" + search.trim() + "%");
        }
        if (status != null && !status.trim().isEmpty()) {
            sql.append(" AND l.status = ?");
            params.add(status);
        }
        try (Connection c = getConnection(); PreparedStatement p = c.prepareStatement(sql.toString())) {
            for (int i = 0; i < params.size(); i++) {
                p.setObject(i + 1, params.get(i));
            }
            try (ResultSet rs = p.executeQuery()) {
                if (rs.next()) return rs.getInt(1);
            }
        } catch (Exception e) {
            SystemLogger.error("Liquidation", "Lỗi countTotal", e.getMessage(), e);
        }
        return 0;
    }

    public List<Liquidation> findWithPagination(int limit, int offset, String search, String status) {
        List<Liquidation> list = new ArrayList<>();
        StringBuilder sql = new StringBuilder("SELECT l.*, u.name AS created_by_name, c.name AS reason_name FROM liquidation l JOIN user u ON l.created_by = u.id JOIN category c ON l.reason_id = c.id WHERE 1=1");
        List<Object> params = new ArrayList<>();
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
        
        try (Connection c = getConnection(); PreparedStatement p = c.prepareStatement(sql.toString())) {
            for (int i = 0; i < params.size(); i++) {
                p.setObject(i + 1, params.get(i));
            }
            try (ResultSet rs = p.executeQuery()) {
                while (rs.next()) {
                    list.add(getFromResultSet(rs));
                }
            }
        } catch (Exception e) {
            SystemLogger.error("Liquidation", "Lỗi findWithPagination", e.getMessage(), e);
        }
        return list;
    }

    public java.util.Map<String, Integer> getKpiCounts() {
        java.util.Map<String, Integer> kpis = new java.util.HashMap<>();
        String sql = "SELECT status, COUNT(*) FROM liquidation GROUP BY status";
        try (Connection c = getConnection(); PreparedStatement p = c.prepareStatement(sql); ResultSet rs = p.executeQuery()) {
            while (rs.next()) {
                kpis.put(rs.getString(1), rs.getInt(2));
            }
        } catch (Exception e) {
            SystemLogger.error("Liquidation", "Lỗi getKpiCounts", e.getMessage(), e);
        }
        return kpis;
    }


    public Liquidation findById(int id) {
        String sql = "SELECT l.*, u.name AS created_by_name, c.name AS reason_name, f.name AS ceo_feedback_name, mf.name AS manager_feedback_name "
                + "FROM liquidation l "
                + "JOIN user u ON l.created_by = u.id "
                + "JOIN category c ON l.reason_id = c.id "
                + "LEFT JOIN category f ON l.ceo_feedback_id = f.id "
                + "LEFT JOIN category mf ON l.manager_feedback_id = mf.id "
                + "WHERE l.liquidation_id = ?";
        try (Connection c = getConnection(); PreparedStatement p = c.prepareStatement(sql)) {
            p.setInt(1, id);
            try (ResultSet rs = p.executeQuery()) {
                if (rs.next()) {
                    return getFromResultSet(rs);
                }
            }
        } catch (Exception e) {
            SystemLogger.error("Liquidation", "Lỗi findById", e.getMessage(), e);
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

        try (Connection c = getConnection(); PreparedStatement p = c.prepareStatement(sql)) {
            p.setString(1, status);
            LocalDateTime now = LocalDateTime.now();
            p.setObject(2, now);

            if (role.equals("manager")) {
                p.setInt(3, reviewerId);
                p.setObject(4, now);
                p.setInt(5, liquidationId);
            } else if (role.equals("ceo")) {
                p.setInt(3, reviewerId);
                p.setObject(4, now);
                if (receiptId != null) {
                    p.setInt(5, receiptId);
                } else {
                    p.setNull(5, java.sql.Types.INTEGER);
                }
                p.setInt(6, liquidationId);
            } else {
                p.setInt(3, liquidationId);
            }
            return p.executeUpdate() > 0;
        } catch (Exception e) {
            SystemLogger.error("Liquidation", "Lỗi updateStatus", e.getMessage(), e);
        }
        return false;
    }

    public boolean updateReject(int liquidationId, int ceoId, int feedbackId) {
        return updateCeoReject(liquidationId, ceoId, feedbackId, false);
    }

    public boolean updateCeoReject(int liquidationId, int ceoId, int feedbackId, boolean isPermanent) {
        String status = isPermanent ? "REJECTED_BY_CEO" : "CEO_REQUEST_EDIT";
        String sql = "UPDATE liquidation SET status = ?, ceo_reviewed_by = ?, ceo_reviewed_at = ?, ceo_feedback_id = ?, updated_at = ? WHERE liquidation_id = ?";
        try (Connection c = getConnection(); PreparedStatement p = c.prepareStatement(sql)) {
            LocalDateTime now = LocalDateTime.now();
            p.setString(1, status);
            p.setInt(2, ceoId);
            p.setObject(3, now);
            p.setInt(4, feedbackId);
            p.setObject(5, now);
            p.setInt(6, liquidationId);
            return p.executeUpdate() > 0;
        } catch (Exception e) {
            SystemLogger.error("Liquidation", "Lỗi updateCeoReject", e.getMessage(), e);
        }
        return false;
    }

    public boolean updateManagerReject(int liquidationId, int managerId, int feedbackId, boolean isPermanent) {
        String status = isPermanent ? "REJECTED_BY_MANAGER" : "MANAGER_REQUEST_EDIT";
        String sql = "UPDATE liquidation SET status = ?, manager_reviewed_by = ?, manager_reviewed_at = ?, manager_feedback_id = ?, updated_at = ? WHERE liquidation_id = ?";
        try (Connection c = getConnection(); PreparedStatement p = c.prepareStatement(sql)) {
            LocalDateTime now = LocalDateTime.now();
            p.setString(1, status);
            p.setInt(2, managerId);
            p.setObject(3, now);
            p.setInt(4, feedbackId);
            p.setObject(5, now);
            p.setInt(6, liquidationId);
            return p.executeUpdate() > 0;
        } catch (Exception e) {
            SystemLogger.error("Liquidation", "Lỗi updateManagerReject", e.getMessage(), e);
        }
        return false;
    }

    public boolean updateReasonAndStatus(int liquidationId, int reasonId) {
        String sql = "UPDATE liquidation SET reason_id = ?, status = 'PENDING_MANAGER', manager_feedback_id = NULL, manager_reviewed_by = NULL, manager_reviewed_at = NULL, updated_at = ? WHERE liquidation_id = ?";
        try (Connection c = getConnection(); PreparedStatement p = c.prepareStatement(sql)) {
            p.setInt(1, reasonId);
            p.setObject(2, LocalDateTime.now());
            p.setInt(3, liquidationId);
            return p.executeUpdate() > 0;
        } catch (Exception e) {
            SystemLogger.error("Liquidation", "Lỗi updateReasonAndStatus", e.getMessage(), e);
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
        String sql = "INSERT INTO liquidation (liquidation_code, created_by, status, reason_id, created_at, updated_at) "
                + "VALUES (?, ?, 'PENDING_MANAGER', ?, ?, ?)";
        try (Connection c = getConnection(); PreparedStatement p = c.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            p.setString(1, t.getLiquidationCode());
            p.setInt(2, t.getCreatedBy());
            p.setInt(3, t.getReasonId());
            LocalDateTime now = LocalDateTime.now();
            p.setObject(4, now);
            p.setObject(5, now);
            if (p.executeUpdate() > 0) {
                try (ResultSet rs = p.getGeneratedKeys()) {
                    if (rs.next()) {
                        return rs.getInt(1);
                    }
                }
            }
        } catch (Exception e) {
            SystemLogger.error("Liquidation", "Lỗi tạo đơn", e.getMessage(), e);
        }
        return -1;
    }
}
