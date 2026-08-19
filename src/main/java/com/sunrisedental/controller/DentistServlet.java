
package com.sunrisedental.controller;

import com.sunrisedental.model.Dentist;
import com.sunrisedental.service.DentistService;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.sql.SQLException;
import java.util.List;

@WebServlet("/dentists")
public class DentistServlet extends HttpServlet {

    private DentistService dentistService;

    @Override
    public void init() {
        dentistService = new DentistService();
    }

    @Override
    protected void doGet(
            HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {

        try {
            String dentistNumber = request.getParameter("dentistNumber");

            if (dentistNumber != null && !dentistNumber.isBlank()) {
                Dentist dentist = dentistService.getDentistByNumber(dentistNumber.trim());
                request.setAttribute("searchedDentist", dentist);
            } else {
                List<Dentist> dentists = dentistService.getAllDentists();
                request.setAttribute("dentists", dentists);
            }

            request.getRequestDispatcher("/pages/dentists.jsp").forward(request, response);

        } catch (SQLException e) {
            throw new ServletException("Unable to load dentist information.", e);
        }
    }

    @Override
    protected void doPost(
            HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {

        String action = request.getParameter("action");

        try {
            if ("update".equals(action)) {
                updateDentist(request, response);
            } else if ("deactivate".equals(action)) {
                deactivateDentist(request, response);
            } else {
                addDentist(request, response);
            }
        } catch (IllegalArgumentException e) {
            request.setAttribute("error", e.getMessage());
            loadDentistsAndForward(request, response);
        } catch (SQLException e) {
            request.setAttribute(
                    "error",
                    "Unable to process dentist information. The dentist number may already exist."
            );
            loadDentistsAndForward(request, response);
        }
    }

    private void addDentist(
            HttpServletRequest request,
            HttpServletResponse response)
            throws SQLException, IOException {

        Dentist dentist = new Dentist();
        dentist.setDentistNumber(request.getParameter("dentistNumber"));
        dentist.setFullName(request.getParameter("fullName"));
        dentist.setSpecialization(request.getParameter("specialization"));
        dentist.setContactNumber(request.getParameter("contactNumber"));

        dentistService.addDentist(dentist);

        response.sendRedirect(
                request.getContextPath() + "/dentists?success=registered"
        );
    }

    private void updateDentist(
            HttpServletRequest request,
            HttpServletResponse response)
            throws SQLException, IOException {

        String idParameter = request.getParameter("id");
        if (idParameter == null || idParameter.isBlank()) {
            throw new IllegalArgumentException("Dentist ID is required for update.");
        }

        Long id;
        try {
            id = Long.parseLong(idParameter.trim());
        } catch (NumberFormatException e) {
            throw new IllegalArgumentException("Invalid dentist ID format.");
        }

        Dentist dentist = new Dentist();
        dentist.setId(id);
        dentist.setFullName(request.getParameter("fullName"));
        dentist.setSpecialization(request.getParameter("specialization"));
        dentist.setContactNumber(request.getParameter("contactNumber"));

        dentistService.updateDentist(dentist);

        response.sendRedirect(
                request.getContextPath() + "/dentists?success=updated"
        );
    }

    private void deactivateDentist(
            HttpServletRequest request,
            HttpServletResponse response)
            throws SQLException, IOException {

        String idParameter = request.getParameter("id");
        if (idParameter == null || idParameter.isBlank()) {
            throw new IllegalArgumentException("Dentist ID is required for deactivation.");
        }

        Long id;
        try {
            id = Long.parseLong(idParameter.trim());
        } catch (NumberFormatException e) {
            throw new IllegalArgumentException("Invalid dentist ID format.");
        }

        dentistService.deactivateDentist(id);

        response.sendRedirect(
                request.getContextPath() + "/dentists?success=deactivated"
        );
    }

    private void loadDentistsAndForward(
            HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {

        try {
            List<Dentist> dentists = dentistService.getAllDentists();
            request.setAttribute("dentists", dentists);
            request.getRequestDispatcher("/pages/dentists.jsp").forward(request, response);
        } catch (SQLException e) {
            throw new ServletException("Unable to load dentists.", e);
        }
    }
}

