/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package com.quanlymayphatdien.g1.dal;

import com.quanlymayphatdien.g1.entity.ImportProposalDetail;
import java.math.BigDecimal;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Types;
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
                + "g.power_rating, g.frequency, g.weight, "
                + "(SELECT c.name FROM generator_category gc "
                + "   JOIN category c ON c.id = gc.category_id "
                + "  WHERE gc.generator_id = g.id AND c.type = 'brand' LIMIT 1) AS brand_name, "
                + "(SELECT c.name FROM generator_category gc "
                + "   JOIN category c ON c.id = gc.category_id "
                + "  WHERE gc.generator_id = g.id AND c.type = 'origin' LIMIT 1) AS origin_name, "
                + "(SELECT c.name FROM generator_category gc "
                + "   JOIN category c ON c.id = gc.category_id "
                + "  WHERE gc.generator_id = g.id AND c.type = 'condition' LIMIT 1) AS condition_name, "
                + "(SELECT c.name FROM generator_category gc "
                + "   JOIN category c ON c.id = gc.category_id "
                + "  WHERE gc.generator_id = g.id AND c.type = 'fuel_type' LIMIT 1) AS fuel_name, "
                + "(SELECT c.name FROM generator_category gc "
                + "   JOIN category c ON c.id = gc.category_id "
                + "  WHERE gc.generator_id = g.id AND c.type = 'phase' LIMIT 1) AS phase_name, "
                + "(SELECT c.name FROM generator_category gc "
                + "   JOIN category c ON c.id = gc.category_id "
                + "  WHERE gc.generator_id = g.id AND c.type = 'generator_type' LIMIT 1) AS gen_type_name, "
                + "s.id AS s_id, "
                + "s.name AS supplier_name, "
                + "s.phone AS supplier_phone, "
                + "s.email AS supplier_email, "
                + "s.company_name AS supplier_company "
                + "FROM import_proposal_detail d "
                + "LEFT JOIN generator g ON g.id = d.generator_id "
                + "LEFT JOIN supplier s ON s.id = d.supplier_id "
                + "WHERE d.proposal_id = ? "
                + "ORDER BY d.proposal_detail_id ASC";
        try {
            connection = getConnection();
            statement = connection.prepareStatement(sql);
            statement.setInt(1, proposalId);
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

    public boolean insertDetail(ImportProposalDetail d) {
        String sql = "INSERT INTO import_proposal_detail "
                + "(proposal_id, generator_id, supplier_id, quantity, current_stock, unit_price, note) "
                + "VALUES (?, ?, ?, ?, ?, ?, ?)";
        try {
            connection = getConnection();
            statement = connection.prepareStatement(sql);
            statement.setInt(1, d.getProposalId());
            statement.setInt(2, d.getGeneratorId());
            if (d.getSupplierId() != null) {
                statement.setInt(3, d.getSupplierId());
            } else {
                statement.setNull(3, Types.INTEGER);
            }
            statement.setInt(4, d.getQuantity());
            statement.setInt(5, d.getCurrentStock());
            if (d.getUnitPrice() != null) {
                statement.setBigDecimal(6, d.getUnitPrice());
            } else {
                statement.setNull(6, Types.DECIMAL);
            }
            statement.setString(7, d.getNote());
            return statement.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            closeResources();
        }
        return false;
    }

    public void insertDetailsBatch(List<ImportProposalDetail> details) {
        String sql = "INSERT INTO import_proposal_detail "
                + "(proposal_id, generator_id, supplier_id, quantity, current_stock, unit_price, note) "
                + "VALUES (?, ?, ?, ?, ?, ?, ?)";
        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            for (ImportProposalDetail d : details) {
                ps.setInt(1, d.getProposalId());
                ps.setInt(2, d.getGeneratorId());
                if (d.getSupplierId() != null) {
                    ps.setInt(3, d.getSupplierId());
                } else {
                    ps.setNull(3, Types.INTEGER);
                }
                ps.setInt(4, d.getQuantity());
                ps.setInt(5, d.getCurrentStock());
                if (d.getUnitPrice() != null) {
                    ps.setBigDecimal(6, d.getUnitPrice());
                } else {
                    ps.setNull(6, Types.DECIMAL);
                }
                ps.setString(7, d.getNote());
                ps.addBatch();
            }
            ps.executeBatch();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    public void deleteByProposalId(int proposalId) {
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

    @Override
    public List<ImportProposalDetail> findAll() {
        return new ArrayList<>();
    }

    @Override
    public boolean update(ImportProposalDetail t) {
        String sql = "UPDATE import_proposal_detail SET generator_id = ?, supplier_id = ?, quantity = ?, "
                + "current_stock = ?, unit_price = ?, note = ? WHERE proposal_detail_id = ?";
        try {
            connection = getConnection();
            statement = connection.prepareStatement(sql);
            statement.setInt(1, t.getGeneratorId());
            if (t.getSupplierId() != null) {
                statement.setInt(2, t.getSupplierId());
            } else {
                statement.setNull(2, Types.INTEGER);
            }
            statement.setInt(3, t.getQuantity());
            statement.setInt(4, t.getCurrentStock());
            if (t.getUnitPrice() != null) {
                statement.setBigDecimal(5, t.getUnitPrice());
            } else {
                statement.setNull(5, Types.DECIMAL);
            }
            statement.setString(6, t.getNote());
            statement.setInt(7, t.getProposalDetailId());
            return statement.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        } finally {
            closeResources();
        }
    }

    @Override
    public boolean delete(ImportProposalDetail t) {
        String sql = "DELETE FROM import_proposal_detail WHERE proposal_detail_id = ?";
        try {
            connection = getConnection();
            statement = connection.prepareStatement(sql);
            statement.setInt(1, t.getProposalDetailId());
            return statement.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        } finally {
            closeResources();
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
        int supId = rs.getInt("supplier_id");
        if (!rs.wasNull()) {
            d.setSupplierId(supId);
        }
        d.setQuantity(rs.getInt("quantity"));
        d.setCurrentStock(rs.getInt("current_stock"));
        BigDecimal up = rs.getBigDecimal("unit_price");
        if (up != null) {
            d.setUnitPrice(up);
        }
        d.setNote(rs.getString("note"));
        d.setGeneratorCode(rs.getString("generator_code"));
        d.setGeneratorName(rs.getString("generator_name"));
        d.setBrandName(rs.getString("brand_name"));
        d.setOriginName(rs.getString("origin_name"));
        d.setConditionName(rs.getString("condition_name"));
        d.setFuelName(rs.getString("fuel_name"));
        d.setPhaseName(rs.getString("phase_name"));
        d.setGenTypeName(rs.getString("gen_type_name"));
        BigDecimal pr = rs.getBigDecimal("power_rating");
        if (pr != null) d.setPowerRating(pr);
        d.setFrequency(rs.getString("frequency"));
        BigDecimal w = rs.getBigDecimal("weight");
        if (w != null) d.setWeight(w);
        d.setSupplierName(rs.getString("supplier_name"));
        d.setSupplierPhone(rs.getString("supplier_phone"));
        d.setSupplierEmail(rs.getString("supplier_email"));
        d.setSupplierCompany(rs.getString("supplier_company"));
        return d;
    }
}
