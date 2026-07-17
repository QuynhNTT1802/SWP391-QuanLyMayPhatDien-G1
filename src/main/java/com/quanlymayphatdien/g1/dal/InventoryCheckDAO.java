package com.quanlymayphatdien.g1.dal;

import com.quanlymayphatdien.g1.entity.InventoryCheck;
import com.quanlymayphatdien.g1.entity.InventoryCheckDetail;
import com.quanlymayphatdien.g1.entity.InventoryCheckSerial;
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

        try {
            connection = getConnection();
            statement = connection.prepareStatement(sql.toString());
            for (int i = 0; i < params.size(); i++) {
                statement.setObject(i + 1, params.get(i));
            }
            resultSet = statement.executeQuery();
            while (resultSet.next()) {
                list.add(getFromResultSet(resultSet));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            closeResources();
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

        try {
            connection = getConnection();
            statement = connection.prepareStatement(sql.toString());
            for (int i = 0; i < params.size(); i++) {
                statement.setObject(i + 1, params.get(i));
            }
            resultSet = statement.executeQuery();
            if (resultSet.next()) {
                return resultSet.getInt(1);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            closeResources();
        }
        return 0;
    }

    public InventoryCheck findById(int id) {
        String sql = "SELECT ic.*, w.name AS warehouse_name, u.name AS created_by_name "
                + "FROM inventory_check ic "
                + "JOIN warehouse w ON ic.warehouse_id = w.warehouse_id "
                + "JOIN user u ON ic.created_by = u.id "
                + "WHERE ic.id = ?";
        try {
            connection = getConnection();
            statement = connection.prepareStatement(sql);
            statement.setInt(1, id);
            resultSet = statement.executeQuery();
            if (resultSet.next()) {
                return getFromResultSet(resultSet);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            closeResources();
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
        try {
            connection = getConnection();
            statement = connection.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS);
            statement.setString(1, check.getCheckCode());
            statement.setInt(2, check.getWarehouseId());
            statement.setString(3, check.getNotes());
            statement.setInt(4, check.getCreatedBy());
            LocalDateTime now = LocalDateTime.now();
            statement.setTimestamp(5, Timestamp.valueOf(now));
            statement.setTimestamp(6, Timestamp.valueOf(now));
            statement.executeUpdate();
            resultSet = statement.getGeneratedKeys();
            if (resultSet.next()) {
                return resultSet.getInt(1);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            closeResources();
        }
        return -1;
    }

    @Override
    public boolean update(InventoryCheck check) {
        String sql = "UPDATE inventory_check SET warehouse_id = ?, notes = ? WHERE id = ?";
        try {
            connection = getConnection();
            statement = connection.prepareStatement(sql);
            statement.setInt(1, check.getWarehouseId());
            statement.setString(2, check.getNotes());
            statement.setInt(3, check.getId());
            return statement.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            closeResources();
        }
        return false;
    }

    public boolean complete(int id) {
        String sql = "UPDATE inventory_check SET status = 'completed', completed_at = ? "
                + "WHERE id = ? AND status = 'doing'";
        try {
            connection = getConnection();
            statement = connection.prepareStatement(sql);
            statement.setTimestamp(1, Timestamp.valueOf(LocalDateTime.now()));
            statement.setInt(2, id);
            return statement.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            closeResources();
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
        try {
            connection = getConnection();
            statement = connection.prepareStatement(sql);
            statement.setInt(1, checkId);
            resultSet = statement.executeQuery();
            while (resultSet.next()) {
                list.add(getDetailFromResultSet(resultSet));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            closeResources();
        }
        return list;
    }

    public int insertDetail(InventoryCheckDetail detail) {
        String sql = "INSERT INTO inventory_check_detail "
                + "(check_id, generator_id, system_quantity, actual_quantity, notes) "
                + "VALUES (?, ?, ?, ?, ?)";
        try {
            connection = getConnection();
            statement = connection.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS);
            statement.setInt(1, detail.getCheckId());
            statement.setInt(2, detail.getGeneratorId());
            statement.setInt(3, detail.getSystemQuantity());
            if (detail.getActualQuantity() != null) {
                statement.setInt(4, detail.getActualQuantity());
            } else {
                statement.setNull(4, Types.INTEGER);
            }
            statement.setString(5, detail.getNotes());
            statement.executeUpdate();
            resultSet = statement.getGeneratedKeys();
            if (resultSet.next()) {
                return resultSet.getInt(1);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            closeResources();
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
        String sql = "UPDATE inventory_check_detail SET actual_quantity = ?, notes = ? WHERE id = ?";
        try {
            connection = getConnection();
            statement = connection.prepareStatement(sql);
            if (detail.getActualQuantity() != null) {
                statement.setInt(1, detail.getActualQuantity());
            } else {
                statement.setNull(1, Types.INTEGER);
            }
            statement.setString(2, detail.getNotes());
            statement.setInt(3, detail.getId());
            return statement.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            closeResources();
        }
        return false;
    }

    public boolean updateDetailsBatch(int checkId, List<InventoryCheckDetail> details) {
        String sql = "UPDATE inventory_check_detail SET actual_quantity = ?, notes = ? "
                + "WHERE id = ? AND check_id = ?";
        try (Connection c = getConnection(); PreparedStatement ps = c.prepareStatement(sql)) {
            for (InventoryCheckDetail d : details) {
                if (d.getActualQuantity() != null) {
                    ps.setInt(1, d.getActualQuantity());
                } else {
                    ps.setNull(1, Types.INTEGER);
                }
                ps.setString(2, d.getNotes());
                ps.setInt(3, d.getId());
                ps.setInt(4, checkId);
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
        try {
            connection = getConnection();
            statement = connection.prepareStatement(sql);
            statement.setInt(1, checkId);
            statement.executeUpdate();
            return true;
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            closeResources();
        }
        return false;
    }

    public int countDetailsByCheckId(int checkId) {
        String sql = "SELECT COUNT(*) FROM inventory_check_detail WHERE check_id = ?";
        try {
            connection = getConnection();
            statement = connection.prepareStatement(sql);
            statement.setInt(1, checkId);
            resultSet = statement.executeQuery();
            if (resultSet.next()) {
                return resultSet.getInt(1);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            closeResources();
        }
        return 0;
    }

    public int countTotal() {
        String sql = "SELECT COUNT(*) FROM inventory_check";
        try {
            connection = getConnection();
            statement = connection.prepareStatement(sql);
            resultSet = statement.executeQuery();
            if (resultSet.next()) {
                return resultSet.getInt(1);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            closeResources();
        }
        return 0;
    }

    public int countByStatus(String status) {
        String sql = "SELECT COUNT(*) FROM inventory_check WHERE status = ?";
        try {
            connection = getConnection();
            statement = connection.prepareStatement(sql);
            statement.setString(1, status);
            resultSet = statement.executeQuery();
            if (resultSet.next()) {
                return resultSet.getInt(1);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            closeResources();
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
        d.setNotes(rs.getString("notes"));
        try { d.setGeneratorModel(rs.getString("generator_model")); } catch (SQLException ignored) {}
        try { d.setGeneratorBrand(rs.getString("generator_brand")); } catch (SQLException ignored) {}
        try { d.setPowerRating(rs.getString("power_rating")); } catch (SQLException ignored) {}
        return d;
    }

    public List<InventoryCheckSerial> findSerialsByCheckId(int checkId) {
        List<InventoryCheckSerial> list = new ArrayList<>();
        String sql = "SELECT ics.*, icd.generator_id, g.model AS generator_model, "
                + "(SELECT c.name FROM generator_category gc "
                + "  JOIN category c ON gc.category_id = c.id "
                + "  WHERE gc.generator_id = g.id AND c.type = 'brand' LIMIT 1) AS generator_brand "
                + "FROM inventory_check_serial ics "
                + "JOIN inventory_check_detail icd ON ics.check_detail_id = icd.id "
                + "JOIN generator g ON icd.generator_id = g.id "
                + "WHERE icd.check_id = ? "
                + "ORDER BY icd.id, ics.id";
        try {
            connection = getConnection();
            statement = connection.prepareStatement(sql);
            statement.setInt(1, checkId);
            resultSet = statement.executeQuery();
            while (resultSet.next()) {
                list.add(getSerialFromResultSet(resultSet));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            closeResources();
        }
        return list;
    }

    public List<InventoryCheckSerial> findSerialsByDetailId(int detailId) {
        List<InventoryCheckSerial> list = new ArrayList<>();
        String sql = "SELECT * FROM inventory_check_serial WHERE check_detail_id = ? ORDER BY id";
        try {
            connection = getConnection();
            statement = connection.prepareStatement(sql);
            statement.setInt(1, detailId);
            resultSet = statement.executeQuery();
            while (resultSet.next()) {
                list.add(getSerialFromResultSet(resultSet));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            closeResources();
        }
        return list;
    }

    public boolean insertSerialsBatch(int checkDetailId, List<InventoryCheckSerial> serials) {
        String sql = "INSERT INTO inventory_check_serial (check_detail_id, serial_number) VALUES (?, ?)";
        try (Connection c = getConnection(); PreparedStatement ps = c.prepareStatement(sql)) {
            for (InventoryCheckSerial s : serials) {
                ps.setInt(1, checkDetailId);
                ps.setString(2, s.getSerialNumber());
                ps.addBatch();
            }
            int[] results = ps.executeBatch();
            return results.length > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean updateSerialsBatch(List<InventoryCheckSerial> serials) {
        String sql = "UPDATE inventory_check_serial SET `status` = ?, notes = ? WHERE id = ?";
        try (Connection c = getConnection(); PreparedStatement ps = c.prepareStatement(sql)) {
            for (InventoryCheckSerial s : serials) {
                ps.setString(1, s.getStatus());
                ps.setString(2, s.getNotes());
                ps.setInt(3, s.getId());
                ps.addBatch();
            }
            int[] results = ps.executeBatch();
            for (int r : results) {
                if (r <= 0) {
                    System.out.println("WARNING: updateSerialsBatch - có serial không update được");
                    return false;
                }
            }
            return true;
        } catch (SQLException e) {
            System.out.println("Lỗi updateSerialsBatch: " + e.getMessage());
        }
        return false;
    }

    public int countSerialsByCheckId(int checkId) {
        String sql = "SELECT COUNT(*) FROM inventory_check_serial ics "
                + "JOIN inventory_check_detail icd ON ics.check_detail_id = icd.id "
                + "WHERE icd.check_id = ?";
        try {
            connection = getConnection();
            statement = connection.prepareStatement(sql);
            statement.setInt(1, checkId);
            resultSet = statement.executeQuery();
            if (resultSet.next()) {
                return resultSet.getInt(1);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            closeResources();
        }
        return 0;
    }

    public int countSerialsByStatus(int checkId, String status) {
        String sql = "SELECT COUNT(*) FROM inventory_check_serial ics "
                + "JOIN inventory_check_detail icd ON ics.check_detail_id = icd.id "
                + "WHERE icd.check_id = ? AND ics.status = ?";
        try {
            connection = getConnection();
            statement = connection.prepareStatement(sql);
            statement.setInt(1, checkId);
            statement.setString(2, status);
            resultSet = statement.executeQuery();
            if (resultSet.next()) {
                return resultSet.getInt(1);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            closeResources();
        }
        return 0;
    }

    public int countNullStatusByCheckId(int checkId) {
        String sql = "SELECT COUNT(*) FROM inventory_check_serial ics "
                + "JOIN inventory_check_detail icd ON ics.check_detail_id = icd.id "
                + "WHERE icd.check_id = ? AND ics.status IS NULL";
        try {
            connection = getConnection();
            statement = connection.prepareStatement(sql);
            statement.setInt(1, checkId);
            resultSet = statement.executeQuery();
            if (resultSet.next()) {
                return resultSet.getInt(1);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            closeResources();
        }
        return -1;
    }

    private InventoryCheckSerial getSerialFromResultSet(ResultSet rs) throws SQLException {
        InventoryCheckSerial s = new InventoryCheckSerial();
        s.setId(rs.getInt("id"));
        s.setCheckDetailId(rs.getInt("check_detail_id"));
        s.setSerialNumber(rs.getString("serial_number"));
        s.setStatus(rs.getString("status"));
        s.setNotes(rs.getString("notes"));
        try { s.setGeneratorModel(rs.getString("generator_model")); } catch (SQLException ignored) {}
        try { s.setGeneratorBrand(rs.getString("generator_brand")); } catch (SQLException ignored) {}
        try { s.setGeneratorId(rs.getInt("generator_id")); } catch (SQLException ignored) {}
        return s;
    }
}
