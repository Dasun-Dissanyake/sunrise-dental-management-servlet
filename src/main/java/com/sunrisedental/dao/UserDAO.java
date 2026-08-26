package com.sunrisedental.dao;

import com.sunrisedental.model.User;
import com.sunrisedental.util.DatabaseConnection;

import java.sql.*;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;

public class UserDAO {

    private static final String FIND_BY_USERNAME =
            """
            SELECT id,
                   created_at,
                   enabled,
                   full_name,
                   password,
                   role,
                   username
            FROM users
            WHERE username = ?
            """;

    private static final String FIND_BY_ID =
            """
            SELECT id,
                   created_at,
                   enabled,
                   full_name,
                   password,
                   role,
                   username
            FROM users
            WHERE id = ?
            """;

    private static final String FIND_ALL =
            """
            SELECT id,
                   created_at,
                   enabled,
                   full_name,
                   password,
                   role,
                   username
            FROM users
            ORDER BY created_at DESC
            """;

    public User findByUsername(String username) throws SQLException {
        if (username == null || username.isBlank()) {
            return null;
        }

        try (Connection connection = DatabaseConnection.getConnection();
             PreparedStatement statement =
                     connection.prepareStatement(FIND_BY_USERNAME)) {

            statement.setString(1, username.trim());

            try (ResultSet resultSet = statement.executeQuery()) {

                if (resultSet.next()) {
                    return mapResultSetToUser(resultSet);
                }
            }
        }

        return null;
    }

    public User findById(Long id) throws SQLException {
        if (id == null || id <= 0) {
            return null;
        }

        try (Connection connection = DatabaseConnection.getConnection();
             PreparedStatement statement =
                     connection.prepareStatement(FIND_BY_ID)) {

            statement.setLong(1, id);

            try (ResultSet resultSet = statement.executeQuery()) {

                if (resultSet.next()) {
                    return mapResultSetToUser(resultSet);
                }
            }
        }

        return null;
    }

    public List<User> findAll() throws SQLException {
        List<User> users = new ArrayList<>();

        try (Connection connection = DatabaseConnection.getConnection();
             PreparedStatement statement =
                     connection.prepareStatement(FIND_ALL);
             ResultSet resultSet = statement.executeQuery()) {

            while (resultSet.next()) {
                users.add(mapResultSetToUser(resultSet));
            }
        }

        return users;
    }

    public boolean save(User user) throws SQLException {
        if (user == null) {
            return false;
        }

        String sql = """
                INSERT INTO users
                (created_at, enabled, full_name, password, role, username)
                VALUES (?, ?, ?, ?, ?, ?)
                """;

        try (Connection connection = DatabaseConnection.getConnection();
             PreparedStatement statement = connection.prepareStatement(sql)) {

            LocalDateTime createdAt = user.getCreatedAt();
            if (createdAt == null) {
                createdAt = LocalDateTime.now();
            }
            statement.setTimestamp(1, Timestamp.valueOf(createdAt));
            statement.setBoolean(2, user.isEnabled());
            statement.setString(3, user.getFullName());
            statement.setString(4, user.getPassword());
            statement.setString(5, user.getRole());
            statement.setString(6, user.getUsername());

            return statement.executeUpdate() > 0;
        }
    }

    public boolean update(User user) throws SQLException {
        if (user == null || user.getId() == null) {
            return false;
        }

        String sql = """
                UPDATE users
                SET full_name = ?,
                    role = ?
                WHERE id = ?
                """;

        try (Connection connection = DatabaseConnection.getConnection();
             PreparedStatement statement = connection.prepareStatement(sql)) {

            statement.setString(1, user.getFullName());
            statement.setString(2, user.getRole());
            statement.setLong(3, user.getId());

            return statement.executeUpdate() > 0;
        }
    }

    public boolean updateStatus(Long id, boolean enabled) throws SQLException {
        if (id == null || id <= 0) {
            return false;
        }

        String sql = """
                UPDATE users
                SET enabled = ?
                WHERE id = ?
                """;

        try (Connection connection = DatabaseConnection.getConnection();
             PreparedStatement statement = connection.prepareStatement(sql)) {

            statement.setBoolean(1, enabled);
            statement.setLong(2, id);

            return statement.executeUpdate() > 0;
        }
    }

    public boolean updatePassword(Long id, String hashedPassword) throws SQLException {
        if (id == null || id <= 0 || hashedPassword == null || hashedPassword.isBlank()) {
            return false;
        }

        String sql = """
                UPDATE users
                SET password = ?
                WHERE id = ?
                """;

        try (Connection connection = DatabaseConnection.getConnection();
             PreparedStatement statement = connection.prepareStatement(sql)) {

            statement.setString(1, hashedPassword);
            statement.setLong(2, id);

            return statement.executeUpdate() > 0;
        }
    }

    public boolean existsByUsername(String username) throws SQLException {
        if (username == null || username.isBlank()) {
            return false;
        }

        String sql = "SELECT 1 FROM users WHERE username = ?";

        try (Connection connection = DatabaseConnection.getConnection();
             PreparedStatement statement = connection.prepareStatement(sql)) {

            statement.setString(1, username.trim());

            try (ResultSet resultSet = statement.executeQuery()) {
                return resultSet.next();
            }
        }
    }

    public int countActiveAdmins() throws SQLException {
        String sql = "SELECT COUNT(*) FROM users WHERE UPPER(role) = 'ADMIN' AND (enabled = true OR enabled = 1)";

        try (Connection connection = DatabaseConnection.getConnection();
             PreparedStatement statement = connection.prepareStatement(sql);
             ResultSet resultSet = statement.executeQuery()) {

            if (resultSet.next()) {
                return resultSet.getInt(1);
            }
        }

        return 0;
    }

    private User mapResultSetToUser(ResultSet resultSet) throws SQLException {
        Timestamp createdAt = resultSet.getTimestamp("created_at");

        return new User(
                resultSet.getLong("id"),
                createdAt != null ? createdAt.toLocalDateTime() : null,
                resultSet.getBoolean("enabled"),
                resultSet.getString("full_name"),
                resultSet.getString("password"),
                resultSet.getString("role"),
                resultSet.getString("username")
        );
    }
}