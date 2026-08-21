package com.sunrisedental.service;

import com.sunrisedental.dao.DashboardDAO;

import java.sql.SQLException;
import com.sunrisedental.model.DashboardAppointment;
import java.util.List;

public class DashboardService {

    private final DashboardDAO dashboardDAO;

    public DashboardService() {
        this.dashboardDAO = new DashboardDAO();
    }

    public int getTotalPatients() throws SQLException {
        return dashboardDAO.getTotalPatients();
    }

    public int getTotalAppointments() throws SQLException {
        return dashboardDAO.getTotalAppointments();
    }

    public int getTodaysAppointments() throws SQLException {
        return dashboardDAO.getTodaysAppointments();
    }

    public double getTotalRevenue() throws SQLException {
        return dashboardDAO.getTotalRevenue();
    }

    public List<DashboardAppointment> getRecentAppointments()
        throws SQLException {

    return dashboardDAO.getRecentAppointments();
}
}