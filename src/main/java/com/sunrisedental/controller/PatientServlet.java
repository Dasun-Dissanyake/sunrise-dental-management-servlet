package com.sunrisedental.controller;

import com.sunrisedental.model.Patient;
import com.sunrisedental.service.PatientService;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.sql.SQLException;
import java.time.LocalDate;
import java.util.List;

@WebServlet("/patients")
public class PatientServlet extends HttpServlet {

    private PatientService patientService;

    @Override
    public void init() {
        patientService = new PatientService();
    }

    @Override
    protected void doGet(
            HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {

        try {

            String patientNumber =
                    request.getParameter("patientNumber");

            if (patientNumber != null &&
                    !patientNumber.isBlank()) {

                Patient patient =
                        patientService.findPatient(
                                patientNumber
                        );

                request.setAttribute(
                        "searchedPatient",
                        patient
                );

            } else {

                List<Patient> patients =
                        patientService.getAllPatients();

                request.setAttribute(
                        "patients",
                        patients
                );
            }

            request.getRequestDispatcher(
                    "/pages/patients.jsp"
            ).forward(request, response);

        } catch (SQLException e) {

            throw new ServletException(
                    "Unable to load patient information.",
                    e
            );
        }
    }

    @Override
    protected void doPost(
            HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {

        try {

            Patient patient = new Patient();

            patient.setPatientNumber(
                    request.getParameter("patientNumber")
            );

            patient.setFullName(
                    request.getParameter("fullName")
            );

            patient.setAddress(
                    request.getParameter("address")
            );

            patient.setContactNumber(
                    request.getParameter("contactNumber")
            );

            String dateOfBirth =
                    request.getParameter("dateOfBirth");

            if (dateOfBirth != null &&
                    !dateOfBirth.isBlank()) {

                patient.setDateOfBirth(
                        LocalDate.parse(dateOfBirth)
                );
            }

            patient.setEmail(
                    request.getParameter("email")
            );

            patient.setGender(
                    request.getParameter("gender")
            );

            patientService.registerPatient(patient);

            response.sendRedirect(
                    request.getContextPath()
                            + "/patients?success=registered"
            );

        } catch (IllegalArgumentException e) {

            request.setAttribute(
                    "error",
                    e.getMessage()
            );

            request.getRequestDispatcher(
                    "/pages/patients.jsp"
            ).forward(request, response);

        } catch (SQLException e) {

            request.setAttribute(
                    "error",
                    "Unable to register patient. "
                            + "The patient number may already exist."
            );

            request.getRequestDispatcher(
                    "/pages/patients.jsp"
            ).forward(request, response);
        }
    }
}