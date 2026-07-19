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

        l.setCeoReviewedBy(rs.getObject("ceo_reviewed_by", Integer.class));
        l.setCeoReviewedAt(rs.getObject("ceo_reviewed_at", LocalDateTime.class));
        l.setCeoFeedbackId(rs.getObject("ceo_feedback_id", Integer.class));
        l.setConvertedReceiptId(rs.getObject("converted_receipt_id", Integer.class));

        l.setCreatedAt(rs.getObject("created_at", LocalDateTime.class));
        l.setUpdatedAt(rs.getObject("updated_at", LocalDateTime.class));

        try {
            l.setCreatedByName(rs.getString("created_by_name"));

            l.setReasonName(rs.getString("reason_name"));
            l.setCeoFeedbackName(rs.getString("ceo_feedback_name"));

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
        StringBuilder sql = new StringBuilder("SELECT l.*, u.name AS created_by_name, c.name AS reason_name, w.name AS warehouse_name, cu.name AS customer_name, cu.phone AS customer_phone, cu.email AS customer_email, cu.address AS customer_address, f.name AS ceo_feedback_name, agg.detail_count, agg.total_original_price, agg.total_liquidation_price FROM liquidation l JOIN user u ON l.created_by = u.id JOIN category c ON l.reason_id = c.id JOIN warehouse w ON l.warehouse_id = w.warehouse_id LEFT JOIN customer cu ON l.customer_id = cu.id LEFT JOIN category f ON l.ceo_feedback_id = f.id LEFT JOIN (SELECT liquidation_id, COUNT(*) AS detail_count, SUM(original_price) AS total_original_price, SUM(liquidation_price) AS total_liquidation_price FROM liquidation_detail GROUP BY liquidation_id) agg ON agg.liquidation_id = l.liquidation_id WHERE 1=1");
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
                + "w.name AS warehouse_name, "
                + "cu.name AS customer_name, cu.phone AS customer_phone, cu.email AS customer_email, cu.address AS customer_address, "
                + "agg.detail_count, agg.total_original_price, agg.total_liquidation_price "
                + "FROM liquidation l "
                + "JOIN user u ON l.created_by = u.id "
                + "JOIN category c ON l.reason_id = c.id "
                + "JOIN warehouse w ON l.warehouse_id = w.warehouse_id "
                + "LEFT JOIN customer cu ON l.customer_id = cu.id "
                + "LEFT JOIN category f ON l.ceo_feedback_id = f.id "
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

    public boolean updateStatus(int liquidationId, String status, int reviewerId, Integer receiptId) {
        String sql = "UPDATE liquidation SET status = ?, ceo_reviewed_by = ?, ceo_reviewed_at = ?, updated_at = ?";
        if (receiptId != null) {
            sql += ", converted_receipt_id = ?";
        }
        sql += " WHERE liquidation_id = ?";

        try {
            connection = getConnection();
            statement = connection.prepareStatement(sql);
            LocalDateTime now = LocalDateTime.now();
            statement.setString(1, status);
            statement.setInt(2, reviewerId);
            statement.setObject(3, now);
            statement.setObject(4, now);
            if (receiptId != null) {
                statement.setInt(5, receiptId);
                statement.setInt(6, liquidationId);
            } else {
                statement.setInt(5, liquidationId);
            }
            return statement.executeUpdate() > 0;
        } catch (Exception e) {
            SystemLogger.error(LogModule.LIQUIDATION, "Lỗi updateStatus", e.getMessage(), e);
        } finally {
            closeResources();
        }
        return false;
    }

    public void updateStatus(Connection conn, int liquidationId, String status, Integer reviewerId, Integer receiptId) throws SQLException {
        String sql = "UPDATE liquidation SET status = ?, ceo_reviewed_by = ?, ceo_reviewed_at = ?, updated_at = ?";
        if (receiptId != null) {
            sql += ", converted_receipt_id = ?";
        }
        sql += " WHERE liquidation_id = ?";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            LocalDateTime now = LocalDateTime.now();
            ps.setString(1, status);
            if (reviewerId != null) {
                ps.setInt(2, reviewerId);
            } else {
                ps.setNull(2, java.sql.Types.INTEGER);
            }
            ps.setObject(3, now);
            ps.setObject(4, now);
            if (receiptId != null) {
                ps.setInt(5, receiptId);
                ps.setInt(6, liquidationId);
            } else {
                ps.setInt(5, liquidationId);
            }
            ps.executeUpdate();
        }
    }

    public boolean updateReject(int liquidationId, int ceoId, int feedbackId) {
        return updateCeoReject(liquidationId, ceoId, feedbackId, false);
    }

    public boolean updateCeoReject(int liquidationId, int ceoId, int feedbackId, boolean isPermanent) {
        String status = isPermanent ? "CANCELLED" : "CEO_REQUEST_EDIT";
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

    public boolean updateReasonAndStatus(int liquidationId, int reasonId, String targetStatus) {
        String sql = "UPDATE liquidation SET reason_id = ?, status = ?, "
                + "ceo_feedback_id = NULL, ceo_reviewed_by = NULL, ceo_reviewed_at = NULL, "
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

    @Override
    public boolean update(Liquidation t) {
        return false;
    }

    @Override
    public boolean delete(Liquidation t) {
        return false;
    }

    // ===================== BÁO CÁO THANH LÝ =====================
    // Tất cả query báo cáo chỉ tính đơn ĐÃ thanh lý hoàn tất (status = 'COMPLETED'):
    // máy đã xuất khỏi kho, giá trị thu hồi là tiền thật. Mốc thời gian dùng
    // ceo_reviewed_at (giữ nguyên khi đơn chuyển sang COMPLETED).
    // Lọc theo khoảng ngày + kho (tuỳ chọn).

    // Build mệnh đề WHERE chung + nạp tham số theo đúng thứ tự.
    // Dùng mốc receipt.approved_at (ngày xuất kho thực tế) thay vì ceo_reviewed_at.
    // Các query gọi buildReportWhere phải có JOIN receipt r ON l.converted_receipt_id = r.receipt_id trong FROM.
    private String buildReportWhere(java.time.LocalDate from, java.time.LocalDate to, Integer warehouseId, List<Object> params) {
        StringBuilder w = new StringBuilder(" WHERE l.status = 'COMPLETED'");
        if (from != null) {
            w.append(" AND DATE(r.approved_at) >= ?");
            params.add(java.sql.Date.valueOf(from));
        }
        if (to != null) {
            w.append(" AND DATE(r.approved_at) <= ?");
            params.add(java.sql.Date.valueOf(to));
        }
        if (warehouseId != null) {
            w.append(" AND l.warehouse_id = ?");
            params.add(warehouseId);
        }
        return w.toString();
    }

    private void bindParams(PreparedStatement ps, List<Object> params) throws SQLException {
        for (int i = 0; i < params.size(); i++) {
            ps.setObject(i + 1, params.get(i));
        }
    }

    // Tổng quan: số máy đã thanh lý, tổng nguyên giá, tổng giá thu hồi, tổn thất, % thu hồi.
    public Map<String, Object> getReportSummary(java.time.LocalDate from, java.time.LocalDate to, Integer warehouseId) {
        Map<String, Object> m = new java.util.HashMap<>();
        List<Object> params = new ArrayList<>();
        String where = buildReportWhere(from, to, warehouseId, params);
        String sql = "SELECT COUNT(ld.liquidation_detail_id) AS machine_count, "
                + "COALESCE(SUM(ld.original_price), 0) AS total_original, "
                + "COALESCE(SUM(ld.liquidation_price), 0) AS total_liquidation, "
                + "COUNT(DISTINCT l.liquidation_id) AS order_count "
                + "FROM liquidation l "
                + "JOIN receipt r ON l.converted_receipt_id = r.receipt_id "
                + "JOIN liquidation_detail ld ON ld.liquidation_id = l.liquidation_id"
                + where;
        try {
            connection = getConnection();
            statement = connection.prepareStatement(sql);
            bindParams(statement, params);
            resultSet = statement.executeQuery();
            java.math.BigDecimal totalOriginal = java.math.BigDecimal.ZERO;
            java.math.BigDecimal totalLiquidation = java.math.BigDecimal.ZERO;
            int machineCount = 0;
            int orderCount = 0;
            if (resultSet.next()) {
                machineCount = resultSet.getInt("machine_count");
                orderCount = resultSet.getInt("order_count");
                totalOriginal = resultSet.getBigDecimal("total_original");
                totalLiquidation = resultSet.getBigDecimal("total_liquidation");
            }
            java.math.BigDecimal loss = totalLiquidation.subtract(totalOriginal);
            double recoveryRate = totalOriginal.signum() > 0
                    ? totalLiquidation.multiply(new java.math.BigDecimal(100))
                            .divide(totalOriginal, 1, java.math.RoundingMode.HALF_UP).doubleValue()
                    : 0.0;
            m.put("machineCount", machineCount);
            m.put("orderCount", orderCount);
            m.put("totalOriginal", totalOriginal);
            m.put("totalLiquidation", totalLiquidation);
            m.put("totalLoss", loss);
            m.put("recoveryRate", recoveryRate);
        } catch (Exception e) {
            SystemLogger.error(LogModule.LIQUIDATION, "Lỗi getReportSummary", e.getMessage(), e);
        } finally {
            closeResources();
        }
        return m;
    }

    // Phân tích theo lý do thanh lý: lý do | số máy | nguyên giá | thu hồi | tổn thất.
    public List<Map<String, Object>> getReportByReason(java.time.LocalDate from, java.time.LocalDate to, Integer warehouseId) {
        List<Map<String, Object>> list = new ArrayList<>();
        List<Object> params = new ArrayList<>();
        String where = buildReportWhere(from, to, warehouseId, params);
        String sql = "SELECT c.name AS reason_name, COUNT(ld.liquidation_detail_id) AS machine_count, "
                + "COALESCE(SUM(ld.original_price), 0) AS total_original, "
                + "COALESCE(SUM(ld.liquidation_price), 0) AS total_liquidation "
                + "FROM liquidation l "
                + "JOIN receipt r ON l.converted_receipt_id = r.receipt_id "
                + "JOIN liquidation_detail ld ON ld.liquidation_id = l.liquidation_id "
                + "JOIN category c ON l.reason_id = c.id"
                + where
                + " GROUP BY l.reason_id, c.name ORDER BY total_original DESC";
        try {
            connection = getConnection();
            statement = connection.prepareStatement(sql);
            bindParams(statement, params);
            resultSet = statement.executeQuery();
            while (resultSet.next()) {
                Map<String, Object> r = new java.util.HashMap<>();
                java.math.BigDecimal orig = resultSet.getBigDecimal("total_original");
                java.math.BigDecimal liq = resultSet.getBigDecimal("total_liquidation");
                r.put("reasonName", resultSet.getString("reason_name"));
                r.put("machineCount", resultSet.getInt("machine_count"));
                r.put("totalOriginal", orig);
                r.put("totalLiquidation", liq);
                r.put("totalLoss", liq.subtract(orig));
                list.add(r);
            }
        } catch (Exception e) {
            SystemLogger.error(LogModule.LIQUIDATION, "Lỗi getReportByReason", e.getMessage(), e);
        } finally {
            closeResources();
        }
        return list;
    }

    // Phân tích theo kho: kho | số máy | nguyên giá | thu hồi | tổn thất | % thu hồi.
    public List<Map<String, Object>> getReportByWarehouse(java.time.LocalDate from, java.time.LocalDate to, Integer warehouseId) {
        List<Map<String, Object>> list = new ArrayList<>();
        List<Object> params = new ArrayList<>();
        String where = buildReportWhere(from, to, warehouseId, params);
        String sql = "SELECT w.name AS warehouse_name, COUNT(ld.liquidation_detail_id) AS machine_count, "
                + "COALESCE(SUM(ld.original_price), 0) AS total_original, "
                + "COALESCE(SUM(ld.liquidation_price), 0) AS total_liquidation "
                + "FROM liquidation l "
                + "JOIN receipt r ON l.converted_receipt_id = r.receipt_id "
                + "JOIN liquidation_detail ld ON ld.liquidation_id = l.liquidation_id "
                + "JOIN warehouse w ON l.warehouse_id = w.warehouse_id"
                + where
                + " GROUP BY l.warehouse_id, w.name ORDER BY total_original DESC";
        try {
            connection = getConnection();
            statement = connection.prepareStatement(sql);
            bindParams(statement, params);
            resultSet = statement.executeQuery();
            while (resultSet.next()) {
                Map<String, Object> r = new java.util.HashMap<>();
                java.math.BigDecimal orig = resultSet.getBigDecimal("total_original");
                java.math.BigDecimal liq = resultSet.getBigDecimal("total_liquidation");
                double rate = orig.signum() > 0
                        ? liq.multiply(new java.math.BigDecimal(100)).divide(orig, 1, java.math.RoundingMode.HALF_UP).doubleValue()
                        : 0.0;
                r.put("warehouseName", resultSet.getString("warehouse_name"));
                r.put("machineCount", resultSet.getInt("machine_count"));
                r.put("totalOriginal", orig);
                r.put("totalLiquidation", liq);
                r.put("totalLoss", liq.subtract(orig));
                r.put("recoveryRate", rate);
                list.add(r);
            }
        } catch (Exception e) {
            SystemLogger.error(LogModule.LIQUIDATION, "Lỗi getReportByWarehouse", e.getMessage(), e);
        } finally {
            closeResources();
        }
        return list;
    }

    // Top model bị thanh lý nhiều nhất: model | số máy | tổn thất.
    public List<Map<String, Object>> getReportByModel(java.time.LocalDate from, java.time.LocalDate to, Integer warehouseId, int limit) {
        List<Map<String, Object>> list = new ArrayList<>();
        List<Object> params = new ArrayList<>();
        String where = buildReportWhere(from, to, warehouseId, params);
        String sql = "SELECT g.model AS model_name, COUNT(ld.liquidation_detail_id) AS machine_count, "
                + "COALESCE(SUM(ld.original_price), 0) AS total_original, "
                + "COALESCE(SUM(ld.liquidation_price), 0) AS total_liquidation "
                + "FROM liquidation l "
                + "JOIN receipt r ON l.converted_receipt_id = r.receipt_id "
                + "JOIN liquidation_detail ld ON ld.liquidation_id = l.liquidation_id "
                + "JOIN generator g ON ld.generator_id = g.id"
                + where
                + " GROUP BY ld.generator_id, g.model ORDER BY machine_count DESC, total_original DESC LIMIT ?";
        params.add(limit);
        try {
            connection = getConnection();
            statement = connection.prepareStatement(sql);
            bindParams(statement, params);
            resultSet = statement.executeQuery();
            while (resultSet.next()) {
                Map<String, Object> r = new java.util.HashMap<>();
                java.math.BigDecimal orig = resultSet.getBigDecimal("total_original");
                java.math.BigDecimal liq = resultSet.getBigDecimal("total_liquidation");
                r.put("modelName", resultSet.getString("model_name"));
                r.put("machineCount", resultSet.getInt("machine_count"));
                r.put("totalOriginal", orig);
                r.put("totalLiquidation", liq);
                r.put("totalLoss", orig.subtract(liq));
                list.add(r);
            }
        } catch (Exception e) {
            SystemLogger.error(LogModule.LIQUIDATION, "Lỗi getReportByModel", e.getMessage(), e);
        } finally {
            closeResources();
        }
        return list;
    }

    // Xu hướng theo tháng: tháng (yyyy-MM) | số đơn | giá trị thanh lý.
    public List<Map<String, Object>> getReportMonthlyTrend(java.time.LocalDate from, java.time.LocalDate to, Integer warehouseId) {
        List<Map<String, Object>> list = new ArrayList<>();
        List<Object> params = new ArrayList<>();
        String where = buildReportWhere(from, to, warehouseId, params);
        String sql = "SELECT DATE_FORMAT(r.approved_at, '%Y-%m') AS ym, "
                + "COUNT(DISTINCT l.liquidation_id) AS order_count, "
                + "COUNT(ld.liquidation_detail_id) AS machine_count, "
                + "COALESCE(SUM(ld.original_price), 0) AS total_original, "
                + "COALESCE(SUM(ld.liquidation_price), 0) AS total_liquidation "
                + "FROM liquidation l "
                + "JOIN receipt r ON l.converted_receipt_id = r.receipt_id "
                + "JOIN liquidation_detail ld ON ld.liquidation_id = l.liquidation_id"
                + where
                + " GROUP BY ym ORDER BY ym ASC";
        try {
            connection = getConnection();
            statement = connection.prepareStatement(sql);
            bindParams(statement, params);
            resultSet = statement.executeQuery();
            while (resultSet.next()) {
                Map<String, Object> r = new java.util.HashMap<>();
                java.math.BigDecimal orig = resultSet.getBigDecimal("total_original");
                java.math.BigDecimal liq = resultSet.getBigDecimal("total_liquidation");
                r.put("month", resultSet.getString("ym"));
                r.put("orderCount", resultSet.getInt("order_count"));
                r.put("machineCount", resultSet.getInt("machine_count"));
                r.put("totalOriginal", orig);
                r.put("totalLiquidation", liq);
                r.put("totalLoss", liq.subtract(orig));
                list.add(r);
            }
        } catch (Exception e) {
            SystemLogger.error(LogModule.LIQUIDATION, "Lỗi getReportMonthlyTrend", e.getMessage(), e);
        } finally {
            closeResources();
        }
        return list;
    }

    // Chi tiết từng máy đã thanh lý (mỗi dòng = 1 máy) để xuất sheet "Chi tiết".
    // Cùng phạm vi lọc với các query báo cáo khác (COMPLETED, theo ngày + kho).
    public List<Map<String, Object>> getReportDetailList(java.time.LocalDate from, java.time.LocalDate to, Integer warehouseId) {
        return getReportDetailList(from, to, warehouseId, Integer.MAX_VALUE, 0);
    }

    public List<Map<String, Object>> getReportDetailList(java.time.LocalDate from, java.time.LocalDate to, Integer warehouseId, int limit, int offset) {
        List<Map<String, Object>> list = new ArrayList<>();
        List<Object> params = new ArrayList<>();
        String where = buildReportWhere(from, to, warehouseId, params);
        String sql = "SELECT l.liquidation_id, l.liquidation_code, ld.serial_number, g.model AS model_name, "
                + "w.name AS warehouse_name, c.name AS reason_name, "
                + "ld.original_price, ld.liquidation_price, "
                + "cu.name AS customer_name, ceo.name AS ceo_name, l.ceo_reviewed_at, r.approved_at AS export_at "
                + "FROM liquidation l "
                + "JOIN receipt r ON l.converted_receipt_id = r.receipt_id "
                + "JOIN liquidation_detail ld ON ld.liquidation_id = l.liquidation_id "
                + "JOIN generator g ON ld.generator_id = g.id "
                + "JOIN warehouse w ON l.warehouse_id = w.warehouse_id "
                + "JOIN category c ON l.reason_id = c.id "
                + "LEFT JOIN customer cu ON l.customer_id = cu.id "
                + "LEFT JOIN user ceo ON l.ceo_reviewed_by = ceo.id"
                + where
                + " ORDER BY r.approved_at DESC, l.liquidation_code, ld.serial_number"
                + " LIMIT ? OFFSET ?";
        params.add(limit);
        params.add(offset);
        try {
            connection = getConnection();
            statement = connection.prepareStatement(sql);
            bindParams(statement, params);
            resultSet = statement.executeQuery();
            java.time.format.DateTimeFormatter df = java.time.format.DateTimeFormatter.ofPattern("dd/MM/yyyy");
            while (resultSet.next()) {
                Map<String, Object> r = new java.util.HashMap<>();
                java.math.BigDecimal orig = resultSet.getBigDecimal("original_price");
                java.math.BigDecimal liq = resultSet.getBigDecimal("liquidation_price");
                if (orig == null) {
                    orig = java.math.BigDecimal.ZERO;
                }
                if (liq == null) {
                    liq = java.math.BigDecimal.ZERO;
                }
                r.put("liquidationId", resultSet.getInt("liquidation_id"));
                r.put("liquidationCode", resultSet.getString("liquidation_code"));
                r.put("serialNumber", resultSet.getString("serial_number"));
                r.put("modelName", resultSet.getString("model_name"));
                r.put("warehouseName", resultSet.getString("warehouse_name"));
                r.put("reasonName", resultSet.getString("reason_name"));
                r.put("originalPrice", orig);
                r.put("liquidationPrice", liq);
                r.put("totalLoss", liq.subtract(orig));
                r.put("customerName", resultSet.getString("customer_name"));
                r.put("ceoName", resultSet.getString("ceo_name"));
                java.time.LocalDateTime reviewedAt = resultSet.getObject("export_at", java.time.LocalDateTime.class);
                r.put("reviewedAtStr", reviewedAt != null ? reviewedAt.toLocalDate().format(df) : "");
                r.put("exportAtStr", reviewedAt != null ? reviewedAt.toLocalDate().format(df) : "");
                list.add(r);
            }
        } catch (Exception e) {
            SystemLogger.error(LogModule.LIQUIDATION, "Lỗi getReportDetailList", e.getMessage(), e);
        } finally {
            closeResources();
        }
        return list;
    }

    public int countReportDetailList(java.time.LocalDate from, java.time.LocalDate to, Integer warehouseId) {
        List<Object> params = new ArrayList<>();
        String where = buildReportWhere(from, to, warehouseId, params);
        String sql = "SELECT COUNT(*) FROM liquidation l "
                + "JOIN receipt r ON l.converted_receipt_id = r.receipt_id "
                + "JOIN liquidation_detail ld ON ld.liquidation_id = l.liquidation_id "
                + "JOIN generator g ON ld.generator_id = g.id "
                + "JOIN warehouse w ON l.warehouse_id = w.warehouse_id "
                + "JOIN category c ON l.reason_id = c.id "
                + "LEFT JOIN customer cu ON l.customer_id = cu.id "
                + "LEFT JOIN user ceo ON l.ceo_reviewed_by = ceo.id"
                + where;
        try {
            connection = getConnection();
            statement = connection.prepareStatement(sql);
            bindParams(statement, params);
            resultSet = statement.executeQuery();
            if (resultSet.next()) return resultSet.getInt(1);
        } catch (Exception e) {
            SystemLogger.error(LogModule.LIQUIDATION, "Lỗi countReportDetailList", e.getMessage(), e);
        } finally {
            closeResources();
        }
        return 0;
    }

    @Override
    public int insert(Liquidation t) {
        String sql = "INSERT INTO liquidation (liquidation_code, created_by, status, reason_id, warehouse_id, customer_id, created_at, updated_at) "
                + "VALUES (?, ?, ?, ?, ?, ?, ?, ?)";
        try {
            connection = getConnection();
            statement = connection.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS);
            LocalDateTime now = LocalDateTime.now();
            statement.setString(1, t.getLiquidationCode());
            statement.setInt(2, t.getCreatedBy());
            statement.setString(3, t.getStatus() != null ? t.getStatus() : "PENDING_CEO");
            statement.setInt(4, t.getReasonId());
            statement.setInt(5, t.getWarehouseId());
            if (t.getCustomerId() != null) {
                statement.setInt(6, t.getCustomerId());
            } else {
                statement.setNull(6, java.sql.Types.INTEGER);
            }
            statement.setObject(7, now);
            statement.setObject(8, now);
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

    public int countReportFlatTable(java.time.LocalDate from, java.time.LocalDate to, Integer warehouseId) {
        List<Object> params = new ArrayList<>();
        String where = buildReportWhere(from, to, warehouseId, params);
        String sql = "SELECT COUNT(*) FROM (SELECT l.liquidation_id "
                + "FROM liquidation l "
                + "JOIN receipt r ON l.converted_receipt_id = r.receipt_id "
                + "JOIN liquidation_detail ld ON ld.liquidation_id = l.liquidation_id "
                + "JOIN warehouse w ON l.warehouse_id = w.warehouse_id "
                + "JOIN category c ON l.reason_id = c.id "
                + "LEFT JOIN customer cu ON l.customer_id = cu.id "
                + "LEFT JOIN user cr ON l.created_by = cr.id "
                + "LEFT JOIN user ceo ON l.ceo_reviewed_by = ceo.id"
                + where
                + " GROUP BY l.liquidation_id) t";
        try {
            connection = getConnection();
            statement = connection.prepareStatement(sql);
            bindParams(statement, params);
            resultSet = statement.executeQuery();
            if (resultSet.next()) return resultSet.getInt(1);
        } catch (Exception e) {
            SystemLogger.error(LogModule.LIQUIDATION, "Lỗi countReportFlatTable", e.getMessage(), e);
        } finally {
            closeResources();
        }
        return 0;
    }

    public List<Map<String, Object>> getReportFlatTable(java.time.LocalDate from, java.time.LocalDate to, Integer warehouseId) {
        return getReportFlatTable(from, to, warehouseId, 0, Integer.MAX_VALUE);
    }

    public List<Map<String, Object>> getReportFlatTable(java.time.LocalDate from, java.time.LocalDate to, Integer warehouseId, int limit, int offset) {
        List<Map<String, Object>> list = new ArrayList<>();
        List<Object> params = new ArrayList<>();
        String where = buildReportWhere(from, to, warehouseId, params);
        String sql = "SELECT l.liquidation_id, l.liquidation_code, r.approved_at AS ceo_reviewed_at, "
                + "w.name AS warehouse_name, c.name AS reason_name, "
                + "COUNT(ld.liquidation_detail_id) AS machine_count, "
                + "COALESCE(SUM(ld.original_price), 0) AS total_original, "
                + "COALESCE(SUM(ld.liquidation_price), 0) AS total_liquidation, "
                + "cu.name AS customer_name, cr.name AS creator_name, ceo.name AS ceo_name "
                + "FROM liquidation l "
                + "JOIN receipt r ON l.converted_receipt_id = r.receipt_id "
                + "JOIN liquidation_detail ld ON ld.liquidation_id = l.liquidation_id "
                + "JOIN warehouse w ON l.warehouse_id = w.warehouse_id "
                + "JOIN category c ON l.reason_id = c.id "
                + "LEFT JOIN customer cu ON l.customer_id = cu.id "
                + "LEFT JOIN user cr ON l.created_by = cr.id "
                + "LEFT JOIN user ceo ON l.ceo_reviewed_by = ceo.id"
                + where
                + " GROUP BY l.liquidation_id ORDER BY r.approved_at DESC"
                + " LIMIT ? OFFSET ?";
        params.add(limit);
        params.add(offset);
        try {
            connection = getConnection();
            statement = connection.prepareStatement(sql);
            bindParams(statement, params);
            resultSet = statement.executeQuery();
            java.time.format.DateTimeFormatter df = java.time.format.DateTimeFormatter.ofPattern("dd/MM/yyyy");
            while (resultSet.next()) {
                Map<String, Object> r = new java.util.HashMap<>();
                java.math.BigDecimal orig = resultSet.getBigDecimal("total_original");
                java.math.BigDecimal liq = resultSet.getBigDecimal("total_liquidation");
                if (orig == null) orig = java.math.BigDecimal.ZERO;
                if (liq == null) liq = java.math.BigDecimal.ZERO;
                r.put("liquidationId", resultSet.getInt("liquidation_id"));
                r.put("liquidationCode", resultSet.getString("liquidation_code"));
                java.time.LocalDateTime reviewedAt = resultSet.getObject("ceo_reviewed_at", java.time.LocalDateTime.class);
                r.put("ceoReviewedAt", reviewedAt);
                r.put("reviewedAtStr", reviewedAt != null ? reviewedAt.format(df) : "");
                r.put("warehouseName", resultSet.getString("warehouse_name"));
                r.put("reasonName", resultSet.getString("reason_name"));
                r.put("machineCount", resultSet.getInt("machine_count"));
                r.put("totalOriginal", orig);
                r.put("totalLiquidation", liq);
                r.put("totalLoss", liq.subtract(orig));
                r.put("customerName", resultSet.getString("customer_name"));
                r.put("creatorName", resultSet.getString("creator_name"));
                r.put("ceoName", resultSet.getString("ceo_name"));
                list.add(r);
            }
        } catch (Exception e) {
            SystemLogger.error(LogModule.LIQUIDATION, "Lỗi getReportFlatTable", e.getMessage(), e);
        } finally {
            closeResources();
        }
        return list;
    }

    public List<Liquidation> findApprovedAvailableFiltered(String search, String fromDate, String toDate, int page, int pageSize) {
        List<Liquidation> list = new ArrayList<>();
        StringBuilder sql = new StringBuilder(
                "SELECT l.*, u.name AS created_by_name, c.name AS reason_name, f.name AS ceo_feedback_name, "
                + "w.name AS warehouse_name, "
                + "cu.name AS customer_name, cu.phone AS customer_phone, cu.email AS customer_email, cu.address AS customer_address, "
                + "agg.detail_count, agg.total_original_price, agg.total_liquidation_price "
                + "FROM liquidation l "
                + "JOIN user u ON l.created_by = u.id "
                + "JOIN category c ON l.reason_id = c.id "
                + "LEFT JOIN category f ON l.ceo_feedback_id = f.id "
                + "JOIN warehouse w ON l.warehouse_id = w.warehouse_id "
                + "LEFT JOIN customer cu ON l.customer_id = cu.id "
                + "LEFT JOIN (SELECT liquidation_id, COUNT(*) AS detail_count, SUM(original_price) AS total_original_price, SUM(liquidation_price) AS total_liquidation_price FROM liquidation_detail GROUP BY liquidation_id) agg ON agg.liquidation_id = l.liquidation_id "
                + "WHERE l.status = 'APPROVED' "
                + "AND NOT EXISTS ("
                + "  SELECT 1 FROM receipt r "
                + "  WHERE r.liquidation_id = l.liquidation_id AND r.status <> 'CANCELLED'"
                + ") ");
        List<Object> params = new ArrayList<>();
        if (search != null && !search.trim().isEmpty()) {
            sql.append("AND (l.liquidation_code LIKE ? OR cu.name LIKE ?) ");
            String like = "%" + search.trim() + "%";
            params.add(like);
            params.add(like);
        }
        if (fromDate != null && !fromDate.isEmpty()) {
            sql.append("AND DATE(l.ceo_reviewed_at) >= ? ");
            params.add(fromDate);
        }
        if (toDate != null && !toDate.isEmpty()) {
            sql.append("AND DATE(l.ceo_reviewed_at) <= ? ");
            params.add(toDate);
        }
        sql.append("ORDER BY l.ceo_reviewed_at DESC LIMIT ? OFFSET ?");
        params.add(pageSize);
        params.add((page - 1) * pageSize);
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
            SystemLogger.error(LogModule.LIQUIDATION, "Lỗi findApprovedAvailableFiltered", e.getMessage(), e);
        } finally {
            closeResources();
        }
        return list;
    }

    public int countApprovedAvailableFiltered(String search, String fromDate, String toDate) {
        StringBuilder sql = new StringBuilder(
                "SELECT COUNT(*) FROM liquidation l "
                + "JOIN user u ON l.created_by = u.id "
                + "LEFT JOIN customer cu ON l.customer_id = cu.id "
                + "WHERE l.status = 'APPROVED' "
                + "AND NOT EXISTS ("
                + "  SELECT 1 FROM receipt r "
                + "  WHERE r.liquidation_id = l.liquidation_id AND r.status <> 'CANCELLED'"
                + ") ");
        List<Object> params = new ArrayList<>();
        if (search != null && !search.trim().isEmpty()) {
            sql.append("AND (l.liquidation_code LIKE ? OR cu.name LIKE ?) ");
            String like = "%" + search.trim() + "%";
            params.add(like);
            params.add(like);
        }
        if (fromDate != null && !fromDate.isEmpty()) {
            sql.append("AND DATE(l.ceo_reviewed_at) >= ? ");
            params.add(fromDate);
        }
        if (toDate != null && !toDate.isEmpty()) {
            sql.append("AND DATE(l.ceo_reviewed_at) <= ? ");
            params.add(toDate);
        }
        try {
            connection = getConnection();
            statement = connection.prepareStatement(sql.toString());
            for (int i = 0; i < params.size(); i++) {
                statement.setObject(i + 1, params.get(i));
            }
            resultSet = statement.executeQuery();
            if (resultSet.next()) return resultSet.getInt(1);
        } catch (Exception e) {
            SystemLogger.error(LogModule.LIQUIDATION, "Lỗi countApprovedAvailableFiltered", e.getMessage(), e);
        } finally {
            closeResources();
        }
        return 0;
    }
<<<<<<< HEAD
}
=======
}
>>>>>>> 43e4ad0e5deebd88847eabeffbcf9cd1a13a3749
