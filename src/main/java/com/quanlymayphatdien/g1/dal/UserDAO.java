package com.quanlymayphatdien.g1.dal;

import com.quanlymayphatdien.g1.entity.User;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.sql.Timestamp;
import java.sql.Types;
import java.util.ArrayList;
import java.util.List;

public class UserDAO extends DBContext implements I_DAO<User> {

    @Override
    public List<User> findAll() {
        List<User> list = new ArrayList<>();
        String sql = "SELECT * FROM user";
        try {
            connection = getConnection();
            statement = connection.prepareStatement(sql);
            resultSet = statement.executeQuery();
            while (resultSet.next()) {
                list.add(getFromResultSet(resultSet));
            }
        } catch (SQLException e) {
            System.out.println(e.getMessage());
        }
        return list;
    }

    @Override
    public boolean update(User user) {
        String sql = "UPDATE user SET name = ?, username = ?, email = ?, phone = ?, "
                + "address = ?, status = ?, updated_at = ?, updated_by = ? WHERE id = ?";
        try {

            connection = getConnection();
            statement = connection.prepareStatement(sql);
            statement.setString(1, user.getName());
            statement.setString(2, user.getUsername());
            statement.setString(3, user.getEmail());
            statement.setString(4, user.getPhone());
            statement.setString(5, user.getAddress());
            statement.setString(6, user.getStatus());
            statement.setTimestamp(7, Timestamp.valueOf(user.getUpdatedAt()));
            statement.setNull(8, Types.INTEGER);
            statement.setInt(9, user.getId());

            return statement.executeUpdate() > 0;
        } catch (SQLException e) {
            System.out.println(e.getMessage());
        }
        return false;
    }

    public boolean updatePassword(int userId, String password) {
        String sql = "UPDATE user SET password = ? WHERE id = ?";
        try {
            connection = getConnection();
            statement = connection.prepareStatement(sql);
            statement.setString(1, password);
            statement.setInt(2, userId);
            return statement.executeUpdate() > 0;
        } catch (SQLException e) {
            System.out.println(e.getMessage());
        }
        return false;
    }

    @Override
    public boolean delete(User user) {
        String sql = "DELETE FROM user WHERE id = ?";
        try {
            connection = getConnection();
            statement = connection.prepareStatement(sql);
            statement.setInt(1, user.getId());
            return statement.executeUpdate() > 0;
        } catch (SQLException e) {
            System.out.println(e.getMessage());
        }
        return false;
    }

    @Override
    public int insert(User user) {
        String sql = "INSERT INTO user (name, username, password, email, phone, address, status, created_at, created_by) "
                + "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)";
        try {
            connection = getConnection();
            statement = connection.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS);
            statement.setString(1, user.getName());
            statement.setString(2, user.getUsername());
            statement.setString(3, user.getPassword());
            statement.setString(4, user.getEmail());
            statement.setString(5, user.getPhone());
            statement.setString(6, user.getAddress());
            statement.setString(7, user.getStatus());
            statement.setTimestamp(8, Timestamp.valueOf(user.getCreatedAt()));
            statement.setInt(9, user.getCreatedBy());

            int affectedRows = statement.executeUpdate();
            if (affectedRows > 0) {
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
        return 0;
    }

    public User findById(int id) {
        String sql = "SELECT * FROM user WHERE id = ?";
        try {
            connection = getConnection();
            statement = connection.prepareStatement(sql);
            statement.setInt(1, id);
            resultSet = statement.executeQuery();
            if (resultSet.next()) {
                return getFromResultSet(resultSet);
            }
        } catch (SQLException e) {
            System.out.println(e.getMessage());
        }
        return null;
    }

    public User findByUsername(String username) {
        String sql = "SELECT * FROM user WHERE username = ?";
        try {
            connection = getConnection();
            statement = connection.prepareStatement(sql);
            statement.setString(1, username);
            resultSet = statement.executeQuery();
            if (resultSet.next()) {
                return getFromResultSet(resultSet);
            }
        } catch (SQLException e) {
            System.out.println(e.getMessage());
        }
        return null;
    }

    public boolean activateAccount(int userId) {
        String sql = "UPDATE user SET status = ? WHERE id = ?";
        try {
            connection = getConnection();
            statement = connection.prepareStatement(sql);
            statement.setString(1, "active");
            statement.setInt(2, userId);

            int affectedRows = statement.executeUpdate();
            return affectedRows > 0;
        } catch (SQLException e) {
            System.out.println(e.getMessage());
            return false;
        }
    }

    public boolean deactivateAccount(int userId) {
        String sql = "UPDATE user SET status = ? WHERE id = ?";
        try {
            connection = getConnection();
            statement = connection.prepareStatement(sql);
            statement.setString(1, "locked");
            statement.setInt(2, userId);

            int affectedRows = statement.executeUpdate();
            return affectedRows > 0;
        } catch (SQLException ex) {
            System.out.println(ex.getMessage());
            return false;
        }
    }

    public List<User> findUsersWithFilters(String roleFilter, String statusFilter, String searchFilter, int page, int pageSize) {
        List<User> allUsers = new ArrayList<>();
        String sql = "SELECT u.* FROM user u";
        List<String> inputs = new ArrayList<>();
        boolean hasCondition = false;

        if (roleFilter != null && !roleFilter.isEmpty()) {
            sql += " WHERE EXISTS (SELECT 1 FROM user_roles ur JOIN roles r ON ur.role_id = r.id WHERE ur.user_id = u.id AND r.name = ?)";
            inputs.add(roleFilter);
            hasCondition = true;
        }

        if (statusFilter != null && !statusFilter.isEmpty()) {
            if (hasCondition) {
                sql += " AND";
            } else {
                sql += " WHERE";
                hasCondition = true;
            }
            sql += " u.status = ?";
            inputs.add(statusFilter);
        }

        if (searchFilter != null && !searchFilter.trim().isEmpty()) {
            if (hasCondition) {
                sql += " AND";
            } else {
                sql += " WHERE";
                hasCondition = true;
            }
            sql += " (u.email LIKE ? OR u.username LIKE ? OR u.name LIKE ?)";
            String searchPattern = "%" + searchFilter.trim() + "%";
            inputs.add(searchPattern);
            inputs.add(searchPattern);
            inputs.add(searchPattern);
        }

        sql += " ORDER BY u.created_at DESC";

        try {
            connection = getConnection();
            statement = connection.prepareStatement(sql);

            for (int i = 0; i < inputs.size(); i++) {
                statement.setString(i + 1, inputs.get(i));
            }

            resultSet = statement.executeQuery();
            while (resultSet.next()) {
                allUsers.add(getFromResultSet(resultSet));
            }

            if (allUsers.isEmpty()) {
                return allUsers;
            }

            int start = (page - 1) * pageSize;
            int end = Math.min(start + pageSize, allUsers.size());

            if (start > allUsers.size()) {
                return new ArrayList<>();
            }

            return allUsers.subList(start, end);

        } catch (SQLException ex) {
            System.out.println(ex.getMessage());
        }
        return new ArrayList<>();
    }

    public List<User> findUsersWithRoles(String roleFilter, String statusFilter,
            String searchFilter, int page, int pageSize) {
        List<User> users = findUsersWithFilters(roleFilter, statusFilter, searchFilter, page, pageSize);
        RoleDAO roleDAO = new RoleDAO();
        for (User user : users) {
            user.setRoles(roleDAO.getRolesByUserId(user.getId()));
        }
        return users;
    }

    public int getTotalFilteredUsers(String roleFilter, String statusFilter, String searchFilter) {
        String sql = "SELECT COUNT(*) FROM user u";
        List<String> inputs = new ArrayList<>();
        boolean hasCondition = false;

        if (roleFilter != null && !roleFilter.isEmpty()) {
            sql += " WHERE EXISTS (SELECT 1 FROM user_roles ur JOIN roles r ON ur.role_id = r.id WHERE ur.user_id = u.id AND r.name = ?)";
            inputs.add(roleFilter);
            hasCondition = true;
        }

        if (statusFilter != null && !statusFilter.isEmpty()) {
            if (hasCondition) {
                sql += " AND";
            } else {
                sql += " WHERE";
                hasCondition = true;
            }
            sql += " u.status = ?";
            inputs.add(statusFilter);
        }

        if (searchFilter != null && !searchFilter.trim().isEmpty()) {
            if (hasCondition) {
                sql += " AND";
            } else {
                sql += " WHERE";
                hasCondition = true;
            }
            sql += " (u.email LIKE ? OR u.username LIKE ? OR u.name LIKE ?)";
            String searchPattern = "%" + searchFilter.trim() + "%";
            inputs.add(searchPattern);
            inputs.add(searchPattern);
            inputs.add(searchPattern);
        }

        try {
            connection = getConnection();
            statement = connection.prepareStatement(sql);

            for (int i = 0; i < inputs.size(); i++) {
                statement.setString(i + 1, inputs.get(i));
            }

            resultSet = statement.executeQuery();
            if (resultSet.next()) {
                return resultSet.getInt(1);
            }
        } catch (SQLException ex) {
            System.out.println(ex.getMessage());
        }
        return 0;
    }

    @Override
    public User getFromResultSet(ResultSet resultSet) throws SQLException {
        User user = new User() {
        };

        user.setId(resultSet.getInt("id"));
        user.setName(resultSet.getString("name"));
        user.setUsername(resultSet.getString("username"));
        user.setPassword(resultSet.getString("password"));
        user.setEmail(resultSet.getString("email"));
        user.setPhone(resultSet.getString("phone"));
        user.setAddress(resultSet.getString("address"));
        user.setStatus(resultSet.getString("status"));

        Timestamp createdAt = resultSet.getTimestamp("created_at");
        if (createdAt != null) {
            user.setCreatedAt(createdAt.toLocalDateTime());
        }

        Timestamp updatedAt = resultSet.getTimestamp("updated_at");
        if (updatedAt != null) {
            user.setUpdatedAt(updatedAt.toLocalDateTime());
        }

        int createdBy = resultSet.getInt("created_by");
        if (!resultSet.wasNull()) {
            user.setCreatedBy(createdBy);
        }

        int updatedBy = resultSet.getInt("updated_by");
        if (!resultSet.wasNull()) {
            user.setUpdatedBy(updatedBy);
        }

        return user;
    }

    public boolean isUsernameExists(String username) {
        String sql = "SELECT COUNT(*) AS total FROM user WHERE username = ?";
        try {
            connection = getConnection();
            statement = connection.prepareStatement(sql);
            statement.setString(1, username);
            resultSet = statement.executeQuery();
            if (resultSet.next()) {
                return resultSet.getInt("total") > 0;
            }
        } catch (SQLException e) {
            System.out.println(e.getMessage());
        }
        return false;
    }

    public boolean isEmailExists(String email, Integer userId) {
        String sql = "SELECT COUNT(*) FROM user WHERE email = ?";
        if (userId != null) {
            sql += " AND id != ?";
        }
        try {
            connection = getConnection();
            statement = connection.prepareStatement(sql);
            statement.setString(1, email);
            if (userId != null) {
                statement.setInt(2, userId);
            }
            resultSet = statement.executeQuery();
            if (resultSet.next()) {
                return resultSet.getInt(1) > 0;
            }
        } catch (SQLException e) {
            System.out.println(e.getMessage());
        }
        return false;
    }

    public boolean isPhoneExists(String phone, Integer userId) {
        String sql = "SELECT COUNT(*) FROM user WHERE phone = ?";
        if (userId != null) {
            sql += " AND id != ?";
        }
        try {
            connection = getConnection();
            statement = connection.prepareStatement(sql);
            statement.setString(1, phone);
            if (userId != null) {
                statement.setInt(2, userId);
            }
            resultSet = statement.executeQuery();
            if (resultSet.next()) {
                return resultSet.getInt(1) > 0;
            }
        } catch (SQLException e) {
            System.out.println(e.getMessage());
        }
        return false;
    }

    public int countUsersByStatus(String status) {
        String sql = "SELECT COUNT(*) FROM user WHERE status = ?";
        try {
            connection = getConnection();
            statement = connection.prepareStatement(sql);
            statement.setString(1, status);
            resultSet = statement.executeQuery();
            if (resultSet.next()) {
                return resultSet.getInt(1);
            }
        } catch (SQLException e) {
            System.out.println(e.getMessage());
        }
        return 0;
    }

    public int countAllUsers() {
        String sql = "SELECT COUNT(*) FROM user";
        try {
            connection = getConnection();
            statement = connection.prepareStatement(sql);
            resultSet = statement.executeQuery();
            if (resultSet.next()) {
                return resultSet.getInt(1);
            }
        } catch (SQLException e) {
            System.out.println(e.getMessage());
        }
        return 0;
    }

    public void updateUserRoles(int userId, List<Integer> roleIds) throws SQLException {
        String deleteOld = "delete from user_roles where user_id = ?";
        String insertNew = "insert into user_roles (user_id, role_id) values (?,?)";

        try (Connection c = getConnection()) {
            c.setAutoCommit(false);
            try {
                PreparedStatement del = c.prepareStatement(deleteOld);
                del.setInt(1, userId);
                del.executeUpdate();

                if (roleIds != null && !roleIds.isEmpty()) {
                    PreparedStatement ins = c.prepareStatement(insertNew);
                    for (Integer roleId : roleIds) {
                        ins.setInt(1, userId);
                        ins.setInt(2, roleId);
                        ins.addBatch();
                    }
                    ins.executeBatch();
                }
                c.commit();
            } catch (Exception e) {
                c.rollback();
                throw e;
            }
        }
    }

}
