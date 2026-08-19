package com.sunrisedental.service;

import com.sunrisedental.dao.DentistDAO;
import com.sunrisedental.model.Dentist;

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
     * Validates the required dentist information.
     *
     * @param dentist dentist object to validate
     * @return true if the dentist contains all required information
     */
    public boolean isValidDentist(Dentist dentist) {
        if (dentist == null) {
            return false;
        }

        // Dentist number is required
        if (dentist.getDentistNumber() == null ||
                dentist.getDentistNumber().isBlank()) {
            return false;
        }

        // Full name is required
        if (dentist.getFullName() == null ||
                dentist.getFullName().isBlank()) {
            return false;
        }

        // Specialization is required
        if (dentist.getSpecialization() == null ||
                dentist.getSpecialization().isBlank()) {
            return false;
        }

        // Contact number is required
        if (dentist.getContactNumber() == null ||
                dentist.getContactNumber().isBlank()) {
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
    public boolean addDentist(Dentist dentist) {
        if (!isValidDentist(dentist)) {
            return false;
        }

        return dentistDAO.save(dentist);
    }

    /**
     * Retrieves a dentist by database ID.
     *
     * @param id dentist ID
     * @return dentist if found, otherwise null
     */
    public Dentist getDentistById(Long id) {
        if (id == null || id <= 0) {
            return null;
        }

        return dentistDAO.findById(id);
    }

    /**
     * Retrieves a dentist by dentist number.
     *
     * @param dentistNumber dentist number
     * @return dentist if found, otherwise null
     */
    public Dentist getDentistByNumber(String dentistNumber) {
        if (dentistNumber == null || dentistNumber.isBlank()) {
            return null;
        }

        return dentistDAO.findByDentistNumber(dentistNumber);
    }

    /**
     * Retrieves all dentists.
     *
     * @return list of dentists
     */
    public List<Dentist> getAllDentists() {
        return dentistDAO.findAll();
    }

    /**
     * Updates an existing dentist.
     *
     * @param dentist dentist information to update
     * @return true if the dentist was successfully updated
     */
    public boolean updateDentist(Dentist dentist) {
        if (dentist == null || dentist.getId() == null ||
                dentist.getId() <= 0) {
            return false;
        }

        // For an update, validate the required fields.
        if (dentist.getFullName() == null ||
                dentist.getFullName().isBlank()) {
            return false;
        }

        if (dentist.getSpecialization() == null ||
                dentist.getSpecialization().isBlank()) {
            return false;
        }

        if (dentist.getContactNumber() == null ||
                dentist.getContactNumber().isBlank()) {
            return false;
        }

        return dentistDAO.update(dentist);
    }

    /**
     * Deactivates a dentist instead of permanently deleting the record.
     *
     * @param id dentist ID
     * @return true if successfully deactivated
     */
    public boolean deactivateDentist(Long id) {
        if (id == null || id <= 0) {
            return false;
        }

        return dentistDAO.deactivate(id);
    }
}