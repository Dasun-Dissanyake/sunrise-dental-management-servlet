package com.sunrisedental.service;

import com.sunrisedental.model.Dentist;
import org.junit.jupiter.api.Test;

import static org.junit.jupiter.api.Assertions.*;

class DentistServiceTest {

    @Test
    void shouldValidateValidDentist() {
        Dentist dentist = new Dentist();

        dentist.setDentistNumber("D001");
        dentist.setFullName("Dr. John Silva");
        dentist.setSpecialization("General Dentistry");
        dentist.setContactNumber("0771234567");

        DentistService service = new DentistService();

        assertTrue(service.isValidDentist(dentist));
    }

    @Test
    void shouldRejectDentistWithoutDentistNumber() {
        Dentist dentist = new Dentist();

        dentist.setFullName("Dr. John Silva");
        dentist.setSpecialization("General Dentistry");
        dentist.setContactNumber("0771234567");

        DentistService service = new DentistService();

        assertFalse(service.isValidDentist(dentist));
    }

    @Test
    void shouldRejectDentistWithoutFullName() {
        Dentist dentist = new Dentist();

        dentist.setDentistNumber("D001");
        dentist.setSpecialization("General Dentistry");
        dentist.setContactNumber("0771234567");

        DentistService service = new DentistService();

        assertFalse(service.isValidDentist(dentist));
    }

    @Test
    void shouldRejectDentistWithoutSpecialization() {
        Dentist dentist = new Dentist();

        dentist.setDentistNumber("D001");
        dentist.setFullName("Dr. John Silva");
        dentist.setContactNumber("0771234567");

        DentistService service = new DentistService();

        assertFalse(service.isValidDentist(dentist));
    }

    @Test
    void shouldRejectDentistWithoutContactNumber() {
        Dentist dentist = new Dentist();

        dentist.setDentistNumber("D001");
        dentist.setFullName("Dr. John Silva");
        dentist.setSpecialization("General Dentistry");

        DentistService service = new DentistService();

        assertFalse(service.isValidDentist(dentist));
    }
}