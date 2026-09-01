package com.sunrisedental.controller;

import com.sunrisedental.model.Treatment;
import com.sunrisedental.service.TreatmentService;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.sql.SQLException;
import java.util.List;

@WebServlet("/treatments")
public class TreatmentServlet extends HttpServlet {

    private TreatmentService treatmentService;

    public TreatmentServlet() {
        this.treatmentService = new TreatmentService();
    }

    public TreatmentServlet(TreatmentService treatmentService) {
        this.treatmentService = treatmentService;
    }

    @Override
    public void init() {
        if (this.treatmentService == null) {
            this.treatmentService = new TreatmentService();
        }
    }

    @Override
    protected void doGet(
            HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {

        try {
            String treatmentCode = request.getParameter("treatmentCode");

            if (treatmentCode != null && !treatmentCode.isBlank()) {
                Treatment treatment = treatmentService.getTreatmentByCode(treatmentCode.trim());
                request.setAttribute("searchedTreatment", treatment);
            }

            List<Treatment> treatments = treatmentService.getAllTreatments();
            request.setAttribute("treatments", treatments);

            request.getRequestDispatcher("/pages/treatments.jsp").forward(request, response);

        } catch (SQLException e) {
            throw new ServletException("Unable to load treatment information.", e);
        }
    }

    @Override
    protected void doPost(
            HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {

        String action = request.getParameter("action");

        try {
            if ("deactivate".equalsIgnoreCase(action)) {
                deactivateTreatment(request, response);
            } else {
                addTreatment(request, response);
            }
        } catch (IllegalArgumentException e) {
            request.setAttribute("error", e.getMessage());
            loadTreatmentsAndForward(request, response);
        } catch (SQLException e) {
            request.setAttribute(
                    "error",
                    "Unable to process treatment. The treatment code may already exist."
            );
            loadTreatmentsAndForward(request, response);
        }
    }

    private void addTreatment(
            HttpServletRequest request,
            HttpServletResponse response)
            throws SQLException, IOException {

        String treatmentCode = request.getParameter("treatmentCode");
        String treatmentName = request.getParameter("treatmentName");
        String description = request.getParameter("description");
        String costStr = request.getParameter("treatmentCost");
        String feeStr = request.getParameter("consultationFee");

        Double treatmentCost = null;
        if (costStr != null && !costStr.isBlank()) {
            try {
                treatmentCost = Double.parseDouble(costStr.trim());
            } catch (NumberFormatException e) {
                throw new IllegalArgumentException("Treatment cost must be a valid numeric value.");
            }
        }

        Double consultationFee = null;
        if (feeStr != null && !feeStr.isBlank()) {
            try {
                consultationFee = Double.parseDouble(feeStr.trim());
            } catch (NumberFormatException e) {
                throw new IllegalArgumentException("Consultation fee must be a valid numeric value.");
            }
        }

        Treatment treatment = new Treatment();
        treatment.setTreatmentCode(treatmentCode != null ? treatmentCode.trim() : null);
        treatment.setTreatmentName(treatmentName != null ? treatmentName.trim() : null);
        treatment.setDescription(description != null && !description.isBlank() ? description.trim() : null);
        treatment.setTreatmentCost(treatmentCost);
        treatment.setConsultationFee(consultationFee);

        treatmentService.addTreatment(treatment);

        response.sendRedirect(
                request.getContextPath() + "/treatments?success=registered"
        );
    }

    private void deactivateTreatment(
            HttpServletRequest request,
            HttpServletResponse response)
            throws SQLException, IOException {

        String idParameter = request.getParameter("id");
        if (idParameter == null || idParameter.isBlank()) {
            throw new IllegalArgumentException("Treatment ID is required for deactivation.");
        }

        Long id;
        try {
            id = Long.parseLong(idParameter.trim());
        } catch (NumberFormatException e) {
            throw new IllegalArgumentException("Invalid treatment ID format.");
        }

        treatmentService.deactivateTreatment(id);

        response.sendRedirect(
                request.getContextPath() + "/treatments?success=deactivated"
        );
    }

    private void loadTreatmentsAndForward(
            HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {

        try {
            List<Treatment> treatments = treatmentService.getAllTreatments();
            request.setAttribute("treatments", treatments);
            request.getRequestDispatcher("/pages/treatments.jsp").forward(request, response);
        } catch (SQLException e) {
            throw new ServletException("Unable to load treatments.", e);
        }
    }
}