package com.sunrisedental.dao;

import com.sunrisedental.model.User;
import org.junit.jupiter.api.Test;

import static org.junit.jupiter.api.Assertions.*;

class UserDAOTest {

    @Test
    void shouldFindUserByUsername() throws Exception {

        UserDAO userDAO = new UserDAO();

        User user = userDAO.findByUsername("admin");

        assertNotNull(user);
        assertEquals("admin", user.getUsername());
        assertNotNull(user.getFullName());
        assertNotNull(user.getRole());
    }

    @Test
    void shouldPerformCrudAndStatusOperations() throws Exception {
        UserDAO userDAO = new UserDAO();
        String uniqueUsername = "test_user_" + System.currentTimeMillis();

        User newUser = new User();
        newUser.setUsername(uniqueUsername);
        newUser.setFullName("Test User DAO");
        newUser.setRole("RECEPTIONIST");
        newUser.setPassword("hashed_pw_placeholder");
        newUser.setEnabled(true);

        // Save
        boolean saved = userDAO.save(newUser);
        assertTrue(saved);

        // Exists
        assertTrue(userDAO.existsByUsername(uniqueUsername));

        // Find by username
        User found = userDAO.findByUsername(uniqueUsername);
        assertNotNull(found);
        assertNotNull(found.getId());
        assertEquals("Test User DAO", found.getFullName());
        assertEquals("RECEPTIONIST", found.getRole());
        assertTrue(found.isEnabled());

        // Find by ID
        User foundById = userDAO.findById(found.getId());
        assertNotNull(foundById);
        assertEquals(found.getId(), foundById.getId());

        // Update
        found.setFullName("Updated Test User");
        found.setRole("DENTIST");
        boolean updated = userDAO.update(found);
        assertTrue(updated);

        User updatedUser = userDAO.findById(found.getId());
        assertEquals("Updated Test User", updatedUser.getFullName());
        assertEquals("DENTIST", updatedUser.getRole());

        // Update status
        boolean deactivated = userDAO.updateStatus(found.getId(), false);
        assertTrue(deactivated);
        User deactivatedUser = userDAO.findById(found.getId());
        assertFalse(deactivatedUser.isEnabled());

        boolean reactivated = userDAO.updateStatus(found.getId(), true);
        assertTrue(reactivated);
        User reactivatedUser = userDAO.findById(found.getId());
        assertTrue(reactivatedUser.isEnabled());

        // Update password
        boolean pwUpdated = userDAO.updatePassword(found.getId(), "new_hashed_password");
        assertTrue(pwUpdated);
        User pwUpdatedUser = userDAO.findById(found.getId());
        assertEquals("new_hashed_password", pwUpdatedUser.getPassword());

        // Find all
        assertFalse(userDAO.findAll().isEmpty());

        // Count active admins
        int activeAdmins = userDAO.countActiveAdmins();
        assertTrue(activeAdmins >= 1);
    }
}