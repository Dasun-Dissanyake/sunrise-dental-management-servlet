package com.sunrisedental.service;

import com.sunrisedental.dao.BillDAO;
import com.sunrisedental.model.Bill;

import java.sql.SQLException;
import java.time.LocalDateTime;

public class BillService {

    private final BillDAO billDAO;

    public BillService() {
        this.billDAO = new BillDAO();
    }

    public BillService(BillDAO billDAO) {
        this.billDAO = billDAO;
    }

    public boolean generateBill(Bill bill)
            throws SQLException {

        validateBill(bill);

        // Prevent more than one bill for the same appointment
        Bill existingBill =
                billDAO.findByAppointmentId(
                        bill.getAppointmentId()
                );

        if (existingBill != null) {
            throw new IllegalArgumentException(
                    "A bill already exists for this appointment."
            );
        }

        // Calculate total from the two components
        double consultationFee =
                bill.getConsultationFee();

        double treatmentCost =
                bill.getTreatmentCost();

        bill.setTotalAmount(
                consultationFee + treatmentCost
        );

        if (bill.getBillDate() == null) {
            bill.setBillDate(
                    LocalDateTime.now()
            );
        }

        return billDAO.save(bill);
    }

    public Bill getBillById(Long id)
            throws SQLException {

        if (id == null || id <= 0) {
            return null;
        }

        return billDAO.findById(id);
    }

    public Bill getBillByNumber(String billNumber)
            throws SQLException {

        if (billNumber == null ||
                billNumber.isBlank()) {

            return null;
        }

        return billDAO.findByBillNumber(
                billNumber.trim()
        );
    }

    public Bill getBillByAppointmentId(
            Long appointmentId)
            throws SQLException {

        if (appointmentId == null ||
                appointmentId <= 0) {

            return null;
        }

        return billDAO.findByAppointmentId(
                appointmentId
        );
    }

    private void validateBill(Bill bill) {

        if (bill == null) {
            throw new IllegalArgumentException(
                    "Bill information is required."
            );
        }

        if (bill.getBillNumber() == null ||
                bill.getBillNumber().isBlank()) {

            throw new IllegalArgumentException(
                    "Bill number is required."
            );
        }

        if (bill.getAppointmentId() == null ||
                bill.getAppointmentId() <= 0) {

            throw new IllegalArgumentException(
                    "Valid appointment is required."
            );
        }

        if (bill.getConsultationFee() == null ||
                bill.getConsultationFee() < 0) {

            throw new IllegalArgumentException(
                    "Valid consultation fee is required."
            );
        }

        if (bill.getTreatmentCost() == null ||
                bill.getTreatmentCost() < 0) {

            throw new IllegalArgumentException(
                    "Valid treatment cost is required."
            );
        }
    }
}