package com.sunrisedental.dao;

import com.sunrisedental.model.Patient;
import com.sunrisedental.util.DatabaseConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class PatientDAO {

    public boolean save(Patient patient) throws SQLException {

        String sql = """
                INSERT INTO patients
                (patient_number, full_name, address, contact_number,
                 date_of_birth, email, gender, registration_date, active)
                VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)
                """;

        try (Connection connection =
                     DatabaseConnection.getConnection();
             PreparedStatement statement =
                     connection.prepareStatement(sql)) {

            statement.setString(1, patient.getPatientNumber());
            statement.setString(2, patient.getFullName());
            statement.setString(3, patient.getAddress());
            statement.setString(4, patient.getContactNumber());

            if (patient.getDateOfBirth() != null) {
                statement.setDate(
                        5,
                        Date.valueOf(patient.getDateOfBirth())
                );
            } else {
                statement.setNull(5, Types.DATE);
            }

            statement.setString(6, patient.getEmail());
            statement.setString(7, patient.getGender());

            statement.setTimestamp(
                    8,
                    Timestamp.valueOf(patient.getRegistrationDate())
            );

            statement.setBoolean(9, patient.isActive());

            return statement.executeUpdate() > 0;
        }
    }

    public List<Patient> findAll() throws SQLException {

        List<Patient> patients = new ArrayList<>();

        String sql = """
                SELECT *
                FROM patients
                WHERE active = true
                ORDER BY full_name
                """;

        try (Connection connection =
                     DatabaseConnection.getConnection();
             PreparedStatement statement =
                     connection.prepareStatement(sql);
             ResultSet resultSet =
                     statement.executeQuery()) {

            while (resultSet.next()) {
                patients.add(mapPatient(resultSet));
            }
        }

        return patients;
    }

    public Patient findByPatientNumber(
            String patientNumber) throws SQLException {

        String sql = """
                SELECT *
                FROM patients
                WHERE patient_number = ?
                AND active = true
                """;

        try (Connection connection =
                     DatabaseConnection.getConnection();
             PreparedStatement statement =
                     connection.prepareStatement(sql)) {

            statement.setString(1, patientNumber);

            try (ResultSet resultSet =
                         statement.executeQuery()) {

                if (resultSet.next()) {
                    return mapPatient(resultSet);
                }
            }
        }

        return null;
    }

    private Patient mapPatient(ResultSet resultSet)
            throws SQLException {

        Patient patient = new Patient();

        patient.setId(resultSet.getLong("id"));
        patient.setPatientNumber(
                resultSet.getString("patient_number")
        );
        patient.setFullName(
                resultSet.getString("full_name")
        );
        patient.setAddress(
                resultSet.getString("address")
        );
        patient.setContactNumber(
                resultSet.getString("contact_number")
        );

        Date dob = resultSet.getDate("date_of_birth");

        if (dob != null) {
            patient.setDateOfBirth(
                    dob.toLocalDate()
            );
        }

        patient.setEmail(
                resultSet.getString("email")
        );

        patient.setGender(
                resultSet.getString("gender")
        );

        Timestamp registrationDate =
                resultSet.getTimestamp("registration_date");

        if (registrationDate != null) {
            patient.setRegistrationDate(
                    registrationDate.toLocalDateTime()
            );
        }

        patient.setActive(
                resultSet.getBoolean("active")
        );

        return patient;
    }
}