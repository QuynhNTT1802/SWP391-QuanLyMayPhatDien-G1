/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package com.quanlymayphatdien.g1.dal;

import com.quanlymayphatdien.g1.entity.ActivityLog;
import com.quanlymayphatdien.g1.entity.Role;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;

/**
 *
 * @author LENOVO
 */
public class RoleDAO extends DBContext implements I_DAO<Role> {

    //cap nhat permission cho 1 role
    public boolean updatePermissionRole(int roleId, List<Integer> perIds) throws SQLException {
        String deleteOld = "delete from role_permission where role_id = ?";
        String insertNew = "insert into role_permission (role_id, permission_id) values (?, ?)";
        try (Connection c = getConnection()) {
            c.setAutoCommit(false);
            try {
                PreparedStatement del = c.prepareStatement(deleteOld);
                del.setInt(1, roleId);
                del.executeUpdate();

                if (perIds != null && !perIds.isEmpty()) {
                    PreparedStatement ins = c.prepareStatement(insertNew);
                    for (Integer pId : perIds) {
                        ins.setInt(1, roleId);
                        ins.setInt(2, pId);
                        ins.addBatch();// batch giup chay nhanh hon
                    }
                    ins.executeBatch();
                    ins.close();
                }
                c.commit();
                return true;
            } catch (Exception e) {
                c.rollback();
                e.printStackTrace();
            }
        }
        return false;
    }

    public List<Role> getRolesByUserId(int userId) {
        List<Role> roles = new ArrayList<>();
        String sql = "SELECT r.* FROM role r JOIN user_role ur ON r.id = ur.role_id WHERE ur.user_id = ? AND r.status = 'active'";
        try {
            connection = getConnection();
            statement = connection.prepareStatement(sql);
            statement.setInt(1, userId);
            resultSet = statement.executeQuery();
            while (resultSet.next()) {
                Role role = new Role();
                role.setRoleId(resultSet.getInt("id"));
                role.setRoleName(resultSet.getString("name"));
                role.setDescription(resultSet.getString("description"));
                roles.add(role);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            closeResources();
        }
        return roles;
    }

    //deactive or active
    public boolean updateStatus(int roleId, String status) {
        String sql = "UPDATE role SET status = ? WHERE id = ?";
        try {
            connection = getConnection();
            statement = connection.prepareStatement(sql);
            statement.setString(1, status);
            statement.setInt(2, roleId);
            return statement.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            closeResources();
        }
        return false;
    }

    public boolean isRoleNameExists(String name, int excludeRoleId) {
        String sql = "SELECT COUNT(*) FROM role WHERE name = ? AND id != ?";
        try {
            connection = getConnection();
            statement = connection.prepareStatement(sql);
            statement.setString(1, name);
            statement.setInt(2, excludeRoleId);
            resultSet = statement.executeQuery();
            if (resultSet.next()) {
                return resultSet.getInt(1) > 0;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            closeResources();
        }
        return false;
    }

    public List<Role> searchByName(String keyword) {
        List<Role> list = new ArrayList<>();
        String sql = "SELECT * FROM role WHERE name LIKE ? OR description LIKE ? ORDER BY id";
        try {
            connection = getConnection();
            statement = connection.prepareStatement(sql);
            String likeKeyword = "%" + keyword + "%";
            statement.setString(1, likeKeyword);
            statement.setString(2, likeKeyword);
            resultSet = statement.executeQuery();
            while (resultSet.next()) {
                list.add(getFromResultSet(resultSet));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            closeResources();
        }
        return list;
    }
    

    @Override
    public List<Role> findAll() {
        List<Role> list = new ArrayList<>();
        String sql = "SELECT * FROM role ORDER BY id";
        try {
            connection = getConnection();
            statement = connection.prepareStatement(sql);
            resultSet = statement.executeQuery();
            while (resultSet.next()) {
                list.add(getFromResultSet(resultSet));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            closeResources();
        }
        return list;
    }

    @Override
    public boolean update(Role role) {
        String sql = "UPDATE role SET name = ?, description = ?, status = ?, updated_at = ? WHERE id = ?";
        try {
            connection = getConnection();
            statement = connection.prepareStatement(sql);
            statement.setString(1, role.getRoleName());
            statement.setString(2, role.getDescription());
            statement.setString(3, role.getStatus());
            statement.setObject(4, LocalDateTime.now());
            statement.setInt(5, role.getRoleId());
            return statement.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            closeResources();
        }
        return false;
    }

    @Override
    public boolean delete(Role role) {
        String sql = "UPDATE role SET status = 'inactive', updated_at = ? WHERE id = ?";
        try {
            connection = getConnection();
            statement = connection.prepareStatement(sql);
            statement.setObject(1, LocalDateTime.now());
            statement.setInt(2, role.getRoleId());
            return statement.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            closeResources();
        }
        return false;
    }

    @Override
    public int insert(Role role) {
        String sql = "INSERT INTO role (name, description, status, created_at, updated_at) VALUES (?, ?, ?, ?, ?)";
        try {
            connection = getConnection();
            statement = connection.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS);
            statement.setString(1, role.getRoleName());
            statement.setString(2, role.getDescription());
            statement.setString(3, role.getStatus());
            LocalDateTime now = LocalDateTime.now();
            statement.setObject(4, now);
            statement.setObject(5, now);

            if (statement.executeUpdate() > 0) {
                resultSet = statement.getGeneratedKeys();
                if (resultSet.next()) {
                    return resultSet.getInt(1);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            closeResources();
        }
        return -1;
    }

    @Override
    public Role getFromResultSet(ResultSet rs) throws SQLException {
        int id = rs.getInt("id");
        String name = rs.getString("name");
        String desc = rs.getString("description");
        String status = rs.getString("status");
        LocalDateTime createdAt = rs.getObject("created_at", LocalDateTime.class);
        LocalDateTime updatedAt = rs.getObject("updated_at", LocalDateTime.class);
        return new Role(id, name, desc, status, createdAt, updatedAt);
    }
}