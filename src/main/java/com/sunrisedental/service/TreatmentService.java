package com.sunrisedental.service;

import com.sunrisedental.dao.TreatmentDAO;
import com.sunrisedental.model.Treatment;

import java.sql.SQLException;
import java.util.List;

public class TreatmentService {

    private final TreatmentDAO treatmentDAO;

    public TreatmentService() {
        this.treatmentDAO = new TreatmentDAO();
    }

    public TreatmentService(TreatmentDAO treatmentDAO) {
        this.treatmentDAO = treatmentDAO;
    }

    public List<Treatment> getAllTreatments() throws SQLException {
        return treatmentDAO.findAll();
    }

    public Treatment getTreatmentById(Long id) throws SQLException {
        if (id == null || id <= 0) {
            return null;
        }
        return treatmentDAO.findById(id);
    }

    public Treatment getTreatmentByCode(String code) throws SQLException {
        if (code == null || code.isBlank()) {
            return null;
        }
        return treatmentDAO.findByTreatmentCode(code.trim());
    }
}