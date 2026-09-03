package com.sunrisedental.controller;

import com.sunrisedental.model.Appointment;
import com.sunrisedental.service.AppointmentService;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;

import java.io.PrintWriter;
import java.io.StringWriter;
import java.sql.SQLException;
import java.time.LocalDate;
import java.time.LocalTime;
import java.util.List;

import static org.junit.jupiter.api.Assertions.assertTrue;
import static org.mockito.Mockito.*;

class AppointmentApiServletTest {

    private AppointmentService mockAppointmentService;
    private AppointmentApiServlet servlet;
    private HttpServletRequest request;
    private HttpServletResponse response;
    private StringWriter responseWriter;

    @BeforeEach
    void setUp() throws Exception {
        mockAppointmentService = mock(AppointmentService.class);
        servlet = new AppointmentApiServlet(mockAppointmentService);

        request = mock(HttpServletRequest.class);
        response = mock(HttpServletResponse.class);

        responseWriter = new StringWriter();
        PrintWriter printWriter = new PrintWriter(responseWriter);
        when(response.getWriter()).thenReturn(printWriter);
    }

    private Appointment createSampleAppointment(Long id, String number) {
        Appointment appointment = new Appointment();
        appointment.setId(id);
        appointment.setAppointmentNumber(number);
        appointment.setPatientId(1L);
        appointment.setDentistId(2L);
        appointment.setTreatmentId(3L);
        appointment.setAppointmentDate(LocalDate.of(2026, 9, 3));
        appointment.setAppointmentTime(LocalTime.of(10, 0));
        appointment.setStatus("SCHEDULED");
        appointment.setNotes("Regular checkup");
        return appointment;
    }

    @Test
    void testGetAllAppointments_success() throws Exception {
        when(request.getPathInfo()).thenReturn(null);
        Appointment app1 = createSampleAppointment(1L, "APP-001");
        Appointment app2 = createSampleAppointment(2L, "APP-002");
        when(mockAppointmentService.getAllAppointments()).thenReturn(List.of(app1, app2));

        servlet.doGet(request, response);

        verify(response).setStatus(HttpServletResponse.SC_OK);
        verify(response).setContentType("application/json");
        String jsonOutput = responseWriter.toString();
        assertTrue(jsonOutput.contains("APP-001"));
        assertTrue(jsonOutput.contains("APP-002"));
        assertTrue(jsonOutput.contains("2026-09-03"));
    }

    @Test
    void testGetAllAppointments_withSlashPath_success() throws Exception {
        when(request.getPathInfo()).thenReturn("/");
        Appointment app1 = createSampleAppointment(1L, "APP-001");
        when(mockAppointmentService.getAllAppointments()).thenReturn(List.of(app1));

        servlet.doGet(request, response);

        verify(response).setStatus(HttpServletResponse.SC_OK);
        verify(response).setContentType("application/json");
        String jsonOutput = responseWriter.toString();
        assertTrue(jsonOutput.contains("APP-001"));
    }

    @Test
    void testGetAppointmentById_success() throws Exception {
        when(request.getPathInfo()).thenReturn("/1");
        Appointment app1 = createSampleAppointment(1L, "APP-001");
        when(mockAppointmentService.getAppointmentById(1L)).thenReturn(app1);

        servlet.doGet(request, response);

        verify(response).setStatus(HttpServletResponse.SC_OK);
        verify(response).setContentType("application/json");
        String jsonOutput = responseWriter.toString();
        assertTrue(jsonOutput.contains("APP-001"));
        assertTrue(jsonOutput.contains("SCHEDULED"));
        assertTrue(jsonOutput.contains("2026-09-03"));
    }

    @Test
    void testGetAppointmentById_notFound() throws Exception {
        when(request.getPathInfo()).thenReturn("/999");
        when(mockAppointmentService.getAppointmentById(999L)).thenReturn(null);

        servlet.doGet(request, response);

        verify(response).setStatus(HttpServletResponse.SC_NOT_FOUND);
        verify(response).setContentType("application/json");
        String jsonOutput = responseWriter.toString();
        assertTrue(jsonOutput.contains("404"));
        assertTrue(jsonOutput.contains("Appointment not found with ID: 999"));
    }

    @Test
    void testGetAppointmentById_invalidIdFormat() throws Exception {
        when(request.getPathInfo()).thenReturn("/invalid-id");

        servlet.doGet(request, response);

        verify(response).setStatus(HttpServletResponse.SC_BAD_REQUEST);
        verify(response).setContentType("application/json");
        String jsonOutput = responseWriter.toString();
        assertTrue(jsonOutput.contains("400"));
        assertTrue(jsonOutput.contains("Invalid appointment ID format"));
    }

    @Test
    void testGetAppointmentById_negativeId() throws Exception {
        when(request.getPathInfo()).thenReturn("/-5");

        servlet.doGet(request, response);

        verify(response).setStatus(HttpServletResponse.SC_BAD_REQUEST);
        verify(response).setContentType("application/json");
        String jsonOutput = responseWriter.toString();
        assertTrue(jsonOutput.contains("400"));
        assertTrue(jsonOutput.contains("ID must be a positive integer"));
    }

    @Test
    void testGetAllAppointments_sqlException() throws Exception {
        when(request.getPathInfo()).thenReturn(null);
        when(mockAppointmentService.getAllAppointments()).thenThrow(new SQLException("Database connection error"));

        servlet.doGet(request, response);

        verify(response).setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
        verify(response).setContentType("application/json");
        String jsonOutput = responseWriter.toString();
        assertTrue(jsonOutput.contains("500"));
        assertTrue(jsonOutput.contains("Database error occurred"));
    }

    @Test
    void testGetAppointmentById_sqlException() throws Exception {
        when(request.getPathInfo()).thenReturn("/1");
        when(mockAppointmentService.getAppointmentById(1L)).thenThrow(new SQLException("Query execution failed"));

        servlet.doGet(request, response);

        verify(response).setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
        verify(response).setContentType("application/json");
        String jsonOutput = responseWriter.toString();
        assertTrue(jsonOutput.contains("500"));
        assertTrue(jsonOutput.contains("Database error occurred"));
    }
}
