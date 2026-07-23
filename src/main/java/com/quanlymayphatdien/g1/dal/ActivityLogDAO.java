/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package com.quanlymayphatdien.g1.dal;

import com.quanlymayphatdien.g1.entity.ActivityLog;
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

/**
 *
 * @author LENOVO
 */
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
        int result = -1;
        String sql = "insert into activity_log(user_id, entity_type, action, entity_id, entity_name, details, created_at) "
                + "values(?, ?, ?, ?, ?, ?, ?)";
        try {
            connection = getConnection();
            statement = connection.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS);
            statement.setInt(1, t.getUserId());
            statement.setString(2, t.getEntityType());
            statement.setString(3, t.getAction());
            if (t.getEntityId() != null) {
                statement.setInt(4, t.getEntityId());
            } else {
                statement.setNull(4, Types.INTEGER);
            }
            statement.setString(5, t.getEntityName());
            statement.setString(6, t.getDetails());
            statement.setObject(7, LocalDateTime.now());

            if (statement.executeUpdate() > 0) {
                resultSet = statement.getGeneratedKeys();
                if (resultSet.next()) {
                    result = resultSet.getInt(1);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            closeResources();
        }
        return result;
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

  
    public List<ActivityLog> findByEntityType(String entityType, int page, int pageSize) {
        List<ActivityLog> list = new ArrayList<>();
        String sql = "select al.* , u.name as user_name "
                + "from activity_log al join user u on al.user_id = u.id "
                + "where al.entity_type = ? "
                + "order by al.created_at desc "
                + "limit ? offset ?";
        try {
            connection = getConnection();
            statement = connection.prepareStatement(sql);
            statement.setString(1, entityType);
            statement.setInt(2, pageSize);
            statement.setInt(3, (page - 1) * pageSize);
            resultSet = statement.executeQuery();
            while (resultSet.next()) {
                ActivityLog log = getFromResultSet(resultSet);
                log.setUsername(resultSet.getString("user_name"));
                list.add(log);
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            closeResources();
        }
        return list;
    }

    public int countByEntityType(String entityType) {
        int result = 0;
        String sql = "SELECT COUNT(*) FROM activity_log WHERE entity_type = ?";
        try {
            connection = getConnection();
            statement = connection.prepareStatement(sql);
            statement.setString(1, entityType);
            resultSet = statement.executeQuery();
            if (resultSet.next()) {
                result = resultSet.getInt(1);
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            closeResources();
        }
        return result;
    }

 
    public List<ActivityLog> findByFilter(String entityType, String search, String action,
            String dateFrom, String dateTo,
            int page, int pageSize) {
        List<ActivityLog> list = new ArrayList<>();
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

        String sql = "SELECT al.*, u.name AS user_name "
                + "FROM activity_log al JOIN user u ON al.user_id = u.id "
                + where
                + "ORDER BY al.created_at DESC "
                + "LIMIT ? OFFSET ?";

        try {
            connection = getConnection();
            statement = connection.prepareStatement(sql);

            int idx = 1;
            for (Object param : params) {
                if (param instanceof String) {
                    statement.setString(idx++, (String) param);
                } else if (param instanceof LocalDateTime) {
                    statement.setObject(idx++, (LocalDateTime) param);
                } else {
                    statement.setObject(idx++, param);
                }
            }

            statement.setInt(idx++, pageSize);
            statement.setInt(idx, (page - 1) * pageSize);

            resultSet = statement.executeQuery();
            while (resultSet.next()) {
                ActivityLog log = getFromResultSet(resultSet);
                log.setUsername(resultSet.getString("user_name"));
                list.add(log);
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            closeResources();
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


        String sql = "SELECT COUNT(*) "
                + "FROM activity_log al JOIN user u ON al.user_id = u.id "
                + where;

        try {
            connection = getConnection();
            statement = connection.prepareStatement(sql);

            int idx = 1;
            for (Object param : params) {
                if (param instanceof String) {
                    statement.setString(idx++, (String) param);
                } else if (param instanceof LocalDateTime) {
                    statement.setObject(idx++, (LocalDateTime) param);
                } else {
                    statement.setObject(idx++, param);
                }
            }

            resultSet = statement.executeQuery();
            if (resultSet.next()) {
                return resultSet.getInt(1);
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            closeResources();
        }
        return 0;
    }


    public List<ActivityLog> findByModuleFilter(String module, String search, String action,
            String dateFrom, String dateTo,
            int page, int pageSize) {
        List<ActivityLog> list = new ArrayList<>();
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

        String sql = "SELECT al.*, u.name AS user_name "
                + "FROM activity_log al "
                + "JOIN user u ON al.user_id = u.id "
                + "LEFT JOIN category c ON al.entity_id = c.id "
                + where
                + "ORDER BY al.created_at DESC "
                + "LIMIT ? OFFSET ?";

        try {
            connection = getConnection();
            statement = connection.prepareStatement(sql);

            int idx = 1;
            for (Object param : params) {
                if (param instanceof String) {
                    statement.setString(idx++, (String) param);
                } else if (param instanceof LocalDateTime) {
                    statement.setObject(idx++, (LocalDateTime) param);
                } else {
                    statement.setObject(idx++, param);
                }
            }
            statement.setInt(idx++, pageSize);
            statement.setInt(idx, (page - 1) * pageSize);

            resultSet = statement.executeQuery();
            while (resultSet.next()) {
                ActivityLog log = getFromResultSet(resultSet);
                log.setUsername(resultSet.getString("user_name"));
                list.add(log);
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            closeResources();
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

        try {
            connection = getConnection();
            statement = connection.prepareStatement(sql);

            int idx = 1;
            for (Object param : params) {
                if (param instanceof String) {
                    statement.setString(idx++, (String) param);
                } else if (param instanceof LocalDateTime) {
                    statement.setObject(idx++, (LocalDateTime) param);
                } else {
                    statement.setObject(idx++, param);
                }
            }

            resultSet = statement.executeQuery();
            if (resultSet.next()) {
                return resultSet.getInt(1);
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            closeResources();
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

        try {
            connection = getConnection();
            statement = connection.prepareStatement(sql);

            int idx = 1;
            for (Object param : params) {
                if (param instanceof String) {
                    statement.setString(idx++, (String) param);
                } else if (param instanceof LocalDateTime) {
                    statement.setObject(idx++, (LocalDateTime) param);
                } else {
                    statement.setObject(idx++, param);
                }
            }
            statement.setInt(idx++, pageSize);
            statement.setInt(idx, (page - 1) * pageSize);

            resultSet = statement.executeQuery();
            while (resultSet.next()) {
                ActivityLog log = getFromResultSet(resultSet);
                log.setUsername(resultSet.getString("user_name"));
                list.add(log);
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            closeResources();
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

        try {
            connection = getConnection();
            statement = connection.prepareStatement(sql);

            int idx = 1;
            for (Object param : params) {
                if (param instanceof String) {
                    statement.setString(idx++, (String) param);
                } else if (param instanceof LocalDateTime) {
                    statement.setObject(idx++, (LocalDateTime) param);
                } else {
                    statement.setObject(idx++, param);
                }
            }

            resultSet = statement.executeQuery();
            if (resultSet.next()) {
                return resultSet.getInt(1);
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            closeResources();
        }
        return 0;
    }


    public List<ActivityLog> findByEntityId(int entityId, String search, String action, String dateFrom, String dateTo, int page, int pageSize) {
        List<ActivityLog> list = new ArrayList<>();
        List<Object> params = new ArrayList<>();

        StringBuilder where = new StringBuilder(
                "WHERE al.entity_type = 'categories' "
                + "AND al.entity_id = ? "
                + "AND al.action NOT IN ('VIEW_LIST', 'VIEW_DETAIL') "
        );
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

        try {
            connection = getConnection();
            statement = connection.prepareStatement(sql);
            int idx = 1;
            for (Object param : params) {
                if (param instanceof String) {
                    statement.setString(idx++, (String) param);
                } else if (param instanceof LocalDateTime) {
                    statement.setObject(idx++, (LocalDateTime) param);
                } else {
                    statement.setObject(idx++, param);
                }
            }
            statement.setInt(idx++, pageSize);
            statement.setInt(idx, (page - 1) * pageSize);

            resultSet = statement.executeQuery();
            while (resultSet.next()) {
                ActivityLog log = getFromResultSet(resultSet);
                log.setUsername(resultSet.getString("user_name"));
                list.add(log);
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            closeResources();
        }
        return list;
    }


    public int countByEntityId(int entityId, String search, String action, String dateFrom, String dateTo) {
        List<Object> params = new ArrayList<>();

        StringBuilder where = new StringBuilder(
                "WHERE al.entity_type = 'categories' "
                + "AND al.entity_id = ? "
                + "AND al.action NOT IN ('VIEW_LIST', 'VIEW_DETAIL') "
        );
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

        try {
            connection = getConnection();
            statement = connection.prepareStatement(sql);
            int idx = 1;
            for (Object param : params) {
                if (param instanceof String) {
                    statement.setString(idx++, (String) param);
                } else if (param instanceof LocalDateTime) {
                    statement.setObject(idx++, (LocalDateTime) param);
                } else {
                    statement.setObject(idx++, param);
                }
            }
            resultSet = statement.executeQuery();
            if (resultSet.next()) {
                return resultSet.getInt(1);
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            closeResources();
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
        try {
            connection = getConnection();
            statement = connection.prepareStatement(sql);
            statement.setString(1, entityType);
            statement.setInt(2, entityId);
            statement.setInt(3, pageSize);
            statement.setInt(4, (page - 1) * pageSize);
            resultSet = statement.executeQuery();
            while (resultSet.next()) {
                list.add(getLogFromResultSet(resultSet));
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            closeResources();
        }
        return list;
    }

    private ActivityLog getLogFromResultSet(ResultSet rs) throws SQLException {
        ActivityLog log = new ActivityLog();
        log.setId(rs.getInt("id"));
        log.setUserId(rs.getInt("user_id"));
        log.setUsername(rs.getString("user_name"));
        log.setAction(rs.getString("action"));
        log.setEntityType(rs.getString("entity_type"));
        log.setEntityId(rs.getObject("entity_id", Integer.class));
        log.setDetails(rs.getString("details"));
        log.setCreatedAt(rs.getObject("created_at", LocalDateTime.class));
        return log;
    }

    public int insertLog(ActivityLog t) {
        int result = -1;
        String sql = "insert into activity_log(user_id, action, entity_type, entity_id, entity_name, details, created_at) "
                + "values(?, ?, ?, ?, ?, ?, ?)";
        try {
            connection = getConnection();
            statement = connection.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS);
            statement.setInt(1, t.getUserId());
            statement.setString(2, t.getAction());
            statement.setString(3, t.getEntityType());
            if (t.getEntityId() != null) {
                statement.setInt(4, t.getEntityId());
            } else {
                statement.setNull(4, Types.INTEGER);
            }
            statement.setString(5, t.getEntityName());
            statement.setString(6, t.getDetails());
            statement.setObject(7, LocalDateTime.now());

            if (statement.executeUpdate() > 0) {
                resultSet = statement.getGeneratedKeys();
                if (resultSet.next()) {
                    result = resultSet.getInt(1);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            closeResources();
        }
        return result;
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

        try {
            connection = getConnection();
            statement = connection.prepareStatement(sql);
            int idx = 1;
            for (Object param : params) {
                if (param instanceof String) {
                    statement.setString(idx++, (String) param);
                } else if (param instanceof LocalDateTime) {
                    statement.setObject(idx++, (LocalDateTime) param);
                } else {
                    statement.setObject(idx++, param);
                }
            }
            statement.setInt(idx++, pageSize);
            statement.setInt(idx, (page - 1) * pageSize);

            resultSet = statement.executeQuery();
            while (resultSet.next()) {
                ActivityLog log = getFromResultSet(resultSet);
                log.setUsername(resultSet.getString("user_name"));
                list.add(log);

            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            closeResources();
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

        try {
            connection = getConnection();
            statement = connection.prepareStatement(sql);
            int idx = 1;
            for (Object param : params) {
                if (param instanceof String) {
                    statement.setString(idx++, (String) param);
                } else if (param instanceof LocalDateTime) {
                    statement.setObject(idx++, (LocalDateTime) param);
                } else {
                    statement.setObject(idx++, param);
                }
            }
            resultSet = statement.executeQuery();
            if (resultSet.next()) {
                return resultSet.getInt(1);
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            closeResources();
        }
        return 0;
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

        try {
            connection = getConnection();
            statement = connection.prepareStatement(sql);
            int idx = 1;
            for (Object param : params) {
                if (param instanceof String) {
                    statement.setString(idx++, (String) param);
                } else if (param instanceof LocalDateTime) {
                    statement.setObject(idx++, (LocalDateTime) param);
                } else {
                    statement.setObject(idx++, param);
                }
            }
            statement.setInt(idx++, pageSize);
            statement.setInt(idx, (page - 1) * pageSize);

            resultSet = statement.executeQuery();
            while (resultSet.next()) {
                ActivityLog log = getFromResultSet(resultSet);
                log.setUsername(resultSet.getString("user_name"));
                list.add(log);
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            closeResources();
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

        try {
            connection = getConnection();
            statement = connection.prepareStatement(sql);
            int idx = 1;
            for (Object param : params) {
                if (param instanceof String) {
                    statement.setString(idx++, (String) param);
                } else if (param instanceof LocalDateTime) {
                    statement.setObject(idx++, (LocalDateTime) param);
                } else {
                    statement.setObject(idx++, param);
                }
            }
            resultSet = statement.executeQuery();
            if (resultSet.next()) {
                return resultSet.getInt(1);
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            closeResources();
        }
        return 0;
    }

    public int countByEntityTypeAndId(String entityType, int entityId) {
        int result = 0;
        String sql = "SELECT COUNT(*) FROM activity_log "
                + "WHERE entity_type = ? AND entity_id = ?";
        try {
            connection = getConnection();
            statement = connection.prepareStatement(sql);
            statement.setString(1, entityType);
            statement.setInt(2, entityId);
            resultSet = statement.executeQuery();
            if (resultSet.next()) {
                result = resultSet.getInt(1);
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            closeResources();
        }
        return result;
    }

    public List<ActivityLog> findByEntityTypeAndId(String entityType, int entityId,
            int page, int pageSize) {
        List<ActivityLog> list = new ArrayList<>();
        String sql = "select al.*, u.name as user_name "
                + "from activity_log al join user u on al.user_id = u.id "
                + "where al.entity_type = ? and al.entity_id = ? "
                + "order by al.created_at desc "
                + "limit ? offset ?";
        try {
            connection = getConnection();
            statement = connection.prepareStatement(sql);
            statement.setString(1, entityType);
            statement.setInt(2, entityId);
            statement.setInt(3, pageSize);
            statement.setInt(4, (page - 1) * pageSize);
            resultSet = statement.executeQuery();
            while (resultSet.next()) {
                ActivityLog log = getFromResultSet(resultSet);
                log.setUsername(resultSet.getString("user_name"));
                list.add(log);
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            closeResources();
        }
        return list;
    }

}