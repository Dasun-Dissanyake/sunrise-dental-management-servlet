package com.sunrisedental.service;

import com.sunrisedental.model.Dentist;
import org.junit.jupiter.api.Test;

import static org.junit.jupiter.api.Assertions.*;

class DentistServiceTest {

    private final DentistService service = new DentistService();

    @Test
    void shouldValidateValidDentist() {
        Dentist dentist = createValidDentist();
        assertTrue(service.isValidDentist(dentist));
    }

    @Test
    void shouldRejectDentistWithoutDentistNumber() {
        Dentist dentist = createValidDentist();
        dentist.setDentistNumber("");

        assertFalse(service.isValidDentist(dentist));
        assertThrows(
                IllegalArgumentException.class,
                () -> service.addDentist(dentist)
        );
    }

    @Test
    void shouldRejectDentistWithoutFullName() {
        Dentist dentist = createValidDentist();
        dentist.setFullName("");

        assertFalse(service.isValidDentist(dentist));
        assertThrows(
                IllegalArgumentException.class,
                () -> service.addDentist(dentist)
        );
    }

    @Test
    void shouldRejectDentistWithoutSpecialization() {
        Dentist dentist = createValidDentist();
        dentist.setSpecialization("");

        assertFalse(service.isValidDentist(dentist));
        assertThrows(
                IllegalArgumentException.class,
                () -> service.addDentist(dentist)
        );
    }

    @Test
    void shouldRejectDentistWithoutContactNumber() {
        Dentist dentist = createValidDentist();
        dentist.setContactNumber("");

        assertFalse(service.isValidDentist(dentist));
        assertThrows(
                IllegalArgumentException.class,
                () -> service.addDentist(dentist)
        );
    }

    @Test
    void shouldRejectNullDentist() {
        assertFalse(service.isValidDentist(null));
        assertThrows(
                IllegalArgumentException.class,
                () -> service.addDentist(null)
        );
    }

    private Dentist createValidDentist() {
        Dentist dentist = new Dentist();
        dentist.setDentistNumber("D001");
        dentist.setFullName("Dr. John Silva");
        dentist.setSpecialization("General Dentistry");
        dentist.setContactNumber("0771234567");
        dentist.setActive(true);
        return dentist;
    }
}