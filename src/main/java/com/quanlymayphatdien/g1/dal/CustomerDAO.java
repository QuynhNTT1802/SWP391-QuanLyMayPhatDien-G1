package com.quanlymayphatdien.g1.dal;

import com.quanlymayphatdien.g1.entity.Customer;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.sql.Timestamp;
import java.sql.Types;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;

public class CustomerDAO extends DBContext implements I_DAO<Customer> {

    @Override
    public List<Customer> findAll() {
        List<Customer> list = new ArrayList<>();
        String sql = "SELECT * FROM customer WHERE status = 'active' ORDER BY created_at DESC";
        try {
            connection = getConnection();
            statement = connection.prepareStatement(sql);
            resultSet = statement.executeQuery();
            while (resultSet.next()) {
                list.add(getFromResultSet(resultSet));
            }
        } catch (SQLException e) {
            System.out.println(e.getMessage());
        } finally {
            closeResources();
        }
        return list;
    }

    public Customer findById(int id) {
        String sql = "SELECT * FROM customer WHERE id = ?";
        try {
            connection = getConnection();
            statement = connection.prepareStatement(sql);
            statement.setInt(1, id);
            resultSet = statement.executeQuery();
            if (resultSet.next()) {
                return getFromResultSet(resultSet);
            }
        } catch (SQLException e) {
            System.out.println(e.getMessage());
        } finally {
            closeResources();
        }
        return null;
    }

    @Override
    public int insert(Customer c) {
        String sql = "INSERT INTO customer (name, phone, email, address, company_name, "
                + "customer_type_id, status, created_at, created_by) "
                + "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)";
        try {
            connection = getConnection();
            statement = connection.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS);
            statement.setString(1, c.getName());
            statement.setString(2, c.getPhone());
            statement.setString(3, c.getEmail());
            statement.setString(4, c.getAddress());
            statement.setString(5, c.getCompanyName());
            if (c.getCustomerTypeId() > 0) {
                statement.setInt(6, c.getCustomerTypeId());
            } else {
                statement.setNull(6, Types.INTEGER);
            }
            statement.setString(7, c.getStatus() != null ? c.getStatus() : "active");
            statement.setTimestamp(8, Timestamp.valueOf(LocalDateTime.now()));
            if (c.getCreatedBy() != null) {
                statement.setInt(9, c.getCreatedBy());
            } else {
                statement.setNull(9, Types.INTEGER);
            }
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
        return 0;
    }

    @Override
    public boolean update(Customer c) {
        String sql = "UPDATE customer SET name=?, phone=?, email=?, address=?, company_name=?, "
                + "customer_type_id=?, status=?, updated_at=?, updated_by=? WHERE id=?";
        try {
            connection = getConnection();
            statement = connection.prepareStatement(sql);
            statement.setString(1, c.getName());
            statement.setString(2, c.getPhone());
            statement.setString(3, c.getEmail());
            statement.setString(4, c.getAddress());
            statement.setString(5, c.getCompanyName());
            if (c.getCustomerTypeId() > 0) {
                statement.setInt(6, c.getCustomerTypeId());
            } else {
                statement.setNull(6, Types.INTEGER);
            }
            statement.setString(7, c.getStatus());
            statement.setTimestamp(8, Timestamp.valueOf(LocalDateTime.now()));
            if (c.getUpdatedBy() != null) {
                statement.setInt(9, c.getUpdatedBy());
            } else {
                statement.setNull(9, Types.INTEGER);
            }
            statement.setInt(10, c.getId());
            return statement.executeUpdate() > 0;
        } catch (SQLException e) {
            System.out.println(e.getMessage());
        } finally {
            closeResources();
        }
        return false;
    }

    @Override
    public boolean delete(Customer c) {
        String sql = "DELETE FROM customer WHERE id = ?";
        try {
            connection = getConnection();
            statement = connection.prepareStatement(sql);
            statement.setInt(1, c.getId());
            return statement.executeUpdate() > 0;
        } catch (SQLException e) {
            System.out.println(e.getMessage());
        } finally {
            closeResources();
        }
        return false;
    }

    public boolean activate(int id) {
        String sql = "UPDATE customer SET status = 'active', updated_at = ? WHERE id = ?";
        try {
            connection = getConnection();
            statement = connection.prepareStatement(sql);
            statement.setTimestamp(1, Timestamp.valueOf(LocalDateTime.now()));
            statement.setInt(2, id);
            return statement.executeUpdate() > 0;
        } catch (SQLException e) {
            System.out.println(e.getMessage());
        } finally {
            closeResources();
        }
        return false;
    }

    public boolean deactivate(int id) {
        String sql = "UPDATE customer SET status = 'locked', updated_at = ? WHERE id = ?";
        try {
            connection = getConnection();
            statement = connection.prepareStatement(sql);
            statement.setTimestamp(1, Timestamp.valueOf(LocalDateTime.now()));
            statement.setInt(2, id);
            return statement.executeUpdate() > 0;
        } catch (SQLException e) {
            System.out.println(e.getMessage());
        } finally {
            closeResources();
        }
        return false;
    }

    public List<Customer> findByFilters(String search, String status,
            Integer customerTypeId, int page, int pageSize) {
        List<Customer> all = new ArrayList<>();
        StringBuilder sql = new StringBuilder("SELECT * FROM customer WHERE 1=1 ");
        List<Object> params = new ArrayList<>();

        if (status != null && !status.isEmpty()) {
            sql.append("AND status = ? ");
            params.add(status);
        }
        if (search != null && !search.trim().isEmpty()) {
            sql.append("AND (name LIKE ? OR phone LIKE ?) ");
            String p = "%" + search.trim() + "%";
            params.add(p);
            params.add(p);
        }
        if (customerTypeId != null) {
            sql.append("AND customer_type_id = ? ");
            params.add(customerTypeId);
        }
        sql.append("ORDER BY created_at DESC");

        try {
            connection = getConnection();
            statement = connection.prepareStatement(sql.toString());
            for (int i = 0; i < params.size(); i++) {
                Object val = params.get(i);
                if (val instanceof String) {
                    statement.setString(i + 1, (String) val);
                } else if (val instanceof Integer) {
                    statement.setInt(i + 1, (Integer) val);
                }
            }
            resultSet = statement.executeQuery();
            while (resultSet.next()) {
                all.add(getFromResultSet(resultSet));
            }

            if (all.isEmpty()) return all;

            int start = (page - 1) * pageSize;
            int end = Math.min(start + pageSize, all.size());
            if (start > all.size()) return new ArrayList<>();
            return new ArrayList<>(all.subList(start, end));
        } catch (SQLException e) {
            System.out.println(e.getMessage());
        } finally {
            closeResources();
        }
        return new ArrayList<>();
    }

    public int getTotalFiltered(String search, String status, Integer customerTypeId) {
        StringBuilder sql = new StringBuilder("SELECT COUNT(*) FROM customer WHERE 1=1 ");
        List<Object> params = new ArrayList<>();

        if (status != null && !status.isEmpty()) {
            sql.append("AND status = ? ");
            params.add(status);
        }
        if (search != null && !search.trim().isEmpty()) {
            sql.append("AND (name LIKE ? OR phone LIKE ?) ");
            String p = "%" + search.trim() + "%";
            params.add(p);
            params.add(p);
        }
        if (customerTypeId != null) {
            sql.append("AND customer_type_id = ? ");
            params.add(customerTypeId);
        }
        try {
            connection = getConnection();
            statement = connection.prepareStatement(sql.toString());
            for (int i = 0; i < params.size(); i++) {
                Object val = params.get(i);
                if (val instanceof String) {
                    statement.setString(i + 1, (String) val);
                } else if (val instanceof Integer) {
                    statement.setInt(i + 1, (Integer) val);
                }
            }
            resultSet = statement.executeQuery();
            if (resultSet.next()) {
                return resultSet.getInt(1);
            }
        } catch (SQLException e) {
            System.out.println(e.getMessage());
        } finally {
            closeResources();
        }
        return 0;
    }

    public int countByStatus(String status) {
        String sql = "SELECT COUNT(*) FROM customer WHERE status = ?";
        try {
            connection = getConnection();
            statement = connection.prepareStatement(sql);
            statement.setString(1, status);
            resultSet = statement.executeQuery();
            if (resultSet.next()) {
                return resultSet.getInt(1);
            }
        } catch (SQLException e) {
            System.out.println(e.getMessage());
        } finally {
            closeResources();
        }
        return 0;
    }

    public boolean isPhoneExists(String phone, Integer excludeId) {
        String sql = "SELECT COUNT(*) FROM customer WHERE phone = ?";
        if (excludeId != null) {
            sql += " AND id != ?";
        }
        try {
            connection = getConnection();
            statement = connection.prepareStatement(sql);
            statement.setString(1, phone.trim());
            if (excludeId != null) {
                statement.setInt(2, excludeId);
            }
            resultSet = statement.executeQuery();
            if (resultSet.next()) {
                return resultSet.getInt(1) > 0;
            }
        } catch (SQLException e) {
            System.out.println(e.getMessage());
        } finally {
            closeResources();
        }
        return false;
    }

    public List<Customer> searchByKeyword(String keyword) {
        List<Customer> list = new ArrayList<>();
        String sql;
        boolean hasKeyword = keyword != null && !keyword.trim().isEmpty();
        if (hasKeyword) {
            sql = "SELECT * FROM customer WHERE status = 'active' "
                    + "AND (name LIKE ? OR phone LIKE ? OR email LIKE ?) "
                    + "ORDER BY name ASC LIMIT 30";
        } else {
            sql = "SELECT * FROM customer WHERE status = 'active' "
                    + "ORDER BY name ASC LIMIT 50";
        }
        try {
            connection = getConnection();
            statement = connection.prepareStatement(sql);
            if (hasKeyword) {
                String p = "%" + keyword.trim() + "%";
                statement.setString(1, p);
                statement.setString(2, p);
                statement.setString(3, p);
            }
            resultSet = statement.executeQuery();
            while (resultSet.next()) {
                list.add(getFromResultSet(resultSet));
            }
        } catch (SQLException e) {
            System.out.println(e.getMessage());
        } finally {
            closeResources();
        }
        return list;
    }

    public int countByName(String name) {
        if (name == null || name.trim().isEmpty()) {
            return 0;
        }
        String sql = "SELECT COUNT(*) FROM customer "
                + "WHERE status = 'active' AND LOWER(TRIM(name)) = LOWER(TRIM(?))";
        try {
            connection = getConnection();
            statement = connection.prepareStatement(sql);
            statement.setString(1, name.trim());
            resultSet = statement.executeQuery();
            if (resultSet.next()) {
                return resultSet.getInt(1);
            }
        } catch (SQLException e) {
            System.out.println(e.getMessage());
        } finally {
            closeResources();
        }
        return 0;
    }

    @Override
    public Customer getFromResultSet(ResultSet rs) throws SQLException {
        Customer c = new Customer();
        c.setId(rs.getInt("id"));
        c.setName(rs.getString("name"));
        c.setPhone(rs.getString("phone"));
        c.setEmail(rs.getString("email"));
        c.setAddress(rs.getString("address"));
        c.setCompanyName(rs.getString("company_name"));
        int ctId = rs.getInt("customer_type_id");
        if (!rs.wasNull()) {
            c.setCustomerTypeId(ctId);
        }
        c.setStatus(rs.getString("status"));

        Timestamp ca = rs.getTimestamp("created_at");
        if (ca != null) c.setCreatedAt(ca.toLocalDateTime());

        int cb = rs.getInt("created_by");
        if (!rs.wasNull()) c.setCreatedBy(cb);

        Timestamp ua = rs.getTimestamp("updated_at");
        if (ua != null) c.setUpdatedAt(ua.toLocalDateTime());

        int ub = rs.getInt("updated_by");
        if (!rs.wasNull()) c.setUpdatedBy(ub);

        return c;
    }

    public Customer findByPhone(String custPhone) {
        String sql = "SELECT * FROM customer WHERE phone = ?";
    try {
        connection = getConnection();
        statement = connection.prepareStatement(sql);
        statement.setString(1, custPhone.trim());
        resultSet = statement.executeQuery();
        if (resultSet.next()) {
            return getFromResultSet(resultSet);
        }
    } catch (SQLException e) {
        System.out.println(e.getMessage());
    } finally {
        closeResources();
    }
    return null;

    }
}