package com.sunrisedental.dao;

import com.sunrisedental.util.DatabaseConnection;

import java.math.BigDecimal;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.time.LocalDate;

public class DashboardDAO {

    public long getTotalPatients()
            throws SQLException {

        String sql = """
                SELECT COUNT(*)
                FROM patients
                WHERE active = true
                """;

        try (
                Connection connection =
                        DatabaseConnection.getConnection();

                PreparedStatement statement =
                        connection.prepareStatement(sql);

                ResultSet resultSet =
                        statement.executeQuery()
        ) {

            if (resultSet.next()) {
                return resultSet.getLong(1);
            }
        }

        return 0;
    }


    public long getTotalAppointments()
            throws SQLException {

        String sql = """
                SELECT COUNT(*)
                FROM appointments
                """;

        try (
                Connection connection =
                        DatabaseConnection.getConnection();

                PreparedStatement statement =
                        connection.prepareStatement(sql);

                ResultSet resultSet =
                        statement.executeQuery()
        ) {

            if (resultSet.next()) {
                return resultSet.getLong(1);
            }
        }

        return 0;
    }


    public long getTodayAppointments()
            throws SQLException {

        String sql = """
                SELECT COUNT(*)
                FROM appointments
                WHERE appointment_date = ?
                """;

        try (
                Connection connection =
                        DatabaseConnection.getConnection();

                PreparedStatement statement =
                        connection.prepareStatement(sql)
        ) {

            statement.setDate(
                    1,
                    java.sql.Date.valueOf(
                            LocalDate.now()
                    )
            );

            try (
                    ResultSet resultSet =
                            statement.executeQuery()
            ) {

                if (resultSet.next()) {
                    return resultSet.getLong(1);
                }
            }
        }

        return 0;
    }


    public BigDecimal getTotalRevenue()
            throws SQLException {

        String sql = """
                SELECT COALESCE(
                    SUM(total_amount),
                    0
                )
                FROM bills
                """;

        try (
                Connection connection =
                        DatabaseConnection.getConnection();

                PreparedStatement statement =
                        connection.prepareStatement(sql);

                ResultSet resultSet =
                        statement.executeQuery()
        ) {

            if (resultSet.next()) {
                return resultSet.getBigDecimal(1);
            }
        }

        return BigDecimal.ZERO;
    }
}