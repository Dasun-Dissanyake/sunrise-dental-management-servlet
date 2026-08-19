package com.sunrisedental.service;

import com.sunrisedental.model.Dentist;
import org.junit.jupiter.api.*;

import java.util.List;

import static org.junit.jupiter.api.Assertions.*;

@TestMethodOrder(MethodOrderer.OrderAnnotation.class)
class DentistDAOIntegrationTest {

    private static DentistService service;
    private static Long testDentistId;

    @BeforeAll
    static void setUp() {
        service = new DentistService();
    }

    @Test
    @Order(1)
    @DisplayName("Find dentist by ID")
    void testFindDentistById() {

        Dentist dentist = service.getDentistById(1L);

        assertNotNull(dentist);
        assertEquals("DENT-000001", dentist.getDentistNumber());
        assertEquals("Dr. Amara Perera", dentist.getFullName());
        assertEquals("General Dentistry", dentist.getSpecialization());
        assertTrue(dentist.isActive());
    }

    @Test
    @Order(2)
    @DisplayName("Find dentist by dentist number")
    void testFindDentistByNumber() {

        Dentist dentist =
                service.getDentistByNumber("DENT-000002");

        assertNotNull(dentist);
        assertEquals("Dr. Roshan Silva", dentist.getFullName());
        assertEquals("Orthodontics", dentist.getSpecialization());
    }

    @Test
    @Order(3)
    @DisplayName("Get all dentists")
    void testGetAllDentists() {

        List<Dentist> dentists = service.getAllDentists();

        assertNotNull(dentists);
        assertTrue(dentists.size() >= 3);
    }

    @Test
    @Order(4)
    @DisplayName("Add temporary dentist")
    void testAddDentist() {

        Dentist dentist = new Dentist();

        dentist.setDentistNumber("DENT-TEST-001");
        dentist.setFullName("Dr. Test Dentist");
        dentist.setSpecialization("Test Dentistry");
        dentist.setContactNumber("0711111111");
        dentist.setActive(true);

        boolean result = service.addDentist(dentist);

        assertTrue(result);

        Dentist saved =
                service.getDentistByNumber("DENT-TEST-001");

        assertNotNull(saved);

        testDentistId = saved.getId();

        assertEquals("Dr. Test Dentist", saved.getFullName());
        assertTrue(saved.isActive());
    }

    @Test
    @Order(5)
    @DisplayName("Update temporary dentist")
    void testUpdateDentist() {

        assertNotNull(testDentistId);

        Dentist dentist =
                service.getDentistById(testDentistId);

        assertNotNull(dentist);

        dentist.setFullName("Dr. Test Dentist Updated");
        dentist.setSpecialization("Advanced Test Dentistry");
        dentist.setContactNumber("0722222222");

        boolean result = service.updateDentist(dentist);

        assertTrue(result);

        Dentist updated =
                service.getDentistById(testDentistId);

        assertNotNull(updated);
        assertEquals(
                "Dr. Test Dentist Updated",
                updated.getFullName()
        );
        assertEquals(
                "Advanced Test Dentistry",
                updated.getSpecialization()
        );
        assertEquals(
                "0722222222",
                updated.getContactNumber()
        );
    }

    @Test
    @Order(6)
    @DisplayName("Deactivate temporary dentist")
    void testDeactivateDentist() {

        assertNotNull(testDentistId);

        boolean result =
                service.deactivateDentist(testDentistId);

        assertTrue(result);

        Dentist dentist =
                service.getDentistById(testDentistId);

        assertNotNull(dentist);
        assertFalse(dentist.isActive());
    }
}