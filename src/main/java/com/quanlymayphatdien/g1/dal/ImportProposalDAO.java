/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package com.quanlymayphatdien.g1.dal;

import com.quanlymayphatdien.g1.entity.ImportProposal;
import com.quanlymayphatdien.g1.entity.ImportProposalDetail;
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
                + "u_r.name AS rejected_by_name, "
                + "rc.receipt_code AS converted_receipt_code "
                + "FROM import_proposal p "
                + "LEFT JOIN warehouse w  ON w.warehouse_id = p.warehouse_id "
                + "LEFT JOIN user u_c     ON u_c.id = p.created_by "
                + "LEFT JOIN user u_a     ON u_a.id = p.approved_by "
                + "LEFT JOIN user u_r     ON u_r.id = p.rejected_by "
                + "LEFT JOIN receipt rc   ON rc.receipt_id = p.converted_receipt_id "
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
                + "u_r.name AS rejected_by_name, "
                + "rc.receipt_code AS converted_receipt_code "
                + "FROM import_proposal p "
                + "LEFT JOIN warehouse w  ON w.warehouse_id = p.warehouse_id "
                + "LEFT JOIN user u_c     ON u_c.id = p.created_by "
                + "LEFT JOIN user u_a     ON u_a.id = p.approved_by "
                + "LEFT JOIN user u_r     ON u_r.id = p.rejected_by "
                + "LEFT JOIN receipt rc   ON rc.receipt_id = p.converted_receipt_id "
                + "WHERE p.proposal_id = ?";

        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    ImportProposal p = getFromResultSet(rs);
                    p.setDetails(findDetailsByProposalId(id));
                    return p;
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    public int countAll() {
        String sql = "SELECT COUNT(*) FROM import_proposal";
        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql); ResultSet rs = ps.executeQuery()) {
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }

    public int countByStatus(String status) {
        String sql = "SELECT COUNT(*) FROM import_proposal WHERE status = ?";
        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, status);
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
    public boolean update(ImportProposal t) {
        throw new UnsupportedOperationException("Not supported yet."); // Generated from nbfs://nbhost/SystemFileSystem/Templates/Classes/Code/GeneratedMethodBody
    }

    @Override
    public boolean delete(ImportProposal t) {
        throw new UnsupportedOperationException("Not supported yet."); // Generated from nbfs://nbhost/SystemFileSystem/Templates/Classes/Code/GeneratedMethodBody
    }

    @Override
    public int insert(ImportProposal t) {
        String sql = "INSERT INTO import_proposal (proposal_code, status, warehouse_id, created_by, "
                + "proposal_date, note) VALUES (?, ?, ?, ?, ?, ?)";
        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            ps.setString(1, t.getProposalCode());
            ps.setString(2, t.getStatus());
            ps.setInt(3, t.getWarehouseId());
            ps.setInt(4, t.getCreatedBy());
            ps.setTimestamp(5, t.getProposalDate() != null
                    ? Timestamp.valueOf(t.getProposalDate())
                    : Timestamp.valueOf(LocalDateTime.now()));
            ps.setString(6, t.getNote());

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

        int cr = rs.getInt("converted_receipt_id");
        p.setConvertedReceiptId(rs.wasNull() ? null : cr);

        Timestamp ca = rs.getTimestamp("created_at");
        p.setCreatedAt(ca != null ? ca.toLocalDateTime() : null);

        Timestamp ua = rs.getTimestamp("updated_at");
        p.setUpdatedAt(ua != null ? ua.toLocalDateTime() : null);

        p.setWarehouseName(rs.getString("warehouse_name"));
        p.setCreatedByName(rs.getString("created_by_name"));
        p.setApprovedByName(rs.getString("approved_by_name"));
        p.setRejectedByName(rs.getString("rejected_by_name"));
        p.setConvertedReceiptCode(rs.getString("converted_receipt_code"));
        return p;
    }

    public boolean insertDetail(ImportProposalDetail d) {
        String sql = "INSERT INTO import_proposal_detail (proposal_id, generator_id, quantity, "
                + "current_stock, note) VALUES (?, ?, ?, ?, ?)";
        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, d.getProposalId());
            ps.setInt(2, d.getGeneratorId());
            ps.setInt(3, d.getQuantity());
            ps.setInt(4, d.getCurrentStock());
            ps.setString(5, d.getNote());
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public List<ImportProposalDetail> findDetailsByProposalId(int proposalId) {
        List<ImportProposalDetail> list = new ArrayList<>();
        String sql = "SELECT d.*, "
                + "g.model_code AS generator_code, "
                + "g.name AS generator_name, "
                + "(SELECT c.name FROM generator_category gc "
                + "   JOIN category c ON c.id = gc.category_id "
                + "  WHERE gc.generator_id = g.id AND c.type = 'brand' LIMIT 1) AS brand_name "
                + "FROM import_proposal_detail d "
                + "LEFT JOIN generator g ON g.id = d.generator_id "
                + "WHERE d.proposal_id = ? "
                + "ORDER BY d.proposal_detail_id ASC";
        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, proposalId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    ImportProposalDetail d = new ImportProposalDetail();
                    d.setProposalDetailId(rs.getInt("proposal_detail_id"));
                    d.setProposalId(rs.getInt("proposal_id"));
                    d.setGeneratorId(rs.getInt("generator_id"));
                    d.setQuantity(rs.getInt("quantity"));
                    d.setCurrentStock(rs.getInt("current_stock"));
                    d.setNote(rs.getString("note"));
                    d.setGeneratorCode(rs.getString("generator_code"));
                    d.setGeneratorName(rs.getString("generator_name"));
                    d.setBrandName(rs.getString("brand_name"));
                    list.add(d);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

}
