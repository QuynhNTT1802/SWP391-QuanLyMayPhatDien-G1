/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package com.quanlymayphatdien.g1.dal;

import com.quanlymayphatdien.g1.entity.ImportProposal;
import com.quanlymayphatdien.g1.entity.ImportProposalDetail;

import com.quanlymayphatdien.g1.utils.GlobalUtils;
import com.quanlymayphatdien.g1.utils.PeriodUtils;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.sql.Timestamp;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.ArrayList;
import java.util.List;

/**
 *
 * @author Phuong Linh
 */
public class ImportProposalDAO extends DBContext implements I_DAO<ImportProposal> {

    public String generateProposalCode() {
        String dateStr = LocalDateTime.now().format(DateTimeFormatter.ofPattern("yyyyMMdd"));
        return String.format("PRC-%s-%03d", dateStr, countTodayProposals() + 1);
    }

    public int countTodayProposals() {
        String sql = "SELECT COUNT(*) FROM import_proposal WHERE DATE(proposal_date) = CURDATE()";
        try {
            connection = getConnection();
            statement = connection.prepareStatement(sql);
            resultSet = statement.executeQuery();
            if (resultSet.next()) {
                return resultSet.getInt(1);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            closeResources();
        }
        return 0;
    }

    @Override
    public List<ImportProposal> findAll() {
        List<ImportProposal> list = new ArrayList<>();
        String sql = "SELECT p.*, "
                + "w.name AS warehouse_name, "
                + "u_c.name AS created_by_name, "
                + "u_a.name AS approved_by_name, "
                + "u_r.name AS rejected_by_name, "
                + "s.name AS supplier_name "
                + "FROM import_proposal p "
                + "LEFT JOIN warehouse w  ON w.warehouse_id = p.warehouse_id "
                + "LEFT JOIN user u_c     ON u_c.id = p.created_by "
                + "LEFT JOIN user u_a     ON u_a.id = p.approved_by "
                + "LEFT JOIN user u_r     ON u_r.id = p.rejected_by "
                + "LEFT JOIN supplier s   ON s.id = p.supplier_id "
                + "ORDER BY p.proposal_date DESC, p.proposal_id DESC";

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

    public ImportProposal findById(int id) {
        String sql = "SELECT p.*, "
                + "po.po_code AS po_code, "
                + "w.name AS warehouse_name, "
                + "u_c.name AS created_by_name, "
                + "u_a.name AS approved_by_name, "
                + "u_r.name AS rejected_by_name, "
                + "s.name AS supplier_name "
                + "FROM import_proposal p "
                + "LEFT JOIN purchase_order po ON po.po_id = p.purchase_order_id "
                + "LEFT JOIN warehouse w  ON w.warehouse_id = p.warehouse_id "
                + "LEFT JOIN user u_c     ON u_c.id = p.created_by "
                + "LEFT JOIN user u_a     ON u_a.id = p.approved_by "
                + "LEFT JOIN user u_r     ON u_r.id = p.rejected_by "
                + "LEFT JOIN supplier s   ON s.id = p.supplier_id "
                + "WHERE p.proposal_id = ?";

        try {
            connection = getConnection();
            statement = connection.prepareStatement(sql);
            statement.setInt(1, id);
            resultSet = statement.executeQuery();
            if (resultSet.next()) {
                ImportProposal p = getFromResultSet(resultSet);
                p.setDetails(findDetailsByProposalId(id));
                p.setHasNewGenerator(hasNewGenerator(p.getWarehouseId(), id));
                return p;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            closeResources();
        }
        return null;
    }

    /**
     * Kiểm tra phiếu có chứa máy phát chưa có trong inventory của kho đề xuất không.
     * Dùng cho entity.transient.hasNewGenerator (warehouse tự xử lý category khi cần).
     */
    public boolean hasNewGenerator(int warehouseId, int proposalId) {
        String sql = "SELECT COUNT(*) FROM import_proposal_detail d "
                + "WHERE d.proposal_id = ? "
                + "AND NOT EXISTS (SELECT 1 FROM inventory i "
                + "    WHERE i.warehouse_id = ? AND i.generator_id = d.generator_id)";
        try {
            connection = getConnection();
            statement = connection.prepareStatement(sql);
            statement.setInt(1, proposalId);
            statement.setInt(2, warehouseId);
            resultSet = statement.executeQuery();
            if (resultSet.next()) {
                return resultSet.getInt(1) > 0;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            closeResources();
        }
        return false;
    }

    public int countByStatus(String status, Integer createdBy, String dateFrom, String dateTo, int loggedUserId) {
        StringBuilder sql = new StringBuilder("SELECT COUNT(*) FROM import_proposal WHERE status = ?");
        List<Object> params = new ArrayList<>();
        params.add(status);
        if (GlobalUtils.STATUS_DELETED.equals(status)) {
            sql.append(" AND created_by = ?");
            params.add(loggedUserId);
        }
        if (createdBy != null && !GlobalUtils.STATUS_DELETED.equals(status)) {
            sql.append(" AND created_by = ?");
            params.add(createdBy);
        }
        if (dateFrom != null && !dateFrom.isEmpty()) {
            sql.append(" AND proposal_date >= ?");
            params.add(java.sql.Timestamp.valueOf(java.time.LocalDate.parse(dateFrom).atStartOfDay()));
        }
        if (dateTo != null && !dateTo.isEmpty()) {
            sql.append(" AND proposal_date < ?");
            params.add(java.sql.Timestamp.valueOf(java.time.LocalDate.parse(dateTo).plusDays(1).atStartOfDay()));
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
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            closeResources();
        }
        return 0;
    }

    @Override
    public boolean delete(ImportProposal t) {
        String sql = "DELETE FROM import_proposal WHERE proposal_id = ? AND status = ?";
        try {
            connection = getConnection();
            statement = connection.prepareStatement(sql);
            statement.setInt(1, t.getProposalId());
            statement.setString(2, GlobalUtils.STATUS_PENDING);
            return statement.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        } finally {
            closeResources();
        }
    }

    /**
     * Soft delete: chuyển status sang DELETED, ghi nhận người huỷ và thời điểm.
     * Chỉ creator mới được xoá, và chỉ khi phiếu đang ở trạng thái PENDING.
     */
    public boolean softDeleteByCreator(int proposalId, int creatorId) {
        String sql = "UPDATE import_proposal SET status = ?, cancelled_by = ?, cancelled_at = NOW() "
                + "WHERE proposal_id = ? AND created_by = ? AND status = ?";
        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, GlobalUtils.STATUS_DELETED);
            ps.setInt(2, creatorId);
            ps.setInt(3, proposalId);
            ps.setInt(4, creatorId);
            ps.setString(5, GlobalUtils.STATUS_PENDING);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    @Override
    public int insert(ImportProposal t) {
        String sql = "INSERT INTO import_proposal (proposal_code, status, warehouse_id, supplier_id, created_by, "
                + "proposal_date, period, note) VALUES (?, ?, ?, ?, ?, ?, ?, ?)";
        try {
            connection = getConnection();
            statement = connection.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS);
            statement.setString(1, t.getProposalCode());
            statement.setString(2, t.getStatus());
            statement.setInt(3, t.getWarehouseId());
            if (t.getSupplierId() != null) {
                statement.setInt(4, t.getSupplierId());
            } else {
                statement.setNull(4, java.sql.Types.INTEGER);
            }
            statement.setInt(5, t.getCreatedBy());
            statement.setTimestamp(6, t.getProposalDate() != null
                    ? Timestamp.valueOf(t.getProposalDate())
                    : Timestamp.valueOf(LocalDateTime.now()));
            statement.setString(7, PeriodUtils.currentPeriod());
            statement.setString(8, t.getNote());

            int affected = statement.executeUpdate();
            if (affected > 0) {
                resultSet = statement.getGeneratedKeys();
                if (resultSet.next()) {
                    int newId = resultSet.getInt(1);
                    t.setProposalId(newId);
                    return newId;
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            closeResources();
        }
        return 0;
    }

    @Override
    public ImportProposal getFromResultSet(ResultSet rs) throws SQLException {
        ImportProposal p = new ImportProposal();
        p.setProposalId(rs.getInt("proposal_id"));
        p.setProposalCode(rs.getString("proposal_code"));
        p.setStatus(rs.getString("status"));
        p.setWarehouseId(rs.getInt("warehouse_id"));
        p.setCreatedBy(rs.getInt("created_by"));

        int approvedBy = rs.getInt("approved_by");
        p.setApprovedBy(rs.wasNull() ? null : approvedBy);

        int rejectedBy = rs.getInt("rejected_by");
        p.setRejectedBy(rs.wasNull() ? null : rejectedBy);

        try {
            int supId = rs.getInt("supplier_id");
            p.setSupplierId(rs.wasNull() ? null : supId);
        } catch (SQLException ignored) { p.setSupplierId(null); }

        try { p.setRevisionRequestedByRole(rs.getString("revision_requested_by_role")); }
        catch (SQLException ignored) { p.setRevisionRequestedByRole(GlobalUtils.REVISION_REQUESTER_SM); }

        Timestamp pd = rs.getTimestamp("proposal_date");
        p.setProposalDate(pd != null ? pd.toLocalDateTime() : null);

        p.setNote(rs.getString("note"));
        p.setRejectReason(rs.getString("reject_reason"));

        Timestamp aa = rs.getTimestamp("approved_at");
        p.setApprovedAt(aa != null ? aa.toLocalDateTime() : null);

        Timestamp ra = rs.getTimestamp("rejected_at");
        p.setRejectedAt(ra != null ? ra.toLocalDateTime() : null);

        try {
            int cancelledBy = rs.getInt("cancelled_by");
            p.setCancelledBy(rs.wasNull() ? null : cancelledBy);
        } catch (SQLException ignored) { p.setCancelledBy(null); }

        try {
            Timestamp cat = rs.getTimestamp("cancelled_at");
            p.setCancelledAt(cat != null ? cat.toLocalDateTime() : null);
        } catch (SQLException ignored) { p.setCancelledAt(null); }

        Timestamp ca = rs.getTimestamp("created_at");
        p.setCreatedAt(ca != null ? ca.toLocalDateTime() : null);

        Timestamp ua = rs.getTimestamp("updated_at");
        p.setUpdatedAt(ua != null ? ua.toLocalDateTime() : null);

        p.setWarehouseName(rs.getString("warehouse_name"));
        p.setCreatedByName(rs.getString("created_by_name"));
        p.setApprovedByName(rs.getString("approved_by_name"));
        p.setRejectedByName(rs.getString("rejected_by_name"));
        try { p.setSupplierName(rs.getString("supplier_name")); } catch (SQLException ignored) {}

        try {
            int poId = rs.getInt("purchase_order_id");
            p.setPurchaseOrderId(rs.wasNull() ? null : poId);
        } catch (SQLException ignored) {}
        try { p.setPeriod(rs.getString("period")); } catch (SQLException ignored) {}
        try { p.setPoCode(rs.getString("po_code")); } catch (SQLException ignored) {}
        return p;
    }

    public List<ImportProposalDetail> findDetailsByProposalId(int proposalId) {
        return new ImportProposalDetailDAO().findByProposalId(proposalId);
    }

    public boolean approveProposal(int proposalId, int approverId) {
        String sql = "UPDATE import_proposal SET status = ?, approved_by = ?, approved_at = NOW() "
                + "WHERE proposal_id = ? AND status = ?";
        try {
            connection = getConnection();
            statement = connection.prepareStatement(sql);
            statement.setString(1, GlobalUtils.STATUS_APPROVED);
            statement.setInt(2, approverId);
            statement.setInt(3, proposalId);
            statement.setString(4, GlobalUtils.STATUS_PENDING);   // chỉ duyệt khi PENDING
            return statement.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        } finally {
            closeResources();
        }
    }

    public boolean rejectProposal(int proposalId, int rejecterId, String reason) {
        String sql = "UPDATE import_proposal SET status = ?, reject_reason = ?, "
                + "rejected_by = ?, rejected_at = NOW() "
                + "WHERE proposal_id = ? AND status = ?";
        try {
            connection = getConnection();
            statement = connection.prepareStatement(sql);
            statement.setString(1, GlobalUtils.STATUS_REJECTED);
            statement.setString(2, reason);
            statement.setInt(3, rejecterId);
            statement.setInt(4, proposalId);
            statement.setString(5, GlobalUtils.STATUS_PENDING);
            return statement.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        } finally {
            closeResources();
        }
    }

    public boolean cancelProposal(int proposalId, int cancellerId) {
        String sql = "UPDATE import_proposal SET status = ?, updated_at = NOW() "
                + "WHERE proposal_id = ? AND status = ?";
        try {
            connection = getConnection();
            statement = connection.prepareStatement(sql);
            statement.setString(1, GlobalUtils.STATUS_CANCELLED);
            statement.setInt(2, proposalId);
            statement.setString(3, GlobalUtils.STATUS_PENDING);
            return statement.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        } finally {
            closeResources();
        }
    }

    public boolean requestRevision(int proposalId, int userId, String reason) {
        String sql = "UPDATE import_proposal SET status = ?, reject_reason = ?, "
                + "rejected_by = ?, rejected_at = NOW(), revision_requested_by_role = ? "
                + "WHERE proposal_id = ? AND status = ?";
        try {
            connection = getConnection();
            statement = connection.prepareStatement(sql);
            statement.setString(1, GlobalUtils.STATUS_NEEDS_REVISION);
            statement.setString(2, reason);
            statement.setInt(3, userId);
            statement.setString(4, GlobalUtils.REVISION_REQUESTER_SM);
            statement.setInt(5, proposalId);
            statement.setString(6, GlobalUtils.STATUS_PENDING);
            return statement.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        } finally {
            closeResources();
        }
    }

    public boolean revertApprovedToRevision(int proposalId, int userId, String reason) {
        String sql = "UPDATE import_proposal SET status = ?, reject_reason = ?, "
                + "rejected_by = ?, rejected_at = NOW(), revision_requested_by_role = ? "
                + "WHERE proposal_id = ? AND status = ?";
        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, GlobalUtils.STATUS_NEEDS_REVISION);
            ps.setString(2, reason);
            ps.setInt(3, userId);
            ps.setString(4, GlobalUtils.REVISION_REQUESTER_SM);
            ps.setInt(5, proposalId);
            ps.setString(6, GlobalUtils.STATUS_APPROVED);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    /**
     * CEO yêu cầu Sale Manager chỉnh sửa proposal. Đánh dấu revision_requested_by_role='CEO'.
     * Đồng thời gỡ liên kết PO (purchase_order_id = NULL).
     */
    public boolean requestRevisionByCeo(int proposalId, int ceoId, String reason) {
        String sql = "UPDATE import_proposal SET status = ?, reject_reason = ?, "
                + "rejected_by = ?, rejected_at = NOW(), revision_requested_by_role = ?, "
                + "purchase_order_id = NULL "
                + "WHERE proposal_id = ? AND status = ?";
        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, GlobalUtils.STATUS_NEEDS_REVISION);
            ps.setString(2, reason);
            ps.setInt(3, ceoId);
            ps.setString(4, GlobalUtils.REVISION_REQUESTER_CEO);
            ps.setInt(5, proposalId);
            ps.setString(6, GlobalUtils.PROPOSAL_STATUS_PENDING_CEO);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public List<ImportProposal> searchByFilters(String status, String search, Integer createdBy, Integer poFilter, String dateFrom, String dateTo, int loggedUserId, int page, int pageSize) {
        List<ImportProposal> list = new ArrayList<>();
        StringBuilder sql = new StringBuilder(
                "SELECT p.*, "
                + "po.po_code AS po_code, "
                + "w.name AS warehouse_name, "
                + "u_c.name AS created_by_name, "
                + "u_a.name AS approved_by_name, "
                + "u_r.name AS rejected_by_name, "
                + "s.name AS supplier_name "
                + "FROM import_proposal p "
                + "LEFT JOIN purchase_order po ON po.po_id = p.purchase_order_id "
                + "LEFT JOIN warehouse w  ON w.warehouse_id = p.warehouse_id "
                + "LEFT JOIN user u_c     ON u_c.id = p.created_by "
                + "LEFT JOIN user u_a     ON u_a.id = p.approved_by "
                + "LEFT JOIN user u_r     ON u_r.id = p.rejected_by "
                + "LEFT JOIN supplier s   ON s.id = p.supplier_id "
                + "WHERE (p.status != ? OR p.created_by = ?)");
        List<Object> params = new ArrayList<>();
        params.add(GlobalUtils.STATUS_DELETED);
        params.add(loggedUserId);
        if (status != null && !status.isEmpty()) {
            sql.append(" AND p.status = ?");
            params.add(status);
        }
        if (search != null && !search.trim().isEmpty()) {
            sql.append(" AND p.proposal_code LIKE ?");
            params.add("%" + search.trim() + "%");
        }
        if (createdBy != null) {
            sql.append(" AND p.created_by = ?");
            params.add(createdBy);
        }
        if (poFilter != null) {
            if (poFilter == 0) {
                sql.append(" AND p.purchase_order_id IS NULL");
            } else {
                sql.append(" AND p.purchase_order_id = ?");
                params.add(poFilter);
            }
        }
        if (dateFrom != null && !dateFrom.isEmpty()) {
            sql.append(" AND p.proposal_date >= ?");
            params.add(java.sql.Timestamp.valueOf(java.time.LocalDate.parse(dateFrom).atStartOfDay()));
        }
        if (dateTo != null && !dateTo.isEmpty()) {
            sql.append(" AND p.proposal_date < ?");
            params.add(java.sql.Timestamp.valueOf(java.time.LocalDate.parse(dateTo).plusDays(1).atStartOfDay()));
        }
        sql.append(" ORDER BY p.proposal_date DESC LIMIT ? OFFSET ?");
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
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            closeResources();
        }
        return list;
    }

    public int countByFilters(String status, String search, Integer createdBy, Integer poFilter, String dateFrom, String dateTo, int loggedUserId) {
        StringBuilder sql = new StringBuilder("SELECT COUNT(*) FROM import_proposal p WHERE (p.status != ? OR p.created_by = ?)");
        List<Object> params = new ArrayList<>();
        params.add(GlobalUtils.STATUS_DELETED);
        params.add(loggedUserId);
        if (status != null && !status.isEmpty()) {
            sql.append(" AND p.status = ?");
            params.add(status);
        }
        if (search != null && !search.trim().isEmpty()) {
            sql.append(" AND p.proposal_code LIKE ?");
            params.add("%" + search.trim() + "%");
        }
        if (createdBy != null) {
            sql.append(" AND p.created_by = ?");
            params.add(createdBy);
        }
        if (poFilter != null) {
            if (poFilter == 0) {
                sql.append(" AND p.purchase_order_id IS NULL");
            } else {
                sql.append(" AND p.purchase_order_id = ?");
                params.add(poFilter);
            }
        }
        if (dateFrom != null && !dateFrom.isEmpty()) {
            sql.append(" AND p.proposal_date >= ?");
            params.add(java.sql.Timestamp.valueOf(java.time.LocalDate.parse(dateFrom).atStartOfDay()));
        }
        if (dateTo != null && !dateTo.isEmpty()) {
            sql.append(" AND p.proposal_date < ?");
            params.add(java.sql.Timestamp.valueOf(java.time.LocalDate.parse(dateTo).plusDays(1).atStartOfDay()));
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
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            closeResources();
        }
        return 0;
    }

    public void deleteDetails(int proposalId) {
        String sql = "DELETE FROM import_proposal_detail WHERE proposal_id = ?";
        try {
            connection = getConnection();
            statement = connection.prepareStatement(sql);
            statement.setInt(1, proposalId);
            statement.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            closeResources();
        }
    }

    public boolean replaceDetails(int proposalId, List<ImportProposalDetail> details) {
        Connection conn = null;
        try {
            conn = getConnection();
            conn.setAutoCommit(false);
            try (PreparedStatement ps = conn.prepareStatement("DELETE FROM import_proposal_detail WHERE proposal_id = ?")) {
                ps.setInt(1, proposalId);
                ps.executeUpdate();
            }
            if (details != null && !details.isEmpty()) {
                try (PreparedStatement ps = conn.prepareStatement(
                        "INSERT INTO import_proposal_detail (proposal_id, generator_id, supplier_id, quantity, current_stock, unit_price, note) "
                        + "VALUES (?, ?, ?, ?, ?, ?, ?)")) {
                    for (ImportProposalDetail d : details) {
                        ps.setInt(1, d.getProposalId());
                        ps.setInt(2, d.getGeneratorId());
                        if (d.getSupplierId() != null) {
                            ps.setInt(3, d.getSupplierId());
                        } else {
                            ps.setNull(3, java.sql.Types.INTEGER);
                        }
                        ps.setInt(4, d.getQuantity());
                        ps.setInt(5, d.getCurrentStock());
                        if (d.getUnitPrice() != null) {
                            ps.setBigDecimal(6, d.getUnitPrice());
                        } else {
                            ps.setNull(6, java.sql.Types.DECIMAL);
                        }
                        ps.setString(7, d.getNote());
                        ps.addBatch();
                    }
                    ps.executeBatch();
                }
            }
            conn.commit();
            return true;
        } catch (SQLException e) {
            e.printStackTrace();
            try { if (conn != null) conn.rollback(); } catch (SQLException ex) { ex.printStackTrace(); }
            return false;
        } finally {
            try { if (conn != null) { conn.setAutoCommit(true); conn.close(); } } catch (SQLException e) { e.printStackTrace(); }
        }
    }

    public void insertDetailsBatch(List<ImportProposalDetail> details) {
        String sql = "INSERT INTO import_proposal_detail (proposal_id, generator_id, supplier_id, quantity, current_stock, unit_price, note) "
                + "VALUES (?, ?, ?, ?, ?, ?, ?)";
        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            for (ImportProposalDetail d : details) {
                ps.setInt(1, d.getProposalId());
                ps.setInt(2, d.getGeneratorId());
                if (d.getSupplierId() != null) {
                    ps.setInt(3, d.getSupplierId());
                } else {
                    ps.setNull(3, java.sql.Types.INTEGER);
                }
                ps.setInt(4, d.getQuantity());
                ps.setInt(5, d.getCurrentStock());
                if (d.getUnitPrice() != null) {
                    ps.setBigDecimal(6, d.getUnitPrice());
                } else {
                    ps.setNull(6, java.sql.Types.DECIMAL);
                }
                ps.setString(7, d.getNote());
                ps.addBatch();
            }
            ps.executeBatch();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    public List<ImportProposal> findPendingByPeriodAndWarehouse(String period, int warehouseId) {
        List<ImportProposal> list = new ArrayList<>();
        String sql = "SELECT p.*, "
                + "w.name AS warehouse_name, "
                + "u_c.name AS created_by_name "
                + "FROM import_proposal p "
                + "LEFT JOIN warehouse w ON w.warehouse_id = p.warehouse_id "
                + "LEFT JOIN user u_c ON u_c.id = p.created_by "
                + "WHERE p.period = ? AND p.warehouse_id = ? "
                + "AND p.status = 'APPROVED' "
                + "AND p.purchase_order_id IS NULL "
                + "ORDER BY u_c.name, p.proposal_id";
        try {
            connection = getConnection();
            statement = connection.prepareStatement(sql);
            statement.setString(1, period);
            statement.setInt(2, warehouseId);
            resultSet = statement.executeQuery();
            while (resultSet.next()) {
                ImportProposal p = getFromResultSet(resultSet);
                p.setWarehouseName(resultSet.getString("warehouse_name"));
                p.setCreatedByName(resultSet.getString("created_by_name"));
                p.setDetails(findDetailsByProposalId(p.getProposalId()));
                list.add(p);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            closeResources();
        }
        return list;
    }

    public List<ImportProposal> findApprovedAvailableFiltered(String search, String fromDate, String toDate, int page, int pageSize) {
        List<ImportProposal> list = new ArrayList<>();
        StringBuilder sql = new StringBuilder(
                "SELECT p.*, "
                + "w.name AS warehouse_name, "
                + "u_c.name AS created_by_name, "
                + "u_a.name AS approved_by_name, "
                + "u_r.name AS rejected_by_name "
                + "FROM import_proposal p "
                + "LEFT JOIN warehouse w  ON w.warehouse_id = p.warehouse_id "
                + "LEFT JOIN user u_c     ON u_c.id = p.created_by "
                + "LEFT JOIN user u_a     ON u_a.id = p.approved_by "
                + "LEFT JOIN user u_r     ON u_r.id = p.rejected_by "
                + "WHERE p.status = ? "
                + "AND NOT EXISTS ("
                + "  SELECT 1 FROM receipt r "
                + "  WHERE r.proposal_id = p.proposal_id AND r.status <> 'CANCELLED'"
                + ") ");
        List<Object> params = new ArrayList<>();
        params.add(GlobalUtils.STATUS_APPROVED);
        if (search != null && !search.trim().isEmpty()) {
            sql.append("AND p.proposal_code LIKE ? ");
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
                list.add(getFromResultSet(resultSet));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            closeResources();
        }
        return list;
    }

    public int countApprovedAvailableFiltered(String search, String fromDate, String toDate) {
        StringBuilder sql = new StringBuilder(
                "SELECT COUNT(*) FROM import_proposal p "
                + "WHERE p.status = ? "
                + "AND NOT EXISTS ("
                + "  SELECT 1 FROM receipt r "
                + "  WHERE r.proposal_id = p.proposal_id AND r.status <> 'CANCELLED'"
                + ") ");
        List<Object> params = new ArrayList<>();
        params.add(GlobalUtils.STATUS_APPROVED);
        if (search != null && !search.trim().isEmpty()) {
            sql.append("AND p.proposal_code LIKE ? ");
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
                return resultSet.getInt(1);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            closeResources();
        }
        return 0;
    }

    public List<ImportProposal> findByIdsForReview(List<Integer> proposalIds) {
    if (proposalIds == null || proposalIds.isEmpty()) {
        return new ArrayList<>();
    }  
    List<ImportProposal> list = new ArrayList<>();
    
    StringBuilder placeholders = new StringBuilder();
    for (int i = 0; i < proposalIds.size(); i++) {
        if (i > 0) placeholders.append(",");
        placeholders.append("?");
    }
    
    String sql = "SELECT ip.*, w.name AS warehouse_name, u_c.name AS created_by_name, "
               + "u_a.name AS approved_by_name, u_r.name AS rejected_by_name "
               + "FROM import_proposal ip "
               + "LEFT JOIN warehouse w ON w.warehouse_id = ip.warehouse_id "
               + "LEFT JOIN user u_c ON u_c.id = ip.created_by "
               + "LEFT JOIN user u_a ON u_a.id = ip.approved_by "
               + "LEFT JOIN user u_r ON u_r.id = ip.rejected_by "
               + "WHERE ip.proposal_id IN (" + placeholders + ") "
               + "  AND ip.status = 'APPROVED' "
               + "  AND ip.purchase_order_id IS NULL "
               + "ORDER BY ip.proposal_id ASC";
    
    try {
            connection = getConnection();
            statement = connection.prepareStatement(sql);
            for (int i = 0; i < proposalIds.size(); i++) {
                statement.setInt(i + 1, proposalIds.get(i));
            }
            resultSet = statement.executeQuery();
            while (resultSet.next()) {
                ImportProposal p = getFromResultSet(resultSet);
                p.setWarehouseName(resultSet.getString("warehouse_name"));
                p.setCreatedByName(resultSet.getString("created_by_name"));
                p.setDetails(findDetailsByProposalId(p.getProposalId()));
                list.add(p);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            closeResources();
        }
    return list;
}

    @Override
    public boolean update(ImportProposal t) {
        String sql = "UPDATE import_proposal SET note = ?, status = ?, "
                + "supplier_id = ?, updated_at = NOW() "
                + "WHERE proposal_id = ? AND status = ?";
        try {
            connection = getConnection();
            statement = connection.prepareStatement(sql);
            statement.setString(1, t.getNote());
            statement.setString(2, t.getStatus());
            if (t.getSupplierId() != null) {
                statement.setInt(3, t.getSupplierId());
            } else {
                statement.setNull(3, java.sql.Types.INTEGER);
            }
            statement.setInt(4, t.getProposalId());
            statement.setString(5, GlobalUtils.STATUS_NEEDS_REVISION);
            return statement.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        } finally {
            closeResources();
        }
    }
}
