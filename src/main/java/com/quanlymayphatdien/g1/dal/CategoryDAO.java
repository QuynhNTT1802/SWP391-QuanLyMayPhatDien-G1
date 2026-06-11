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
import java.sql.Statement;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 *
 * @author LENOVO
 */
public class CategoryDAO extends DBContext implements I_DAO<Category> {

    public Category findById(int id) {
        String sql = "select * from category where id = ?";
        try (Connection c = getConnection();
             PreparedStatement p = c.prepareStatement(sql)) {
            p.setInt(1, id);
            try (ResultSet rs = p.executeQuery()) {
                if (rs.next()) return getFromResultSet(rs);
            }
        } catch (Exception e) {
            com.quanlymayphatdien.g1.utils.SystemLogger.error("He thong", "Loi Ngoai Le", e.getMessage() != null ? e.getMessage() : e.getClass().getName(), e);
        }
        return null;
    }

    public boolean existsByNameAndTypeAndModule(String name, String type, String module, int excludeId) {
        String sql = "select count(*) from category where name = ? and type = ? and module = ? and id != ?";
        try (Connection c = getConnection();
             PreparedStatement p = c.prepareStatement(sql)) {
            p.setString(1, name);
            p.setString(2, type);
            p.setString(3, module);
            p.setInt(4, excludeId);
            try (ResultSet rs = p.executeQuery()) {
                if (rs.next()) return rs.getInt(1) > 0;
            }
        } catch (Exception e) {
            com.quanlymayphatdien.g1.utils.SystemLogger.error("He thong", "Loi Ngoai Le", e.getMessage() != null ? e.getMessage() : e.getClass().getName(), e);
        }
        return false;
    }

    public List<Category> findByType(String type) {
        List<Category> list = new ArrayList<>();
        String sql = "select * from category where type = ? and status = 'active' order by name";
        try (Connection c = getConnection()) {
            PreparedStatement p = c.prepareStatement(sql);
            p.setString(1, type);
            ResultSet rs = p.executeQuery();
            while (rs.next()) {
                list.add(getFromResultSet(rs));
            }
        } catch (Exception e) {
            com.quanlymayphatdien.g1.utils.SystemLogger.error("He thong", "Loi Ngoai Le", e.getMessage() != null ? e.getMessage() : e.getClass().getName(), e);
        }
        return list;
    }

    public List<String> getDistrictTypes() {
        List<String> types = new ArrayList<>();
        String sql = "select distinct type from category order by type";
        try (Connection c = getConnection()) {
            PreparedStatement p = c.prepareStatement(sql);
            ResultSet rs = p.executeQuery();
            while (rs.next()) {
                types.add(rs.getString("type"));
            }
        } catch (Exception e) {
            com.quanlymayphatdien.g1.utils.SystemLogger.error("He thong", "Loi Ngoai Le", e.getMessage() != null ? e.getMessage() : e.getClass().getName(), e);
        }
        return types;
    }

    public List<Category> searchByTypeAndModule(String type, String module, String keyword) {
        List<Category> list = new ArrayList<>();
        String extTable = getExtensionTable(type);
        String sql;
        if (extTable != null) {
            sql = "SELECT c.* FROM category c LEFT JOIN " + extTable + " e ON c.id = e.category_id "
                + "WHERE c.module = ? AND c.type = ? AND (c.name LIKE ? OR c.description LIKE ? "
                + getExtSearchConditions(type) + ") ORDER BY c.name";
        } else {
            sql = "SELECT * FROM category WHERE module = ? AND type = ? "
                + "AND (name LIKE ? OR description LIKE ?) ORDER BY name";
        }
        try (Connection c = getConnection();
             PreparedStatement p = c.prepareStatement(sql)) {
            String k = "%" + keyword + "%";
            p.setString(1, module);
            p.setString(2, type);
            p.setString(3, k);
            p.setString(4, k);
            int idx = 5;
            if ("brand".equals(type)) {
                p.setString(idx++, k); p.setString(idx++, k);
            } else if ("fuel_type".equals(type)) {
                p.setString(idx++, k);
            }
            ResultSet rs = p.executeQuery();
            while (rs.next()) list.add(getFromResultSet(rs));
        } catch (SQLException e) { com.quanlymayphatdien.g1.utils.SystemLogger.error("He thong", "Loi Ngoai Le", e.getMessage() != null ? e.getMessage() : e.getClass().getName(), e); }
        return list;
    }

    private String getExtSearchConditions(String type) {
        switch (type) {
            case "brand": return "OR e.country LIKE ? OR e.website LIKE ?";
            case "fuel_type": return "OR e.unit LIKE ?";
            default: return "";
        }
    }

    private String getExtensionTable(String type) {
        switch (type) {
            case "brand": return "category_brand";
            case "fuel_type": return "category_fuel_type";
            case "origin": return "category_origin";
            case "customer_type": return "category_customer_type";
            case "generator_type": return "category_generator_type";
            case "phase": return "category_phase";
            case "condition": return "category_condition";
            case "receipt_reason": return "category_receipt_reason";
            default: return null;
        }
    }

    public List<Category> findByModule(String module) {
        List<Category> list = new ArrayList<>();
        String sql = "select * from category where module = ? order by type, name";
        try (Connection c = getConnection();
             PreparedStatement p = c.prepareStatement(sql)) {
            p.setString(1, module);
            ResultSet rs = p.executeQuery();
            while (rs.next()) {
                list.add(getFromResultSet(rs));
            }
        } catch (Exception e) {
            com.quanlymayphatdien.g1.utils.SystemLogger.error("He thong", "Loi Ngoai Le", e.getMessage() != null ? e.getMessage() : e.getClass().getName(), e);
        }
        return list;
    }

    public List<String> getTypesByModule(String module) {
        List<String> types = new ArrayList<>();
        String sql = "select distinct type from category where module = ? order by type";
        try (Connection c = getConnection();
             PreparedStatement p = c.prepareStatement(sql)) {
            p.setString(1, module);
            ResultSet rs = p.executeQuery();
            while (rs.next()) {
                types.add(rs.getString("type"));
            }
        } catch (Exception e) {
            com.quanlymayphatdien.g1.utils.SystemLogger.error("He thong", "Loi Ngoai Le", e.getMessage() != null ? e.getMessage() : e.getClass().getName(), e);
        }
        return types;
    }

    /**
     * Lấy MIN(id) theo từng type trong một module.
     * Dùng để hiển thị cột ID đại diện trong bảng Tổng quan danh mục.
     *
     * @param module tên module, VD "quản lý vật tư"
     * @return Map&lt;type, minId&gt;
     */
    public Map<String, Integer> getMinIdByType(String module) {
        Map<String, Integer> result = new HashMap<>();
        String sql = "SELECT type, MIN(id) AS min_id FROM category WHERE module = ? GROUP BY type";
        try (Connection c = getConnection();
             PreparedStatement p = c.prepareStatement(sql)) {
            p.setString(1, module);
            try (ResultSet rs = p.executeQuery()) {
                while (rs.next()) {
                    result.put(rs.getString("type"), rs.getInt("min_id"));
                }
            }
        } catch (Exception e) {
            com.quanlymayphatdien.g1.utils.SystemLogger.error("He thong", "Loi Ngoai Le", e.getMessage() != null ? e.getMessage() : e.getClass().getName(), e);
        }
        return result;
    }



    public List<Category> searchByName(String name) {
        List<Category> list = new ArrayList<>();
        String sql = "select * from category where name like ? or description like ? order by type, name";
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
            com.quanlymayphatdien.g1.utils.SystemLogger.error("He thong", "Loi Ngoai Le", e.getMessage() != null ? e.getMessage() : e.getClass().getName(), e);
        }
        return list;
    }

    @Override
    public List<Category> findAll() {
        List<Category> list = new ArrayList<>();
        String sql = "select * from category order by type,name ";
        try (Connection c = getConnection()) {
            PreparedStatement p = c.prepareStatement(sql);
            ResultSet rs = p.executeQuery();
            while (rs.next()) {
                list.add((Category) getFromResultSet(rs));
            }
        } catch (Exception e) {
            com.quanlymayphatdien.g1.utils.SystemLogger.error("He thong", "Loi Ngoai Le", e.getMessage() != null ? e.getMessage() : e.getClass().getName(), e);
        }
        return list;
    }

    @Override
    public boolean update(Category category) {
        String sql = "update category set module = ?, name = ?, type = ?, description = ?, status = ?, updated_at = ? where id = ? ";
        try (Connection c = getConnection()) {
            PreparedStatement p = c.prepareStatement(sql);
            p.setString(1, category.getModule());
            p.setString(2, category.getName());
            p.setString(3, category.getType());
            p.setString(4, category.getDescription());
            p.setString(5, category.getStatus());
            p.setObject(6, LocalDateTime.now());
            p.setInt(7, category.getId());
            return p.executeUpdate() > 0;
        } catch (Exception e) {
            com.quanlymayphatdien.g1.utils.SystemLogger.error("He thong", "Loi Ngoai Le", e.getMessage() != null ? e.getMessage() : e.getClass().getName(), e);
        }
        return false;
    }

    @Override
    public boolean delete(Category t) {
        String sql = "update category set status = 'inactive', updated_at = ? where id = ?";
        try (Connection c = getConnection()) {
            PreparedStatement p = c.prepareStatement(sql);
            p.setObject(1, LocalDateTime.now());
            p.setInt(2, t.getId());
            return p.executeUpdate() > 0;
        } catch (Exception e) {
            com.quanlymayphatdien.g1.utils.SystemLogger.error("He thong", "Loi Ngoai Le", e.getMessage() != null ? e.getMessage() : e.getClass().getName(), e);
        }
        return false;
    }

    @Override
    public int insert(Category t) {
        String sql = "insert into category (module, name, type, description, status, created_at, updated_at) values (?, ?, ?, ?, ?, ?, ?)";
        try (Connection c = getConnection()) {
            PreparedStatement p = c.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS);
            p.setString(1, t.getModule());
            p.setString(2, t.getName());
            p.setString(3, t.getType());
            p.setString(4, t.getDescription());
            p.setString(5, t.getStatus() != null ? t.getStatus() : "active");
            LocalDateTime now = LocalDateTime.now();
            p.setObject(6, now);
            p.setObject(7, now);

            if (p.executeUpdate() > 0) {
                try (ResultSet rs = p.getGeneratedKeys()) {
                    if (rs.next()) {
                        return rs.getInt(1);
                    }
                }
            }
        } catch (Exception e) {
            com.quanlymayphatdien.g1.utils.SystemLogger.error("He thong", "Loi Ngoai Le", e.getMessage() != null ? e.getMessage() : e.getClass().getName(), e);
        }
        return -1;
    }

    @Override
    public Category getFromResultSet(ResultSet rs) throws SQLException {
        int id = rs.getInt("id");
        String module = rs.getString("module");
        String name = rs.getString("name");
        String type = rs.getString("type");
        String desc = rs.getString("description");
        String status = rs.getString("status");
        LocalDateTime createdAt = rs.getObject("created_at", LocalDateTime.class);
        LocalDateTime updatedAt = rs.getObject("updated_at", LocalDateTime.class);
        return new Category(id, module, name, type, desc, status, createdAt, updatedAt);
    }
}
