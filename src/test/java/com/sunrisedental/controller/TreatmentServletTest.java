package com.sunrisedental.controller;

import com.sunrisedental.model.Treatment;
import com.sunrisedental.service.TreatmentService;
import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;

import java.sql.SQLException;
import java.util.List;

import static org.mockito.ArgumentMatchers.any;
import static org.mockito.ArgumentMatchers.anyString;
import static org.mockito.ArgumentMatchers.eq;
import static org.mockito.Mockito.*;

class TreatmentServletTest {

    private TreatmentService mockTreatmentService;
    private TreatmentServlet servlet;
    private HttpServletRequest request;
    private HttpServletResponse response;
    private RequestDispatcher dispatcher;

    @BeforeEach
    void setUp() {
        mockTreatmentService = mock(TreatmentService.class);
        servlet = new TreatmentServlet(mockTreatmentService);

        request = mock(HttpServletRequest.class);
        response = mock(HttpServletResponse.class);
        dispatcher = mock(RequestDispatcher.class);

        when(request.getContextPath()).thenReturn("/sunrise-dental");
        when(request.getRequestDispatcher("/pages/treatments.jsp")).thenReturn(dispatcher);
    }

    @Test
    void shouldForwardWithTreatmentsOnGet() throws Exception {
        Treatment t = new Treatment();
        t.setId(1L);
        t.setTreatmentCode("TRT-001");
        when(mockTreatmentService.getAllTreatments()).thenReturn(List.of(t));

        servlet.doGet(request, response);

        verify(request).setAttribute("treatments", List.of(t));
        verify(dispatcher).forward(request, response);
    }

    @Test
    void shouldSearchTreatmentByCodeOnGet() throws Exception {
        Treatment t = new Treatment();
        t.setId(1L);
        t.setTreatmentCode("TRT-001");

        when(request.getParameter("treatmentCode")).thenReturn("TRT-001");
        when(mockTreatmentService.getTreatmentByCode("TRT-001")).thenReturn(t);
        when(mockTreatmentService.getAllTreatments()).thenReturn(List.of(t));

        servlet.doGet(request, response);

        verify(request).setAttribute("searchedTreatment", t);
        verify(request).setAttribute("treatments", List.of(t));
        verify(dispatcher).forward(request, response);
    }

    @Test
    void shouldHandleAddTreatmentOnPost() throws Exception {
        when(request.getParameter("action")).thenReturn("add");
        when(request.getParameter("treatmentCode")).thenReturn("TRT-100");
        when(request.getParameter("treatmentName")).thenReturn("Dental Cleaning");
        when(request.getParameter("description")).thenReturn("Standard scaling");
        when(request.getParameter("treatmentCost")).thenReturn("5000.00");
        when(request.getParameter("consultationFee")).thenReturn("1500.00");

        servlet.doPost(request, response);

        verify(mockTreatmentService).addTreatment(any(Treatment.class));
        verify(response).sendRedirect("/sunrise-dental/treatments?success=registered");
    }

    @Test
    void shouldHandleDeactivateTreatmentOnPost() throws Exception {
        when(request.getParameter("action")).thenReturn("deactivate");
        when(request.getParameter("id")).thenReturn("5");

        servlet.doPost(request, response);

        verify(mockTreatmentService).deactivateTreatment(5L);
        verify(response).sendRedirect("/sunrise-dental/treatments?success=deactivated");
    }

    @Test
    void shouldForwardWithErrorMessageOnValidationError() throws Exception {
        when(request.getParameter("action")).thenReturn("add");
        when(request.getParameter("treatmentCode")).thenReturn("TRT-100");
        when(request.getParameter("treatmentName")).thenReturn("Dental Cleaning");
        when(request.getParameter("treatmentCost")).thenReturn("invalid_cost");

        servlet.doPost(request, response);

        verify(request).setAttribute(eq("error"), anyString());
        verify(dispatcher).forward(request, response);
    }

    @Test
    void shouldForwardWithErrorMessageOnSQLException() throws Exception {
        when(request.getParameter("action")).thenReturn("add");
        when(request.getParameter("treatmentCode")).thenReturn("TRT-100");
        when(request.getParameter("treatmentName")).thenReturn("Dental Cleaning");
        when(request.getParameter("treatmentCost")).thenReturn("5000.00");
        when(request.getParameter("consultationFee")).thenReturn("1500.00");

        doThrow(new SQLException("Duplicate entry")).when(mockTreatmentService).addTreatment(any());

        servlet.doPost(request, response);

        verify(request).setAttribute("error", "Unable to process treatment. The treatment code may already exist.");
        verify(dispatcher).forward(request, response);
    }
}
