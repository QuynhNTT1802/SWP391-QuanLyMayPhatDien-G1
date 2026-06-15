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
                    + "OR c.name LIKE ? OR u1.name LIKE ?) ";
            String like = "%" + search.trim() + "%";
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
                    + "OR c.name LIKE ? OR u1.name LIKE ?) ";
            String like = "%" + search.trim() + "%";
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
        String sql = "INSERT INTO receipt (receipt_code, receipt_type, order_id, "
                + "warehouse_id, created_by, status, note, reason_id, total_amount, created_at) "
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
            statement.setInt(4, r.getWarehouseId());
            statement.setInt(5, r.getCreatedBy());
            statement.setString(6, status);
            statement.setString(7, r.getNote());
            if (r.getReasonId() != null) {
                statement.setInt(8, r.getReasonId());
            } else {
                statement.setNull(8, Types.INTEGER);
            }
            if (r.getTotalAmount() != null) {
                statement.setBigDecimal(9, r.getTotalAmount());
            } else {
                statement.setNull(9, Types.DECIMAL);
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
                errors.add("Phiếu không ở trạng thái chờ duyệt");
                return errors;
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

            // 4. Validate serial (IMPORT: khong duoc trung; EXPORT: phai IN_STOCK o dung kho)
            if ("IMPORT".equals(receiptType)) {
                for (ReceiptDetail d : details) {
                    if (d.getSerialNumber() != null && !d.getSerialNumber().trim().isEmpty()) {
                        if (invDAO.isSerialExists(connection, d.getSerialNumber().trim())) {
                            errors.add("Serial \"" + d.getSerialNumber().trim() + "\" đã tồn tại trong hệ thống");
                        }
                    }
                }
            } else if ("EXPORT".equals(receiptType)) {
                for (ReceiptDetail d : details) {
                    if (d.getSerialNumber() != null && !d.getSerialNumber().trim().isEmpty()) {
                        if (!invDAO.isInStockAtWarehouse(connection, d.getSerialNumber().trim(), warehouseId)) {
                            errors.add("Serial \"" + d.getSerialNumber().trim() + "\" không tồn tại IN_STOCK ở kho này");
                        }
                    }
                }
            }
            if (!errors.isEmpty()) {
                connection.rollback();
                return errors;
            }

            // 5. Voi moi dong receipt_detail: ghi 1 stock_card (quantity_change = ±quantity, quantity_after = COUNT(inventory WHERE IN_STOCK))
            //    Voi moi serial: them moi (IMPORT) hoac doi status (EXPORT)
            for (ReceiptDetail d : details) {
                if (d.getSerialNumber() == null || d.getSerialNumber().trim().isEmpty()) {
                    continue;
                }
                String serial = d.getSerialNumber().trim();

                if ("IMPORT".equals(receiptType)) {
                    // Insert serial moi vao inventory
                    try {
                        invDAO.insert(connection, d.getGeneratorId(), serial, warehouseId, InventoryDAO.STATUS_IN_STOCK);
                    } catch (SQLException ex) {
                        if (ex.getMessage() != null && ex.getMessage().contains("Duplicate")) {
                            errors.add("Serial \"" + serial + "\" đã tồn tại (UNIQUE conflict)");
                        } else {
                            throw ex;
                        }
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
                    invDAO.updateStatusBySerial(connection, serial, targetStatus);
                }
            }
            if (!errors.isEmpty()) {
                connection.rollback();
                return errors;
            }

            // 6. Ghi stock_card theo generator (gom theo generator_id, quantity_change = ±totalQty)
            Map<Integer, List<ReceiptDetail>> grouped = new LinkedHashMap<>();
            for (ReceiptDetail d : details) {
                grouped.computeIfAbsent(d.getGeneratorId(), k -> new ArrayList<>()).add(d);
            }
            for (Map.Entry<Integer, List<ReceiptDetail>> entry : grouped.entrySet()) {
                int genId = entry.getKey();
                List<ReceiptDetail> groupDetails = entry.getValue();
                int totalQty = 0;
                for (ReceiptDetail gd : groupDetails) {
                    totalQty += gd.getQuantity();
                }
                int change = "IMPORT".equals(receiptType) ? totalQty : -totalQty;
                // Tinh quantity_after = COUNT(inventory WHERE IN_STOCK AND warehouse=? AND generator=?)
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
                sc.setReferenceNote("Phiếu " + receiptCode);
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
            errors.add("Lỗi hệ thống: " + e.getMessage());
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
