package com.sunrisedental.service;

import com.sunrisedental.dao.AppointmentReportDAO;

import java.sql.SQLException;
import java.time.LocalDate;
import java.util.Map;

public class AppointmentReportService {

    private final AppointmentReportDAO appointmentReportDAO;

    public AppointmentReportService() {
        this.appointmentReportDAO =
                new AppointmentReportDAO();
    }

    public Map<String, Integer> getAppointmentStatusReport(
            LocalDate startDate,
            LocalDate endDate) throws SQLException {

        validateDateRange(startDate, endDate);

        return appointmentReportDAO.getAppointmentStatusReport(
                startDate,
                endDate
        );
    }

    public int getTotalAppointments(
            LocalDate startDate,
            LocalDate endDate) throws SQLException {

        validateDateRange(startDate, endDate);

        return appointmentReportDAO.getTotalAppointments(
                startDate,
                endDate
        );
    }

    private void validateDateRange(
            LocalDate startDate,
            LocalDate endDate) {

        if (startDate == null) {
            throw new IllegalArgumentException(
                    "Start date is required."
            );
        }

        if (endDate == null) {
            throw new IllegalArgumentException(
                    "End date is required."
            );
        }

        if (startDate.isAfter(endDate)) {
            throw new IllegalArgumentException(
                    "Start date cannot be after end date."
            );
        }
    }
}