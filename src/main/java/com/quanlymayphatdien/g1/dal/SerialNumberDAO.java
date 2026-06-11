package com.quanlymayphatdien.g1.dal;

import com.quanlymayphatdien.g1.entity.SerialNumber;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class SerialNumberDAO extends DBContext {

    public List<SerialNumber> findByWarehouseAndGeneratorAndStatus(int warehouseId, int generatorId, String status) {
        List<SerialNumber> list = new ArrayList<>();
        String sql = "SELECT sn.*, g.model as generator_name FROM serial_number sn " +
                     "JOIN generator g ON sn.generator_id = g.id " +
                     "WHERE sn.warehouse_id = ? AND sn.generator_id = ? AND sn.status = ?";
        try {
            Connection conn = getConnection();
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setInt(1, warehouseId);
            ps.setInt(2, generatorId);
            ps.setString(3, status);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                SerialNumber sn = new SerialNumber();
                sn.setId(rs.getInt("id"));
                sn.setGeneratorId(rs.getInt("generator_id"));
                sn.setSerialNumber(rs.getString("serial_number"));
                sn.setWarehouseId(rs.getInt("warehouse_id"));
                sn.setStatus(rs.getString("status"));
                if (rs.getTimestamp("created_at") != null) sn.setCreatedAt(rs.getTimestamp("created_at").toLocalDateTime());
                if (rs.getTimestamp("updated_at") != null) sn.setUpdatedAt(rs.getTimestamp("updated_at").toLocalDateTime());
                sn.setGeneratorName(rs.getString("generator_name"));
                list.add(sn);
            }
            rs.close();
            ps.close();
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    public boolean updateStatus(String serialNumber, String newStatus) {
        String sql = "UPDATE serial_number SET status = ? WHERE serial_number = ?";
        try {
            Connection conn = getConnection();
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setString(1, newStatus);
            ps.setString(2, serialNumber);
            int rows = ps.executeUpdate();
            ps.close();
            return rows > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    // Migration method to generate initial serials from receipts and inventory
    // To simplify, we will just copy distinct serials from receipt_detail that are IMPORT type.
    // However, the actual logic might need to match with inventory counts.
    // For now, we will assume all imported serials that are not exported are IN_STOCK.
    public void migrateFromReceiptDetail() {
        String sql = "INSERT IGNORE INTO serial_number (generator_id, serial_number, warehouse_id, status) " +
                     "SELECT rd.generator_id, rd.serial_number, r.warehouse_id, 'IN_STOCK' " +
                     "FROM receipt_detail rd " +
                     "JOIN receipt r ON rd.receipt_id = r.receipt_id " +
                     "WHERE r.receipt_type = 'IMPORT' " +
                     "AND r.status = 'COMPLETED'";
        try {
            Connection conn = getConnection();
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.executeUpdate();
            ps.close();
            
            // Mark as SOLD or EXPORTED based on EXPORT receipts
            String updateSql = "UPDATE serial_number sn " +
                               "JOIN receipt_detail rd ON sn.serial_number = rd.serial_number " +
                               "JOIN receipt r ON rd.receipt_id = r.receipt_id " +
                               "SET sn.status = 'SOLD' " +
                               "WHERE r.receipt_type = 'EXPORT' AND r.status = 'COMPLETED'";
            PreparedStatement ps2 = conn.prepareStatement(updateSql);
            ps2.executeUpdate();
            ps2.close();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
}
