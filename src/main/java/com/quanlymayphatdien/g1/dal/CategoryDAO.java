package com.quanlymayphatdien.g1.dal;

import com.quanlymayphatdien.g1.entity.Category;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.List;

public class CategoryDAO extends DBContext implements I_DAO<Category> {

    @Override
    public List<Category> findAll() {
        List<Category> list = new ArrayList<>();
        String sql = "SELECT * FROM category ORDER BY type, name";
        try {
            connection = getConnection();
            statement = connection.prepareStatement(sql);
            resultSet = statement.executeQuery();
            while (resultSet.next()) {
                list.add(getFromResultSet(resultSet));
            }
        } catch (SQLException e) {
            System.out.println(e.getMessage());
        }
        return list;
    }

    public List<Category> findByModule(String module) {
        List<Category> list = new ArrayList<>();
        String sql = "SELECT * FROM category WHERE module = ? ORDER BY type, name";
        try {
            connection = getConnection();
            statement = connection.prepareStatement(sql);
            statement.setString(1, module);
            resultSet = statement.executeQuery();
            while (resultSet.next()) {
                list.add(getFromResultSet(resultSet));
            }
        } catch (SQLException e) {
            System.out.println(e.getMessage());
        }
        return list;
    }

    public List<Category> findByType(String type) {
        List<Category> list = new ArrayList<>();
        String sql = "SELECT * FROM category WHERE type = ? AND status = 'active' ORDER BY name";
        try {
            connection = getConnection();
            statement = connection.prepareStatement(sql);
            statement.setString(1, type);
            resultSet = statement.executeQuery();
            while (resultSet.next()) {
                list.add(getFromResultSet(resultSet));
            }
        } catch (SQLException e) {
            System.out.println(e.getMessage());
        }
        return list;
    }

    public Category findById(int id) {
        String sql = "SELECT * FROM category WHERE id = ?";
        try {
            connection = getConnection();
            statement = connection.prepareStatement(sql);
            statement.setInt(1, id);
            resultSet = statement.executeQuery();
            if (resultSet.next()) {
                return getFromResultSet(resultSet);
            }
        } catch (SQLException e) {
            System.out.println(e.getMessage());
        }
        return null;
    }

    public List<Category> getCategoriesByGeneratorId(int generatorId) {
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
                list.add(getFromResultSet(resultSet));
            }
        } catch (SQLException e) {
            System.out.println(e.getMessage());
        }
        return list;
    }

    @Override
    public int insert(Category c) {
        String sql = "INSERT INTO category (module, name, type, description, status, created_at) "
                + "VALUES (?, ?, ?, ?, ?, ?)";
        try {
            connection = getConnection();
            statement = connection.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS);
            statement.setString(1, c.getModule());
            statement.setString(2, c.getName());
            statement.setString(3, c.getType());
            statement.setString(4, c.getDescription());
            statement.setString(5, c.getStatus());
            statement.setTimestamp(6, Timestamp.valueOf(c.getCreatedAt()));

            int affectedRows = statement.executeUpdate();
            if (affectedRows > 0) {
                resultSet = statement.getGeneratedKeys();
                if (resultSet.next()) {
                    return resultSet.getInt(1);
                }
            }
        } catch (SQLException e) {
            System.out.println(e.getMessage());
        } finally {
            closeResources();
        }
        return 0;
    }

    @Override
    public boolean update(Category c) {
        String sql = "UPDATE category SET module=?, name=?, type=?, description=?, "
                + "status=?, updated_at=? WHERE id=?";
        try {
            connection = getConnection();
            statement = connection.prepareStatement(sql);
            statement.setString(1, c.getModule());
            statement.setString(2, c.getName());
            statement.setString(3, c.getType());
            statement.setString(4, c.getDescription());
            statement.setString(5, c.getStatus());
            statement.setTimestamp(6, Timestamp.valueOf(c.getUpdatedAt()));
            statement.setInt(7, c.getId());
            return statement.executeUpdate() > 0;
        } catch (SQLException e) {
            System.out.println(e.getMessage());
        }
        return false;
    }

    @Override
    public boolean delete(Category c) {
        String sql = "DELETE FROM category WHERE id = ?";
        try {
            connection = getConnection();
            statement = connection.prepareStatement(sql);
            statement.setInt(1, c.getId());
            return statement.executeUpdate() > 0;
        } catch (SQLException e) {
            System.out.println(e.getMessage());
        }
        return false;
    }

    @Override
    public Category getFromResultSet(ResultSet rs) throws SQLException {
        Category c = new Category();
        c.setId(rs.getInt("id"));
        c.setModule(rs.getString("module"));
        c.setName(rs.getString("name"));
        c.setType(rs.getString("type"));
        c.setDescription(rs.getString("description"));
        c.setStatus(rs.getString("status"));

        Timestamp ca = rs.getTimestamp("created_at");
        if (ca != null) {
            c.setCreatedAt(ca.toLocalDateTime());
        }
        Timestamp ua = rs.getTimestamp("updated_at");
        if (ua != null) {
            c.setUpdatedAt(ua.toLocalDateTime());
        }
        return c;
    }
}