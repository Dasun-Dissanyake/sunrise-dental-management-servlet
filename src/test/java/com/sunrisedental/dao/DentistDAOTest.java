package com.sunrisedental.dao;

import com.sunrisedental.model.Dentist;
import org.junit.jupiter.api.Test;

import java.time.LocalDateTime;
import java.util.List;

import static org.junit.jupiter.api.Assertions.*;

class DentistDAOTest {

    private final DentistDAO dentistDAO = new DentistDAO();

    @Test
    void shouldSaveAndFindDentist() throws Exception {
        String dentistNumber = "D" + (System.currentTimeMillis() % 100000000);

        Dentist dentist = new Dentist();
        dentist.setDentistNumber(dentistNumber);
        dentist.setFullName("Dr. Test Dentist");
        dentist.setSpecialization("Orthodontics");
        dentist.setContactNumber("0771234567");
        dentist.setCreatedAt(LocalDateTime.now());
        dentist.setActive(true);

        boolean saved = dentistDAO.save(dentist);
        assertTrue(saved);

        Dentist found = dentistDAO.findByDentistNumber(dentistNumber);
        assertNotNull(found);
        assertEquals(dentistNumber, found.getDentistNumber());
        assertEquals("Dr. Test Dentist", found.getFullName());
        assertEquals("Orthodontics", found.getSpecialization());
        assertEquals("0771234567", found.getContactNumber());
        assertNotNull(found.getCreatedAt());
        assertTrue(found.isActive());
    }

    @Test
    void shouldReturnDentistsList() throws Exception {
        List<Dentist> dentists = dentistDAO.findAll();
        assertNotNull(dentists);
    }

    @Test
    void shouldReturnNullForUnknownDentist() throws Exception {
        Dentist dentist = dentistDAO.findByDentistNumber("D-UNKNOWN-999");
        assertNull(dentist);
    }

    @Test
    void shouldUpdateDentist() throws Exception {
        String dentistNumber = "DU" + (System.currentTimeMillis() % 100000000);

        Dentist dentist = new Dentist();
        dentist.setDentistNumber(dentistNumber);
        dentist.setFullName("Dr. Before Update");
        dentist.setSpecialization("General");
        dentist.setContactNumber("0771111111");
        dentist.setCreatedAt(LocalDateTime.now());
        dentist.setActive(true);

        dentistDAO.save(dentist);
        Dentist saved = dentistDAO.findByDentistNumber(dentistNumber);
        assertNotNull(saved);

        saved.setFullName("Dr. After Update");
        saved.setSpecialization("Prosthodontics");
        saved.setContactNumber("0772222222");

        boolean updated = dentistDAO.update(saved);
        assertTrue(updated);

        Dentist updatedDentist = dentistDAO.findById(saved.getId());
        assertNotNull(updatedDentist);
        assertEquals("Dr. After Update", updatedDentist.getFullName());
        assertEquals("Prosthodontics", updatedDentist.getSpecialization());
        assertEquals("0772222222", updatedDentist.getContactNumber());
    }

    @Test
    void shouldDeactivateDentist() throws Exception {
        String dentistNumber = "DD" + (System.currentTimeMillis() % 100000000);

        Dentist dentist = new Dentist();
        dentist.setDentistNumber(dentistNumber);
        dentist.setFullName("Dr. Deactivate Test");
        dentist.setSpecialization("Pediatric");
        dentist.setContactNumber("0773333333");
        dentist.setCreatedAt(LocalDateTime.now());
        dentist.setActive(true);

        dentistDAO.save(dentist);
        Dentist saved = dentistDAO.findByDentistNumber(dentistNumber);
        assertNotNull(saved);

        boolean deactivated = dentistDAO.deactivate(saved.getId());
        assertTrue(deactivated);

        // findByDentistNumber only finds active dentists, so it should now return null
        Dentist inactiveSearch = dentistDAO.findByDentistNumber(dentistNumber);
        assertNull(inactiveSearch);

        // findById can still locate the record, but active should be false
        Dentist deactivatedDentist = dentistDAO.findById(saved.getId());
        assertNotNull(deactivatedDentist);
        assertFalse(deactivatedDentist.isActive());
    }
}