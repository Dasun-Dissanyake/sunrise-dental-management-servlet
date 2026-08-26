
package com.sunrisedental.service;

import com.sunrisedental.dao.TreatmentDAO;
import com.sunrisedental.model.Treatment;

import java.sql.SQLException;
import java.time.LocalDateTime;
import java.util.List;

public class TreatmentService {

    private final TreatmentDAO treatmentDAO;

    public TreatmentService() {
        this.treatmentDAO = new TreatmentDAO();
    }

    public TreatmentService(TreatmentDAO treatmentDAO) {
        this.treatmentDAO = treatmentDAO;
    }

    public boolean addTreatment(Treatment treatment)
            throws SQLException {

        validateTreatment(treatment);

        Treatment existing =
                treatmentDAO.findByTreatmentCode(
                        treatment.getTreatmentCode().trim()
                );

        if (existing != null) {
            throw new IllegalArgumentException(
                    "A treatment with this treatment code already exists."
            );
        }

        treatment.setCreatedAt(
                LocalDateTime.now()
        );

        treatment.setActive(true);

        return treatmentDAO.save(treatment);
    }

    public List<Treatment> getAllTreatments()
            throws SQLException {

        return treatmentDAO.findAll();
    }

    public Treatment getTreatmentById(Long id)
            throws SQLException {

        if (id == null || id <= 0) {
            return null;
        }

        return treatmentDAO.findById(id);
    }

    public Treatment getTreatmentByCode(String code)
            throws SQLException {

        if (code == null || code.isBlank()) {
            return null;
        }

        return treatmentDAO.findByTreatmentCode(
                code.trim()
        );
    }

    public boolean updateTreatment(
            Treatment treatment)
            throws SQLException {

        if (treatment == null ||
                treatment.getId() == null ||
                treatment.getId() <= 0) {

            return false;
        }

        validateTreatmentForUpdate(treatment);

        return treatmentDAO.update(treatment);
    }

    public boolean deactivateTreatment(Long id)
            throws SQLException {

        if (id == null || id <= 0) {
            return false;
        }

        return treatmentDAO.deactivate(id);
    }

    private void validateTreatment(
            Treatment treatment) {

        if (treatment == null) {
            throw new IllegalArgumentException(
                    "Treatment information is required."
            );
        }

        if (treatment.getTreatmentCode() == null ||
                treatment.getTreatmentCode().isBlank()) {

            throw new IllegalArgumentException(
                    "Treatment code is required."
            );
        }

        if (treatment.getTreatmentName() == null ||
                treatment.getTreatmentName().isBlank()) {

            throw new IllegalArgumentException(
                    "Treatment name is required."
            );
        }

        validateCosts(treatment);
    }

    private void validateTreatmentForUpdate(
            Treatment treatment) {

        if (treatment.getTreatmentName() == null ||
                treatment.getTreatmentName().isBlank()) {

            throw new IllegalArgumentException(
                    "Treatment name is required."
            );
        }

        validateCosts(treatment);
    }

    private void validateCosts(
            Treatment treatment) {

        if (treatment.getTreatmentCost() == null) {
            throw new IllegalArgumentException(
                    "Treatment cost is required."
            );
        }

        if (treatment.getTreatmentCost() < 0) {
            throw new IllegalArgumentException(
                    "Treatment cost cannot be negative."
            );
        }

        if (treatment.getConsultationFee() == null) {
            throw new IllegalArgumentException(
                    "Consultation fee is required."
            );
        }

        if (treatment.getConsultationFee() < 0) {
            throw new IllegalArgumentException(
                    "Consultation fee cannot be negative."
            );
        }
    }
}

