package com.sunrisedental.dao;

import com.sunrisedental.model.Patient;
import org.junit.jupiter.api.Test;

import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.List;

import static org.junit.jupiter.api.Assertions.*;

class PatientDAOTest {

    private final PatientDAO patientDAO = new PatientDAO();

    @Test
    void shouldSaveAndFindPatient() throws Exception {

        String patientNumber =
                "TEST-" + System.currentTimeMillis();

        Patient patient = new Patient();

        patient.setPatientNumber(patientNumber);
        patient.setFullName("Test Patient");
        patient.setAddress("Colombo");
        patient.setContactNumber("0771234567");
        patient.setDateOfBirth(
                LocalDate.of(2000, 1, 1)
        );
        patient.setEmail("test@example.com");
        patient.setGender("Male");
        patient.setRegistrationDate(
                LocalDateTime.now()
        );
        patient.setActive(true);

        boolean saved = patientDAO.save(patient);

        assertTrue(saved);

        Patient found =
                patientDAO.findByPatientNumber(
                        patientNumber
                );

        assertNotNull(found);
        assertEquals(
                patientNumber,
                found.getPatientNumber()
        );
        assertEquals(
                "Test Patient",
                found.getFullName()
        );
    }

    @Test
    void shouldReturnPatientsList() throws Exception {

        List<Patient> patients =
                patientDAO.findAll();

        assertNotNull(patients);
    }

    @Test
    void shouldReturnNullForUnknownPatient()
            throws Exception {

        Patient patient =
                patientDAO.findByPatientNumber(
                        "PATIENT-DOES-NOT-EXIST"
                );

        assertNull(patient);
    }
}