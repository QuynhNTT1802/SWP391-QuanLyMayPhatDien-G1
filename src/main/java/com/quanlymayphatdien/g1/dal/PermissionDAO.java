/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package com.quanlymayphatdien.g1.dal;

import com.quanlymayphatdien.g1.entity.Permission;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.HashSet;
import java.util.List;
import java.util.Map;
import java.util.Set;

/**
 *
 * @author LENOVO
 */
public class PermissionDAO extends DBContext implements I_DAO<Permission> {
    
    //ABAC override -> RBAC
    public Set<String> getEffectPermissions(int userId) throws SQLException {
    Set<String> permissions = getRolePermissions(userId);
    Set<String> denies = applyOverrides(userId, permissions);
    autoGrantViews(permissions, denies);
    return permissions;

}

    private void autoGrantViews(Set<String> permissions, Set<String> denies) {
    Set<String> toAdd = new HashSet<>();
    for (String perm : permissions) {
        int dot = perm.lastIndexOf('.');
        if (dot > 0) {
            String action = perm.substring(dot + 1);
            if (!"view".equals(action)) {              
                String viewPerm = perm.substring(0, dot) + ".view";
                if (!denies.contains(viewPerm)             
                    && !permissions.contains(viewPerm)) {     
                    toAdd.add(viewPerm);
                }
            }
        }
    }
    permissions.addAll(toAdd);
}
    
    //lay quyen dua tren role goc
    public Set<String> getRolePermissions(int userId) throws SQLException {
        Set<String> permissions = new HashSet<>();
        String sql = "select p.resource, p.action from permission p "
                + "join role_permission rp on p.id = rp.permission_id "
                + "join user_role ur on rp.role_id = ur.role_id "
                + "join role r on r.id = ur.role_id "
                + "where ur.user_id = ? and r.status = 'active'";
        try (Connection c = getConnection()) {
            PreparedStatement p = c.prepareStatement(sql);
            p.setInt(1, userId);
            ResultSet rs = p.executeQuery();
            while (rs.next()) {
                String key = rs.getString("resource") + "." + rs.getString("action");
                permissions.add(key);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return permissions;
    }

    // xu li quyen ngoai le overide uu tien cao nhat
    public Set<String> applyOverrides(int userId, Set<String> permissions) throws SQLException {
        Set<String> grants = new HashSet<>();
        Set<String> denies = new HashSet<>();

        String sql = "select * from permission p join user_permission up "
                + "on p.id = up.permission_id "
                + "where up.user_id = ?";
        try (Connection c = getConnection()) {
            PreparedStatement p = c.prepareStatement(sql);
            p.setInt(1, userId);
            ResultSet rs = p.executeQuery();
            while (rs.next()) {
                String key = rs.getString("resource") + "." + rs.getString("action");
                String type = rs.getString("type");

                if ("GRANT".equals(type)) {
                    grants.add(key);
                } else {
                    denies.add(key);
                }
            }

        } catch (Exception e) {
            e.printStackTrace();
        }
        permissions.addAll(grants);
        permissions.removeAll(denies);
        return denies;
    }

    //xem detail cua mot role cu the co nhung quyen j
    public List<Permission> getPermissionByRoleId(int roleId) throws SQLException {
        List<Permission> list = new ArrayList<>();
        String sql = "select * from permission p join role_permission rp "
                + "on p.id = rp.permission_id "
                + "where rp.role_id = ?";
        try (Connection c = getConnection()) {
            PreparedStatement p = c.prepareStatement(sql);
            p.setInt(1, roleId);
            ResultSet rs = p.executeQuery();
            while (rs.next()) {
                int id = rs.getInt("id");
                String resource = rs.getString("resource");
                String action = rs.getString("action");
                String desc = rs.getString("description");
                list.add(new Permission(id, resource, action, desc));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    // lay danh sach quyen ngoai le cua 1 user
    public List<String[]> getUserOverrides(int userId) throws SQLException {
        List<String[]> list = new ArrayList<>();
        String sql = "select p.resource, p.action, up.type from permission p "
                + "join user_permission up "
                + "on p.id = up.permission_id "
                + "where up.user_id = ?";

        try (Connection c = getConnection()) {
            PreparedStatement p = c.prepareStatement(sql);
            p.setInt(1, userId);
            ResultSet rs = p.executeQuery();
            while (rs.next()) {
                String key = rs.getString("resource") + "." + rs.getString("action");
                String type = rs.getString("type");
                String[] value = new String[]{key, type};
                list.add(value);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    //them moi hoac cap nhat quyen ngoai le cho user
    public boolean setUserOverride(int userId, int perId, String type) throws SQLException {
        String sql = "INSERT INTO user_permission (user_id, permission_id, type) "
                + "VALUES (?, ?, ?) "
                + "ON DUPLICATE KEY UPDATE type = ?";
        try (Connection c = getConnection()) {
            PreparedStatement p = c.prepareStatement(sql);
            p.setInt(1, userId);
            p.setInt(2, perId);
            p.setString(3, type);
            p.setString(4, type);
            return p.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    // xoa bo quyen ngoai le ca nhan luc do user tro lai quyen mac dich RBAC
    public boolean removeUserOverride(int userId, int perId) throws SQLException {
        String sql = "DELETE FROM user_permission WHERE user_id = ? AND permission_id = ?";
        try (Connection c = getConnection()) {
            PreparedStatement p = c.prepareStatement(sql);
            p.setInt(1, userId);
            p.setInt(2, perId);
            return p.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    public void applyUserOverrides(int userId, List<Permission> allPermissions,
                                    Map<Integer, String> overrides) throws SQLException {
        Map<Integer, Permission> permById = new HashMap<>();
        Map<String, Integer> resourceViewPermId = new HashMap<>();
        for (Permission p : allPermissions) {
            permById.put(p.getPermissionId(), p);
            if ("view".equals(p.getAction())) {
                resourceViewPermId.put(p.getResource(), p.getPermissionId());
            }
        }

        for (Map.Entry<Integer, String> e : overrides.entrySet()) {
            int permId = e.getKey();
            String type = e.getValue();

            if ("GRANT".equals(type) || "DENY".equals(type)) {
                setUserOverride(userId, permId, type);
            } else {
                removeUserOverride(userId, permId);
            }

            Permission perm = permById.get(permId);
            if (perm != null && !"view".equals(perm.getAction())) {
                Integer viewPermId = resourceViewPermId.get(perm.getResource());
                if (viewPermId != null && !overrides.containsKey(viewPermId)) {
                    if ("GRANT".equals(type)) {
                        setUserOverride(userId, viewPermId, "GRANT");
                    }
                }
            }
        }
    }

    @Override
    public List<Permission> findAll() {
        List<Permission> list = new ArrayList<>();
        String sql = "select * from permission order by resource, action";
        try (Connection c = getConnection()) {
            PreparedStatement p = c.prepareStatement(sql);
            ResultSet rs = p.executeQuery();
            while (rs.next()) {
                int id = rs.getInt("id");
                String resource = rs.getString("resource");
                String action = rs.getString("action");
                String desc = rs.getString("description");

                list.add(new Permission(id, resource, action, desc));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    @Override
    public boolean update(Permission t) {
        throw new UnsupportedOperationException("Not supported yet."); // Generated from nbfs://nbhost/SystemFileSystem/Templates/Classes/Code/GeneratedMethodBody
    }

    @Override
    public boolean delete(Permission t) {
        throw new UnsupportedOperationException("Not supported yet."); // Generated from nbfs://nbhost/SystemFileSystem/Templates/Classes/Code/GeneratedMethodBody
    }

    @Override
    public int insert(Permission t) {
        throw new UnsupportedOperationException("Not supported yet."); // Generated from nbfs://nbhost/SystemFileSystem/Templates/Classes/Code/GeneratedMethodBody
    }

    @Override
    public Permission getFromResultSet(ResultSet rs) throws SQLException {
        return new Permission(
            rs.getInt("id"),
            rs.getString("resource"),
            rs.getString("action"),
            rs.getString("description")
         );
    }

}