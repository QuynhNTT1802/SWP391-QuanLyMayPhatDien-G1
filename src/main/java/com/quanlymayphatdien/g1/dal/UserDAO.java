/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package com.quanlymayphatdien.g1.dal;

import java.sql.SQLException;

/**
 *
 * @author Aadmin
 */
public class UserDAO extends DBContext{
    public boolean isUsernameExists(String username) {
        String sql = "SELECT COUNT(*) AS total FROM user WHERE username = ?";
        try {
            connection = getConnection();
            statement = connection.prepareStatement(sql);
            statement.setString(1, username);
            resultSet = statement.executeQuery();
            if (resultSet.next()) {
                return resultSet.getInt("total") > 0;
            }
        } catch (SQLException e) {
            System.out.println(e.getMessage());
        }
        return false;
    }
    
    public boolean isEmailExists(String email, Integer userId) {
        String sql = "SELECT COUNT(*) FROM account WHERE email = ?";
        if (userId != null) {
            sql += " AND user_id != ?";
        }
        try {
            connection = getConnection();
            statement = connection.prepareStatement(sql);
            statement.setString(1, email);
            if (userId != null) {
                statement.setInt(2, userId);
            }
            resultSet = statement.executeQuery();
            if (resultSet.next()) {
                return resultSet.getInt(1) > 0;
            }
        } catch (SQLException e) {
            System.out.println("Error checking email existence: " + e.getMessage());
        } 
        return false;
    }
    
    public boolean isPhoneExists(String phone, Integer userId) {
        String sql = "SELECT COUNT(*) FROM account WHERE phone = ?";
        if (userId != null) {
            sql += " AND user_id != ?";
        }
        try {
            connection = getConnection();
            statement = connection.prepareStatement(sql);
            statement.setString(1, phone);
            if (userId != null) {
                statement.setInt(2, userId);
            }
            resultSet = statement.executeQuery();
            if (resultSet.next()) {
                return resultSet.getInt(1) > 0;
            }
        } catch (SQLException e) {
            System.out.println("Error checking phone existence: " + e.getMessage());
        } finally {
            closeResources();
        }
        return false;
    }
}
