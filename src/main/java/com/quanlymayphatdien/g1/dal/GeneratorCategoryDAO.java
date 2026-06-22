package com.quanlymayphatdien.g1.dal;

import com.quanlymayphatdien.g1.entity.Category;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class GeneratorCategoryDAO extends DBContext {

    public void saveCategories(int generatorId, String[] categoryIds) {
        deleteByGenerator(generatorId);
        if (categoryIds == null || categoryIds.length == 0) return;

        String sql = "INSERT INTO generator_category (generator_id, category_id) VALUES (?, ?)";
        try (Connection c = getConnection();
             PreparedStatement p = c.prepareStatement(sql)) {
            for (String idStr : categoryIds) {
                try {
                    int catId = Integer.parseInt(idStr);
                    p.setInt(1, generatorId);
                    p.setInt(2, catId);
                    p.addBatch();
                } catch (NumberFormatException ignored) {
                }
            }
            p.executeBatch();
        } catch (SQLException e) {
            System.out.println(e.getMessage());
        }
    }

    public void deleteByGenerator(int generatorId) {
        String sql = "DELETE FROM generator_category WHERE generator_id = ?";
        try {
            connection = getConnection();
            statement = connection.prepareStatement(sql);
            statement.setInt(1, generatorId);
            statement.executeUpdate();
        } catch (SQLException e) {
            System.out.println(e.getMessage());
        } finally {
            closeResources();
        }
    }

    public List<Category> findByGenerator(int generatorId) {
        List<Category> list = new ArrayList<>();
        String sql = "SELECT c.* FROM category c "
                + "JOIN generator_category gc ON c.id = gc.category_id "
                + "WHERE gc.generator_id = ? ORDER BY c.type, c.name";
        try {
            connection = getConnection();
            statement = connection.prepareStatement(sql);
            statement.setInt(1, generatorId);
            resultSet = statement.executeQuery();
            while (resultSet.next()) {
                Category cat = new Category();
                cat.setId(resultSet.getInt("id"));
                cat.setName(resultSet.getString("name"));
                cat.setType(resultSet.getString("type"));
                cat.setDescription(resultSet.getString("description"));
                list.add(cat);
            }
        } catch (SQLException e) {
            System.out.println(e.getMessage());
        } finally {
            closeResources();
        }
        return list;
    }
}