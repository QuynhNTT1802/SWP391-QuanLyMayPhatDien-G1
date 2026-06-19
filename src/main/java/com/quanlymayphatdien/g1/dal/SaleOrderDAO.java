/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package com.quanlymayphatdien.g1.dal;

import com.quanlymayphatdien.g1.entity.Admin;
import com.quanlymayphatdien.g1.entity.Customer;
import com.quanlymayphatdien.g1.entity.OrderDetail;
import com.quanlymayphatdien.g1.entity.SaleOrder;
import com.quanlymayphatdien.g1.utils.GlobalUtils;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;

/**
 *
 * @author Phuong Linh
 */
public class SaleOrderDAO extends DBContext implements I_DAO<SaleOrder> {

    public List<SaleOrder> findByStatus(String status) {
        List<SaleOrder> list = new ArrayList<>();
        String sql = "SELECT so.*, "
                + "u_created.name AS created_by_name, "
                + "u_approved.name AS approved_by_name, "
                + "u_cancelled.name AS cancelled_by_name, "
                + "c.name AS customer_name, "
                + "c.phone AS customer_phone, "
                + "c.email AS customer_email, "
                + "c.address AS customer_address, "
                + "c.company_name AS customer_company_name "
                + "FROM sale_order so "
                + "LEFT JOIN user u_created ON so.created_by = u_created.id "
                + "LEFT JOIN user u_approved ON so.approved_by = u_approved.id "
                + "LEFT JOIN user u_cancelled ON so.cancelled_by = u_cancelled.id "
                + "LEFT JOIN customer c ON so.customer_id = c.id "
                + "WHERE status = ?";

        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, status);

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

    public List<SaleOrder> searchByNameCode(String search, String status, int userId) {
        List<SaleOrder> list = new ArrayList<>();
        StringBuilder sql = new StringBuilder(
                "SELECT so.*, "
                + "u_created.name AS created_by_name, "
                + "u_approved.name AS approved_by_name, "
                + "u_cancelled.name AS cancelled_by_name, "
                + "c.name AS customer_name, "
                + "c.phone AS customer_phone, "
                + "c.email AS customer_email, "
                + "c.address AS customer_address, "
                + "c.company_name AS customer_company_name "
                + "FROM sale_order so "
                + "LEFT JOIN user u_created ON so.created_by = u_created.id "
                + "LEFT JOIN user u_approved ON so.approved_by = u_approved.id "
                + "LEFT JOIN user u_cancelled ON so.cancelled_by = u_cancelled.id "
                + "LEFT JOIN customer c ON so.customer_id = c.id "
                + "WHERE 1=1"
        );
        List<Object> param = new ArrayList<>();

        if (status != null && !status.trim().isEmpty()) {
            sql.append(" AND so.status = ?");
            param.add(status);
        }

        if (search != null && !search.trim().isEmpty()) {
            sql.append(" AND (so.order_code LIKE ? OR c.name LIKE ?)");
            String pattern = "%" + search.trim() + "%";
            param.add(pattern);
            param.add(pattern);
        }

        if (userId > 0) {
            sql.append(" AND so.created_by = ?");
            param.add(userId);
        }

        sql.append(" ORDER BY so.created_at DESC");

        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql.toString())) {
            for (int i = 0; i < param.size(); i++) {
                ps.setObject(i + 1, param.get(i));
            }

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    SaleOrder order = getFromResultSet(rs);
                    list.add(order);
                }
            }
        } catch (Exception e) {
            System.err.println("ERROR in searchByNameCode: " + e.getMessage());
            e.printStackTrace();
        }
        return list;
    }

    private int countOrdersByStatus(String status, int userId) {
        String sql = "SELECT COUNT(*) FROM sale_order WHERE status = ?";
        if (userId > 0) {
            sql += " AND created_by = ?";
        }
        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, status);
            if (userId > 0) {
                ps.setInt(2, userId);
            }
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return 0;
    }

    public List<SaleOrder> findApprovedAvailableFiltered(String search, String fromDate, String toDate, int page, int pageSize) {
        List<SaleOrder> list = new ArrayList<>();
        StringBuilder sql = new StringBuilder(
                "SELECT so.*, "
                + "u_created.name AS created_by_name, "
                + "u_approved.name AS approved_by_name, "
                + "u_cancelled.name AS cancelled_by_name, "
                + "c.name AS customer_name, "
                + "c.phone AS customer_phone, "
                + "c.email AS customer_email, "
                + "c.address AS customer_address, "
                + "c.company_name AS customer_company_name "
                + "FROM sale_order so "
                + "LEFT JOIN user u_created ON so.created_by = u_created.id "
                + "LEFT JOIN user u_approved ON so.approved_by = u_approved.id "
                + "LEFT JOIN user u_cancelled ON so.cancelled_by = u_cancelled.id "
                + "LEFT JOIN customer c ON so.customer_id = c.id "
                + "WHERE so.status = 'APPROVED' "
                + "AND NOT EXISTS ("
                + "  SELECT 1 FROM receipt r "
                + "  WHERE r.order_id = so.order_id AND r.status <> 'CANCELLED'"
                + ") ");
        List<Object> params = new ArrayList<>();
        if (search != null && !search.trim().isEmpty()) {
            sql.append("AND (so.order_code LIKE ? OR c.name LIKE ?) ");
            String like = "%" + search.trim() + "%";
            params.add(like);
            params.add(like);
        }
        if (fromDate != null && !fromDate.isEmpty()) {
            sql.append("AND DATE(so.approved_at) >= ? ");
            params.add(fromDate);
        }
        if (toDate != null && !toDate.isEmpty()) {
            sql.append("AND DATE(so.approved_at) <= ? ");
            params.add(toDate);
        }
        sql.append("ORDER BY so.approved_at DESC LIMIT ? OFFSET ?");
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
                "SELECT COUNT(*) FROM sale_order so "
                + "LEFT JOIN user u_created ON so.created_by = u_created.id "
                + "LEFT JOIN customer c ON so.customer_id = c.id "
                + "WHERE so.status = 'APPROVED' "
                + "AND NOT EXISTS ("
                + "  SELECT 1 FROM receipt r "
                + "  WHERE r.order_id = so.order_id AND r.status <> 'CANCELLED'"
                + ") ");
        List<Object> params = new ArrayList<>();
        if (search != null && !search.trim().isEmpty()) {
            sql.append("AND (so.order_code LIKE ? OR c.name LIKE ?) ");
            String like = "%" + search.trim() + "%";
            params.add(like);
            params.add(like);
        }
        if (fromDate != null && !fromDate.isEmpty()) {
            sql.append("AND DATE(so.approved_at) >= ? ");
            params.add(fromDate);
        }
        if (toDate != null && !toDate.isEmpty()) {
            sql.append("AND DATE(so.approved_at) <= ? ");
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

    public List<SaleOrder> findAll() {
        List<SaleOrder> list = new ArrayList<>();
        String sql = "SELECT * FROM sale_order ORDER BY created_at DESC";
        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql); ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                list.add(getFromResultSet(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    @Override
    public boolean update(SaleOrder s) {
        String sql = "UPDATE sale_order SET order_code = ?, customer_id = ?, "
                + "created_by = ?, approved_by = ?, cancelled_by = ?, updated_by = ?, "
                + "rejected_by = ?, status = ?, total_amount = ?, note = ?, "
                + "customer_note = ?, reject_reason = ?, order_date = ?, approved_at = ?, "
                + "cancelled_at = ?, updated_at = ? "
                + "WHERE order_id = ? AND status = ?";
        try (Connection conn = getConnection()) {
            conn.setAutoCommit(false);
            try (PreparedStatement ps = conn.prepareStatement(sql)) {
                ps.setString(1, s.getOrderCode());
                if (s.getCustomerId() > 0) {
                    ps.setInt(2, s.getCustomerId());
                } else {
                    ps.setNull(2, java.sql.Types.INTEGER);
                }
                ps.setInt(3, s.getCreatedBy());
                ps.setInt(4, s.getApprovedBy());
                ps.setInt(5, s.getCancelledBy());
                ps.setInt(6, s.getUpdatedBy());
                ps.setInt(7, s.getRejectedBy());
                ps.setString(8, s.getStatus());
                ps.setDouble(9, s.getTotalAmount());
                ps.setString(10, s.getNote());
                ps.setString(11, s.getCustomerNote());
                ps.setString(12, s.getRejectReason());
                ps.setTimestamp(13, s.getOrderDate() != null ? new java.sql.Timestamp(s.getOrderDate().getTime()) : null);
                ps.setTimestamp(14, s.getApprovedAt() != null ? new java.sql.Timestamp(s.getApprovedAt().getTime()) : null);
                ps.setTimestamp(15, s.getCancelledAt() != null ? new java.sql.Timestamp(s.getCancelledAt().getTime()) : null);
                ps.setTimestamp(16, s.getUpdatedAt() != null ? new java.sql.Timestamp(s.getUpdatedAt().getTime()) : null);
                ps.setInt(17, s.getOrderId());
                ps.setString(18, GlobalUtils.STATUS_PENDING);
                ps.executeUpdate();
                conn.commit();
                return true;
            } catch (SQLException e) {
                conn.rollback();
                e.printStackTrace();
                return false;
            } finally {
                conn.setAutoCommit(true);
            }
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public int cancelOrder(int orderId, int cancelledBy) {
        String checkSql = "SELECT COUNT(*) FROM receipt "
                + "WHERE order_id = ? AND receipt_type = 'EXPORT' AND status = 'COMPLETED'";

        try (Connection conn = getConnection(); PreparedStatement checkPs = conn.prepareStatement(checkSql)) {
            checkPs.setInt(1, orderId);
            try (ResultSet rs = checkPs.executeQuery()) {
                if (rs.next() && rs.getInt(1) > 0) {
                    return -1;
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
            return 0;
        }

        String updateSql = "UPDATE sale_order SET status = ?, cancelled_by = ?, cancelled_at = NOW() "
                + "WHERE order_id = ? AND status IN (?, ?)";

        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(updateSql)) {
            ps.setString(1, GlobalUtils.STATUS_CANCELLED);
            ps.setInt(2, cancelledBy);
            ps.setInt(3, orderId);
            ps.setString(4, GlobalUtils.STATUS_PENDING);
            ps.setString(5, GlobalUtils.STATUS_APPROVED);

            int rowsAffected = ps.executeUpdate();
            return rowsAffected > 0 ? 1 : 0;

        } catch (SQLException e) {
            e.printStackTrace();
            return 0;
        }
    }

    public boolean approveOrder(int orderId, int approvedBy) {

        String sql = "UPDATE sale_order SET status = ?, approved_by = ?, approved_at = NOW() "
                + "WHERE order_id = ? AND status = ?";
        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, GlobalUtils.STATUS_APPROVED);
            ps.setInt(2, approvedBy);
            ps.setInt(3, orderId);
            ps.setString(4, GlobalUtils.STATUS_PENDING);

            int rowsAffected = ps.executeUpdate();
            return rowsAffected > 0;

        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public boolean rejectOrder(int orderId, int rejectedBy, String rejectReason) {
        String sql = "UPDATE sale_order SET status = ?, reject_reason = ?, rejected_by = ?, updated_at = NOW() "
                + "WHERE order_id = ? AND status = ?";
        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, GlobalUtils.STATUS_REJECTED);
            ps.setString(2, rejectReason);
            ps.setInt(3, rejectedBy);
            ps.setInt(4, orderId);
            ps.setString(5, GlobalUtils.STATUS_PENDING);
            int rowsAffected = ps.executeUpdate();
            return rowsAffected > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public SaleOrder findById(int id) {
        String sql = "SELECT so.*, "
                + "u_created.name AS created_by_name, "
                + "u_approved.name AS approved_by_name, "
                + "u_cancelled.name AS cancelled_by_name, "
                + "c.name AS customer_name, "
                + "c.phone AS customer_phone, "
                + "c.email AS customer_email, "
                + "c.address AS customer_address, "
                + "c.company_name AS customer_company_name "
                + "FROM sale_order so "
                + "LEFT JOIN user u_created ON so.created_by = u_created.id "
                + "LEFT JOIN user u_approved ON so.approved_by = u_approved.id "
                + "LEFT JOIN user u_cancelled ON so.cancelled_by = u_cancelled.id "
                + "LEFT JOIN customer c ON so.customer_id = c.id "
                + "WHERE so.order_id = ?";

        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return getFromResultSet(rs);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    @Override
    public boolean delete(SaleOrder t) {
        throw new UnsupportedOperationException("Not supported yet."); // Generated from nbfs://nbhost/SystemFileSystem/Templates/Classes/Code/GeneratedMethodBody
    }

    @Override
    public int insert(SaleOrder s) {
        String sql = "INSERT INTO sale_order (order_code, customer_id, created_by, status, "
                + "total_amount, note, customer_note, order_date) "
                + "VALUES (?, ?, ?, ?, ?, ?, ?, ?)";
        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql, java.sql.Statement.RETURN_GENERATED_KEYS)) {
            ps.setString(1, s.getOrderCode());
            if (s.getCustomerId() > 0) {
                ps.setInt(2, s.getCustomerId());
            } else {
                ps.setNull(2, java.sql.Types.INTEGER);
            }
            ps.setInt(3, s.getCreatedBy());
            ps.setString(4, GlobalUtils.STATUS_PENDING);
            ps.setDouble(5, s.getTotalAmount() != null ? s.getTotalAmount() : 0);
            ps.setString(6, s.getNote());
            ps.setString(7, s.getCustomerNote());
            ps.setTimestamp(8, s.getOrderDate() != null ? new java.sql.Timestamp(s.getOrderDate().getTime()) : null);

            ps.executeUpdate();
            try (ResultSet rs = ps.getGeneratedKeys()) {
                if (rs.next()) {
                    return rs.getInt(1);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }

    public int countTodayOrders() {
        String sql = "SELECT COUNT(*) FROM sale_order WHERE DATE(created_at) = CURDATE()";
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
    public SaleOrder getFromResultSet(ResultSet rs) throws SQLException {
        SaleOrder s = new SaleOrder();

        s.setOrderId(rs.getInt("order_id"));
        s.setOrderCode(rs.getString("order_code"));

        int customerId = rs.getInt("customer_id");
        s.setCustomerId(rs.wasNull() ? 0 : customerId);

        try {

            Customer customer = new Customer();
            customer.setId(rs.getInt("customer_id"));

            customer.setName(rs.getString("customer_name"));
            customer.setPhone(rs.getString("customer_phone"));
            customer.setEmail(rs.getString("customer_email"));
            customer.setAddress(rs.getString("customer_address"));
            customer.setCompanyName(rs.getString("customer_company_name"));

            s.setCustomer(customer);
        } catch (SQLException e) {

            s.setCustomer(null);
        }

        s.setCreatedBy(rs.getInt("created_by"));

        int approvedBy = rs.getInt("approved_by");
        s.setApprovedBy(rs.wasNull() ? 0 : approvedBy);

        int cancelledBy = rs.getInt("cancelled_by");
        s.setCancelledBy(rs.wasNull() ? 0 : cancelledBy);

        int updatedBy = rs.getInt("updated_by");
        s.setUpdatedBy(rs.wasNull() ? 0 : updatedBy);

        int rejectedBy = rs.getInt("rejected_by");
        s.setRejectedBy(rs.wasNull() ? 0 : rejectedBy);

        try {
            s.setCreatedByName(rs.getString("created_by_name"));
        } catch (SQLException e) {
        }
        try {
            s.setApprovedByName(rs.getString("approved_by_name"));
        } catch (SQLException e) {
        }
        try {
            s.setCancelledByName(rs.getString("cancelled_by_name"));
        } catch (SQLException e) {
        }
        try {
            s.setRejectedByName(rs.getString("rejected_by_name"));
        } catch (SQLException e) {
        }

        s.setStatus(rs.getString("status"));
        s.setTotalAmount(rs.getDouble("total_amount"));
        s.setNote(rs.getString("note"));
        s.setRejectReason(rs.getString("reject_reason"));

        try {
            s.setCustomerNote(rs.getString("customer_note"));
        } catch (SQLException e) {
        }

        if (rs.getTimestamp("order_date") != null) {
            s.setOrderDate(new Date(rs.getTimestamp("order_date").getTime()));
        }
        if (rs.getTimestamp("approved_at") != null) {
            s.setApprovedAt(new Date(rs.getTimestamp("approved_at").getTime()));
        }
        if (rs.getTimestamp("cancelled_at") != null) {
            s.setCancelledAt(new Date(rs.getTimestamp("cancelled_at").getTime()));
        }
        if (rs.getTimestamp("created_at") != null) {
            s.setCreatedAt(new Date(rs.getTimestamp("created_at").getTime()));
        }
        if (rs.getTimestamp("updated_at") != null) {
            s.setUpdatedAt(new Date(rs.getTimestamp("updated_at").getTime()));
        }
        return s;
    }

    public boolean updateWithDetails(SaleOrder s, List<OrderDetail> newDetails) {
        String updateSql = "UPDATE sale_order SET customer_id = ?, customer_note = ?, "
                + "total_amount = ?, note = ?, updated_at = NOW() "
                + "WHERE order_id = ? AND status = ?";
        String deleteDetailSql = "DELETE FROM order_detail WHERE order_id = ?";
        String insertDetailSql = "INSERT INTO order_detail (order_id, generator_id, quantity, unit_price, note) "
                + "VALUES (?, ?, ?, ?, ?)";

        try (Connection conn = getConnection()) {
            conn.setAutoCommit(false);
            try {

                try (PreparedStatement ps = conn.prepareStatement(updateSql)) {
                    if (s.getCustomerId() > 0) {
                        ps.setInt(1, s.getCustomerId());
                    } else {
                        ps.setNull(1, java.sql.Types.INTEGER);
                    }
                    ps.setString(2, s.getCustomerNote());
                    ps.setDouble(3, s.getTotalAmount());
                    ps.setString(4, s.getNote());
                    ps.setInt(5, s.getOrderId());
                    ps.setString(6, GlobalUtils.STATUS_PENDING);

                    int rows = ps.executeUpdate();
                    if (rows == 0) {
                        conn.rollback();
                        return false;
                    }
                }

                try (PreparedStatement ps = conn.prepareStatement(deleteDetailSql)) {
                    ps.setInt(1, s.getOrderId());
                    ps.executeUpdate();
                }

                try (PreparedStatement ps = conn.prepareStatement(insertDetailSql)) {
                    for (OrderDetail d : newDetails) {
                        ps.setInt(1, d.getOrderId());
                        ps.setInt(2, d.getGeneratorId());
                        ps.setInt(3, d.getQuantity());
                        ps.setDouble(4, d.getUnitPrice());
                        ps.setString(5, d.getNote());
                        ps.addBatch();
                    }
                    ps.executeBatch();
                }

                conn.commit();
                return true;

            } catch (SQLException e) {
                conn.rollback();
                e.printStackTrace();
                return false;
            } finally {
                conn.setAutoCommit(true);
            }
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public int countOrderByStatus(String status, int userId) {
        String sql = "select count(*)\n"
                + "from sale_order\n"
                + "where status = ? ";
        if (userId > 0) {
            sql += " AND created_by = ?";
        }
        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, status);
            if (userId > 0) {
                ps.setInt(2, userId);
            }
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return 0;

    }
    public List<SaleOrder> findByCustomerId(int customerId) {
        List<SaleOrder> list = new ArrayList<>();
        String sql = "SELECT so.*, "
                + "u_created.name AS created_by_name, "
                + "u_approved.name AS approved_by_name, "
                + "u_cancelled.name AS cancelled_by_name, "
                + "c.name AS customer_name, "
                + "c.phone AS customer_phone, "
                + "c.email AS customer_email, "
                + "c.address AS customer_address, "
                + "c.company_name AS customer_company_name "
                + "FROM sale_order so "
                + "LEFT JOIN user u_created ON so.created_by = u_created.id "
                + "LEFT JOIN user u_approved ON so.approved_by = u_approved.id "
                + "LEFT JOIN user u_cancelled ON so.cancelled_by = u_cancelled.id "
                + "LEFT JOIN customer c ON so.customer_id = c.id "
                + "WHERE so.customer_id = ? "
                + "ORDER BY so.created_at DESC";
        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, customerId);
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

}