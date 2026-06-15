/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package com.quanlymayphatdien.g1.dal;

import com.quanlymayphatdien.g1.entity.ImportProposalDetail;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

/**
 *
 * @author Phuong Linh
 */
public class ImportProposalDetailDAO extends DBContext implements I_DAO<ImportProposalDetail> {

    public List<ImportProposalDetail> findByProposalId(int proposalId) {
        List<ImportProposalDetail> list = new ArrayList<>();
        String sql = "SELECT d.*, "
                + "g.model AS generator_code, "
                + "g.model AS generator_name, "
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
                    list.add(getFromResultSet(rs));
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
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

    public void deleteByProposalId(int proposalId) {
        String sql = "DELETE FROM import_proposal_detail WHERE proposal_id = ?";
        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, proposalId);
            ps.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    @Override
    public List<ImportProposalDetail> findAll() {
        return new ArrayList<>();
    }

    @Override
    public boolean update(ImportProposalDetail t) {
        String sql = "UPDATE import_proposal_detail SET generator_id = ?, quantity = ?, "
                + "current_stock = ?, note = ? WHERE proposal_detail_id = ?";
        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, t.getGeneratorId());
            ps.setInt(2, t.getQuantity());
            ps.setInt(3, t.getCurrentStock());
            ps.setString(4, t.getNote());
            ps.setInt(5, t.getProposalDetailId());
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    @Override
    public boolean delete(ImportProposalDetail t) {
        String sql = "DELETE FROM import_proposal_detail WHERE proposal_detail_id = ?";
        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, t.getProposalDetailId());
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    @Override
    public int insert(ImportProposalDetail t) {
        if (insertDetail(t)) {
            return t.getProposalDetailId();
        }
        return 0;
    }

    @Override
    public ImportProposalDetail getFromResultSet(ResultSet rs) throws SQLException {
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
        return d;
    }
}
