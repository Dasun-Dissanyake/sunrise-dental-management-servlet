package com.sunrisedental.service;

import com.sunrisedental.model.Appointment;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;

import java.time.LocalDate;
import java.time.LocalTime;

import static org.junit.jupiter.api.Assertions.*;

public class AppointmentServiceTest {

    private AppointmentService appointmentService;

    @BeforeEach
    public void setUp() {
        appointmentService = new AppointmentService();
    }

    @Test
    public void testValidateAppointment_nullThrowsException() {
        IllegalArgumentException ex = assertThrows(
                IllegalArgumentException.class,
                () -> appointmentService.validateAppointment(null)
        );
        assertEquals("Appointment information is required.", ex.getMessage());
    }

    @Test
    public void testValidateAppointment_blankNumberThrowsException() {
        Appointment appointment = new Appointment();
        appointment.setAppointmentNumber("");
        appointment.setAppointmentDate(LocalDate.now());
        appointment.setAppointmentTime(LocalTime.of(9, 0));
        appointment.setPatientId(1L);
        appointment.setDentistId(1L);
        appointment.setTreatmentId(1L);

        IllegalArgumentException ex = assertThrows(
                IllegalArgumentException.class,
                () -> appointmentService.validateAppointment(appointment)
        );
        assertEquals("Appointment number is required.", ex.getMessage());
    }

    @Test
    public void testValidateAppointment_missingDateThrowsException() {
        Appointment appointment = new Appointment();
        appointment.setAppointmentNumber("APP-001");
        appointment.setAppointmentTime(LocalTime.of(9, 0));
        appointment.setPatientId(1L);
        appointment.setDentistId(1L);
        appointment.setTreatmentId(1L);

        IllegalArgumentException ex = assertThrows(
                IllegalArgumentException.class,
                () -> appointmentService.validateAppointment(appointment)
        );
        assertEquals("Appointment date is required.", ex.getMessage());
    }

    @Test
    public void testValidateAppointment_missingTimeThrowsException() {
        Appointment appointment = new Appointment();
        appointment.setAppointmentNumber("APP-001");
        appointment.setAppointmentDate(LocalDate.now());
        appointment.setPatientId(1L);
        appointment.setDentistId(1L);
        appointment.setTreatmentId(1L);

        IllegalArgumentException ex = assertThrows(
                IllegalArgumentException.class,
                () -> appointmentService.validateAppointment(appointment)
        );
        assertEquals("Appointment time is required.", ex.getMessage());
    }

    @Test
    public void testValidateAppointment_invalidPatientIdThrowsException() {
        Appointment appointment = new Appointment();
        appointment.setAppointmentNumber("APP-001");
        appointment.setAppointmentDate(LocalDate.now());
        appointment.setAppointmentTime(LocalTime.of(9, 0));
        appointment.setPatientId(0L);
        appointment.setDentistId(1L);
        appointment.setTreatmentId(1L);

        IllegalArgumentException ex = assertThrows(
                IllegalArgumentException.class,
                () -> appointmentService.validateAppointment(appointment)
        );
        assertEquals("Valid patient is required.", ex.getMessage());
    }

    @Test
    public void testUpdateAppointmentStatus_invalidStatusThrowsException() {
        IllegalArgumentException ex = assertThrows(
                IllegalArgumentException.class,
                () -> appointmentService.updateAppointmentStatus(1L, "UNKNOWN_STATUS")
        );
        assertTrue(ex.getMessage().contains("Invalid appointment status"));
    }

    @Test
    public void testUpdateAppointmentStatus_nullIdThrowsException() {
        IllegalArgumentException ex = assertThrows(
                IllegalArgumentException.class,
                () -> appointmentService.updateAppointmentStatus(null, "COMPLETED")
        );
        assertEquals("Valid appointment ID is required.", ex.getMessage());
    }
}
