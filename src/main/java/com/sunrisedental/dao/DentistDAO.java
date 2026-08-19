package com.sunrisedental.dao;

import com.sunrisedental.model.Dentist;
import com.sunrisedental.util.DatabaseConnection;

import java.sql.*;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;

public class DentistDAO {

public boolean save(Dentist dentist) {
    String sql = """
            INSERT INTO dentists
            (dentist_number, full_name, specialization, contact_number, created_at, active)
            VALUES (?, ?, ?, ?, ?, ?)
            """;

    try (Connection connection = DatabaseConnection.getConnection();
         PreparedStatement statement = connection.prepareStatement(sql)) {

        statement.setString(1, dentist.getDentistNumber());
        statement.setString(2, dentist.getFullName());
        statement.setString(3, dentist.getSpecialization());
        statement.setString(4, dentist.getContactNumber());

        LocalDateTime createdAt = dentist.getCreatedAt();

        if (createdAt == null) {
            createdAt = LocalDateTime.now();
        }

        statement.setTimestamp(5, Timestamp.valueOf(createdAt));
        statement.setBoolean(6, dentist.isActive());

        return statement.executeUpdate() > 0;

    } catch (SQLException e) {
        e.printStackTrace();
        return false;
    }
}

    public Dentist findById(Long id) {
        String sql = "SELECT * FROM dentists WHERE id = ?";

        try (Connection connection = DatabaseConnection.getConnection();
             PreparedStatement statement = connection.prepareStatement(sql)) {

            statement.setLong(1, id);

            try (ResultSet resultSet = statement.executeQuery()) {
                if (resultSet.next()) {
                    return mapResultSetToDentist(resultSet);
                }
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return null;
    }

    public Dentist findByDentistNumber(String dentistNumber) {
        String sql = "SELECT * FROM dentists WHERE dentist_number = ?";

        try (Connection connection = DatabaseConnection.getConnection();
             PreparedStatement statement = connection.prepareStatement(sql)) {

            statement.setString(1, dentistNumber);

            try (ResultSet resultSet = statement.executeQuery()) {
                if (resultSet.next()) {
                    return mapResultSetToDentist(resultSet);
                }
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return null;
    }

    public List<Dentist> findAll() {
        List<Dentist> dentists = new ArrayList<>();

        String sql = "SELECT * FROM dentists ORDER BY id DESC";

        try (Connection connection = DatabaseConnection.getConnection();
             PreparedStatement statement = connection.prepareStatement(sql);
             ResultSet resultSet = statement.executeQuery()) {

            while (resultSet.next()) {
                dentists.add(mapResultSetToDentist(resultSet));
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return dentists;
    }

    public boolean update(Dentist dentist) {
        String sql = """
                UPDATE dentists
                SET full_name = ?,
                    specialization = ?,
                    contact_number = ?
                WHERE id = ?
                """;

        try (Connection connection = DatabaseConnection.getConnection();
             PreparedStatement statement = connection.prepareStatement(sql)) {

            statement.setString(1, dentist.getFullName());
            statement.setString(2, dentist.getSpecialization());
            statement.setString(3, dentist.getContactNumber());
            statement.setLong(4, dentist.getId());

            return statement.executeUpdate() > 0;

        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public boolean deactivate(Long id) {
        String sql = "UPDATE dentists SET active = false WHERE id = ?";

        try (Connection connection = DatabaseConnection.getConnection();
             PreparedStatement statement = connection.prepareStatement(sql)) {

            statement.setLong(1, id);

            return statement.executeUpdate() > 0;

        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    private Dentist mapResultSetToDentist(ResultSet resultSet) throws SQLException {
        Dentist dentist = new Dentist();

        dentist.setId(resultSet.getLong("id"));
        dentist.setDentistNumber(resultSet.getString("dentist_number"));
        dentist.setFullName(resultSet.getString("full_name"));
        dentist.setSpecialization(resultSet.getString("specialization"));
        dentist.setContactNumber(resultSet.getString("contact_number"));

        Timestamp createdAt = resultSet.getTimestamp("created_at");
        if (createdAt != null) {
            dentist.setCreatedAt(createdAt.toLocalDateTime());
        }

        dentist.setActive(resultSet.getBoolean("active"));

        return dentist;
    }
}