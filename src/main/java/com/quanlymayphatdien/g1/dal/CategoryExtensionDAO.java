package com.quanlymayphatdien.g1.dal;

import com.quanlymayphatdien.g1.entity.*;
import java.math.BigDecimal;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Types;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

public class CategoryExtensionDAO extends DBContext {

    public void saveBrand(CategoryBrand brand) {
        delete("category_brand", brand.getCategoryId());
        String sql = "INSERT INTO category_brand (category_id, country, website, founded_year, warranty_period) VALUES (?,?,?,?,?)";
        try {
            connection = getConnection();
            statement = connection.prepareStatement(sql);
            statement.setInt(1, brand.getCategoryId());
            statement.setString(2, brand.getCountry());
            statement.setString(3, brand.getWebsite());
            if (brand.getFoundedYear() != null) {
                statement.setInt(4, brand.getFoundedYear());
            } else {
                statement.setNull(4, java.sql.Types.INTEGER);
            }
            if (brand.getWarrantyPeriod() != null) {
                statement.setInt(5, brand.getWarrantyPeriod());
            } else {
                statement.setNull(5, java.sql.Types.INTEGER);
            }
            statement.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            closeResources();
        }
    }

    public CategoryBrand findBrand(int categoryId) {
        CategoryBrand result = null;
        String sql = "SELECT * FROM category_brand WHERE category_id = ?";
        try {
            connection = getConnection();
            statement = connection.prepareStatement(sql);
            statement.setInt(1, categoryId);
            resultSet = statement.executeQuery();
            if (resultSet.next()) {
                CategoryBrand b = new CategoryBrand();
                b.setCategoryId(categoryId);
                b.setCountry(resultSet.getString("country"));
                b.setWebsite(resultSet.getString("website"));
                b.setFoundedYear(resultSet.getInt("founded_year"));
                if (resultSet.wasNull()) {
                    b.setFoundedYear(null);
                }
                b.setWarrantyPeriod(resultSet.getInt("warranty_period"));
                if (resultSet.wasNull()) {
                    b.setWarrantyPeriod(null);
                }
                result = b;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            closeResources();
        }
        return result;
    }

    public void saveFuelType(CategoryFuelType ft) {
        delete("category_fuel_type", ft.getCategoryId());
        String sql = "INSERT INTO category_fuel_type (category_id, unit, typical_price) VALUES (?,?,?)";
        try {
            connection = getConnection();
            statement = connection.prepareStatement(sql);
            statement.setInt(1, ft.getCategoryId());
            statement.setString(2, ft.getUnit());
            if (ft.getTypicalPrice() != null) {
                statement.setBigDecimal(3, ft.getTypicalPrice());
            } else {
                statement.setNull(3, Types.DECIMAL);
            }
            statement.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            closeResources();
        }
    }

    public CategoryFuelType findFuelType(int categoryId) {
        CategoryFuelType result = null;
        String sql = "SELECT * FROM category_fuel_type WHERE category_id = ?";
        try {
            connection = getConnection();
            statement = connection.prepareStatement(sql);
            statement.setInt(1, categoryId);
            resultSet = statement.executeQuery();
            if (resultSet.next()) {
                CategoryFuelType ft = new CategoryFuelType();
                ft.setCategoryId(categoryId);
                ft.setUnit(resultSet.getString("unit"));
                BigDecimal price = resultSet.getBigDecimal("typical_price");
                if (!resultSet.wasNull()) {
                    ft.setTypicalPrice(price);
                }
                result = ft;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            closeResources();
        }
        return result;
    }

    public void saveOrigin(CategoryOrigin origin) {
        delete("category_origin", origin.getCategoryId());
        String sql = "INSERT INTO category_origin (category_id, country_code) VALUES (?,?)";
        try {
            connection = getConnection();
            statement = connection.prepareStatement(sql);
            statement.setInt(1, origin.getCategoryId());
            statement.setString(2, origin.getCountryCode());
            statement.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            closeResources();
        }
    }

    public CategoryOrigin findOrigin(int categoryId) {
        CategoryOrigin result = null;
        String sql = "SELECT * FROM category_origin WHERE category_id = ?";
        try {
            connection = getConnection();
            statement = connection.prepareStatement(sql);
            statement.setInt(1, categoryId);
            resultSet = statement.executeQuery();
            if (resultSet.next()) {
                CategoryOrigin o = new CategoryOrigin();
                o.setCategoryId(categoryId);
                o.setCountryCode(resultSet.getString("country_code"));
                result = o;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            closeResources();
        }
        return result;
    }

    public void saveCustomerType(CategoryCustomerType ct) {
        delete("category_customer_type", ct.getCategoryId());
        String sql = "INSERT INTO category_customer_type (category_id, tax_type) VALUES (?,?)";
        try {
            connection = getConnection();
            statement = connection.prepareStatement(sql);
            statement.setInt(1, ct.getCategoryId());
            statement.setString(2, ct.getTaxType());
            statement.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            closeResources();
        }
    }

    public CategoryCustomerType findCustomerType(int categoryId) {
        CategoryCustomerType result = null;
        String sql = "SELECT * FROM category_customer_type WHERE category_id = ?";
        try {
            connection = getConnection();
            statement = connection.prepareStatement(sql);
            statement.setInt(1, categoryId);
            resultSet = statement.executeQuery();
            if (resultSet.next()) {
                CategoryCustomerType ct = new CategoryCustomerType();
                ct.setCategoryId(categoryId);
                ct.setTaxType(resultSet.getString("tax_type"));
                result = ct;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            closeResources();
        }
        return result;
    }

    public void insertEmptyExtension(String tableName, int categoryId) {

        delete(tableName, categoryId);
        String sql = "INSERT INTO " + tableName + " (category_id) VALUES (?)";
        try {
            connection = getConnection();
            statement = connection.prepareStatement(sql);
            statement.setInt(1, categoryId);
            statement.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            closeResources();
        }
    }

    public void deleteExtension(String tableName, int categoryId) {
        delete(tableName, categoryId);
    }

    private void delete(String tableName, int categoryId) {
        String sql = "DELETE FROM " + tableName + " WHERE category_id = ?";
        try {
            connection = getConnection();
            statement = connection.prepareStatement(sql);
            statement.setInt(1, categoryId);
            statement.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            closeResources();
        }
    }

    public Object findExtension(String type, int categoryId) {
        switch (type) {
            case "brand":
                return findBrand(categoryId);
            case "fuel_type":
                return findFuelType(categoryId);
            case "origin":
                return findOrigin(categoryId);
            case "customer_type":
                return findCustomerType(categoryId);
            default:
                return null;
        }
    }

    public Map<Integer, Object> loadExtensionsByType(String type, List<Integer> catIds) {
        Map<Integer, Object> map = new LinkedHashMap<>();
        if (catIds == null || catIds.isEmpty()) {
            return map;
        }
        switch (type) {
            case "brand": {
                String sql = "SELECT b.*, c.name FROM category_brand b JOIN category c ON b.category_id=c.id WHERE b.category_id IN (" + idsPlaceholder(catIds) + ")";
                try {
                    connection = getConnection();
                    statement = connection.prepareStatement(sql);
                    int i = 1;
                    for (Integer id : catIds) {
                        statement.setInt(i++, id);
                    }
                    resultSet = statement.executeQuery();
                    while (resultSet.next()) {
                        CategoryBrand b = new CategoryBrand();
                        int cid = resultSet.getInt("category_id");
                        b.setCategoryId(cid);
                        b.setCountry(resultSet.getString("country"));
                        b.setWebsite(resultSet.getString("website"));
                        b.setFoundedYear(resultSet.getInt("founded_year"));
                        if (resultSet.wasNull()) {
                            b.setFoundedYear(null);
                        }
                        b.setWarrantyPeriod(resultSet.getInt("warranty_period"));
                        if (resultSet.wasNull()) {
                            b.setWarrantyPeriod(null);
                        }
                        map.put(cid, b);
                    }
                } catch (SQLException e) {
                    e.printStackTrace();
                } finally {
                    closeResources();
                }
                break;
            }
            case "fuel_type": {
                String sql = "SELECT * FROM category_fuel_type WHERE category_id IN (" + idsPlaceholder(catIds) + ")";
                try {
                    connection = getConnection();
                    statement = connection.prepareStatement(sql);
                    int i = 1;
                    for (Integer id : catIds) {
                        statement.setInt(i++, id);
                    }
                    resultSet = statement.executeQuery();
                    while (resultSet.next()) {
                        CategoryFuelType ft = new CategoryFuelType();
                        int cid = resultSet.getInt("category_id");
                        ft.setCategoryId(cid);
                        ft.setUnit(resultSet.getString("unit"));
                        java.math.BigDecimal pr = resultSet.getBigDecimal("typical_price");
                        if (!resultSet.wasNull()) {
                            ft.setTypicalPrice(pr);
                        }
                        map.put(cid, ft);
                    }
                } catch (SQLException e) {
                    e.printStackTrace();
                } finally {
                    closeResources();
                }
                break;
            }
            case "origin": {
                String sql = "SELECT * FROM category_origin WHERE category_id IN (" + idsPlaceholder(catIds) + ")";
                try {
                    connection = getConnection();
                    statement = connection.prepareStatement(sql);
                    int i = 1;
                    for (Integer id : catIds) {
                        statement.setInt(i++, id);
                    }
                    resultSet = statement.executeQuery();
                    while (resultSet.next()) {
                        CategoryOrigin o = new CategoryOrigin();
                        int cid = resultSet.getInt("category_id");
                        o.setCategoryId(cid);
                        o.setCountryCode(resultSet.getString("country_code"));
                        map.put(cid, o);
                    }
                } catch (SQLException e) {
                    e.printStackTrace();
                } finally {
                    closeResources();
                }
                break;
            }
            case "customer_type": {
                String sql = "SELECT * FROM category_customer_type WHERE category_id IN (" + idsPlaceholder(catIds) + ")";
                try {
                    connection = getConnection();
                    statement = connection.prepareStatement(sql);
                    int i = 1;
                    for (Integer id : catIds) {
                        statement.setInt(i++, id);
                    }
                    resultSet = statement.executeQuery();
                    while (resultSet.next()) {
                        CategoryCustomerType ct = new CategoryCustomerType();
                        int cid = resultSet.getInt("category_id");
                        ct.setCategoryId(cid);
                        ct.setTaxType(resultSet.getString("tax_type"));
                        map.put(cid, ct);
                    }
                } catch (SQLException e) {
                    e.printStackTrace();
                } finally {
                    closeResources();
                }
                break;
            }
        }
        return map;
    }

    private String idsPlaceholder(List<Integer> ids) {
        StringBuilder sb = new StringBuilder();
        for (int i = 0; i < ids.size(); i++) {
            if (i > 0) {
                sb.append(",");
            }
            sb.append("?");
        }
        return sb.toString();
    }
}