/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package com.quanlymayphatdien.g1.dal;

import com.quanlymayphatdien.g1.utils.LogModule;
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

    public List<PasswordResetRequest> findAll(int page, int pageSize, String status,
            String search, String fromDate, String toDate) {
        List<PasswordResetRequest> list = new ArrayList<>();
        StringBuilder sql = new StringBuilder(
                "SELECT pr.*, u.name AS user_name, u.username, u.phone "
                + "FROM password_reset_request pr "
                + "JOIN user u ON pr.user_id = u.id "
                + "WHERE 1=1 ");
        List<Object> params = new ArrayList<>();
        if (status != null && !status.isEmpty()) {
            sql.append("AND pr.status = ? ");
            params.add(status);
        }
        if (search != null && !search.trim().isEmpty()) {
            sql.append("AND u.username LIKE ? ");
            params.add("%" + search.trim() + "%");
        }
        if (fromDate != null && !fromDate.isEmpty()) {
            sql.append("AND DATE(pr.created_at) >= ? ");
            params.add(fromDate);
        }
        if (toDate != null && !toDate.isEmpty()) {
            sql.append("AND DATE(pr.created_at) <= ? ");
            params.add(toDate);
        }
        sql.append("ORDER BY pr.created_at DESC LIMIT ? OFFSET ?");
        params.add(pageSize);
        params.add((page - 1) * pageSize);
        try {
            connection = getConnection();
            statement = connection.prepareStatement(sql.toString());
            for (int i = 0; i < params.size(); i++) {
                statement.setObject(i + 1, params.get(i));
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

    public List<PasswordResetRequest> findAll(int page, int pageSize, String status) {
        return findAll(page, pageSize, status, null, null, null);
    }

    public int getTotalCountByStatus(String status, String search, String fromDate, String toDate) {
        StringBuilder sql = new StringBuilder(
                "SELECT COUNT(*) FROM password_reset_request pr "
                + "JOIN user u ON pr.user_id = u.id "
                + "WHERE 1=1 ");
        List<Object> params = new ArrayList<>();
        if (status != null && !status.isEmpty()) {
            sql.append("AND pr.status = ? ");
            params.add(status);
        }
        if (search != null && !search.trim().isEmpty()) {
            sql.append("AND u.username LIKE ? ");
            params.add("%" + search.trim() + "%");
        }
        if (fromDate != null && !fromDate.isEmpty()) {
            sql.append("AND DATE(pr.created_at) >= ? ");
            params.add(fromDate);
        }
        if (toDate != null && !toDate.isEmpty()) {
            sql.append("AND DATE(pr.created_at) <= ? ");
            params.add(toDate);
        }
        try {
            connection = getConnection();
            statement = connection.prepareStatement(sql.toString());
            for (int i = 0; i < params.size(); i++) {
                statement.setObject(i + 1, params.get(i));
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

    public int getTotalCountByStatus(String status) {
        return getTotalCountByStatus(status, null, null, null);
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
                + " note = ?, processed_at = ? WHERE id = ?";
        try {
            connection = getConnection();
            statement = connection.prepareStatement(sql);
            statement.setString(1, req.getStatus());
            statement.setInt(2, req.getProcessedBy());
            statement.setString(3, req.getNote());
            statement.setObject(4, req.getProcessedAt());
            statement.setInt(5, req.getId());
            return statement.executeUpdate() > 0;
        } catch (SQLException e) {
            com.quanlymayphatdien.g1.utils.SystemLogger.error(LogModule.SYSTEM, "Loi Ngoai Le", e.getMessage() != null ? e.getMessage() : e.getClass().getName(), e);
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
        req.setNote(rs.getString("note"));
        req.setCreatedAt(rs.getTimestamp("created_at") != null
                ? rs.getTimestamp("created_at").toLocalDateTime() : null);
        req.setProcessedAt(rs.getTimestamp("processed_at") != null
                ? rs.getTimestamp("processed_at").toLocalDateTime() : null);
        return req;
    }

}