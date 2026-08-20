package com.sunrisedental.dao;

import com.sunrisedental.model.Bill;
import com.sunrisedental.util.DatabaseConnection;

import java.sql.*;
import java.time.LocalDateTime;

public class BillDAO {

    public boolean save(Bill bill) throws SQLException {

        String sql = """
                INSERT INTO bills
                (bill_date, bill_number, consultation_fee,
                 total_amount, treatment_cost, appointment_id)
                VALUES (?, ?, ?, ?, ?, ?)
                """;

        try (Connection connection =
                     DatabaseConnection.getConnection();
             PreparedStatement statement =
                     connection.prepareStatement(sql)) {

            LocalDateTime billDate = bill.getBillDate();

            if (billDate == null) {
                billDate = LocalDateTime.now();
            }

            statement.setTimestamp(
                    1,
                    Timestamp.valueOf(billDate)
            );

            statement.setString(
                    2,
                    bill.getBillNumber()
            );

            statement.setDouble(
                    3,
                    bill.getConsultationFee()
            );

            statement.setDouble(
                    4,
                    bill.getTotalAmount()
            );

            statement.setDouble(
                    5,
                    bill.getTreatmentCost()
            );

            statement.setLong(
                    6,
                    bill.getAppointmentId()
            );

            return statement.executeUpdate() > 0;
        }
    }

    public Bill findById(Long id) throws SQLException {

        String sql = """
                SELECT *
                FROM bills
                WHERE id = ?
                """;

        try (Connection connection =
                     DatabaseConnection.getConnection();
             PreparedStatement statement =
                     connection.prepareStatement(sql)) {

            statement.setLong(1, id);

            try (ResultSet resultSet =
                         statement.executeQuery()) {

                if (resultSet.next()) {
                    return mapResultSetToBill(resultSet);
                }
            }
        }

        return null;
    }

    public Bill findByBillNumber(
            String billNumber) throws SQLException {

        String sql = """
                SELECT *
                FROM bills
                WHERE bill_number = ?
                """;

        try (Connection connection =
                     DatabaseConnection.getConnection();
             PreparedStatement statement =
                     connection.prepareStatement(sql)) {

            statement.setString(1, billNumber);

            try (ResultSet resultSet =
                         statement.executeQuery()) {

                if (resultSet.next()) {
                    return mapResultSetToBill(resultSet);
                }
            }
        }

        return null;
    }

    public Bill findByAppointmentId(
            Long appointmentId) throws SQLException {

        String sql = """
                SELECT *
                FROM bills
                WHERE appointment_id = ?
                """;

        try (Connection connection =
                     DatabaseConnection.getConnection();
             PreparedStatement statement =
                     connection.prepareStatement(sql)) {

            statement.setLong(1, appointmentId);

            try (ResultSet resultSet =
                         statement.executeQuery()) {

                if (resultSet.next()) {
                    return mapResultSetToBill(resultSet);
                }
            }
        }

        return null;
    }

    private Bill mapResultSetToBill(
            ResultSet resultSet) throws SQLException {

        Bill bill = new Bill();

        bill.setId(
                resultSet.getLong("id")
        );

        bill.setBillNumber(
                resultSet.getString("bill_number")
        );

        Timestamp billDate =
                resultSet.getTimestamp("bill_date");

        if (billDate != null) {
            bill.setBillDate(
                    billDate.toLocalDateTime()
            );
        }

        bill.setConsultationFee(
                resultSet.getDouble("consultation_fee")
        );

        bill.setTreatmentCost(
                resultSet.getDouble("treatment_cost")
        );

        bill.setTotalAmount(
                resultSet.getDouble("total_amount")
        );

        bill.setAppointmentId(
                resultSet.getLong("appointment_id")
        );

        return bill;
    }
}