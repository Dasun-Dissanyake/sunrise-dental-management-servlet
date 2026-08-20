package com.sunrisedental.model;

import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.LocalTime;

public class Appointment {

    private Long id;
    private LocalDate appointmentDate;
    private String appointmentNumber;
    private LocalTime appointmentTime;
    private LocalDateTime createdAt;
    private String notes;
    private String status; // 'SCHEDULED', 'COMPLETED', 'CANCELLED', 'NO_SHOW'
    private LocalDateTime updatedAt;
    private Long dentistId;
    private Long patientId;
    private Long treatmentId;
    private Treatment treatment;

    public Appointment() {
    }

    public Appointment(Long id, LocalDate appointmentDate, String appointmentNumber,
                       LocalTime appointmentTime, LocalDateTime createdAt, String notes,
                       String status, LocalDateTime updatedAt, Long dentistId,
                       Long patientId, Long treatmentId) {
        this.id = id;
        this.appointmentDate = appointmentDate;
        this.appointmentNumber = appointmentNumber;
        this.appointmentTime = appointmentTime;
        this.createdAt = createdAt;
        this.notes = notes;
        this.status = status;
        this.updatedAt = updatedAt;
        this.dentistId = dentistId;
        this.patientId = patientId;
        this.treatmentId = treatmentId;
    }

    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }

    public LocalDate getAppointmentDate() {
        return appointmentDate;
    }

    public void setAppointmentDate(LocalDate appointmentDate) {
        this.appointmentDate = appointmentDate;
    }

    public String getAppointmentNumber() {
        return appointmentNumber;
    }

    public void setAppointmentNumber(String appointmentNumber) {
        this.appointmentNumber = appointmentNumber;
    }

    public LocalTime getAppointmentTime() {
        return appointmentTime;
    }

    public void setAppointmentTime(LocalTime appointmentTime) {
        this.appointmentTime = appointmentTime;
    }

    public LocalDateTime getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(LocalDateTime createdAt) {
        this.createdAt = createdAt;
    }

    public String getNotes() {
        return notes;
    }

    public void setNotes(String notes) {
        this.notes = notes;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public LocalDateTime getUpdatedAt() {
        return updatedAt;
    }

    public void setUpdatedAt(LocalDateTime updatedAt) {
        this.updatedAt = updatedAt;
    }

    public Long getDentistId() {
        return dentistId;
    }

    public void setDentistId(Long dentistId) {
        this.dentistId = dentistId;
    }

    public Long getPatientId() {
        return patientId;
    }

    public void setPatientId(Long patientId) {
        this.patientId = patientId;
    }

    public Long getTreatmentId() {
        return treatmentId;
    }

    public void setTreatmentId(Long treatmentId) {
        this.treatmentId = treatmentId;
    }
    public Treatment getTreatment() {
    return treatment;
}

public void setTreatment(Treatment treatment) {
    this.treatment = treatment;
}

}