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
            e.printStackTrace();
        }
        return -1;
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
            e.printStackTrace();
        }
        return list;
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
            e.printStackTrace();
        }
        return 0;
    }

    /**
     * Tìm kiếm log có filter động: keyword (tên đối tượng / tên người dùng),
     * action (CREATE/UPDATE/DELETE...) và khoảng ngày (dateFrom - dateTo). SQL
     * được ghép động qua StringBuilder + List params để an toàn với SQL
     * injection.
     *
     * @param entityType loại đối tượng, VD "categories"
     * @param search từ khóa tìm kiếm (entity_name hoặc username), có thể
     * null/rỗng
     * @param action loại hành động, có thể null/rỗng (= lấy tất cả)
     * @param dateFrom ngày bắt đầu dạng "yyyy-MM-dd", có thể null/rỗng
     * @param dateTo ngày kết thúc dạng "yyyy-MM-dd", có thể null/rỗng
     * @param page trang hiện tại (bắt đầu từ 1)
     * @param pageSize số bản ghi mỗi trang
     */
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
            e.printStackTrace();
        }
        return list;
    }

    /**
     * Đếm tổng số bản ghi thỏa bộ filter — dùng cho phân trang. Cùng logic ghép
     * WHERE với findByFilter().
     */
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
            e.printStackTrace();
        }
        return 0;
    }

    /**
     * Tìm log của danh mục theo module (phân trang + filter động). Dùng LEFT
     * JOIN với bảng category để lọc theo module. Với log DELETE (category đã
     * xóa), fallback: kiểm tra details có chứa "module:[module]". Luôn loại bỏ
     * các log VIEW_LIST, VIEW_DETAIL khỏi kết quả.
     *
     * @param module tên module, VD "quản lý vật tư"
     * @param search từ khóa tìm theo entity_name hoặc username, có thể null
     * @param action loại hành động (CREATE/UPDATE/DELETE), có thể null
     * @param dateFrom ngày bắt đầu yyyy-MM-dd, có thể null
     * @param dateTo ngày kết thúc yyyy-MM-dd, có thể null
     * @param page trang hiện tại (bắt đầu từ 1)
     * @param pageSize số bản ghi mỗi trang
     */
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
            e.printStackTrace();
        }
        return list;
    }

    /**
     * Đếm tổng số log theo module — dùng cho phân trang. Cùng logic WHERE với
     * findByModuleFilter.
     */
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
            e.printStackTrace();
        }
        return 0;
    }

    /**
     * Tìm log của danh mục theo loại (type) và module. Dùng cho tab Lịch sử cấp
     * 1 bên trong danh sách loại danh mục.
     */
    public List<ActivityLog> findByTypeAndModuleFilter(String module, String type, String search, String action,
            String dateFrom, String dateTo,
            int page, int pageSize) {
        List<ActivityLog> list = new ArrayList<>();
        List<Object> params = new ArrayList<>();

        StringBuilder where = new StringBuilder(
                "WHERE al.entity_type = 'categories' "
                + "AND al.action NOT IN ('VIEW_LIST', 'VIEW_DETAIL') "
                + "AND ( (c.module = ? AND c.type = ?) OR (c.module IS NULL AND al.details LIKE ? AND al.details LIKE ?) ) "
        );
        params.add(module);
        params.add(type);
        params.add("%module:" + module + "%");
        params.add("%type:" + type + "%"); // fallback trong tương lai nếu log delete lưu type

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
            e.printStackTrace();
        }
        return list;
    }

    /**
     * Đếm tổng số log theo loại và module — dùng cho phân trang Lịch sử cấp 1.
     */
    public int countByTypeAndModuleFilter(String module, String type, String search, String action,
            String dateFrom, String dateTo) {
        List<Object> params = new ArrayList<>();

        StringBuilder where = new StringBuilder(
                "WHERE al.entity_type = 'categories' "
                + "AND al.action NOT IN ('VIEW_LIST', 'VIEW_DETAIL') "
                + "AND ( (c.module = ? AND c.type = ?) OR (c.module IS NULL AND al.details LIKE ? AND al.details LIKE ?) ) "
        );
        params.add(module);
        params.add(type);
        params.add("%module:" + module + "%");
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
            e.printStackTrace();
        }
        return 0;
    }

    /**
     * Lấy lịch sử hoạt động của một danh mục cụ thể theo entity_id. Dùng cho
     * tab "Lịch sử" cấp 2 trong trang edit danh mục.
     *
     * @param entityId id của danh mục cụ thể
     * @param search tìm kiếm theo tên người dùng
     * @param action lọc theo hành động (CREATE/UPDATE/DELETE), null = tất cả
     * @param dateFrom từ ngày (yyyy-MM-dd)
     * @param dateTo đến ngày (yyyy-MM-dd)
     * @param page trang hiện tại (bắt đầu từ 1)
     * @param pageSize số bản ghi mỗi trang
     */
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
            e.printStackTrace();
        }
        return list;
    }

    /**
     * Đếm số bản ghi lịch sử theo entity_id — dùng cho phân trang tab cấp 2.
     */
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
            e.printStackTrace();
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
            e.printStackTrace();
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
            e.printStackTrace();
        }
        return -1;
    }

}
