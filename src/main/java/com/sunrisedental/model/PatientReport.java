package com.sunrisedental.model;

import java.time.LocalDate;

public class PatientReport {

    private String patientName;
    private int totalAppointments;
    private int completedAppointments;
    private LocalDate lastAppointment;

    public PatientReport() {
    }

    public String getPatientName() {
        return patientName;
    }

    public void setPatientName(String patientName) {
        this.patientName = patientName;
    }

    public int getTotalAppointments() {
        return totalAppointments;
    }

    public void setTotalAppointments(int totalAppointments) {
        this.totalAppointments = totalAppointments;
    }

    public int getCompletedAppointments() {
        return completedAppointments;
    }

    public void setCompletedAppointments(int completedAppointments) {
        this.completedAppointments = completedAppointments;
    }

    public LocalDate getLastAppointment() {
        return lastAppointment;
    }

    public void setLastAppointment(LocalDate lastAppointment) {
        this.lastAppointment = lastAppointment;
    }
}