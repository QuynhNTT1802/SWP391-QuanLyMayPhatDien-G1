package com.quanlymayphatdien.g1.dal;

import com.quanlymayphatdien.g1.entity.User;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Timestamp;
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
        String sql = "UPDATE user SET name = ?, username = ?, password = ?, email = ?, phone = ?, "
                + "address = ?, status = ?, updated_at = ?, updated_by = ? WHERE id = ?";
        try {
            connection = getConnection();
            statement = connection.prepareStatement(sql);
            statement.setString(1, user.getName());
            statement.setString(2, user.getUsername());
            statement.setString(3, user.getPassword());
            statement.setString(4, user.getEmail());
            statement.setString(5, user.getPhone());
            statement.setString(6, user.getAddress());
            statement.setString(7, user.getStatus());
            statement.setTimestamp(8, Timestamp.valueOf(user.getUpdatedAt()));
            statement.setInt(9, user.getUpdatedBy());
            statement.setInt(10, user.getId());

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
            statement = connection.prepareStatement(sql);
            statement.setString(1, user.getName());
            statement.setString(2, user.getUsername());
            statement.setString(3, user.getPassword());
            statement.setString(4, user.getEmail());
            statement.setString(5, user.getPhone());
            statement.setString(6, user.getAddress());
            statement.setString(7, user.getStatus());
            statement.setTimestamp(8, Timestamp.valueOf(user.getUpdatedAt()));
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

    public User findByName(String name) {
        String sql = "SELECT * FROM user WHERE username = ?";
        try {
            connection = getConnection();
            statement = connection.prepareStatement(sql);
            statement.setString(1, name);
            resultSet = statement.executeQuery();
            if (resultSet.next()) {
                return getFromResultSet(resultSet);
            }
        } catch (SQLException e) {
            System.out.println(e.getMessage());
        }
        return null;
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
        } finally {
            closeResources();
        }
        return false;
    }

    public boolean isEmailExists(String email, Integer userId) {
        String sql = "SELECT COUNT(*) FROM user WHERE email = ?";
        if (userId != null) {
            sql += " AND user_id != ?";
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
            System.out.println("Error checking email existence: " + e.getMessage());
        } finally {
            closeResources();
        }
        return false;
    }

    public boolean isPhoneExists(String phone, Integer userId) {
        String sql = "SELECT COUNT(*) FROM user WHERE phone = ?";
        if (userId != null) {
            sql += " AND user_id != ?";
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
            System.out.println("Error checking phone existence: " + e.getMessage());
        } finally {
            closeResources();
        }
        return false;
    }

}
