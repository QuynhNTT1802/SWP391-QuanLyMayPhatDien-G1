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

    @Override
    public List<Generator> findAll() {
        List<Generator> list = new ArrayList<>();
        String sql = "SELECT * FROM generator ORDER BY id DESC";
        try (Connection c = getConnection(); PreparedStatement p = c.prepareStatement(sql); ResultSet rs = p.executeQuery()) {
            while (rs.next()) {
                list.add(getFromResultSet(rs));
            }
        } catch (SQLException e) {
            System.out.println(e.getMessage());
        }
        return list;
    }

    @Override
    public boolean update(Generator g) {
        String sql = "UPDATE generator SET model=?, power_rating=?, "
                + "unit_price=?, stock_quantity=?, description=?, status=?, "
                + "frequency=?, weight=?, updated_at=?, updated_by=? WHERE id=?";
        try (Connection c = getConnection(); PreparedStatement p = c.prepareStatement(sql)) {
            p.setString(1, g.getModel());
            p.setBigDecimal(2, g.getPowerRating());
            p.setBigDecimal(3, g.getUnitPrice());
            p.setInt(4, g.getStockQuantity());
            p.setString(5, g.getDescription());
            p.setString(6, g.getStatus());
            p.setString(7, g.getFrequency());
            if (g.getWeight() != null) {
                p.setBigDecimal(8, g.getWeight());
            } else {
                p.setNull(8, Types.DECIMAL);
            }
            p.setTimestamp(9, g.getUpdatedAt() != null ? Timestamp.valueOf(g.getUpdatedAt()) : null);
            if (g.getUpdatedBy() != null) {
                p.setInt(10, g.getUpdatedBy());
            } else {
                p.setNull(10, Types.INTEGER);
            }
            p.setInt(11, g.getId());
            return p.executeUpdate() > 0;
        } catch (SQLException e) {
            System.out.println(e.getMessage());
        }
        return false;
    }

    @Override
    public boolean delete(Generator g) {
        String sql = "DELETE FROM generator WHERE id = ?";
        try (Connection c = getConnection(); PreparedStatement p = c.prepareStatement(sql)) {
            p.setInt(1, g.getId());
            return p.executeUpdate() > 0;
        } catch (SQLException e) {
            System.out.println(e.getMessage());
        }
        return false;
    }

    @Override
    public int insert(Generator g) {
        String sql = "INSERT INTO generator (model, power_rating, unit_price, "
                + "stock_quantity, description, status, frequency, weight, created_at, created_by) "
                + "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
        try (Connection c = getConnection(); PreparedStatement p = c.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            p.setString(1, g.getModel());
            p.setBigDecimal(2, g.getPowerRating());
            p.setBigDecimal(3, g.getUnitPrice());
            p.setInt(4, g.getStockQuantity());
            p.setString(5, g.getDescription());
            p.setString(6, g.getStatus());
            p.setString(7, g.getFrequency());
            if (g.getWeight() != null) {
                p.setBigDecimal(8, g.getWeight());
            } else {
                p.setNull(8, Types.DECIMAL);
            }
            p.setTimestamp(9, g.getCreatedAt() != null ? Timestamp.valueOf(g.getCreatedAt()) : null);
            if (g.getCreatedBy() != null) {
                p.setInt(10, g.getCreatedBy());
            } else {
                p.setNull(10, Types.INTEGER);
            }
            p.executeUpdate();
            try (ResultSet rs = p.getGeneratedKeys()) {
                if (rs.next()) {
                    return rs.getInt(1);
                }
            }
        } catch (SQLException e) {
            System.out.println(e.getMessage());
        }
        return 0;
    }

    public Generator findById(int id) {
        String sql = "SELECT * FROM generator WHERE id = ?";
        try (Connection c = getConnection(); PreparedStatement p = c.prepareStatement(sql)) {
            p.setInt(1, id);
            try (ResultSet rs = p.executeQuery()) {
                if (rs.next()) {
                    return getFromResultSet(rs);
                }
            }
        } catch (SQLException e) {
            System.out.println(e.getMessage());
        }
        return null;
    }

    public boolean activate(int id) {
        String sql = "UPDATE generator SET status = 'active' WHERE id = ?";
        try (Connection c = getConnection(); PreparedStatement p = c.prepareStatement(sql)) {
            p.setInt(1, id);
            return p.executeUpdate() > 0;
        } catch (SQLException e) {
            System.out.println(e.getMessage());
        }
        return false;
    }

    public boolean deactivate(int id) {
        String sql = "UPDATE generator SET status = 'locked' WHERE id = ?";
        try (Connection c = getConnection(); PreparedStatement p = c.prepareStatement(sql)) {
            p.setInt(1, id);
            return p.executeUpdate() > 0;
        } catch (SQLException e) {
            System.out.println(e.getMessage());
        }
        return false;
    }

    public List<Generator> findByCategoryId(int categoryId) {
        List<Generator> list = new ArrayList<>();
        String sql = "SELECT DISTINCT g.* FROM generator g "
                + "JOIN generator_category gc ON g.id = gc.generator_id "
                + "WHERE gc.category_id = ? AND g.status = 'available'";
        try (Connection c = getConnection(); PreparedStatement p = c.prepareStatement(sql)) {
            p.setInt(1, categoryId);
            try (ResultSet rs = p.executeQuery()) {
                while (rs.next()) {
                    Generator g = getFromResultSet(rs);
                    list.add(g);
                }
            }
            attachCategories(list);
        } catch (SQLException e) {
            System.out.println(e.getMessage());
        }
        return list;
    }

    public List<Generator> findByFilters(String search, String status,
            int page, int pageSize) {
        List<Generator> all = new ArrayList<>();
        String sql = "SELECT * FROM generator WHERE 1=1 ";
        List<Object> params = new ArrayList<>();

        if (status != null && !status.isEmpty()) {
            sql += "AND status = ? ";
            params.add(status);
        }
        if (search != null && !search.trim().isEmpty()) {
            sql += "AND model LIKE ? ";
            params.add("%" + search.trim() + "%");
        }
        sql += "ORDER BY created_at DESC";

        try (Connection c = getConnection(); PreparedStatement p = c.prepareStatement(sql)) {
            for (int i = 0; i < params.size(); i++) {
                p.setObject(i + 1, params.get(i));
            }
            try (ResultSet rs = p.executeQuery()) {
                while (rs.next()) {
                    all.add(getFromResultSet(rs));
                }
            }

            if (all.isEmpty()) {
                return all;
            }

            int start = (page - 1) * pageSize;
            int end = Math.min(start + pageSize, all.size());
            if (start > all.size()) {
                return new ArrayList<>();
            }
            return all.subList(start, end);
        } catch (SQLException e) {
            System.out.println(e.getMessage());
        }
        return new ArrayList<>();
    }

    public int getTotalFiltered(String search, String status) {
        String sql = "SELECT COUNT(*) FROM generator WHERE 1=1 ";
        List<Object> params = new ArrayList<>();

        if (status != null && !status.isEmpty()) {
            sql += "AND status = ? ";
            params.add(status);
        }
        if (search != null && !search.trim().isEmpty()) {
            sql += "AND model LIKE ? ";
            params.add("%" + search.trim() + "%");
        }
        try (Connection c = getConnection(); PreparedStatement p = c.prepareStatement(sql)) {
            for (int i = 0; i < params.size(); i++) {
                p.setObject(i + 1, params.get(i));
            }
            try (ResultSet rs = p.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1);
                }
            }
        } catch (SQLException e) {
            System.out.println(e.getMessage());
        }
        return 0;
    }

    public int countByStatus(String status) {
        String sql = "SELECT COUNT(*) FROM generator WHERE status = ?";
        try (Connection c = getConnection(); PreparedStatement p = c.prepareStatement(sql)) {
            p.setString(1, status);
            try (ResultSet rs = p.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1);
                }
            }
        } catch (SQLException e) {
            System.out.println(e.getMessage());
        }
        return 0;
    }

    public List<Category> getCategories(int generatorId) {
        List<Category> list = new ArrayList<>();
        String sql = "SELECT c.* FROM category c "
                + "JOIN generator_category gc ON c.id = gc.category_id "
                + "WHERE gc.generator_id = ? ORDER BY c.type, c.name";
        try (Connection c = getConnection(); PreparedStatement p = c.prepareStatement(sql)) {
            p.setInt(1, generatorId);
            try (ResultSet rs = p.executeQuery()) {
                while (rs.next()) {
                    Category cat = new Category();
                    cat.setId(rs.getInt("id"));
                    cat.setName(rs.getString("name"));
                    cat.setType(rs.getString("type"));
                    cat.setDescription(rs.getString("description"));
                    list.add(cat);
                }
            }
        } catch (SQLException e) {
            System.out.println(e.getMessage());
        }
        return list;
    }

    public void attachCategories(Generator g) {
        if (g != null) {
            g.setCategories(getCategories(g.getId()));
        }
    }

    public void attachCategories(List<Generator> generators) {
        for (Generator g : generators) {
            attachCategories(g);
        }
    }

    @Override
    public Generator getFromResultSet(ResultSet rs) throws SQLException {
        Generator g = new Generator();
        g.setId(rs.getInt("id"));
        g.setModel(rs.getString("model"));
        g.setPowerRating(rs.getBigDecimal("power_rating"));
        g.setUnitPrice(rs.getBigDecimal("unit_price"));
        g.setStockQuantity(rs.getInt("stock_quantity"));
        g.setDescription(rs.getString("description"));
        g.setStatus(rs.getString("status"));
        g.setFrequency(rs.getString("frequency"));
        BigDecimal w = rs.getBigDecimal("weight");
        if (!rs.wasNull()) {
            g.setWeight(w);
        }

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
