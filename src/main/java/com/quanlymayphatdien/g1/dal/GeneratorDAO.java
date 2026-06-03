package com.quanlymayphatdien.g1.dal;

import com.quanlymayphatdien.g1.entity.Category;
import com.quanlymayphatdien.g1.entity.Generator;
import java.math.BigDecimal;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.sql.Timestamp;
import java.sql.Types;
import java.util.ArrayList;
import java.util.List;

public class GeneratorDAO extends DBContext implements I_DAO<Generator> {

    private final CategoryDAO categoryDAO = new CategoryDAO();

    @Override
    public List<Generator> findAll() {
        List<Generator> list = new ArrayList<>();
        String sql = "SELECT * FROM generator ORDER BY created_at DESC";
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

    @Override
    public boolean update(Generator g) {
        String sql = "UPDATE generator SET model=?, power_rating=?, unit_price=?, "
                + "frequency=?, weight=?, description=?, status=?, "
                + "updated_at=?, updated_by=? WHERE id=?";
        try {
            connection = getConnection();
            statement = connection.prepareStatement(sql);
            statement.setString(1, g.getModel());
            statement.setBigDecimal(2, g.getPowerRating());
            statement.setBigDecimal(3, g.getUnitPrice());
            statement.setString(4, g.getFrequency());
            if (g.getWeight() != null) {
                statement.setBigDecimal(5, g.getWeight());
            } else {
                statement.setNull(5, Types.DECIMAL);
            }
            statement.setString(6, g.getDescription());
            statement.setString(7, g.getStatus());
            statement.setTimestamp(8, Timestamp.valueOf(g.getUpdatedAt()));
            if (g.getUpdatedBy() != null) {
                statement.setInt(9, g.getUpdatedBy());
            } else {
                statement.setNull(9, Types.INTEGER);
            }
            statement.setInt(10, g.getId());
            return statement.executeUpdate() > 0;
        } catch (SQLException e) {
            System.out.println(e.getMessage());
        }
        return false;
    }

    @Override
    public boolean delete(Generator g) {
        String sql = "DELETE FROM generator WHERE id = ?";
        try {
            connection = getConnection();
            statement = connection.prepareStatement(sql);
            statement.setInt(1, g.getId());
            return statement.executeUpdate() > 0;
        } catch (SQLException e) {
            System.out.println(e.getMessage());
        }
        return false;
    }

    @Override
    public int insert(Generator g) {
        String sql = "INSERT INTO generator (model, power_rating, unit_price, "
                + "frequency, weight, description, status, created_at, created_by) "
                + "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)";
        try {
            connection = getConnection();
            statement = connection.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS);
            statement.setString(1, g.getModel());
            statement.setBigDecimal(2, g.getPowerRating());
            statement.setBigDecimal(3, g.getUnitPrice());
            statement.setString(4, g.getFrequency());
            if (g.getWeight() != null) {
                statement.setBigDecimal(5, g.getWeight());
            } else {
                statement.setNull(5, Types.DECIMAL);
            }
            statement.setString(6, g.getDescription());
            statement.setString(7, g.getStatus());
            statement.setTimestamp(8, Timestamp.valueOf(g.getCreatedAt()));
            if (g.getCreatedBy() != null) {
                statement.setInt(9, g.getCreatedBy());
            } else {
                statement.setNull(9, Types.INTEGER);
            }
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

    public Generator findById(int id) {
        String sql = "SELECT * FROM generator WHERE id = ?";
        try {
            connection = getConnection();
            statement = connection.prepareStatement(sql);
            statement.setInt(1, id);
            resultSet = statement.executeQuery();
            if (resultSet.next()) {
                Generator g = getFromResultSet(resultSet);
                g.setCategories(getCategoriesByGeneratorId(id));
                return g;
            }
        } catch (SQLException e) {
            System.out.println(e.getMessage());
        }
        return null;
    }

    public boolean activate(int id) {
        String sql = "UPDATE generator SET status = 'active' WHERE id = ?";
        try {
            connection = getConnection();
            statement = connection.prepareStatement(sql);
            statement.setInt(1, id);
            return statement.executeUpdate() > 0;
        } catch (SQLException e) {
            System.out.println(e.getMessage());
        }
        return false;
    }

    public boolean deactivate(int id) {
        String sql = "UPDATE generator SET status = 'locked' WHERE id = ?";
        try {
            connection = getConnection();
            statement = connection.prepareStatement(sql);
            statement.setInt(1, id);
            return statement.executeUpdate() > 0;
        } catch (SQLException e) {
            System.out.println(e.getMessage());
        }
        return false;
    }

    public boolean saveGeneratorCategories(int generatorId, List<Integer> categoryIds) {
        String sql = "INSERT INTO generator_category (generator_id, category_id) VALUES (?, ?)";
        try {
            connection = getConnection();
            statement = connection.prepareStatement(sql);
            for (Integer catId : categoryIds) {
                statement.setInt(1, generatorId);
                statement.setInt(2, catId);
                statement.addBatch();
            }
            statement.executeBatch();
            return true;
        } catch (SQLException e) {
            System.out.println(e.getMessage());
            return false;
        }
    }

    public boolean deleteGeneratorCategories(int generatorId) {
        String sql = "DELETE FROM generator_category WHERE generator_id = ?";
        try {
            connection = getConnection();
            statement = connection.prepareStatement(sql);
            statement.setInt(1, generatorId);
            statement.executeUpdate();
            return true;
        } catch (SQLException e) {
            System.out.println(e.getMessage());
            return false;
        }
    }

    public List<Generator> findGeneratorsByFilters(String search, String status,
            int page, int pageSize) {
        List<Generator> all = new ArrayList<>();
        String sql = "SELECT DISTINCT g.* FROM generator g "
                + "LEFT JOIN generator_category gc ON g.id = gc.generator_id "
                + "LEFT JOIN category c ON gc.category_id = c.id WHERE 1=1 ";
        List<String> params = new ArrayList<>();

        if (status != null && !status.isEmpty()) {
            sql += "AND g.status = ? ";
            params.add(status);
        }
        if (search != null && !search.trim().isEmpty()) {
            sql += "AND (g.model LIKE ? OR c.name LIKE ?) ";
            String p = "%" + search.trim() + "%";
            params.add(p);
            params.add(p);
        }
        sql += "ORDER BY g.created_at DESC";

        try {
            connection = getConnection();
            statement = connection.prepareStatement(sql);
            for (int i = 0; i < params.size(); i++) {
                statement.setString(i + 1, params.get(i));
            }
            resultSet = statement.executeQuery();
            while (resultSet.next()) {
                all.add(getFromResultSet(resultSet));
            }

            if (all.isEmpty()) {
                return all;
            }
            int start = (page - 1) * pageSize;
            int end = Math.min(start + pageSize, all.size());
            if (start > all.size()) {
                return new ArrayList<>();
            }
            List<Generator> pageList = new ArrayList<>(all.subList(start, end));
            for (Generator g : pageList) {
                g.setCategories(getCategoriesByGeneratorId(g.getId()));
            }
            return pageList;
        } catch (SQLException e) {
            System.out.println(e.getMessage());
        }
        return new ArrayList<>();
    }

    public int getTotalFiltered(String search, String status) {
        String sql = "SELECT COUNT(DISTINCT g.id) FROM generator g "
                + "LEFT JOIN generator_category gc ON g.id = gc.generator_id "
                + "LEFT JOIN category c ON gc.category_id = c.id WHERE 1=1 ";
        List<String> params = new ArrayList<>();

        if (status != null && !status.isEmpty()) {
            sql += "AND g.status = ? ";
            params.add(status);
        }
        if (search != null && !search.trim().isEmpty()) {
            sql += "AND (g.model LIKE ? OR c.name LIKE ?) ";
            String p = "%" + search.trim() + "%";
            params.add(p);
            params.add(p);
        }
        try {
            connection = getConnection();
            statement = connection.prepareStatement(sql);
            for (int i = 0; i < params.size(); i++) {
                statement.setString(i + 1, params.get(i));
            }
            resultSet = statement.executeQuery();
            if (resultSet.next()) {
                return resultSet.getInt(1);
            }
        } catch (SQLException e) {
            System.out.println(e.getMessage());
        }
        return 0;
    }

    public int countByStatus(String status) {
        String sql = "SELECT COUNT(*) FROM generator WHERE status = ?";
        try {
            connection = getConnection();
            statement = connection.prepareStatement(sql);
            statement.setString(1, status);
            resultSet = statement.executeQuery();
            if (resultSet.next()) {
                return resultSet.getInt(1);
            }
        } catch (SQLException e) {
            System.out.println(e.getMessage());
        }
        return 0;
    }

    public boolean isModelExists(String model, Integer excludeId) {
        String sql = "SELECT COUNT(*) FROM generator WHERE model = ?";
        if (excludeId != null) {
            sql += " AND id != ?";
        }
        try {
            connection = getConnection();
            statement = connection.prepareStatement(sql);
            statement.setString(1, model.trim());
            if (excludeId != null) {
                statement.setInt(2, excludeId);
            }
            resultSet = statement.executeQuery();
            if (resultSet.next()) {
                return resultSet.getInt(1) > 0;
            }
        } catch (SQLException e) {
            System.out.println(e.getMessage());
        }
        return false;
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
                list.add(categoryDAO.getFromResultSet(resultSet));
            }
        } catch (SQLException e) {
            System.out.println(e.getMessage());
        }
        return list;
    }

    @Override
    public Generator getFromResultSet(ResultSet rs) throws SQLException {
        Generator g = new Generator();
        g.setId(rs.getInt("id"));
        g.setModel(rs.getString("model"));
        g.setPowerRating(rs.getBigDecimal("power_rating"));
        g.setUnitPrice(rs.getBigDecimal("unit_price"));
        g.setFrequency(rs.getString("frequency"));
        BigDecimal w = rs.getBigDecimal("weight");
        if (!rs.wasNull()) {
            g.setWeight(w);
        }
        g.setDescription(rs.getString("description"));
        g.setStatus(rs.getString("status"));

        Timestamp ca = rs.getTimestamp("created_at");
        if (ca != null) {
            g.setCreatedAt(ca.toLocalDateTime());
        }
        Timestamp ua = rs.getTimestamp("updated_at");
        if (ua != null) {
            g.setUpdatedAt(ua.toLocalDateTime());
        }

        int cb = rs.getInt("created_by");
        if (!rs.wasNull()) {
            g.setCreatedBy(cb);
        }
        int ub = rs.getInt("updated_by");
        if (!rs.wasNull()) {
            g.setUpdatedBy(ub);
        }

        return g;
    }
}
