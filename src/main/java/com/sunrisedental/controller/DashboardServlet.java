package com.sunrisedental.controller;

import com.sunrisedental.model.User;
import com.sunrisedental.service.DashboardService;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.math.BigDecimal;
import java.sql.SQLException;

@WebServlet("/dashboard")
public class DashboardServlet extends HttpServlet {

    private DashboardService dashboardService;

    @Override
    public void init() {
        dashboardService = new DashboardService();
    }

    @Override
    protected void doGet(
            HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);

        if (session == null ||
                session.getAttribute("loggedInUser") == null) {

            response.sendRedirect(
                    request.getContextPath()
                            + "/pages/login.html"
            );

            return;
        }

        try {

            User user =
                    (User) session.getAttribute("loggedInUser");

            request.setAttribute(
                    "user",
                    user
            );

            // Load dashboard statistics

            long totalPatients =
                    dashboardService.getTotalPatients();

            long totalAppointments =
                    dashboardService.getTotalAppointments();

            long todayAppointments =
                    dashboardService.getTodayAppointments();

            BigDecimal totalRevenue =
                    dashboardService.getTotalRevenue();

            // Send statistics to dashboard.jsp

            request.setAttribute(
                    "totalPatients",
                    totalPatients
            );

            request.setAttribute(
                    "totalAppointments",
                    totalAppointments
            );

            request.setAttribute(
                    "todayAppointments",
                    todayAppointments
            );

            request.setAttribute(
                    "totalRevenue",
                    totalRevenue
            );

            // Open dashboard

            request.getRequestDispatcher(
                    "/pages/dashboard.jsp"
            ).forward(
                    request,
                    response
            );

        } catch (SQLException e) {

            throw new ServletException(
                    "Unable to load dashboard statistics.",
                    e
            );
        }
    }
}