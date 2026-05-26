/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package com.quanlymayphatdien.g1.dal;

import com.quanlymayphatdien.g1.entity.Inventory;
import com.quanlymayphatdien.g1.entity.Receipt;
import com.quanlymayphatdien.g1.entity.ReceiptDetail;
import com.quanlymayphatdien.g1.entity.StockCard;
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
            String search, int page, int pageSize) {
        List<Receipt> allReceipts = new ArrayList<>();
        String sql = "SELECT r.*, w.name AS warehouse_name, "
                + "u1.name AS created_by_name, u2.name AS approved_by_name, "
                + "so.order_code, so.customer_name "
                + "FROM receipt r "
                + "LEFT JOIN warehouse w ON r.warehouse_id = w.warehouse_id "
                + "LEFT JOIN user u1 ON r.created_by = u1.id "
                + "LEFT JOIN user u2 ON r.approved_by = u2.id "
                + "LEFT JOIN sale_order so ON r.order_id = so.order_id "
                + "WHERE 1=1 ";
        List<String> inputs = new ArrayList<>();
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
        if (search != null && !search.trim().isEmpty()) {
            sql += "AND (r.receipt_code LIKE ? OR so.order_code LIKE ? "
                 + "OR so.customer_name LIKE ? OR u1.name LIKE ?) ";
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
                statement.setString(i + 1, inputs.get(i));
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

    public int countWithFilters(String typeFilter, String statusFilter, String whFilter, String search) {
        String sql = "SELECT COUNT(*) FROM receipt r "
                + "LEFT JOIN user u1 ON r.created_by = u1.id "
                + "LEFT JOIN sale_order so ON r.order_id = so.order_id "
                + "WHERE 1=1 ";
        List<String> inputs = new ArrayList<>();
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
        if (search != null && !search.trim().isEmpty()) {
            sql += "AND (r.receipt_code LIKE ? OR so.order_code LIKE ? "
                 + "OR so.customer_name LIKE ? OR u1.name LIKE ?) ";
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
                statement.setString(i + 1, inputs.get(i));
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
                + "so.order_code, so.customer_name "
                + "FROM receipt r "
                + "LEFT JOIN warehouse w ON r.warehouse_id = w.warehouse_id "
                + "LEFT JOIN user u1 ON r.created_by = u1.id "
                + "LEFT JOIN user u2 ON r.approved_by = u2.id "
                + "LEFT JOIN sale_order so ON r.order_id = so.order_id "
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
        String sql = "INSERT INTO receipt (receipt_code, receipt_type, order_id, "
                + "warehouse_id, created_by, status, note, created_at) "
                + "VALUES (?, ?, ?, ?, ?, 'PENDING_RECONCILIATION', ?, ?)";
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
            statement.setString(6, r.getNote());
            statement.setTimestamp(7, Timestamp.valueOf(LocalDateTime.now()));
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
            String updateSql = "UPDATE receipt SET status = 'COMPLETED', "
                    + "approved_by = ?, approved_at = ? "
                    + "WHERE receipt_id = ? AND status = 'PENDING_RECONCILIATION'";
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
                        if (qtyRs.next()) qtyAfter = qtyRs.getInt("quantity");
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

    public boolean rejectReceipt(int receiptId, int approvedBy, String reason) {
        String sql = "UPDATE receipt SET status = 'CANCELLED', approved_by = ?, "
                + "approved_at = ?, "
                + "note = CONCAT(COALESCE(note, ''), ' | Lý do từ chối: ', ?) "
                + "WHERE receipt_id = ? AND status = 'PENDING_RECONCILIATION'";
        try {
            connection = getConnection();
            statement = connection.prepareStatement(sql);
            statement.setInt(1, approvedBy);
            statement.setTimestamp(2, Timestamp.valueOf(LocalDateTime.now()));
            statement.setString(3, reason);
            statement.setInt(4, receiptId);
            return statement.executeUpdate() > 0;
        } catch (SQLException e) {
            System.out.println(e.getMessage());
        }
        return false;
    }

    public boolean requestRevision(int receiptId, int managerId, String reason) {
        String sql = "UPDATE receipt SET status = 'NEEDS_REVISION', approved_by = ?, "
                + "note = CONCAT(COALESCE(note, ''), ' | Lý do yêu cầu chỉnh sửa: ', ?) "
                + "WHERE receipt_id = ? AND status = 'PENDING_RECONCILIATION'";
        try {
            connection = getConnection();
            statement = connection.prepareStatement(sql);
            statement.setInt(1, managerId);
            statement.setString(2, reason);
            statement.setInt(3, receiptId);
            return statement.executeUpdate() > 0;
        } catch (SQLException e) {
            System.out.println(e.getMessage());
        }
        return false;
    }

    public boolean updateReceipt(Receipt r, List<ReceiptDetail> newDetails, int userId) {
        String updateSql = "UPDATE receipt SET warehouse_id = ?, note = ?, "
                + "status = 'PENDING_RECONCILIATION', approved_by = NULL "
                + "WHERE receipt_id = ? AND status = 'NEEDS_REVISION' AND created_by = ?";
        String deleteDetailSql = "DELETE FROM receipt_detail WHERE receipt_id = ?";
        String insertDetailSql = "INSERT INTO receipt_detail "
                + "(receipt_id, generator_id, serial_number, quantity, note) VALUES (?, ?, ?, ?, ?)";
        Connection conn = null;
        try {
            conn = getConnection();
            conn.setAutoCommit(false);

            try (PreparedStatement ps = conn.prepareStatement(updateSql)) {
                ps.setInt(1, r.getWarehouseId());
                ps.setString(2, r.getNote());
                ps.setInt(3, r.getReceiptId());
                ps.setInt(4, userId);
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
                    ps.setString(5, d.getNote());
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
        return r;
    }

}
