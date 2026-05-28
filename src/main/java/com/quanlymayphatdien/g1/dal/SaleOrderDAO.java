/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package com.quanlymayphatdien.g1.dal;

import com.quanlymayphatdien.g1.entity.Admin;
import com.quanlymayphatdien.g1.entity.SaleOrder;
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

        String sql = "SELECT * FROM sale_order WHERE status = ? ORDER BY created_at DESC";
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

    public int countStatusApproved() {
        String sql = "select count(*)\n"
                + "from sale_order\n"
                + "where status = 'approved'";
        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql); ResultSet rs = ps.executeQuery()) {
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (Exception e) {
        }
        return 0;
    }

    public int countStatusRejected() {
        String sql = "select count(*)\n"
                + "from sale_order\n"
                + "where status = 'rejected'";
        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql); ResultSet rs = ps.executeQuery()) {
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (Exception e) {
        }
        return 0;
    }

    public int countStatusPending() {
        String sql = "select count(*)\n"
                + "from sale_order\n"
                + "where status = 'pending'";
        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql); ResultSet rs = ps.executeQuery()) {
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (Exception e) {
        }
        return 0;
    }
    
    public int countStatusCancelled() {
        String sql = "select count(*)\n"
                + "from sale_order\n"
                + "where status = 'cancelled'";
        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql); ResultSet rs = ps.executeQuery()) {
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (Exception e) {
        }
        return 0;
    }

    public List<SaleOrder> findAll() {
        List<SaleOrder> list = new ArrayList<>();
        // Sắp xếp đơn mới tạo nhất lên đầu
        String sql = "SELECT * FROM sale_order ORDER BY created_at DESC";
        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql); ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                SaleOrder s = new SaleOrder();
                s.setOrderId(rs.getInt("order_id"));
                s.setOrderCode(rs.getString("order_code"));
                s.setCustomerName(rs.getString("customer_name"));
                s.setCustomerPhone(rs.getString("customer_phone"));
                s.setCustomerEmail(rs.getString("customer_email"));
                s.setCustomerAddress(rs.getString("customer_address"));
                s.setCustomerTaxCode(rs.getString("customer_tax_code"));
                s.setCustomerType(rs.getString("customer_type"));
                s.setCustomerCompany(rs.getString("customer_company_name"));
                s.setCustomerNote(rs.getString("customer_note"));
                s.setCreatedBy(rs.getInt("created_by"));
                s.setApprovedBy(rs.getInt("approved_by"));
                s.setStatus(rs.getString("status"));
                s.setTotalAmount(rs.getDouble("total_amount"));
                s.setNote(rs.getString("note"));
                if (rs.getTimestamp("order_date") != null) {
                    s.setOrderDate(new Date(rs.getTimestamp("order_date").getTime()));
                }
                if (rs.getTimestamp("approved_at") != null) {
                    s.setApprovedAt(new Date(rs.getTimestamp("approved_at").getTime()));
                }
                if (rs.getTimestamp("created_at") != null) {
                    s.setCreatedAt(new Date(rs.getTimestamp("created_at").getTime()));
                }
                if (rs.getTimestamp("updated_at") != null) {
                    s.setUpdatedAt(new Date(rs.getTimestamp("updated_at").getTime()));
                }
                list.add(s);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    @Override
    public boolean update(SaleOrder s) {

        String sql = "UPDATE sale_order SET order_code = ?, customer_name = ?, customer_phone = ?, "
                + "customer_email = ?, customer_address = ?, customer_tax_code = ?, customer_type = ?, "
                + "customer_company_name = ?, customer_note = ?, created_by = ?, approved_by = ?, "
                + "status = ?, total_amount = ?, note = ?, "
                + "order_date = ?, approved_at = ?, updated_at = ? "
                + "WHERE order_id = ?";
        try (Connection conn = getConnection()) {
            conn.setAutoCommit(false);
            try (PreparedStatement ps = conn.prepareStatement(sql)) {
                ps.setString(1, s.getOrderCode());
                ps.setString(2, s.getCustomerName());
                ps.setString(3, s.getCustomerPhone());
                ps.setString(4, s.getCustomerEmail());
                ps.setString(5, s.getCustomerAddress());
                ps.setString(6, s.getCustomerTaxCode());
                ps.setString(7, s.getCustomerType());
                ps.setString(8, s.getCustomerCompany());
                ps.setString(9, s.getCustomerNote());
                ps.setInt(10, s.getCreatedBy());
                ps.setInt(11, s.getApprovedBy());
                ps.setString(12, s.getStatus());
                ps.setDouble(13, s.getTotalAmount());
                ps.setString(14, s.getNote());
                ps.setTimestamp(15, s.getOrderDate() != null ? new java.sql.Timestamp(s.getOrderDate().getTime()) : null);
                ps.setTimestamp(16, s.getApprovedAt() != null ? new java.sql.Timestamp(s.getApprovedAt().getTime()) : null);
                ps.setTimestamp(17, s.getUpdatedAt() != null ? new java.sql.Timestamp(s.getUpdatedAt().getTime()) : null);
                ps.setInt(18, s.getOrderId());
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

    public boolean cancelOrder(int orderId, int cancelledBy) {

        String sql = "UPDATE sale_order SET status = 'CANCELLED', updated_at = NOW() "
                + "WHERE order_id = ? AND status IN ('PENDING', 'APPROVED')";

        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, orderId);

            int rowsAffected = ps.executeUpdate();
            return rowsAffected > 0;

        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public boolean approveOrder(int orderId, int approvedBy) {

        String sql = "UPDATE sale_order SET status = 'APPROVED', approved_by = ?, approved_at = NOW() "
                + "WHERE order_id = ? AND status = 'PENDING'";
        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, approvedBy);
            ps.setInt(2, orderId);

            int rowsAffected = ps.executeUpdate();
            return rowsAffected > 0;

        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public boolean rejectOrder(int orderId, int rejectedBy, String rejectReason) {

        String sql = "UPDATE sale_order SET status = 'REJECTED', "
                + "note = CONCAT(COALESCE(note, ''), ' | Lý do từ chối: ', ?), "
                + "updated_at = NOW() "
                + "WHERE order_id = ? AND status = 'PENDING'";
        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, rejectReason);
            ps.setInt(2, orderId);
            int rowsAffected = ps.executeUpdate();
            return rowsAffected > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public SaleOrder findById(int id) {
        String sql = "SELECT * FROM sale_order WHERE order_id = ?";
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
        String sql = "INSERT INTO sale_order (order_code, customer_name, customer_phone, customer_email, "
                + "customer_address, customer_tax_code, customer_type, customer_company_name, customer_note, "
                + "created_by, status, total_amount, note, order_date) "
                + "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, 'PENDING', ?, ?, ?)";
        try (Connection conn = getConnection(); // Thêm tham số RETURN_GENERATED_KEYS để lấy lại ID vừa tạo
                 PreparedStatement ps = conn.prepareStatement(sql, java.sql.Statement.RETURN_GENERATED_KEYS)) {
            ps.setString(1, s.getOrderCode());
            ps.setString(2, s.getCustomerName());
            ps.setString(3, s.getCustomerPhone());
            ps.setString(4, s.getCustomerEmail());
            ps.setString(5, s.getCustomerAddress());
            ps.setString(6, s.getCustomerTaxCode());
            ps.setString(7, s.getCustomerType());
            ps.setString(8, s.getCustomerCompany());
            ps.setString(9, s.getCustomerNote());
            ps.setInt(10, s.getCreatedBy());
            ps.setDouble(11, s.getTotalAmount() != null ? s.getTotalAmount() : 0);
            ps.setString(12, s.getNote());
            ps.setTimestamp(13, s.getOrderDate() != null ? new java.sql.Timestamp(s.getOrderDate().getTime()) : null);
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
        s.setCustomerName(rs.getString("customer_name"));
        s.setCustomerPhone(rs.getString("customer_phone"));
        s.setCustomerEmail(rs.getString("customer_email"));
        s.setCustomerAddress(rs.getString("customer_address"));
        s.setCustomerTaxCode(rs.getString("customer_tax_code"));
        s.setCustomerType(rs.getString("customer_type"));
        s.setCustomerCompany(rs.getString("customer_company_name"));
        s.setCustomerNote(rs.getString("customer_note"));

        s.setCreatedBy(rs.getInt("created_by"));
        s.setApprovedBy(rs.getInt("approved_by"));

        s.setStatus(rs.getString("status"));
        s.setTotalAmount(rs.getDouble("total_amount"));
        s.setNote(rs.getString("note"));
        if (rs.getTimestamp("order_date") != null) {
            s.setOrderDate(new Date(rs.getTimestamp("order_date").getTime()));
        }
        if (rs.getTimestamp("approved_at") != null) {
            s.setApprovedAt(new Date(rs.getTimestamp("approved_at").getTime()));
        }
        if (rs.getTimestamp("created_at") != null) {
            s.setCreatedAt(new Date(rs.getTimestamp("created_at").getTime()));
        }
        if (rs.getTimestamp("updated_at") != null) {
            s.setUpdatedAt(new Date(rs.getTimestamp("updated_at").getTime()));
        }
        return s;
    }

}
