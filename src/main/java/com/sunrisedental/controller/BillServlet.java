package com.sunrisedental.controller;

import com.sunrisedental.model.Appointment;
import com.sunrisedental.model.Bill;
import com.sunrisedental.model.Treatment;
import com.sunrisedental.service.AppointmentService;
import com.sunrisedental.service.BillService;
import com.sunrisedental.service.TreatmentService;
import com.sunrisedental.model.Patient;
import com.sunrisedental.service.PatientService;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.sql.SQLException;

@WebServlet("/bills")
public class BillServlet extends HttpServlet {

    private BillService billService;
    private AppointmentService appointmentService;
    private TreatmentService treatmentService;
    private PatientService patientService;

    @Override
    public void init() {
        billService = new BillService();
        appointmentService = new AppointmentService();
        treatmentService = new TreatmentService();
        patientService = new PatientService();
    }

    @Override
    protected void doGet(
            HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {

        try {
            String billNumber = request.getParameter("billNumber");
            String appointmentIdParameter = request.getParameter("appointmentId");

if (billNumber != null && !billNumber.isBlank()) {

    Bill bill = billService.getBillByNumber(
            billNumber.trim()
    );

    request.setAttribute(
            "searchedBill",
            bill
    );

    /*
     * Load appointment and patient information
     * for the searched bill.
     */
    if (bill != null
            && bill.getAppointmentId() != null) {

        Appointment appointment =
                appointmentService.getAppointmentById(
                        bill.getAppointmentId()
                );

        request.setAttribute(
                "appointment",
                appointment
        );

        if (appointment != null
                && appointment.getPatientId() != null) {

            Patient patient =
                    patientService.getPatientById(
                            appointment.getPatientId()
                    );

            request.setAttribute(
                    "patient",
                    patient
            );
        }

        /*
         * Load treatment information.
         */
        if (appointment != null
                && appointment.getTreatmentId() != null) {

            Treatment treatment =
                    treatmentService.getTreatmentById(
                            appointment.getTreatmentId()
                    );

            request.setAttribute(
                    "treatment",
                    treatment
            );
        }
    }

            } else if (appointmentIdParameter != null
                    && !appointmentIdParameter.isBlank()) {

                Long appointmentId;

                try {
                    appointmentId = Long.parseLong(
                            appointmentIdParameter
                    );

                } catch (NumberFormatException e) {

                    request.setAttribute(
                            "error",
                            "Invalid appointment ID."
                    );

                    forwardToBillsPage(request, response);
                    return;
                }

                Bill bill = billService.getBillByAppointmentId(
                        appointmentId
                );

                request.setAttribute(
                        "searchedBill",
                        bill
                );

Appointment appointment =
        appointmentService.getAppointmentById(
                appointmentId
        );

request.setAttribute(
        "appointment",
        appointment
);

/*
 * Retrieve the patient connected to this appointment.
 */
if (appointment != null
        && appointment.getPatientId() != null) {

    Patient patient =
            patientService.getPatientById(
                    appointment.getPatientId()
            );

    request.setAttribute(
            "patient",
            patient
);
}

                /*
                 * Appointment stores only treatmentId.
                 * Retrieve the complete Treatment object separately.
                 */
                if (appointment != null
                        && appointment.getTreatmentId() != null) {

                    Treatment treatment =
                            treatmentService.getTreatmentById(
                                    appointment.getTreatmentId()
                            );

                    request.setAttribute(
                            "treatment",
                            treatment
                    );
                }
            }

            forwardToBillsPage(
                    request,
                    response
            );

        } catch (SQLException e) {

            throw new ServletException(
                    "Unable to load billing information.",
                    e
            );
        }
    }

    @Override
    protected void doPost(
            HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {

        String action = request.getParameter("action");

        try {

            if ("generate".equals(action)) {

                generateBill(
                        request,
                        response
                );

            } else {

                response.sendRedirect(
                        request.getContextPath()
                                + "/bills?error=invalid"
                );
            }

        } catch (IllegalArgumentException e) {

            request.setAttribute(
                    "error",
                    e.getMessage()
            );

            forwardToBillsPage(
                    request,
                    response
            );

        } catch (SQLException e) {

            request.setAttribute(
                    "error",
                    "Unable to generate bill. "
                            + "Please check the appointment and "
                            + "bill information."
            );

            forwardToBillsPage(
                    request,
                    response
            );
        }
    }

    private void generateBill(
            HttpServletRequest request,
            HttpServletResponse response)
            throws SQLException, IOException {

        String billNumber =
                request.getParameter("billNumber");

        String appointmentIdParameter =
                request.getParameter("appointmentId");

        /*
         * Validate bill number.
         */
        if (billNumber == null || billNumber.isBlank()) {

            throw new IllegalArgumentException(
                    "Bill number is required."
            );
        }

        /*
         * Validate appointment ID.
         */
        if (appointmentIdParameter == null
                || appointmentIdParameter.isBlank()) {

            throw new IllegalArgumentException(
                    "Appointment is required."
            );
        }

        Long appointmentId;

        try {

            appointmentId =
                    Long.parseLong(
                            appointmentIdParameter
                    );

        } catch (NumberFormatException e) {

            throw new IllegalArgumentException(
                    "Invalid appointment ID."
            );
        }

        /*
         * Find appointment.
         */
        Appointment appointment =
                appointmentService.getAppointmentById(
                        appointmentId
                );

        if (appointment == null) {

            throw new IllegalArgumentException(
                    "Appointment not found."
            );
        }

        /*
         * Make sure the appointment has a treatment.
         */
        if (appointment.getTreatmentId() == null
                || appointment.getTreatmentId() <= 0) {

            throw new IllegalArgumentException(
                    "Treatment information is missing "
                            + "from this appointment."
            );
        }

        /*
         * Retrieve the treatment using treatmentId.
         *
         * Appointment does NOT contain getTreatment().
         * It only contains getTreatmentId().
         */
        Treatment treatment =
                treatmentService.getTreatmentById(
                        appointment.getTreatmentId()
                );

        if (treatment == null) {

            throw new IllegalArgumentException(
                    "Treatment not found."
            );
        }

        /*
         * Make sure pricing information exists.
         */
        if (treatment.getConsultationFee() == null
                || treatment.getTreatmentCost() == null) {

            throw new IllegalArgumentException(
                    "Treatment pricing information is incomplete."
            );
        }

        /*
         * Check whether this appointment already has a bill.
         */
        Bill existingBill =
                billService.getBillByAppointmentId(
                        appointmentId
                );

        if (existingBill != null) {

            response.sendRedirect(
                    request.getContextPath()
                            + "/bills?appointmentId="
                            + appointmentId
                            + "&error=exists"
            );

            return;
        }

        /*
         * Create the Bill.
         */
        Bill bill = new Bill();

        bill.setBillNumber(
                billNumber.trim()
        );

        bill.setAppointmentId(
                appointmentId
        );

        bill.setConsultationFee(
                treatment.getConsultationFee()
        );

        bill.setTreatmentCost(
                treatment.getTreatmentCost()
        );

        /*
         * BillService calculates total amount
         * and saves the bill.
         */
        boolean success =
                billService.generateBill(
                        bill
                );

        if (success) {

            response.sendRedirect(
                    request.getContextPath()
                            + "/bills?billNumber="
                            + bill.getBillNumber()
                            + "&success=generated"
            );

        } else {

            response.sendRedirect(
                    request.getContextPath()
                            + "/bills?error=failed"
            );
        }
    }

    private void forwardToBillsPage(
            HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {

        request.getRequestDispatcher(
                "/pages/bills.jsp"
        ).forward(
                request,
                response
        );
    }
}
