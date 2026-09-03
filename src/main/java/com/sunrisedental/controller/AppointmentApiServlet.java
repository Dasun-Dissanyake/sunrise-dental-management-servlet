package com.sunrisedental.controller;

import com.google.gson.Gson;
import com.google.gson.GsonBuilder;
import com.google.gson.JsonPrimitive;
import com.google.gson.JsonSerializer;
import com.sunrisedental.model.Appointment;
import com.sunrisedental.service.AppointmentService;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.sql.SQLException;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.LocalTime;
import java.time.format.DateTimeFormatter;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * REST-style Web Service API Servlet for Appointments.
 * Follows layered architecture: HTTP -> Servlet -> Service -> DAO -> JDBC -> MySQL.
 *
 * Endpoints:
 * - GET /api/appointments        : Returns JSON list of all appointments
 * - GET /api/appointments/{id}   : Returns JSON details of a specific appointment by ID
 */
@WebServlet(urlPatterns = {"/api/appointments", "/api/appointments/*"})
public class AppointmentApiServlet extends HttpServlet {

    private AppointmentService appointmentService;
    private final Gson gson;

    public AppointmentApiServlet() {
        this.appointmentService = new AppointmentService();
        this.gson = createGson();
    }

    public AppointmentApiServlet(AppointmentService appointmentService) {
        this.appointmentService = appointmentService;
        this.gson = createGson();
    }

    private Gson createGson() {
        return new GsonBuilder()
                .registerTypeAdapter(LocalDate.class, (JsonSerializer<LocalDate>) (src, typeOfSrc, context) ->
                        new JsonPrimitive(src.format(DateTimeFormatter.ISO_LOCAL_DATE)))
                .registerTypeAdapter(LocalTime.class, (JsonSerializer<LocalTime>) (src, typeOfSrc, context) ->
                        new JsonPrimitive(src.format(DateTimeFormatter.ISO_LOCAL_TIME)))
                .registerTypeAdapter(LocalDateTime.class, (JsonSerializer<LocalDateTime>) (src, typeOfSrc, context) ->
                        new JsonPrimitive(src.format(DateTimeFormatter.ISO_LOCAL_DATE_TIME)))
                .serializeNulls()
                .setPrettyPrinting()
                .create();
    }

    @Override
    public void init() {
        if (this.appointmentService == null) {
            this.appointmentService = new AppointmentService();
        }
    }

    @Override
    public void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String pathInfo = request.getPathInfo();

        try {
            if (pathInfo == null || pathInfo.equals("/") || pathInfo.isBlank()) {
                handleGetAllAppointments(response);
            } else {
                handleGetAppointmentById(pathInfo, response);
            }
        } catch (SQLException e) {
            sendErrorResponse(response, HttpServletResponse.SC_INTERNAL_SERVER_ERROR,
                    "Database error occurred while processing appointment request.");
        } catch (Exception e) {
            sendErrorResponse(response, HttpServletResponse.SC_INTERNAL_SERVER_ERROR,
                    "An unexpected error occurred: " + e.getMessage());
        }
    }

    private void handleGetAllAppointments(HttpServletResponse response) throws SQLException, IOException {
        List<Appointment> appointments = appointmentService.getAllAppointments();
        sendJsonResponse(response, HttpServletResponse.SC_OK, appointments);
    }

    private void handleGetAppointmentById(String pathInfo, HttpServletResponse response)
            throws SQLException, IOException {

        String rawId = pathInfo.startsWith("/") ? pathInfo.substring(1) : pathInfo;
        rawId = rawId.trim();

        if (rawId.isEmpty()) {
            handleGetAllAppointments(response);
            return;
        }

        Long id;
        try {
            id = Long.parseLong(rawId);
            if (id <= 0) {
                sendErrorResponse(response, HttpServletResponse.SC_BAD_REQUEST,
                        "Invalid appointment ID. ID must be a positive integer.");
                return;
            }
        } catch (NumberFormatException e) {
            sendErrorResponse(response, HttpServletResponse.SC_BAD_REQUEST,
                    "Invalid appointment ID format: '" + rawId + "'.");
            return;
        }

        Appointment appointment = appointmentService.getAppointmentById(id);
        if (appointment == null) {
            sendErrorResponse(response, HttpServletResponse.SC_NOT_FOUND,
                    "Appointment not found with ID: " + id);
            return;
        }

        sendJsonResponse(response, HttpServletResponse.SC_OK, appointment);
    }

    private void sendJsonResponse(HttpServletResponse response, int statusCode, Object data) throws IOException {
        response.setStatus(statusCode);
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        response.getWriter().write(gson.toJson(data));
        response.getWriter().flush();
    }

    private void sendErrorResponse(HttpServletResponse response, int statusCode, String message) throws IOException {
        Map<String, Object> errorDetails = new HashMap<>();
        errorDetails.put("status", statusCode);
        errorDetails.put("error", message);
        sendJsonResponse(response, statusCode, errorDetails);
    }
}
