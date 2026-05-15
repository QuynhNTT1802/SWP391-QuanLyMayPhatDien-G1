package com.quanlymayphatdien.g1.dal;

import com.quanlymayphatdien.g1.entity.Admin;
import java.sql.*;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;

public class AdminDAO extends DBContext implements I_DAO<Admin> {


    @Override
    public List<Admin> findAll() {
        List<Admin> list = new ArrayList<>();
        String sql = "SELECT u.id, u.name, u.username, u.password, u.email, u.phone, u.address, u.status, " +
                     "u.createdAt, u.updatedAt, u.createdBy, u.updatedBy, " +
                     "a.department, a.lastLogin " +
                     "FROM user u INNER JOIN admin a ON u.id = a.adminId";
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
        String updateUser = "UPDATE user SET name=?, username=?, password=?, email=?, phone=?, address=?, status=?, updatedBy=? WHERE id=?";
        String updateAdmin = "UPDATE admin SET department=?, lastLogin=? WHERE adminId=?";
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
        // Xóa admin trước vì khóa ngoại, sau đó xóa user
        String deleteAdmin = "DELETE FROM admin WHERE adminId=?";
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
        // Insert user trước, lấy ID, rồi insert admin
        String insertUser = "INSERT INTO user (name, username, password, email, phone, address, status, createdBy, updatedBy) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)";
        String insertAdmin = "INSERT INTO admin (adminId, department, lastLogin) VALUES (?, ?, ?)";
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

                // Insert admin
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
        // Các cột từ user
        int id = rs.getInt("id");
        String name = rs.getString("name");
        String username = rs.getString("username");
        String password = rs.getString("password");
        String email = rs.getString("email");
        String phone = rs.getString("phone");
        String address = rs.getString("address");
        String status = rs.getString("status");

        LocalDateTime createdAt = rs.getTimestamp("createdAt") != null
                ? rs.getTimestamp("createdAt").toLocalDateTime() : null;
        LocalDateTime updatedAt = rs.getTimestamp("updatedAt") != null
                ? rs.getTimestamp("updatedAt").toLocalDateTime() : null;

        Integer createdBy = rs.getObject("createdBy") != null ? rs.getInt("createdBy") : null;
        Integer updatedBy = rs.getObject("updatedBy") != null ? rs.getInt("updatedBy") : null;

        // Các cột từ admin
        String department = rs.getString("department");
        LocalDateTime lastLogin = rs.getTimestamp("lastLogin") != null
                ? rs.getTimestamp("lastLogin").toLocalDateTime() : null;

        return new Admin(id, name, username, password, email, phone, address, status,
                         createdAt, updatedAt, createdBy, updatedBy,
                         department, lastLogin);
    }

    // Tiện ích: tìm Admin theo ID
    public Admin findById(int id) {
        String sql = "SELECT u.id, u.name, u.username, u.password, u.email, u.phone, u.address, u.status, " +
                     "u.createdAt, u.updatedAt, u.createdBy, u.updatedBy, " +
                     "a.department, a.lastLogin " +
                     "FROM user u INNER JOIN admin a ON u.id = a.adminId " +
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