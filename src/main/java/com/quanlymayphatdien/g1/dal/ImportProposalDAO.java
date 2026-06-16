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
        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql); ResultSet rs = ps.executeQuery()) {
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (SQLException e) {
            e.printStackTrace();
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
                + "u_r.name AS rejected_by_name "
                + "FROM import_proposal p "
                + "LEFT JOIN warehouse w  ON w.warehouse_id = p.warehouse_id "
                + "LEFT JOIN user u_c     ON u_c.id = p.created_by "
                + "LEFT JOIN user u_a     ON u_a.id = p.approved_by "
                + "LEFT JOIN user u_r     ON u_r.id = p.rejected_by "
                + "ORDER BY p.proposal_date DESC, p.proposal_id DESC";

        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql); ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                list.add(getFromResultSet(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    public ImportProposal findById(int id) {
        String sql = "SELECT p.*, "
                + "w.name AS warehouse_name, "
                + "u_c.name AS created_by_name, "
                + "u_a.name AS approved_by_name, "
                + "u_r.name AS rejected_by_name "
                + "FROM import_proposal p "
                + "LEFT JOIN warehouse w  ON w.warehouse_id = p.warehouse_id "
                + "LEFT JOIN user u_c     ON u_c.id = p.created_by "
                + "LEFT JOIN user u_a     ON u_a.id = p.approved_by "
                + "LEFT JOIN user u_r     ON u_r.id = p.rejected_by "
                + "WHERE p.proposal_id = ?";

        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    ImportProposal p = getFromResultSet(rs);
                    p.setDetails(findDetailsByProposalId(id));
                    p.setHasNewGenerator(hasNewGenerator(p.getWarehouseId(), id));
                    return p;
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
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
        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, proposalId);
            ps.setInt(2, warehouseId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1) > 0;
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public int countByStatus(String status, Integer createdBy, boolean excludeDraft, String dateFrom, String dateTo) {
        StringBuilder sql = new StringBuilder("SELECT COUNT(*) FROM import_proposal WHERE status = ?");
        List<Object> params = new ArrayList<>();
        params.add(status);
        if (createdBy != null) {
            sql.append(" AND created_by = ?");
            params.add(createdBy);
        }
        if (excludeDraft) {
            sql.append(" AND status != ?");
            params.add(GlobalUtils.STATUS_DRAFT);
        }
        if (dateFrom != null && !dateFrom.isEmpty()) {
            sql.append(" AND proposal_date >= ?");
            params.add(java.sql.Timestamp.valueOf(java.time.LocalDate.parse(dateFrom).atStartOfDay()));
        }
        if (dateTo != null && !dateTo.isEmpty()) {
            sql.append(" AND proposal_date < ?");
            params.add(java.sql.Timestamp.valueOf(java.time.LocalDate.parse(dateTo).plusDays(1).atStartOfDay()));
        }
        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql.toString())) {
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

    @Override
    public boolean delete(ImportProposal t) {
        String sql = "DELETE FROM import_proposal WHERE proposal_id = ? AND status = ?";
        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, t.getProposalId());
            ps.setString(2, GlobalUtils.STATUS_DRAFT);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    @Override
    public int insert(ImportProposal t) {
        String sql = "INSERT INTO import_proposal (proposal_code, status, warehouse_id, created_by, "
                + "proposal_date, period, note) VALUES (?, ?, ?, ?, ?, ?, ?)";
        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            ps.setString(1, t.getProposalCode());
            ps.setString(2, t.getStatus());
            ps.setInt(3, t.getWarehouseId());
            ps.setInt(4, t.getCreatedBy());
            ps.setTimestamp(5, t.getProposalDate() != null
                    ? Timestamp.valueOf(t.getProposalDate())
                    : Timestamp.valueOf(LocalDateTime.now()));
            ps.setString(6, PeriodUtils.currentPeriod());
            ps.setString(7, t.getNote());

            int affected = ps.executeUpdate();
            if (affected > 0) {
                try (ResultSet keys = ps.getGeneratedKeys()) {
                    if (keys.next()) {
                        int newId = keys.getInt(1);
                        t.setProposalId(newId);
                        return newId;
                    }
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
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

        Timestamp pd = rs.getTimestamp("proposal_date");
        p.setProposalDate(pd != null ? pd.toLocalDateTime() : null);

        p.setNote(rs.getString("note"));
        p.setRejectReason(rs.getString("reject_reason"));

        Timestamp aa = rs.getTimestamp("approved_at");
        p.setApprovedAt(aa != null ? aa.toLocalDateTime() : null);

        Timestamp ra = rs.getTimestamp("rejected_at");
        p.setRejectedAt(ra != null ? ra.toLocalDateTime() : null);

        Timestamp ca = rs.getTimestamp("created_at");
        p.setCreatedAt(ca != null ? ca.toLocalDateTime() : null);

        Timestamp ua = rs.getTimestamp("updated_at");
        p.setUpdatedAt(ua != null ? ua.toLocalDateTime() : null);

        p.setWarehouseName(rs.getString("warehouse_name"));
        p.setCreatedByName(rs.getString("created_by_name"));
        p.setApprovedByName(rs.getString("approved_by_name"));
        p.setRejectedByName(rs.getString("rejected_by_name"));

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
        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, GlobalUtils.STATUS_APPROVED);
            ps.setInt(2, approverId);
            ps.setInt(3, proposalId);
            ps.setString(4, GlobalUtils.STATUS_PENDING);   // chỉ duyệt khi PENDING
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public boolean rejectProposal(int proposalId, int rejecterId, String reason) {
        String sql = "UPDATE import_proposal SET status = ?, reject_reason = ?, "
                + "rejected_by = ?, rejected_at = NOW() "
                + "WHERE proposal_id = ? AND status = ?";
        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, GlobalUtils.STATUS_REJECTED);
            ps.setString(2, reason);
            ps.setInt(3, rejecterId);
            ps.setInt(4, proposalId);
            ps.setString(5, GlobalUtils.STATUS_PENDING);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public boolean cancelProposal(int proposalId, int cancellerId) {
        String sql = "UPDATE import_proposal SET status = ?, updated_at = NOW() "
                + "WHERE proposal_id = ? AND status IN (?, ?)";
        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, GlobalUtils.STATUS_CANCELLED);
            ps.setInt(2, proposalId);
            ps.setString(3, GlobalUtils.STATUS_DRAFT);
            ps.setString(4, GlobalUtils.STATUS_PENDING);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public List<ImportProposal> searchByFilters(String status, String search, Integer createdBy, boolean excludeDraft, Integer poFilter, String dateFrom, String dateTo, int page, int pageSize) {
        List<ImportProposal> list = new ArrayList<>();
        StringBuilder sql = new StringBuilder(
                "SELECT p.*, "
                + "po.po_code AS po_code, "
                + "w.name AS warehouse_name, "
                + "u_c.name AS created_by_name, "
                + "u_a.name AS approved_by_name, "
                + "u_r.name AS rejected_by_name "
                + "FROM import_proposal p "
                + "LEFT JOIN purchase_order po ON po.po_id = p.purchase_order_id "
                + "LEFT JOIN warehouse w  ON w.warehouse_id = p.warehouse_id "
                + "LEFT JOIN user u_c     ON u_c.id = p.created_by "
                + "LEFT JOIN user u_a     ON u_a.id = p.approved_by "
                + "LEFT JOIN user u_r     ON u_r.id = p.rejected_by "
                + "WHERE 1=1");
        List<Object> params = new ArrayList<>();
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
        if (excludeDraft) {
            sql.append(" AND p.status != ?");
            params.add(GlobalUtils.STATUS_DRAFT);
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
        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql.toString())) {
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

    public int countByFilters(String status, String search, Integer createdBy, boolean excludeDraft, Integer poFilter, String dateFrom, String dateTo) {
        StringBuilder sql = new StringBuilder("SELECT COUNT(*) FROM import_proposal p WHERE 1=1");
        List<Object> params = new ArrayList<>();
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
        if (excludeDraft) {
            sql.append(" AND p.status != ?");
            params.add(GlobalUtils.STATUS_DRAFT);
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
        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql.toString())) {
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

    public void deleteDetails(int proposalId) {
        String sql = "DELETE FROM import_proposal_detail WHERE proposal_id = ?";
        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, proposalId);
            ps.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    public void insertDetailsBatch(List<ImportProposalDetail> details) {
        String sql = "INSERT INTO import_proposal_detail (proposal_id, generator_id, quantity, current_stock, note) "
                + "VALUES (?, ?, ?, ?, ?)";
        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            for (ImportProposalDetail d : details) {
                ps.setInt(1, d.getProposalId());
                ps.setInt(2, d.getGeneratorId());
                ps.setInt(3, d.getQuantity());
                ps.setInt(4, d.getCurrentStock());
                ps.setString(5, d.getNote());
                ps.addBatch();
            }
            ps.executeBatch();
        } catch (SQLException e) {
            e.printStackTrace();
        }
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
        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql.toString())) {
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
        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql.toString())) {
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
               + "  AND ip.status = 'PENDING' "
               + "  AND ip.purchase_order_id IS NULL "
               + "ORDER BY ip.proposal_id ASC";
    
    try (Connection c = getConnection();
         PreparedStatement ps = c.prepareStatement(sql)) {
        for (int i = 0; i < proposalIds.size(); i++) {
            ps.setInt(i + 1, proposalIds.get(i));
        }
        ResultSet rs = ps.executeQuery();
        while (rs.next()) {
           
            ImportProposal p = getFromResultSet(rs);
            p.setWarehouseName(rs.getString("warehouse_name"));
            p.setCreatedByName(rs.getString("created_by_name"));
            list.add(p);
        }
    } catch (SQLException e) {
        e.printStackTrace();
    }
    return list;
}

    @Override
    public boolean update(ImportProposal t) {
        String sql = "UPDATE import_proposal SET note = ?, status = ?, updated_at = NOW() "
                + "WHERE proposal_id = ? AND status = ?";
        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, t.getNote());
            ps.setString(2, t.getStatus());
            ps.setInt(3, t.getProposalId());
            ps.setString(4, GlobalUtils.STATUS_DRAFT);   // chỉ update khi DRAFT
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
}
