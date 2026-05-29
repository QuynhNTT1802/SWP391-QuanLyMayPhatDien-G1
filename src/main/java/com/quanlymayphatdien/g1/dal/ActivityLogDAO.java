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
        try(Connection c = getConnection()) {
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
            
            if(p.executeUpdate() > 0) {
                try(ResultSet rs = p.getGeneratedKeys()) {
                    if(rs.next()){
                        return rs.getInt(1);
                    }
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return -1;
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
        return new ActivityLog(id,userId,entityType,action,entityId,entityName, details,createdAt);
               
    }

    public List<ActivityLog> findByEntityType(String entityType, int page, int pageSize) {
        List<ActivityLog> list = new ArrayList<>();
        String sql = "select al.* , u.name as user_name "
                   + "from activity_log al join user u on al.user_id = u.id "
                   + "where al.entity_type = ? "
                   + "order by al.created_at desc "
                   + "limit ? offset ?";
        try(Connection c = getConnection()) {
            PreparedStatement p = c.prepareStatement(sql);
            p.setString(1,entityType);
            p.setInt(2, pageSize);
            p.setInt(3, (page - 1) * pageSize);
            ResultSet rs = p.executeQuery();
            while(rs.next()){
                ActivityLog log = getFromResultSet(rs);
                log.setUsername(rs.getString("user_name"));
                list.add(log);
            }
        } catch(Exception e){
            e.printStackTrace();
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
        try (Connection c = getConnection()){
             PreparedStatement p = c.prepareStatement(sql);
             p.setString(1, entityType);
             ResultSet rs = p.executeQuery();
             if(rs.next()){
                 return rs.getInt(1);
             }
        } catch (Exception e){
            e.printStackTrace();
        }
        return 0;
    }
    
    
    
}
