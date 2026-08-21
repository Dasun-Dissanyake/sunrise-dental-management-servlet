package com.sunrisedental.dao;

import com.sunrisedental.util.DatabaseConnection;

import java.sql.*;
import java.time.LocalDate;
import java.util.HashMap;
import java.util.Map;

public class AppointmentReportDAO {

    public Map<String, Integer> getAppointmentStatusReport(
            LocalDate startDate,
            LocalDate endDate) throws SQLException {

        Map<String, Integer> report = new HashMap<>();

        String sql = """
                SELECT status, COUNT(*) AS total
                FROM appointments
                WHERE appointment_date BETWEEN ? AND ?
                GROUP BY status
                ORDER BY status
                """;

        try (Connection connection = DatabaseConnection.getConnection();
             PreparedStatement statement = connection.prepareStatement(sql)) {

            statement.setDate(1, Date.valueOf(startDate));
            statement.setDate(2, Date.valueOf(endDate));

            try (ResultSet resultSet = statement.executeQuery()) {

                while (resultSet.next()) {

                    String status =
                            resultSet.getString("status");

                    int total =
                            resultSet.getInt("total");

                    report.put(status, total);
                }
            }
        }

        return report;
    }

    public int getTotalAppointments(
            LocalDate startDate,
            LocalDate endDate) throws SQLException {

        String sql = """
                SELECT COUNT(*)
                FROM appointments
                WHERE appointment_date BETWEEN ? AND ?
                """;

        try (Connection connection = DatabaseConnection.getConnection();
             PreparedStatement statement = connection.prepareStatement(sql)) {

            statement.setDate(1, Date.valueOf(startDate));
            statement.setDate(2, Date.valueOf(endDate));

            try (ResultSet resultSet = statement.executeQuery()) {

                if (resultSet.next()) {
                    return resultSet.getInt(1);
                }
            }
        }

        return 0;
    }
}