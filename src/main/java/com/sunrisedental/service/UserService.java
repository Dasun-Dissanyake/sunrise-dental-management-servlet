package com.sunrisedental.service;

import com.sunrisedental.dao.UserDAO;
import com.sunrisedental.model.User;
import org.mindrot.jbcrypt.BCrypt;

import java.sql.SQLException;
import java.time.LocalDateTime;
import java.util.List;
import java.util.Set;

public class UserService {

    private static final Set<String> VALID_ROLES =
            Set.of("ADMIN", "DENTIST", "RECEPTIONIST");

    private static final int MIN_PASSWORD_LENGTH = 6;

    private final UserDAO userDAO;

    public UserService() {
        this.userDAO = new UserDAO();
    }

    public UserService(UserDAO userDAO) {
        this.userDAO = userDAO;
    }

    /**
     * Retrieves all users from the database.
     */
    public List<User> getAllUsers() throws SQLException {
        return userDAO.findAll();
    }

    /**
     * Retrieves a user by their primary key ID.
     */
    public User getUserById(Long id) throws SQLException {
        if (id == null || id <= 0) {
            return null;
        }

        return userDAO.findById(id);
    }

    /**
     * Retrieves a user by their username.
     */
    public User getUserByUsername(String username) throws SQLException {
        if (username == null || username.isBlank()) {
            return null;
        }

        return userDAO.findByUsername(username.trim());
    }

    /**
     * Creates a new ADMIN, DENTIST, or RECEPTIONIST user account.
     *
     * Passwords are securely hashed using BCrypt before being stored.
     */
    public boolean createUser(
            User user,
            String rawPassword,
            String confirmPassword) throws SQLException {

        if (user == null) {
            throw new IllegalArgumentException(
                    "User information is required."
            );
        }

        // Username validation
        if (user.getUsername() == null ||
                user.getUsername().isBlank()) {

            throw new IllegalArgumentException(
                    "Username is required."
            );
        }

        String trimmedUsername = user.getUsername().trim();

        if (trimmedUsername.length() < 3) {
            throw new IllegalArgumentException(
                    "Username must be at least 3 characters long."
            );
        }

        // Duplicate username validation
        if (userDAO.existsByUsername(trimmedUsername)) {
            throw new IllegalArgumentException(
                    "Username already exists. Please choose a different username."
            );
        }

        // Full name validation
        if (user.getFullName() == null ||
                user.getFullName().isBlank()) {

            throw new IllegalArgumentException(
                    "Full name is required."
            );
        }

        // Role validation
        if (user.getRole() == null ||
                user.getRole().isBlank()) {

            throw new IllegalArgumentException(
                    "Role is required."
            );
        }

        String normalizedRole =
                user.getRole().trim().toUpperCase();

        if (!VALID_ROLES.contains(normalizedRole)) {
            throw new IllegalArgumentException(
                    "Invalid role. Role must be ADMIN, DENTIST, or RECEPTIONIST."
            );
        }

        // Password validation
        validatePassword(rawPassword, confirmPassword);

        // BCrypt password hashing
        String hashedPassword =
                BCrypt.hashpw(rawPassword, BCrypt.gensalt(12));

        // Prepare user object
        user.setUsername(trimmedUsername);
        user.setFullName(user.getFullName().trim());
        user.setRole(normalizedRole);
        user.setPassword(hashedPassword);
        user.setEnabled(true);

        if (user.getCreatedAt() == null) {
            user.setCreatedAt(LocalDateTime.now());
        }

        return userDAO.save(user);
    }

    /**
     * Updates profile details for an existing user.
     *
     * Only Full Name and Role are updated here.
     */
    public boolean updateUser(
            Long id,
            String fullName,
            String role,
            User loggedInUser) throws SQLException {

        if (id == null || id <= 0) {
            throw new IllegalArgumentException(
                    "Valid user ID is required."
            );
        }

        User existing = userDAO.findById(id);

        if (existing == null) {
            throw new IllegalArgumentException(
                    "User not found."
            );
        }

        // Full name validation
        if (fullName == null || fullName.isBlank()) {
            throw new IllegalArgumentException(
                    "Full name is required."
            );
        }

        // Role validation
        if (role == null || role.isBlank()) {
            throw new IllegalArgumentException(
                    "Role is required."
            );
        }

        String normalizedRole =
                role.trim().toUpperCase();

        if (!VALID_ROLES.contains(normalizedRole)) {
            throw new IllegalArgumentException(
                    "Invalid role. Role must be ADMIN, DENTIST, or RECEPTIONIST."
            );
        }

        /*
         * Prevent changing the role of the last active administrator.
         */
        if ("ADMIN".equalsIgnoreCase(existing.getRole())
                && !"ADMIN".equalsIgnoreCase(normalizedRole)) {

            if (existing.isEnabled()
                    && userDAO.countActiveAdmins() <= 1) {

                throw new IllegalArgumentException(
                        "Cannot change the role of the only remaining active administrator."
                );
            }
        }

        existing.setFullName(fullName.trim());
        existing.setRole(normalizedRole);

        return userDAO.update(existing);
    }

    /**
     * Activates a user account.
     */
    public boolean activateUser(Long id) throws SQLException {

        if (id == null || id <= 0) {
            throw new IllegalArgumentException(
                    "Valid user ID is required."
            );
        }

        User existing = userDAO.findById(id);

        if (existing == null) {
            throw new IllegalArgumentException(
                    "User not found."
            );
        }

        return userDAO.updateStatus(id, true);
    }

    /**
     * Deactivates a user account.
     *
     * Prevents:
     * - Self-deactivation
     * - Deactivation of the last active administrator
     */
    public boolean deactivateUser(
            Long id,
            User loggedInUser) throws SQLException {

        if (id == null || id <= 0) {
            throw new IllegalArgumentException(
                    "Valid user ID is required."
            );
        }

        User existing = userDAO.findById(id);

        if (existing == null) {
            throw new IllegalArgumentException(
                    "User not found."
            );
        }

        /*
         * Prevent an administrator from deactivating
         * their own currently logged-in account.
         */
        if (loggedInUser != null) {

            if (loggedInUser.getId() != null
                    && loggedInUser.getId().equals(id)) {

                throw new IllegalArgumentException(
                        "You cannot deactivate your own currently logged-in account."
                );
            }

            if (loggedInUser.getUsername() != null
                    && existing.getUsername() != null
                    && loggedInUser.getUsername()
                    .equalsIgnoreCase(existing.getUsername())) {

                throw new IllegalArgumentException(
                        "You cannot deactivate your own currently logged-in account."
                );
            }
        }

        /*
         * Prevent deactivating the last active administrator.
         */
        if ("ADMIN".equalsIgnoreCase(existing.getRole())
                && existing.isEnabled()) {

            if (userDAO.countActiveAdmins() <= 1) {

                throw new IllegalArgumentException(
                        "Cannot deactivate the only remaining active administrator."
                );
            }
        }

        return userDAO.updateStatus(id, false);
    }

    /**
     * Changes or resets a user's password.
     *
     * The password is hashed using BCrypt before
     * being stored in the database.
     */
    public boolean changePassword(
            Long id,
            String newPassword,
            String confirmPassword) throws SQLException {

        if (id == null || id <= 0) {
            throw new IllegalArgumentException(
                    "Valid user ID is required."
            );
        }

        User existing = userDAO.findById(id);

        if (existing == null) {
            throw new IllegalArgumentException(
                    "User not found."
            );
        }

        validatePassword(
                newPassword,
                confirmPassword
        );

        String hashedPassword =
                BCrypt.hashpw(
                        newPassword,
                        BCrypt.gensalt(12)
                );

        return userDAO.updatePassword(
                id,
                hashedPassword
        );
    }

    /**
     * Validates password requirements.
     */
    private void validatePassword(
            String password,
            String confirmPassword) {

        if (password == null || password.isBlank()) {
            throw new IllegalArgumentException(
                    "Password is required."
            );
        }

        if (password.length() < MIN_PASSWORD_LENGTH) {
            throw new IllegalArgumentException(
                    "Password must be at least "
                            + MIN_PASSWORD_LENGTH
                            + " characters long."
            );
        }

        if (confirmPassword == null
                || !password.equals(confirmPassword)) {

            throw new IllegalArgumentException(
                    "Password and confirmation password do not match."
            );
        }
    }
}