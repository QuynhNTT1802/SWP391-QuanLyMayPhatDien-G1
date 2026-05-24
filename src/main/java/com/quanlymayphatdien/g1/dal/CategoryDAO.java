/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package com.quanlymayphatdien.g1.dal;

import com.quanlymayphatdien.g1.entity.Category;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;

/**
 *
 * @author LENOVO
 */
public class CategoryDAO extends DBContext implements I_DAO<Category> {

    public List<Category> findByType(String type) {
        List<Category> list = new ArrayList<>();
        String sql = "select * from categories where type = ? and status = 'active' order by name";
        try (Connection c = getConnection()) {
            PreparedStatement p = c.prepareStatement(sql);
            p.setString(1, type);
            ResultSet rs = p.executeQuery();
            while (rs.next()) {
                list.add(getFromResultSet(rs));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    public List<String> getDistrictTypes() {
        List<String> types = new ArrayList<>();
        String sql = "select district type from categories order by type";
        try (Connection c = getConnection()) {
            PreparedStatement p = c.prepareStatement(sql);
            ResultSet rs = p.executeQuery();
            while (rs.next()) {
                types.add(rs.getString("type"));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return types;
    }

    public List<Category> searchByName(String name) {
        List<Category> list = new ArrayList<>();
        String sql = "select * from categories where name like ? or description like ? order by type, name";
        try (Connection c = getConnection()) {
            PreparedStatement p = c.prepareStatement(sql);
            String keyword = "%" + name + "%";
            p.setString(1, keyword);
            p.setString(2, keyword);
            ResultSet rs = p.executeQuery();
            while (rs.next()) {
                list.add(getFromResultSet(rs));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    @Override
    public List findAll() {
        List<Category> list = new ArrayList<>();
        String sql = "select * from categories order by type,name ";
        try (Connection c = getConnection()) {
            PreparedStatement p = c.prepareStatement(sql);
            ResultSet rs = p.executeQuery();
            while (rs.next()) {
                list.add((Category) getFromResultSet(rs));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    @Override
    public boolean update(Category category) {
        String sql = "update categories set name = ?, type = ?, description = ?, status = ?, updated_at = ? where id = ? ";
        try (Connection c = getConnection()) {
            PreparedStatement p = c.prepareStatement(sql);
            p.setString(1, category.getName());
            p.setString(2, category.getType());
            p.setString(3, category.getDescription());
            p.setString(4, category.getStatus());
            p.setObject(5, LocalDateTime.now());
            p.setInt(6, category.getId());
            return p.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    @Override
    public boolean delete(Category t) {
        String sql = "update categories set status = 'inactive', update_at = ? where id = ?";
        try (Connection c = getConnection()) {
            PreparedStatement p = c.prepareStatement(sql);
            p.setObject(1, LocalDateTime.now());
            p.setInt(2, t.getId());
            return p.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    @Override
    public int insert(Category t) {
        String sql = "insert into categories (name, type, description, status, created_at, updated_at) values (?, ?, ?, ?, ?, ?)";
        try (Connection c = getConnection()) {
            PreparedStatement p = c.prepareStatement(sql);
            p.setString(1, t.getName());
            p.setString(2, t.getType());
            p.setString(3, t.getDescription());
            p.setString(4, t.getStatus() != null ? t.getStatus() : "active");
            LocalDateTime now = LocalDateTime.now();
            p.setObject(5, now);
            p.setObject(6, now);

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
    public Category getFromResultSet(ResultSet rs) throws SQLException {
        int id = rs.getInt("id");
        String name = rs.getString("name");
        String type = rs.getString("type");
        String desc = rs.getString("description");
        String status = rs.getString("status");
        LocalDateTime createdAt = rs.getObject("created_at", LocalDateTime.class);
        LocalDateTime updatedAt = rs.getObject("updated_at", LocalDateTime.class);
        return new Category(id, name, type, desc, status, createdAt, updatedAt);
    }

}
