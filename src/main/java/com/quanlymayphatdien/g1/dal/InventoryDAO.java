package com.quanlymayphatdien.g1.dal;

import com.quanlymayphatdien.g1.entity.GeneratorSummary;
import com.quanlymayphatdien.g1.entity.Inventory;
import java.sql.*;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * Moi serial = 1 dong trong bang inventory. Quan ly ton kho = quan ly serial.
 */
public class InventoryDAO extends DBContext implements I_DAO<Inventory> {

    public static final String STATUS_IN_STOCK = "IN_STOCK";
    public static final String STATUS_SOLD = "SOLD";
    public static final String STATUS_PENDING_LIQUIDATION = "PENDING_LIQUIDATION";
    public static final String STATUS_LIQUIDATED = "LIQUIDATED";
    public static final String STATUS_IN_TRANSIT = "IN_TRANSIT";
    public static final String STATUS_PENDING_IMPORT = "PENDING_IMPORT";
    public static final String STATUS_RESERVED_EXPORT = "RESERVED_EXPORT";

    public List<GeneratorSummary> findGeneratorSummary(Integer warehouseId,
            String search, int page, int pageSize) {
        List<GeneratorSummary> list = new ArrayList<>();
        StringBuilder sql = new StringBuilder(
                "SELECT g.id, g.model, "
              + "  (SELECT c.name FROM generator_category gc "
              + "     JOIN category c ON gc.category_id = c.id "
              + "     WHERE gc.generator_id = g.id AND c.type = 'brand' LIMIT 1) AS brand, "
              + "  COUNT(i.inventory_id) AS total_serials "
              + "FROM generator g "
              + "JOIN inventory i ON i.generator_id = g.id "
              + "JOIN warehouse w ON i.warehouse_id = w.warehouse_id "
              + "WHERE w.status <> 'locked' ");
        List<Object> params = new ArrayList<>();
        if (warehouseId != null) {
            sql.append("AND i.warehouse_id = ? ");
            params.add(warehouseId);
        }
        if (search != null && !search.trim().isEmpty()) {
            sql.append("AND g.model LIKE ? ");
            params.add("%" + search.trim() + "%");
        }
        sql.append("GROUP BY g.id, g.model ORDER BY g.model LIMIT ? OFFSET ?");
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
                GeneratorSummary s = new GeneratorSummary();
                s.setId(resultSet.getInt("id"));
                s.setModel(resultSet.getString("model"));
                try { s.setBrand(resultSet.getString("brand")); } catch (SQLException ignored) {}
                s.setTotalSerials(resultSet.getInt("total_serials"));
                list.add(s);
            }
        } catch (SQLException e) {
            System.out.println(e.getMessage());
        } finally {
            closeResources();
        }
        return list;
    }

    public int countGeneratorSummary(Integer warehouseId, String search) {
        StringBuilder sql = new StringBuilder(
                "SELECT COUNT(DISTINCT g.id) "
              + "FROM generator g "
              + "JOIN inventory i ON i.generator_id = g.id "
              + "JOIN warehouse w ON i.warehouse_id = w.warehouse_id "
              + "WHERE w.status <> 'locked' ");
        List<Object> params = new ArrayList<>();
        if (warehouseId != null) {
            sql.append("AND i.warehouse_id = ? ");
            params.add(warehouseId);
        }
        if (search != null && !search.trim().isEmpty()) {
            sql.append("AND g.model LIKE ? ");
            params.add("%" + search.trim() + "%");
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

    public List<Inventory> findByFilters(Integer warehouseId, Integer generatorId,
            String status, String search, int page, int pageSize) {
        List<Inventory> list = new ArrayList<>();
        StringBuilder sql = new StringBuilder(
                "SELECT i.*, "
                + "  g.model AS generator_model, "
                + "  (SELECT c.name FROM generator_category gc "
                + "     JOIN category c ON gc.category_id = c.id "
                + "     WHERE gc.generator_id = g.id AND c.type = 'brand' LIMIT 1) AS generator_brand, "
                + "  w.name AS warehouse_name, "
                + "  imp.receipt_id AS import_receipt_id, "
                + "  imp.receipt_code AS import_receipt_code "
                + "FROM inventory i "
                + "JOIN generator g ON i.generator_id = g.id "
                + "JOIN warehouse w ON i.warehouse_id = w.warehouse_id "
                + "LEFT JOIN ( "
                + "  SELECT rd.inventory_id, r.receipt_id, r.receipt_code "
                + "  FROM receipt_detail rd "
                + "  JOIN receipt r ON r.receipt_id = rd.receipt_id "
                + "  WHERE r.receipt_type = 'IMPORT' "
                + "    AND r.status NOT IN ('CANCELLED','REJECTED') "
                + ") imp ON imp.inventory_id = i.inventory_id "
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
                try {
                    int rid = resultSet.getInt("import_receipt_id");
                    if (!resultSet.wasNull()) {
                        inv.setImportReceiptId(rid);
                        inv.setImportReceiptCode(resultSet.getString("import_receipt_code"));
                    }
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

    public int countTotalInStockByGenerator(int generatorId) {
        String sql = "SELECT COUNT(*) FROM inventory WHERE generator_id = ? AND status = ?";
        try {
            connection = getConnection();
            statement = connection.prepareStatement(sql);
            statement.setInt(1, generatorId);
            statement.setString(2, STATUS_IN_STOCK);
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

    /**
     * Lay tat ca serial IN_STOCK cua mot warehouse, group theo generator. Dung
     * cho serial-picker mới: 1 lan goi de hien tat ca model trong kho.
     */
    public List<Inventory> findInStockByWarehouse(int warehouseId) {
        List<Inventory> list = new ArrayList<>();
        String sql = "SELECT i.*, g.model AS generator_model, w.name AS warehouse_name "
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


    public List<Map<String, Object>> findPendingLiquidationSerials(int warehouseId, int generatorId) {
        List<Map<String, Object>> result = new ArrayList<>();
        for (Map<String, Object> m : findPendingLiquidationSerialsByWarehouse(warehouseId)) {
            Object gid = m.get("generatorId");
            if (gid instanceof Integer && ((Integer) gid) == generatorId) {
                result.add(m);
            }
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


    public int insertPendingImport(Connection conn, int generatorId,
                                    String serialNumber, int warehouseId) throws SQLException {
        String sql = "INSERT INTO inventory (generator_id, serial_number, warehouse_id, status) "
                   + "VALUES (?, ?, ?, ?)";
        try (PreparedStatement ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            ps.setInt(1, generatorId);
            ps.setString(2, serialNumber);
            ps.setInt(3, warehouseId);
            ps.setString(4, STATUS_PENDING_IMPORT);
            ps.executeUpdate();
            try (ResultSet rs = ps.getGeneratedKeys()) {
                if (rs.next()) {
                    return rs.getInt(1);
                }
            }
        }
        return -1;
    }


    public boolean reserveForExport(Connection conn, int inventoryId) throws SQLException {
        String sql = "UPDATE inventory SET status = ? WHERE inventory_id = ? AND status = ?";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, STATUS_RESERVED_EXPORT);
            ps.setInt(2, inventoryId);
            ps.setString(3, STATUS_IN_STOCK);
            return ps.executeUpdate() > 0;
        }
    }


    public boolean releaseReservation(Connection conn, int inventoryId) throws SQLException {
        String sql = "UPDATE inventory SET status = ? WHERE inventory_id = ? AND status = ?";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, STATUS_IN_STOCK);
            ps.setInt(2, inventoryId);
            ps.setString(3, STATUS_RESERVED_EXPORT);
            return ps.executeUpdate() > 0;
        }
    }


    public boolean completeImport(Connection conn, int inventoryId) throws SQLException {
        String sql = "UPDATE inventory SET status = ? WHERE inventory_id = ? AND status = ?";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, STATUS_IN_STOCK);
            ps.setInt(2, inventoryId);
            ps.setString(3, STATUS_PENDING_IMPORT);
            return ps.executeUpdate() > 0;
        }
    }

    public boolean completeExport(Connection conn, int inventoryId, String targetStatus) throws SQLException {
        String sql = "UPDATE inventory SET status = ? WHERE inventory_id = ? AND status = ?";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, targetStatus);
            ps.setInt(2, inventoryId);
            ps.setString(3, STATUS_RESERVED_EXPORT);
            return ps.executeUpdate() > 0;
        }
    }


    public int deletePendingImport(Connection conn, List<Integer> inventoryIds) throws SQLException {
        if (inventoryIds == null || inventoryIds.isEmpty()) {
            return 0;
        }
        String placeholders = String.join(",", java.util.Collections.nCopies(inventoryIds.size(), "?"));
        String sql = "DELETE FROM inventory WHERE status = ? AND inventory_id IN (" + placeholders + ")";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, STATUS_PENDING_IMPORT);
            for (int i = 0; i < inventoryIds.size(); i++) {
                ps.setInt(i + 2, inventoryIds.get(i));
            }
            return ps.executeUpdate();
        }
    }

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
        try {
            connection = getConnection();
            return updateStatusBySerial(connection, serialNumber, newStatus) > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        } finally {
            closeResources();
        }
    }

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
     * Atomic claim: chi update sang newStatus nhung serial dang IN_STOCK va dung kho.
     * Tra ve so dong update thanh cong. Goi sau do voi cung input qua findUnavailableSerials
     * de biet serial nao bi tu choi.
     */
    public int claimInStockBatch(Connection conn, List<String> serialNumbers, int warehouseId, String newStatus) throws SQLException {
        if (serialNumbers == null || serialNumbers.isEmpty()) {
            return 0;
        }
        String sql = "UPDATE inventory SET status = ? "
                   + "WHERE serial_number = ? AND warehouse_id = ? AND status = ?";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            for (String sn : serialNumbers) {
                ps.setString(1, newStatus);
                ps.setString(2, sn);
                ps.setInt(3, warehouseId);
                ps.setString(4, STATUS_IN_STOCK);
                ps.addBatch();
            }
            int[] rs = ps.executeBatch();
            int total = 0;
            for (int r : rs) {
                if (r > 0) {
                    total += r;
                }
            }
            return total;
        }
    }

    /**
     * Tra ve cac serial trong input KHONG dang IN_STOCK o warehouse chi dinh
     * (khong ton tai, sai kho, hoac sai status). Dung de bao loi cho user
     * sau khi claimInStockBatch fail mot phan.
     */
    public List<String> findUnavailableSerials(Connection conn, List<String> serialNumbers, int warehouseId) throws SQLException {
        List<String> result = new ArrayList<>();
        if (serialNumbers == null || serialNumbers.isEmpty()) {
            return result;
        }
        StringBuilder placeholders = new StringBuilder();
        for (int i = 0; i < serialNumbers.size(); i++) {
            if (i > 0) placeholders.append(",");
            placeholders.append("?");
        }
        String sql = "SELECT serial_number FROM inventory "
                   + "WHERE serial_number IN (" + placeholders + ") "
                   + "  AND warehouse_id = ? AND status = ?";
        java.util.Set<String> available = new java.util.HashSet<>();
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            int idx = 1;
            for (String sn : serialNumbers) {
                ps.setString(idx++, sn);
            }
            ps.setInt(idx++, warehouseId);
            ps.setString(idx, STATUS_IN_STOCK);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    available.add(rs.getString("serial_number"));
                }
            }
        }
        for (String sn : serialNumbers) {
            if (!available.contains(sn)) {
                result.add(sn);
            }
        }
        return result;
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
        try {
            connection = getConnection();
            return isInStockAtWarehouse(connection, serialNumber, warehouseId);
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            closeResources();
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
     * Kiem tra serial co dang bi "khoa" khong the tai su dung.
     * Tra ve true neu serial dang duoc su dung boi 1 receipt con hieu luc
     * (DRAFT, PENDING, hoac co status khac PENDING_IMPORT nhu IN_STOCK, SOLD...).
     * Tra ve false neu serial chi ton tai tren receipt DA Huy (CANCELLED)
     * hoac khong ton tai trong he thong.
     */
    public boolean isSerialBlocked(String serialNumber) {
        String sql = "SELECT COUNT(*) FROM inventory i "
                   + "LEFT JOIN receipt_detail rd ON i.inventory_id = rd.inventory_id "
                   + "LEFT JOIN receipt r ON rd.receipt_id = r.receipt_id "
                   + "WHERE i.serial_number = ? "
                   + "AND (i.status <> ? "
                   + "     OR (r.status IS NOT NULL AND r.status <> ?))";
        try (Connection c = getConnection(); PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setString(1, serialNumber);
            ps.setString(2, STATUS_PENDING_IMPORT);
            ps.setString(3, "CANCELLED");
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1) > 0;
                }
            }
        } catch (SQLException e) {
            System.out.println(e.getMessage());
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
        try {
            connection = getConnection();
            statement = connection.prepareStatement(sql);
            resultSet = statement.executeQuery();
            while (resultSet.next()) {
                map.put(resultSet.getInt("warehouse_id"), resultSet.getInt("cnt"));
            }
        } catch (SQLException e) {
            System.out.println(e.getMessage());
        } finally {
            closeResources();
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
        try {
            connection = getConnection();
            statement = connection.prepareStatement(sql);
            resultSet = statement.executeQuery();
            while (resultSet.next()) {
                String key = resultSet.getInt("warehouse_id") + "_" + resultSet.getInt("generator_id");
                map.put(key, resultSet.getInt("cnt"));
            }
        } catch (SQLException e) {
            System.out.println(e.getMessage());
        } finally {
            closeResources();
        }
        return map;
    }

    public long grandTotalInStock() {
        String sql = "SELECT COUNT(*) FROM inventory i "
                + "JOIN warehouse w ON i.warehouse_id = w.warehouse_id "
                + "WHERE w.status = 'active' AND i.status = 'IN_STOCK'";
        try {
            connection = getConnection();
            statement = connection.prepareStatement(sql);
            resultSet = statement.executeQuery();
            if (resultSet.next()) {
                return resultSet.getLong(1);
            }
        } catch (SQLException e) {
            System.out.println(e.getMessage());
        } finally {
            closeResources();
        }
        return 0;
    }

    public int countActiveWarehouses() {
        String sql = "SELECT COUNT(*) FROM warehouse WHERE status = 'active'";
        try {
            connection = getConnection();
            statement = connection.prepareStatement(sql);
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

    public int countLockedWarehouses() {
        String sql = "SELECT COUNT(*) FROM warehouse WHERE status = 'locked'";
        try {
            connection = getConnection();
            statement = connection.prepareStatement(sql);
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

    /**
     * So luong model (generator) dang co trong 1 kho.
     */
    public int countDistinctGeneratorsInStockByWarehouse(int warehouseId) {
        String sql = "SELECT COUNT(DISTINCT generator_id) FROM inventory WHERE warehouse_id = ? AND status = 'IN_STOCK'";
        try {
            connection = getConnection();
            statement = connection.prepareStatement(sql);
            statement.setInt(1, warehouseId);
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

    /**
     * So serial IN_STOCK trong 1 kho.
     */
    public int countByWarehouseId(int warehouseId) {
        String sql = "SELECT COUNT(*) FROM inventory WHERE warehouse_id = ? AND status = 'IN_STOCK'";
        try {
            connection = getConnection();
            statement = connection.prepareStatement(sql);
            statement.setInt(1, warehouseId);
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

    public List<Inventory> findAllInStock() {
        List<Inventory> list = new ArrayList<>();
        String sql = "SELECT i.*, g.model AS generator_model, w.name AS warehouse_name "
                   + "FROM inventory i "
                   + "JOIN generator g ON i.generator_id = g.id "
                   + "JOIN warehouse w ON i.warehouse_id = w.warehouse_id "
                   + "WHERE i.status = ?";
        try {
            connection = getConnection();
            statement = connection.prepareStatement(sql);
            statement.setString(1, STATUS_IN_STOCK);
            resultSet = statement.executeQuery();
            while (resultSet.next()) {
                Inventory inv = getFromResultSet(resultSet);
                try { inv.setGeneratorModel(resultSet.getString("generator_model")); } catch (SQLException ignored) {}
                try { inv.setWarehouseName(resultSet.getString("warehouse_name")); } catch (SQLException ignored) {}
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
    public List<Inventory> findByWarehouseId(int warehouseId) {
        List<Inventory> list = new ArrayList<>();
        String sql = "SELECT i.*, g.model AS generator_model "
                + "FROM inventory i "
                + "JOIN generator g ON i.generator_id = g.id "
                + "WHERE i.warehouse_id = ? AND g.status = 'active'";
        try {
            connection = getConnection();
            statement = connection.prepareStatement(sql);
            statement.setInt(1, warehouseId);
            resultSet = statement.executeQuery();
            while (resultSet.next()) {
                list.add(getFromResultSet(resultSet));
            }
        } catch (SQLException e) {
            System.out.println(e.getMessage());
        } finally {
            closeResources();
        }
        return list;
    }
    public Inventory findByWarehouseAndGenerator(int warehouseId, int generatorId) {
        String sql = "SELECT * FROM inventory WHERE warehouse_id = ? AND generator_id = ?";
        try {
            connection = getConnection();
            statement = connection.prepareStatement(sql);
            statement.setInt(1, warehouseId);
            statement.setInt(2, generatorId);
            resultSet = statement.executeQuery();
            if (resultSet.next()) {
                return getFromResultSet(resultSet);
            }
        } catch (SQLException e) {
            System.out.println(e.getMessage());
        } finally {
            closeResources();
        }
        return null;
    }
}