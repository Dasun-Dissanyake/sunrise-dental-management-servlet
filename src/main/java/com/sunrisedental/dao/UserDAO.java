package com.sunrisedental.dao;

import com.sunrisedental.model.User;
import com.sunrisedental.util.DatabaseConnection;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Timestamp;

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

    public User findByUsername(String username) throws SQLException {

        try (Connection connection = DatabaseConnection.getConnection();
             PreparedStatement statement =
                     connection.prepareStatement(FIND_BY_USERNAME)) {

            statement.setString(1, username);

            try (ResultSet resultSet = statement.executeQuery()) {

                if (resultSet.next()) {

                    Timestamp createdAt =
                            resultSet.getTimestamp("created_at");

                    return new User(
                            resultSet.getLong("id"),
                            createdAt != null
                                    ? createdAt.toLocalDateTime()
                                    : null,
                            resultSet.getBoolean("enabled"),
                            resultSet.getString("full_name"),
                            resultSet.getString("password"),
                            resultSet.getString("role"),
                            resultSet.getString("username")
                    );
                }
            }
        }

        return null;
    }
}