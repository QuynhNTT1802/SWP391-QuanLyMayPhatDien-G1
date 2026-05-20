/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package com.quanlymayphatdien.g1.dal;

import com.quanlymayphatdien.g1.entity.PasswordResetRequest;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

/**
 *
 * @author FPTShop
 */
public class PasswordResetRequestDAO extends DBContext implements I_DAO<PasswordResetRequest> {

    @Override
    public int insert(PasswordResetRequest req) {
        String sql = "INSERT INTO password_reset_request (user_id) VALUES (?)";
        try {
            connection = getConnection();
            statement = connection.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS);
            statement.setInt(1, req.getUserId());
            statement.executeUpdate();
            resultSet = statement.getGeneratedKeys();
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
    public List<PasswordResetRequest> findAll() {
        List<PasswordResetRequest> list = new ArrayList<>();
        String sql = "SELECT pr.*, u.name AS user_name, u.username, u.phone "
                + "FROM password_reset_request pr "
                + "JOIN user u ON pr.user_id = u.id "
                + "ORDER BY pr.created_at DESC";
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

    public List<PasswordResetRequest> findAll(int page, int pageSize, String status) {
        List<PasswordResetRequest> list = new ArrayList<>();
        String sql = "SELECT pr.*, u.name AS user_name, u.username, u.phone "
                + "FROM password_reset_request pr "
                + "JOIN user u ON pr.user_id = u.id "
                + (status != null && !status.isEmpty() ? " WHERE pr.status = ?" : "")
                + " ORDER BY pr.created_at DESC LIMIT ? OFFSET ?";
        try {
            connection = getConnection();
            statement = connection.prepareStatement(sql);
            int i = 1;
            if (status != null && !status.isEmpty()) {
                statement.setString(i++, status);
            }
            statement.setInt(i++, pageSize);
            statement.setInt(i, (page - 1) * pageSize);
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

    public int getTotalCountByStatus(String status) {
        List<PasswordResetRequest> list = new ArrayList<>();
        String sql = "SELECT COUNT(*) FROM password_reset_request " + (status != null && !status.isEmpty() ? "WHERE status = ? " : "");
        try {
            connection = getConnection();
            statement = connection.prepareStatement(sql);
            if (status != null && !status.isEmpty()) {
                statement.setString(1, status);
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

    public List<PasswordResetRequest> findByStatus(String status) {
        List<PasswordResetRequest> list = new ArrayList<>();
        String sql = "SELECT pr.*, u.name AS user_name, u.username, u.phone "
                + "FROM password_reset_request pr "
                + "JOIN user u ON pr.user_id = u.id "
                + "WHERE pr.status = ? ORDER BY pr.created_at DESC";
        try {
            connection = getConnection();
            statement = connection.prepareStatement(sql);
            statement.setString(1, status);
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

    public boolean hasPendingRequest(int id) {
        List<PasswordResetRequest> list = new ArrayList<>();
        String sql = "SELECT * "
                + "FROM password_reset_request "
                + "WHERE status = 'pending' and user_id = ?";
        try {
            connection = getConnection();
            statement = connection.prepareStatement(sql);
            statement.setInt(1, id);
            resultSet = statement.executeQuery();
            while (resultSet.next()) {
                return true;
            }
        } catch (SQLException e) {
            System.out.println(e.getMessage());
        } finally {
            closeResources();
        }
        return false;
    }

    public PasswordResetRequest findById(int id) {
        String sql = "SELECT pr.*, u.username "
                + "FROM password_reset_request pr "
                + "JOIN user u ON pr.user_id = u.id "
                + "WHERE pr.id = ?";
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
    public boolean update(PasswordResetRequest req) {
        String sql = "UPDATE password_reset_request SET status = ?, processed_by = ?, "
                + "new_password = ?, note = ?, processed_at = ? WHERE id = ?";
        try {
            connection = getConnection();
            statement = connection.prepareStatement(sql);
            statement.setString(1, req.getStatus());
            statement.setInt(2, req.getProcessedBy());
            statement.setString(3, req.getNewPassword());
            statement.setString(4, req.getNote());
            statement.setObject(5, req.getProcessedAt());
            statement.setInt(6, req.getId());
            return statement.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            closeResources();
        }
        return false;
    }

    @Override
    public boolean delete(PasswordResetRequest t) {
        throw new UnsupportedOperationException("Not supported yet."); // Generated from nbfs://nbhost/SystemFileSystem/Templates/Classes/Code/GeneratedMethodBody
    }

    @Override
    public PasswordResetRequest getFromResultSet(ResultSet rs) throws SQLException {
        PasswordResetRequest req = new PasswordResetRequest();
        req.setId(rs.getInt("id"));
        req.setUserId(rs.getInt("user_id"));
        req.setUsername(rs.getString("username"));
        req.setStatus(rs.getString("status"));
        req.setProcessedBy(rs.getObject("processed_by") != null ? rs.getInt("processed_by") : null);
        req.setNewPassword(rs.getString("new_password"));
        req.setNote(rs.getString("note"));
        req.setCreatedAt(rs.getTimestamp("created_at") != null
                ? rs.getTimestamp("created_at").toLocalDateTime() : null);
        req.setProcessedAt(rs.getTimestamp("processed_at") != null
                ? rs.getTimestamp("processed_at").toLocalDateTime() : null);
        return req;
    }

}
