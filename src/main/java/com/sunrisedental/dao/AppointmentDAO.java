package com.sunrisedental.dao;

import com.sunrisedental.model.Appointment;
import com.sunrisedental.util.DatabaseConnection;

import java.sql.*;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.LocalTime;
import java.util.ArrayList;
import java.util.List;

public class AppointmentDAO {

    public boolean save(Appointment appointment) throws SQLException {
        String sql = """
                INSERT INTO appointments
                (appointment_date, appointment_number, appointment_time, created_at, notes, status, updated_at, dentist_id, patient_id, treatment_id)
                VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)
                """;

        try (Connection connection = DatabaseConnection.getConnection();
             PreparedStatement statement = connection.prepareStatement(sql)) {

            statement.setDate(1, Date.valueOf(appointment.getAppointmentDate()));
            statement.setString(2, appointment.getAppointmentNumber());
            statement.setTime(3, Time.valueOf(appointment.getAppointmentTime()));

            LocalDateTime createdAt = appointment.getCreatedAt();
            if (createdAt == null) {
                createdAt = LocalDateTime.now();
            }
            statement.setTimestamp(4, Timestamp.valueOf(createdAt));

            statement.setString(5, appointment.getNotes());

            String status = appointment.getStatus();
            if (status == null || status.isBlank()) {
                status = "SCHEDULED";
            }
            statement.setString(6, status);

            if (appointment.getUpdatedAt() != null) {
                statement.setTimestamp(7, Timestamp.valueOf(appointment.getUpdatedAt()));
            } else {
                statement.setNull(7, Types.TIMESTAMP);
            }

            statement.setLong(8, appointment.getDentistId());
            statement.setLong(9, appointment.getPatientId());
            statement.setLong(10, appointment.getTreatmentId());

            return statement.executeUpdate() > 0;
        }
    }

    public Appointment findById(Long id) throws SQLException {
        String sql = "SELECT * FROM appointments WHERE id = ?";

        try (Connection connection = DatabaseConnection.getConnection();
             PreparedStatement statement = connection.prepareStatement(sql)) {

            statement.setLong(1, id);

            try (ResultSet resultSet = statement.executeQuery()) {
                if (resultSet.next()) {
                    return mapResultSetToAppointment(resultSet);
                }
            }
        }

        return null;
    }

    public Appointment findByAppointmentNumber(String appointmentNumber) throws SQLException {
        String sql = "SELECT * FROM appointments WHERE appointment_number = ?";

        try (Connection connection = DatabaseConnection.getConnection();
             PreparedStatement statement = connection.prepareStatement(sql)) {

            statement.setString(1, appointmentNumber);

            try (ResultSet resultSet = statement.executeQuery()) {
                if (resultSet.next()) {
                    return mapResultSetToAppointment(resultSet);
                }
            }
        }

        return null;
    }

    public List<Appointment> findAll() throws SQLException {
        List<Appointment> appointments = new ArrayList<>();

        String sql = "SELECT * FROM appointments ORDER BY appointment_date DESC, appointment_time DESC";

        try (Connection connection = DatabaseConnection.getConnection();
             PreparedStatement statement = connection.prepareStatement(sql);
             ResultSet resultSet = statement.executeQuery()) {

            while (resultSet.next()) {
                appointments.add(mapResultSetToAppointment(resultSet));
            }
        }

        return appointments;
    }

    public boolean update(Appointment appointment) throws SQLException {
        String sql = """
                UPDATE appointments
                SET appointment_date = ?,
                    appointment_time = ?,
                    dentist_id = ?,
                    patient_id = ?,
                    treatment_id = ?,
                    notes = ?,
                    status = ?,
                    updated_at = ?
                WHERE id = ?
                """;

        try (Connection connection = DatabaseConnection.getConnection();
             PreparedStatement statement = connection.prepareStatement(sql)) {

            statement.setDate(1, Date.valueOf(appointment.getAppointmentDate()));
            statement.setTime(2, Time.valueOf(appointment.getAppointmentTime()));
            statement.setLong(3, appointment.getDentistId());
            statement.setLong(4, appointment.getPatientId());
            statement.setLong(5, appointment.getTreatmentId());
            statement.setString(6, appointment.getNotes());

            String status = appointment.getStatus();
            if (status == null || status.isBlank()) {
                status = "SCHEDULED";
            }
            statement.setString(7, status);

            LocalDateTime updatedAt = appointment.getUpdatedAt();
            if (updatedAt == null) {
                updatedAt = LocalDateTime.now();
            }
            statement.setTimestamp(8, Timestamp.valueOf(updatedAt));

            statement.setLong(9, appointment.getId());

            return statement.executeUpdate() > 0;
        }
    }

    public boolean updateStatus(Long id, String status) throws SQLException {
        String sql = """
                UPDATE appointments
                SET status = ?,
                    updated_at = ?
                WHERE id = ?
                """;

        try (Connection connection = DatabaseConnection.getConnection();
             PreparedStatement statement = connection.prepareStatement(sql)) {

            statement.setString(1, status);
            statement.setTimestamp(2, Timestamp.valueOf(LocalDateTime.now()));
            statement.setLong(3, id);

            return statement.executeUpdate() > 0;
        }
    }

    private Appointment mapResultSetToAppointment(ResultSet resultSet) throws SQLException {
        Appointment appointment = new Appointment();

        appointment.setId(resultSet.getLong("id"));

        Date appDate = resultSet.getDate("appointment_date");
        if (appDate != null) {
            appointment.setAppointmentDate(appDate.toLocalDate());
        }

        appointment.setAppointmentNumber(resultSet.getString("appointment_number"));

        Time appTime = resultSet.getTime("appointment_time");
        if (appTime != null) {
            appointment.setAppointmentTime(appTime.toLocalTime());
        }

        Timestamp createdAt = resultSet.getTimestamp("created_at");
        if (createdAt != null) {
            appointment.setCreatedAt(createdAt.toLocalDateTime());
        }

        appointment.setNotes(resultSet.getString("notes"));
        appointment.setStatus(resultSet.getString("status"));

        Timestamp updatedAt = resultSet.getTimestamp("updated_at");
        if (updatedAt != null) {
            appointment.setUpdatedAt(updatedAt.toLocalDateTime());
        }

        appointment.setDentistId(resultSet.getLong("dentist_id"));
        appointment.setPatientId(resultSet.getLong("patient_id"));
        appointment.setTreatmentId(resultSet.getLong("treatment_id"));

        return appointment;
    }
}