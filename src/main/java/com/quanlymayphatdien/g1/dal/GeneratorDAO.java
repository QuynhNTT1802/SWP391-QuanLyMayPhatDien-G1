package com.quanlymayphatdien.g1.dal;

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

    @Override
    public List<Generator> findAll() {
        List<Generator> list = new ArrayList<>();
        String sql = "SELECT * FROM generator";
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
        String sql = "UPDATE generator SET model=?, brand=?, power_rating=?, "
                + "unit_price=?, stock_quantity=?, description=?, status=?, "
                + "updated_at=?, updated_by=? WHERE id=?";
        try {
            connection = getConnection();
            statement = connection.prepareStatement(sql);
            statement.setString(1, g.getModel());
            statement.setString(2, g.getBrand());
            statement.setBigDecimal(3, g.getPowerRating());
            statement.setBigDecimal(4, g.getUnitPrice());
            statement.setInt(5, g.getStockQuantity());
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
        String sql = "INSERT INTO generator (model, brand, power_rating, unit_price, "
                + "stock_quantity, description, status, created_at, created_by) "
                + "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)";
        try {
            connection = getConnection();
            statement = connection.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS);
            statement.setString(1, g.getModel());
            statement.setString(2, g.getBrand());
            statement.setBigDecimal(3, g.getPowerRating());
            statement.setBigDecimal(4, g.getUnitPrice());
            statement.setInt(5, g.getStockQuantity());
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
                return getFromResultSet(resultSet);
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

    public List<Generator> findGeneratorsByFilters(String search, String status, int page, int pageSize) {
        List<Generator> allGenerators = new ArrayList<>();
        String sql = "SELECT * FROM generator WHERE 1=1 ";
        List<String> params = new ArrayList<>();

        if (status != null && !status.isEmpty()) {
            sql += "AND status = ? ";
            params.add(status);
        }
        if (search != null && !search.trim().isEmpty()) {
            sql += "AND (model LIKE ? OR brand LIKE ?) ";
            String p = "%" + search.trim() + "%";
            params.add(p);
            params.add(p);
        }
        sql += "ORDER BY created_at DESC";

        try {
            connection = getConnection();
            statement = connection.prepareStatement(sql);
            for (int i = 0; i < params.size(); i++) {
                statement.setString(i + 1, params.get(i));
            }
            resultSet = statement.executeQuery();
            while (resultSet.next()) {
                allGenerators.add(getFromResultSet(resultSet));
            }

            if (allGenerators.isEmpty()) {
                return allGenerators;
            }
            int start = (page - 1) * pageSize;
            int end = Math.min(start + pageSize, allGenerators.size());
            if (start > allGenerators.size()) {
                return new ArrayList<>();
            }
            return allGenerators.subList(start, end);
        } catch (SQLException e) {
            System.out.println(e.getMessage());
        }
        return new ArrayList<>();
    }

    public int getTotalFiltered(String search, String status) {
        String sql = "SELECT COUNT(*) FROM generator";
        List<String> inputs = new ArrayList<>();
        boolean hasCondition = false;

        if (status != null && !status.isEmpty()) {
            sql += " WHERE status = ?";
            inputs.add(status);
            hasCondition = true;
        }

        if (search != null && !search.trim().isEmpty()) {
            if (hasCondition) {
                sql += " AND (model LIKE ? OR brand LIKE ?)";
            } else {
                sql += " WHERE (model LIKE ? OR brand LIKE ?)";
            }
            String searchPattern = "%" + search.trim() + "%";
            inputs.add(searchPattern);
            inputs.add(searchPattern);
        }

        try {
            connection = getConnection();
            statement = connection.prepareStatement(sql);
            for (int i = 0; i < inputs.size(); i++) {
                statement.setString(i + 1, inputs.get(i));
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

    @Override
    public Generator getFromResultSet(ResultSet rs) throws SQLException {
        Generator g = new Generator();
        g.setId(rs.getInt("id"));
        g.setModel(rs.getString("model"));
        g.setBrand(rs.getString("brand"));
        g.setPowerRating(rs.getBigDecimal("power_rating"));
        g.setUnitPrice(rs.getBigDecimal("unit_price"));
        g.setStockQuantity(rs.getInt("stock_quantity"));
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

    public boolean isModelExists(String model, Integer id) {
        String sql = "SELECT COUNT(*) FROM generator WHERE model = ?";
        if (id != null) {
            sql += " AND id != ?";
        }
        try {
            connection = getConnection();
            statement = connection.prepareStatement(sql);
            statement.setString(1, model.trim());
            if (id != null) {
                statement.setInt(2, id);
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
}
