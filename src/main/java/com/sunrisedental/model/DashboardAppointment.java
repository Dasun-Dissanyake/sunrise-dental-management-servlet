package com.sunrisedental.model;

import java.time.LocalDate;
import java.time.LocalTime;

public class DashboardAppointment {


private String appointmentNumber;
private String patientName;
private String dentistName;
private String treatmentName;
private LocalDate appointmentDate;
private LocalTime appointmentTime;
private String status;

public DashboardAppointment() {
}

public String getAppointmentNumber() {
    return appointmentNumber;
}

public void setAppointmentNumber(String appointmentNumber) {
    this.appointmentNumber = appointmentNumber;
}

public String getPatientName() {
    return patientName;
}

public void setPatientName(String patientName) {
    this.patientName = patientName;
}

public String getDentistName() {
    return dentistName;
}

public void setDentistName(String dentistName) {
    this.dentistName = dentistName;
}

public String getTreatmentName() {
    return treatmentName;
}

public void setTreatmentName(String treatmentName) {
    this.treatmentName = treatmentName;
}

public LocalDate getAppointmentDate() {
    return appointmentDate;
}

public void setAppointmentDate(LocalDate appointmentDate) {
    this.appointmentDate = appointmentDate;
}

public LocalTime getAppointmentTime() {
    return appointmentTime;
}

public void setAppointmentTime(LocalTime appointmentTime) {
    this.appointmentTime = appointmentTime;
}

public String getStatus() {
    return status;
}

public void setStatus(String status) {
    this.status = status;
}


}
