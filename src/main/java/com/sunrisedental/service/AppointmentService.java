package com.sunrisedental.service;

import com.sunrisedental.dao.AppointmentDAO;
import com.sunrisedental.model.Appointment;

import java.sql.SQLException;
import java.time.LocalDateTime;
import java.util.List;
import java.util.Set;

public class AppointmentService {

    private static final Set<String> VALID_STATUSES = Set.of(
            "SCHEDULED", "COMPLETED", "CANCELLED", "NO_SHOW"
    );

    private final AppointmentDAO appointmentDAO;

    public AppointmentService() {
        this.appointmentDAO = new AppointmentDAO();
    }

    public AppointmentService(AppointmentDAO appointmentDAO) {
        this.appointmentDAO = appointmentDAO;
    }

    /**
     * Validates required appointment fields and throws IllegalArgumentException if invalid.
     *
     * @param appointment appointment object to validate
     */
    public void validateAppointment(Appointment appointment) {
        if (appointment == null) {
            throw new IllegalArgumentException("Appointment information is required.");
        }

        if (appointment.getAppointmentNumber() == null || appointment.getAppointmentNumber().isBlank()) {
            throw new IllegalArgumentException("Appointment number is required.");
        }

        if (appointment.getAppointmentDate() == null) {
            throw new IllegalArgumentException("Appointment date is required.");
        }

        if (appointment.getAppointmentTime() == null) {
            throw new IllegalArgumentException("Appointment time is required.");
        }

        if (appointment.getPatientId() == null || appointment.getPatientId() <= 0) {
            throw new IllegalArgumentException("Valid patient is required.");
        }

        if (appointment.getDentistId() == null || appointment.getDentistId() <= 0) {
            throw new IllegalArgumentException("Valid dentist is required.");
        }

        if (appointment.getTreatmentId() == null || appointment.getTreatmentId() <= 0) {
            throw new IllegalArgumentException("Valid treatment is required.");
        }
    }

    /**
     * Registers a new appointment with default status SCHEDULED.
     *
     * @param appointment appointment to register
     * @return true if appointment was successfully saved
     */
    public boolean registerAppointment(Appointment appointment) throws SQLException {
        validateAppointment(appointment);

        if (appointment.getCreatedAt() == null) {
            appointment.setCreatedAt(LocalDateTime.now());
        }

        if (appointment.getStatus() == null || appointment.getStatus().isBlank()) {
            appointment.setStatus("SCHEDULED");
        }

        return appointmentDAO.save(appointment);
    }

    /**
     * Retrieves all appointments.
     *
     * @return list of appointments
     */
    public List<Appointment> getAllAppointments() throws SQLException {
        return appointmentDAO.findAll();
    }

    /**
     * Retrieves an appointment by database ID.
     *
     * @param id appointment ID
     * @return appointment if found, otherwise null
     */
    public Appointment getAppointmentById(Long id) throws SQLException {
        if (id == null || id <= 0) {
            return null;
        }

        return appointmentDAO.findById(id);
    }

    /**
     * Retrieves an appointment by appointment number.
     *
     * @param appointmentNumber appointment number
     * @return appointment if found, otherwise null
     */
    public Appointment getAppointmentByNumber(String appointmentNumber) throws SQLException {
        if (appointmentNumber == null || appointmentNumber.trim().isEmpty()) {
            throw new IllegalArgumentException("Appointment number is required.");
        }

        return appointmentDAO.findByAppointmentNumber(appointmentNumber.trim());
    }

    /**
     * Updates appointment details.
     *
     * @param appointment appointment information to update
     * @return true if update succeeded
     */
    public boolean updateAppointment(Appointment appointment) throws SQLException {
        if (appointment == null || appointment.getId() == null || appointment.getId() <= 0) {
            throw new IllegalArgumentException("Valid appointment ID is required.");
        }

        validateAppointment(appointment);

        appointment.setUpdatedAt(LocalDateTime.now());

        return appointmentDAO.update(appointment);
    }

    /**
     * Updates the status of an appointment.
     *
     * @param id appointment ID
     * @param status new status ('SCHEDULED', 'COMPLETED', 'CANCELLED', 'NO_SHOW')
     * @return true if update succeeded
     */
    public boolean updateAppointmentStatus(Long id, String status) throws SQLException {
        if (id == null || id <= 0) {
            throw new IllegalArgumentException("Valid appointment ID is required.");
        }

        if (status == null || status.isBlank()) {
            throw new IllegalArgumentException("Status is required.");
        }

        String normalizedStatus = status.trim().toUpperCase();
        if (!VALID_STATUSES.contains(normalizedStatus)) {
            throw new IllegalArgumentException("Invalid appointment status: " + status);
        }

        return appointmentDAO.updateStatus(id, normalizedStatus);
    }
}