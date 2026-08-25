package com.sunrisedental.service;

import com.sunrisedental.dao.ReportDAO;
import com.sunrisedental.model.DentistReport;
import com.sunrisedental.model.PatientReport;
import com.sunrisedental.model.TreatmentReport;

import java.util.List;

import java.sql.SQLException;
import java.time.LocalDate;

public class ReportService {

    private final ReportDAO reportDAO;

    public ReportService() {
        this.reportDAO = new ReportDAO();
    }

    public double getTotalRevenue(
            LocalDate startDate,
            LocalDate endDate) throws SQLException {

        validateDateRange(startDate, endDate);

        return reportDAO.getTotalRevenue(
                startDate,
                endDate
        );
    }

    public double getTotalConsultationFees(
            LocalDate startDate,
            LocalDate endDate) throws SQLException {

        validateDateRange(startDate, endDate);

        return reportDAO.getTotalConsultationFees(
                startDate,
                endDate
        );
    }

    public double getTotalTreatmentRevenue(
            LocalDate startDate,
            LocalDate endDate) throws SQLException {

        validateDateRange(startDate, endDate);

        return reportDAO.getTotalTreatmentRevenue(
                startDate,
                endDate
        );
    }

    public int getTotalBills(
            LocalDate startDate,
            LocalDate endDate) throws SQLException {

        validateDateRange(startDate, endDate);

        return reportDAO.getTotalBills(
                startDate,
                endDate
        );
    }

    public double getAverageBillAmount(
            LocalDate startDate,
            LocalDate endDate) throws SQLException {

        validateDateRange(startDate, endDate);

        return reportDAO.getAverageBillAmount(
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
public List<TreatmentReport> getTreatmentReport(
        LocalDate startDate,
        LocalDate endDate) throws SQLException {

    validateDateRange(startDate, endDate);

    return reportDAO.getTreatmentReport(
            startDate,
            endDate
    );
}


public List<DentistReport> getDentistReport(
        LocalDate startDate,
        LocalDate endDate) throws SQLException {

    validateDateRange(startDate, endDate);

    return reportDAO.getDentistReport(
            startDate,
            endDate
    );
}


public List<PatientReport> getPatientReport(
        LocalDate startDate,
        LocalDate endDate) throws SQLException {

    validateDateRange(startDate, endDate);

    return reportDAO.getPatientReport(
            startDate,
            endDate
    );
}
    
}