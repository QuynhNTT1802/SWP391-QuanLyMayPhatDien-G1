/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package com.quanlymayphatdien.g1.dal;

import com.quanlymayphatdien.g1.utils.LogModule;
import com.quanlymayphatdien.g1.entity.Warehouse;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.List;

/**
 *
 * @author FPTShop
 */
public class WarehouseDAO extends DBContext implements I_DAO<Warehouse> {

    public List<Warehouse> findWithSearch(String search, int page, int pageSize) {
        List<Warehouse> list = new ArrayList<>();
        String base = "SELECT w.*, "
                + "  COALESCE((SELECT COUNT(*) FROM inventory i WHERE i.warehouse_id = w.warehouse_id AND i.status = 'IN_STOCK'), 0) AS total_inventory, "
                + "  (SELECT COUNT(DISTINCT i.generator_id) FROM inventory i WHERE i.warehouse_id = w.warehouse_id AND i.status = 'IN_STOCK') AS item_count "
                + "FROM warehouse w ";
        String where = "";
        if (search != null && !search.trim().isEmpty()) {
            where = "WHERE w.name LIKE ? OR w.address LIKE ? ";
        }
        String sql = base + where + "ORDER BY w.status, w.name LIMIT ? OFFSET ?";
        try (Connection c = getConnection(); PreparedStatement ps = c.prepareStatement(sql)) {
            int idx = 1;
            if (search != null && !search.trim().isEmpty()) {
                String like = "%" + search.trim() + "%";
                ps.setString(idx++, like);
                ps.setString(idx++, like);
            }
            ps.setInt(idx++, pageSize);
            ps.setInt(idx++, (page - 1) * pageSize);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                list.add(getFromResultSet(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    public int countWithSearch(String search) {
        String sql = "SELECT COUNT(*) FROM warehouse w WHERE 1=1 ";
        if (search != null && !search.trim().isEmpty()) {
            sql += "AND (w.name LIKE ? OR w.address LIKE ?) ";
        }
        try (Connection c = getConnection(); PreparedStatement ps = c.prepareStatement(sql)) {
            if (search != null && !search.trim().isEmpty()) {
                String like = "%" + search.trim() + "%";
                ps.setString(1, like);
                ps.setString(2, like);
            }
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }
    @Override
    public List<Warehouse> findAll() {
        List<Warehouse> list = new ArrayList<>();
        String sql = "SELECT w.*, "
                + "  COALESCE((SELECT COUNT(*) FROM inventory i WHERE i.warehouse_id = w.warehouse_id AND i.status = 'IN_STOCK'), 0) AS total_inventory "
                + "FROM warehouse w "
                + "WHERE w.status = 'active' "
                + "ORDER BY w.warehouse_id";
        try (Connection c = getConnection(); PreparedStatement ps = c.prepareStatement(sql); ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                list.add(getFromResultSet(rs));
            }
        } catch (SQLException e) {
            com.quanlymayphatdien.g1.utils.SystemLogger.error(LogModule.SYSTEM, "Loi Ngoai Le", e.getMessage() != null ? e.getMessage() : e.getClass().getName(), e);
        }
        return list;
    }

    public Warehouse findById(int id) {
        String sql = "SELECT w.*, "
                + "  COALESCE((SELECT COUNT(*) FROM inventory i WHERE i.warehouse_id = w.warehouse_id AND i.status = 'IN_STOCK'), 0) AS total_inventory "
                + "FROM warehouse w "
                + "WHERE w.warehouse_id = ?";
        try (Connection c = getConnection();
             PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setInt(1, id);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return getFromResultSet(rs);
            }
        } catch (SQLException e) {
            com.quanlymayphatdien.g1.utils.SystemLogger.error(LogModule.SYSTEM, "Loi Ngoai Le", e.getMessage() != null ? e.getMessage() : e.getClass().getName(), e);
        }
        return null;
    }

    @Override
    public boolean update(Warehouse w) {
        String sql = "UPDATE warehouse SET name = ?, address = ?, description = ?, status = ?, updated_at = ? WHERE warehouse_id = ?";
        try (Connection c = getConnection(); PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setString(1, w.getName());
            ps.setString(2, w.getAddress());
            ps.setString(3, w.getDescription());
            ps.setString(4, w.getStatus());
            ps.setTimestamp(5, w.getUpdatedAt() != null ? Timestamp.valueOf(w.getUpdatedAt()) : Timestamp.valueOf(java.time.LocalDateTime.now()));
            ps.setInt(6, w.getWarehouseId());
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            com.quanlymayphatdien.g1.utils.SystemLogger.error(LogModule.SYSTEM, "Loi Ngoai Le", e.getMessage() != null ? e.getMessage() : e.getClass().getName(), e);
        }
        return false;
    }

    @Override
    public boolean delete(Warehouse t) {
        throw new UnsupportedOperationException("Not supported yet."); // Generated from nbfs://nbhost/SystemFileSystem/Templates/Classes/Code/GeneratedMethodBody
    }

    @Override
    public int insert(Warehouse t) {
        throw new UnsupportedOperationException("Not supported yet."); // Generated from nbfs://nbhost/SystemFileSystem/Templates/Classes/Code/GeneratedMethodBody
    }

    public boolean lock(int id) {
        String sql = "UPDATE warehouse SET status = 'locked', updated_at = CURRENT_TIMESTAMP WHERE warehouse_id = ?";
        try (Connection c = getConnection(); PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setInt(1, id);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean unlock(int id) {
        String sql = "UPDATE warehouse SET status = 'active', updated_at = CURRENT_TIMESTAMP WHERE warehouse_id = ?";
        try (Connection c = getConnection(); PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setInt(1, id);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    @Override
    public Warehouse getFromResultSet(ResultSet rs) throws SQLException {
        Warehouse w = new Warehouse();
        w.setWarehouseId(rs.getInt("warehouse_id"));
        w.setName(rs.getString("name"));
        w.setAddress(rs.getString("address"));
        w.setDescription(rs.getString("description"));
        w.setStatus(rs.getString("status"));

        Timestamp ca = rs.getTimestamp("created_at");
        if (ca != null) {
            w.setCreatedAt(ca.toLocalDateTime());
        }

        Timestamp ua = rs.getTimestamp("updated_at");
        if (ua != null) {
            w.setUpdatedAt(ua.toLocalDateTime());
        }

        try {
            w.setTotalInventory(rs.getInt("total_inventory"));
        } catch (SQLException ignored) {
        }
        try {
            w.setItemCount(rs.getInt("item_count"));
        } catch (SQLException ignored) {
        }
        return w;
    }

}
