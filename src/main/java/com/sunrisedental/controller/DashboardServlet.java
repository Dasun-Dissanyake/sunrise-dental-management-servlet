package com.sunrisedental.controller;

import com.sunrisedental.model.User;
import com.sunrisedental.service.DashboardService;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import com.sunrisedental.model.DashboardAppointment;
import java.util.List;
import java.io.IOException;
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

        User user =
                (User) session.getAttribute("loggedInUser");

        try {

            int totalPatients =
                    dashboardService.getTotalPatients();

            int totalAppointments =
                    dashboardService.getTotalAppointments();

            int todaysAppointments =
                    dashboardService.getTodaysAppointments();

            double totalRevenue =
                    dashboardService.getTotalRevenue();

                    List<DashboardAppointment> recentAppointments =
        dashboardService.getRecentAppointments();

            request.setAttribute(
                    "user",
                    user
            );

            request.setAttribute(
                    "totalPatients",
                    totalPatients
            );

            request.setAttribute(
                    "totalAppointments",
                    totalAppointments
            );

            request.setAttribute(
                    "todaysAppointments",
                    todaysAppointments
            );

            request.setAttribute(
                    "totalRevenue",
                    totalRevenue
            );

            request.setAttribute(
        "recentAppointments",
        recentAppointments
);

            request.getRequestDispatcher(
                    "/pages/dashboard.jsp"
            ).forward(request, response);

        } catch (SQLException e) {

            throw new ServletException(
                    "Unable to load dashboard statistics.",
                    e
            );
        }
    }
}