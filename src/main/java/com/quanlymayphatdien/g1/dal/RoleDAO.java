/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package com.quanlymayphatdien.g1.dal;

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
        try (Connection c = getConnection()) {
            PreparedStatement p = c.prepareStatement(sql);
            p.setInt(1, userId);
            ResultSet rs = p.executeQuery();
            while (rs.next()) {
                Role role = new Role();
                role.setRoleId(rs.getInt("id"));
                role.setRoleName(rs.getString("name"));
                role.setDescription(rs.getString("description"));
                roles.add(role);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return roles;
    }

    //deactive or active
    public boolean updateStatus(int roleId, String status) {
        String sql = "UPDATE role SET status = ? WHERE id = ?";
        try (Connection c = getConnection()) {
            PreparedStatement p = c.prepareStatement(sql);
            p.setString(1, status);
            p.setInt(2, roleId);
            return p.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean isRoleNameExists(String name, int excludeRoleId) {
        String sql = "SELECT COUNT(*) FROM role WHERE name = ? AND id != ?";
        try (Connection c = getConnection()) {
            PreparedStatement p = c.prepareStatement(sql);
            p.setString(1, name);
            p.setInt(2, excludeRoleId);
            ResultSet rs = p.executeQuery();
            if (rs.next()) {
                return rs.getInt(1) > 0;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public List<Role> searchByName(String keyword) {
        List<Role> list = new ArrayList<>();
        String sql = "SELECT * FROM role WHERE name LIKE ? OR description LIKE ? ORDER BY id";
        try (Connection c = getConnection()) {
            PreparedStatement p = c.prepareStatement(sql);
            String likeKeyword = "%" + keyword + "%";
            p.setString(1, likeKeyword);
            p.setString(2, likeKeyword);
            ResultSet rs = p.executeQuery();
            while (rs.next()) {
                list.add(getFromResultSet(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    @Override
    public List<Role> findAll() {
        List<Role> list = new ArrayList<>();
        String sql = "SELECT * FROM role ORDER BY id";
        try (Connection c = getConnection()) {
            PreparedStatement p = c.prepareStatement(sql);
            ResultSet rs = p.executeQuery();
            while (rs.next()) {
                list.add(getFromResultSet(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    @Override
    public boolean update(Role role) {
        String sql = "UPDATE role SET name = ?, description = ?, status = ?, updated_at = ? WHERE id = ?";
        try (Connection c = getConnection()) {
            PreparedStatement p = c.prepareStatement(sql);
            p.setString(1, role.getRoleName());
            p.setString(2, role.getDescription());
            p.setString(3, role.getStatus());
            p.setObject(4, LocalDateTime.now());
            p.setInt(5, role.getRoleId());
            return p.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    @Override
    public boolean delete(Role role) {
        String sql = "UPDATE role SET status = 'inactive', updated_at = ? WHERE id = ?";
        try (Connection c = getConnection()) {
            PreparedStatement p = c.prepareStatement(sql);
            p.setObject(1, LocalDateTime.now());
            p.setInt(2, role.getRoleId());
            return p.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    @Override
    public int insert(Role role) {
        String sql = "INSERT INTO role (name, description, status, created_at, updated_at) VALUES (?, ?, ?, ?, ?)";
        try (Connection c = getConnection()) {
            PreparedStatement p = c.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS);
            p.setString(1, role.getRoleName());
            p.setString(2, role.getDescription());
            p.setString(3, role.getStatus());
            LocalDateTime now = LocalDateTime.now();
            p.setObject(4, now);
            p.setObject(5, now);

            if (p.executeUpdate() > 0) {
                try (ResultSet rs = p.getGeneratedKeys()) {
                    if (rs.next()) {
                        return rs.getInt(1);
                    }
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
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