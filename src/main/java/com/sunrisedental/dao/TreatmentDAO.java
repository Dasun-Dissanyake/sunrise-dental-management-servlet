
package com.sunrisedental.dao;

import com.sunrisedental.model.Treatment;
import com.sunrisedental.util.DatabaseConnection;

import java.sql.*;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;

public class TreatmentDAO {

    public boolean save(Treatment treatment) throws SQLException {

        String sql = """
                INSERT INTO treatments
                (treatment_code, treatment_name, description,
                 treatment_cost, consultation_fee, created_at, active)
                VALUES (?, ?, ?, ?, ?, ?, ?)
                """;

        try (Connection connection = DatabaseConnection.getConnection();
             PreparedStatement statement =
                     connection.prepareStatement(sql)) {

            statement.setString(1, treatment.getTreatmentCode());
            statement.setString(2, treatment.getTreatmentName());
            statement.setString(3, treatment.getDescription());

            if (treatment.getTreatmentCost() != null) {
                statement.setDouble(4, treatment.getTreatmentCost());
            } else {
                statement.setNull(4, Types.DECIMAL);
            }

            if (treatment.getConsultationFee() != null) {
                statement.setDouble(5, treatment.getConsultationFee());
            } else {
                statement.setNull(5, Types.DECIMAL);
            }

            LocalDateTime createdAt = treatment.getCreatedAt();

            if (createdAt == null) {
                createdAt = LocalDateTime.now();
            }

            statement.setTimestamp(
                    6,
                    Timestamp.valueOf(createdAt)
            );

            statement.setBoolean(
                    7,
                    treatment.isActive()
            );

            return statement.executeUpdate() > 0;
        }
    }

    public Treatment findById(Long id) throws SQLException {

        String sql = """
                SELECT *
                FROM treatments
                WHERE id = ?
                """;

        try (Connection connection = DatabaseConnection.getConnection();
             PreparedStatement statement =
                     connection.prepareStatement(sql)) {

            statement.setLong(1, id);

            try (ResultSet resultSet =
                         statement.executeQuery()) {

                if (resultSet.next()) {
                    return mapResultSetToTreatment(resultSet);
                }
            }
        }

        return null;
    }

    public Treatment findByTreatmentCode(
            String treatmentCode) throws SQLException {

        String sql = """
                SELECT *
                FROM treatments
                WHERE treatment_code = ?
                AND active = true
                """;

        try (Connection connection = DatabaseConnection.getConnection();
             PreparedStatement statement =
                     connection.prepareStatement(sql)) {

            statement.setString(1, treatmentCode);

            try (ResultSet resultSet =
                         statement.executeQuery()) {

                if (resultSet.next()) {
                    return mapResultSetToTreatment(resultSet);
                }
            }
        }

        return null;
    }

    public List<Treatment> findAll() throws SQLException {

        List<Treatment> treatments = new ArrayList<>();

        String sql = """
                SELECT *
                FROM treatments
                WHERE active = true
                ORDER BY treatment_name
                """;

        try (Connection connection = DatabaseConnection.getConnection();
             PreparedStatement statement =
                     connection.prepareStatement(sql);
             ResultSet resultSet =
                     statement.executeQuery()) {

            while (resultSet.next()) {

                treatments.add(
                        mapResultSetToTreatment(resultSet)
                );
            }
        }

        return treatments;
    }

    public boolean update(Treatment treatment)
            throws SQLException {

        String sql = """
                UPDATE treatments
                SET treatment_name = ?,
                    description = ?,
                    treatment_cost = ?,
                    consultation_fee = ?
                WHERE id = ?
                AND active = true
                """;

        try (Connection connection = DatabaseConnection.getConnection();
             PreparedStatement statement =
                     connection.prepareStatement(sql)) {

            statement.setString(
                    1,
                    treatment.getTreatmentName()
            );

            statement.setString(
                    2,
                    treatment.getDescription()
            );

            if (treatment.getTreatmentCost() != null) {
                statement.setDouble(
                        3,
                        treatment.getTreatmentCost()
                );
            } else {
                statement.setNull(
                        3,
                        Types.DECIMAL
                );
            }

            if (treatment.getConsultationFee() != null) {
                statement.setDouble(
                        4,
                        treatment.getConsultationFee()
                );
            } else {
                statement.setNull(
                        4,
                        Types.DECIMAL
                );
            }

            statement.setLong(
                    5,
                    treatment.getId()
            );

            return statement.executeUpdate() > 0;
        }
    }

    public boolean deactivate(Long id)
            throws SQLException {

        String sql = """
                UPDATE treatments
                SET active = false
                WHERE id = ?
                """;

        try (Connection connection = DatabaseConnection.getConnection();
             PreparedStatement statement =
                     connection.prepareStatement(sql)) {

            statement.setLong(1, id);

            return statement.executeUpdate() > 0;
        }
    }

    private Treatment mapResultSetToTreatment(
            ResultSet resultSet)
            throws SQLException {

        Treatment treatment = new Treatment();

        treatment.setId(
                resultSet.getLong("id")
        );

        treatment.setTreatmentCode(
                resultSet.getString("treatment_code")
        );

        treatment.setTreatmentName(
                resultSet.getString("treatment_name")
        );

        treatment.setDescription(
                resultSet.getString("description")
        );

        double cost =
                resultSet.getDouble("treatment_cost");

        if (!resultSet.wasNull()) {
            treatment.setTreatmentCost(cost);
        }

        double fee =
                resultSet.getDouble("consultation_fee");

        if (!resultSet.wasNull()) {
            treatment.setConsultationFee(fee);
        }

        Timestamp createdAt =
                resultSet.getTimestamp("created_at");

        if (createdAt != null) {

            treatment.setCreatedAt(
                    createdAt.toLocalDateTime()
            );
        }

        treatment.setActive(
                resultSet.getBoolean("active")
        );

        return treatment;
    }
}

