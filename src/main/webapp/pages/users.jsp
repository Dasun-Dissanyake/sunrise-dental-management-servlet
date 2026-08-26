<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="java.util.List" %>
<%@ page import="com.sunrisedental.model.User" %>

<%
    User user = (User) session.getAttribute("loggedInUser");

    if (user == null) {
        user = (User) request.getAttribute("user");
    }

    List<User> users = (List<User>) request.getAttribute("users");
    User editUser = (User) request.getAttribute("editUser");
    User pwdUser = (User) request.getAttribute("pwdUser");

    String error = (String) request.getAttribute("error");
    if (error == null) {
        error = request.getParameter("error");
    }
    String success = request.getParameter("success");

    String successMessage = null;

    if ("created".equals(success)) {
        successMessage = "User account created successfully.";
    } else if ("updated".equals(success)) {
        successMessage = "User account updated successfully.";
    } else if ("activated".equals(success)) {
        successMessage = "User account activated successfully.";
    } else if ("deactivated".equals(success)) {
        successMessage = "User account deactivated successfully.";
    } else if ("password_changed".equals(success)) {
        successMessage = "User password updated successfully.";
    }
%>

<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">

    <title>User Management - Sunrise Dental</title>

    <link rel="stylesheet"
          href="<%= request.getContextPath() %>/css/sunrise-theme.css">
</head>

<body>

<header class="header">

    <div class="header-inner">

        <a class="brand"
           href="<%= request.getContextPath() %>/dashboard">

            <img
                src="<%= request.getContextPath() %>/assets/images/sunrise-dental-logo.png"
                alt="Sunrise Dental Logo"
                class="brand-logo"
            >

            <div>
                <div class="brand-name">
                    Sunrise Dental
                </div>

                <div class="brand-subtitle">
                    Management System
                </div>
            </div>

        </a>

        <div class="user-section">

            <div class="user-info">

                <div class="user-name">
                    <%= user != null ? user.getFullName() : "Administrator" %>
                </div>

                <div class="user-role">
                    <%= user != null ? user.getRole() : "ADMIN" %>
                </div>

            </div>

            <a class="logout"
               href="<%= request.getContextPath() %>/logout">
                Logout
            </a>

        </div>

    </div>

</header>


<nav class="nav-bar">

    <div class="nav-inner">

        <a class="nav-link"
           href="<%= request.getContextPath() %>/dashboard">
            Dashboard
        </a>

        <a class="nav-link"
           href="<%= request.getContextPath() %>/appointments">
            Appointments
        </a>

        <a class="nav-link"
           href="<%= request.getContextPath() %>/patients">
            Patients
        </a>

        <a class="nav-link"
           href="<%= request.getContextPath() %>/dentists">
            Dentists
        </a>

        <a class="nav-link"
           href="<%= request.getContextPath() %>/treatments">
            Treatments
        </a>

        <a class="nav-link"
           href="<%= request.getContextPath() %>/bills">
            Billing
        </a>

        <a class="nav-link"
           href="<%= request.getContextPath() %>/reports">
            Reports
        </a>

        <a class="nav-link"
           href="<%= request.getContextPath() %>/help">
            Help
        </a>

        <% if (user != null && "ADMIN".equalsIgnoreCase(user.getRole())) { %>

            <a class="nav-link active"
               href="<%= request.getContextPath() %>/users">
                User Management
            </a>

        <% } %>

    </div>

</nav>


<main class="container">

    <div class="page-header">

        <div class="page-header-text">

            <h1>User Management</h1>

            <p>
                Create and manage clinic staff credentials, roles, and account statuses.
            </p>

        </div>

        <div class="page-header-actions">

            <a class="back-link"
               href="<%= request.getContextPath() %>/dashboard">

                &larr; Back to Dashboard

            </a>

        </div>

    </div>


    <!-- SUCCESS MESSAGE -->

    <% if (successMessage != null) { %>

        <div class="message success">
            <%= successMessage %>
        </div>

    <% } %>


    <!-- ERROR MESSAGE -->

    <% if (error != null) { %>

        <div class="message error">
            <%= error %>
        </div>

    <% } %>


    <!-- EDIT USER -->

    <% if (editUser != null) { %>

        <div class="card"
             style="border-left: 4px solid var(--primary);">

            <div class="card-header">

                <div>

                    <h2 class="card-title">
                        Edit User Account:
                        <%= editUser.getUsername() %>
                    </h2>

                    <p class="card-subtitle">
                        Update the user's display name and assigned system role.
                    </p>

                </div>

                <a class="btn btn-secondary btn-sm"
                   href="<%= request.getContextPath() %>/users">
                    Cancel Edit
                </a>

            </div>


            <form method="post"
                  action="<%= request.getContextPath() %>/users">

                <input type="hidden"
                       name="action"
                       value="update">

                <input type="hidden"
                       name="id"
                       value="<%= editUser.getId() %>">


                <div class="form-grid">


                    <!-- USERNAME -->

                    <div class="form-group">

                        <label>
                            Username
                        </label>

                        <input
                            type="text"
                            value="<%= editUser.getUsername() %>"
                            disabled
                            style="background: var(--surface-secondary);
                                   cursor: not-allowed;"
                        >

                    </div>


                    <!-- FULL NAME -->

                    <div class="form-group">

                        <label for="editFullName">

                            Full Name

                            <span class="required-indicator">
                                *
                            </span>

                        </label>

                        <input
                            type="text"
                            id="editFullName"
                            name="fullName"
                            value="<%= editUser.getFullName() %>"
                            required
                            maxlength="100"
                        >

                    </div>


                    <!-- ROLE -->

                    <div class="form-group">

                        <label for="editRole">

                            System Role

                            <span class="required-indicator">
                                *
                            </span>

                        </label>


                        <select id="editRole"
                                name="role"
                                required>


                            <option value="RECEPTIONIST"
                                <%= "RECEPTIONIST".equalsIgnoreCase(editUser.getRole())
                                        ? "selected"
                                        : "" %>>

                                RECEPTIONIST (Front Desk)

                            </option>


                            <option value="DENTIST"
                                <%= "DENTIST".equalsIgnoreCase(editUser.getRole())
                                        ? "selected"
                                        : "" %>>

                                DENTIST (Dental Practitioner)

                            </option>


                            <option value="ADMIN"
                                <%= "ADMIN".equalsIgnoreCase(editUser.getRole())
                                        ? "selected"
                                        : "" %>>

                                ADMIN (System Administrator)

                            </option>


                        </select>

                    </div>

                </div>


                <div class="form-actions">

                    <button type="submit"
                            class="btn btn-primary">

                        Save Changes

                    </button>

                    <a class="btn btn-secondary"
                       href="<%= request.getContextPath() %>/users">

                        Cancel

                    </a>

                </div>

            </form>

        </div>

    <% } %>


    <!-- CHANGE PASSWORD -->

    <% if (pwdUser != null) { %>

        <div class="card"
             style="border-left: 4px solid var(--warning);">

            <div class="card-header">

                <div>

                    <h2 class="card-title">

                        Reset Password:
                        <%= pwdUser.getUsername() %>

                    </h2>

                    <p class="card-subtitle">

                        Set a new encrypted password for this user account.

                    </p>

                </div>


                <a class="btn btn-secondary btn-sm"
                   href="<%= request.getContextPath() %>/users">

                    Cancel

                </a>

            </div>


            <form method="post"
                  action="<%= request.getContextPath() %>/users">

                <input type="hidden"
                       name="action"
                       value="changePassword">

                <input type="hidden"
                       name="id"
                       value="<%= pwdUser.getId() %>">


                <div class="form-grid">


                    <!-- NEW PASSWORD -->

                    <div class="form-group">

                        <label for="newPassword">

                            New Password

                            <span class="required-indicator">
                                *
                            </span>

                        </label>

                        <input
                            type="password"
                            id="newPassword"
                            name="newPassword"
                            required
                            minlength="6"
                            placeholder="Minimum 6 characters"
                        >

                    </div>


                    <!-- CONFIRM PASSWORD -->

                    <div class="form-group">

                        <label for="confirmNewPassword">

                            Confirm New Password

                            <span class="required-indicator">
                                *
                            </span>

                        </label>

                        <input
                            type="password"
                            id="confirmNewPassword"
                            name="confirmPassword"
                            required
                            minlength="6"
                            placeholder="Re-enter new password"
                        >

                    </div>

                </div>


                <div class="form-actions">

                    <button type="submit"
                            class="btn btn-primary">

                        Update Password

                    </button>

                    <a class="btn btn-secondary"
                       href="<%= request.getContextPath() %>/users">

                        Cancel

                    </a>

                </div>

            </form>

        </div>

    <% } %>


    <!-- CREATE USER -->

    <div class="card">

        <div class="card-header">

            <div>

                <h2 class="card-title">
                    Create New User Account
                </h2>

                <p class="card-subtitle">
                    Create login credentials and assign a system role
                    for a new clinic employee.
                </p>

            </div>

        </div>


        <form method="post"
              action="<%= request.getContextPath() %>/users">

            <input type="hidden"
                   name="action"
                   value="create">


            <div class="form-grid">


                <!-- USERNAME -->

                <div class="form-group">

                    <label for="username">

                        Username

                        <span class="required-indicator">
                            *
                        </span>

                    </label>

                    <input
                        type="text"
                        id="username"
                        name="username"
                        required
                        minlength="3"
                        maxlength="50"
                        placeholder="e.g. receptionist1"
                        autocomplete="off"
                    >

                </div>


                <!-- FULL NAME -->

                <div class="form-group">

                    <label for="fullName">

                        Full Name

                        <span class="required-indicator">
                            *
                        </span>

                    </label>

                    <input
                        type="text"
                        id="fullName"
                        name="fullName"
                        required
                        maxlength="100"
                        placeholder="e.g. Kasun Fernando"
                    >

                </div>


                <!-- ROLE -->

                <div class="form-group">

                    <label for="role">

                        Assigned Role

                        <span class="required-indicator">
                            *
                        </span>

                    </label>


                    <select id="role"
                            name="role"
                            required>


                        <option value="RECEPTIONIST" selected>

                            RECEPTIONIST (Front Desk / Reception)

                        </option>


                        <option value="DENTIST">

                            DENTIST (Dental Practitioner)

                        </option>


                        <option value="ADMIN">

                            ADMIN (System Administrator)

                        </option>


                    </select>

                </div>


                <!-- PASSWORD -->

                <div class="form-group">

                    <label for="password">

                        Password

                        <span class="required-indicator">
                            *
                        </span>

                    </label>

                    <input
                        type="password"
                        id="password"
                        name="password"
                        required
                        minlength="6"
                        placeholder="Minimum 6 characters"
                        autocomplete="new-password"
                    >

                </div>


                <!-- CONFIRM PASSWORD -->

                <div class="form-group">

                    <label for="confirmPassword">

                        Confirm Password

                        <span class="required-indicator">
                            *
                        </span>

                    </label>

                    <input
                        type="password"
                        id="confirmPassword"
                        name="confirmPassword"
                        required
                        minlength="6"
                        placeholder="Re-enter password"
                        autocomplete="new-password"
                    >

                </div>

            </div>


            <div class="form-actions">

                <button type="submit"
                        class="btn btn-primary">

                    Create User Account

                </button>

            </div>

        </form>

    </div>


    <!-- USER DIRECTORY -->

    <% if (users != null) { %>

        <div class="card">

            <div class="card-header">

                <div>

                    <h2 class="card-title">
                        System User Accounts
                    </h2>

                    <p class="card-subtitle">

                        Directory of all registered accounts,
                        assigned roles, and current statuses.

                    </p>

                </div>

            </div>


            <% if (users.isEmpty()) { %>

                <div class="empty-state">

                    No user accounts found in the database.

                </div>

            <% } else { %>


                <div class="table-container">

                    <table class="app-table">

                        <thead>

                        <tr>

                            <th>Username</th>

                            <th>Full Name</th>

                            <th>Role</th>

                            <th>Status</th>

                            <th>Created Date</th>

                            <th>Actions</th>

                        </tr>

                        </thead>


                        <tbody>


                        <% for (User u : users) {

                            boolean isSelf =
                                    (user != null
                                    && user.getId() != null
                                    && user.getId().equals(u.getId()))

                                    ||

                                    (user != null
                                    && user.getUsername() != null
                                    && user.getUsername()
                                           .equalsIgnoreCase(u.getUsername()));

                        %>


                            <tr>


                                <!-- USERNAME -->

                                <td class="code-highlight">

                                    <%= u.getUsername() %>

                                    <% if (isSelf) { %>

                                        <span
                                            style="font-size: 11px;
                                                   color: var(--primary);
                                                   font-weight: 700;">

                                            (You)

                                        </span>

                                    <% } %>

                                </td>


                                <!-- FULL NAME -->

                                <td style="font-weight: 600;">

                                    <%= u.getFullName() %>

                                </td>


                                <!-- ROLE -->

                                <td>

                                    <span
                                        class="role-badge"
                                        style="display: inline-block;
                                               padding: 3px 8px;
                                               font-size: 11px;">

                                        <%= u.getRole() %>

                                    </span>

                                </td>


                                <!-- STATUS -->

                                <td>

                                    <span
                                        class="status <%= u.isEnabled()
                                                ? "status-ACTIVE"
                                                : "status-INACTIVE" %>">

                                        <%= u.isEnabled()
                                                ? "Active"
                                                : "Inactive" %>

                                    </span>

                                </td>


                                <!-- CREATED DATE -->

                                <td style="color: var(--muted);
                                           font-size: 13px;">

                                    <%= u.getCreatedAt() != null
                                            ? u.getCreatedAt().toLocalDate()
                                            : "-" %>

                                </td>


                                <!-- ACTIONS -->

                                <td>

                                    <div
                                        style="display: flex;
                                               gap: 8px;
                                               align-items: center;
                                               flex-wrap: wrap;">


                                        <!-- EDIT -->

                                        <a
                                            class="action-link"
                                            href="<%= request.getContextPath() %>/users?editId=<%= u.getId() %>">

                                            Edit

                                        </a>


                                        <span style="color: var(--border-light);">
                                            |
                                        </span>


                                        <!-- PASSWORD -->

                                        <a
                                            class="action-link"
                                            href="<%= request.getContextPath() %>/users?pwdId=<%= u.getId() %>">

                                            Password

                                        </a>


                                        <span style="color: var(--border-light);">
                                            |
                                        </span>


                                        <!-- ACTIVE USER -->

                                        <% if (u.isEnabled()) { %>


                                            <% if (isSelf) { %>

                                                <span
                                                    style="color: var(--muted);
                                                           font-size: 12px;"
                                                    title="You cannot deactivate your own account">

                                                    Active

                                                </span>


                                            <% } else { %>


                                                <form
                                                    method="post"
                                                    action="<%= request.getContextPath() %>/users"
                                                    style="display: inline;
                                                           margin: 0;">

                                                    <input
                                                        type="hidden"
                                                        name="action"
                                                        value="deactivate"
                                                    >

                                                    <input
                                                        type="hidden"
                                                        name="id"
                                                        value="<%= u.getId() %>"
                                                    >


                                                    <button
                                                        type="submit"
                                                        class="action-link"
                                                        style="background: none;
                                                               border: none;
                                                               padding: 0;
                                                               color: var(--danger);
                                                               cursor: pointer;
                                                               font-family: inherit;
                                                               font-size: 13px;"
                                                        onclick="return confirm('Are you sure you want to deactivate user <%= u.getUsername() %>?');"
                                                    >

                                                        Deactivate

                                                    </button>

                                                </form>


                                            <% } %>


                                        <!-- INACTIVE USER -->

                                        <% } else { %>


                                            <form
                                                method="post"
                                                action="<%= request.getContextPath() %>/users"
                                                style="display: inline;
                                                       margin: 0;">

                                                <input
                                                    type="hidden"
                                                    name="action"
                                                    value="activate"
                                                >

                                                <input
                                                    type="hidden"
                                                    name="id"
                                                    value="<%= u.getId() %>"
                                                >


                                                <button
                                                    type="submit"
                                                    class="action-link"
                                                    style="background: none;
                                                           border: none;
                                                           padding: 0;
                                                           color: var(--success);
                                                           cursor: pointer;
                                                           font-family: inherit;
                                                           font-size: 13px;"
                                                >

                                                    Activate

                                                </button>

                                            </form>


                                        <% } %>


                                    </div>

                                </td>

                            </tr>


                        <% } %>


                        </tbody>

                    </table>

                </div>


            <% } %>


        </div>

    <% } %>


</main>


<footer class="footer">

    Sunrise Dental Management System
    &bull;
    Professional Dental Care &amp; Clinical Operations

</footer>


</body>

</html>