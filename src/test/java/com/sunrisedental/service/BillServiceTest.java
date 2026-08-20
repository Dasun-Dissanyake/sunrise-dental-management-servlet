package com.sunrisedental.service;

import com.sunrisedental.dao.BillDAO;
import com.sunrisedental.model.Bill;
import org.junit.jupiter.api.Test;

import java.sql.SQLException;

import static org.junit.jupiter.api.Assertions.*;

class BillServiceTest {

    @Test
    void shouldCalculateTotalAmount() throws SQLException {

        BillDAO dao = new BillDAO() {
            @Override
            public Bill findByAppointmentId(Long appointmentId) {
                return null;
            }

            @Override
            public boolean save(Bill bill) {
                return true;
            }
        };

        BillService service = new BillService(dao);

        Bill bill = new Bill();

        bill.setBillNumber("BILL-001");
        bill.setAppointmentId(1L);
        bill.setConsultationFee(500.00);
        bill.setTreatmentCost(2500.00);

        boolean result =
                service.generateBill(bill);

        assertTrue(result);
        assertEquals(
                3000.00,
                bill.getTotalAmount()
        );
    }

    @Test
    void shouldRejectNullBill() {

        BillService service =
                new BillService(
                        new BillDAO()
                );

        assertThrows(
                IllegalArgumentException.class,
                () -> service.generateBill(null)
        );
    }

    @Test
    void shouldRejectMissingBillNumber() {

        BillService service =
                new BillService(
                        new BillDAO()
                );

        Bill bill = new Bill();

        bill.setAppointmentId(1L);
        bill.setConsultationFee(500.00);
        bill.setTreatmentCost(1000.00);

        assertThrows(
                IllegalArgumentException.class,
                () -> service.generateBill(bill)
        );
    }

    @Test
    void shouldRejectInvalidAppointment() {

        BillService service =
                new BillService(
                        new BillDAO()
                );

        Bill bill = new Bill();

        bill.setBillNumber("BILL-001");
        bill.setAppointmentId(0L);
        bill.setConsultationFee(500.00);
        bill.setTreatmentCost(1000.00);

        assertThrows(
                IllegalArgumentException.class,
                () -> service.generateBill(bill)
        );
    }

    @Test
    void shouldRejectNegativeConsultationFee() {

        BillService service =
                new BillService(
                        new BillDAO()
                );

        Bill bill = new Bill();

        bill.setBillNumber("BILL-001");
        bill.setAppointmentId(1L);
        bill.setConsultationFee(-500.00);
        bill.setTreatmentCost(1000.00);

        assertThrows(
                IllegalArgumentException.class,
                () -> service.generateBill(bill)
        );
    }

    @Test
    void shouldRejectNegativeTreatmentCost() {

        BillService service =
                new BillService(
                        new BillDAO()
                );

        Bill bill = new Bill();

        bill.setBillNumber("BILL-001");
        bill.setAppointmentId(1L);
        bill.setConsultationFee(500.00);
        bill.setTreatmentCost(-1000.00);

        assertThrows(
                IllegalArgumentException.class,
                () -> service.generateBill(bill)
        );
    }

    @Test
    void shouldPreventDuplicateAppointmentBill()
            throws SQLException {

        Bill existingBill = new Bill();

        existingBill.setId(1L);
        existingBill.setBillNumber("BILL-001");
        existingBill.setAppointmentId(1L);

        BillDAO dao = new BillDAO() {
            @Override
            public Bill findByAppointmentId(Long appointmentId) {
                return existingBill;
            }
        };

        BillService service =
                new BillService(dao);

        Bill newBill = new Bill();

        newBill.setBillNumber("BILL-002");
        newBill.setAppointmentId(1L);
        newBill.setConsultationFee(500.00);
        newBill.setTreatmentCost(1000.00);

        assertThrows(
                IllegalArgumentException.class,
                () -> service.generateBill(newBill)
        );
    }
}