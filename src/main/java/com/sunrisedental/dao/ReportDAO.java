package com.sunrisedental.dao;

import com.sunrisedental.util.DatabaseConnection;

import java.sql.*;
import java.time.LocalDate;
import com.sunrisedental.model.DentistReport;
import com.sunrisedental.model.PatientReport;
import com.sunrisedental.model.TreatmentReport;
import java.util.ArrayList;
import java.util.List;

public class ReportDAO {

    public double getTotalRevenue(
            LocalDate startDate,
            LocalDate endDate) throws SQLException {

        String sql = """
                SELECT COALESCE(SUM(total_amount), 0)
                FROM bills
                WHERE DATE(bill_date) BETWEEN ? AND ?
                """;

        try (Connection connection = DatabaseConnection.getConnection();
             PreparedStatement statement = connection.prepareStatement(sql)) {

            statement.setDate(1, Date.valueOf(startDate));
            statement.setDate(2, Date.valueOf(endDate));

            try (ResultSet resultSet = statement.executeQuery()) {
                if (resultSet.next()) {
                    return resultSet.getDouble(1);
                }
            }
        }

        return 0.0;
    }

    public double getTotalConsultationFees(
            LocalDate startDate,
            LocalDate endDate) throws SQLException {

        String sql = """
                SELECT COALESCE(SUM(consultation_fee), 0)
                FROM bills
                WHERE DATE(bill_date) BETWEEN ? AND ?
                """;

        try (Connection connection = DatabaseConnection.getConnection();
             PreparedStatement statement = connection.prepareStatement(sql)) {

            statement.setDate(1, Date.valueOf(startDate));
            statement.setDate(2, Date.valueOf(endDate));

            try (ResultSet resultSet = statement.executeQuery()) {
                if (resultSet.next()) {
                    return resultSet.getDouble(1);
                }
            }
        }

        return 0.0;
    }

    public double getTotalTreatmentRevenue(
            LocalDate startDate,
            LocalDate endDate) throws SQLException {

        String sql = """
                SELECT COALESCE(SUM(treatment_cost), 0)
                FROM bills
                WHERE DATE(bill_date) BETWEEN ? AND ?
                """;

        try (Connection connection = DatabaseConnection.getConnection();
             PreparedStatement statement = connection.prepareStatement(sql)) {

            statement.setDate(1, Date.valueOf(startDate));
            statement.setDate(2, Date.valueOf(endDate));

            try (ResultSet resultSet = statement.executeQuery()) {
                if (resultSet.next()) {
                    return resultSet.getDouble(1);
                }
            }
        }

        return 0.0;
    }

    public int getTotalBills(
            LocalDate startDate,
            LocalDate endDate) throws SQLException {

        String sql = """
                SELECT COUNT(*)
                FROM bills
                WHERE DATE(bill_date) BETWEEN ? AND ?
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

    public double getAverageBillAmount(
            LocalDate startDate,
            LocalDate endDate) throws SQLException {

        String sql = """
                SELECT COALESCE(AVG(total_amount), 0)
                FROM bills
                WHERE DATE(bill_date) BETWEEN ? AND ?
                """;

        try (Connection connection = DatabaseConnection.getConnection();
             PreparedStatement statement = connection.prepareStatement(sql)) {

            statement.setDate(1, Date.valueOf(startDate));
            statement.setDate(2, Date.valueOf(endDate));

            try (ResultSet resultSet = statement.executeQuery()) {
                if (resultSet.next()) {
                    return resultSet.getDouble(1);
                }
            }
        }

        return 0.0;
    }

    public List<TreatmentReport> getTreatmentReport(
        LocalDate startDate,
        LocalDate endDate) throws SQLException {

    List<TreatmentReport> reports = new ArrayList<>();

    String sql = """
            SELECT
                t.treatment_name,
                COUNT(a.id) AS appointment_count,
                COALESCE(SUM(b.treatment_cost), 0) AS revenue
            FROM treatments t
            LEFT JOIN appointments a
                ON t.id = a.treatment_id
                AND a.appointment_date BETWEEN ? AND ?
            LEFT JOIN bills b
                ON b.appointment_id = a.id
            GROUP BY t.id, t.treatment_name
            ORDER BY appointment_count DESC,
                     t.treatment_name
            """;

    try (Connection connection = DatabaseConnection.getConnection();
         PreparedStatement statement =
                 connection.prepareStatement(sql)) {

        statement.setDate(1, Date.valueOf(startDate));
        statement.setDate(2, Date.valueOf(endDate));

        try (ResultSet resultSet = statement.executeQuery()) {

            while (resultSet.next()) {

                TreatmentReport report =
                        new TreatmentReport();

                report.setTreatmentName(
                        resultSet.getString("treatment_name")
                );

                report.setAppointmentCount(
                        resultSet.getInt("appointment_count")
                );

                report.setRevenue(
                        resultSet.getDouble("revenue")
                );

                reports.add(report);
            }
        }
    }

    return reports;
}


public List<DentistReport> getDentistReport(
        LocalDate startDate,
        LocalDate endDate) throws SQLException {

    List<DentistReport> reports = new ArrayList<>();

    String sql = """
            SELECT
                d.full_name AS dentist_name,
                COUNT(a.id) AS total_appointments,
                SUM(
                    CASE
                        WHEN a.status = 'COMPLETED'
                        THEN 1 ELSE 0
                    END
                ) AS completed_appointments,
                SUM(
                    CASE
                        WHEN a.status = 'CANCELLED'
                        THEN 1 ELSE 0
                    END
                ) AS cancelled_appointments,
                SUM(
                    CASE
                        WHEN a.status = 'NO_SHOW'
                        THEN 1 ELSE 0
                    END
                ) AS no_show_appointments
            FROM dentists d
            LEFT JOIN appointments a
                ON d.id = a.dentist_id
                AND a.appointment_date BETWEEN ? AND ?
            GROUP BY d.id, d.full_name
            ORDER BY total_appointments DESC,
                     d.full_name
            """;

    try (Connection connection = DatabaseConnection.getConnection();
         PreparedStatement statement =
                 connection.prepareStatement(sql)) {

        statement.setDate(1, Date.valueOf(startDate));
        statement.setDate(2, Date.valueOf(endDate));

        try (ResultSet resultSet = statement.executeQuery()) {

            while (resultSet.next()) {

                DentistReport report =
                        new DentistReport();

                report.setDentistName(
                        resultSet.getString("dentist_name")
                );

                report.setTotalAppointments(
                        resultSet.getInt("total_appointments")
                );

                report.setCompletedAppointments(
                        resultSet.getInt(
                                "completed_appointments"
                        )
                );

                report.setCancelledAppointments(
                        resultSet.getInt(
                                "cancelled_appointments"
                        )
                );

                report.setNoShowAppointments(
                        resultSet.getInt(
                                "no_show_appointments"
                        )
                );

                reports.add(report);
            }
        }
    }

    return reports;
}


public List<PatientReport> getPatientReport(
        LocalDate startDate,
        LocalDate endDate) throws SQLException {

    List<PatientReport> reports = new ArrayList<>();

    String sql = """
            SELECT
                p.full_name AS patient_name,
                COUNT(a.id) AS total_appointments,
                SUM(
                    CASE
                        WHEN a.status = 'COMPLETED'
                        THEN 1 ELSE 0
                    END
                ) AS completed_appointments,
                MAX(a.appointment_date) AS last_appointment
            FROM patients p
            LEFT JOIN appointments a
                ON p.id = a.patient_id
                AND a.appointment_date BETWEEN ? AND ?
            GROUP BY p.id, p.full_name
            ORDER BY total_appointments DESC,
                     p.full_name
            """;

    try (Connection connection = DatabaseConnection.getConnection();
         PreparedStatement statement =
                 connection.prepareStatement(sql)) {

        statement.setDate(1, Date.valueOf(startDate));
        statement.setDate(2, Date.valueOf(endDate));

        try (ResultSet resultSet = statement.executeQuery()) {

            while (resultSet.next()) {

                PatientReport report =
                        new PatientReport();

                report.setPatientName(
                        resultSet.getString("patient_name")
                );

                report.setTotalAppointments(
                        resultSet.getInt("total_appointments")
                );

                report.setCompletedAppointments(
                        resultSet.getInt(
                                "completed_appointments"
                        )
                );

                Date lastAppointment =
                        resultSet.getDate("last_appointment");

                if (lastAppointment != null) {
                    report.setLastAppointment(
                            lastAppointment.toLocalDate()
                    );
                }

                reports.add(report);
            }
        }
    }

    return reports;
}

}