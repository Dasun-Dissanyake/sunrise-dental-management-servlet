
package com.sunrisedental.controller;

import com.sunrisedental.model.Appointment;
import com.sunrisedental.service.AppointmentService;
import com.sunrisedental.service.DentistService;
import com.sunrisedental.service.PatientService;
import com.sunrisedental.service.TreatmentService;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.sql.SQLException;
import java.time.LocalDate;
import java.time.LocalTime;
import java.util.List;

@WebServlet("/appointments")
public class AppointmentServlet extends HttpServlet {

    private AppointmentService appointmentService;
    private PatientService patientService;
    private DentistService dentistService;
    private TreatmentService treatmentService;

    @Override
    public void init() {
        appointmentService = new AppointmentService();
        patientService = new PatientService();
        dentistService = new DentistService();
        treatmentService = new TreatmentService();
    }

    @Override
    protected void doGet(
            HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {

        try {
            loadLookupData(request);

            String appointmentNumber = request.getParameter("appointmentNumber");
            if (appointmentNumber != null && !appointmentNumber.isBlank()) {
                Appointment appointment = appointmentService.getAppointmentByNumber(appointmentNumber.trim());
                request.setAttribute("searchedAppointment", appointment);
            }

            List<Appointment> appointments = appointmentService.getAllAppointments();
            request.setAttribute("appointments", appointments);

            request.getRequestDispatcher("/pages/appointments.jsp").forward(request, response);

        } catch (SQLException e) {
            throw new ServletException("Unable to load appointment information.", e);
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
                updateAppointment(request, response);
            } else if ("status".equals(action) || "updateStatus".equals(action)) {
                updateAppointmentStatus(request, response);
            } else {
                registerAppointment(request, response);
            }
        } catch (IllegalArgumentException e) {
            request.setAttribute("error", e.getMessage());
            loadDataAndForward(request, response);
        } catch (SQLException e) {
            request.setAttribute(
                    "error",
                    "Unable to process appointment. The appointment number may already exist or references are invalid."
            );
            loadDataAndForward(request, response);
        }
    }

    private void registerAppointment(
            HttpServletRequest request,
            HttpServletResponse response)
            throws SQLException, IOException {

        Appointment appointment = new Appointment();
        appointment.setAppointmentNumber(request.getParameter("appointmentNumber"));

        String dateStr = request.getParameter("appointmentDate");
        if (dateStr != null && !dateStr.isBlank()) {
            appointment.setAppointmentDate(LocalDate.parse(dateStr.trim()));
        }

        String timeStr = request.getParameter("appointmentTime");
        if (timeStr != null && !timeStr.isBlank()) {
            String cleanTime = timeStr.trim();
            if (cleanTime.length() == 5) {
                cleanTime += ":00";
            }
            appointment.setAppointmentTime(LocalTime.parse(cleanTime));
        }

        String patientIdStr = request.getParameter("patientId");
        if (patientIdStr != null && !patientIdStr.isBlank()) {
            appointment.setPatientId(Long.parseLong(patientIdStr.trim()));
        }

        String dentistIdStr = request.getParameter("dentistId");
        if (dentistIdStr != null && !dentistIdStr.isBlank()) {
            appointment.setDentistId(Long.parseLong(dentistIdStr.trim()));
        }

        String treatmentIdStr = request.getParameter("treatmentId");
        if (treatmentIdStr != null && !treatmentIdStr.isBlank()) {
            appointment.setTreatmentId(Long.parseLong(treatmentIdStr.trim()));
        }

        appointment.setNotes(request.getParameter("notes"));
        appointment.setStatus("SCHEDULED");

        appointmentService.registerAppointment(appointment);

        response.sendRedirect(
                request.getContextPath() + "/appointments?success=registered"
        );
    }

    private void updateAppointment(
            HttpServletRequest request,
            HttpServletResponse response)
            throws SQLException, IOException {

        String idParameter = request.getParameter("id");
        if (idParameter == null || idParameter.isBlank()) {
            throw new IllegalArgumentException("Appointment ID is required for update.");
        }

        Long id;
        try {
            id = Long.parseLong(idParameter.trim());
        } catch (NumberFormatException e) {
            throw new IllegalArgumentException("Invalid appointment ID format.");
        }

        Appointment appointment = new Appointment();
        appointment.setId(id);
        appointment.setAppointmentNumber(request.getParameter("appointmentNumber"));

        String dateStr = request.getParameter("appointmentDate");
        if (dateStr != null && !dateStr.isBlank()) {
            appointment.setAppointmentDate(LocalDate.parse(dateStr.trim()));
        }

        String timeStr = request.getParameter("appointmentTime");
        if (timeStr != null && !timeStr.isBlank()) {
            String cleanTime = timeStr.trim();
            if (cleanTime.length() == 5) {
                cleanTime += ":00";
            }
            appointment.setAppointmentTime(LocalTime.parse(cleanTime));
        }

        String patientIdStr = request.getParameter("patientId");
        if (patientIdStr != null && !patientIdStr.isBlank()) {
            appointment.setPatientId(Long.parseLong(patientIdStr.trim()));
        }

        String dentistIdStr = request.getParameter("dentistId");
        if (dentistIdStr != null && !dentistIdStr.isBlank()) {
            appointment.setDentistId(Long.parseLong(dentistIdStr.trim()));
        }

        String treatmentIdStr = request.getParameter("treatmentId");
        if (treatmentIdStr != null && !treatmentIdStr.isBlank()) {
            appointment.setTreatmentId(Long.parseLong(treatmentIdStr.trim()));
        }

        appointment.setNotes(request.getParameter("notes"));

        String statusStr = request.getParameter("status");
        if (statusStr != null && !statusStr.isBlank()) {
            appointment.setStatus(statusStr.trim());
        }

        appointmentService.updateAppointment(appointment);

        response.sendRedirect(
                request.getContextPath() + "/appointments?success=updated"
        );
    }

    private void updateAppointmentStatus(
            HttpServletRequest request,
            HttpServletResponse response)
            throws SQLException, IOException {

        String idParameter = request.getParameter("id");
        if (idParameter == null || idParameter.isBlank()) {
            throw new IllegalArgumentException("Appointment ID is required.");
        }

        Long id;
        try {
            id = Long.parseLong(idParameter.trim());
        } catch (NumberFormatException e) {
            throw new IllegalArgumentException("Invalid appointment ID format.");
        }

        String status = request.getParameter("status");
        appointmentService.updateAppointmentStatus(id, status);

        response.sendRedirect(
                request.getContextPath() + "/appointments?success=status_updated"
        );
    }

    private void loadLookupData(HttpServletRequest request) throws SQLException {
        request.setAttribute("patients", patientService.getAllPatients());
        request.setAttribute("dentists", dentistService.getAllDentists());
        request.setAttribute("treatments", treatmentService.getAllTreatments());
    }

    private void loadDataAndForward(
            HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {

        try {
            loadLookupData(request);
            List<Appointment> appointments = appointmentService.getAllAppointments();
            request.setAttribute("appointments", appointments);
            request.getRequestDispatcher("/pages/appointments.jsp").forward(request, response);
        } catch (SQLException e) {
            throw new ServletException("Unable to load appointment data.", e);
        }
    }
}

