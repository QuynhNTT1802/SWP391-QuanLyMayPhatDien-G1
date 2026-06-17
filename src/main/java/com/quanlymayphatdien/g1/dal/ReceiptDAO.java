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
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

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
                + "so.order_code, liq.liquidation_code, liq.liquidation_id, c.name AS customer_name, cr.name AS reason_name "
                + "FROM receipt r "
                + "LEFT JOIN warehouse w ON r.warehouse_id = w.warehouse_id "
                + "LEFT JOIN user u1 ON r.created_by = u1.id "
                + "LEFT JOIN user u2 ON r.approved_by = u2.id "
                + "LEFT JOIN sale_order so ON r.order_id = so.order_id "
                + "LEFT JOIN liquidation liq ON liq.converted_receipt_id = r.receipt_id "
                + "LEFT JOIN customer c ON so.customer_id = c.id OR liq.customer_id = c.id "
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
                + "LEFT JOIN liquidation liq ON liq.converted_receipt_id = r.receipt_id "
                + "LEFT JOIN customer c ON so.customer_id = c.id OR liq.customer_id = c.id "
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
                + "so.order_code, liq.liquidation_code, liq.liquidation_id, c.name AS customer_name, cr.name AS reason_name "
                + "FROM receipt r "
                + "LEFT JOIN warehouse w ON r.warehouse_id = w.warehouse_id "
                + "LEFT JOIN user u1 ON r.created_by = u1.id "
                + "LEFT JOIN user u2 ON r.approved_by = u2.id "
                + "LEFT JOIN sale_order so ON r.order_id = so.order_id "
                + "LEFT JOIN liquidation liq ON liq.converted_receipt_id = r.receipt_id "
                + "LEFT JOIN customer c ON so.customer_id = c.id OR liq.customer_id = c.id "
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
                + "warehouse_id, created_by, status, note, reason_id, created_at) "
                + "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
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
            statement.setTimestamp(10, Timestamp.valueOf(LocalDateTime.now()));
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

    public List<String> approveReceipt(int receiptId, int approvedBy) {
        List<String> errors = new ArrayList<>();
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
                errors.add("Phi?u kh�ng ? tr?ng th�i ch? duy?t");
                return errors;
            }
            // 2. Lay receipt_detail (join inventory de lay generator_id, serial_number)
            String detailSql = "SELECT rd.*, i.serial_number, i.generator_id "
                             + "FROM receipt_detail rd "
                             + "JOIN inventory i ON rd.inventory_id = i.inventory_id "
                             + "WHERE rd.receipt_id = ?";
            statement = connection.prepareStatement(detailSql);
            statement.setInt(1, receiptId);
            resultSet = statement.executeQuery();
            List<ReceiptDetail> details = new ArrayList<>();
            ReceiptDetailDAO rdDAO = new ReceiptDetailDAO();
            while (resultSet.next()) {
                details.add(rdDAO.getFromResultSet(resultSet));
            }

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

            // 4. Validate: IMPORT (inventory phai o PENDING_IMPORT), EXPORT (phai o RESERVED_EXPORT)
            if ("IMPORT".equals(receiptType)) {
                String chkSql = "SELECT COUNT(*) FROM receipt_detail rd "
                              + "JOIN inventory i ON rd.inventory_id = i.inventory_id "
                              + "WHERE rd.receipt_id = ? AND i.status <> ?";
                try (PreparedStatement ps = connection.prepareStatement(chkSql)) {
                    ps.setInt(1, receiptId);
                    ps.setString(2, InventoryDAO.STATUS_PENDING_IMPORT);
                    try (ResultSet rs = ps.executeQuery()) {
                        if (rs.next() && rs.getInt(1) > 0) {
                            errors.add("Có serial trong phiếu không ở trạng thái PENDING_IMPORT");
                        }
                    }
                }
            } else if ("EXPORT".equals(receiptType)) {
                String chkSql = "SELECT COUNT(*) FROM receipt_detail rd "
                              + "JOIN inventory i ON rd.inventory_id = i.inventory_id "
                              + "WHERE rd.receipt_id = ? AND i.status <> ?";
                try (PreparedStatement ps = connection.prepareStatement(chkSql)) {
                    ps.setInt(1, receiptId);
                    ps.setString(2, InventoryDAO.STATUS_RESERVED_EXPORT);
                    try (ResultSet rs = ps.executeQuery()) {
                        if (rs.next() && rs.getInt(1) > 0) {
                            errors.add("Có serial trong phiếu không ở trạng thái RESERVED_EXPORT");
                        }
                    }
                }
            }
            if (!errors.isEmpty()) {
                connection.rollback();
                return errors;
            }

            // 5. Voi moi inventory: flip status (PENDING_IMPORT -> IN_STOCK cho IMPORT,
            //                                  RESERVED_EXPORT -> SOLD/LIQUIDATED cho EXPORT)
            if ("IMPORT".equals(receiptType)) {
                String updSql = "UPDATE inventory SET status = ? "
                              + "WHERE inventory_id IN (SELECT inventory_id FROM receipt_detail WHERE receipt_id = ?) "
                              + "AND status = ?";
                try (PreparedStatement ps = connection.prepareStatement(updSql)) {
                    ps.setString(1, InventoryDAO.STATUS_IN_STOCK);
                    ps.setInt(2, receiptId);
                    ps.setString(3, InventoryDAO.STATUS_PENDING_IMPORT);
                    ps.executeUpdate();
                }
            } else if ("EXPORT".equals(receiptType)) {
                boolean isLiquidation = false;
                String checkLiqSql = "SELECT liquidation_id FROM liquidation WHERE converted_receipt_id = ?";
                try (PreparedStatement checkLiqPs = connection.prepareStatement(checkLiqSql)) {
                    checkLiqPs.setInt(1, receiptId);
                    try (ResultSet liqRs = checkLiqPs.executeQuery()) {
                        if (liqRs.next()) {
                            isLiquidation = true;
                        }
                    }
                }
                String targetStatus = isLiquidation ? InventoryDAO.STATUS_LIQUIDATED : InventoryDAO.STATUS_SOLD;
                String updSql = "UPDATE inventory SET status = ? "
                              + "WHERE inventory_id IN (SELECT inventory_id FROM receipt_detail WHERE receipt_id = ?) "
                              + "AND status = ?";
                try (PreparedStatement ps = connection.prepareStatement(updSql)) {
                    ps.setString(1, targetStatus);
                    ps.setInt(2, receiptId);
                    ps.setString(3, InventoryDAO.STATUS_RESERVED_EXPORT);
                    ps.executeUpdate();
                }
            }

            // 6. Ghi stock_card theo generator (gom theo generator_id, quantity_change = ±size)
            Map<Integer, List<ReceiptDetail>> grouped = new LinkedHashMap<>();
            for (ReceiptDetail d : details) {
                grouped.computeIfAbsent(d.getGeneratorId(), k -> new ArrayList<>()).add(d);
            }
            for (Map.Entry<Integer, List<ReceiptDetail>> entry : grouped.entrySet()) {
                int genId = entry.getKey();
                List<ReceiptDetail> groupDetails = entry.getValue();
                int totalQty = groupDetails.size();
                int change = "IMPORT".equals(receiptType) ? totalQty : -totalQty;
                int qtyAfter = 0;
                String qtySql = "SELECT COUNT(*) FROM inventory WHERE warehouse_id = ? AND generator_id = ? AND status = 'IN_STOCK'";
                try (PreparedStatement qtyPs = connection.prepareStatement(qtySql)) {
                    qtyPs.setInt(1, warehouseId);
                    qtyPs.setInt(2, genId);
                    try (ResultSet qtyRs = qtyPs.executeQuery()) {
                        if (qtyRs.next()) {
                            qtyAfter = qtyRs.getInt(1);
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
                sc.setReferenceNote("Phi?u " + receiptCode);
                sc.setCreatedAt(LocalDateTime.now());
                sc.setCreatedBy(approvedBy);
                scDAO.insert(connection, sc);
            }

            connection.commit();
            return errors;
        } catch (SQLException e) {
            try {
                if (connection != null) {
                    connection.rollback();
                }
            } catch (SQLException ex) {
                ex.printStackTrace();
            }
            e.printStackTrace();
            errors.add("L?i h? th?ng: " + e.getMessage());
            return errors;
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
        String updateSql = "UPDATE receipt SET warehouse_id = ?, note = ?, "
                + "status = ?, approved_by = NULL, reason_id = ? "
                + "WHERE receipt_id = ? AND status IN (" + placeholders + ") AND created_by = ?";
        String deleteDetailSql = "DELETE FROM receipt_detail WHERE receipt_id = ?";
        String insertDetailSql = "INSERT INTO receipt_detail "
                + "(receipt_id, inventory_id, note) VALUES (?, ?, ?)";
        Connection conn = null;
        try {
            conn = getConnection();
            conn.setAutoCommit(false);

            // Lay receipt_type va warehouse_id de biet cleanup inventory the nao
            String typeSql = "SELECT receipt_type, warehouse_id FROM receipt WHERE receipt_id = ?";
            String receiptType = "";
            int warehouseId = 0;
            try (PreparedStatement ps = conn.prepareStatement(typeSql)) {
                ps.setInt(1, r.getReceiptId());
                try (ResultSet rs = ps.executeQuery()) {
                    if (rs.next()) {
                        receiptType = rs.getString("receipt_type");
                        warehouseId = rs.getInt("warehouse_id");
                    }
                }
            }

            // Lay danh sach inventory_id cu (truoc khi xoa receipt_detail)
            List<Integer> oldInventoryIds = new ArrayList<>();
            String selInvSql = "SELECT inventory_id FROM receipt_detail WHERE receipt_id = ?";
            try (PreparedStatement ps = conn.prepareStatement(selInvSql)) {
                ps.setInt(1, r.getReceiptId());
                try (ResultSet rs = ps.executeQuery()) {
                    while (rs.next()) {
                        oldInventoryIds.add(rs.getInt("inventory_id"));
                    }
                }
            }

            // Cap nhat receipt header
            try (PreparedStatement ps = conn.prepareStatement(updateSql)) {
                ps.setInt(1, r.getWarehouseId());
                ps.setString(2, r.getNote());
                ps.setString(3, newStatus);
                if (r.getReasonId() != null) {
                    ps.setInt(4, r.getReasonId());
                } else {
                    ps.setNull(4, Types.INTEGER);
                }
                ps.setInt(5, r.getReceiptId());
                int statusIdx = 6;
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

            // Xoa receipt_detail cu truoc (tranh FK conflict khi xoa inventory sau)
            try (PreparedStatement ps = conn.prepareStatement(deleteDetailSql)) {
                ps.setInt(1, r.getReceiptId());
                ps.executeUpdate();
            }

            // Cleanup inventory rows cu:
            //   IMPORT: xoa PENDING_IMPORT rows
            //   EXPORT: rollback RESERVED_EXPORT -> IN_STOCK (giu nguyen inventory, chi doi status)
            if (!oldInventoryIds.isEmpty()) {
                String placeholdersInv = String.join(",",
                        java.util.Collections.nCopies(oldInventoryIds.size(), "?"));
                if ("IMPORT".equals(receiptType)) {
                    String delInvSql = "DELETE FROM inventory WHERE status = ? AND inventory_id IN ("
                                     + placeholdersInv + ")";
                    try (PreparedStatement ps = conn.prepareStatement(delInvSql)) {
                        ps.setString(1, InventoryDAO.STATUS_PENDING_IMPORT);
                        for (int i = 0; i < oldInventoryIds.size(); i++) {
                            ps.setInt(i + 2, oldInventoryIds.get(i));
                        }
                        ps.executeUpdate();
                    }
                } else if ("EXPORT".equals(receiptType)) {
                    String relInvSql = "UPDATE inventory SET status = ? WHERE status = ? AND inventory_id IN ("
                                     + placeholdersInv + ")";
                    try (PreparedStatement ps = conn.prepareStatement(relInvSql)) {
                        ps.setString(1, InventoryDAO.STATUS_IN_STOCK);
                        ps.setString(2, InventoryDAO.STATUS_RESERVED_EXPORT);
                        for (int i = 0; i < oldInventoryIds.size(); i++) {
                            ps.setInt(i + 3, oldInventoryIds.get(i));
                        }
                        ps.executeUpdate();
                    }
                }
            }

            // Insert receipt_detail moi (inventory_id phai duoc set boi controller truoc do)
            try (PreparedStatement ps = conn.prepareStatement(insertDetailSql)) {
                for (ReceiptDetail d : newDetails) {
                    ps.setInt(1, r.getReceiptId());
                    ps.setInt(2, d.getInventoryId());
                    ps.setString(3, d.getNote());
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
            r.setLiquidationCode(rs.getString("liquidation_code"));
            int lid = rs.getInt("liquidation_id");
            if (!rs.wasNull()) {
                r.setLiquidationId(lid);
            }
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