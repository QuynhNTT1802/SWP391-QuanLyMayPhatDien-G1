/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package com.quanlymayphatdien.g1.dal;

import com.quanlymayphatdien.g1.entity.Inventory;
import java.sql.*;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 *
 * @author FPTShop
 *
 * Moi serial = 1 dong trong bang inventory. Quan ly ton kho = quan ly serial.
 */
public class InventoryDAO extends DBContext implements I_DAO<Inventory> {

    public static final String STATUS_IN_STOCK = "IN_STOCK";
    public static final String STATUS_SOLD = "SOLD";
    public static final String STATUS_PENDING_LIQUIDATION = "PENDING_LIQUIDATION";
    public static final String STATUS_LIQUIDATED = "LIQUIDATED";
    public static final String STATUS_IN_TRANSIT = "IN_TRANSIT";

    // ============================================================
    // PAGINATED LIST (cho trang /inventory/list)
    // Moi dong = 1 serial, co the loc theo (warehouse, generator, status, search)
    // ============================================================
    public List<Inventory> findByFilters(Integer warehouseId, Integer generatorId,
            String status, String search, int page, int pageSize) {
        List<Inventory> list = new ArrayList<>();
        StringBuilder sql = new StringBuilder(
                "SELECT i.*, "
                + "  g.model AS generator_model, "
                + "  (SELECT c.name FROM generator_category gc "
                + "     JOIN category c ON gc.category_id = c.id "
                + "     WHERE gc.generator_id = g.id AND c.type = 'brand' LIMIT 1) AS generator_brand, "
                + "  w.name AS warehouse_name "
                + "FROM inventory i "
                + "JOIN generator g ON i.generator_id = g.id "
                + "JOIN warehouse w ON i.warehouse_id = w.warehouse_id "
                + "WHERE w.status <> 'locked' ");
        List<Object> params = new ArrayList<>();
        if (warehouseId != null) {
            sql.append("AND i.warehouse_id = ? ");
            params.add(warehouseId);
        }
        if (generatorId != null) {
            sql.append("AND i.generator_id = ? ");
            params.add(generatorId);
        }
        if (status != null && !status.trim().isEmpty()) {
            sql.append("AND i.status = ? ");
            params.add(status.trim());
        }
        if (search != null && !search.trim().isEmpty()) {
            sql.append("AND (i.serial_number LIKE ? OR g.model LIKE ?) ");
            String like = "%" + search.trim() + "%";
            params.add(like);
            params.add(like);
        }
        sql.append("ORDER BY i.updated_at DESC, i.inventory_id DESC LIMIT ? OFFSET ?");
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
                Inventory inv = getFromResultSet(resultSet);
                try {
                    inv.setWarehouseName(resultSet.getString("warehouse_name"));
                } catch (SQLException ignored) {
                }
                try {
                    inv.setGeneratorBrand(resultSet.getString("generator_brand"));
                } catch (SQLException ignored) {
                }
                list.add(inv);
            }
        } catch (SQLException e) {
            System.out.println(e.getMessage());
        } finally {
            closeResources();
        }
        return list;
    }

    public int countByFilters(Integer warehouseId, Integer generatorId, String status, String search) {
        StringBuilder sql = new StringBuilder(
                "SELECT COUNT(*) FROM inventory i "
                + "JOIN generator g ON i.generator_id = g.id "
                + "JOIN warehouse w ON i.warehouse_id = w.warehouse_id "
                + "WHERE w.status <> 'locked' ");
        List<Object> params = new ArrayList<>();
        if (warehouseId != null) {
            sql.append("AND i.warehouse_id = ? ");
            params.add(warehouseId);
        }
        if (generatorId != null) {
            sql.append("AND i.generator_id = ? ");
            params.add(generatorId);
        }
        if (status != null && !status.trim().isEmpty()) {
            sql.append("AND i.status = ? ");
            params.add(status.trim());
        }
        if (search != null && !search.trim().isEmpty()) {
            sql.append("AND (i.serial_number LIKE ? OR g.model LIKE ?) ");
            String like = "%" + search.trim() + "%";
            params.add(like);
            params.add(like);
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
            System.out.println(e.getMessage());
        } finally {
            closeResources();
        }
        return 0;
    }

    // ============================================================
    // TIM KIEM SERIAL (cho receipt xuat / thanh ly / chuyen kho)
    // ============================================================
    public List<Inventory> findInStockByWarehouseAndGenerator(int warehouseId, int generatorId) {
        List<Inventory> list = new ArrayList<>();
        String sql = "SELECT i.*, g.model AS generator_model, w.name AS warehouse_name "
                + "FROM inventory i "
                + "JOIN generator g ON i.generator_id = g.id "
                + "JOIN warehouse w ON i.warehouse_id = w.warehouse_id "
                + "WHERE i.warehouse_id = ? AND i.generator_id = ? AND i.status = ? "
                + "ORDER BY i.created_at, i.inventory_id";
        try {
            connection = getConnection();
            statement = connection.prepareStatement(sql);
            statement.setInt(1, warehouseId);
            statement.setInt(2, generatorId);
            statement.setString(3, STATUS_IN_STOCK);
            resultSet = statement.executeQuery();
            while (resultSet.next()) {
                Inventory inv = getFromResultSet(resultSet);
                try {
                    inv.setGeneratorModel(resultSet.getString("generator_model"));
                } catch (SQLException ignored) {
                }
                try {
                    inv.setWarehouseName(resultSet.getString("warehouse_name"));
                } catch (SQLException ignored) {
                }
                list.add(inv);
            }
        } catch (SQLException e) {
            System.out.println(e.getMessage());
        } finally {
            closeResources();
        }
        return list;
    }

    /**
     * Lay tat ca serial IN_STOCK cua mot warehouse, group theo generator. Dung
     * cho serial-picker mới: 1 lan goi de hien tat ca model trong kho.
     */
    public List<Inventory> findInStockByWarehouse(int warehouseId) {
        List<Inventory> list = new ArrayList<>();
        String sql = "SELECT i.*, g.model AS generator_model, g.unit_price AS generator_price, w.name AS warehouse_name "
                + "FROM inventory i "
                + "JOIN generator g ON i.generator_id = g.id "
                + "JOIN warehouse w ON i.warehouse_id = w.warehouse_id "
                + "WHERE i.warehouse_id = ? AND i.status = ? "
                + "ORDER BY g.model, i.created_at, i.inventory_id";
        try {
            connection = getConnection();
            statement = connection.prepareStatement(sql);
            statement.setInt(1, warehouseId);
            statement.setString(2, STATUS_IN_STOCK);
            resultSet = statement.executeQuery();
            while (resultSet.next()) {
                Inventory inv = getFromResultSet(resultSet);
                try {
                    inv.setGeneratorModel(resultSet.getString("generator_model"));
                } catch (SQLException ignored) {
                }
                try {
                    inv.setWarehouseName(resultSet.getString("warehouse_name"));
                } catch (SQLException ignored) {
                }
                list.add(inv);
            }
        } catch (SQLException e) {
            System.out.println(e.getMessage());
        } finally {
            closeResources();
        }
        return list;
    }

    /**
     * Lay danh sach serial dang bi khoa (PENDING_LIQUIDATION) cho ca mot
     * warehouse, khong filter generator. Dung cho serial-picker moi.
     */
    public List<Map<String, Object>> findPendingLiquidationSerialsByWarehouse(int warehouseId) {
        List<Map<String, Object>> result = new ArrayList<>();
        String sql = "SELECT i.serial_number, i.generator_id, i.created_at, g.model AS generator_model, "
                + "       l.liquidation_id, l.liquidation_code, l.status AS liq_status "
                + "FROM inventory i "
                + "JOIN generator g ON i.generator_id = g.id "
                + "JOIN liquidation_detail ld ON ld.serial_number = i.serial_number "
                + "JOIN liquidation l ON l.liquidation_id = ld.liquidation_id "
                + "WHERE i.warehouse_id = ? "
                + "  AND i.status = ? "
                + "  AND l.status IN ('PENDING_MANAGER','PENDING_CEO','MANAGER_REQUEST_EDIT','CEO_REQUEST_EDIT')";
        try {
            connection = getConnection();
            statement = connection.prepareStatement(sql);
            statement.setInt(1, warehouseId);
            statement.setString(2, STATUS_PENDING_LIQUIDATION);
            resultSet = statement.executeQuery();
            while (resultSet.next()) {
                Map<String, Object> m = new HashMap<>();
                m.put("serialNumber", resultSet.getString("serial_number"));
                m.put("generatorId", resultSet.getInt("generator_id"));
                m.put("generatorModel", resultSet.getString("generator_model"));
                m.put("createdAt", resultSet.getTimestamp("created_at"));
                m.put("liquidationId", resultSet.getInt("liquidation_id"));
                m.put("liquidationCode", resultSet.getString("liquidation_code"));
                m.put("liquidationStatus", resultSet.getString("liq_status"));
                result.add(m);
            }
        } catch (SQLException e) {
            System.out.println(e.getMessage());
        } finally {
            closeResources();
        }
        return result;
    }

    public Inventory findBySerialNumber(String serialNumber) {
        String sql = "SELECT i.*, g.model AS generator_model, w.name AS warehouse_name "
                + "FROM inventory i "
                + "JOIN generator g ON i.generator_id = g.id "
                + "JOIN warehouse w ON i.warehouse_id = w.warehouse_id "
                + "WHERE i.serial_number = ?";
        try {
            connection = getConnection();
            statement = connection.prepareStatement(sql);
            statement.setString(1, serialNumber);
            resultSet = statement.executeQuery();
            if (resultSet.next()) {
                Inventory inv = getFromResultSet(resultSet);
                try {
                    inv.setGeneratorModel(resultSet.getString("generator_model"));
                } catch (SQLException ignored) {
                }
                try {
                    inv.setWarehouseName(resultSet.getString("warehouse_name"));
                } catch (SQLException ignored) {
                }
                return inv;
            }
        } catch (SQLException e) {
            System.out.println(e.getMessage());
        } finally {
            closeResources();
        }
        return null;
    }

    // ============================================================
    // MUTATIONS (insert / update status)
    // ============================================================
    /**
     * Them 1 serial moi vao kho. Tra ve true neu insert thanh cong, false neu
     * serial bi trung (UNIQUE conflict).
     */
    public boolean insert(Connection conn, int generatorId, String serialNumber, int warehouseId, String status) throws SQLException {
        String sql = "INSERT INTO inventory (generator_id, serial_number, warehouse_id, status) VALUES (?, ?, ?, ?)";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, generatorId);
            ps.setString(2, serialNumber);
            ps.setInt(3, warehouseId);
            ps.setString(4, status == null ? STATUS_IN_STOCK : status);
            return ps.executeUpdate() > 0;
        }
    }

    /**
     * Atomic claim: chuyển status IN_STOCK -> targetStatus cho list serial, CHỈ
     * UPDATE row đang IN_STOCK đúng warehouse. Trả về số row affected. Caller
     * so sánh affected với serials.size() để phát hiện race condition.
     */
    public int claimInStockBatch(Connection conn, List<String> serialNumbers,
            int warehouseId, String targetStatus) throws SQLException {
        if (serialNumbers == null || serialNumbers.isEmpty()) {
            return 0;
        }
        StringBuilder sql = new StringBuilder(
                "UPDATE inventory SET status = ? "
                + "WHERE warehouse_id = ? AND status = ? AND serial_number IN (");
        for (int i = 0; i < serialNumbers.size(); i++) {
            sql.append(i == 0 ? "?" : ",?");
        }
        sql.append(")");
        try (PreparedStatement ps = conn.prepareStatement(sql.toString())) {
            int idx = 1;
            ps.setString(idx++, targetStatus);
            ps.setInt(idx++, warehouseId);
            ps.setString(idx++, STATUS_IN_STOCK);
            for (String sn : serialNumbers) {
                ps.setString(idx++, sn);
            }
            return ps.executeUpdate();
        }
    }

    /**
     * Trả về list serial đang KHÔNG ở trạng thái IN_STOCK ở warehouse cho
     * trước. Dùng để báo lỗi rõ "Serial X đã bị chiếm chỗ" khi atomic claim
     * fail.
     */
    public List<String> findUnavailableSerials(Connection conn, List<String> serialNumbers, int warehouseId) throws SQLException {
        List<String> result = new ArrayList<>();
        if (serialNumbers == null || serialNumbers.isEmpty()) {
            return result;
        }
        StringBuilder sql = new StringBuilder(
                "SELECT serial_number FROM inventory "
                + "WHERE serial_number IN (");
        for (int i = 0; i < serialNumbers.size(); i++) {
            sql.append(i == 0 ? "?" : ",?");
        }
        sql.append(") AND (warehouse_id <> ? OR status <> ?)");
        try (PreparedStatement ps = conn.prepareStatement(sql.toString())) {
            int idx = 1;
            for (String sn : serialNumbers) {
                ps.setString(idx++, sn);
            }
            ps.setInt(idx++, warehouseId);
            ps.setString(idx++, STATUS_IN_STOCK);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    result.add(rs.getString("serial_number"));
                }
            }
        }
        return result;
    }

    /**
     * Lấy thông tin serial đang bị khoá ở liquidation khác cho cùng warehouse +
     * generator. Trả về Map: serialNumber -> Map{liquidationId,
     * liquidationCode, status}
     */
    public List<Map<String, Object>> findPendingLiquidationSerials(int warehouseId, int generatorId) {
        List<Map<String, Object>> result = new ArrayList<>();
        String sql = "SELECT i.serial_number, i.created_at, "
                + "       l.liquidation_id, l.liquidation_code, l.status AS liq_status "
                + "FROM inventory i "
                + "JOIN liquidation_detail ld ON ld.serial_number = i.serial_number "
                + "JOIN liquidation l ON l.liquidation_id = ld.liquidation_id "
                + "WHERE i.warehouse_id = ? AND i.generator_id = ? "
                + "  AND i.status = ? "
                + "  AND l.status IN ('PENDING_MANAGER','PENDING_CEO','MANAGER_REQUEST_EDIT','CEO_REQUEST_EDIT')";
        try {
            connection = getConnection();
            statement = connection.prepareStatement(sql);
            statement.setInt(1, warehouseId);
            statement.setInt(2, generatorId);
            statement.setString(3, STATUS_PENDING_LIQUIDATION);
            resultSet = statement.executeQuery();
            while (resultSet.next()) {
                Map<String, Object> m = new HashMap<>();
                m.put("serialNumber", resultSet.getString("serial_number"));
                m.put("createdAt", resultSet.getTimestamp("created_at"));
                m.put("liquidationId", resultSet.getInt("liquidation_id"));
                m.put("liquidationCode", resultSet.getString("liquidation_code"));
                m.put("liquidationStatus", resultSet.getString("liq_status"));
                result.add(m);
            }
        } catch (SQLException e) {
            System.out.println(e.getMessage());
        } finally {
            closeResources();
        }
        return result;
    }

    /**
     * Cap nhat trang thai cua 1 serial. Tra ve so dong bi anh huong.
     */
    public int updateStatusBySerial(Connection conn, String serialNumber, String newStatus) throws SQLException {
        String sql = "UPDATE inventory SET status = ? WHERE serial_number = ?";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, newStatus);
            ps.setString(2, serialNumber);
            return ps.executeUpdate();
        }
    }

    /**
     * Overload khong can connection (tu mo connection rieng).
     */
    public boolean updateStatusBySerial(String serialNumber, String newStatus) {
        try (Connection c = getConnection()) {
            return updateStatusBySerial(c, serialNumber, newStatus) > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    /**
     * Cap nhat trang thai nhieu serial cung luc.
     */
    public int updateStatusBatch(Connection conn, List<String> serialNumbers, String newStatus) throws SQLException {
        if (serialNumbers == null || serialNumbers.isEmpty()) {
            return 0;
        }
        String sql = "UPDATE inventory SET status = ? WHERE serial_number = ?";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            for (String sn : serialNumbers) {
                ps.setString(1, newStatus);
                ps.setString(2, sn);
                ps.addBatch();
            }
            int[] rs = ps.executeBatch();
            int total = 0;
            for (int r : rs) {
                total += r;
            }
            return total;
        }
    }

    /**
     * Kiem tra serial co dang IN_STOCK o dung kho khong (dung cho xuat kho).
     * Tra ve true neu OK, false neu khong ton tai hoac khong o trang thai
     * IN_STOCK.
     */
    public boolean isInStockAtWarehouse(Connection conn, String serialNumber, int warehouseId) throws SQLException {
        String sql = "SELECT COUNT(*) FROM inventory WHERE serial_number = ? AND warehouse_id = ? AND status = ?";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, serialNumber);
            ps.setInt(2, warehouseId);
            ps.setString(3, STATUS_IN_STOCK);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1) > 0;
                }
            }
        }
        return false;
    }

    public boolean isInStockAtWarehouse(String serialNumber, int warehouseId) {
        try (Connection c = getConnection()) {
            return isInStockAtWarehouse(c, serialNumber, warehouseId);
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    /**
     * Kiem tra serial da ton tai trong he thong hay chua (bat ke trang thai
     * nao).
     */
    public boolean isSerialExists(Connection conn, String serialNumber) throws SQLException {
        String sql = "SELECT COUNT(*) FROM inventory WHERE serial_number = ?";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, serialNumber);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1) > 0;
                }
            }
        }
        return false;
    }

    /**
     * Lay danh sach serial IN_STOCK theo (warehouse, generator) - DUNG CHO
     * CHUYEN KHO. Co gioi han (limit) de tranh query qua lon.
     */
    public List<String> findInStockSerialsForTransfer(Connection conn, int warehouseId, int generatorId, int limit) throws SQLException {
        List<String> result = new ArrayList<>();
        String sql = "SELECT serial_number FROM inventory "
                + "WHERE warehouse_id = ? AND generator_id = ? AND status = ? "
                + "ORDER BY created_at LIMIT ?";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, warehouseId);
            ps.setInt(2, generatorId);
            ps.setString(3, STATUS_IN_STOCK);
            ps.setInt(4, limit);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    result.add(rs.getString("serial_number"));
                }
            }
        }
        return result;
    }

    /**
     * Cap nhat warehouse_id cua mot serial (dung cho chuyen kho).
     */
    public int updateWarehouseBySerial(Connection conn, String serialNumber, int newWarehouseId) throws SQLException {
        String sql = "UPDATE inventory SET warehouse_id = ?, status = ? WHERE serial_number = ?";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, newWarehouseId);
            ps.setString(2, STATUS_IN_STOCK);
            ps.setString(3, serialNumber);
            return ps.executeUpdate();
        }
    }

    // ============================================================
    // AGGREGATE / KPI (tinh tu serial table)
    // ============================================================
    /**
     * Dem tong so serial IN_STOCK theo kho.
     */
    public Map<Integer, Integer> countInStockByWarehouse() {
        Map<Integer, Integer> map = new HashMap<>();
        String sql = "SELECT i.warehouse_id, COUNT(*) AS cnt "
                + "FROM inventory i "
                + "JOIN warehouse w ON i.warehouse_id = w.warehouse_id "
                + "WHERE w.status = 'active' AND i.status = 'IN_STOCK' "
                + "GROUP BY i.warehouse_id";
        try (Connection c = getConnection(); PreparedStatement ps = c.prepareStatement(sql); ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                map.put(rs.getInt("warehouse_id"), rs.getInt("cnt"));
            }
        } catch (SQLException e) {
            System.out.println(e.getMessage());
        }
        return map;
    }

    /**
     * Dem tong serial theo (warehouse, generator) - de hien thi trang overview.
     */
    public Map<String, Integer> countItemsByWarehouseAndGenerator() {
        Map<String, Integer> map = new HashMap<>();
        String sql = "SELECT i.warehouse_id, i.generator_id, COUNT(*) AS cnt "
                + "FROM inventory i "
                + "WHERE i.status = 'IN_STOCK' "
                + "GROUP BY i.warehouse_id, i.generator_id";
        try (Connection c = getConnection(); PreparedStatement ps = c.prepareStatement(sql); ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                String key = rs.getInt("warehouse_id") + "_" + rs.getInt("generator_id");
                map.put(key, rs.getInt("cnt"));
            }
        } catch (SQLException e) {
            System.out.println(e.getMessage());
        }
        return map;
    }

    public long grandTotalInStock() {
        String sql = "SELECT COUNT(*) FROM inventory i "
                + "JOIN warehouse w ON i.warehouse_id = w.warehouse_id "
                + "WHERE w.status = 'active' AND i.status = 'IN_STOCK'";
        try (Connection c = getConnection(); PreparedStatement ps = c.prepareStatement(sql); ResultSet rs = ps.executeQuery()) {
            if (rs.next()) {
                return rs.getLong(1);
            }
        } catch (SQLException e) {
            System.out.println(e.getMessage());
        }
        return 0;
    }

    public int countActiveWarehouses() {
        String sql = "SELECT COUNT(*) FROM warehouse WHERE status = 'active'";
        try (Connection c = getConnection(); PreparedStatement ps = c.prepareStatement(sql); ResultSet rs = ps.executeQuery()) {
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (SQLException e) {
            System.out.println(e.getMessage());
        }
        return 0;
    }

    public int countLockedWarehouses() {
        String sql = "SELECT COUNT(*) FROM warehouse WHERE status = 'locked'";
        try (Connection c = getConnection(); PreparedStatement ps = c.prepareStatement(sql); ResultSet rs = ps.executeQuery()) {
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (SQLException e) {
            System.out.println(e.getMessage());
        }
        return 0;
    }

    /**
     * So luong model (generator) dang co trong 1 kho.
     */
    public int countDistinctGeneratorsInStockByWarehouse(int warehouseId) {
        String sql = "SELECT COUNT(DISTINCT generator_id) FROM inventory WHERE warehouse_id = ? AND status = 'IN_STOCK'";
        try (Connection c = getConnection(); PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setInt(1, warehouseId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1);
                }
            }
        } catch (SQLException e) {
            System.out.println(e.getMessage());
        }
        return 0;
    }

    /**
     * So serial IN_STOCK trong 1 kho.
     */
    public int countByWarehouseId(int warehouseId) {
        String sql = "SELECT COUNT(*) FROM inventory WHERE warehouse_id = ? AND status = 'IN_STOCK'";
        try (Connection c = getConnection(); PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setInt(1, warehouseId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1);
                }
            }
        } catch (SQLException e) {
            System.out.println(e.getMessage());
        }
        return 0;
    }

    // ============================================================
    // I_DAO contract (giu lai de khong break code khac)
    // ============================================================
    @Override
    public List<Inventory> findAll() {
        List<Inventory> list = new ArrayList<>();
        String sql = "SELECT i.*, g.model AS generator_model, w.name AS warehouse_name "
                + "FROM inventory i "
                + "JOIN generator g ON i.generator_id = g.id "
                + "JOIN warehouse w ON i.warehouse_id = w.warehouse_id";
        try {
            connection = getConnection();
            statement = connection.prepareStatement(sql);
            resultSet = statement.executeQuery();
            while (resultSet.next()) {
                Inventory inv = getFromResultSet(resultSet);
                try {
                    inv.setGeneratorModel(resultSet.getString("generator_model"));
                } catch (SQLException ignored) {
                }
                try {
                    inv.setWarehouseName(resultSet.getString("warehouse_name"));
                } catch (SQLException ignored) {
                }
                list.add(inv);
            }
        } catch (SQLException e) {
            System.out.println(e.getMessage());
        } finally {
            closeResources();
        }
        return list;
    }

    @Override
    public boolean update(Inventory t) {
        throw new UnsupportedOperationException("Not supported yet.");
    }

    @Override
    public boolean delete(Inventory t) {
        throw new UnsupportedOperationException("Not supported yet.");
    }

    @Override
    public int insert(Inventory t) {
        String sql = "INSERT INTO inventory (serial_number, generator_id, warehouse_id, status) VALUES (?, ?, ?, ?)";
        try {
            connection = getConnection();
            statement = connection.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS);
            statement.setString(1, t.getSerialNumber());
            statement.setInt(2, t.getGeneratorId());
            statement.setInt(3, t.getWarehouseId());
            statement.setString(4, t.getStatus() == null ? STATUS_IN_STOCK : t.getStatus());
            int affected = statement.executeUpdate();
            if (affected > 0) {
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
        return -1;
    }

    @Override
    public Inventory getFromResultSet(ResultSet rs) throws SQLException {
        Inventory inv = new Inventory();
        inv.setInventoryId(rs.getInt("inventory_id"));
        inv.setSerialNumber(rs.getString("serial_number"));
        inv.setGeneratorId(rs.getInt("generator_id"));
        inv.setWarehouseId(rs.getInt("warehouse_id"));
        inv.setStatus(rs.getString("status"));
        Timestamp ca = rs.getTimestamp("created_at");
        if (ca != null) {
            inv.setCreatedAt(ca.toLocalDateTime());
        }
        Timestamp ua = rs.getTimestamp("updated_at");
        if (ua != null) {
            inv.setUpdatedAt(ua.toLocalDateTime());
        }
        try {
            inv.setGeneratorModel(rs.getString("generator_model"));
        } catch (SQLException ignored) {
        }
        try {
            inv.setGeneratorBrand(rs.getString("generator_brand"));
        } catch (SQLException ignored) {
        }
        try {
            inv.setWarehouseName(rs.getString("warehouse_name"));
        } catch (SQLException ignored) {
        }
        return inv;
    }
}
