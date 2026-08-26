
package com.sunrisedental.service;

import com.sunrisedental.dao.PatientDAO;
import com.sunrisedental.model.Patient;

import java.sql.SQLException;
import java.time.LocalDateTime;
import java.util.List;

public class PatientService {

    private final PatientDAO patientDAO;

    public PatientService() {
        this.patientDAO = new PatientDAO();
    }

    public PatientService(PatientDAO patientDAO) {
        this.patientDAO = patientDAO;
    }

    public boolean registerPatient(Patient patient)
            throws SQLException {

        validatePatient(patient);

        Patient existing =
                patientDAO.findByPatientNumber(
                        patient.getPatientNumber().trim()
                );

        if (existing != null) {
            throw new IllegalArgumentException(
                    "A patient with this patient number already exists."
            );
        }

        patient.setRegistrationDate(
                LocalDateTime.now()
        );

        patient.setActive(true);

        return patientDAO.save(patient);
    }

    public List<Patient> getAllPatients()
            throws SQLException {

        return patientDAO.findAll();
    }

    public Patient getPatientById(Long id)
            throws SQLException {

        if (id == null || id <= 0) {
            return null;
        }

        return patientDAO.findById(id);
    }

    public Patient findPatient(String patientNumber)
            throws SQLException {

        if (patientNumber == null ||
                patientNumber.trim().isEmpty()) {

            throw new IllegalArgumentException(
                    "Patient number is required."
            );
        }

        return patientDAO.findByPatientNumber(
                patientNumber.trim()
        );
    }

    private void validatePatient(Patient patient) {

        if (patient == null) {
            throw new IllegalArgumentException(
                    "Patient information is required."
            );
        }

        if (patient.getPatientNumber() == null ||
                patient.getPatientNumber().isBlank()) {

            throw new IllegalArgumentException(
                    "Patient number is required."
            );
        }

        if (patient.getFullName() == null ||
                patient.getFullName().isBlank()) {

            throw new IllegalArgumentException(
                    "Patient name is required."
            );
        }

        if (patient.getAddress() == null ||
                patient.getAddress().isBlank()) {

            throw new IllegalArgumentException(
                    "Address is required."
            );
        }

        if (patient.getContactNumber() == null ||
                patient.getContactNumber().isBlank()) {

            throw new IllegalArgumentException(
                    "Contact number is required."
            );
        }
    }
}
