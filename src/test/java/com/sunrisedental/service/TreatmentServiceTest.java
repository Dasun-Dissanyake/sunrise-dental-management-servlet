package com.sunrisedental.service;

import com.sunrisedental.dao.TreatmentDAO;
import com.sunrisedental.model.Treatment;
import org.junit.jupiter.api.Test;

import java.sql.SQLException;
import java.util.List;

import static org.junit.jupiter.api.Assertions.*;

class TreatmentServiceTest {

    private final TreatmentService service = new TreatmentService(new TreatmentDAO() {
        @Override
        public Treatment findByTreatmentCode(String code) {
            if ("EXISTING-001".equals(code)) {
                Treatment t = new Treatment();
                t.setId(1L);
                t.setTreatmentCode("EXISTING-001");
                return t;
            }
            return null;
        }

        @Override
        public boolean save(Treatment treatment) {
            return true;
        }

        @Override
        public List<Treatment> findAll() {
            return List.of();
        }

        @Override
        public Treatment findById(Long id) {
            if (Long.valueOf(1L).equals(id)) {
                Treatment t = new Treatment();
                t.setId(1L);
                t.setTreatmentCode("EXISTING-001");
                return t;
            }
            return null;
        }

        @Override
        public boolean deactivate(Long id) {
            return Long.valueOf(1L).equals(id);
        }
    });

    @Test
    void shouldAddValidTreatment() throws SQLException {
        Treatment treatment = createValidTreatment("TRT-TEST-1");
        boolean result = service.addTreatment(treatment);
        assertTrue(result);
        assertTrue(treatment.isActive());
        assertNotNull(treatment.getCreatedAt());
    }

    @Test
    void shouldRejectNullTreatment() {
        assertThrows(
                IllegalArgumentException.class,
                () -> service.addTreatment(null)
        );
    }

    @Test
    void shouldRejectBlankTreatmentCode() {
        Treatment treatment = createValidTreatment("");
        assertThrows(
                IllegalArgumentException.class,
                () -> service.addTreatment(treatment)
        );
    }

    @Test
    void shouldRejectNullTreatmentCode() {
        Treatment treatment = createValidTreatment(null);
        assertThrows(
                IllegalArgumentException.class,
                () -> service.addTreatment(treatment)
        );
    }

    @Test
    void shouldRejectBlankTreatmentName() {
        Treatment treatment = createValidTreatment("TRT-002");
        treatment.setTreatmentName("");
        assertThrows(
                IllegalArgumentException.class,
                () -> service.addTreatment(treatment)
        );
    }

    @Test
    void shouldRejectNullTreatmentName() {
        Treatment treatment = createValidTreatment("TRT-002");
        treatment.setTreatmentName(null);
        assertThrows(
                IllegalArgumentException.class,
                () -> service.addTreatment(treatment)
        );
    }

    @Test
    void shouldRejectNullTreatmentCost() {
        Treatment treatment = createValidTreatment("TRT-003");
        treatment.setTreatmentCost(null);
        assertThrows(
                IllegalArgumentException.class,
                () -> service.addTreatment(treatment)
        );
    }

    @Test
    void shouldRejectNegativeTreatmentCost() {
        Treatment treatment = createValidTreatment("TRT-003");
        treatment.setTreatmentCost(-100.0);
        assertThrows(
                IllegalArgumentException.class,
                () -> service.addTreatment(treatment)
        );
    }

    @Test
    void shouldRejectNullConsultationFee() {
        Treatment treatment = createValidTreatment("TRT-004");
        treatment.setConsultationFee(null);
        assertThrows(
                IllegalArgumentException.class,
                () -> service.addTreatment(treatment)
        );
    }

    @Test
    void shouldRejectNegativeConsultationFee() {
        Treatment treatment = createValidTreatment("TRT-004");
        treatment.setConsultationFee(-50.0);
        assertThrows(
                IllegalArgumentException.class,
                () -> service.addTreatment(treatment)
        );
    }

    @Test
    void shouldRejectDuplicateTreatmentCode() {
        Treatment treatment = createValidTreatment("EXISTING-001");
        assertThrows(
                IllegalArgumentException.class,
                () -> service.addTreatment(treatment)
        );
    }

    @Test
    void shouldSuccessfullyDeactivateTreatment() throws SQLException {
        boolean result = service.deactivateTreatment(1L);
        assertTrue(result);
    }

    @Test
    void shouldRejectNullTreatmentIdOnDeactivation() {
        assertThrows(
                IllegalArgumentException.class,
                () -> service.deactivateTreatment(null)
        );
    }

    @Test
    void shouldRejectZeroTreatmentIdOnDeactivation() {
        assertThrows(
                IllegalArgumentException.class,
                () -> service.deactivateTreatment(0L)
        );
    }

    @Test
    void shouldRejectNegativeTreatmentIdOnDeactivation() {
        assertThrows(
                IllegalArgumentException.class,
                () -> service.deactivateTreatment(-5L)
        );
    }

    @Test
    void shouldGetTreatmentByCode() throws SQLException {
        Treatment t = service.getTreatmentByCode("EXISTING-001");
        assertNotNull(t);
        assertEquals("EXISTING-001", t.getTreatmentCode());
    }

    @Test
    void shouldReturnNullForBlankTreatmentCode() throws SQLException {
        assertNull(service.getTreatmentByCode(""));
        assertNull(service.getTreatmentByCode(null));
    }

    @Test
    void shouldGetTreatmentById() throws SQLException {
        Treatment t = service.getTreatmentById(1L);
        assertNotNull(t);
        assertEquals(1L, t.getId());
    }

    @Test
    void shouldReturnNullForInvalidTreatmentId() throws SQLException {
        assertNull(service.getTreatmentById(null));
        assertNull(service.getTreatmentById(0L));
        assertNull(service.getTreatmentById(-1L));
    }

    @Test
    void shouldGetAllTreatments() throws SQLException {
        List<Treatment> list = service.getAllTreatments();
        assertNotNull(list);
    }

    private Treatment createValidTreatment(String code) {
        Treatment treatment = new Treatment();
        treatment.setTreatmentCode(code);
        treatment.setTreatmentName("Root Canal Treatment");
        treatment.setDescription("Endodontic therapy procedure");
        treatment.setTreatmentCost(15000.0);
        treatment.setConsultationFee(2000.0);
        return treatment;
    }
}
