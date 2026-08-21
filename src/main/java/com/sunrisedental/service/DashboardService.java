package com.sunrisedental.service;

import com.sunrisedental.dao.DashboardDAO;

import java.math.BigDecimal;
import java.sql.SQLException;

public class DashboardService {

    private final DashboardDAO dashboardDAO;

    public DashboardService() {
        dashboardDAO = new DashboardDAO();
    }

    public long getTotalPatients()
            throws SQLException {

        return dashboardDAO.getTotalPatients();
    }

    public long getTotalAppointments()
            throws SQLException {

        return dashboardDAO.getTotalAppointments();
    }

    public long getTodayAppointments()
            throws SQLException {

        return dashboardDAO.getTodayAppointments();
    }

    public BigDecimal getTotalRevenue()
            throws SQLException {

        return dashboardDAO.getTotalRevenue();
    }
}