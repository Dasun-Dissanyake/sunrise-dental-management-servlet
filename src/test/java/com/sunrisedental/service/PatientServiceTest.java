package com.sunrisedental.service;

import com.sunrisedental.model.Patient;
import org.junit.jupiter.api.Test;

import java.time.LocalDate;

import static org.junit.jupiter.api.Assertions.*;

class PatientServiceTest {

    private final PatientService patientService =
            new PatientService();

    @Test
    void shouldRejectPatientWithoutPatientNumber() {

        Patient patient = createValidPatient();

        patient.setPatientNumber("");

        assertThrows(
                IllegalArgumentException.class,
                () -> patientService.registerPatient(patient)
        );
    }

    @Test
    void shouldRejectPatientWithoutName() {

        Patient patient = createValidPatient();

        patient.setFullName("");

        assertThrows(
                IllegalArgumentException.class,
                () -> patientService.registerPatient(patient)
        );
    }

    @Test
    void shouldRejectPatientWithoutAddress() {

        Patient patient = createValidPatient();

        patient.setAddress("");

        assertThrows(
                IllegalArgumentException.class,
                () -> patientService.registerPatient(patient)
        );
    }

    @Test
    void shouldRejectPatientWithoutContactNumber() {

        Patient patient = createValidPatient();

        patient.setContactNumber("");

        assertThrows(
                IllegalArgumentException.class,
                () -> patientService.registerPatient(patient)
        );
    }

    private Patient createValidPatient() {

        Patient patient = new Patient();

        patient.setPatientNumber(
                "TEST-" + System.currentTimeMillis()
        );

        patient.setFullName("Test Patient");
        patient.setAddress("Colombo");
        patient.setContactNumber("0771234567");
        patient.setDateOfBirth(
                LocalDate.of(2000, 1, 1)
        );
        patient.setEmail("test@example.com");
        patient.setGender("Male");

        return patient;
    }
}