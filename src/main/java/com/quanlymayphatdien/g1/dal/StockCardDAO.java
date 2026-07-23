/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package com.quanlymayphatdien.g1.dal;

import com.quanlymayphatdien.g1.entity.StockCard;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.*;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.HashSet;
import java.util.List;
import java.util.Map;
import java.util.Set;

/**
 *
 * @author FPTShop
 */
public class StockCardDAO extends DBContext implements I_DAO<StockCard> {

    public List<StockCard> findByWarehouseAndGenerator(int warehouseId, int generatorId) {
        List<StockCard> list = new ArrayList<>();
        String sql = "SELECT sc.*, w.name AS warehouse_name, "
                + "g.model AS generator_model, r.receipt_code, u.name AS created_by_name, "
                + "(SELECT GROUP_CONCAT(i.serial_number SEPARATOR ', ') "
                + " FROM receipt_detail rd "
                + " JOIN inventory i ON rd.inventory_id = i.inventory_id "
                + " WHERE rd.receipt_id = sc.receipt_id AND i.generator_id = sc.generator_id) AS serial_list "
                + "FROM stock_card sc "
                + "LEFT JOIN warehouse w ON sc.warehouse_id = w.warehouse_id "
                + "LEFT JOIN generator g ON sc.generator_id = g.id "
                + "LEFT JOIN receipt r ON sc.receipt_id = r.receipt_id "
                + "LEFT JOIN user u ON sc.created_by = u.id "
                + "WHERE sc.warehouse_id = ? AND sc.generator_id = ? "
                + "ORDER BY sc.created_at DESC";
        try {
            connection = getConnection();
            statement = connection.prepareStatement(sql);
            statement.setInt(1, warehouseId);
            statement.setInt(2, generatorId);
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

    public List<StockCard> findByWarehouseAndGeneratorPaged(int warehouseId, int generatorId,
            String typeFilter, String search, String fromDate, String toDate,
            int page, int pageSize) {
        List<StockCard> list = new ArrayList<>();
        StringBuilder sql = new StringBuilder(
                "SELECT sc.*, w.name AS warehouse_name, "
                + "g.model AS generator_model, r.receipt_code, u.name AS created_by_name, "
                + "(SELECT GROUP_CONCAT(i.serial_number SEPARATOR ', ') "
                + " FROM receipt_detail rd "
                + " JOIN inventory i ON rd.inventory_id = i.inventory_id "
                + " WHERE rd.receipt_id = sc.receipt_id AND i.generator_id = sc.generator_id) AS serial_list "
                + "FROM stock_card sc "
                + "LEFT JOIN warehouse w ON sc.warehouse_id = w.warehouse_id "
                + "LEFT JOIN generator g ON sc.generator_id = g.id "
                + "LEFT JOIN receipt r ON sc.receipt_id = r.receipt_id "
                + "LEFT JOIN user u ON sc.created_by = u.id "
                + "WHERE sc.warehouse_id = ? AND sc.generator_id = ? ");
        List<Object> params = new ArrayList<>();
        params.add(warehouseId);
        params.add(generatorId);
        if (typeFilter != null && !typeFilter.isEmpty()) {
            sql.append("AND sc.transaction_type = ? ");
            params.add(typeFilter);
        }
        if (search != null && !search.trim().isEmpty()) {
            sql.append("AND (r.receipt_code LIKE ? OR sc.reference_note LIKE ? "
                    + "OR EXISTS (SELECT 1 FROM receipt_detail rd2 "
                    + "JOIN inventory i2 ON rd2.inventory_id = i2.inventory_id "
                    + "WHERE rd2.receipt_id = sc.receipt_id AND i2.generator_id = sc.generator_id "
                    + "AND i2.serial_number LIKE ?)) ");
            String like = "%" + search.trim() + "%";
            params.add(like);
            params.add(like);
            params.add(like);
        }
        if (fromDate != null && !fromDate.isEmpty()) {
            sql.append("AND DATE(sc.created_at) >= ? ");
            params.add(fromDate);
        }
        if (toDate != null && !toDate.isEmpty()) {
            sql.append("AND DATE(sc.created_at) <= ? ");
            params.add(toDate);
        }
        sql.append("ORDER BY sc.created_at DESC LIMIT ? OFFSET ?");
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

    public int countByWarehouseAndGenerator(int warehouseId, int generatorId,
            String typeFilter, String search, String fromDate, String toDate) {
        StringBuilder sql = new StringBuilder(
                "SELECT COUNT(*) FROM stock_card sc "
                + "LEFT JOIN receipt r ON sc.receipt_id = r.receipt_id "
                + "WHERE sc.warehouse_id = ? AND sc.generator_id = ? ");
        List<Object> params = new ArrayList<>();
        params.add(warehouseId);
        params.add(generatorId);
        if (typeFilter != null && !typeFilter.isEmpty()) {
            sql.append("AND sc.transaction_type = ? ");
            params.add(typeFilter);
        }
        if (search != null && !search.trim().isEmpty()) {
            sql.append("AND (r.receipt_code LIKE ? OR sc.reference_note LIKE ? "
                    + "OR EXISTS (SELECT 1 FROM receipt_detail rd2 "
                    + "JOIN inventory i2 ON rd2.inventory_id = i2.inventory_id "
                    + "WHERE rd2.receipt_id = sc.receipt_id AND i2.generator_id = sc.generator_id "
                    + "AND i2.serial_number LIKE ?)) ");
            String like = "%" + search.trim() + "%";
            params.add(like);
            params.add(like);
            params.add(like);
        }
        if (fromDate != null && !fromDate.isEmpty()) {
            sql.append("AND DATE(sc.created_at) >= ? ");
            params.add(fromDate);
        }
        if (toDate != null && !toDate.isEmpty()) {
            sql.append("AND DATE(sc.created_at) <= ? ");
            params.add(toDate);
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

    public List<StockCard> findWithFilters(Integer warehouseId, Integer generatorId,
            String typeFilter, String search, String fromDate, String toDate,
            int page, int pageSize) {
        List<StockCard> list = new ArrayList<>();
        StringBuilder sql = new StringBuilder(
                "SELECT sc.*, w.name AS warehouse_name, "
                + "g.model AS generator_model, r.receipt_code, u.name AS created_by_name, "
                + "(SELECT GROUP_CONCAT(i.serial_number SEPARATOR ', ') "
                + " FROM receipt_detail rd "
                + " JOIN inventory i ON rd.inventory_id = i.inventory_id "
                + " WHERE rd.receipt_id = sc.receipt_id AND i.generator_id = sc.generator_id) AS serial_list "
                + "FROM stock_card sc "
                + "LEFT JOIN warehouse w ON sc.warehouse_id = w.warehouse_id "
                + "LEFT JOIN generator g ON sc.generator_id = g.id "
                + "LEFT JOIN receipt r ON sc.receipt_id = r.receipt_id "
                + "LEFT JOIN user u ON sc.created_by = u.id "
                + "WHERE 1=1 ");
        List<Object> params = new ArrayList<>();
        if (warehouseId != null) {
            sql.append("AND sc.warehouse_id = ? ");
            params.add(warehouseId);
        }
        if (generatorId != null) {
            sql.append("AND sc.generator_id = ? ");
            params.add(generatorId);
        }
        if (typeFilter != null && !typeFilter.isEmpty()) {
            sql.append("AND sc.transaction_type = ? ");
            params.add(typeFilter);
        }
        if (search != null && !search.trim().isEmpty()) {
            sql.append("AND (r.receipt_code LIKE ? OR sc.reference_note LIKE ? "
                    + "OR EXISTS (SELECT 1 FROM receipt_detail rd2 "
                    + "JOIN inventory i2 ON rd2.inventory_id = i2.inventory_id "
                    + "WHERE rd2.receipt_id = sc.receipt_id AND i2.generator_id = sc.generator_id "
                    + "AND i2.serial_number LIKE ?)) ");
            String like = "%" + search.trim() + "%";
            params.add(like);
            params.add(like);
            params.add(like);
        }
        if (fromDate != null && !fromDate.isEmpty()) {
            sql.append("AND DATE(sc.created_at) >= ? ");
            params.add(fromDate);
        }
        if (toDate != null && !toDate.isEmpty()) {
            sql.append("AND DATE(sc.created_at) <= ? ");
            params.add(toDate);
        }
        sql.append("ORDER BY sc.created_at DESC LIMIT ? OFFSET ?");
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

    public int countWithFilters(Integer warehouseId, Integer generatorId,
            String typeFilter, String search, String fromDate, String toDate) {
        StringBuilder sql = new StringBuilder(
                "SELECT COUNT(*) FROM stock_card sc "
                + "LEFT JOIN receipt r ON sc.receipt_id = r.receipt_id "
                + "WHERE 1=1 ");
        List<Object> params = new ArrayList<>();
        if (warehouseId != null) {
            sql.append("AND sc.warehouse_id = ? ");
            params.add(warehouseId);
        }
        if (generatorId != null) {
            sql.append("AND sc.generator_id = ? ");
            params.add(generatorId);
        }
        if (typeFilter != null && !typeFilter.isEmpty()) {
            sql.append("AND sc.transaction_type = ? ");
            params.add(typeFilter);
        }
        if (search != null && !search.trim().isEmpty()) {
            sql.append("AND (r.receipt_code LIKE ? OR sc.reference_note LIKE ? "
                    + "OR EXISTS (SELECT 1 FROM receipt_detail rd2 "
                    + "JOIN inventory i2 ON rd2.inventory_id = i2.inventory_id "
                    + "WHERE rd2.receipt_id = sc.receipt_id AND i2.generator_id = sc.generator_id "
                    + "AND i2.serial_number LIKE ?)) ");
            String like = "%" + search.trim() + "%";
            params.add(like);
            params.add(like);
            params.add(like);
        }
        if (fromDate != null && !fromDate.isEmpty()) {
            sql.append("AND DATE(sc.created_at) >= ? ");
            params.add(fromDate);
        }
        if (toDate != null && !toDate.isEmpty()) {
            sql.append("AND DATE(sc.created_at) <= ? ");
            params.add(toDate);
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

    public int insert(Connection conn, StockCard sc) throws SQLException {
        String sql = "INSERT INTO stock_card "
                + "(warehouse_id, generator_id, receipt_id, transaction_type, "
                + "quantity_change, quantity_after, reference_note, created_at, created_by) "
                + "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)";
        try (PreparedStatement ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            ps.setInt(1, sc.getWarehouseId());
            ps.setInt(2, sc.getGeneratorId());
            if (sc.getReceiptId() != null) {
                ps.setInt(3, sc.getReceiptId());
            } else {
                ps.setNull(3, Types.INTEGER);
            }
            ps.setString(4, sc.getTransactionType());
            ps.setInt(5, sc.getQuantityChange());
            ps.setInt(6, sc.getQuantityAfter());
            ps.setString(7, sc.getReferenceNote());
            LocalDateTime now = sc.getCreatedAt() != null ? sc.getCreatedAt() : LocalDateTime.now();
            ps.setTimestamp(8, Timestamp.valueOf(now));
            if (sc.getCreatedBy() != null) {
                ps.setInt(9, sc.getCreatedBy());
            } else {
                ps.setNull(9, Types.INTEGER);
            }
            ps.executeUpdate();
            try (ResultSet rs = ps.getGeneratedKeys()) {
                if (rs.next()) {
                    return rs.getInt(1);
                }
            }
        }
        return -1;
    }

    public List<StockCard> findByReceiptId(int receiptId) {
        List<StockCard> list = new ArrayList<>();
        String sql = "SELECT * FROM stock_card WHERE receipt_id = ? ORDER BY stock_card_id";
        try {
            connection = getConnection();
            statement = connection.prepareStatement(sql);
            statement.setInt(1, receiptId);
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

    @Override
    public List<StockCard> findAll() {
        throw new UnsupportedOperationException("Not supported yet."); // Generated from nbfs://nbhost/SystemFileSystem/Templates/Classes/Code/GeneratedMethodBody
    }

    @Override
    public boolean update(StockCard t) {
        throw new UnsupportedOperationException("Not supported yet."); // Generated from nbfs://nbhost/SystemFileSystem/Templates/Classes/Code/GeneratedMethodBody
    }

    @Override
    public boolean delete(StockCard t) {
        throw new UnsupportedOperationException("Not supported yet."); // Generated from nbfs://nbhost/SystemFileSystem/Templates/Classes/Code/GeneratedMethodBody
    }

    @Override
    public int insert(StockCard sc) {
        try {
            connection = getConnection();
            return insert(connection, sc);   // g?i method b�n tr�n
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            closeResources();
        }
        return -1;
    }

    @Override
    public StockCard getFromResultSet(ResultSet rs) throws SQLException {
        StockCard sc = new StockCard();
        sc.setStockCardId(rs.getInt("stock_card_id"));
        sc.setWarehouseId(rs.getInt("warehouse_id"));
        sc.setGeneratorId(rs.getInt("generator_id"));
        sc.setReceiptId((Integer) rs.getObject("receipt_id"));
        sc.setTransactionType(rs.getString("transaction_type"));
        sc.setQuantityChange(rs.getInt("quantity_change"));
        sc.setQuantityAfter(rs.getInt("quantity_after"));
        sc.setReferenceNote(rs.getString("reference_note"));
        Timestamp ca = rs.getTimestamp("created_at");
        if (ca != null) {
            sc.setCreatedAt(ca.toLocalDateTime());
        }
        sc.setCreatedBy((Integer) rs.getObject("created_by"));
        try {
            sc.setWarehouseName(rs.getString("warehouse_name"));
        } catch (SQLException ignored) {
        }
        try {
            sc.setGeneratorModel(rs.getString("generator_model"));
        } catch (SQLException ignored) {
        }
        try {
            sc.setReceiptCode(rs.getString("receipt_code"));
        } catch (SQLException ignored) {
        }
        try {
            sc.setCreatedByName(rs.getString("created_by_name"));
        } catch (SQLException ignored) {
        }
        try {
            sc.setSerialList(rs.getString("serial_list"));
        } catch (SQLException ignored) {
        }
        return sc;
    }

    // ===================== BÁO CÁO THẺ KHO =====================
    private String buildSCReportWhere(java.time.LocalDate from, java.time.LocalDate to,
                                     Integer warehouseId, Integer generatorId,
                                     String transactionType, List<Object> params) {
        StringBuilder w = new StringBuilder(" WHERE w.status <> 'locked'");
        if (from != null) {
            w.append(" AND DATE(sc.created_at) >= ?");
            params.add(java.sql.Date.valueOf(from));
        }
        if (to != null) {
            w.append(" AND DATE(sc.created_at) <= ?");
            params.add(java.sql.Date.valueOf(to));
        }
        if (warehouseId != null) {
            w.append(" AND sc.warehouse_id = ?");
            params.add(warehouseId);
        }
        if (generatorId != null) {
            w.append(" AND sc.generator_id = ?");
            params.add(generatorId);
        }
        if (transactionType != null && !transactionType.isEmpty()) {
            w.append(" AND sc.transaction_type = ?");
            params.add(transactionType);
        }
        return w.toString();
    }

    private void bindParams(PreparedStatement ps, List<Object> params) throws SQLException {
        for (int i = 0; i < params.size(); i++) {
            ps.setObject(i + 1, params.get(i));
        }
    }

    // KPI: tong giao dich, tong nhap, tong xuat, so kho
    public Map<String, Object> getStockCardReportSummary(java.time.LocalDate from, java.time.LocalDate to,
                                                       Integer warehouseId, Integer generatorId,
                                                       String transactionType) {
        Map<String, Object> m = new java.util.HashMap<>();
        List<Object> params = new ArrayList<>();
        String where = buildSCReportWhere(from, to, warehouseId, generatorId, transactionType, params);
        String sql = "SELECT COUNT(*) AS total_tx, "
                + "COALESCE(SUM(CASE WHEN sc.transaction_type = 'IMPORT' THEN sc.quantity_change ELSE 0 END), 0) AS import_qty, "
                + "COALESCE(SUM(CASE WHEN sc.transaction_type = 'EXPORT' THEN sc.quantity_change ELSE 0 END), 0) AS export_qty, "
                + "COUNT(DISTINCT sc.warehouse_id) AS warehouse_count, "
                + "COUNT(DISTINCT sc.generator_id) AS model_count "
                + "FROM stock_card sc JOIN warehouse w ON sc.warehouse_id = w.warehouse_id"
                + where;
        try {
            connection = getConnection();
            statement = connection.prepareStatement(sql);
            bindParams(statement, params);
            resultSet = statement.executeQuery();
            if (resultSet.next()) {
                int importQty = resultSet.getInt("import_qty");
                int exportQty = resultSet.getInt("export_qty");
                m.put("totalTx", resultSet.getInt("total_tx"));
                m.put("importQty", importQty);
                m.put("exportQty", exportQty);
                m.put("netChange", importQty - exportQty);
                m.put("warehouseCount", resultSet.getInt("warehouse_count"));
                m.put("modelCount", resultSet.getInt("model_count"));
            } else {
                m.put("totalTx", 0);
                m.put("importQty", 0);
                m.put("exportQty", 0);
                m.put("netChange", 0);
                m.put("warehouseCount", 0);
                m.put("modelCount", 0);
            }
        } catch (Exception e) {
            e.printStackTrace();
            System.err.println("Error getStockCardReportSummary: " + e.getMessage());
        } finally {
            closeResources();
        }
        return m;
    }

    // Phan tich theo kho: kho | so giao dich | nhap | xuat
    public List<Map<String, Object>> getStockCardByWarehouse(java.time.LocalDate from, java.time.LocalDate to,
                                                             Integer warehouseId, Integer generatorId,
                                                             String transactionType) {
        List<Map<String, Object>> list = new ArrayList<>();
        List<Object> params = new ArrayList<>();
        String where = buildSCReportWhere(from, to, warehouseId, generatorId, transactionType, params);
        String sql = "SELECT w.name AS warehouse_name, "
                + "COUNT(*) AS tx_count, "
                + "COALESCE(SUM(CASE WHEN sc.transaction_type = 'IMPORT' THEN sc.quantity_change ELSE 0 END), 0) AS import_qty, "
                + "COALESCE(SUM(CASE WHEN sc.transaction_type = 'EXPORT' THEN sc.quantity_change ELSE 0 END), 0) AS export_qty "
                + "FROM stock_card sc JOIN warehouse w ON sc.warehouse_id = w.warehouse_id"
                + where
                + " GROUP BY w.warehouse_id, w.name ORDER BY tx_count DESC";
        try {
            connection = getConnection();
            statement = connection.prepareStatement(sql);
            bindParams(statement, params);
            resultSet = statement.executeQuery();
            while (resultSet.next()) {
                Map<String, Object> r = new java.util.HashMap<>();
                r.put("warehouseName", resultSet.getString("warehouse_name"));
                r.put("txCount", resultSet.getInt("tx_count"));
                r.put("importQty", resultSet.getInt("import_qty"));
                r.put("exportQty", resultSet.getInt("export_qty"));
                list.add(r);
            }
        } catch (Exception e) {
            e.printStackTrace();
            System.err.println("Error getStockCardByWarehouse: " + e.getMessage());
        } finally {
            closeResources();
        }
        return list;
    }

    // Phan tich theo model: model | so giao dich | nhap | xuat
    public List<Map<String, Object>> getStockCardByGenerator(java.time.LocalDate from, java.time.LocalDate to,
                                                             Integer warehouseId, Integer generatorId,
                                                             String transactionType) {
        List<Map<String, Object>> list = new ArrayList<>();
        List<Object> params = new ArrayList<>();
        String where = buildSCReportWhere(from, to, warehouseId, generatorId, transactionType, params);
        String sql = "SELECT g.model AS generator_model, g.id AS generator_id, "
                + "COUNT(*) AS tx_count, "
                + "COALESCE(SUM(CASE WHEN sc.transaction_type = 'IMPORT' THEN sc.quantity_change ELSE 0 END), 0) AS import_qty, "
                + "COALESCE(SUM(CASE WHEN sc.transaction_type = 'EXPORT' THEN sc.quantity_change ELSE 0 END), 0) AS export_qty "
                + "FROM stock_card sc "
                + "JOIN warehouse w ON sc.warehouse_id = w.warehouse_id "
                + "JOIN generator g ON sc.generator_id = g.id"
                + where
                + " GROUP BY g.id, g.model ORDER BY tx_count DESC";
        try {
            connection = getConnection();
            statement = connection.prepareStatement(sql);
            bindParams(statement, params);
            resultSet = statement.executeQuery();
            while (resultSet.next()) {
                Map<String, Object> r = new java.util.HashMap<>();
                r.put("generatorModel", resultSet.getString("generator_model"));
                r.put("txCount", resultSet.getInt("tx_count"));
                r.put("importQty", resultSet.getInt("import_qty"));
                r.put("exportQty", resultSet.getInt("export_qty"));
                list.add(r);
            }
        } catch (Exception e) {
            e.printStackTrace();
            System.err.println("Error getStockCardByGenerator: " + e.getMessage());
        } finally {
            closeResources();
        }
        return list;
    }

    // Xu huong theo thang: thang | nhap | xuat | bien dong (net)
    public List<Map<String, Object>> getStockCardMonthlyTrend(java.time.LocalDate from, java.time.LocalDate to,
                                                             Integer warehouseId, Integer generatorId,
                                                             String transactionType) {
        List<Map<String, Object>> list = new ArrayList<>();
        List<Object> params = new ArrayList<>();
        String where = buildSCReportWhere(from, to, warehouseId, generatorId, transactionType, params);
        String sql = "SELECT DATE_FORMAT(sc.created_at, '%Y-%m') AS ym, "
                + "COALESCE(SUM(CASE WHEN sc.transaction_type = 'IMPORT' THEN sc.quantity_change ELSE 0 END), 0) AS import_qty, "
                + "COALESCE(SUM(CASE WHEN sc.transaction_type = 'EXPORT' THEN sc.quantity_change ELSE 0 END), 0) AS export_qty "
                + "FROM stock_card sc JOIN warehouse w ON sc.warehouse_id = w.warehouse_id"
                + where
                + " GROUP BY ym ORDER BY ym ASC";
        try {
            connection = getConnection();
            statement = connection.prepareStatement(sql);
            bindParams(statement, params);
            resultSet = statement.executeQuery();
            while (resultSet.next()) {
                Map<String, Object> r = new java.util.HashMap<>();
                r.put("month", resultSet.getString("ym"));
                r.put("importQty", resultSet.getInt("import_qty"));
                r.put("exportQty", resultSet.getInt("export_qty"));
                list.add(r);
            }
        } catch (Exception e) {
            e.printStackTrace();
            System.err.println("Error getStockCardMonthlyTrend: " + e.getMessage());
        } finally {
            closeResources();
        }
        return list;
    }

    // Chi tiet giao dich
    public List<Map<String, Object>> getStockCardDetailList(java.time.LocalDate from, java.time.LocalDate to,
                                                            Integer warehouseId, Integer generatorId,
                                                            String transactionType, int limit, int offset) {
        List<Map<String, Object>> list = new ArrayList<>();
        List<Object> params = new ArrayList<>();
        String where = buildSCReportWhere(from, to, warehouseId, generatorId, transactionType, params);
        String sql = "SELECT sc.stock_card_id, sc.warehouse_id, sc.generator_id, sc.receipt_id, "
                + "sc.transaction_type, sc.quantity_change, sc.quantity_after, "
                + "sc.reference_note, sc.created_at, "
                + "w.name AS warehouse_name, g.model AS generator_model, "
                + "r.receipt_code, "
                + "(SELECT GROUP_CONCAT(i.serial_number SEPARATOR ', ') "
                + " FROM receipt_detail rd JOIN inventory i ON rd.inventory_id = i.inventory_id "
                + " WHERE rd.receipt_id = sc.receipt_id AND i.generator_id = sc.generator_id) AS serial_list "
                + "FROM stock_card sc "
                + "LEFT JOIN warehouse w ON sc.warehouse_id = w.warehouse_id "
                + "LEFT JOIN generator g ON sc.generator_id = g.id "
                + "LEFT JOIN receipt r ON sc.receipt_id = r.receipt_id"
                + where
                + " ORDER BY sc.created_at DESC, sc.stock_card_id DESC "
                + "LIMIT ? OFFSET ?";
        params.add(limit);
        params.add(offset);
        try {
            connection = getConnection();
            statement = connection.prepareStatement(sql);
            bindParams(statement, params);
            resultSet = statement.executeQuery();
            java.time.format.DateTimeFormatter df = java.time.format.DateTimeFormatter.ofPattern("dd/MM/yyyy HH:mm");
            while (resultSet.next()) {
                Map<String, Object> r = new java.util.HashMap<>();
                r.put("stockCardId", resultSet.getInt("stock_card_id"));
                r.put("transactionType", resultSet.getString("transaction_type"));
                r.put("quantityChange", resultSet.getInt("quantity_change"));
                r.put("quantityAfter", resultSet.getInt("quantity_after"));
                r.put("warehouseName", resultSet.getString("warehouse_name"));
                r.put("generatorModel", resultSet.getString("generator_model"));
                r.put("receiptCode", resultSet.getString("receipt_code"));
                r.put("referenceNote", resultSet.getString("reference_note"));
                r.put("serialList", resultSet.getString("serial_list"));
                java.time.LocalDateTime createdAt = resultSet.getObject("created_at", java.time.LocalDateTime.class);
                r.put("createdAtStr", createdAt != null ? createdAt.format(df) : "");
                list.add(r);
            }
        } catch (Exception e) {
            e.printStackTrace();
            System.err.println("Error getStockCardDetailList: " + e.getMessage());
        } finally {
            closeResources();
        }
        return list;
    }

    public int countStockCardDetailList(java.time.LocalDate from, java.time.LocalDate to,
                                        Integer warehouseId, Integer generatorId,
                                        String transactionType) {
        List<Object> params = new ArrayList<>();
        String where = buildSCReportWhere(from, to, warehouseId, generatorId, transactionType, params);
        String sql = "SELECT COUNT(*) FROM stock_card sc JOIN warehouse w ON sc.warehouse_id = w.warehouse_id" + where;
        try {
            connection = getConnection();
            statement = connection.prepareStatement(sql);
            bindParams(statement, params);
            resultSet = statement.executeQuery();
            if (resultSet.next()) return resultSet.getInt(1);
        } catch (Exception e) {
            e.printStackTrace();
            System.err.println("Error countStockCardDetailList: " + e.getMessage());
        } finally {
            closeResources();
        }
        return 0;
    }

    // ===================== BALANCE SNAPSHOT (dùng cho báo cáo tồn kho) =====================

    public Map<String, Integer> getBalanceSnapshot(Integer warehouseId, String beforeDate) {
        Map<String, Integer> result = new HashMap<>();
        String sql = "SELECT sc.warehouse_id, sc.generator_id, sc.quantity_after"
                + " FROM stock_card sc"
                + " INNER JOIN ("
                + "  SELECT warehouse_id, generator_id, MAX(stock_card_id) AS max_id"
                + "  FROM stock_card"
                + "  WHERE created_at < ?"
                + (warehouseId != null ? " AND warehouse_id = ?" : "")
                + "  GROUP BY warehouse_id, generator_id"
                + " ) latest ON sc.stock_card_id = latest.max_id";
        List<Object> params = new ArrayList<>();
        params.add(beforeDate);
        if (warehouseId != null) params.add(warehouseId);
        try {
            connection = getConnection();
            statement = connection.prepareStatement(sql);
            for (int i = 0; i < params.size(); i++) {
                statement.setObject(i + 1, params.get(i));
            }
            resultSet = statement.executeQuery();
            while (resultSet.next()) {
                String key = resultSet.getInt("warehouse_id") + "_" + resultSet.getInt("generator_id");
                result.put(key, resultSet.getInt("quantity_after"));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            closeResources();
        }
        return result;
    }

    public Set<String> getDistinctWhGenBefore(Integer warehouseId, String beforeDate) {
        Set<String> result = new HashSet<>();
        String sql = "SELECT DISTINCT warehouse_id, generator_id FROM stock_card WHERE created_at < ?"
                + (warehouseId != null ? " AND warehouse_id = ?" : "");
        List<Object> params = new ArrayList<>();
        params.add(beforeDate);
        if (warehouseId != null) params.add(warehouseId);
        try {
            connection = getConnection();
            statement = connection.prepareStatement(sql);
            for (int i = 0; i < params.size(); i++) {
                statement.setObject(i + 1, params.get(i));
            }
            resultSet = statement.executeQuery();
            while (resultSet.next()) {
                result.add(resultSet.getInt("warehouse_id") + "_" + resultSet.getInt("generator_id"));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            closeResources();
        }
        return result;
    }

    // ===================== END BÁO CÁO THẺ KHO =====================
}