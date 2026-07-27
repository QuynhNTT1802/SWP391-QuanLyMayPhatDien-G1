package com.quanlymayphatdien.g1.dal;

import java.sql.SQLException;
import java.time.LocalDate;
import java.util.ArrayList;
import java.util.List;

public class BaseReportDAO extends DBContext {

    protected static String firstDay(int month, int year) {
        return String.format("%04d-%02d-01", year, month);
    }
    protected static String lastDay(int month, int year) {
        return LocalDate.of(year, month, 1).plusMonths(1).minusDays(1).toString();
    }
    protected static String nextDay(int month, int year) {
        return LocalDate.of(year, month, 1).plusMonths(1).toString();
    }

    protected int countWithParams(String sql, List<Object> params) {
        try {
            connection = getConnection();
            statement = connection.prepareStatement(sql);
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

    protected List<Object[]> queryFlat(String sql, List<Object> params) {
        List<Object[]> result = new ArrayList<>();
        try {
            connection = getConnection();
            statement = connection.prepareStatement(sql);
            for (int i = 0; i < params.size(); i++) {
                statement.setObject(i + 1, params.get(i));
            }
            resultSet = statement.executeQuery();
            int colCount = resultSet.getMetaData().getColumnCount();
            while (resultSet.next()) {
                Object[] row = new Object[colCount];
                for (int i = 0; i < colCount; i++) {
                    row[i] = resultSet.getObject(i + 1);
                }
                result.add(row);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            closeResources();
        }
        return result;
    }

    protected List<Object> params(int month, int year, Integer warehouseId) {
        List<Object> p = new ArrayList<>();
        p.add(firstDay(month, year));
        p.add(lastDay(month, year));
        if (warehouseId != null) p.add(warehouseId);
        return p;
    }
}
