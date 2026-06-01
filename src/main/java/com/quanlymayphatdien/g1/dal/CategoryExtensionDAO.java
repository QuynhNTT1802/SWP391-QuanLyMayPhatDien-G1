package com.quanlymayphatdien.g1.dal;

import com.quanlymayphatdien.g1.entity.*;
import java.math.BigDecimal;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

public class CategoryExtensionDAO extends DBContext {

    public void saveBrand(CategoryBrand brand) {
        delete("category_brand", brand.getCategoryId());
        String sql = "INSERT INTO category_brand (category_id, country, website, founded_year, warranty_period) VALUES (?,?,?,?,?)";
        try (Connection c = getConnection();
             PreparedStatement p = c.prepareStatement(sql)) {
            p.setInt(1, brand.getCategoryId());
            p.setString(2, brand.getCountry());
            p.setString(3, brand.getWebsite());
            if (brand.getFoundedYear() != null) p.setInt(4, brand.getFoundedYear());
            else p.setNull(4, java.sql.Types.INTEGER);
            if (brand.getWarrantyPeriod() != null) p.setInt(5, brand.getWarrantyPeriod());
            else p.setNull(5, java.sql.Types.INTEGER);
            p.executeUpdate();
        } catch (SQLException e) { e.printStackTrace(); }
    }

    public CategoryBrand findBrand(int categoryId) {
        String sql = "SELECT * FROM category_brand WHERE category_id = ?";
        try (Connection c = getConnection();
             PreparedStatement p = c.prepareStatement(sql)) {
            p.setInt(1, categoryId);
            try (ResultSet rs = p.executeQuery()) {
                if (rs.next()) {
                    CategoryBrand b = new CategoryBrand();
                    b.setCategoryId(categoryId);
                    b.setCountry(rs.getString("country"));
                    b.setWebsite(rs.getString("website"));
                    b.setFoundedYear(rs.getInt("founded_year"));
                    if (rs.wasNull()) b.setFoundedYear(null);
                    b.setWarrantyPeriod(rs.getInt("warranty_period"));
                    if (rs.wasNull()) b.setWarrantyPeriod(null);
                    return b;
                }
            }
        } catch (SQLException e) { e.printStackTrace(); }
        return null;
    }

    public void saveFuelType(CategoryFuelType ft) {
        delete("category_fuel_type", ft.getCategoryId());
        String sql = "INSERT INTO category_fuel_type (category_id, unit, typical_price) VALUES (?,?,?)";
        try (Connection c = getConnection();
             PreparedStatement p = c.prepareStatement(sql)) {
            p.setInt(1, ft.getCategoryId());
            p.setString(2, ft.getUnit());
            if (ft.getTypicalPrice() != null) p.setBigDecimal(3, ft.getTypicalPrice());
            else p.setNull(3, java.sql.Types.DECIMAL);
            p.executeUpdate();
        } catch (SQLException e) { e.printStackTrace(); }
    }

    public CategoryFuelType findFuelType(int categoryId) {
        String sql = "SELECT * FROM category_fuel_type WHERE category_id = ?";
        try (Connection c = getConnection();
             PreparedStatement p = c.prepareStatement(sql)) {
            p.setInt(1, categoryId);
            try (ResultSet rs = p.executeQuery()) {
                if (rs.next()) {
                    CategoryFuelType ft = new CategoryFuelType();
                    ft.setCategoryId(categoryId);
                    ft.setUnit(rs.getString("unit"));
                    BigDecimal price = rs.getBigDecimal("typical_price");
                    if (!rs.wasNull()) ft.setTypicalPrice(price);
                    return ft;
                }
            }
        } catch (SQLException e) { e.printStackTrace(); }
        return null;
    }

    public void saveOrigin(CategoryOrigin origin) {
        delete("category_origin", origin.getCategoryId());
        String sql = "INSERT INTO category_origin (category_id, country_code) VALUES (?,?)";
        try (Connection c = getConnection();
             PreparedStatement p = c.prepareStatement(sql)) {
            p.setInt(1, origin.getCategoryId());
            p.setString(2, origin.getCountryCode());
            p.executeUpdate();
        } catch (SQLException e) { e.printStackTrace(); }
    }

    public CategoryOrigin findOrigin(int categoryId) {
        String sql = "SELECT * FROM category_origin WHERE category_id = ?";
        try (Connection c = getConnection();
             PreparedStatement p = c.prepareStatement(sql)) {
            p.setInt(1, categoryId);
            try (ResultSet rs = p.executeQuery()) {
                if (rs.next()) {
                    CategoryOrigin o = new CategoryOrigin();
                    o.setCategoryId(categoryId);
                    o.setCountryCode(rs.getString("country_code"));
                    return o;
                }
            }
        } catch (SQLException e) { e.printStackTrace(); }
        return null;
    }

    public void saveCustomerType(CategoryCustomerType ct) {
        delete("category_customer_type", ct.getCategoryId());
        String sql = "INSERT INTO category_customer_type (category_id, tax_type) VALUES (?,?)";
        try (Connection c = getConnection();
             PreparedStatement p = c.prepareStatement(sql)) {
            p.setInt(1, ct.getCategoryId());
            p.setString(2, ct.getTaxType());
            p.executeUpdate();
        } catch (SQLException e) { e.printStackTrace(); }
    }

    public CategoryCustomerType findCustomerType(int categoryId) {
        String sql = "SELECT * FROM category_customer_type WHERE category_id = ?";
        try (Connection c = getConnection();
             PreparedStatement p = c.prepareStatement(sql)) {
            p.setInt(1, categoryId);
            try (ResultSet rs = p.executeQuery()) {
                if (rs.next()) {
                    CategoryCustomerType ct = new CategoryCustomerType();
                    ct.setCategoryId(categoryId);
                    ct.setTaxType(rs.getString("tax_type"));
                    return ct;
                }
            }
        } catch (SQLException e) { e.printStackTrace(); }
        return null;
    }

    public void insertEmptyExtension(String tableName, int categoryId) {
        String sql = "INSERT INTO " + tableName + " (category_id) VALUES (?)";
        try (Connection c = getConnection();
             PreparedStatement p = c.prepareStatement(sql)) {
            p.setInt(1, categoryId);
            p.executeUpdate();
        } catch (SQLException e) { e.printStackTrace(); }
    }

    public void deleteExtension(String tableName, int categoryId) {
        delete(tableName, categoryId);
    }

    private void delete(String tableName, int categoryId) {
        String sql = "DELETE FROM " + tableName + " WHERE category_id = ?";
        try (Connection c = getConnection();
             PreparedStatement p = c.prepareStatement(sql)) {
            p.setInt(1, categoryId);
            p.executeUpdate();
        } catch (SQLException e) { e.printStackTrace(); }
    }

    public Object findExtension(String type, int categoryId) {
        switch (type) {
            case "brand":          return findBrand(categoryId);
            case "fuel_type":      return findFuelType(categoryId);
            case "origin":         return findOrigin(categoryId);
            case "customer_type":  return findCustomerType(categoryId);
            default: return null;
        }
    }

    public java.util.Map<Integer, Object> loadExtensionsByType(String type, java.util.List<Integer> catIds) {
        java.util.Map<Integer, Object> map = new java.util.LinkedHashMap<>();
        if (catIds == null || catIds.isEmpty()) return map;
        switch (type) {
            case "brand": {
                String sql = "SELECT b.*, c.name FROM category_brand b JOIN category c ON b.category_id=c.id WHERE b.category_id IN (" + idsPlaceholder(catIds) + ")";
                try (Connection conn = getConnection(); PreparedStatement p = conn.prepareStatement(sql)) {
                    int i = 1; for (Integer id : catIds) p.setInt(i++, id);
                    try (ResultSet rs = p.executeQuery()) {
                        while (rs.next()) {
                            CategoryBrand b = new CategoryBrand();
                            int cid = rs.getInt("category_id");
                            b.setCategoryId(cid);
                            b.setCountry(rs.getString("country"));
                            b.setWebsite(rs.getString("website"));
                            b.setFoundedYear(rs.getInt("founded_year"));
                            if (rs.wasNull()) b.setFoundedYear(null);
                            b.setWarrantyPeriod(rs.getInt("warranty_period"));
                            if (rs.wasNull()) b.setWarrantyPeriod(null);
                            map.put(cid, b);
                        }
                    }
                } catch (SQLException e) { e.printStackTrace(); }
                break;
            }
            case "fuel_type": {
                String sql = "SELECT * FROM category_fuel_type WHERE category_id IN (" + idsPlaceholder(catIds) + ")";
                try (Connection conn = getConnection(); PreparedStatement p = conn.prepareStatement(sql)) {
                    int i = 1; for (Integer id : catIds) p.setInt(i++, id);
                    try (ResultSet rs = p.executeQuery()) {
                        while (rs.next()) {
                            CategoryFuelType ft = new CategoryFuelType();
                            int cid = rs.getInt("category_id");
                            ft.setCategoryId(cid);
                            ft.setUnit(rs.getString("unit"));
                            java.math.BigDecimal pr = rs.getBigDecimal("typical_price");
                            if (!rs.wasNull()) ft.setTypicalPrice(pr);
                            map.put(cid, ft);
                        }
                    }
                } catch (SQLException e) { e.printStackTrace(); }
                break;
            }
            case "origin": {
                String sql = "SELECT * FROM category_origin WHERE category_id IN (" + idsPlaceholder(catIds) + ")";
                try (Connection conn = getConnection(); PreparedStatement p = conn.prepareStatement(sql)) {
                    int i = 1; for (Integer id : catIds) p.setInt(i++, id);
                    try (ResultSet rs = p.executeQuery()) {
                        while (rs.next()) {
                            CategoryOrigin o = new CategoryOrigin();
                            int cid = rs.getInt("category_id");
                            o.setCategoryId(cid);
                            o.setCountryCode(rs.getString("country_code"));
                            map.put(cid, o);
                        }
                    }
                } catch (SQLException e) { e.printStackTrace(); }
                break;
            }
            case "customer_type": {
                String sql = "SELECT * FROM category_customer_type WHERE category_id IN (" + idsPlaceholder(catIds) + ")";
                try (Connection conn = getConnection(); PreparedStatement p = conn.prepareStatement(sql)) {
                    int i = 1; for (Integer id : catIds) p.setInt(i++, id);
                    try (ResultSet rs = p.executeQuery()) {
                        while (rs.next()) {
                            CategoryCustomerType ct = new CategoryCustomerType();
                            int cid = rs.getInt("category_id");
                            ct.setCategoryId(cid);
                            ct.setTaxType(rs.getString("tax_type"));
                            map.put(cid, ct);
                        }
                    }
                } catch (SQLException e) { e.printStackTrace(); }
                break;
            }
        }
        return map;
    }

    private String idsPlaceholder(java.util.List<Integer> ids) {
        StringBuilder sb = new StringBuilder();
        for (int i = 0; i < ids.size(); i++) { if (i > 0) sb.append(","); sb.append("?"); }
        return sb.toString();
    }
}
