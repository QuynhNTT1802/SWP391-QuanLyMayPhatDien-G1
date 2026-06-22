package com.quanlymayphatdien.g1.dal;

import com.quanlymayphatdien.g1.entity.ImportProposal;
import com.quanlymayphatdien.g1.entity.PurchaseOrder;
import com.quanlymayphatdien.g1.entity.PurchaseOrderDetail;
import com.quanlymayphatdien.g1.utils.GlobalUtils;
import java.sql.Connection;
import java.sql.Date;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

public class PurchaseOrderDAO extends DBContext implements I_DAO<PurchaseOrder> {

    public int insert(PurchaseOrder po) {
        int result = 0;
        String sql = "INSERT INTO purchase_order (po_code, period, period_start, period_end, "
                + "warehouse_id, status, created_by, note, total_proposals, total_quantity) "
                + "VALUES (?,?,?,?,?,?,?,?,?,?)";
        try {
            connection = getConnection();
            statement = connection.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS);
            statement.setString(1, po.getPoCode());
            statement.setString(2, po.getPeriod());
            statement.setDate(3, Date.valueOf(po.getPeriodStart()));
            statement.setDate(4, Date.valueOf(po.getPeriodEnd()));
            statement.setInt(5, po.getWarehouseId());
            statement.setString(6, po.getStatus());
            statement.setInt(7, po.getCreatedBy());
            statement.setString(8, po.getNote());
            statement.setInt(9, po.getTotalProposals());
            statement.setInt(10, po.getTotalQuantity());
            statement.executeUpdate();
            resultSet = statement.getGeneratedKeys();
            if (resultSet.next()) {
                result = resultSet.getInt(1);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            closeResources();
        }
        return result;
    }

    @Override
    public List<PurchaseOrder> findAll() {
        List<PurchaseOrder> list = new ArrayList<>();
        String sql = "SELECT p.*, w.name AS warehouse_name, u_c.name AS created_by_name "
                + "FROM purchase_order p "
                + "LEFT JOIN warehouse w ON w.warehouse_id = p.warehouse_id "
                + "LEFT JOIN user u_c ON u_c.id = p.created_by "
                + "ORDER BY p.created_at DESC";
        try {
            connection = getConnection();
            statement = connection.prepareStatement(sql);
            resultSet = statement.executeQuery();
            while (resultSet.next()) {
                list.add(getFromResultSet(resultSet));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            closeResources();
        }
        return list;
    }

    @Override
    public boolean update(PurchaseOrder t) {
        boolean result = false;
        String sql = "UPDATE purchase_order SET note = ?, status = ?, total_proposals = ?, total_quantity = ? "
                + "WHERE po_id = ? AND status = ?";
        try {
            connection = getConnection();
            statement = connection.prepareStatement(sql);
            statement.setString(1, t.getNote());
            statement.setString(2, t.getStatus());
            statement.setInt(3, t.getTotalProposals());
            statement.setInt(4, t.getTotalQuantity());
            statement.setInt(5, t.getPoId());
            statement.setString(6, GlobalUtils.PO_STATUS_DRAFT);
            result = statement.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            closeResources();
        }
        return result;
    }

    @Override
    public boolean delete(PurchaseOrder t) {
        try (Connection c = getConnection()) {
            c.setAutoCommit(false);
            try (PreparedStatement ps1 = c.prepareStatement(
                    "UPDATE import_proposal SET purchase_order_id = NULL WHERE purchase_order_id = ?")) {
                ps1.setInt(1, t.getPoId());
                ps1.executeUpdate();
            }
            try (PreparedStatement ps2 = c.prepareStatement(
                    "DELETE FROM purchase_order_detail WHERE po_id = ?")) {
                ps2.setInt(1, t.getPoId());
                ps2.executeUpdate();
            }
            try (PreparedStatement ps3 = c.prepareStatement(
                    "DELETE FROM purchase_order WHERE po_id = ? AND status = ?")) {
                ps3.setInt(1, t.getPoId());
                ps3.setString(2, GlobalUtils.PO_STATUS_DRAFT);
                if (ps3.executeUpdate() == 0) {
                    c.rollback();
                    return false;
                }
            }
            c.commit();
            return true;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    @Override
    public PurchaseOrder getFromResultSet(ResultSet rs) throws SQLException {
        PurchaseOrder po = new PurchaseOrder();
        po.setPoId(rs.getInt("po_id"));
        po.setPoCode(rs.getString("po_code"));
        po.setPeriod(rs.getString("period"));
        try {
            po.setPeriodStart(rs.getDate("period_start").toLocalDate());
            po.setPeriodEnd(rs.getDate("period_end").toLocalDate());
        } catch (SQLException | NullPointerException ignored) {
        }
        po.setWarehouseId(rs.getInt("warehouse_id"));
        po.setStatus(rs.getString("status"));
        po.setCreatedBy(rs.getInt("created_by"));
        try {
            int approvedBy = rs.getInt("approved_by");
            po.setApprovedBy(rs.wasNull() ? null : approvedBy);
        } catch (SQLException ignored) {
        }
        try {
            int rejectedBy = rs.getInt("rejected_by");
            po.setRejectedBy(rs.wasNull() ? null : rejectedBy);
        } catch (SQLException ignored) {
        }
        try {
            po.setRejectReason(rs.getString("reject_reason"));
        } catch (SQLException ignored) {
        }
        try {
            po.setCancelMode(rs.getString("cancel_mode"));
        } catch (SQLException ignored) {
        }
        try {
            po.setCancelReason(rs.getString("cancel_reason"));
        } catch (SQLException ignored) {
        }
        try {
            po.setTotalProposals(rs.getInt("total_proposals"));
        } catch (SQLException ignored) {
        }
        try {
            po.setTotalQuantity(rs.getInt("total_quantity"));
        } catch (SQLException ignored) {
        }
        try {
            po.setNote(rs.getString("note"));
        } catch (SQLException ignored) {
        }
        try {
            po.setWarehouseName(rs.getString("warehouse_name"));
        } catch (SQLException ignored) {
        }
        try {
            po.setCreatedByName(rs.getString("created_by_name"));
        } catch (SQLException ignored) {
        }
        try {
            Timestamp t = rs.getTimestamp("sent_to_ceo_at");
            if (t != null) {
                po.setSentToCeoAt(t.toLocalDateTime());
            }
        } catch (SQLException ignored) {
        }
        try {
            Timestamp t = rs.getTimestamp("approved_at");
            if (t != null) {
                po.setApprovedAt(t.toLocalDateTime());
            }
        } catch (SQLException ignored) {
        }
        try {
            Timestamp t = rs.getTimestamp("rejected_at");
            if (t != null) {
                po.setRejectedAt(t.toLocalDateTime());
            }
        } catch (SQLException ignored) {
        }
        try {
            Timestamp t = rs.getTimestamp("created_at");
            if (t != null) {
                po.setCreatedAt(t.toLocalDateTime());
            }
        } catch (SQLException ignored) {
        }
        try {
            Timestamp t = rs.getTimestamp("updated_at");
            if (t != null) {
                po.setUpdatedAt(t.toLocalDateTime());
            }
        } catch (SQLException ignored) {
        }
        return po;
    }

    public int createPoWithDetailsAndLinks(PurchaseOrder po, List<PurchaseOrderDetail> details, List<Integer> proposalIds) {
        if (po == null || details == null || details.isEmpty()) {
            return 0;
        }
        Connection c = null;
        try {
            c = getConnection();
            c.setAutoCommit(false);

            int poId;
            try (PreparedStatement ps = c.prepareStatement(
                    "INSERT INTO purchase_order (po_code, period, period_start, period_end, "
                    + "warehouse_id, status, created_by, note, total_proposals, total_quantity) "
                    + "VALUES (?,?,?,?,?,?,?,?,?,?)", Statement.RETURN_GENERATED_KEYS)) {
                ps.setString(1, po.getPoCode());
                ps.setString(2, po.getPeriod());
                ps.setDate(3, Date.valueOf(po.getPeriodStart()));
                ps.setDate(4, Date.valueOf(po.getPeriodEnd()));
                ps.setInt(5, po.getWarehouseId());
                ps.setString(6, po.getStatus());
                ps.setInt(7, po.getCreatedBy());
                ps.setString(8, po.getNote());
                ps.setInt(9, 0);
                ps.setInt(10, po.getTotalQuantity());
                ps.executeUpdate();
                ResultSet rs = ps.getGeneratedKeys();
                if (!rs.next()) {
                    c.rollback();
                    return 0;
                }
                poId = rs.getInt(1);
            }

            try (PreparedStatement ps = c.prepareStatement(
                    "INSERT INTO purchase_order_detail "
                    + "(po_id, generator_id, proposed_quantity, current_stock, unit_price, final_quantity, note) "
                    + "VALUES (?,?,?,?,?,?,?)")) {
                for (PurchaseOrderDetail d : details) {
                    ps.setInt(1, poId);
                    ps.setInt(2, d.getGeneratorId());
                    ps.setInt(3, d.getProposedQuantity());
                    ps.setInt(4, d.getCurrentStock());
                    if (d.getUnitPrice() != null) {
                        ps.setBigDecimal(5, d.getUnitPrice());
                    } else {
                        ps.setNull(5, java.sql.Types.DECIMAL);
                    }
                    ps.setInt(6, d.getFinalQuantity());
                    ps.setString(7, d.getNote());
                    ps.addBatch();
                }
                ps.executeBatch();
            }

            int linked = 0;
            if (proposalIds != null && !proposalIds.isEmpty()) {
                StringBuilder placeholders = new StringBuilder();
                for (int i = 0; i < proposalIds.size(); i++) {
                    if (i > 0) {
                        placeholders.append(",");
                    }
                    placeholders.append("?");
                }
                try (PreparedStatement ps = c.prepareStatement(
                        "UPDATE import_proposal SET purchase_order_id = ?, status = 'PENDING_CEO' "
                        + "WHERE proposal_id IN (" + placeholders + ") "
                        + "  AND status = 'APPROVED' "
                        + "  AND purchase_order_id IS NULL")) {
                    ps.setInt(1, poId);
                    for (int i = 0; i < proposalIds.size(); i++) {
                        ps.setInt(2 + i, proposalIds.get(i));
                    }
                    linked = ps.executeUpdate();
                }
            }

            try (PreparedStatement ps = c.prepareStatement(
                    "UPDATE purchase_order SET total_proposals = ? WHERE po_id = ?")) {
                ps.setInt(1, linked);
                ps.setInt(2, poId);
                ps.executeUpdate();
            }

            c.commit();
            return poId;
        } catch (SQLException e) {
            e.printStackTrace();
            try {
                if (c != null) {
                    c.rollback();
                }
            } catch (SQLException ex) {
                ex.printStackTrace();
            }
            // Surface the real DB error instead of silently returning 0 so the
            // controller can show a meaningful message (e.g. duplicate PO for the
            // same period + warehouse via uk_po_period_warehouse).
            throw new RuntimeException(translateSqlError(e), e);
        } finally {
            try {
                if (c != null) {
                    c.setAutoCommit(true);
                    c.close();
                }
            } catch (SQLException ex) {
                ex.printStackTrace();
            }
        }
    }

    /**
     * Convert a low-level SQLException into a user-friendly Vietnamese message
     * so the controller can show what actually went wrong instead of a generic
     * "Tạo phiếu mua thất bại".
     */
    private String translateSqlError(SQLException e) {
        String msg = e.getMessage() == null ? "" : e.getMessage();
        if (e instanceof java.sql.SQLIntegrityConstraintViolationException
                || e.getErrorCode() == 1062) {
            if (msg.contains("uk_po_period_warehouse")) {
                return "Đã tồn tại phiếu mua cho kỳ và kho này. Mỗi kỳ/kho chỉ được tạo 1 phiếu mua.";
            }
            if (msg.contains("uk_po_code")) {
                return "Mã phiếu mua đã tồn tại, vui lòng thử lại.";
            }
            if (msg.contains("uk_po_detail_generator")) {
                return "Có máy phát điện bị trùng trong danh sách chi tiết phiếu mua.";
            }
            return "Dữ liệu phiếu mua bị trùng (vi phạm ràng buộc duy nhất).";
        }
        // Foreign key violations (1452) or other DB errors
        return "Lỗi cơ sở dữ liệu khi tạo phiếu mua: " + msg;
    }

    public void insertDetails(int poId, List<PurchaseOrderDetail> details) {
        String sql = "INSERT INTO purchase_order_detail "
                + "(po_id, generator_id, proposed_quantity, current_stock, unit_price, final_quantity, note) "
                + "VALUES (?,?,?,?,?,?,?)";
        try (Connection c = getConnection(); PreparedStatement ps = c.prepareStatement(sql)) {
            for (PurchaseOrderDetail d : details) {
                ps.setInt(1, poId);
                ps.setInt(2, d.getGeneratorId());
                ps.setInt(3, d.getProposedQuantity());
                ps.setInt(4, d.getCurrentStock());
                if (d.getUnitPrice() != null) {
                    ps.setBigDecimal(5, d.getUnitPrice());
                } else {
                    ps.setNull(5, java.sql.Types.DECIMAL);
                }
                ps.setInt(6, d.getFinalQuantity());
                ps.setString(7, d.getNote());
                ps.addBatch();
            }
            ps.executeBatch();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    public String generatePoCode(String period) {
        String prefix = "PO-" + period + "-";
        String sql = "SELECT po_code FROM purchase_order WHERE po_code LIKE ? ORDER BY po_id DESC LIMIT 1";
        try {
            connection = getConnection();
            statement = connection.prepareStatement(sql);
            statement.setString(1, prefix + "%");
            resultSet = statement.executeQuery();
            int n = 1;
            if (resultSet.next()) {
                String last = resultSet.getString(1);
                n = Integer.parseInt(last.substring(last.lastIndexOf("-") + 1)) + 1;
            }
            return prefix + String.format("%03d", n);
        } catch (SQLException e) {
            e.printStackTrace();
            return prefix + "001";
        } finally {
            closeResources();
        }
    }

    public PurchaseOrder findById(int poId) {
        String sql = "SELECT p.*, w.name AS warehouse_name, u_c.name AS created_by_name, "
                + "u_a.name AS approved_by_name, u_r.name AS rejected_by_name "
                + "FROM purchase_order p "
                + "LEFT JOIN warehouse w ON w.warehouse_id = p.warehouse_id "
                + "LEFT JOIN user u_c ON u_c.id = p.created_by "
                + "LEFT JOIN user u_a ON u_a.id = p.approved_by "
                + "LEFT JOIN user u_r ON u_r.id = p.rejected_by "
                + "WHERE p.po_id = ?";
        try {
            connection = getConnection();
            statement = connection.prepareStatement(sql);
            statement.setInt(1, poId);
            resultSet = statement.executeQuery();
            if (resultSet.next()) {
                PurchaseOrder po = new PurchaseOrder();
                po.setPoId(resultSet.getInt("po_id"));
                po.setPoCode(resultSet.getString("po_code"));
                po.setPeriod(resultSet.getString("period"));
                po.setPeriodStart(resultSet.getDate("period_start").toLocalDate());
                po.setPeriodEnd(resultSet.getDate("period_end").toLocalDate());
                po.setWarehouseId(resultSet.getInt("warehouse_id"));
                po.setStatus(resultSet.getString("status"));
                po.setCreatedBy(resultSet.getInt("created_by"));
                int approvedBy = resultSet.getInt("approved_by");
                po.setApprovedBy(resultSet.wasNull() ? null : approvedBy);
                int rejectedBy = resultSet.getInt("rejected_by");
                po.setRejectedBy(resultSet.wasNull() ? null : rejectedBy);
                po.setRejectReason(resultSet.getString("reject_reason"));
                try {
                    po.setCancelMode(resultSet.getString("cancel_mode"));
                } catch (SQLException ignored) {
                }
                try {
                    po.setCancelReason(resultSet.getString("cancel_reason"));
                } catch (SQLException ignored) {
                }
                po.setTotalProposals(rs.getInt("total_proposals"));
                po.setTotalQuantity(rs.getInt("total_quantity"));
                po.setNote(rs.getString("note"));
                po.setWarehouseName(rs.getString("warehouse_name"));
                po.setCreatedByName(rs.getString("created_by_name"));
                try {
                    po.setApprovedByName(rs.getString("approved_by_name"));
                } catch (SQLException ignored) {
                }
                try {
                    po.setRejectedByName(rs.getString("rejected_by_name"));
                } catch (SQLException ignored) {
                }
                Timestamp stc = rs.getTimestamp("sent_to_ceo_at");
                if (stc != null) {
                    po.setSentToCeoAt(stc.toLocalDateTime());
                }
                Timestamp sta = resultSet.getTimestamp("approved_at");
                if (sta != null) {
                    po.setApprovedAt(sta.toLocalDateTime());
                }
                Timestamp str = resultSet.getTimestamp("rejected_at");
                if (str != null) {
                    po.setRejectedAt(str.toLocalDateTime());
                }
                po.setCreatedAt(resultSet.getTimestamp("created_at").toLocalDateTime());
                po.setUpdatedAt(resultSet.getTimestamp("updated_at").toLocalDateTime());
                po.setDetails(findDetails(poId));
                result = po;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            closeResources();
        }
        return result;
    }

    public List<PurchaseOrderDetail> findDetails(int poId) {
        List<PurchaseOrderDetail> list = new ArrayList<>();
        String sql = "SELECT d.*, g.model AS generator_code, g.description AS generator_name, "
                + "(SELECT c.name FROM generator_category gc "
                + "   JOIN category c ON c.id = gc.category_id "
                + "  WHERE gc.generator_id = g.id AND c.type = 'brand' LIMIT 1) AS brand_name "
                + "FROM purchase_order_detail d "
                + "JOIN generator g ON g.id = d.generator_id "
                + "WHERE d.po_id = ?";
        try {
            connection = getConnection();
            statement = connection.prepareStatement(sql);
            statement.setInt(1, poId);
            resultSet = statement.executeQuery();
            while (resultSet.next()) {
                PurchaseOrderDetail d = new PurchaseOrderDetail();
                d.setPoDetailId(resultSet.getInt("po_detail_id"));
                d.setPoId(resultSet.getInt("po_id"));
                d.setGeneratorId(resultSet.getInt("generator_id"));
                d.setProposedQuantity(resultSet.getInt("proposed_quantity"));
                d.setCurrentStock(resultSet.getInt("current_stock"));
                d.setFinalQuantity(resultSet.getInt("final_quantity"));
                d.setUnitPrice(resultSet.getBigDecimal("unit_price"));
                d.setNote(resultSet.getString("note"));
                d.setGeneratorCode(resultSet.getString("generator_code"));
                d.setGeneratorName(resultSet.getString("generator_name"));
                d.setBrandName(resultSet.getString("brand_name"));
                list.add(d);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            closeResources();
        }
        return list;
    }

    public java.math.BigDecimal getLatestUnitPriceByGeneratorId(int generatorId) {
        java.math.BigDecimal result = null;
        String sql = "SELECT d.unit_price FROM purchase_order_detail d "
                + "JOIN purchase_order p ON p.po_id = d.po_id "
                + "WHERE d.generator_id = ? AND d.unit_price IS NOT NULL "
                + "ORDER BY p.created_at DESC LIMIT 1";
        try {
            connection = getConnection();
            statement = connection.prepareStatement(sql);
            statement.setInt(1, generatorId);
            resultSet = statement.executeQuery();
            if (resultSet.next()) {
                result = resultSet.getBigDecimal("unit_price");
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            closeResources();
        }
        return result;
    }

    public List<PurchaseOrder> findByFilters(String dateFrom, String dateTo, int warehouseId, String status, int page, int pageSize) {
        List<PurchaseOrder> list = new ArrayList<>();
        StringBuilder sql = new StringBuilder(
                "SELECT p.*, w.name AS warehouse_name, u_c.name AS created_by_name "
                + "FROM purchase_order p "
                + "LEFT JOIN warehouse w ON w.warehouse_id = p.warehouse_id "
                + "LEFT JOIN user u_c ON u_c.id = p.created_by WHERE 1=1");
        List<Object> params = new ArrayList<>();
        if (dateFrom != null && !dateFrom.isEmpty()) {
            sql.append(" AND p.period_start >= ?");
            params.add(java.sql.Date.valueOf(java.time.LocalDate.parse(dateFrom)));
        }
        if (dateTo != null && !dateTo.isEmpty()) {
            sql.append(" AND p.period_start <= ?");
            params.add(java.sql.Date.valueOf(java.time.LocalDate.parse(dateTo)));
        }
        if (warehouseId > 0) {
            sql.append(" AND p.warehouse_id = ?");
            params.add(warehouseId);
        }
        if (status != null && !status.isEmpty()) {
            sql.append(" AND p.status = ?");
            params.add(status);
        }
        sql.append(" ORDER BY p.created_at DESC LIMIT ? OFFSET ?");
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
                PurchaseOrder po = new PurchaseOrder();
                po.setPoId(resultSet.getInt("po_id"));
                po.setPoCode(resultSet.getString("po_code"));
                po.setPeriod(resultSet.getString("period"));
                po.setWarehouseId(resultSet.getInt("warehouse_id"));
                po.setStatus(resultSet.getString("status"));
                po.setTotalProposals(resultSet.getInt("total_proposals"));
                po.setTotalQuantity(resultSet.getInt("total_quantity"));
                po.setWarehouseName(resultSet.getString("warehouse_name"));
                po.setCreatedByName(resultSet.getString("created_by_name"));
                po.setCreatedAt(resultSet.getTimestamp("created_at").toLocalDateTime());
                list.add(po);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            closeResources();
        }
        return list;
    }

    public int countByFilters(String dateFrom, String dateTo, int warehouseId, String status) {
        int result = 0;
        StringBuilder sql = new StringBuilder("SELECT COUNT(*) FROM purchase_order WHERE 1=1");
        List<Object> params = new ArrayList<>();
        if (dateFrom != null && !dateFrom.isEmpty()) {
            sql.append(" AND period_start >= ?");
            params.add(java.sql.Date.valueOf(java.time.LocalDate.parse(dateFrom)));
        }
        if (dateTo != null && !dateTo.isEmpty()) {
            sql.append(" AND period_start <= ?");
            params.add(java.sql.Date.valueOf(java.time.LocalDate.parse(dateTo)));
        }
        if (warehouseId > 0) {
            sql.append(" AND warehouse_id = ?");
            params.add(warehouseId);
        }
        if (status != null && !status.isEmpty()) {
            sql.append(" AND status = ?");
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
                result = resultSet.getInt(1);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            closeResources();
        }
        return result;
    }

    public List<PurchaseOrder> findApprovedAvailableFiltered(String search, String fromDate, String toDate, int page, int pageSize) {
        List<PurchaseOrder> list = new ArrayList<>();
        StringBuilder sql = new StringBuilder(
                "SELECT p.*, w.name AS warehouse_name, u_c.name AS created_by_name "
                + "FROM purchase_order p "
                + "LEFT JOIN warehouse w ON w.warehouse_id = p.warehouse_id "
                + "LEFT JOIN user u_c ON u_c.id = p.created_by "
                + "WHERE p.status = 'APPROVED' "
                + "AND NOT EXISTS ("
                + "  SELECT 1 FROM receipt r "
                + "  WHERE r.purchase_order_id = p.po_id AND r.status <> 'CANCELLED'"
                + ") ");
        List<Object> params = new ArrayList<>();
        if (search != null && !search.trim().isEmpty()) {
            sql.append("AND p.po_code LIKE ? ");
            params.add("%" + search.trim() + "%");
        }
        if (fromDate != null && !fromDate.isEmpty()) {
            sql.append("AND DATE(p.approved_at) >= ? ");
            params.add(fromDate);
        }
        if (toDate != null && !toDate.isEmpty()) {
            sql.append("AND DATE(p.approved_at) <= ? ");
            params.add(toDate);
        }
        sql.append("ORDER BY p.approved_at DESC LIMIT ? OFFSET ?");
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
                PurchaseOrder po = new PurchaseOrder();
                po.setPoId(resultSet.getInt("po_id"));
                po.setPoCode(resultSet.getString("po_code"));
                po.setPeriod(resultSet.getString("period"));
                po.setPeriodStart(resultSet.getDate("period_start").toLocalDate());
                po.setPeriodEnd(resultSet.getDate("period_end").toLocalDate());
                po.setWarehouseId(resultSet.getInt("warehouse_id"));
                po.setStatus(resultSet.getString("status"));
                po.setTotalProposals(resultSet.getInt("total_proposals"));
                po.setTotalQuantity(resultSet.getInt("total_quantity"));
                po.setWarehouseName(resultSet.getString("warehouse_name"));
                po.setCreatedByName(resultSet.getString("created_by_name"));
                po.setNote(resultSet.getString("note"));
                Timestamp ca = resultSet.getTimestamp("created_at");
                if (ca != null) po.setCreatedAt(ca.toLocalDateTime());
                Timestamp aa = resultSet.getTimestamp("approved_at");
                if (aa != null) po.setApprovedAt(aa.toLocalDateTime());
                list.add(po);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            closeResources();
        }
        return list;
    }

    public int countApprovedAvailableFiltered(String search, String fromDate, String toDate) {
        int result = 0;
        StringBuilder sql = new StringBuilder(
                "SELECT COUNT(*) FROM purchase_order p "
                + "WHERE p.status = 'APPROVED' "
                + "AND NOT EXISTS ("
                + "  SELECT 1 FROM receipt r "
                + "  WHERE r.purchase_order_id = p.po_id AND r.status <> 'CANCELLED'"
                + ") ");
        List<Object> params = new ArrayList<>();
        if (search != null && !search.trim().isEmpty()) {
            sql.append("AND p.po_code LIKE ? ");
            params.add("%" + search.trim() + "%");
        }
        if (fromDate != null && !fromDate.isEmpty()) {
            sql.append("AND DATE(p.approved_at) >= ? ");
            params.add(fromDate);
        }
        if (toDate != null && !toDate.isEmpty()) {
            sql.append("AND DATE(p.approved_at) <= ? ");
            params.add(toDate);
        }
        try {
            connection = getConnection();
            statement = connection.prepareStatement(sql.toString());
            for (int i = 0; i < params.size(); i++) {
                statement.setObject(i + 1, params.get(i));
            }
            resultSet = statement.executeQuery();
            if (resultSet.next()) {
                result = resultSet.getInt(1);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            closeResources();
        }
        return result;
    }

    public List<Map<String, Object>> aggregatePendingProposals(String period, int warehouseId) {
        List<Map<String, Object>> list = new ArrayList<>();
        String sql = "SELECT ipd.generator_id, g.model AS generator_code, g.description AS generator_name, "
                + "(SELECT c.name FROM generator_category gc "
                + "   JOIN category c ON c.id = gc.category_id "
                + "  WHERE gc.generator_id = g.id AND c.type = 'brand' LIMIT 1) AS brand_name, "
                + "SUM(ipd.quantity) AS total_proposed, "
                + "COUNT(DISTINCT ip.proposal_id) AS proposal_count, "
                + "COALESCE((SELECT COUNT(*) FROM inventory i "
                + "          WHERE i.generator_id = ipd.generator_id AND i.warehouse_id = ? AND i.status = 'IN_STOCK'), 0) AS current_stock "
                + "FROM import_proposal ip "
                + "JOIN import_proposal_detail ipd ON ipd.proposal_id = ip.proposal_id "
                + "JOIN generator g ON g.id = ipd.generator_id "
                + "WHERE ip.period = ? AND ip.warehouse_id = ? AND ip.status = 'APPROVED' AND ip.purchase_order_id IS NULL "
                + "GROUP BY ipd.generator_id, g.model, g.description "
                + "ORDER BY g.description";
        try {
            connection = getConnection();
            statement = connection.prepareStatement(sql);
            statement.setInt(1, warehouseId);
            statement.setString(2, period);
            statement.setInt(3, warehouseId);
            resultSet = statement.executeQuery();
            while (resultSet.next()) {
                Map<String, Object> row = new LinkedHashMap<>();
                row.put("generatorId", resultSet.getInt("generator_id"));
                row.put("generatorCode", resultSet.getString("generator_code"));
                row.put("generatorName", resultSet.getString("generator_name"));
                row.put("brandName", resultSet.getString("brand_name"));
                row.put("totalProposed", resultSet.getInt("total_proposed"));
                row.put("currentStock", resultSet.getInt("current_stock"));
                row.put("proposalCount", resultSet.getInt("proposal_count"));
                list.add(row);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            closeResources();
        }
        return list;
    }

    public List<Map<String, Object>> aggregateByProposalIds(List<Integer> proposalIds, int warehouseId) {
        if (proposalIds == null || proposalIds.isEmpty()) {
            return new ArrayList<>();
        }
        List<Map<String, Object>> list = new ArrayList<>();
        StringBuilder placeholders = new StringBuilder();
        for (int i = 0; i < proposalIds.size(); i++) {
            if (i > 0) {
                placeholders.append(",");
            }
            placeholders.append("?");
        }

        String sql = "SELECT ipd.generator_id, g.model AS generator_code, g.description AS generator_name, "
                + "(SELECT c.name FROM generator_category gc "
                + "   JOIN category c ON c.id = gc.category_id "
                + "  WHERE gc.generator_id = g.id AND c.type = 'brand' LIMIT 1) AS brand_name, "
                + "SUM(ipd.quantity) AS total_proposed, "
                + "COUNT(DISTINCT ip.proposal_id) AS proposal_count, "
                + "COALESCE((SELECT COUNT(*) FROM inventory i "
                + "          WHERE i.generator_id = ipd.generator_id AND i.warehouse_id = ? AND i.status = 'IN_STOCK'), 0) AS current_stock "
                + "FROM import_proposal ip "
                + "JOIN import_proposal_detail ipd ON ipd.proposal_id = ip.proposal_id "
                + "JOIN generator g ON g.id = ipd.generator_id "
                + "WHERE ip.proposal_id IN (" + placeholders + ") "
                + "  AND ip.status = 'APPROVED' "
                + "  AND ip.purchase_order_id IS NULL "
                + "  AND ip.warehouse_id = ? "
                + "GROUP BY ipd.generator_id, g.model, g.description "
                + "ORDER BY g.description";

        try {
            connection = getConnection();
            statement = connection.prepareStatement(sql);
            statement.setInt(1, warehouseId);
            for (int i = 0; i < proposalIds.size(); i++) {
                statement.setInt(i + 2, proposalIds.get(i));
            }
            statement.setInt(proposalIds.size() + 2, warehouseId);
            resultSet = statement.executeQuery();
            while (resultSet.next()) {
                Map<String, Object> row = new LinkedHashMap<>();
                row.put("generatorId", resultSet.getInt("generator_id"));
                row.put("generatorCode", resultSet.getString("generator_code"));
                row.put("generatorName", resultSet.getString("generator_name"));
                row.put("brandName", resultSet.getString("brand_name"));
                row.put("totalProposed", resultSet.getInt("total_proposed"));
                row.put("currentStock", resultSet.getInt("current_stock"));
                row.put("proposalCount", resultSet.getInt("proposal_count"));
                list.add(row);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            closeResources();
        }
        return list;
    }

    public int linkProposalsToPo(int poId, String period, int warehouseId, List<Integer> generatorIds) {
        if (generatorIds == null || generatorIds.isEmpty()) {
            return 0;
        }
        int result = 0;
        StringBuilder placeholders = new StringBuilder();
        for (int i = 0; i < generatorIds.size(); i++) {
            if (i > 0) {
                placeholders.append(",");
            }
            placeholders.append("?");
        }
        String sql = "UPDATE import_proposal SET purchase_order_id = ?, status = 'PENDING_CEO' "
                + "WHERE period = ? AND warehouse_id = ? AND status = 'APPROVED' "
                + "AND purchase_order_id IS NULL "
                + "AND proposal_id IN ("
                + "  SELECT DISTINCT ipd.proposal_id FROM import_proposal_detail ipd "
                + "  WHERE ipd.generator_id IN (" + placeholders + ")"
                + ")";
        try {
            connection = getConnection();
            statement = connection.prepareStatement(sql);
            statement.setInt(1, poId);
            statement.setString(2, period);
            statement.setInt(3, warehouseId);
            for (int i = 0; i < generatorIds.size(); i++) {
                statement.setInt(4 + i, generatorIds.get(i));
            }
            result = statement.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            closeResources();
        }
        return result;
    }

    public int linkProposalsByIds(int poId, List<Integer> proposalIds) {
        if (proposalIds == null || proposalIds.isEmpty()) {
            return 0;
        }
        int result = 0;
        StringBuilder placeholders = new StringBuilder();
        for (int i = 0; i < proposalIds.size(); i++) {
            if (i > 0) {
                placeholders.append(",");
            }
            placeholders.append("?");
        }
        String sql = "UPDATE import_proposal SET purchase_order_id = ?, status = 'PENDING_CEO' "
                + "WHERE proposal_id IN (" + placeholders + ") "
                + "AND status = 'APPROVED' "
                + "AND purchase_order_id IS NULL";
        try {
            connection = getConnection();
            statement = connection.prepareStatement(sql);
            statement.setInt(1, poId);
            for (int i = 0; i < proposalIds.size(); i++) {
                statement.setInt(2 + i, proposalIds.get(i));
            }
            result = statement.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            closeResources();
        }
        return result;
    }

    public boolean updateTotalProposals(int poId, int total) {
        boolean result = false;
        String sql = "UPDATE purchase_order SET total_proposals = ? WHERE po_id = ?";
        try {
            connection = getConnection();
            statement = connection.prepareStatement(sql);
            statement.setInt(1, total);
            statement.setInt(2, poId);
            result = statement.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            closeResources();
        }
        return result;
    }

    public boolean sendToCeo(int poId) {
        try (Connection c = getConnection()) {
            c.setAutoCommit(false);
            try (PreparedStatement ps1 = c.prepareStatement(
                    "UPDATE purchase_order SET status = ?, sent_to_ceo_at = NOW() "
                    + "WHERE po_id = ? AND status = ?")) {
                ps1.setString(1, GlobalUtils.PO_STATUS_PENDING_CEO);
                ps1.setInt(2, poId);
                ps1.setString(3, GlobalUtils.PO_STATUS_DRAFT);
                if (ps1.executeUpdate() == 0) {
                    c.rollback();
                    return false;
                }
            }
            try (PreparedStatement ps2 = c.prepareStatement(
                    "UPDATE import_proposal SET status = ? "
                    + "WHERE purchase_order_id = ? AND status = ?")) {
                ps2.setString(1, GlobalUtils.PROPOSAL_STATUS_PENDING_CEO);
                ps2.setInt(2, poId);
                ps2.setString(3, GlobalUtils.STATUS_APPROVED);
                ps2.executeUpdate();
            }
            c.commit();
            return true;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public boolean approve(int poId, int ceoId) {
        try (Connection c = getConnection()) {
            c.setAutoCommit(false);
            try (PreparedStatement ps1 = c.prepareStatement(
                    "UPDATE purchase_order SET status = ?, approved_by = ?, approved_at = NOW() "
                    + "WHERE po_id = ? AND status = ?")) {
                ps1.setString(1, GlobalUtils.PO_STATUS_APPROVED);
                ps1.setInt(2, ceoId);
                ps1.setInt(3, poId);
                ps1.setString(4, GlobalUtils.PO_STATUS_PENDING_CEO);
                if (ps1.executeUpdate() == 0) {
                    c.rollback();
                    return false;
                }
            }
            try (PreparedStatement ps2 = c.prepareStatement(
                    "UPDATE import_proposal SET status = ? "
                    + "WHERE purchase_order_id = ?")) {
                ps2.setString(1, GlobalUtils.STATUS_APPROVED);
                ps2.setInt(2, poId);
                ps2.executeUpdate();
            }
            c.commit();
            return true;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public boolean reject(int poId, int ceoId, String reason) {
        try (Connection c = getConnection()) {
            c.setAutoCommit(false);
            try (PreparedStatement ps1 = c.prepareStatement(
                    "UPDATE purchase_order SET status = ?, rejected_by = ?, rejected_at = NOW(), reject_reason = ? "
                    + "WHERE po_id = ? AND status = ?")) {
                ps1.setString(1, GlobalUtils.PO_STATUS_REJECTED);
                ps1.setInt(2, ceoId);
                ps1.setString(3, reason);
                ps1.setInt(4, poId);
                ps1.setString(5, GlobalUtils.PO_STATUS_PENDING_CEO);
                if (ps1.executeUpdate() == 0) {
                    c.rollback();
                    return false;
                }
            }
            try (PreparedStatement ps2 = c.prepareStatement(
                    "UPDATE import_proposal SET status = ?, reject_reason = ? "
                    + "WHERE purchase_order_id = ?")) {
                ps2.setString(1, GlobalUtils.STATUS_REJECTED);
                ps2.setString(2, reason);
                ps2.setInt(3, poId);
                ps2.executeUpdate();
            }
            c.commit();
            return true;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public boolean returnPo(int poId, int ceoId, String reason) {
        if (poId <= 0 || ceoId <= 0 || reason == null || reason.trim().isEmpty()) {
            return false;
        }
        try (Connection c = getConnection()) {
            c.setAutoCommit(false);
            try (PreparedStatement ps1 = c.prepareStatement(
                    "UPDATE purchase_order SET status = ?, reject_reason = ?, "
                    + "rejected_by = ?, rejected_at = NOW() "
                    + "WHERE po_id = ? AND status = ?")) {
                ps1.setString(1, GlobalUtils.PO_STATUS_RETURNED);
                ps1.setString(2, reason.trim());
                ps1.setInt(3, ceoId);
                ps1.setInt(4, poId);
                ps1.setString(5, GlobalUtils.PO_STATUS_PENDING_CEO);
                if (ps1.executeUpdate() == 0) {
                    c.rollback();
                    return false;
                }
            }
            try (PreparedStatement ps2 = c.prepareStatement(
                    "UPDATE import_proposal SET purchase_order_id = NULL, status = ? "
                    + "WHERE purchase_order_id = ?")) {
                ps2.setString(1, GlobalUtils.STATUS_APPROVED);
                ps2.setInt(2, poId);
                ps2.executeUpdate();
            }
            c.commit();
            return true;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public boolean updateReturnedPo(PurchaseOrder po, List<PurchaseOrderDetail> details, List<Integer> proposalIds) {
        if (po == null || po.getPoId() <= 0 || details == null || details.isEmpty()) {
            return false;
        }
        Connection c = null;
        try {
            c = getConnection();
            c.setAutoCommit(false);

            try (PreparedStatement ps = c.prepareStatement(
                    "UPDATE purchase_order SET status = ?, note = ?, total_quantity = ?, "
                    + "rejected_by = NULL, rejected_at = NULL, reject_reason = NULL "
                    + "WHERE po_id = ? AND status = ?")) {
                ps.setString(1, GlobalUtils.PO_STATUS_PENDING_CEO);
                ps.setString(2, po.getNote());
                ps.setInt(3, po.getTotalQuantity());
                ps.setInt(4, po.getPoId());
                ps.setString(5, GlobalUtils.PO_STATUS_RETURNED);
                if (ps.executeUpdate() == 0) {
                    c.rollback();
                    return false;
                }
            }

            try (PreparedStatement ps = c.prepareStatement(
                    "DELETE FROM purchase_order_detail WHERE po_id = ?")) {
                ps.setInt(1, po.getPoId());
                ps.executeUpdate();
            }

            try (PreparedStatement ps = c.prepareStatement(
                    "INSERT INTO purchase_order_detail "
                    + "(po_id, generator_id, proposed_quantity, current_stock, unit_price, final_quantity, note) "
                    + "VALUES (?,?,?,?,?,?,?)")) {
                for (PurchaseOrderDetail d : details) {
                    ps.setInt(1, po.getPoId());
                    ps.setInt(2, d.getGeneratorId());
                    ps.setInt(3, d.getProposedQuantity());
                    ps.setInt(4, d.getCurrentStock());
                    if (d.getUnitPrice() != null) {
                        ps.setBigDecimal(5, d.getUnitPrice());
                    } else {
                        ps.setNull(5, java.sql.Types.DECIMAL);
                    }
                    ps.setInt(6, d.getFinalQuantity());
                    ps.setString(7, d.getNote());
                    ps.addBatch();
                }
                ps.executeBatch();
            }

            try (PreparedStatement ps = c.prepareStatement(
                    "UPDATE import_proposal SET purchase_order_id = NULL "
                    + "WHERE purchase_order_id = ?")) {
                ps.setInt(1, po.getPoId());
                ps.executeUpdate();
            }

            int linked = 0;
            if (proposalIds != null && !proposalIds.isEmpty()) {
                StringBuilder placeholders = new StringBuilder();
                for (int i = 0; i < proposalIds.size(); i++) {
                    if (i > 0) {
                        placeholders.append(",");
                    }
                    placeholders.append("?");
                }
                try (PreparedStatement ps = c.prepareStatement(
                        "UPDATE import_proposal SET purchase_order_id = ? "
                        + "WHERE proposal_id IN (" + placeholders + ") "
                        + "  AND status = ? "
                        + "  AND purchase_order_id IS NULL")) {
                    ps.setInt(1, po.getPoId());
                    for (int i = 0; i < proposalIds.size(); i++) {
                        ps.setInt(2 + i, proposalIds.get(i));
                    }
                    ps.setString(2 + proposalIds.size(), GlobalUtils.STATUS_APPROVED);
                    linked = ps.executeUpdate();
                }
            }

            try (PreparedStatement ps = c.prepareStatement(
                    "UPDATE purchase_order SET total_proposals = ? WHERE po_id = ?")) {
                ps.setInt(1, linked);
                ps.setInt(2, po.getPoId());
                ps.executeUpdate();
            }

            try (PreparedStatement ps = c.prepareStatement(
                    "UPDATE import_proposal SET status = ? "
                    + "WHERE purchase_order_id = ?")) {
                ps.setString(1, GlobalUtils.PROPOSAL_STATUS_PENDING_CEO);
                ps.setInt(2, po.getPoId());
                ps.executeUpdate();
            }

            c.commit();
            return true;
        } catch (SQLException e) {
            e.printStackTrace();
            try {
                if (c != null) {
                    c.rollback();
                }
            } catch (SQLException ex) {
                ex.printStackTrace();
            }
            return false;
        } finally {
            try {
                if (c != null) {
                    c.setAutoCommit(true);
                    c.close();
                }
            } catch (SQLException ex) {
                ex.printStackTrace();
            }
        }
    }

    public boolean cancelWithMode(int poId, int ceoId, String mode, String reason) {
        if (poId <= 0 || ceoId <= 0 || mode == null
                || (!mode.equals("REBUILD") && !mode.equals("KILL"))) {
            return false;
        }
        try (Connection c = getConnection()) {
            c.setAutoCommit(false);
            try (PreparedStatement ps1 = c.prepareStatement(
                    "UPDATE purchase_order SET status = ?, cancel_mode = ?, cancel_reason = ?, "
                    + "rejected_by = ?, rejected_at = NOW() "
                    + "WHERE po_id = ? AND status NOT IN ('CANCELLED', 'APPROVED')")) {
                ps1.setString(1, GlobalUtils.PO_STATUS_CANCELLED);
                ps1.setString(2, mode);
                ps1.setString(3, reason);
                ps1.setInt(4, ceoId);
                ps1.setInt(5, poId);
                if (ps1.executeUpdate() == 0) {
                    c.rollback();
                    return false;
                }
            }
            if ("REBUILD".equals(mode)) {
                try (PreparedStatement ps2 = c.prepareStatement(
                        "UPDATE import_proposal SET purchase_order_id = NULL, status = ? "
                        + "WHERE purchase_order_id = ?")) {
                    ps2.setString(1, GlobalUtils.STATUS_APPROVED);
                    ps2.setInt(2, poId);
                    ps2.executeUpdate();
                }
            } else {
                try (PreparedStatement ps2 = c.prepareStatement(
                        "UPDATE import_proposal SET status = ?, rejected_by = ?, rejected_at = NOW(), "
                        + "reject_reason = ? "
                        + "WHERE purchase_order_id = ?")) {
                    ps2.setString(1, GlobalUtils.STATUS_REJECTED);
                    ps2.setInt(2, ceoId);
                    ps2.setString(3, "PO bị hủy hoàn toàn: " + reason);
                    ps2.setInt(4, poId);
                    ps2.executeUpdate();
                }
            }
            c.commit();
            return true;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public boolean cancel(int poId) {
        try (Connection c = getConnection()) {
            c.setAutoCommit(false);
            try (PreparedStatement ps0 = c.prepareStatement(
                    "UPDATE import_proposal SET purchase_order_id = NULL "
                    + "WHERE purchase_order_id = ? AND status = ?")) {
                ps0.setInt(1, poId);
                ps0.setString(2, GlobalUtils.PROPOSAL_STATUS_PENDING_CEO);
                ps0.executeUpdate();
            }
            try (PreparedStatement ps1 = c.prepareStatement(
                    "UPDATE purchase_order SET status = ? "
                    + "WHERE po_id = ? AND status = ?")) {
                ps1.setString(1, GlobalUtils.PO_STATUS_CANCELLED);
                ps1.setInt(2, poId);
                ps1.setString(3, GlobalUtils.PO_STATUS_DRAFT);
                if (ps1.executeUpdate() == 0) {
                    c.rollback();
                    return false;
                }
            }
            c.commit();
            return true;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public List<Map<String, Object>> findOpenMonths(String currentPeriod, java.time.LocalDate currentPeriodEnd) {
        if (currentPeriod == null || currentPeriodEnd == null) {
            return new ArrayList<>();
        }
        List<Map<String, Object>> list = new ArrayList<>();
        String sql = "SELECT w.warehouse_id, w.name AS warehouse_name, "
                + "DATEDIFF(?, CURDATE()) AS days_left "
                + "FROM warehouse w "
                + "WHERE w.status = 'active' "
                + "  AND NOT EXISTS ("
                + "    SELECT 1 FROM purchase_order po "
                + "    WHERE po.period = ? AND po.warehouse_id = w.warehouse_id "
                + "      AND po.status IN ('PENDING_CEO', 'APPROVED')"
                + "  ) "
                + "ORDER BY w.warehouse_id";
        try {
            connection = getConnection();
            statement = connection.prepareStatement(sql);
            statement.setDate(1, java.sql.Date.valueOf(currentPeriodEnd));
            statement.setString(2, currentPeriod);
            resultSet = statement.executeQuery();
            while (resultSet.next()) {
                int daysLeft = resultSet.getInt("days_left");
                if (daysLeft < 0) {
                    continue;
                }
                Map<String, Object> row = new LinkedHashMap<>();
                row.put("warehouseId", resultSet.getInt("warehouse_id"));
                row.put("warehouseName", resultSet.getString("warehouse_name"));
                row.put("daysLeft", daysLeft);
                list.add(row);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            closeResources();
        }
        return list;
    }

    public List<ImportProposal> findProposalsByPo(int poId) {
        List<ImportProposal> list = new ArrayList<>();
        String sql = "SELECT p.*, po.po_code AS po_code, w.name AS warehouse_name, "
                + "u_c.name AS created_by_name, u_a.name AS approved_by_name, u_r.name AS rejected_by_name "
                + "FROM import_proposal p "
                + "LEFT JOIN purchase_order po ON po.po_id = p.purchase_order_id "
                + "LEFT JOIN warehouse w ON w.warehouse_id = p.warehouse_id "
                + "LEFT JOIN user u_c ON u_c.id = p.created_by "
                + "LEFT JOIN user u_a ON u_a.id = p.approved_by "
                + "LEFT JOIN user u_r ON u_r.id = p.rejected_by "
                + "WHERE p.purchase_order_id = ? "
                + "ORDER BY p.proposal_id ASC";
        try {
            connection = getConnection();
            statement = connection.prepareStatement(sql);
            statement.setInt(1, poId);
            resultSet = statement.executeQuery();
            while (resultSet.next()) {
                ImportProposal p = new ImportProposal();
                p.setProposalId(resultSet.getInt("proposal_id"));
                p.setProposalCode(resultSet.getString("proposal_code"));
                p.setStatus(resultSet.getString("status"));
                p.setWarehouseId(resultSet.getInt("warehouse_id"));
                p.setCreatedBy(resultSet.getInt("created_by"));
                Timestamp pd = resultSet.getTimestamp("proposal_date");
                p.setProposalDate(pd != null ? pd.toLocalDateTime() : null);
                p.setWarehouseName(resultSet.getString("warehouse_name"));
                p.setCreatedByName(resultSet.getString("created_by_name"));
                p.setPoCode(resultSet.getString("po_code"));
                p.setPeriod(resultSet.getString("period"));
                int poIdVal = resultSet.getInt("purchase_order_id");
                p.setPurchaseOrderId(resultSet.wasNull() ? null : poIdVal);
                list.add(p);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            closeResources();
        }
        return list;
    }

    public java.math.BigDecimal findApprovedUnitPriceByGenerator(int generatorId) {
        java.math.BigDecimal result = null;
        String sql = "SELECT pod.unit_price "
                + "FROM purchase_order_detail pod "
                + "JOIN purchase_order po ON pod.po_id = po.po_id "
                + "WHERE pod.generator_id = ? "
                + "  AND po.status = 'APPROVED' "
                + "  AND pod.unit_price IS NOT NULL "
                + "ORDER BY po.approved_at DESC "
                + "LIMIT 1";
        try {
            connection = getConnection();
            statement = connection.prepareStatement(sql);
            statement.setInt(1, generatorId);
            resultSet = statement.executeQuery();
            if (resultSet.next()) {
                result = resultSet.getBigDecimal("unit_price");
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            closeResources();
        }
        return result;
    }
}
