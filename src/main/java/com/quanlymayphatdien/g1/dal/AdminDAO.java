package com.quanlymayphatdien.g1.dal;

import com.quanlymayphatdien.g1.entity.Admin;
import com.quanlymayphatdien.g1.entity.Role;
import java.sql.*;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;
import java.util.Set;

public class AdminDAO extends DBContext implements I_DAO<Admin> {


    @Override
    public List<Admin> findAll() {
        List<Admin> list = new ArrayList<>();
        String sql = "SELECT u.id, u.name, u.username, u.password, u.email, u.phone, u.address, u.status, " +
                     "u.created_at, u.updated_at, u.created_by, u.updated_by, " +
                     "a.department, a.last_login " +
                     "FROM user u INNER JOIN admin a ON u.id = a.admin_id";
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                list.add(getFromResultSet(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    @Override
    public boolean update(Admin t) {
        String updateUser = "UPDATE user SET name=?, username=?, password=?, email=?, phone=?, address=?, status=?, updated_by=? WHERE id=?";
        String updateAdmin = "UPDATE admin SET department=?, last_login=? WHERE admin_id=?";
        // Nên dùng transaction để đảm bảo toàn vẹn dữ liệu
        try (Connection conn = getConnection()) {
            conn.setAutoCommit(false);
            try (PreparedStatement psUser = conn.prepareStatement(updateUser);
                 PreparedStatement psAdmin = conn.prepareStatement(updateAdmin)) {

                // Update user
                psUser.setString(1, t.getName());
                psUser.setString(2, t.getUsername());
                psUser.setString(3, t.getPassword());  // Nên hash
                psUser.setString(4, t.getEmail());
                psUser.setString(5, t.getPhone());
                psUser.setString(6, t.getAddress());
                psUser.setString(7, t.getStatus());
                if (t.getUpdatedBy() != null) {
                    psUser.setInt(8, t.getUpdatedBy());
                } else {
                    psUser.setNull(8, Types.INTEGER);
                }
                psUser.setInt(9, t.getId());
                psUser.executeUpdate();

                // Update admin
                psAdmin.setString(1, t.getDepartment());
                if (t.getLastLogin() != null) {
                    psAdmin.setTimestamp(2, Timestamp.valueOf(t.getLastLogin()));
                } else {
                    psAdmin.setNull(2, Types.TIMESTAMP);
                }
                psAdmin.setInt(3, t.getId());
                psAdmin.executeUpdate();

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

    @Override
    public boolean delete(Admin t) {
        String deleteAdmin = "DELETE FROM admin WHERE admin_id=?";
        String deleteUser = "DELETE FROM user WHERE id=?";
        try (Connection conn = getConnection()) {
            conn.setAutoCommit(false);
            try (PreparedStatement psAdmin = conn.prepareStatement(deleteAdmin);
                 PreparedStatement psUser = conn.prepareStatement(deleteUser)) {

                psAdmin.setInt(1, t.getId());
                psAdmin.executeUpdate();

                psUser.setInt(1, t.getId());
                psUser.executeUpdate();

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

    @Override
    public int insert(Admin t) {
        String insertUser = "INSERT INTO user (name, username, password, email, phone, address, status, created_by, updated_by) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)";
        String insertAdmin = "INSERT INTO admin (admin_id, department, last_login) VALUES (?, ?, ?)";
        try (Connection conn = getConnection()) {
            conn.setAutoCommit(false);
            try (PreparedStatement psUser = conn.prepareStatement(insertUser, Statement.RETURN_GENERATED_KEYS);
                 PreparedStatement psAdmin = conn.prepareStatement(insertAdmin)) {

                psUser.setString(1, t.getName());
                psUser.setString(2, t.getUsername());
                psUser.setString(3, t.getPassword());
                psUser.setString(4, t.getEmail());
                psUser.setString(5, t.getPhone());
                psUser.setString(6, t.getAddress());
                psUser.setString(7, t.getStatus());
                if (t.getCreatedBy() != null) {
                    psUser.setInt(8, t.getCreatedBy());
                } else {
                    psUser.setNull(8, Types.INTEGER);
                }
                if (t.getUpdatedBy() != null) {
                    psUser.setInt(9, t.getUpdatedBy());
                } else {
                    psUser.setNull(9, Types.INTEGER);
                }
                psUser.executeUpdate();

                ResultSet rs = psUser.getGeneratedKeys();
                int generatedId;
                if (rs.next()) {
                    generatedId = rs.getInt(1);
                } else {
                    throw new SQLException("Không lấy được ID sau khi insert user.");
                }

                psAdmin.setInt(1, generatedId);
                psAdmin.setString(2, t.getDepartment());
                if (t.getLastLogin() != null) {
                    psAdmin.setTimestamp(3, Timestamp.valueOf(t.getLastLogin()));
                } else {
                    psAdmin.setNull(3, Types.TIMESTAMP);
                }
                psAdmin.executeUpdate();

                conn.commit();
                return generatedId;
            } catch (SQLException e) {
                conn.rollback();
                e.printStackTrace();
                return -1;
            } finally {
                conn.setAutoCommit(true);
            }
        } catch (SQLException e) {
            e.printStackTrace();
            return -1;
        }
    }

    @Override
    public Admin getFromResultSet(ResultSet rs) throws SQLException {
        int id = rs.getInt("id");
        String name = rs.getString("name");
        String username = rs.getString("username");
        String password = rs.getString("password");
        String email = rs.getString("email");
        String phone = rs.getString("phone");
        String address = rs.getString("address");
        String status = rs.getString("status");

        LocalDateTime createdAt = rs.getTimestamp("created_at") != null
                ? rs.getTimestamp("created_at").toLocalDateTime() : null;
        LocalDateTime updatedAt = rs.getTimestamp("updated_at") != null
                ? rs.getTimestamp("updated_at").toLocalDateTime() : null;

        Integer createdBy = rs.getObject("created_by") != null ? rs.getInt("created_by") : null;
        Integer updatedBy = rs.getObject("updated_by") != null ? rs.getInt("updated_by") : null;

        String department = rs.getString("department");
        LocalDateTime lastLogin = rs.getTimestamp("last_login") != null
                ? rs.getTimestamp("last_login").toLocalDateTime() : null;
        
        
        PermissionDAO perDAO = new PermissionDAO();
        RoleDAO roleDAO = new RoleDAO();
        
        List<Role> roles = roleDAO.getRolesByUserId(id);
        Set<String> effectPermissions = perDAO.getEffectPermissions(id);

        return new Admin(id, name, username, password, email, phone, address, status,
                         createdAt, updatedAt, createdBy, updatedBy,
                         roles, effectPermissions, 
                         department, lastLogin);
    }

    public Admin findById(int id) {
        String sql = "SELECT u.id, u.name, u.username, u.password, u.email, u.phone, u.address, u.status, " +
                     "u.created_at, u.updated_at, u.created_by, u.updated_by, " +
                     "a.department, a.last_login " +
                     "FROM user u INNER JOIN admin a ON u.id = a.admin_id " +
                     "WHERE u.id = ?";
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return getFromResultSet(rs);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }
}