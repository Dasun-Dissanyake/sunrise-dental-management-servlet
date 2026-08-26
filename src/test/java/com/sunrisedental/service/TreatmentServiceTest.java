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
    void shouldRejectBlankTreatmentName() {
        Treatment treatment = createValidTreatment("TRT-002");
        treatment.setTreatmentName("");
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
