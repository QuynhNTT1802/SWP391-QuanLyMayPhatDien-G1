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
        Category result = null;
        String sql = "select * from category where id = ?";
        try {
            connection = getConnection();
            statement = connection.prepareStatement(sql);
            statement.setInt(1, id);
            resultSet = statement.executeQuery();
            if (resultSet.next()) result = getFromResultSet(resultSet);
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            closeResources();
        }
        return result;
    }

    public Category findByNameAndType(String name, String type) {
        Category result = null;
        String sql = "select * from category where name = ? and type = ? and status = 'active' limit 1";
        try {
            connection = getConnection();
            statement = connection.prepareStatement(sql);
            statement.setString(1, name);
            statement.setString(2, type);
            resultSet = statement.executeQuery();
            if (resultSet.next()) result = getFromResultSet(resultSet);
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            closeResources();
        }
        return result;
    }

    public boolean existsByNameAndTypeAndModule(String name, String type, String module, int excludeId) {
        boolean result = false;
        String sql = "select count(*) from category where name = ? and type = ? and module = ? and id != ?";
        try {
            connection = getConnection();
            statement = connection.prepareStatement(sql);
            statement.setString(1, name);
            statement.setString(2, type);
            statement.setString(3, module);
            statement.setInt(4, excludeId);
            resultSet = statement.executeQuery();
            if (resultSet.next()) result = resultSet.getInt(1) > 0;
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            closeResources();
        }
        return result;
    }

    public List<Category> findByType(String type) {
        List<Category> list = new ArrayList<>();
        String sql = "select * from category where type = ? and status = 'active' order by name";
        try {
            connection = getConnection();
            statement = connection.prepareStatement(sql);
            statement.setString(1, type);
            resultSet = statement.executeQuery();
            while (resultSet.next()) {
                list.add(getFromResultSet(resultSet));
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            closeResources();
        }
        return list;
    }

    public List<String> getDistrictTypes() {
        List<String> types = new ArrayList<>();
        String sql = "select distinct type from category order by type";
        try {
            connection = getConnection();
            statement = connection.prepareStatement(sql);
            resultSet = statement.executeQuery();
            while (resultSet.next()) {
                types.add(resultSet.getString("type"));
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            closeResources();
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
        try {
            connection = getConnection();
            statement = connection.prepareStatement(sql);
            String k = "%" + keyword + "%";
            statement.setString(1, module);
            statement.setString(2, type);
            statement.setString(3, k);
            statement.setString(4, k);
            int idx = 5;
            if ("brand".equals(type)) {
                statement.setString(idx++, k); statement.setString(idx++, k);
            } else if ("fuel_type".equals(type)) {
                statement.setString(idx++, k);
            }
            resultSet = statement.executeQuery();
            while (resultSet.next()) list.add(getFromResultSet(resultSet));
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            closeResources();
        }
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
        try {
            connection = getConnection();
            statement = connection.prepareStatement(sql);
            statement.setString(1, module);
            resultSet = statement.executeQuery();
            while (resultSet.next()) {
                list.add(getFromResultSet(resultSet));
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            closeResources();
        }
        return list;
    }

    public List<String> getTypesByModule(String module) {
        List<String> types = new ArrayList<>();
        String sql = "select distinct type from category where module = ? order by type";
        try {
            connection = getConnection();
            statement = connection.prepareStatement(sql);
            statement.setString(1, module);
            resultSet = statement.executeQuery();
            while (resultSet.next()) {
                types.add(resultSet.getString("type"));
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            closeResources();
        }
        return types;
    }

    public Map<String, Integer> getMinIdByType(String module) {
        Map<String, Integer> result = new HashMap<>();
        String sql = "SELECT type, MIN(id) AS min_id FROM category WHERE module = ? GROUP BY type";
        try {
            connection = getConnection();
            statement = connection.prepareStatement(sql);
            statement.setString(1, module);
            resultSet = statement.executeQuery();
            while (resultSet.next()) {
                result.put(resultSet.getString("type"), resultSet.getInt("min_id"));
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            closeResources();
        }
        return result;
    }



    public List<Category> searchByName(String name) {
        List<Category> list = new ArrayList<>();
        String sql = "select * from category where name like ? or description like ? order by type, name";
        try {
            connection = getConnection();
            statement = connection.prepareStatement(sql);
            String keyword = "%" + name + "%";
            statement.setString(1, keyword);
            statement.setString(2, keyword);
            resultSet = statement.executeQuery();
            while (resultSet.next()) {
                list.add(getFromResultSet(resultSet));
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            closeResources();
        }
        return list;
    }

    @Override
    public List<Category> findAll() {
        List<Category> list = new ArrayList<>();
        String sql = "select * from category order by type,name ";
        try {
            connection = getConnection();
            statement = connection.prepareStatement(sql);
            resultSet = statement.executeQuery();
            while (resultSet.next()) {
                list.add((Category) getFromResultSet(resultSet));
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            closeResources();
        }
        return list;
    }

    @Override
    public boolean update(Category category) {
        String sql = "update category set module = ?, name = ?, type = ?, description = ?, status = ?, updated_at = ? where id = ? ";
        try {
            connection = getConnection();
            statement = connection.prepareStatement(sql);
            statement.setString(1, category.getModule());
            statement.setString(2, category.getName());
            statement.setString(3, category.getType());
            statement.setString(4, category.getDescription());
            statement.setString(5, category.getStatus());
            statement.setObject(6, LocalDateTime.now());
            statement.setInt(7, category.getId());
            return statement.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            closeResources();
        }
        return false;
    }

    @Override
    public boolean delete(Category t) {
        String sql = "update category set status = 'inactive', updated_at = ? where id = ?";
        try {
            connection = getConnection();
            statement = connection.prepareStatement(sql);
            statement.setObject(1, LocalDateTime.now());
            statement.setInt(2, t.getId());
            return statement.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            closeResources();
        }
        return false;
    }

    @Override
    public int insert(Category t) {
        int result = -1;
        String sql = "insert into category (module, name, type, description, status, created_at, updated_at) values (?, ?, ?, ?, ?, ?, ?)";
        try {
            connection = getConnection();
            statement = connection.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS);
            statement.setString(1, t.getModule());
            statement.setString(2, t.getName());
            statement.setString(3, t.getType());
            statement.setString(4, t.getDescription());
            statement.setString(5, t.getStatus() != null ? t.getStatus() : "active");
            LocalDateTime now = LocalDateTime.now();
            statement.setObject(6, now);
            statement.setObject(7, now);

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