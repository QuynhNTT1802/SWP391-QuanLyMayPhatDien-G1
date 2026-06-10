package com.quanlymayphatdien.g1.dal;

import com.quanlymayphatdien.g1.entity.InventoryCheck;
import com.quanlymayphatdien.g1.entity.InventoryCheckDetail;
import java.sql.*;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;

public class InventoryCheckDAO extends DBContext implements I_DAO<InventoryCheck> {

    public List<InventoryCheck> findWithFilters(String search, Integer warehouseId,
            String status, int page, int pageSize) {
        List<InventoryCheck> list = new ArrayList<>();
        StringBuilder sql = new StringBuilder(
            "SELECT ic.*, w.name AS warehouse_name, u.name AS created_by_name "
            + "FROM inventory_check ic "
            + "JOIN warehouse w ON ic.warehouse_id = w.warehouse_id "
            + "JOIN user u ON ic.created_by = u.id "
            + "WHERE 1=1 ");
        List<Object> params = new ArrayList<>();

        if (search != null && !search.trim().isEmpty()) {
            sql.append("AND ic.check_code LIKE ? ");
            params.add("%" + search.trim() + "%");
        }
        if (warehouseId != null) {
            sql.append("AND ic.warehouse_id = ? ");
            params.add(warehouseId);
        }
        if (status != null && !status.trim().isEmpty()) {
            sql.append("AND ic.status = ? ");
            params.add(status);
        }
        sql.append("ORDER BY ic.created_at DESC LIMIT ? OFFSET ?");
        params.add(pageSize);
        params.add((page - 1) * pageSize);

        try (Connection c = getConnection(); PreparedStatement ps = c.prepareStatement(sql.toString())) {
            for (int i = 0; i < params.size(); i++) {
                ps.setObject(i + 1, params.get(i));
            }
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    list.add(getFromResultSet(rs));
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    public int countWithFilters(String search, Integer warehouseId, String status) {
        StringBuilder sql = new StringBuilder("SELECT COUNT(*) FROM inventory_check ic WHERE 1=1 ");
        List<Object> params = new ArrayList<>();

        if (search != null && !search.trim().isEmpty()) {
            sql.append("AND ic.check_code LIKE ? ");
            params.add("%" + search.trim() + "%");
        }
        if (warehouseId != null) {
            sql.append("AND ic.warehouse_id = ? ");
            params.add(warehouseId);
        }
        if (status != null && !status.trim().isEmpty()) {
            sql.append("AND ic.status = ? ");
            params.add(status);
        }

        try (Connection c = getConnection(); PreparedStatement ps = c.prepareStatement(sql.toString())) {
            for (int i = 0; i < params.size(); i++) {
                ps.setObject(i + 1, params.get(i));
            }
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }

    public InventoryCheck findById(int id) {
        String sql = "SELECT ic.*, w.name AS warehouse_name, u.name AS created_by_name "
                + "FROM inventory_check ic "
                + "JOIN warehouse w ON ic.warehouse_id = w.warehouse_id "
                + "JOIN user u ON ic.created_by = u.id "
                + "WHERE ic.id = ?";
        try (Connection c = getConnection(); PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setInt(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return getFromResultSet(rs);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    public String generateCheckCode() {
        String prefix = "IC";
        String date = LocalDateTime.now().toString().substring(0, 10).replace("-", "");
        String suffix = String.format("%03d", System.currentTimeMillis() % 1000);
        return prefix + "-" + date + "-" + suffix;
    }

    @Override
    public int insert(InventoryCheck check) {
        String sql = "INSERT INTO inventory_check (check_code, warehouse_id, status, notes, "
                + "created_by, started_at, created_at) "
                + "VALUES (?, ?, 'doing', ?, ?, ?, ?)";
        try (Connection c = getConnection();
             PreparedStatement ps = c.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            ps.setString(1, check.getCheckCode());
            ps.setInt(2, check.getWarehouseId());
            ps.setString(3, check.getNotes());
            ps.setInt(4, check.getCreatedBy());
            LocalDateTime now = LocalDateTime.now();
            ps.setTimestamp(5, Timestamp.valueOf(now));
            ps.setTimestamp(6, Timestamp.valueOf(now));
            ps.executeUpdate();
            try (ResultSet rs = ps.getGeneratedKeys()) {
                if (rs.next()) {
                    return rs.getInt(1);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return -1;
    }

    @Override
    public boolean update(InventoryCheck check) {
        String sql = "UPDATE inventory_check SET warehouse_id = ?, notes = ? WHERE id = ?";
        try (Connection c = getConnection(); PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setInt(1, check.getWarehouseId());
            ps.setString(2, check.getNotes());
            ps.setInt(3, check.getId());
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean complete(int id) {
        String sql = "UPDATE inventory_check SET status = 'completed', completed_at = ? "
                + "WHERE id = ? AND status = 'doing'";
        try (Connection c = getConnection(); PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setTimestamp(1, Timestamp.valueOf(LocalDateTime.now()));
            ps.setInt(2, id);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    @Override
    public boolean delete(InventoryCheck t) {
        throw new UnsupportedOperationException("Not supported yet.");
    }

    @Override
    public List<InventoryCheck> findAll() {
        throw new UnsupportedOperationException("Not supported yet.");
    }

    public List<InventoryCheckDetail> findDetailsByCheckId(int checkId) {
        List<InventoryCheckDetail> list = new ArrayList<>();
        String sql = "SELECT icd.*, g.model AS generator_model, g.power_rating, "
                + "(SELECT c.name FROM generator_category gc "
                + "  JOIN category c ON gc.category_id = c.id "
                + "  WHERE gc.generator_id = g.id AND c.type = 'brand' LIMIT 1) AS generator_brand "
                + "FROM inventory_check_detail icd "
                + "JOIN generator g ON icd.generator_id = g.id "
                + "WHERE icd.check_id = ? "
                + "ORDER BY g.model";
        try (Connection c = getConnection(); PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setInt(1, checkId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    list.add(getDetailFromResultSet(rs));
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    public int insertDetail(InventoryCheckDetail detail) {
        String sql = "INSERT INTO inventory_check_detail "
                + "(check_id, generator_id, system_quantity, actual_quantity, damaged_quantity, notes) "
                + "VALUES (?, ?, ?, ?, ?, ?)";
        try (Connection c = getConnection();
             PreparedStatement ps = c.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            ps.setInt(1, detail.getCheckId());
            ps.setInt(2, detail.getGeneratorId());
            ps.setInt(3, detail.getSystemQuantity());
            if (detail.getActualQuantity() != null) {
                ps.setInt(4, detail.getActualQuantity());
            } else {
                ps.setNull(4, Types.INTEGER);
            }
            ps.setInt(5, detail.getDamagedQuantity());
            ps.setString(6, detail.getNotes());
            ps.executeUpdate();
            try (ResultSet rs = ps.getGeneratedKeys()) {
                if (rs.next()) {
                    return rs.getInt(1);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return -1;
    }

    public boolean insertDetailsBatch(int checkId, List<InventoryCheckDetail> details) {
        String sql = "INSERT INTO inventory_check_detail "
                + "(check_id, generator_id, system_quantity, notes) "
                + "VALUES (?, ?, ?, ?)";
        try (Connection c = getConnection(); PreparedStatement ps = c.prepareStatement(sql)) {
            for (InventoryCheckDetail d : details) {
                ps.setInt(1, checkId);
                ps.setInt(2, d.getGeneratorId());
                ps.setInt(3, d.getSystemQuantity());
                ps.setString(4, d.getNotes());
                ps.addBatch();
            }
            int[] results = ps.executeBatch();
            return results.length > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean updateDetail(InventoryCheckDetail detail) {
        String sql = "UPDATE inventory_check_detail SET actual_quantity = ?, damaged_quantity = ?, notes = ? WHERE id = ?";
        try (Connection c = getConnection(); PreparedStatement ps = c.prepareStatement(sql)) {
            if (detail.getActualQuantity() != null) {
                ps.setInt(1, detail.getActualQuantity());
            } else {
                ps.setNull(1, Types.INTEGER);
            }
            ps.setInt(2, detail.getDamagedQuantity());
            ps.setString(3, detail.getNotes());
            ps.setInt(4, detail.getId());
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean updateDetailsBatch(int checkId, List<InventoryCheckDetail> details) {
        String sql = "UPDATE inventory_check_detail SET actual_quantity = ?, damaged_quantity = ?, notes = ? "
                + "WHERE id = ? AND check_id = ?";
        try (Connection c = getConnection(); PreparedStatement ps = c.prepareStatement(sql)) {
            for (InventoryCheckDetail d : details) {
                if (d.getActualQuantity() != null) {
                    ps.setInt(1, d.getActualQuantity());
                } else {
                    ps.setNull(1, Types.INTEGER);
                }
                ps.setInt(2, d.getDamagedQuantity());
                ps.setString(3, d.getNotes());
                ps.setInt(4, d.getId());
                ps.setInt(5, checkId);
                ps.addBatch();
            }
            int[] results = ps.executeBatch();
            return results.length > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean deleteDetailsByCheckId(int checkId) {
        String sql = "DELETE FROM inventory_check_detail WHERE check_id = ?";
        try (Connection c = getConnection(); PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setInt(1, checkId);
            ps.executeUpdate();
            return true;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public int countDetailsByCheckId(int checkId) {
        String sql = "SELECT COUNT(*) FROM inventory_check_detail WHERE check_id = ?";
        try (Connection c = getConnection(); PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setInt(1, checkId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }

    public int countTotal() {
        String sql = "SELECT COUNT(*) FROM inventory_check";
        try (Connection c = getConnection(); PreparedStatement ps = c.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }

    public int countByStatus(String status) {
        String sql = "SELECT COUNT(*) FROM inventory_check WHERE status = ?";
        try (Connection c = getConnection(); PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setString(1, status);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }

    @Override
    public InventoryCheck getFromResultSet(ResultSet rs) throws SQLException {
        InventoryCheck ic = new InventoryCheck();
        ic.setId(rs.getInt("id"));
        ic.setCheckCode(rs.getString("check_code"));
        ic.setWarehouseId(rs.getInt("warehouse_id"));
        ic.setStatus(rs.getString("status"));
        ic.setNotes(rs.getString("notes"));
        ic.setCreatedBy(rs.getInt("created_by"));
        Timestamp sa = rs.getTimestamp("started_at");
        if (sa != null) ic.setStartedAt(sa.toLocalDateTime());
        Timestamp ca = rs.getTimestamp("completed_at");
        if (ca != null) ic.setCompletedAt(ca.toLocalDateTime());
        Timestamp cra = rs.getTimestamp("created_at");
        if (cra != null) ic.setCreatedAt(cra.toLocalDateTime());
        Timestamp ua = rs.getTimestamp("updated_at");
        if (ua != null) ic.setUpdatedAt(ua.toLocalDateTime());
        try { ic.setWarehouseName(rs.getString("warehouse_name")); } catch (SQLException ignored) {}
        try { ic.setCreatedByName(rs.getString("created_by_name")); } catch (SQLException ignored) {}
        return ic;
    }

    private InventoryCheckDetail getDetailFromResultSet(ResultSet rs) throws SQLException {
        InventoryCheckDetail d = new InventoryCheckDetail();
        d.setId(rs.getInt("id"));
        d.setCheckId(rs.getInt("check_id"));
        d.setGeneratorId(rs.getInt("generator_id"));
        d.setSystemQuantity(rs.getInt("system_quantity"));
        d.setActualQuantity((Integer) rs.getObject("actual_quantity"));
        d.setDamagedQuantity(rs.getInt("damaged_quantity"));
        d.setNotes(rs.getString("notes"));
        try { d.setGeneratorModel(rs.getString("generator_model")); } catch (SQLException ignored) {}
        try { d.setGeneratorBrand(rs.getString("generator_brand")); } catch (SQLException ignored) {}
        try { d.setPowerRating(rs.getString("power_rating")); } catch (SQLException ignored) {}
        return d;
    }
}