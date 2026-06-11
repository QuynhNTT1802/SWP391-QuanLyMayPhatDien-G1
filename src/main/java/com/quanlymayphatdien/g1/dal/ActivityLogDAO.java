/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package com.quanlymayphatdien.g1.dal;

import com.quanlymayphatdien.g1.entity.ActivityLog;
import com.quanlymayphatdien.g1.utils.SystemLogger;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.sql.Types;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;
public class ActivityLogDAO extends DBContext implements I_DAO<ActivityLog> {

    @Override
    public List<ActivityLog> findAll() {
        return null;
    }

    @Override
    public boolean update(ActivityLog t) {
        throw new UnsupportedOperationException("Not supported yet."); // Generated from nbfs://nbhost/SystemFileSystem/Templates/Classes/Code/GeneratedMethodBody
    }

    @Override
    public boolean delete(ActivityLog t) {
        throw new UnsupportedOperationException("Not supported yet."); // Generated from nbfs://nbhost/SystemFileSystem/Templates/Classes/Code/GeneratedMethodBody
    }

    @Override
    public int insert(ActivityLog t) {
        String sql = "insert into activity_log(user_id, entity_type, action, entity_id, entity_name, details, created_at) "
                + "values(?, ?, ?, ?, ?, ?, ?)";
        try (Connection c = getConnection()) {
            PreparedStatement p = c.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS);
            p.setInt(1, t.getUserId());
            p.setString(2, t.getEntityType());
            p.setString(3, t.getAction());
            if (t.getEntityId() != null) {
                p.setInt(4, t.getEntityId());
            } else {
                p.setNull(4, Types.INTEGER);
            }
            p.setString(5, t.getEntityName());
            p.setString(6, t.getDetails());
            p.setObject(7, LocalDateTime.now());

            if (p.executeUpdate() > 0) {
                try (ResultSet rs = p.getGeneratedKeys()) {
                    if (rs.next()) {
                        return rs.getInt(1);
                    }
                }
            }
        } catch (Exception e) {
            SystemLogger.error("He thong", "Loi Ngoai Le", e.getMessage() != null ? e.getMessage() : e.getClass().getName(), e);
        }
        return -1;
    }

   public int insertLog(ActivityLog t) {
        String sql = "insert into activity_log(user_id, action, entity_type, entity_id, entity_name, details, created_at) "
                   + "values(?, ?, ?, ?, ?, ?, ?)";
        try (Connection c = getConnection()) {
            PreparedStatement p = c.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS);
            p.setInt(1, t.getUserId());
            p.setString(2, t.getAction());
            p.setString(3, t.getEntityType());
            if (t.getEntityId() != null) {
                p.setInt(4, t.getEntityId());
            } else {
                p.setNull(4, Types.INTEGER);
            }
            p.setString(5, t.getEntityName());
            p.setString(6, t.getDetails());
            p.setObject(7, LocalDateTime.now());

            if (p.executeUpdate() > 0) {
                try (ResultSet rs = p.getGeneratedKeys()) {
                    if (rs.next()) {
                        return rs.getInt(1);
                    }
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return -1;
    }

    private ActivityLog getLogFromResultSet(ResultSet rs) throws SQLException {
        ActivityLog log = new ActivityLog();
        log.setId(rs.getInt("id"));
        log.setUserId(rs.getInt("user_id"));
        log.setUsername(rs.getString("username"));
        log.setAction(rs.getString("action"));
        log.setEntityType(rs.getString("entity_type"));
        log.setEntityId(rs.getObject("entity_id", Integer.class));
        log.setDetails(rs.getString("details"));
        log.setCreatedAt(rs.getObject("created_at", LocalDateTime.class));
        return log;
    }

    public List<ActivityLog> getLogsByEntity(String entityType, int entityId,
            int page, int pageSize) {
        List<ActivityLog> list = new ArrayList<>();
        String sql = "select al.*, u.username as username from activity_log al "
                   + "left join user u on al.user_id = u.id "
                   + "where al.entity_type = ? and al.entity_id = ? "
                   + "order by al.created_at desc "
                   + "limit ? offset ?";
        try (Connection c = getConnection()) {
            PreparedStatement p = c.prepareStatement(sql);
            p.setString(1, entityType);
            p.setInt(2, entityId);
            p.setInt(3, pageSize);
            p.setInt(4, (page - 1) * pageSize);
            ResultSet rs = p.executeQuery();
            while (rs.next()) {
                list.add(getLogFromResultSet(rs));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    @Override
    public ActivityLog getFromResultSet(ResultSet rs) throws SQLException {
        int id = rs.getInt("id");
        int userId = rs.getInt("user_id");
        String entityType = rs.getString("entity_type");
        String action = rs.getString("action");
        Integer entityId = rs.getObject("entity_id", Integer.class);
        String entityName = rs.getString("entity_name");
        String details = rs.getString("details");
        LocalDateTime createdAt = rs.getObject("created_at", LocalDateTime.class);
        return new ActivityLog(id, userId, entityType, action, entityId, entityName, details, createdAt);

    }

    //OFFSET = (page - 1) × pageSize
    public List<ActivityLog> findByEntityType(String entityType, int page, int pageSize) {
        List<ActivityLog> list = new ArrayList<>();
        String sql = "select al.* , u.name as user_name "
                + "from activity_log al join user u on al.user_id = u.id "
                + "where al.entity_type = ? "
                + "order by al.created_at desc "
                + "limit ? offset ?";
        try (Connection c = getConnection()) {
            PreparedStatement p = c.prepareStatement(sql);
            p.setString(1, entityType);
            p.setInt(2, pageSize);
            p.setInt(3, (page - 1) * pageSize);
            ResultSet rs = p.executeQuery();
            while (rs.next()) {
                ActivityLog log = getFromResultSet(rs);
                log.setUsername(rs.getString("user_name"));
                list.add(log);
            }
        } catch (Exception e) {
            SystemLogger.error("He thong", "Loi Ngoai Le", e.getMessage() != null ? e.getMessage() : e.getClass().getName(), e);
        }
        return list;
    }
    
    public List<ActivityLog> findByEntityTypeAndId(String entityType, int entityId,
            int page, int pageSize) {
        List<ActivityLog> list = new ArrayList<>();
        String sql = "select al.*, u.name as user_name "
                + "from activity_log al join user u on al.user_id = u.id "
                + "where al.entity_type = ? and al.entity_id = ? "
                + "order by al.created_at desc "
                + "limit ? offset ?";
        try (Connection c = getConnection()) {
            PreparedStatement p = c.prepareStatement(sql);
            p.setString(1, entityType);
            p.setInt(2, entityId);
            p.setInt(3, pageSize);
            p.setInt(4, (page - 1) * pageSize);
            ResultSet rs = p.executeQuery();
            while (rs.next()) {
                ActivityLog log = getFromResultSet(rs);
                log.setUsername(rs.getString("user_name"));
                list.add(log);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    public int countByEntityTypeAndId(String entityType, int entityId) {
        String sql = "SELECT COUNT(*) FROM activity_log "
                + "WHERE entity_type = ? AND entity_id = ?";
        try (Connection c = getConnection()) {
            PreparedStatement p = c.prepareStatement(sql);
            p.setString(1, entityType);
            p.setInt(2, entityId);
            ResultSet rs = p.executeQuery();
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return 0;
    }
    
    public int countByEntityType(String entityType) {
        String sql = "SELECT COUNT(*) FROM activity_log WHERE entity_type = ?";
        try (Connection c = getConnection()) {
            PreparedStatement p = c.prepareStatement(sql);
            p.setString(1, entityType);
            ResultSet rs = p.executeQuery();
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (Exception e) {
            SystemLogger.error("He thong", "Loi Ngoai Le", e.getMessage() != null ? e.getMessage() : e.getClass().getName(), e);
        }
        return 0;
    }
    
    public List<ActivityLog> findByFilter(String entityType, String search, String action,
            String dateFrom, String dateTo,
            int page, int pageSize) {
        List<ActivityLog> list = new ArrayList<>();
        List<Object> params = new ArrayList<>();

        StringBuilder where = new StringBuilder("WHERE al.entity_type = ? ");
        params.add(entityType);

        if (search != null && !search.trim().isEmpty()) {
            // Tìm theo tên đối tượng HOẶC tên người dùng
            where.append("AND (al.entity_name LIKE ? OR u.name LIKE ?) ");
            String kw = "%" + search.trim() + "%";
            params.add(kw);
            params.add(kw);
        }

        if (action != null && !action.trim().isEmpty()) {
            where.append("AND al.action = ? ");
            params.add(action.trim());
        }

        if (dateFrom != null && !dateFrom.trim().isEmpty()) {
            // Lấy từ 00:00:00 của ngày bắt đầu
            where.append("AND al.created_at >= ? ");
            params.add(LocalDate.parse(dateFrom).atStartOfDay());
        }

        if (dateTo != null && !dateTo.trim().isEmpty()) {
            // Lấy đến 23:59:59 của ngày kết thúc
            where.append("AND al.created_at <= ? ");
            params.add(LocalDate.parse(dateTo).atTime(23, 59, 59));
        }

        String sql = "SELECT al.*, u.name AS user_name "
                + "FROM activity_log al JOIN user u ON al.user_id = u.id "
                + where
                + "ORDER BY al.created_at DESC "
                + "LIMIT ? OFFSET ?";

        try (Connection c = getConnection(); PreparedStatement p = c.prepareStatement(sql)) {

            // Bind tất cả params WHERE
            int idx = 1;
            for (Object param : params) {
                if (param instanceof String) {
                    p.setString(idx++, (String) param);
                } else if (param instanceof LocalDateTime) {
                    p.setObject(idx++, (LocalDateTime) param);
                } else {
                    p.setObject(idx++, param);
                }
            }
            // Bind LIMIT và OFFSET
            p.setInt(idx++, pageSize);
            p.setInt(idx, (page - 1) * pageSize);

            ResultSet rs = p.executeQuery();
            while (rs.next()) {
                ActivityLog log = getFromResultSet(rs);
                log.setUsername(rs.getString("user_name"));
                list.add(log);
            }
        } catch (Exception e) {
            SystemLogger.error("He thong", "Loi Ngoai Le", e.getMessage() != null ? e.getMessage() : e.getClass().getName(), e);
        }
        return list;
    }

    public int countByFilter(String entityType, String search, String action,
            String dateFrom, String dateTo) {
        List<Object> params = new ArrayList<>();

        StringBuilder where = new StringBuilder("WHERE al.entity_type = ? ");
        params.add(entityType);

        if (search != null && !search.trim().isEmpty()) {
            where.append("AND (al.entity_name LIKE ? OR u.name LIKE ?) ");
            String kw = "%" + search.trim() + "%";
            params.add(kw);
            params.add(kw);
        }

        if (action != null && !action.trim().isEmpty()) {
            where.append("AND al.action = ? ");
            params.add(action.trim());
        }

        if (dateFrom != null && !dateFrom.trim().isEmpty()) {
            where.append("AND al.created_at >= ? ");
            params.add(LocalDate.parse(dateFrom).atStartOfDay());
        }

        if (dateTo != null && !dateTo.trim().isEmpty()) {
            where.append("AND al.created_at <= ? ");
            params.add(LocalDate.parse(dateTo).atTime(23, 59, 59));
        }

        // JOIN với bảng user để filter theo username
        String sql = "SELECT COUNT(*) "
                + "FROM activity_log al JOIN user u ON al.user_id = u.id "
                + where;

        try (Connection c = getConnection(); PreparedStatement p = c.prepareStatement(sql)) {

            int idx = 1;
            for (Object param : params) {
                if (param instanceof String) {
                    p.setString(idx++, (String) param);
                } else if (param instanceof LocalDateTime) {
                    p.setObject(idx++, (LocalDateTime) param);
                } else {
                    p.setObject(idx++, param);
                }
            }

            ResultSet rs = p.executeQuery();
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (Exception e) {
            SystemLogger.error("He thong", "Loi Ngoai Le", e.getMessage() != null ? e.getMessage() : e.getClass().getName(), e);
        }
        return 0;
    }

    public List<ActivityLog> findByModuleFilter(String module, String search, String action,
            String dateFrom, String dateTo,
            int page, int pageSize) {
        List<ActivityLog> list = new ArrayList<>();
        List<Object> params = new ArrayList<>();

        // WHERE cơ bản: entity_type + lọc module qua JOIN hoặc fallback trong details
        StringBuilder where = new StringBuilder(
                "WHERE al.entity_type = 'categories' "
                + "AND al.action NOT IN ('VIEW_LIST', 'VIEW_DETAIL') "
                + "AND (c.module = ? OR (c.module IS NULL AND al.details LIKE ?)) "
        );
        params.add(module);
        params.add("%module:" + module + "%");

        if (search != null && !search.trim().isEmpty()) {
            where.append("AND (al.entity_name LIKE ? OR u.name LIKE ?) ");
            String kw = "%" + search.trim() + "%";
            params.add(kw);
            params.add(kw);
        }

        if (action != null && !action.trim().isEmpty()) {
            where.append("AND al.action = ? ");
            params.add(action.trim());
        }

        if (dateFrom != null && !dateFrom.trim().isEmpty()) {
            where.append("AND al.created_at >= ? ");
            params.add(LocalDate.parse(dateFrom).atStartOfDay());
        }

        if (dateTo != null && !dateTo.trim().isEmpty()) {
            where.append("AND al.created_at <= ? ");
            params.add(LocalDate.parse(dateTo).atTime(23, 59, 59));
        }

        String sql = "SELECT al.*, u.name AS user_name "
                + "FROM activity_log al "
                + "JOIN user u ON al.user_id = u.id "
                + "LEFT JOIN category c ON al.entity_id = c.id "
                + where
                + "ORDER BY al.created_at DESC "
                + "LIMIT ? OFFSET ?";

        try (Connection c = getConnection(); PreparedStatement p = c.prepareStatement(sql)) {

            int idx = 1;
            for (Object param : params) {
                if (param instanceof String) {
                    p.setString(idx++, (String) param);
                } else if (param instanceof LocalDateTime) {
                    p.setObject(idx++, (LocalDateTime) param);
                } else {
                    p.setObject(idx++, param);
                }
            }
            p.setInt(idx++, pageSize);
            p.setInt(idx, (page - 1) * pageSize);

            ResultSet rs = p.executeQuery();
            while (rs.next()) {
                ActivityLog log = getFromResultSet(rs);
                log.setUsername(rs.getString("user_name"));
                list.add(log);
            }
        } catch (Exception e) {
            SystemLogger.error("He thong", "Loi Ngoai Le", e.getMessage() != null ? e.getMessage() : e.getClass().getName(), e);
        }
        return list;
    }

    public int countByModuleFilter(String module, String search, String action,
            String dateFrom, String dateTo) {
        List<Object> params = new ArrayList<>();

        StringBuilder where = new StringBuilder(
                "WHERE al.entity_type = 'categories' "
                + "AND al.action NOT IN ('VIEW_LIST', 'VIEW_DETAIL') "
                + "AND (c.module = ? OR (c.module IS NULL AND al.details LIKE ?)) "
        );
        params.add(module);
        params.add("%module:" + module + "%");

        if (search != null && !search.trim().isEmpty()) {
            where.append("AND (al.entity_name LIKE ? OR u.name LIKE ?) ");
            String kw = "%" + search.trim() + "%";
            params.add(kw);
            params.add(kw);
        }

        if (action != null && !action.trim().isEmpty()) {
            where.append("AND al.action = ? ");
            params.add(action.trim());
        }

        if (dateFrom != null && !dateFrom.trim().isEmpty()) {
            where.append("AND al.created_at >= ? ");
            params.add(LocalDate.parse(dateFrom).atStartOfDay());
        }

        if (dateTo != null && !dateTo.trim().isEmpty()) {
            where.append("AND al.created_at <= ? ");
            params.add(LocalDate.parse(dateTo).atTime(23, 59, 59));
        }

        String sql = "SELECT COUNT(*) "
                + "FROM activity_log al "
                + "JOIN user u ON al.user_id = u.id "
                + "LEFT JOIN category c ON al.entity_id = c.id "
                + where;

        try (Connection c = getConnection(); PreparedStatement p = c.prepareStatement(sql)) {

            int idx = 1;
            for (Object param : params) {
                if (param instanceof String) {
                    p.setString(idx++, (String) param);
                } else if (param instanceof LocalDateTime) {
                    p.setObject(idx++, (LocalDateTime) param);
                } else {
                    p.setObject(idx++, param);
                }
            }

            ResultSet rs = p.executeQuery();
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (Exception e) {
            SystemLogger.error("He thong", "Loi Ngoai Le", e.getMessage() != null ? e.getMessage() : e.getClass().getName(), e);
        }
        return 0;
    }
    
    public List<ActivityLog> findByTypeAndModuleFilter(String module, String type, String search, String action,
            String dateFrom, String dateTo,
            int page, int pageSize) {
        List<ActivityLog> list = new ArrayList<>();
        List<Object> params = new ArrayList<>();

        StringBuilder where = new StringBuilder(
                "WHERE al.entity_type = 'categories' "
                + "AND al.action NOT IN ('VIEW_LIST', 'VIEW_DETAIL') "
                + "AND ( "
                + "  (c.module = ? AND c.type = ?) "
                + "  OR (c.module IS NULL AND al.details LIKE ? AND al.details LIKE ?) "
                + "  OR (al.entity_id IS NULL AND al.details LIKE ? AND al.details LIKE ?) "
                + ") "
        );
        params.add(module);
        params.add(type);
        params.add("%module:" + module + "%");
        params.add("%type:" + type + "%");
        params.add("%module:" + module + "%"); // fallback cho EXPORT (entity_id null)
        params.add("%type:" + type + "%");

        if (search != null && !search.trim().isEmpty()) {
            where.append("AND (al.entity_name LIKE ? OR u.name LIKE ?) ");
            String kw = "%" + search.trim() + "%";
            params.add(kw);
            params.add(kw);
        }

        if (action != null && !action.trim().isEmpty()) {
            where.append("AND al.action = ? ");
            params.add(action.trim());
        }

        if (dateFrom != null && !dateFrom.trim().isEmpty()) {
            where.append("AND al.created_at >= ? ");
            params.add(LocalDate.parse(dateFrom).atStartOfDay());
        }

        if (dateTo != null && !dateTo.trim().isEmpty()) {
            where.append("AND al.created_at <= ? ");
            params.add(LocalDate.parse(dateTo).atTime(23, 59, 59));
        }

        String sql = "SELECT al.*, u.name AS user_name "
                + "FROM activity_log al "
                + "JOIN user u ON al.user_id = u.id "
                + "LEFT JOIN category c ON al.entity_id = c.id "
                + where
                + "ORDER BY al.created_at DESC "
                + "LIMIT ? OFFSET ?";

        try (Connection c = getConnection(); PreparedStatement p = c.prepareStatement(sql)) {

            int idx = 1;
            for (Object param : params) {
                if (param instanceof String) {
                    p.setString(idx++, (String) param);
                } else if (param instanceof LocalDateTime) {
                    p.setObject(idx++, (LocalDateTime) param);
                } else {
                    p.setObject(idx++, param);
                }
            }
            p.setInt(idx++, pageSize);
            p.setInt(idx, (page - 1) * pageSize);

            ResultSet rs = p.executeQuery();
            while (rs.next()) {
                ActivityLog log = getFromResultSet(rs);
                log.setUsername(rs.getString("user_name"));
                list.add(log);
            }
        } catch (Exception e) {
            SystemLogger.error("He thong", "Loi Ngoai Le", e.getMessage() != null ? e.getMessage() : e.getClass().getName(), e);
        }
        return list;
    }

    public int countByTypeAndModuleFilter(String module, String type, String search, String action,
            String dateFrom, String dateTo) {
        List<Object> params = new ArrayList<>();

        StringBuilder where = new StringBuilder(
                "WHERE al.entity_type = 'categories' "
                + "AND al.action NOT IN ('VIEW_LIST', 'VIEW_DETAIL') "
                + "AND ( "
                + "  (c.module = ? AND c.type = ?) "
                + "  OR (c.module IS NULL AND al.details LIKE ? AND al.details LIKE ?) "
                + "  OR (al.entity_id IS NULL AND al.details LIKE ? AND al.details LIKE ?) "
                + ") "
        );
        params.add(module);
        params.add(type);
        params.add("%module:" + module + "%");
        params.add("%type:" + type + "%");
        params.add("%module:" + module + "%"); // fallback cho EXPORT
        params.add("%type:" + type + "%");

        if (search != null && !search.trim().isEmpty()) {
            where.append("AND (al.entity_name LIKE ? OR u.name LIKE ?) ");
            String kw = "%" + search.trim() + "%";
            params.add(kw);
            params.add(kw);
        }

        if (action != null && !action.trim().isEmpty()) {
            where.append("AND al.action = ? ");
            params.add(action.trim());
        }

        if (dateFrom != null && !dateFrom.trim().isEmpty()) {
            where.append("AND al.created_at >= ? ");
            params.add(LocalDate.parse(dateFrom).atStartOfDay());
        }

        if (dateTo != null && !dateTo.trim().isEmpty()) {
            where.append("AND al.created_at <= ? ");
            params.add(LocalDate.parse(dateTo).atTime(23, 59, 59));
        }

        String sql = "SELECT COUNT(*) "
                + "FROM activity_log al "
                + "JOIN user u ON al.user_id = u.id "
                + "LEFT JOIN category c ON al.entity_id = c.id "
                + where;

        try (Connection c = getConnection(); PreparedStatement p = c.prepareStatement(sql)) {

            int idx = 1;
            for (Object param : params) {
                if (param instanceof String) {
                    p.setString(idx++, (String) param);
                } else if (param instanceof LocalDateTime) {
                    p.setObject(idx++, (LocalDateTime) param);
                } else {
                    p.setObject(idx++, param);
                }
            }

            ResultSet rs = p.executeQuery();
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (Exception e) {
            SystemLogger.error("He thong", "Loi Ngoai Le", e.getMessage() != null ? e.getMessage() : e.getClass().getName(), e);
        }
        return 0;
    }
    
    public List<ActivityLog> findByEntityId(int entityId, String search, String action, String dateFrom, String dateTo, int page, int pageSize) {
        return findByEntityTypeAndId2("categories", entityId, search, action, dateFrom, dateTo, page, pageSize);
    }

    public int countByEntityId(int entityId, String search, String action, String dateFrom, String dateTo) {
        return countByEntityTypeAndId2("categories", entityId, search, action, dateFrom, dateTo);
    }

    public List<ActivityLog> findByEntityTypeAndId2(String entityType, int entityId, String search, String action, String dateFrom, String dateTo, int page, int pageSize) {
        List<ActivityLog> list = new ArrayList<>();
        List<Object> params = new ArrayList<>();

        StringBuilder where = new StringBuilder(
                "WHERE al.entity_type = ? "
                + "AND al.entity_id = ? "
                + "AND al.action NOT IN ('VIEW_LIST', 'VIEW_DETAIL') "
        );
        params.add(entityType);
        params.add(entityId);

        if (search != null && !search.trim().isEmpty()) {
            where.append("AND u.name LIKE ? ");
            params.add("%" + search.trim() + "%");
        }

        if (action != null && !action.trim().isEmpty()) {
            where.append("AND al.action = ? ");
            params.add(action.trim());
        }
        if (dateFrom != null && !dateFrom.trim().isEmpty()) {
            where.append("AND al.created_at >= ? ");
            params.add(LocalDate.parse(dateFrom).atStartOfDay());
        }

        if (dateTo != null && !dateTo.trim().isEmpty()) {
            where.append("AND al.created_at <= ? ");
            params.add(LocalDate.parse(dateTo).atTime(23, 59, 59));
        }

        String sql = "SELECT al.*, u.name AS user_name "
                + "FROM activity_log al "
                + "JOIN user u ON al.user_id = u.id "
                + where
                + "ORDER BY al.created_at DESC "
                + "LIMIT ? OFFSET ?";

        try (Connection c = getConnection(); PreparedStatement p = c.prepareStatement(sql)) {
            int idx = 1;
            for (Object param : params) {
                if (param instanceof String) {
                    p.setString(idx++, (String) param);
                } else if (param instanceof LocalDateTime) {
                    p.setObject(idx++, (LocalDateTime) param);
                } else {
                    p.setObject(idx++, param);
                }
            }
            p.setInt(idx++, pageSize);
            p.setInt(idx, (page - 1) * pageSize);

            ResultSet rs = p.executeQuery();
            while (rs.next()) {
                ActivityLog log = getFromResultSet(rs);
                log.setUsername(rs.getString("user_name"));
                list.add(log);
            }
        } catch (Exception e) {
            SystemLogger.error("He thong", "Loi Ngoai Le", e.getMessage() != null ? e.getMessage() : e.getClass().getName(), e);
        }
        return list;
    }

    public int countByEntityTypeAndId2(String entityType, int entityId, String search, String action, String dateFrom, String dateTo) {
        List<Object> params = new ArrayList<>();

        StringBuilder where = new StringBuilder(
                "WHERE al.entity_type = ? "
                + "AND al.entity_id = ? "
                + "AND al.action NOT IN ('VIEW_LIST', 'VIEW_DETAIL') "
        );
        params.add(entityType);
        params.add(entityId);

        if (search != null && !search.trim().isEmpty()) {
            where.append("AND u.name LIKE ? ");
            params.add("%" + search.trim() + "%");
        }

        if (action != null && !action.trim().isEmpty()) {
            where.append("AND al.action = ? ");
            params.add(action.trim());
        }
        if (dateFrom != null && !dateFrom.trim().isEmpty()) {
            where.append("AND al.created_at >= ? ");
            params.add(LocalDate.parse(dateFrom).atStartOfDay());
        }

        if (dateTo != null && !dateTo.trim().isEmpty()) {
            where.append("AND al.created_at <= ? ");
            params.add(LocalDate.parse(dateTo).atTime(23, 59, 59));
        }

        String sql = "SELECT COUNT(*) "
                + "FROM activity_log al "
                + "JOIN user u ON al.user_id = u.id "
                + where;

        try (Connection c = getConnection(); PreparedStatement p = c.prepareStatement(sql)) {
            int idx = 1;
            for (Object param : params) {
                if (param instanceof String) {
                    p.setString(idx++, (String) param);
                } else if (param instanceof LocalDateTime) {
                    p.setObject(idx++, (LocalDateTime) param);
                } else {
                    p.setObject(idx++, param);
                }
            }
            ResultSet rs = p.executeQuery();
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (Exception e) {
            SystemLogger.error("He thong", "Loi Ngoai Le", e.getMessage() != null ? e.getMessage() : e.getClass().getName(), e);
        }
        return 0;
    }

    public List<ActivityLog> getLogsByEntity(String entityType, int entityId,
            int page, int pageSize) {
        List<ActivityLog> list = new ArrayList<>();
        String sql = "select * from activity_log "
                + "where entity_type = ? and entity_id = ? "
                + "order by created_at desc "
                + "limit ? offset ?";
        try (Connection c = getConnection()) {
            PreparedStatement p = c.prepareStatement(sql);
            p.setString(1, entityType);
            p.setInt(2, entityId);
            p.setInt(3, pageSize);
            p.setInt(4, (page - 1) * pageSize);
            ResultSet rs = p.executeQuery();
            while (rs.next()) {
                list.add(getLogFromResultSet(rs));
            }
        } catch (Exception e) {
            SystemLogger.error("He thong", "Loi Ngoai Le", e.getMessage() != null ? e.getMessage() : e.getClass().getName(), e);
        }
        return list;
    }

    private ActivityLog getLogFromResultSet(ResultSet rs) throws SQLException {
        ActivityLog log = new ActivityLog();
        log.setId(rs.getInt("id"));
        log.setUserId(rs.getInt("user_id"));
        log.setUsername(rs.getString("username"));
        log.setAction(rs.getString("action"));
        log.setEntityType(rs.getString("entity_type"));
        log.setEntityId(rs.getObject("entity_id", Integer.class));
        log.setDetails(rs.getString("description"));
        log.setCreatedAt(rs.getObject("created_at", LocalDateTime.class));
        return log;
    }

    public int insertLog(ActivityLog t) {
        String sql = "insert into activity_log(user_id, username, action, entity_type, entity_id, description, created_at) "
                + "values(?, ?, ?, ?, ?, ?, ?)";
        try (Connection c = getConnection()) {
            PreparedStatement p = c.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS);
            p.setInt(1, t.getUserId());
            p.setString(2, t.getUsername());
            p.setString(3, t.getAction());
            p.setString(4, t.getEntityType());
            if (t.getEntityId() != null) {
                p.setInt(5, t.getEntityId());
            } else {
                p.setNull(5, Types.INTEGER);
            }
            p.setString(6, t.getDetails());
            p.setObject(7, LocalDateTime.now());

            if (p.executeUpdate() > 0) {
                try (ResultSet rs = p.getGeneratedKeys()) {
                    if (rs.next()) {
                        return rs.getInt(1);
                    }
                }
            }
        } catch (Exception e) {
            SystemLogger.error("Hệ thống", "Lỗi ngoại lệ", e.getMessage() != null ? e.getMessage() : e.getClass().getName(), e);
        }
        return -1;
    }

    public List<ActivityLog> getLogsByRoleId(int roleId, String search, String action, String dateFrom, String dateTo, int page, int pageSize) {
        List<ActivityLog> list = new ArrayList<>();
        List<Object> params = new ArrayList<>();
        
        StringBuilder where = new StringBuilder(
                "WHERE al.entity_type = 'roles' AND al.entity_id = ? "
        );
        params.add(roleId);

        if (search != null && !search.trim().isEmpty()) {
            where.append("AND u.name LIKE ? ");
            params.add("%" + search.trim() + "%");
        }

        if (action != null && !action.trim().isEmpty()) {
            where.append("AND al.action = ? ");
            params.add(action.trim());
        }

        if (dateFrom != null && !dateFrom.trim().isEmpty()) {
            where.append("AND al.created_at >= ? ");
            params.add(LocalDate.parse(dateFrom).atStartOfDay());
        }

        if (dateTo != null && !dateTo.trim().isEmpty()) {
            where.append("AND al.created_at <= ? ");
            params.add(LocalDate.parse(dateTo).atTime(23, 59, 59));
        }

        String sql = "SELECT al.*, u.name AS user_name "
                + "FROM activity_log al JOIN user u ON al.user_id = u.id "
                + where
                + "ORDER BY al.created_at DESC "
                + "LIMIT ? OFFSET ?";
                
        try (Connection c = getConnection()) {
            PreparedStatement p = c.prepareStatement(sql);
            int idx = 1;
            for (Object param : params) {
                if (param instanceof String) {
                    p.setString(idx++, (String) param);
                } else if (param instanceof LocalDateTime) {
                    p.setObject(idx++, (LocalDateTime) param);
                } else {
                    p.setObject(idx++, param);
                }
            }
            p.setInt(idx++, pageSize);
            p.setInt(idx, (page - 1) * pageSize);
            
            ResultSet rs = p.executeQuery();
            while (rs.next()) {
                ActivityLog log = getFromResultSet(rs);
                log.setUsername(rs.getString("user_name"));
                list.add(log);

            }
        } catch (Exception e) {
            SystemLogger.error("Hệ thống", "Lỗi ngoại lệ", e.getMessage() != null ? e.getMessage() : e.getClass().getName(), e);
        }
        return list;
    }

    public int countLogsByRoleId(int roleId, String search, String action, String dateFrom, String dateTo) {
        List<Object> params = new ArrayList<>();
        
        StringBuilder where = new StringBuilder(
                "WHERE al.entity_type = 'roles' AND al.entity_id = ? "
        );
        params.add(roleId);

        if (search != null && !search.trim().isEmpty()) {
            where.append("AND u.name LIKE ? ");
            params.add("%" + search.trim() + "%");
        }

        if (action != null && !action.trim().isEmpty()) {
            where.append("AND al.action = ? ");
            params.add(action.trim());
        }

        if (dateFrom != null && !dateFrom.trim().isEmpty()) {
            where.append("AND al.created_at >= ? ");
            params.add(LocalDate.parse(dateFrom).atStartOfDay());
        }

        if (dateTo != null && !dateTo.trim().isEmpty()) {
            where.append("AND al.created_at <= ? ");
            params.add(LocalDate.parse(dateTo).atTime(23, 59, 59));
        }

        String sql = "SELECT COUNT(*) FROM activity_log al JOIN user u ON al.user_id = u.id "
                + where;
                
        try (Connection c = getConnection()) {
            PreparedStatement p = c.prepareStatement(sql);
            int idx = 1;
            for (Object param : params) {
                if (param instanceof String) {
                    p.setString(idx++, (String) param);
                } else if (param instanceof LocalDateTime) {
                    p.setObject(idx++, (LocalDateTime) param);
                } else {
                    p.setObject(idx++, param);
                }
            }
            ResultSet rs = p.executeQuery();
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (Exception e) {
            SystemLogger.error("Hệ thống", "Lỗi ngoại lệ",
                    e.getMessage() != null ? e.getMessage() : e.getClass().getName(), e);
        }
        return 0;
    }

}
