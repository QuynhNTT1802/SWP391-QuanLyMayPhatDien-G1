/*
 * DAO for the customer table.
 */
package com.quanlymayphatdien.g1.dal;

import com.quanlymayphatdien.g1.entity.Customer;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;

/**
 * Data Access Object cho bảng customer.
 */
public class CustomerDAO extends DBContext implements I_DAO<Customer> {

    // -------------------------------------------------------------------------
    // I_DAO — insert
    // -------------------------------------------------------------------------

    @Override
    public int insert(Customer c) {
        String sql = "INSERT INTO customer "
                + "(name, phone, email, address, company_name, customer_type_id, status, created_by) "
                + "VALUES (?, ?, ?, ?, ?, ?, ?, ?)";
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql, java.sql.Statement.RETURN_GENERATED_KEYS)) {

            ps.setString(1, c.getName());
            ps.setString(2, c.getPhone());
            ps.setString(3, c.getEmail());
            ps.setString(4, c.getAddress());
            ps.setString(5, c.getCompanyName());
            if (c.getCustomerTypeId() > 0) {
                ps.setInt(6, c.getCustomerTypeId());
            } else {
                ps.setNull(6, java.sql.Types.INTEGER);
            }
            ps.setString(7, c.getStatus() != null ? c.getStatus() : "active");
            if (c.getCreatedBy() > 0) {
                ps.setInt(8, c.getCreatedBy());
            } else {
                ps.setNull(8, java.sql.Types.INTEGER);
            }

            ps.executeUpdate();
            try (ResultSet rs = ps.getGeneratedKeys()) {
                if (rs.next()) {
                    return rs.getInt(1);
                }
            }
        } catch (SQLException e) {
            com.quanlymayphatdien.g1.utils.SystemLogger.error(
                    "quản lý khách hàng", "CustomerDAO.insert",
                    e.getMessage() != null ? e.getMessage() : e.getClass().getName(), e);
        }
        return 0;
    }

    // -------------------------------------------------------------------------
    // I_DAO — update
    // -------------------------------------------------------------------------

    @Override
    public boolean update(Customer c) {
        String sql = "UPDATE customer SET name = ?, phone = ?, email = ?, address = ?, "
                + "company_name = ?, customer_type_id = ?, status = ?, "
                + "updated_by = ?, updated_at = NOW() "
                + "WHERE id = ?";
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, c.getName());
            ps.setString(2, c.getPhone());
            ps.setString(3, c.getEmail());
            ps.setString(4, c.getAddress());
            ps.setString(5, c.getCompanyName());
            if (c.getCustomerTypeId() > 0) {
                ps.setInt(6, c.getCustomerTypeId());
            } else {
                ps.setNull(6, java.sql.Types.INTEGER);
            }
            ps.setString(7, c.getStatus());
            if (c.getUpdatedBy() > 0) {
                ps.setInt(8, c.getUpdatedBy());
            } else {
                ps.setNull(8, java.sql.Types.INTEGER);
            }
            ps.setInt(9, c.getId());

            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            com.quanlymayphatdien.g1.utils.SystemLogger.error(
                    "quản lý khách hàng", "CustomerDAO.update",
                    e.getMessage() != null ? e.getMessage() : e.getClass().getName(), e);
        }
        return false;
    }

    // -------------------------------------------------------------------------
    // I_DAO — delete (soft delete: chuyển status → inactive)
    // -------------------------------------------------------------------------

    @Override
    public boolean delete(Customer c) {
        String sql = "UPDATE customer SET status = 'inactive', updated_at = NOW() WHERE id = ?";
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, c.getId());
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            com.quanlymayphatdien.g1.utils.SystemLogger.error(
                    "quản lý khách hàng", "CustomerDAO.delete",
                    e.getMessage() != null ? e.getMessage() : e.getClass().getName(), e);
        }
        return false;
    }

    // -------------------------------------------------------------------------
    // I_DAO — getFromResultSet
    // -------------------------------------------------------------------------

    @Override
    public Customer getFromResultSet(ResultSet rs) throws SQLException {
        Customer c = new Customer();
        c.setId(rs.getInt("id"));
        c.setName(rs.getString("name"));
        c.setPhone(rs.getString("phone"));
        c.setEmail(rs.getString("email"));
        c.setAddress(rs.getString("address"));
        c.setCompanyName(rs.getString("company_name"));

        Object typeId = rs.getObject("customer_type_id");
        if (typeId != null) {
            c.setCustomerTypeId(((Number) typeId).intValue());
        }

        c.setStatus(rs.getString("status"));

        if (rs.getTimestamp("created_at") != null) {
            c.setCreatedAt(new Date(rs.getTimestamp("created_at").getTime()));
        }

        int createdBy = rs.getInt("created_by");
        c.setCreatedBy(rs.wasNull() ? 0 : createdBy);

        if (rs.getTimestamp("updated_at") != null) {
            c.setUpdatedAt(new Date(rs.getTimestamp("updated_at").getTime()));
        }

        int updatedBy = rs.getInt("updated_by");
        c.setUpdatedBy(rs.wasNull() ? 0 : updatedBy);

        return c;
    }

    // -------------------------------------------------------------------------
    // Queries
    // -------------------------------------------------------------------------

    /** Lấy tất cả khách hàng, sắp xếp theo tên. */
    public List<Customer> findAll() {
        List<Customer> list = new ArrayList<>();
        String sql = "SELECT * FROM customer ORDER BY name ASC";
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                list.add(getFromResultSet(rs));
            }
        } catch (SQLException e) {
            com.quanlymayphatdien.g1.utils.SystemLogger.error(
                    "quản lý khách hàng", "CustomerDAO.findAll",
                    e.getMessage() != null ? e.getMessage() : e.getClass().getName(), e);
        }
        return list;
    }

    /** Lấy khách hàng theo id. */
    public Customer findById(int id) {
        String sql = "SELECT * FROM customer WHERE id = ?";
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return getFromResultSet(rs);
                }
            }
        } catch (SQLException e) {
            com.quanlymayphatdien.g1.utils.SystemLogger.error(
                    "quản lý khách hàng", "CustomerDAO.findById",
                    e.getMessage() != null ? e.getMessage() : e.getClass().getName(), e);
        }
        return null;
    }

    /**
     * Tìm kiếm + lọc + phân trang.
     *
     * @param search   tìm theo tên / SĐT / email / tên công ty
     * @param status   lọc theo status (null = tất cả)
     * @param typeId   lọc theo loại KH — category id (0 = tất cả)
     * @param page     trang hiện tại (bắt đầu từ 1)
     * @param pageSize số bản ghi mỗi trang
     */
    public List<Customer> search(String search, String status, int typeId, int page, int pageSize) {
        List<Customer> list = new ArrayList<>();
        StringBuilder sql = new StringBuilder("SELECT * FROM customer WHERE 1=1 ");
        List<Object> params = new ArrayList<>();

        if (search != null && !search.trim().isEmpty()) {
            sql.append("AND (name LIKE ? OR phone LIKE ? OR email LIKE ? OR company_name LIKE ?) ");
            String like = "%" + search.trim() + "%";
            params.add(like);
            params.add(like);
            params.add(like);
            params.add(like);
        }
        if (status != null && !status.trim().isEmpty()) {
            sql.append("AND status = ? ");
            params.add(status);
        }
        if (typeId > 0) {
            sql.append("AND customer_type_id = ? ");
            params.add(typeId);
        }

        sql.append("ORDER BY name ASC LIMIT ? OFFSET ?");
        params.add(pageSize);
        params.add((page - 1) * pageSize);

        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql.toString())) {
            for (int i = 0; i < params.size(); i++) {
                ps.setObject(i + 1, params.get(i));
            }
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    list.add(getFromResultSet(rs));
                }
            }
        } catch (SQLException e) {
            com.quanlymayphatdien.g1.utils.SystemLogger.error(
                    "quản lý khách hàng", "CustomerDAO.search",
                    e.getMessage() != null ? e.getMessage() : e.getClass().getName(), e);
        }
        return list;
    }

    /** Đếm tổng kết quả tìm kiếm (dùng cho phân trang). */
    public int countSearch(String search, String status, int typeId) {
        StringBuilder sql = new StringBuilder("SELECT COUNT(*) FROM customer WHERE 1=1 ");
        List<Object> params = new ArrayList<>();

        if (search != null && !search.trim().isEmpty()) {
            sql.append("AND (name LIKE ? OR phone LIKE ? OR email LIKE ? OR company_name LIKE ?) ");
            String like = "%" + search.trim() + "%";
            params.add(like);
            params.add(like);
            params.add(like);
            params.add(like);
        }
        if (status != null && !status.trim().isEmpty()) {
            sql.append("AND status = ? ");
            params.add(status);
        }
        if (typeId > 0) {
            sql.append("AND customer_type_id = ? ");
            params.add(typeId);
        }

        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql.toString())) {
            for (int i = 0; i < params.size(); i++) {
                ps.setObject(i + 1, params.get(i));
            }
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1);
                }
            }
        } catch (SQLException e) {
            com.quanlymayphatdien.g1.utils.SystemLogger.error(
                    "quản lý khách hàng", "CustomerDAO.countSearch",
                    e.getMessage() != null ? e.getMessage() : e.getClass().getName(), e);
        }
        return 0;
    }

    /** Lấy danh sách khách hàng đang hoạt động (dùng cho dropdown khi tạo đơn). */
    public List<Customer> findAllActive() {
        List<Customer> list = new ArrayList<>();
        String sql = "SELECT * FROM customer WHERE status = 'active' ORDER BY name ASC";
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                list.add(getFromResultSet(rs));
            }
        } catch (SQLException e) {
            com.quanlymayphatdien.g1.utils.SystemLogger.error(
                    "quản lý khách hàng", "CustomerDAO.findAllActive",
                    e.getMessage() != null ? e.getMessage() : e.getClass().getName(), e);
        }
        return list;
    }

    /** Đếm tổng số khách hàng (dùng cho dashboard). */
    public int countAll() {
        String sql = "SELECT COUNT(*) FROM customer";
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (SQLException e) {
            com.quanlymayphatdien.g1.utils.SystemLogger.error(
                    "quản lý khách hàng", "CustomerDAO.countAll",
                    e.getMessage() != null ? e.getMessage() : e.getClass().getName(), e);
        }
        return 0;
    }
}
