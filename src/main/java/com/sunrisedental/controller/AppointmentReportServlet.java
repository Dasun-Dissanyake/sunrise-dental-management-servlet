package com.sunrisedental.controller;

import com.sunrisedental.model.User;
import com.sunrisedental.service.AppointmentReportService;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.time.LocalDate;
import java.util.Map;

@WebServlet("/reports/appointments")
public class AppointmentReportServlet extends HttpServlet {

    private final AppointmentReportService appointmentReportService =
            new AppointmentReportService();

    @Override
    protected void doGet(
            HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session =
                request.getSession(false);

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

        request.setAttribute("user", user);

        String startDateParameter =
                request.getParameter("startDate");

        String endDateParameter =
                request.getParameter("endDate");

        LocalDate startDate;
        LocalDate endDate;

        if (startDateParameter == null ||
                startDateParameter.isBlank()) {

            startDate = LocalDate.now()
                    .withDayOfMonth(1);

        } else {

            startDate =
                    LocalDate.parse(startDateParameter);
        }

        if (endDateParameter == null ||
                endDateParameter.isBlank()) {

            endDate = LocalDate.now();

        } else {

            endDate =
                    LocalDate.parse(endDateParameter);
        }

        try {

            Map<String, Integer> statusReport =
                    appointmentReportService
                            .getAppointmentStatusReport(
                                    startDate,
                                    endDate
                            );

            int totalAppointments =
                    appointmentReportService
                            .getTotalAppointments(
                                    startDate,
                                    endDate
                            );

            request.setAttribute(
                    "startDate",
                    startDate
            );

            request.setAttribute(
                    "endDate",
                    endDate
            );

            request.setAttribute(
                    "statusReport",
                    statusReport
            );

            request.setAttribute(
                    "totalAppointments",
                    totalAppointments
            );

            request.getRequestDispatcher(
                    "/pages/appointment-report.jsp"
            ).forward(request, response);

        } catch (IllegalArgumentException e) {

            request.setAttribute(
                    "error",
                    e.getMessage()
            );

            request.getRequestDispatcher(
                    "/pages/appointment-report.jsp"
            ).forward(request, response);

        } catch (Exception e) {

            throw new ServletException(
                    "Unable to generate appointment report.",
                    e
            );
        }
    }
}