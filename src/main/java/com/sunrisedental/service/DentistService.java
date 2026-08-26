package com.sunrisedental.service;

import com.sunrisedental.dao.DentistDAO;
import com.sunrisedental.model.Dentist;

import java.sql.SQLException;
import java.time.LocalDateTime;
import java.util.List;

public class DentistService {

    private final DentistDAO dentistDAO;

    public DentistService() {
        this.dentistDAO = new DentistDAO();
    }

    public DentistService(DentistDAO dentistDAO) {
        this.dentistDAO = dentistDAO;
    }

    /**
     * Validates required dentist fields and throws IllegalArgumentException if invalid.
     *
     * @param dentist dentist object to validate
     */
    public void validateDentist(Dentist dentist) {
        if (dentist == null) {
            throw new IllegalArgumentException("Dentist information is required.");
        }

        if (dentist.getDentistNumber() == null || dentist.getDentistNumber().isBlank()) {
            throw new IllegalArgumentException("Dentist number is required.");
        }

        if (dentist.getFullName() == null || dentist.getFullName().isBlank()) {
            throw new IllegalArgumentException("Dentist name is required.");
        }

        if (dentist.getSpecialization() == null || dentist.getSpecialization().isBlank()) {
            throw new IllegalArgumentException("Specialization is required.");
        }

        if (dentist.getContactNumber() == null || dentist.getContactNumber().isBlank()) {
            throw new IllegalArgumentException("Contact number is required.");
        }
    }

    /**
     * Validates the required dentist information.
     *
     * @param dentist dentist object to validate
     * @return true if the dentist contains all required information
     */
    public boolean isValidDentist(Dentist dentist) {
        if (dentist == null) {
            return false;
        }

        if (dentist.getDentistNumber() == null || dentist.getDentistNumber().isBlank()) {
            return false;
        }

        if (dentist.getFullName() == null || dentist.getFullName().isBlank()) {
            return false;
        }

        if (dentist.getSpecialization() == null || dentist.getSpecialization().isBlank()) {
            return false;
        }

        if (dentist.getContactNumber() == null || dentist.getContactNumber().isBlank()) {
            return false;
        }

        return true;
    }

    /**
     * Adds a new dentist.
     *
     * @param dentist dentist to add
     * @return true if the dentist was successfully added
     */
    public boolean addDentist(Dentist dentist) throws SQLException {
        validateDentist(dentist);

        Dentist existing = dentistDAO.findByDentistNumber(dentist.getDentistNumber().trim());
        if (existing != null) {
            throw new IllegalArgumentException("A dentist with this dentist number already exists.");
        }

        if (dentist.getCreatedAt() == null) {
            dentist.setCreatedAt(LocalDateTime.now());
        }
        dentist.setActive(true);

        return dentistDAO.save(dentist);
    }

    /**
     * Retrieves a dentist by database ID.
     *
     * @param id dentist ID
     * @return dentist if found, otherwise null
     */
    public Dentist getDentistById(Long id) throws SQLException {
        if (id == null || id <= 0) {
            return null;
        }

        return dentistDAO.findById(id);
    }

    /**
     * Retrieves an active dentist by dentist number.
     *
     * @param dentistNumber dentist number
     * @return dentist if found, otherwise null
     */
    public Dentist getDentistByNumber(String dentistNumber) throws SQLException {
        if (dentistNumber == null || dentistNumber.trim().isEmpty()) {
            throw new IllegalArgumentException("Dentist number is required.");
        }

        return dentistDAO.findByDentistNumber(dentistNumber.trim());
    }

    /**
     * Retrieves all active dentists.
     *
     * @return list of active dentists
     */
    public List<Dentist> getAllDentists() throws SQLException {
        return dentistDAO.findAll();
    }

    /**
     * Updates an existing dentist.
     *
     * @param dentist dentist information to update
     * @return true if the dentist was successfully updated
     */
    public boolean updateDentist(Dentist dentist) throws SQLException {
        if (dentist == null || dentist.getId() == null || dentist.getId() <= 0) {
            throw new IllegalArgumentException("Valid dentist ID is required.");
        }

        if (dentist.getFullName() == null || dentist.getFullName().isBlank()) {
            throw new IllegalArgumentException("Dentist name is required.");
        }

        if (dentist.getSpecialization() == null || dentist.getSpecialization().isBlank()) {
            throw new IllegalArgumentException("Specialization is required.");
        }

        if (dentist.getContactNumber() == null || dentist.getContactNumber().isBlank()) {
            throw new IllegalArgumentException("Contact number is required.");
        }

        return dentistDAO.update(dentist);
    }

    /**
     * Deactivates a dentist instead of permanently deleting the record.
     *
     * @param id dentist ID
     * @return true if successfully deactivated
     */
    public boolean deactivateDentist(Long id) throws SQLException {
        if (id == null || id <= 0) {
            throw new IllegalArgumentException("Valid dentist ID is required.");
        }

        return dentistDAO.deactivate(id);
    }
}