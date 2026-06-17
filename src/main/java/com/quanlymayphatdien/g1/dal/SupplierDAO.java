package com.quanlymayphatdien.g1.dal;

import com.quanlymayphatdien.g1.entity.Supplier;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.sql.Timestamp;
import java.sql.Types;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;

public class SupplierDAO extends DBContext implements I_DAO<Supplier> {

    @Override
    public List<Supplier> findAll() {
        List<Supplier> list = new ArrayList<>();
        String sql = "SELECT * FROM supplier ORDER BY created_at DESC";
        try {
            connection = getConnection();
            statement = connection.prepareStatement(sql);
            resultSet = statement.executeQuery();
            while (resultSet.next()) {
                list.add(getFromResultSet(resultSet));
            }
        } catch (SQLException e) {
            System.out.println(e.getMessage());
        }
        return list;
    }

    public Supplier findById(int id) {
        String sql = "SELECT * FROM supplier WHERE id = ?";
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
        }
        return null;
    }

    @Override
    public int insert(Supplier s) {
        String sql = "INSERT INTO supplier (name, phone, email, address, company_name, "
                + "supplier_type_id, status, created_at, created_by) "
                + "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)";
        try {
            connection = getConnection();
            statement = connection.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS);
            statement.setString(1, s.getName());
            statement.setString(2, s.getPhone());
            statement.setString(3, s.getEmail());
            statement.setString(4, s.getAddress());
            statement.setString(5, s.getCompanyName());
            if (s.getSupplierTypeId() > 0) {
                statement.setInt(6, s.getSupplierTypeId());
            } else {
                statement.setNull(6, Types.INTEGER);
            }
            statement.setString(7, s.getStatus() != null ? s.getStatus() : "active");
            statement.setTimestamp(8, Timestamp.valueOf(LocalDateTime.now()));
            if (s.getCreatedBy() != null) {
                statement.setInt(9, s.getCreatedBy());
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
    public boolean update(Supplier s) {
        String sql = "UPDATE supplier SET name=?, phone=?, email=?, address=?, company_name=?, "
                + "supplier_type_id=?, status=?, updated_at=?, updated_by=? WHERE id=?";
        try {
            connection = getConnection();
            statement = connection.prepareStatement(sql);
            statement.setString(1, s.getName());
            statement.setString(2, s.getPhone());
            statement.setString(3, s.getEmail());
            statement.setString(4, s.getAddress());
            statement.setString(5, s.getCompanyName());
            if (s.getSupplierTypeId() > 0) {
                statement.setInt(6, s.getSupplierTypeId());
            } else {
                statement.setNull(6, Types.INTEGER);
            }
            statement.setString(7, s.getStatus());
            statement.setTimestamp(8, Timestamp.valueOf(LocalDateTime.now()));
            if (s.getUpdatedBy() != null) {
                statement.setInt(9, s.getUpdatedBy());
            } else {
                statement.setNull(9, Types.INTEGER);
            }
            statement.setInt(10, s.getId());
            return statement.executeUpdate() > 0;
        } catch (SQLException e) {
            System.out.println(e.getMessage());
        }
        return false;
    }

    @Override
    public boolean delete(Supplier s) {
        String sql = "DELETE FROM supplier WHERE id = ?";
        try {
            connection = getConnection();
            statement = connection.prepareStatement(sql);
            statement.setInt(1, s.getId());
            return statement.executeUpdate() > 0;
        } catch (SQLException e) {
            System.out.println(e.getMessage());
        }
        return false;
    }

    public boolean activate(int id) {
        String sql = "UPDATE supplier SET status = 'active', updated_at = ? WHERE id = ?";
        try {
            connection = getConnection();
            statement = connection.prepareStatement(sql);
            statement.setTimestamp(1, Timestamp.valueOf(LocalDateTime.now()));
            statement.setInt(2, id);
            return statement.executeUpdate() > 0;
        } catch (SQLException e) {
            System.out.println(e.getMessage());
        }
        return false;
    }

    public boolean deactivate(int id) {
        String sql = "UPDATE supplier SET status = 'locked', updated_at = ? WHERE id = ?";
        try {
            connection = getConnection();
            statement = connection.prepareStatement(sql);
            statement.setTimestamp(1, Timestamp.valueOf(LocalDateTime.now()));
            statement.setInt(2, id);
            return statement.executeUpdate() > 0;
        } catch (SQLException e) {
            System.out.println(e.getMessage());
        }
        return false;
    }

    public List<Supplier> findByFilters(String search, String status,
            Integer supplierTypeId, int page, int pageSize) {
        List<Supplier> all = new ArrayList<>();
        StringBuilder sql = new StringBuilder("SELECT * FROM supplier WHERE 1=1 ");
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
        if (supplierTypeId != null) {
            sql.append("AND supplier_type_id = ? ");
            params.add(supplierTypeId);
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
        }
        return new ArrayList<>();
    }

    public int getTotalFiltered(String search, String status, Integer supplierTypeId) {
        StringBuilder sql = new StringBuilder("SELECT COUNT(*) FROM supplier WHERE 1=1 ");
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
        if (supplierTypeId != null) {
            sql.append("AND supplier_type_id = ? ");
            params.add(supplierTypeId);
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
        }
        return 0;
    }

    public int countByStatus(String status) {
        String sql = "SELECT COUNT(*) FROM supplier WHERE status = ?";
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
        }
        return 0;
    }

    public boolean isPhoneExists(String phone, Integer excludeId) {
        String sql = "SELECT COUNT(*) FROM supplier WHERE phone = ?";
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
        }
        return false;
    }

    @Override
    public Supplier getFromResultSet(ResultSet rs) throws SQLException {
        Supplier s = new Supplier();
        s.setId(rs.getInt("id"));
        s.setName(rs.getString("name"));
        s.setPhone(rs.getString("phone"));
        s.setEmail(rs.getString("email"));
        s.setAddress(rs.getString("address"));
        s.setCompanyName(rs.getString("company_name"));
        int stId = rs.getInt("supplier_type_id");
        if (!rs.wasNull()) {
            s.setSupplierTypeId(stId);
        }
        s.setStatus(rs.getString("status"));

        Timestamp ca = rs.getTimestamp("created_at");
        if (ca != null) s.setCreatedAt(ca.toLocalDateTime());

        int cb = rs.getInt("created_by");
        if (!rs.wasNull()) s.setCreatedBy(cb);

        Timestamp ua = rs.getTimestamp("updated_at");
        if (ua != null) s.setUpdatedAt(ua.toLocalDateTime());

        int ub = rs.getInt("updated_by");
        if (!rs.wasNull()) s.setUpdatedBy(ub);

        return s;
    }
    
    public List<Supplier> findByNameExact(String name) {
        List<Supplier> list = new ArrayList<>();
        if (name == null || name.trim().isEmpty()) {
            return list;
        }
        String sql = "SELECT * FROM supplier "
                + "WHERE LOWER(TRIM(name)) = LOWER(TRIM(?)) AND status = 'active' "
                + "ORDER BY id ASC";
        try {
            connection = getConnection();
            statement = connection.prepareStatement(sql);
            statement.setString(1, name.trim());
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
    
    public List<Supplier> searchByKeyword(String keyword, int limit) {
        List<Supplier> list = new ArrayList<>();
        boolean hasKeyword = keyword != null && !keyword.trim().isEmpty();
        String sql;
        if (hasKeyword) {
            sql = "SELECT * FROM supplier "
                    + "WHERE status = 'active' AND name LIKE ? "
                    + "ORDER BY name ASC LIMIT ?";
        } else {
            sql = "SELECT * FROM supplier WHERE status = 'active' ORDER BY name ASC LIMIT ?";
        }
        try {
            connection = getConnection();
            statement = connection.prepareStatement(sql);
            if (hasKeyword) {
                statement.setString(1, "%" + keyword.trim() + "%");
                statement.setInt(2, limit > 0 ? limit : 10);
            } else {
                statement.setInt(1, limit > 0 ? limit : 10);
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
}