/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package com.quanlymayphatdien.g1.dal;

import com.quanlymayphatdien.g1.utils.LogModule;
import com.quanlymayphatdien.g1.entity.SystemLog;
import com.quanlymayphatdien.g1.utils.SystemLogger;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;

/**
 *
 * @author LENOVO
 */
public class SystemLogDAO extends DBContext implements I_DAO<SystemLog> {

    @Override
    public List<SystemLog> findAll() {
        throw new UnsupportedOperationException("Not supported yet."); // Generated from nbfs://nbhost/SystemFileSystem/Templates/Classes/Code/GeneratedMethodBody
    }

    @Override
    public boolean update(SystemLog t) {
        throw new UnsupportedOperationException("Not supported yet."); // Generated from nbfs://nbhost/SystemFileSystem/Templates/Classes/Code/GeneratedMethodBody
    }

    @Override
    public boolean delete(SystemLog t) {
        throw new UnsupportedOperationException("Not supported yet."); // Generated from nbfs://nbhost/SystemFileSystem/Templates/Classes/Code/GeneratedMethodBody
    }

    @Override
    public int insert(SystemLog t) {
        int result = -1;
        String sql = "INSERT INTO system_log(level, module, source, message, stack_trace) VALUES(?,?,?,?,?)";
        try {
            connection = getConnection();
            statement = connection.prepareStatement(sql, java.sql.Statement.RETURN_GENERATED_KEYS);

            statement.setString(1, t.getLevel() != null ? t.getLevel() : "ERROR");

            statement.setString(2, t.getModule() != null ? t.getModule() : "OTHER");

            if (t.getSource() != null) {
                statement.setString(3, t.getSource());
            } else {
                statement.setNull(3, java.sql.Types.VARCHAR);
            }

            statement.setString(4, t.getMessage() != null ? t.getMessage() : "(no message)");

            if (t.getStackTrace() != null) {
                statement.setString(5, t.getStackTrace());
            } else {
                statement.setNull(5, java.sql.Types.CLOB);
            }

            statement.executeUpdate();
            resultSet = statement.getGeneratedKeys();
            if (resultSet.next()) result = resultSet.getInt(1);
        } catch (Exception e) {
            SystemLogger.error(LogModule.SYSTEM, "Loi Ngoai Le", e.getMessage() != null ? e.getMessage() : e.getClass().getName(), e);
        } finally {
            closeResources();
        }
        return result;
    }


    public List<SystemLog> findByFilter(String level, String module, String search,
                                        String dateFrom, String dateTo, int page, int pageSize) {
        List<SystemLog> list = new ArrayList<>();
        List<Object> params = new ArrayList<>();

        StringBuilder where = new StringBuilder("WHERE 1=1 ");

        if (level != null && !level.trim().isEmpty()) {
            where.append("AND level = ? ");
            params.add(level.trim());
        }

        if (module != null && !module.trim().isEmpty()) {
            where.append("AND module = ? ");
            params.add(module.trim());
        }

        if (search != null && !search.trim().isEmpty()) {
            where.append("AND (message LIKE ? OR source LIKE ? OR module LIKE ?) ");
            String keyword = "%" + search.trim() + "%";
            params.add(keyword); params.add(keyword); params.add(keyword);
        }

        if (dateFrom != null && !dateFrom.trim().isEmpty()) {
            where.append("AND created_at >= ? ");
            params.add(LocalDate.parse(dateFrom).atStartOfDay());
        }

        if (dateTo != null && !dateTo.trim().isEmpty()) {
            where.append("AND created_at <= ? ");
            params.add(LocalDate.parse(dateTo).atTime(23, 59, 59));
        }

        String sql = "SELECT * FROM system_log " + where
                + "ORDER BY created_at DESC LIMIT ? OFFSET ?";

        try {
            connection = getConnection();
            statement = connection.prepareStatement(sql);
            int idx = 1;
            for (Object param : params) {
                statement.setObject(idx++, param);
            }
            statement.setInt(idx++, pageSize);
            statement.setInt(idx, (page - 1) * pageSize);
            resultSet = statement.executeQuery();
            while (resultSet.next()) {
                list.add(getFromResultSet(resultSet));
            }
        } catch (Exception e) {
            SystemLogger.error(LogModule.SYSTEM, "Loi Ngoai Le", e.getMessage() != null ? e.getMessage() : e.getClass().getName(), e);
        } finally {
            closeResources();
        }
        return list;
    }

    @Override
    public SystemLog getFromResultSet(ResultSet rs) throws SQLException {
        SystemLog log = new SystemLog();
        log.setId(rs.getInt("id"));
        log.setLevel(rs.getString("level"));
        log.setModule(rs.getString("module"));
        log.setSource(rs.getString("source"));
        log.setMessage(rs.getString("message"));
        log.setStackTrace(rs.getString("stack_trace"));
        log.setCreatedAt(rs.getObject("created_at", LocalDateTime.class));
        return log;
    }
    
    public int countByFilter(String level, String module, String search, String dateFrom, String dateTo) {
        List<Object> params = new ArrayList<>();
        StringBuilder where = new StringBuilder("WHERE 1=1 ");

        if (level != null && !level.trim().isEmpty()) {
            where.append("AND level = ? ");
            params.add(level.trim());
        }
        if (module != null && !module.trim().isEmpty()) {
            where.append("AND module = ? ");
            params.add(module.trim());
        }
        if (search != null && !search.trim().isEmpty()) {
            where.append("AND (message LIKE ? OR source LIKE ? OR module LIKE ?) ");
            String kw = "%" + search.trim() + "%";
            params.add(kw); params.add(kw); params.add(kw);
        }
        if (dateFrom != null && !dateFrom.trim().isEmpty()) {
            where.append("AND created_at >= ? ");
            params.add(LocalDate.parse(dateFrom).atStartOfDay());
        }
        if (dateTo != null && !dateTo.trim().isEmpty()) {
            where.append("AND created_at <= ? ");
            params.add(LocalDate.parse(dateTo).atTime(23, 59, 59));
        }

        String sql = "SELECT COUNT(*) FROM system_log " + where;
        try {
            connection = getConnection();
            statement = connection.prepareStatement(sql);
            int idx = 1;
            for (Object param : params) statement.setObject(idx++, param);
            resultSet = statement.executeQuery();
            if (resultSet.next()) return resultSet.getInt(1);
        } catch (Exception e) {
            SystemLogger.error(LogModule.SYSTEM, "Loi Ngoai Le", e.getMessage() != null ? e.getMessage() : e.getClass().getName(), e);
        } finally {
            closeResources();
        }
        return 0;
    }

    public List<String> findDistinctModules() {
        List<String> result = new ArrayList<>();
        String sql = "SELECT DISTINCT module FROM system_log "
                   + "WHERE module IS NOT NULL AND TRIM(module) <> '' "
                   + "ORDER BY module";
        try (Connection c = getConnection();
             PreparedStatement p = c.prepareStatement(sql);
             ResultSet rs = p.executeQuery()) {
            while (rs.next()) {
                result.add(rs.getString(1));
            }
        } catch (Exception e) {
            SystemLogger.error(LogModule.SYSTEM, "SystemLogDAO.findDistinctModules", e.getMessage(), e);
        }
        return result;
    }

}