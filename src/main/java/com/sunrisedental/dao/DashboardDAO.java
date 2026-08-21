package com.sunrisedental.dao;

import com.sunrisedental.model.DashboardAppointment;
import com.sunrisedental.util.DatabaseConnection;

import java.sql.Connection;
import java.sql.Date;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Time;
import java.util.ArrayList;
import java.util.List;

public class DashboardDAO {


public int getTotalPatients() throws SQLException {

    String sql = """
            SELECT COUNT(*)
            FROM patients
            WHERE active = true
            """;

    try (Connection connection = DatabaseConnection.getConnection();
         PreparedStatement statement = connection.prepareStatement(sql);
         ResultSet resultSet = statement.executeQuery()) {

        if (resultSet.next()) {
            return resultSet.getInt(1);
        }
    }

    return 0;
}

public int getTotalAppointments() throws SQLException {

    String sql = """
            SELECT COUNT(*)
            FROM appointments
            """;

    try (Connection connection = DatabaseConnection.getConnection();
         PreparedStatement statement = connection.prepareStatement(sql);
         ResultSet resultSet = statement.executeQuery()) {

        if (resultSet.next()) {
            return resultSet.getInt(1);
        }
    }

    return 0;
}

public int getTodaysAppointments() throws SQLException {

    String sql = """
            SELECT COUNT(*)
            FROM appointments
            WHERE appointment_date = CURDATE()
            """;

    try (Connection connection = DatabaseConnection.getConnection();
         PreparedStatement statement = connection.prepareStatement(sql);
         ResultSet resultSet = statement.executeQuery()) {

        if (resultSet.next()) {
            return resultSet.getInt(1);
        }
    }

    return 0;
}

public double getTotalRevenue() throws SQLException {

    String sql = """
            SELECT COALESCE(SUM(total_amount), 0)
            FROM bills
            """;

    try (Connection connection = DatabaseConnection.getConnection();
         PreparedStatement statement = connection.prepareStatement(sql);
         ResultSet resultSet = statement.executeQuery()) {

        if (resultSet.next()) {
            return resultSet.getDouble(1);
        }
    }

    return 0.0;
}

public List<DashboardAppointment> getRecentAppointments()
        throws SQLException {

    List<DashboardAppointment> appointments =
            new ArrayList<>();

    String sql = """
            SELECT
                a.appointment_number,
                p.full_name AS patient_name,
                d.full_name AS dentist_name,
                t.treatment_name AS treatment_name,
                a.appointment_date,
                a.appointment_time,
                a.status
            FROM appointments a
            INNER JOIN patients p
                ON a.patient_id = p.id
            INNER JOIN dentists d
                ON a.dentist_id = d.id
            INNER JOIN treatments t
                ON a.treatment_id = t.id
            ORDER BY a.appointment_date DESC,
                     a.appointment_time DESC
            LIMIT 5
            """;

    try (Connection connection =
                 DatabaseConnection.getConnection();
         PreparedStatement statement =
                 connection.prepareStatement(sql);
         ResultSet resultSet =
                 statement.executeQuery()) {

        while (resultSet.next()) {

            DashboardAppointment appointment =
                    new DashboardAppointment();

            appointment.setAppointmentNumber(
                    resultSet.getString(
                            "appointment_number"
                    )
            );

            appointment.setPatientName(
                    resultSet.getString(
                            "patient_name"
                    )
            );

            appointment.setDentistName(
                    resultSet.getString(
                            "dentist_name"
                    )
            );

            appointment.setTreatmentName(
                    resultSet.getString(
                            "treatment_name"
                    )
            );

            Date appointmentDate =
                    resultSet.getDate(
                            "appointment_date"
                    );

            if (appointmentDate != null) {
                appointment.setAppointmentDate(
                        appointmentDate.toLocalDate()
                );
            }

            Time appointmentTime =
                    resultSet.getTime(
                            "appointment_time"
                    );

            if (appointmentTime != null) {
                appointment.setAppointmentTime(
                        appointmentTime.toLocalTime()
                );
            }

            appointment.setStatus(
                    resultSet.getString("status")
            );

            appointments.add(appointment);
        }
    }

    return appointments;
}


}
