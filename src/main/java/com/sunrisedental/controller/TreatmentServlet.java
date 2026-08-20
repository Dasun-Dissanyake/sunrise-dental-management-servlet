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

    @Override
    public void init() {
        treatmentService = new TreatmentService();
    }

    @Override
    protected void doGet(
            HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {

        try {

            String treatmentCode =
                    request.getParameter("treatmentCode");

            if (treatmentCode != null &&
                    !treatmentCode.isBlank()) {

                Treatment treatment =
                        treatmentService.getTreatmentByCode(
                                treatmentCode.trim()
                        );

                request.setAttribute(
                        "searchedTreatment",
                        treatment
                );

            } else {

                List<Treatment> treatments =
                        treatmentService.getAllTreatments();

                request.setAttribute(
                        "treatments",
                        treatments
                );
            }

            request.getRequestDispatcher(
                    "/pages/treatments.jsp"
            ).forward(request, response);

        } catch (SQLException e) {

            throw new ServletException(
                    "Unable to load treatment information.",
                    e
            );
        }
    }
}