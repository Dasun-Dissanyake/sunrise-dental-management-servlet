package com.sunrisedental.controller;

import com.sunrisedental.model.User;
import com.sunrisedental.service.UserService;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.sql.SQLException;
import java.util.List;

@WebServlet("/users")
public class UserServlet extends HttpServlet {

    private UserService userService;

    public UserServlet() {
        this.userService = new UserService();
    }

    public UserServlet(UserService userService) {
        this.userService = userService;
    }

    @Override
    public void init() {
        if (this.userService == null) {
            this.userService = new UserService();
        }
    }

    /**
     * Handles GET requests for the User Management page.
     *
     * Supported parameters:
     * - editId : opens the edit section for a selected user
     * - pwdId  : opens the password reset section for a selected user
     */
    @Override
    protected void doGet(
            HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {

        User loggedInUser = getAuthenticatedAdmin(request, response);

        if (loggedInUser == null) {
            return;
        }

        try {

            // Load user for editing
            String editIdStr = request.getParameter("editId");

            if (editIdStr != null && !editIdStr.isBlank()) {

                try {
                    Long editId = Long.parseLong(editIdStr.trim());

                    User editUser = userService.getUserById(editId);

                    if (editUser != null) {
                        request.setAttribute("editUser", editUser);
                    } else {
                        request.setAttribute(
                                "error",
                                "User not found for editing."
                        );
                    }

                } catch (NumberFormatException e) {
                    request.setAttribute(
                            "error",
                            "Invalid user ID for editing."
                    );
                }
            }

            // Load user for password reset
            String pwdIdStr = request.getParameter("pwdId");

            if (pwdIdStr != null && !pwdIdStr.isBlank()) {

                try {
                    Long pwdId = Long.parseLong(pwdIdStr.trim());

                    User pwdUser = userService.getUserById(pwdId);

                    if (pwdUser != null) {
                        request.setAttribute("pwdUser", pwdUser);
                    } else {
                        request.setAttribute(
                                "error",
                                "User not found for password reset."
                        );
                    }

                } catch (NumberFormatException e) {
                    request.setAttribute(
                            "error",
                            "Invalid user ID for password reset."
                    );
                }
            }

            // Load all users
            List<User> users = userService.getAllUsers();

            request.setAttribute("users", users);
            request.setAttribute("user", loggedInUser);

            // Forward to User Management JSP
            request.getRequestDispatcher(
                    "/pages/users.jsp"
            ).forward(request, response);

        } catch (SQLException e) {

            e.printStackTrace();

            throw new ServletException(
                    "Unable to load user information from the database.",
                    e
            );
        }
    }

    /**
     * Handles POST requests for User Management.
     *
     * Supported actions:
     * - create
     * - update
     * - activate
     * - deactivate
     * - changePassword
     */
    @Override
    protected void doPost(
            HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {

        User loggedInUser = getAuthenticatedAdmin(request, response);

        if (loggedInUser == null) {
            return;
        }

        String action = request.getParameter("action");

        try {

            if ("create".equalsIgnoreCase(action)) {

                handleCreate(request, response);

            } else if ("update".equalsIgnoreCase(action)) {

                handleUpdate(
                        request,
                        response,
                        loggedInUser
                );

            } else if ("activate".equalsIgnoreCase(action)) {

                handleActivate(
                        request,
                        response
                );

            } else if ("deactivate".equalsIgnoreCase(action)) {

                handleDeactivate(
                        request,
                        response,
                        loggedInUser
                );

            } else if ("changePassword".equalsIgnoreCase(action)) {

                handleChangePassword(
                        request,
                        response
                );

            } else {

                request.setAttribute(
                        "error",
                        "Invalid user management action."
                );

                forwardWithUsers(
                        request,
                        response,
                        loggedInUser
                );
            }

        } catch (IllegalArgumentException e) {

            /*
             * Business validation errors from UserService.
             */
            request.setAttribute(
                    "error",
                    e.getMessage()
            );

            preserveFormStateOnError(request, action);

            forwardWithUsers(
                    request,
                    response,
                    loggedInUser
            );

        } catch (SQLException e) {

            /*
             * Database errors.
             */
            e.printStackTrace();

            request.setAttribute(
                    "error",
                    "Database error: " + e.getMessage()
            );

            preserveFormStateOnError(request, action);

            forwardWithUsers(
                    request,
                    response,
                    loggedInUser
            );
        }
    }

    private void preserveFormStateOnError(
            HttpServletRequest request,
            String action) {

        String idStr = request.getParameter("id");

        if (idStr != null && !idStr.isBlank()) {
            try {
                Long id = Long.parseLong(idStr.trim());
                User targetUser = userService.getUserById(id);

                if (targetUser != null) {
                    if ("update".equalsIgnoreCase(action)) {
                        request.setAttribute("editUser", targetUser);
                    } else if ("changePassword".equalsIgnoreCase(action)) {
                        request.setAttribute("pwdUser", targetUser);
                    }
                }
            } catch (Exception ignored) {
            }
        }
    }

    /**
     * Creates a new user account.
     */
    private void handleCreate(
            HttpServletRequest request,
            HttpServletResponse response)
            throws SQLException, IOException {

        User user = new User();

        user.setUsername(
                request.getParameter("username")
        );

        user.setFullName(
                request.getParameter("fullName")
        );

        user.setRole(
                request.getParameter("role")
        );

        String password = request.getParameter("password");

        String confirmPassword =
                request.getParameter("confirmPassword");

        userService.createUser(
                user,
                password,
                confirmPassword
        );

        response.sendRedirect(
                request.getContextPath()
                        + "/users?success=created"
        );
    }

    /**
     * Updates an existing user's full name and role.
     */
    private void handleUpdate(
            HttpServletRequest request,
            HttpServletResponse response,
            User loggedInUser)
            throws SQLException, IOException {

        String idStr = request.getParameter("id");

        if (idStr == null || idStr.isBlank()) {
            throw new IllegalArgumentException(
                    "User ID is required for update."
            );
        }

        Long id;

        try {

            id = Long.parseLong(
                    idStr.trim()
            );

        } catch (NumberFormatException e) {

            throw new IllegalArgumentException(
                    "Invalid user ID format."
            );
        }

        String fullName =
                request.getParameter("fullName");

        String role =
                request.getParameter("role");

        userService.updateUser(
                id,
                fullName,
                role,
                loggedInUser
        );

        response.sendRedirect(
                request.getContextPath()
                        + "/users?success=updated"
        );
    }

    /**
     * Activates a user account.
     */
    private void handleActivate(
            HttpServletRequest request,
            HttpServletResponse response)
            throws SQLException, IOException {

        String idStr =
                request.getParameter("id");

        if (idStr == null || idStr.isBlank()) {
            throw new IllegalArgumentException(
                    "User ID is required."
            );
        }

        Long id;

        try {

            id = Long.parseLong(
                    idStr.trim()
            );

        } catch (NumberFormatException e) {

            throw new IllegalArgumentException(
                    "Invalid user ID format."
            );
        }

        userService.activateUser(id);

        response.sendRedirect(
                request.getContextPath()
                        + "/users?success=activated"
        );
    }

    /**
     * Deactivates a user account.
     */
    private void handleDeactivate(
            HttpServletRequest request,
            HttpServletResponse response,
            User loggedInUser)
            throws SQLException, IOException {

        String idStr =
                request.getParameter("id");

        if (idStr == null || idStr.isBlank()) {
            throw new IllegalArgumentException(
                    "User ID is required."
            );
        }

        Long id;

        try {

            id = Long.parseLong(
                    idStr.trim()
            );

        } catch (NumberFormatException e) {

            throw new IllegalArgumentException(
                    "Invalid user ID format."
            );
        }

        userService.deactivateUser(
                id,
                loggedInUser
        );

        response.sendRedirect(
                request.getContextPath()
                        + "/users?success=deactivated"
        );
    }

    /**
     * Changes/resets a user's password.
     */
    private void handleChangePassword(
            HttpServletRequest request,
            HttpServletResponse response)
            throws SQLException, IOException {

        String idStr =
                request.getParameter("id");

        if (idStr == null || idStr.isBlank()) {
            throw new IllegalArgumentException(
                    "User ID is required."
            );
        }

        Long id;

        try {

            id = Long.parseLong(
                    idStr.trim()
            );

        } catch (NumberFormatException e) {

            throw new IllegalArgumentException(
                    "Invalid user ID format."
            );
        }

        String newPassword =
                request.getParameter("newPassword");

        String confirmPassword =
                request.getParameter("confirmPassword");

        userService.changePassword(
                id,
                newPassword,
                confirmPassword
        );

        response.sendRedirect(
                request.getContextPath()
                        + "/users?success=password_changed"
        );
    }

    /**
     * Ensures that only an authenticated ADMIN can access
     * User Management.
     */
    private User getAuthenticatedAdmin(
            HttpServletRequest request,
            HttpServletResponse response)
            throws IOException {

        HttpSession session =
                request.getSession(false);

        User loggedInUser = null;

        if (session != null) {

            loggedInUser =
                    (User) session.getAttribute(
                            "loggedInUser"
                    );
        }

        // Not logged in
        if (loggedInUser == null) {

            response.sendRedirect(
                    request.getContextPath()
                            + "/pages/login.html"
            );

            return null;
        }

        // Logged in but not an administrator
        if (!"ADMIN".equalsIgnoreCase(
                loggedInUser.getRole())) {

            response.sendRedirect(
                    request.getContextPath()
                            + "/dashboard?error=unauthorized"
            );

            return null;
        }

        return loggedInUser;
    }

    /**
     * Reloads the user list and forwards back to users.jsp
     * after a validation/database error.
     */
    private void forwardWithUsers(
            HttpServletRequest request,
            HttpServletResponse response,
            User loggedInUser)
            throws ServletException, IOException {

        try {

            List<User> users =
                    userService.getAllUsers();

            request.setAttribute(
                    "users",
                    users
            );

            request.setAttribute(
                    "user",
                    loggedInUser
            );

            request.getRequestDispatcher(
                    "/pages/users.jsp"
            ).forward(
                    request,
                    response
            );

        } catch (SQLException e) {

            e.printStackTrace();

            throw new ServletException(
                    "Unable to reload user information.",
                    e
            );
        }
    }
}