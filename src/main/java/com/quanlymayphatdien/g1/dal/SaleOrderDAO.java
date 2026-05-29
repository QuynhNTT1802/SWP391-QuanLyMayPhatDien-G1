/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package com.quanlymayphatdien.g1.dal;

import com.quanlymayphatdien.g1.entity.Admin;
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

    public List<SaleOrder> searchByNameCode(String search, String status) {
        List<SaleOrder> list = new ArrayList<>();
        StringBuilder sql = new StringBuilder("SELECT * FROM sale_order WHERE 1=1");
        List<Object> param = new ArrayList<>();

        if (status != null && !status.trim().isEmpty()) {
            sql.append(" AND status = ?");
            param.add(status);
        }

        if (search != null && !search.trim().isEmpty()) {
            sql.append(" AND (order_code LIKE ? OR customer_name LIKE ?)");
            String pattern = "%" + search.trim() + "%";
            param.add(pattern);
            param.add(pattern);
        }

        sql.append(" ORDER BY created_at DESC");

        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql.toString())) {
            for (int i = 0; i < param.size(); i++) {
                ps.setObject(i + 1, param.get(i));
            }

            System.out.println("SQL: " + sql.toString());
            System.out.println("Params: " + param);

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    SaleOrder order = getFromResultSet(rs);
                    System.out.println("Loaded order: " + order.getOrderId() + " - " + order.getOrderCode());
                    list.add(order);
                }
            }
        } catch (Exception e) {
            System.err.println("ERROR in searchByNameCode: " + e.getMessage());
            e.printStackTrace();
        }
        return list;
    }

    public int countStatusApproved() {
        String sql = "select count(*)\n"
                + "from sale_order\n"
                + "where status = ?";
        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, GlobalUtils.STATUS_APPROVED);
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

    public int countStatusRejected() {
        String sql = "select count(*)\n"
                + "from sale_order\n"
                + "where status = ?";
        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, GlobalUtils.STATUS_REJECTED);
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

    public int countStatusPending() {
        String sql = "select count(*)\n"
                + "from sale_order\n"
                + "where status = ?";
        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, GlobalUtils.STATUS_PENDING);
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

    public int countStatusCancelled() {
        String sql = "select count(*)\n"
                + "from sale_order\n"
                + "where status = ? ";
        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, GlobalUtils.STATUS_CANCELLED);
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

        String sql = "UPDATE sale_order SET order_code = ?, customer_name = ?, customer_phone = ?, "
                + "customer_email = ?, customer_address = ?, customer_tax_code = ?, customer_type = ?, "
                + "customer_company_name = ?, customer_note = ?, created_by = ?, approved_by = ?, "
                + "cancelled_by = ?, updated_by = ?, status = ?, total_amount = ?, note = ?, "
                + "reject_reason = ?, order_date = ?, approved_at = ?, cancelled_at = ?, updated_at = ?, customer_type_id = ? "
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
                ps.setInt(12, s.getCancelledBy());
                ps.setInt(13, s.getUpdatedBy());
                ps.setString(14, s.getStatus());
                ps.setDouble(15, s.getTotalAmount());
                ps.setString(16, s.getNote());
                ps.setString(17, s.getRejectReason());
                ps.setTimestamp(18, s.getOrderDate() != null ? new java.sql.Timestamp(s.getOrderDate().getTime()) : null);
                ps.setTimestamp(19, s.getApprovedAt() != null ? new java.sql.Timestamp(s.getApprovedAt().getTime()) : null);
                ps.setTimestamp(20, s.getCancelledAt() != null ? new java.sql.Timestamp(s.getCancelledAt().getTime()) : null);
                ps.setTimestamp(21, s.getUpdatedAt() != null ? new java.sql.Timestamp(s.getUpdatedAt().getTime()) : null);
                ps.setInt(22, s.getCustomerTypeId());
                ps.setInt(23, s.getOrderId());
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

        String sql = "UPDATE sale_order SET status = ?, cancelled_by = ?, cancelled_at = NOW() "
                + "WHERE order_id = ? AND status IN (?, ?)";

        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, GlobalUtils.STATUS_CANCELLED);
            ps.setInt(2, cancelledBy);
            ps.setInt(3, orderId);
            ps.setString(4, GlobalUtils.STATUS_PENDING);
            ps.setString(5, GlobalUtils.STATUS_APPROVED);

            int rowsAffected = ps.executeUpdate();
            return rowsAffected > 0;

        } catch (SQLException e) {
            e.printStackTrace();
            return false;
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

        String sql = "UPDATE sale_order SET status = ?, reject_reason = ?, updated_by = ?, updated_at = NOW() "
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
                + "created_by, status, total_amount, note, order_date, customer_type_id) "
                + "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, '" + GlobalUtils.STATUS_PENDING + "', ?, ?, ?, ?)";
        try (Connection conn = getConnection(); 
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
            ps.setInt(14, s.getCustomerTypeId());
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
        
        int approvedBy = rs.getInt("approved_by");
        s.setApprovedBy(rs.wasNull() ? 0 : approvedBy);
        
        int cancelledBy = rs.getInt("cancelled_by");
        s.setCancelledBy(rs.wasNull() ? 0 : cancelledBy);
        
        int updatedBy = rs.getInt("updated_by");
        s.setUpdatedBy(rs.wasNull() ? 0 : updatedBy);

        s.setStatus(rs.getString("status"));
        s.setTotalAmount(rs.getDouble("total_amount"));
        s.setNote(rs.getString("note"));
        s.setRejectReason(rs.getString("reject_reason"));
        
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
        
        Object customerTypeIdObj = rs.getObject("customer_type_id");
        if (customerTypeIdObj != null) {
            s.setCustomerTypeId(((Number) customerTypeIdObj).intValue());
        }
        return s;
    }

}
