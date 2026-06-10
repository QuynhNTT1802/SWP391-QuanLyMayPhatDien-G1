/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package com.quanlymayphatdien.g1.dal;

import com.quanlymayphatdien.g1.entity.Receipt;
import com.quanlymayphatdien.g1.entity.ReceiptDetail;
import com.quanlymayphatdien.g1.entity.StockCard;
import com.quanlymayphatdien.g1.utils.GlobalUtils;
import java.sql.*;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;

/**
 *
 * @author FPTShop
 */
public class ReceiptDAO extends DBContext implements I_DAO<Receipt> {

    public String generateReceiptCode(String type) {
        String prefix = "IMPORT".equals(type) ? "RX-IM" : "RX-EX";
        String date = LocalDateTime.now().toString().substring(0, 10).replace("-", "");
        String suffix = String.format("%03d", System.currentTimeMillis() % 1000);
        return prefix + "-" + date + "-" + suffix;
    }

    public List<Receipt> findWithFilters(String typeFilter, String statusFilter, String whFilter,
            String search, Integer createdByFilter, int page, int pageSize, Integer currentUserId) {
        List<Receipt> allReceipts = new ArrayList<>();
        String sql = "SELECT r.*, w.name AS warehouse_name, "
                + "u1.name AS created_by_name, u2.name AS approved_by_name, "
                + "so.order_code, c.name AS customer_name, cr.name AS reason_name, "
                + "ip.proposal_code "
                + "FROM receipt r "
                + "LEFT JOIN warehouse w ON r.warehouse_id = w.warehouse_id "
                + "LEFT JOIN user u1 ON r.created_by = u1.id "
                + "LEFT JOIN user u2 ON r.approved_by = u2.id "
                + "LEFT JOIN sale_order so ON r.order_id = so.order_id "
                + "LEFT JOIN customer c ON so.customer_id = c.id "
                + "LEFT JOIN import_proposal ip ON r.proposal_id = ip.proposal_id "
                + "LEFT JOIN category cr ON r.reason_id = cr.id "
                + "WHERE 1=1 ";
        List<Object> inputs = new ArrayList<>();
        if (typeFilter != null && !typeFilter.isEmpty()) {
            sql += "AND r.receipt_type = ? ";
            inputs.add(typeFilter);
        }
        if (statusFilter != null && !statusFilter.isEmpty()) {
            sql += "AND r.status = ? ";
            inputs.add(statusFilter);
        }
        if (whFilter != null && !whFilter.isEmpty()) {
            sql += "AND r.warehouse_id = ? ";
            inputs.add(whFilter);
        }
        if (createdByFilter != null) {
            sql += "AND r.created_by = ? ";
            inputs.add(createdByFilter);
        }
        if (currentUserId != null) {
            sql += "AND (r.status <> '" + GlobalUtils.RECEIPT_STATUS_DRAFT + "' OR r.created_by = ?) ";
            inputs.add(currentUserId);
        }
        if (search != null && !search.trim().isEmpty()) {
            sql += "AND (r.receipt_code LIKE ? OR so.order_code LIKE ? "
                    + "OR c.name LIKE ? OR u1.name LIKE ? OR ip.proposal_code LIKE ?) ";
            String like = "%" + search.trim() + "%";
            inputs.add(like);
            inputs.add(like);
            inputs.add(like);
            inputs.add(like);
            inputs.add(like);
        }
        sql += "ORDER BY r.created_at DESC";
        try {
            connection = getConnection();
            statement = connection.prepareStatement(sql);
            for (int i = 0; i < inputs.size(); i++) {
                statement.setObject(i + 1, inputs.get(i));
            }
            resultSet = statement.executeQuery();
            while (resultSet.next()) {
                allReceipts.add(getFromResultSet(resultSet));
            }
            if (allReceipts.isEmpty()) {
                return allReceipts;
            }
            int start = (page - 1) * pageSize;
            int end = Math.min(start + pageSize, allReceipts.size());
            if (start > allReceipts.size()) {
                return new ArrayList<>();
            }
            return allReceipts.subList(start, end);
        } catch (SQLException ex) {
            System.out.println(ex.getMessage());
        }
        return new ArrayList<>();
    }

    public int countWithFilters(String typeFilter, String statusFilter, String whFilter, String search, Integer createdByFilter, Integer currentUserId) {
        String sql = "SELECT COUNT(*) FROM receipt r "
                + "LEFT JOIN user u1 ON r.created_by = u1.id "
                + "LEFT JOIN sale_order so ON r.order_id = so.order_id "
                + "LEFT JOIN customer c ON so.customer_id = c.id "
                + "LEFT JOIN import_proposal ip ON r.proposal_id = ip.proposal_id "
                + "LEFT JOIN category cr ON r.reason_id = cr.id "
                + "WHERE 1=1 ";
        List<Object> inputs = new ArrayList<>();
        if (typeFilter != null && !typeFilter.isEmpty()) {
            sql += "AND r.receipt_type = ? ";
            inputs.add(typeFilter);
        }
        if (statusFilter != null && !statusFilter.isEmpty()) {
            sql += "AND r.status = ? ";
            inputs.add(statusFilter);
        }
        if (whFilter != null && !whFilter.isEmpty()) {
            sql += "AND r.warehouse_id = ? ";
            inputs.add(whFilter);
        }
        if (createdByFilter != null) {
            sql += "AND r.created_by = ? ";
            inputs.add(createdByFilter);
        }
        if (currentUserId != null) {
            sql += "AND (r.status <> '" + GlobalUtils.RECEIPT_STATUS_DRAFT + "' OR r.created_by = ?) ";
            inputs.add(currentUserId);
        }
        if (search != null && !search.trim().isEmpty()) {
            sql += "AND (r.receipt_code LIKE ? OR so.order_code LIKE ? "
                    + "OR c.name LIKE ? OR u1.name LIKE ? OR ip.proposal_code LIKE ?) ";
            String like = "%" + search.trim() + "%";
            inputs.add(like);
            inputs.add(like);
            inputs.add(like);
            inputs.add(like);
            inputs.add(like);
        }
        try {
            connection = getConnection();
            statement = connection.prepareStatement(sql);
            for (int i = 0; i < inputs.size(); i++) {
                statement.setObject(i + 1, inputs.get(i));
            }
            resultSet = statement.executeQuery();
            if (resultSet.next()) {
                return resultSet.getInt(1);
            }
        } catch (SQLException ex) {
            System.out.println(ex.getMessage());
        }
        return 0;
    }

    public Receipt findById(int receiptId) {
        String sql = "SELECT r.*, w.name AS warehouse_name, "
                + "u1.name AS created_by_name, u2.name AS approved_by_name, "
                + "so.order_code, c.name AS customer_name, cr.name AS reason_name, "
                + "ip.proposal_code "
                + "FROM receipt r "
                + "LEFT JOIN warehouse w ON r.warehouse_id = w.warehouse_id "
                + "LEFT JOIN user u1 ON r.created_by = u1.id "
                + "LEFT JOIN user u2 ON r.approved_by = u2.id "
                + "LEFT JOIN sale_order so ON r.order_id = so.order_id "
                + "LEFT JOIN customer c ON so.customer_id = c.id "
                + "LEFT JOIN import_proposal ip ON r.proposal_id = ip.proposal_id "
                + "LEFT JOIN category cr ON r.reason_id = cr.id "
                + "WHERE r.receipt_id = ?";
        try {
            connection = getConnection();
            statement = connection.prepareStatement(sql);
            statement.setInt(1, receiptId);
            resultSet = statement.executeQuery();
            if (resultSet.next()) {
                Receipt r = getFromResultSet(resultSet);
                ReceiptDetailDAO rdDAO = new ReceiptDetailDAO();
                r.setDetails(rdDAO.findByReceiptId(receiptId));
                return r;
            }
        } catch (SQLException e) {
            System.out.println(e.getMessage());
        }
        return null;
    }

    @Override
    public int insert(Receipt r) {
        String status = r.getStatus();
        if (status == null || status.trim().isEmpty()) {
            status = GlobalUtils.RECEIPT_STATUS_PENDING;
        }
        String sql = "INSERT INTO receipt (receipt_code, receipt_type, order_id, proposal_id, "
                + "warehouse_id, created_by, status, note, reason_id, total_amount, created_at) "
                + "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
        try {
            connection = getConnection();
            statement = connection.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS);
            statement.setString(1, r.getReceiptCode());
            statement.setString(2, r.getReceiptType());
            if (r.getOrderId() != null) {
                statement.setInt(3, r.getOrderId());
            } else {
                statement.setNull(3, Types.INTEGER);
            }
            if (r.getProposalId() != null) {
                statement.setInt(4, r.getProposalId());
            } else {
                statement.setNull(4, Types.INTEGER);
            }
            statement.setInt(5, r.getWarehouseId());
            statement.setInt(6, r.getCreatedBy());
            statement.setString(7, status);
            statement.setString(8, r.getNote());
            if (r.getReasonId() != null) {
                statement.setInt(9, r.getReasonId());
            } else {
                statement.setNull(9, Types.INTEGER);
            }
            if (r.getTotalAmount() != null) {
                statement.setBigDecimal(10, r.getTotalAmount());
            } else {
                statement.setNull(10, Types.DECIMAL);
            }
            statement.setTimestamp(11, Timestamp.valueOf(LocalDateTime.now()));
            int affectedRows = statement.executeUpdate();
            if (affectedRows > 0) {
                resultSet = statement.getGeneratedKeys();
                if (resultSet.next()) {
                    return resultSet.getInt(1);
                }
            }
        } catch (SQLException e) {
            System.out.println(e.getMessage());
        } finally {
            closeResources();
        }
        return -1;
    }

    public boolean approveReceipt(int receiptId, int approvedBy) {
        try {
            connection = getConnection();
            connection.setAutoCommit(false);
            // 1. Update receipt status
            String updateSql = "UPDATE receipt SET status = '" + GlobalUtils.RECEIPT_STATUS_COMPLETED + "', "
                    + "approved_by = ?, approved_at = ? "
                    + "WHERE receipt_id = ? AND status = '" + GlobalUtils.RECEIPT_STATUS_PENDING + "'";
            statement = connection.prepareStatement(updateSql);
            statement.setInt(1, approvedBy);
            statement.setTimestamp(2, Timestamp.valueOf(LocalDateTime.now()));
            statement.setInt(3, receiptId);
            int updated = statement.executeUpdate();
            if (updated == 0) {
                connection.rollback();
                return false;
            }
            // 2. Lấy receipt_detail
            String detailSql = "SELECT * FROM receipt_detail WHERE receipt_id = ?";
            statement = connection.prepareStatement(detailSql);
            statement.setInt(1, receiptId);
            resultSet = statement.executeQuery();
            List<ReceiptDetail> details = new ArrayList<>();
            ReceiptDetailDAO rdDAO = new ReceiptDetailDAO();
            while (resultSet.next()) {
                details.add(rdDAO.getFromResultSet(resultSet));
            }
            // 3. Lấy receipt_type để biết IMPORT hay EXPORT
            String typeSql = "SELECT receipt_type, warehouse_id, receipt_code FROM receipt WHERE receipt_id = ?";
            statement = connection.prepareStatement(typeSql);
            statement.setInt(1, receiptId);
            resultSet = statement.executeQuery();
            String receiptType = "";
            int warehouseId = 0;
            String receiptCode = "";
            if (resultSet.next()) {
                receiptType = resultSet.getString("receipt_type");
                warehouseId = resultSet.getInt("warehouse_id");
                receiptCode = resultSet.getString("receipt_code");
            }
            InventoryDAO invDAO = new InventoryDAO();
            StockCardDAO scDAO = new StockCardDAO();
            // 4. Update inventory + ghi stock_card cho từng detail
            for (ReceiptDetail detail : details) {
                int genId = detail.getGeneratorId();
                int qty = detail.getQuantity();
                int change = "IMPORT".equals(receiptType) ? qty : -qty;
                invDAO.updateQuantity(connection, warehouseId, genId, change);
                int qtyAfter = change;
                String qtySql = "SELECT quantity FROM inventory WHERE warehouse_id = ? AND generator_id = ?";
                try (PreparedStatement qtyPs = connection.prepareStatement(qtySql)) {
                    qtyPs.setInt(1, warehouseId);
                    qtyPs.setInt(2, genId);
                    try (ResultSet qtyRs = qtyPs.executeQuery()) {
                        if (qtyRs.next()) {
                            qtyAfter = qtyRs.getInt("quantity");
                        }
                    }
                }
                StockCard sc = new StockCard();
                sc.setWarehouseId(warehouseId);
                sc.setGeneratorId(genId);
                sc.setReceiptId(receiptId);
                sc.setTransactionType(receiptType);
                sc.setQuantityChange(change);
                sc.setQuantityAfter(qtyAfter);
                sc.setReferenceNote("Phiếu " + receiptCode);
                sc.setCreatedAt(LocalDateTime.now());
                sc.setCreatedBy(approvedBy);
                scDAO.insert(connection, sc);
            }
            connection.commit();
            return true;
        } catch (SQLException e) {
            try {
                if (connection != null) {
                    connection.rollback();
                }
            } catch (SQLException ex) {
                ex.printStackTrace();
            }
            e.printStackTrace();
            return false;
        } finally {
            try {
                if (connection != null) {
                    connection.setAutoCommit(true);
                }
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
    }

    public boolean rejectReceipt(int receiptId, int approvedBy, Integer reasonId, String reasonNote) {
        String sql = "UPDATE receipt SET status = '" + GlobalUtils.RECEIPT_STATUS_CANCELLED + "', approved_by = ?, "
                + "approved_at = ?, reason_id = ?, reason_note = ? "
                + "WHERE receipt_id = ? AND status = '" + GlobalUtils.RECEIPT_STATUS_PENDING + "'";
        try {
            connection = getConnection();
            statement = connection.prepareStatement(sql);
            statement.setInt(1, approvedBy);
            statement.setTimestamp(2, Timestamp.valueOf(LocalDateTime.now()));
            if (reasonId != null) {
                statement.setInt(3, reasonId);
            } else {
                statement.setNull(3, Types.INTEGER);
            }
            if (reasonNote != null && !reasonNote.trim().isEmpty()) {
                statement.setString(4, reasonNote.trim());
            } else {
                statement.setNull(4, Types.VARCHAR);
            }
            statement.setInt(5, receiptId);
            return statement.executeUpdate() > 0;
        } catch (SQLException e) {
            System.out.println(e.getMessage());
        }
        return false;
    }

    public boolean requestRevision(int receiptId, int managerId, Integer reasonId, String reasonNote) {
        String sql = "UPDATE receipt SET status = '" + GlobalUtils.RECEIPT_STATUS_REVISION + "', approved_by = ?, "
                + "reason_id = ?, reason_note = ? "
                + "WHERE receipt_id = ? AND status = '" + GlobalUtils.RECEIPT_STATUS_PENDING + "'";
        try {
            connection = getConnection();
            statement = connection.prepareStatement(sql);
            statement.setInt(1, managerId);
            if (reasonId != null) {
                statement.setInt(2, reasonId);
            } else {
                statement.setNull(2, Types.INTEGER);
            }
            if (reasonNote != null && !reasonNote.trim().isEmpty()) {
                statement.setString(3, reasonNote.trim());
            } else {
                statement.setNull(3, Types.VARCHAR);
            }
            statement.setInt(4, receiptId);
            return statement.executeUpdate() > 0;
        } catch (SQLException e) {
            System.out.println(e.getMessage());
        }
        return false;
    }

    public boolean updateReceipt(Receipt r, List<ReceiptDetail> newDetails, int userId) {
        return updateReceiptInternalMulti(r, newDetails, userId,
                GlobalUtils.RECEIPT_STATUS_PENDING, new String[]{GlobalUtils.RECEIPT_STATUS_REVISION});
    }

    public boolean updateDraftReceipt(Receipt r, List<ReceiptDetail> newDetails, int userId, String newStatus) {
        String target = GlobalUtils.RECEIPT_STATUS_DRAFT.equals(newStatus)
                ? GlobalUtils.RECEIPT_STATUS_DRAFT
                : GlobalUtils.RECEIPT_STATUS_PENDING;
        return updateReceiptInternalMulti(r, newDetails, userId,
                target, new String[]{GlobalUtils.RECEIPT_STATUS_DRAFT, GlobalUtils.RECEIPT_STATUS_REVISION});
    }

    private boolean updateReceiptInternalMulti(Receipt r, List<ReceiptDetail> newDetails, int userId,
            String newStatus, String[] allowedCurrentStatuses) {
        StringBuilder placeholders = new StringBuilder();
        for (int i = 0; i < allowedCurrentStatuses.length; i++) {
            if (i > 0) {
                placeholders.append(",");
            }
            placeholders.append("?");
        }
        String updateSql = "UPDATE receipt SET warehouse_id = ?, note = ?, total_amount = ?, "
                + "status = ?, approved_by = NULL, reason_id = ? "
                + "WHERE receipt_id = ? AND status IN (" + placeholders + ") AND created_by = ?";
        String deleteDetailSql = "DELETE FROM receipt_detail WHERE receipt_id = ?";
        String insertDetailSql = "INSERT INTO receipt_detail "
                + "(receipt_id, generator_id, serial_number, quantity, unit_price, note) VALUES (?, ?, ?, ?, ?, ?)";
        Connection conn = null;
        try {
            conn = getConnection();
            conn.setAutoCommit(false);

            try (PreparedStatement ps = conn.prepareStatement(updateSql)) {
                ps.setInt(1, r.getWarehouseId());
                ps.setString(2, r.getNote());
                if (r.getTotalAmount() != null) {
                    ps.setBigDecimal(3, r.getTotalAmount());
                } else {
                    ps.setNull(3, Types.DECIMAL);
                }
                ps.setString(4, newStatus);
                if (r.getReasonId() != null) {
                    ps.setInt(5, r.getReasonId());
                } else {
                    ps.setNull(5, Types.INTEGER);
                }
                ps.setInt(6, r.getReceiptId());
                int statusIdx = 7;
                for (String s : allowedCurrentStatuses) {
                    ps.setString(statusIdx++, s);
                }
                ps.setInt(statusIdx, userId);
                int affected = ps.executeUpdate();
                if (affected == 0) {
                    conn.rollback();
                    return false;
                }
            }

            try (PreparedStatement ps = conn.prepareStatement(deleteDetailSql)) {
                ps.setInt(1, r.getReceiptId());
                ps.executeUpdate();
            }

            try (PreparedStatement ps = conn.prepareStatement(insertDetailSql)) {
                for (ReceiptDetail d : newDetails) {
                    ps.setInt(1, r.getReceiptId());
                    ps.setInt(2, d.getGeneratorId());
                    ps.setString(3, d.getSerialNumber());
                    ps.setInt(4, d.getQuantity());
                    if (d.getUnitPrice() != null) {
                        ps.setBigDecimal(5, d.getUnitPrice());
                    } else {
                        ps.setNull(5, java.sql.Types.DECIMAL);
                    }
                    ps.setString(6, d.getNote());
                    ps.addBatch();
                }
                ps.executeBatch();
            }

            conn.commit();
            return true;
        } catch (SQLException e) {
            if (conn != null) {
                try {
                    conn.rollback();
                } catch (SQLException ex) {
                    ex.printStackTrace();
                }
            }
            e.printStackTrace();
            return false;
        } finally {
            if (conn != null) {
                try {
                    conn.setAutoCommit(true);
                    conn.close();
                } catch (SQLException ignored) {
                }
            }
        }
    }

    @Override
    public List<Receipt> findAll() {
        throw new UnsupportedOperationException("Not supported yet."); // Generated from nbfs://nbhost/SystemFileSystem/Templates/Classes/Code/GeneratedMethodBody
    }

    @Override
    public boolean update(Receipt t) {
        throw new UnsupportedOperationException("Not supported yet."); // Generated from nbfs://nbhost/SystemFileSystem/Templates/Classes/Code/GeneratedMethodBody
    }

    @Override
    public boolean delete(Receipt t) {
        throw new UnsupportedOperationException("Not supported yet."); // Generated from nbfs://nbhost/SystemFileSystem/Templates/Classes/Code/GeneratedMethodBody
    }

    @Override
    public Receipt getFromResultSet(ResultSet rs) throws SQLException {
        Receipt r = new Receipt();
        r.setReceiptId(rs.getInt("receipt_id"));
        r.setReceiptCode(rs.getString("receipt_code"));
        r.setReceiptType(rs.getString("receipt_type"));
        int oid = rs.getInt("order_id");
        if (rs.wasNull()) {
            r.setOrderId(null);
        } else {
            r.setOrderId(oid);
        }
        int pid = rs.getInt("proposal_id");
        if (rs.wasNull()) {
            r.setProposalId(null);
        } else {
            r.setProposalId(pid);
        }
        r.setWarehouseId(rs.getInt("warehouse_id"));
        r.setCreatedBy(rs.getInt("created_by"));
        int aid = rs.getInt("approved_by");
        if (rs.wasNull()) {
            r.setApprovedBy(null);
        } else {
            r.setApprovedBy(aid);
        }
        r.setStatus(rs.getString("status"));
        r.setNote(rs.getString("note"));
        Timestamp aa = rs.getTimestamp("approved_at");
        if (aa != null) {
            r.setApprovedAt(aa.toLocalDateTime());
        }
        Timestamp ca = rs.getTimestamp("created_at");
        if (ca != null) {
            r.setCreatedAt(ca.toLocalDateTime());
        }
        Timestamp ua = rs.getTimestamp("updated_at");
        if (ua != null) {
            r.setUpdatedAt(ua.toLocalDateTime());
        }
        try {
            r.setTotalAmount(rs.getBigDecimal("total_amount"));
        } catch (SQLException ignored) {
        }
        try {
            r.setWarehouseName(rs.getString("warehouse_name"));
        } catch (SQLException ignored) {
        }
        try {
            r.setCreatedByName(rs.getString("created_by_name"));
        } catch (SQLException ignored) {
        }
        try {
            r.setApprovedByName(rs.getString("approved_by_name"));
        } catch (SQLException ignored) {
        }
        try {
            r.setOrderCode(rs.getString("order_code"));
        } catch (SQLException ignored) {
        }
        try {
            r.setCustomerName(rs.getString("customer_name"));
        } catch (SQLException ignored) {
        }
        try {
            r.setProposalCode(rs.getString("proposal_code"));
        } catch (SQLException ignored) {
        }
        int rid = rs.getInt("reason_id");
        if (!rs.wasNull()) {
            r.setReasonId(rid);
        }
        try {
            r.setReasonNote(rs.getString("reason_note"));
        } catch (SQLException ignored) {
        }
        try {
            r.setReasonName(rs.getString("reason_name"));
        } catch (SQLException ignored) {
        }
        return r;
    }

}
