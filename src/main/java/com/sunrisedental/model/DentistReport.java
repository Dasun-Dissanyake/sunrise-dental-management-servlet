package com.sunrisedental.model;

public class DentistReport {

    private String dentistName;
    private int totalAppointments;
    private int completedAppointments;
    private int cancelledAppointments;
    private int noShowAppointments;

    public DentistReport() {
    }

    public String getDentistName() {
        return dentistName;
    }

    public void setDentistName(String dentistName) {
        this.dentistName = dentistName;
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

    public int getCancelledAppointments() {
        return cancelledAppointments;
    }

    public void setCancelledAppointments(int cancelledAppointments) {
        this.cancelledAppointments = cancelledAppointments;
    }

    public int getNoShowAppointments() {
        return noShowAppointments;
    }

    public void setNoShowAppointments(int noShowAppointments) {
        this.noShowAppointments = noShowAppointments;
    }
}