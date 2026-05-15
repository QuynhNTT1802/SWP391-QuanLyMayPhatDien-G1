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
import java.util.HashSet;
import java.util.List;
import java.util.Set;

/**
 *
 * @author LENOVO
 */
public class PermissionDAO extends DBContext{
    
    public List<Permission> getAllPermission() {
        List<Permission> list = new ArrayList<>();
        return null;
    }
    
    // quyen ngoai le overide uu tien cao nhat
    private void applyOverrides(int userId, Set<String> permissions) throws SQLException {
        Set<String> grants = new HashSet<>();
        Set<String> denies = new HashSet<>();
        
        String sql = "select * from permissions p join user_permissions up"
                   + "on p.id = up.permission_id"
                   + "where up.user_id = ?";
        try (Connection c = getConnection()){
            PreparedStatement p = c.prepareStatement(sql);
            p.setInt(1, userId);
            ResultSet rs = p.executeQuery();
            while(rs.next()) {
                String key = rs.getString("resource") + "." + rs.getString("action");
                String type = rs.getString("type");
                
                if("GRANT".equals(type)) {
                    grants.add(key);
                } else {
                    denies.add(key);
                }
            }
            
        } catch (Exception e) {
            e.printStackTrace();
        }
        permissions.addAll(grants);
        permissions.remove(denies);
    }
    
    
    
    
}
