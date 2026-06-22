package com.quanlymayphatdien.g1.dal;

import com.quanlymayphatdien.g1.entity.Notification;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Types;
import java.util.ArrayList;
import java.util.List;

public class NotificationDAO extends DBContext  {

    public boolean insert(Notification notif) {
        boolean result = false;
        String sql = "INSERT INTO notification (user_id, title, message, link, entity_type, entity_id, is_read) VALUES (?, ?, ?, ?, ?, ?, ?)";
        try {
            connection = getConnection();
            statement = connection.prepareStatement(sql);
            statement.setInt(1, notif.getUserId());
            statement.setString(2, notif.getTitle());
            statement.setString(3, notif.getMessage());
            statement.setString(4, notif.getLink());
            statement.setString(5, notif.getEntityType());
            if (notif.getEntityId() == null) {
                statement.setNull(6, Types.INTEGER);
            } else {
                statement.setInt(6, notif.getEntityId());
            }
            statement.setBoolean(7, notif.isRead());
            int rows = statement.executeUpdate();
            result = rows > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            closeResources();
        }
        return result;
    }

    public List<Notification> findByUserId(int userId) {
        List<Notification> list = new ArrayList<>();
        String sql = "SELECT * FROM notification WHERE user_id = ? ORDER BY created_at DESC";
        try {
            connection = getConnection();
            statement = connection.prepareStatement(sql);
            statement.setInt(1, userId);
            resultSet = statement.executeQuery();
            while (resultSet.next()) {
                list.add(map(resultSet));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            closeResources();
        }
        return list;
    }

    public List<Notification> findByUserId(int userId, int limit, int offset) {
        List<Notification> list = new ArrayList<>();
        String sql = "SELECT * FROM notification WHERE user_id = ? ORDER BY created_at DESC LIMIT ? OFFSET ?";
        try {
            connection = getConnection();
            statement = connection.prepareStatement(sql);
            statement.setInt(1, userId);
            statement.setInt(2, limit);
            statement.setInt(3, offset);
            resultSet = statement.executeQuery();
            while (resultSet.next()) {
                list.add(map(resultSet));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            closeResources();
        }
        return list;
    }

    public Notification findById(int id) {
        Notification n = null;
        String sql = "SELECT * FROM notification WHERE id = ?";
        try {
            connection = getConnection();
            statement = connection.prepareStatement(sql);
            statement.setInt(1, id);
            resultSet = statement.executeQuery();
            if (resultSet.next()) {
                n = map(resultSet);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            closeResources();
        }
        return n;
    }

    public List<Notification> findByEntity(String entityType, int entityId) {
        List<Notification> list = new ArrayList<>();
        String sql = "SELECT * FROM notification WHERE entity_type = ? AND entity_id = ? ORDER BY created_at DESC";
        try {
            connection = getConnection();
            statement = connection.prepareStatement(sql);
            statement.setString(1, entityType);
            statement.setInt(2, entityId);
            resultSet = statement.executeQuery();
            while (resultSet.next()) {
                list.add(map(resultSet));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            closeResources();
        }
        return list;
    }

    public boolean markAsRead(int id) {
        boolean result = false;
        String sql = "UPDATE notification SET is_read = 1 WHERE id = ?";
        try {
            connection = getConnection();
            statement = connection.prepareStatement(sql);
            statement.setInt(1, id);
            int rows = statement.executeUpdate();
            result = rows > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            closeResources();
        }
        return result;
    }

    public int markAllAsRead(int userId) {
        int rows = 0;
        String sql = "UPDATE notification SET is_read = 1 WHERE user_id = ? AND is_read = 0";
        try {
            connection = getConnection();
            statement = connection.prepareStatement(sql);
            statement.setInt(1, userId);
            rows = statement.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            closeResources();
        }
        return rows;
    }

    public int countUnread(int userId) {
        int count = 0;
        String sql = "SELECT COUNT(*) FROM notification WHERE user_id = ? AND is_read = 0";
        try {
            connection = getConnection();
            statement = connection.prepareStatement(sql);
            statement.setInt(1, userId);
            resultSet = statement.executeQuery();
            if (resultSet.next()) {
                count = resultSet.getInt(1);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            closeResources();
        }
        return count;
    }

    private Notification map(ResultSet rs) throws SQLException {
        Notification n = new Notification();
        n.setId(rs.getInt("id"));
        n.setUserId(rs.getInt("user_id"));
        n.setTitle(rs.getString("title"));
        n.setMessage(rs.getString("message"));
        n.setLink(rs.getString("link"));
        n.setEntityType(rs.getString("entity_type"));
        int eid = rs.getInt("entity_id");
        n.setEntityId(rs.wasNull() ? null : eid);
        n.setRead(rs.getBoolean("is_read"));
        if (rs.getTimestamp("created_at") != null) {
            n.setCreatedAt(rs.getTimestamp("created_at").toLocalDateTime());
        }
        return n;
    }
}