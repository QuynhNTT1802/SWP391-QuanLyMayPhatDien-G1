/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package com.quanlymayphatdien.g1.dal;

import com.quanlymayphatdien.g1.utils.LogModule;
import com.quanlymayphatdien.g1.entity.SystemLog;
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
        String sql = "INSERT INTO system_log(level, module, source, message, stack_trace) VALUES(?,?,?,?,?)";
        try (Connection c = getConnection();
             PreparedStatement p = c.prepareStatement(sql, java.sql.Statement.RETURN_GENERATED_KEYS)) {


            p.setString(1, t.getLevel() != null ? t.getLevel() : "ERROR");


            p.setString(2, t.getModule() != null ? t.getModule() : "OTHER");
            
            if (t.getSource() != null) {
                p.setString(3, t.getSource());
            } else {
                p.setNull(3, java.sql.Types.VARCHAR);
            }

            p.setString(4, t.getMessage() != null ? t.getMessage() : "(no message)");

            if (t.getStackTrace() != null) {
                p.setString(5, t.getStackTrace());
            } else {
                p.setNull(5, java.sql.Types.CLOB);
            }

            p.executeUpdate();
            try (ResultSet rs = p.getGeneratedKeys()) {
                if (rs.next()) return rs.getInt(1);
            }
        } catch (Exception e) {
            com.quanlymayphatdien.g1.utils.SystemLogger.error(LogModule.SYSTEM, "Loi Ngoai Le", e.getMessage() != null ? e.getMessage() : e.getClass().getName(), e);
        }
        return -1;
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

        try (Connection c = getConnection(); PreparedStatement p = c.prepareStatement(sql)) {
            int idx = 1;
            for (Object param : params) {
                p.setObject(idx++, param);
            }
            p.setInt(idx++, pageSize);
            p.setInt(idx, (page - 1) * pageSize);
            ResultSet rs = p.executeQuery();
            while (rs.next()) {
                list.add(getFromResultSet(rs));
            }
        } catch (Exception e) {
            com.quanlymayphatdien.g1.utils.SystemLogger.error(LogModule.SYSTEM, "Loi Ngoai Le", e.getMessage() != null ? e.getMessage() : e.getClass().getName(), e);
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

    /** Đếm tổng log theo filter — dùng cho phân trang */
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
        try (Connection c = getConnection();
             PreparedStatement p = c.prepareStatement(sql)) {
            int idx = 1;
            for (Object param : params) p.setObject(idx++, param);
            ResultSet rs = p.executeQuery();
            if (rs.next()) return rs.getInt(1);
        } catch (Exception e) {
            com.quanlymayphatdien.g1.utils.SystemLogger.error(LogModule.SYSTEM, "Loi Ngoai Le", e.getMessage() != null ? e.getMessage() : e.getClass().getName(), e);
        }
        return 0;
    }

    /** Lấy danh sách module distinct (đã có dữ liệu) — phục vụ dropdown filter UI. */
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
            com.quanlymayphatdien.g1.utils.SystemLogger.error(LogModule.SYSTEM, "SystemLogDAO.findDistinctModules", e.getMessage(), e);
        }
        return result;
    }

}
