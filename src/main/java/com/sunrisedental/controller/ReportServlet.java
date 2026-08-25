package com.sunrisedental.controller;

import com.sunrisedental.model.DentistReport;
import com.sunrisedental.model.PatientReport;
import com.sunrisedental.model.TreatmentReport;
import com.sunrisedental.model.User;
import com.sunrisedental.service.ReportService;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.time.LocalDate;
import java.util.List;

@WebServlet("/reports")
public class ReportServlet extends HttpServlet {

    private ReportService reportService;

    @Override
    public void init() {
        reportService = new ReportService();
    }

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

        LocalDate startDate;
        LocalDate endDate;

        String startDateParameter =
                request.getParameter("startDate");

        String endDateParameter =
                request.getParameter("endDate");

        try {

            /*
             * Default date range:
             * First day of current month → today
             */
            if (startDateParameter == null ||
                    startDateParameter.isBlank()) {

                startDate =
                        LocalDate.now()
                                .withDayOfMonth(1);

            } else {

                startDate =
                        LocalDate.parse(startDateParameter);
            }

            if (endDateParameter == null ||
                    endDateParameter.isBlank()) {

                endDate =
                        LocalDate.now();

            } else {

                endDate =
                        LocalDate.parse(endDateParameter);
            }

            /*
             * Validate the date range
             */
            if (startDate.isAfter(endDate)) {

                throw new IllegalArgumentException(
                        "Start date cannot be after end date."
                );
            }

            /*
             * Revenue Report
             */
            double totalRevenue =
                    reportService.getTotalRevenue(
                            startDate,
                            endDate
                    );

            double totalConsultationFees =
                    reportService.getTotalConsultationFees(
                            startDate,
                            endDate
                    );

            double totalTreatmentRevenue =
                    reportService.getTotalTreatmentRevenue(
                            startDate,
                            endDate
                    );

            int totalBills =
                    reportService.getTotalBills(
                            startDate,
                            endDate
                    );

            double averageBillAmount =
                    reportService.getAverageBillAmount(
                            startDate,
                            endDate
                    );

            /*
             * Treatment Report
             */
            List<TreatmentReport> treatmentReports =
                    reportService.getTreatmentReport(
                            startDate,
                            endDate
                    );

            /*
             * Dentist Report
             */
            List<DentistReport> dentistReports =
                    reportService.getDentistReport(
                            startDate,
                            endDate
                    );

            /*
             * Patient Report
             */
            List<PatientReport> patientReports =
                    reportService.getPatientReport(
                            startDate,
                            endDate
                    );

            /*
             * Send report data to JSP
             */
            request.setAttribute(
                    "startDate",
                    startDate
            );

            request.setAttribute(
                    "endDate",
                    endDate
            );

            request.setAttribute(
                    "totalRevenue",
                    totalRevenue
            );

            request.setAttribute(
                    "totalConsultationFees",
                    totalConsultationFees
            );

            request.setAttribute(
                    "totalTreatmentRevenue",
                    totalTreatmentRevenue
            );

            request.setAttribute(
                    "totalBills",
                    totalBills
            );

            request.setAttribute(
                    "averageBillAmount",
                    averageBillAmount
            );

            request.setAttribute(
                    "treatmentReports",
                    treatmentReports
            );

            request.setAttribute(
                    "dentistReports",
                    dentistReports
            );

            request.setAttribute(
                    "patientReports",
                    patientReports
            );

            /*
             * Open Reports page
             */
            request.getRequestDispatcher(
                    "/pages/reports.jsp"
            ).forward(
                    request,
                    response
            );

        } catch (IllegalArgumentException e) {

            request.setAttribute(
                    "error",
                    e.getMessage()
            );

            request.setAttribute(
                    "startDate",
                    startDateParameter
            );

            request.setAttribute(
                    "endDate",
                    endDateParameter
            );

            request.getRequestDispatcher(
                    "/pages/reports.jsp"
            ).forward(
                    request,
                    response
            );

        } catch (Exception e) {

            throw new ServletException(
                    "Unable to generate reports.",
                    e
            );
        }
    }
}