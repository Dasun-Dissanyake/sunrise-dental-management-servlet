package com.sunrisedental.model;

import java.time.LocalDateTime;

public class Bill {

    private Long id;
    private LocalDateTime billDate;
    private String billNumber;
    private Double consultationFee;
    private Double totalAmount;
    private Double treatmentCost;
    private Long appointmentId;

    public Bill() {
    }

    public Bill(
            Long id,
            LocalDateTime billDate,
            String billNumber,
            Double consultationFee,
            Double totalAmount,
            Double treatmentCost,
            Long appointmentId) {

        this.id = id;
        this.billDate = billDate;
        this.billNumber = billNumber;
        this.consultationFee = consultationFee;
        this.totalAmount = totalAmount;
        this.treatmentCost = treatmentCost;
        this.appointmentId = appointmentId;
    }

    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }

    public LocalDateTime getBillDate() {
        return billDate;
    }

    public void setBillDate(LocalDateTime billDate) {
        this.billDate = billDate;
    }

    public String getBillNumber() {
        return billNumber;
    }

    public void setBillNumber(String billNumber) {
        this.billNumber = billNumber;
    }

    public Double getConsultationFee() {
        return consultationFee;
    }

    public void setConsultationFee(Double consultationFee) {
        this.consultationFee = consultationFee;
    }

    public Double getTotalAmount() {
        return totalAmount;
    }

    public void setTotalAmount(Double totalAmount) {
        this.totalAmount = totalAmount;
    }

    public Double getTreatmentCost() {
        return treatmentCost;
    }

    public void setTreatmentCost(Double treatmentCost) {
        this.treatmentCost = treatmentCost;
    }

    public Long getAppointmentId() {
        return appointmentId;
    }

    public void setAppointmentId(Long appointmentId) {
        this.appointmentId = appointmentId;
    }
}