<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="java.util.List" %>
<%@ page import="com.sunrisedental.model.Dentist" %>
<%@ page import="com.sunrisedental.model.User" %>

<%
    User user = (User) session.getAttribute("loggedInUser");
    if (user == null) {
        user = (User) request.getAttribute("user");
    }

    List<Dentist> dentists = (List<Dentist>) request.getAttribute("dentists");
    Dentist searchedDentist = (Dentist) request.getAttribute("searchedDentist");
    String error = (String) request.getAttribute("error");
    String success = request.getParameter("success");
%>

<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Dentists - Sunrise Dental</title>
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/sunrise-theme.css">
</head>

<body>

<header class="header">
    <div class="header-inner">
        <a class="brand" href="<%= request.getContextPath() %>/dashboard">
            <img
                src="<%= request.getContextPath() %>/assets/images/sunrise-dental-logo.png"
                alt="Sunrise Dental Logo"
                class="brand-logo"
            >
            <div>
                <div class="brand-name">Sunrise Dental</div>
                <div class="brand-subtitle">Management System</div>
            </div>
        </a>

        <div class="user-section">
            <div class="user-info">
                <div class="user-name"><%= user != null ? user.getFullName() : "User" %></div>
                <div class="user-role"><%= user != null ? user.getRole() : "" %></div>
            </div>
            <a class="logout" href="<%= request.getContextPath() %>/logout">Logout</a>
        </div>
    </div>
</header>

<nav class="nav-bar">
    <div class="nav-inner">
        <a class="nav-link" href="<%= request.getContextPath() %>/dashboard">Dashboard</a>
        <a class="nav-link" href="<%= request.getContextPath() %>/appointments">Appointments</a>
        <a class="nav-link" href="<%= request.getContextPath() %>/patients">Patients</a>
        <a class="nav-link active" href="<%= request.getContextPath() %>/dentists">Dentists</a>
        <a class="nav-link" href="<%= request.getContextPath() %>/treatments">Treatments</a>
        <a class="nav-link" href="<%= request.getContextPath() %>/bills">Billing</a>
        <a class="nav-link" href="<%= request.getContextPath() %>/reports">Reports</a>
    </div>
</nav>

<main class="container">

    <div class="page-header">
        <div class="page-header-text">
            <h1>Dentists</h1>
            <p>Manage dentist profiles and availability.</p>
        </div>
        <div class="page-header-actions">
            <a class="back-link" href="<%= request.getContextPath() %>/dashboard">
                &larr; Back to Dashboard
            </a>
        </div>
    </div>

    <% if (error != null) { %>
        <div class="message error">
            <%= error %>
        </div>
    <% } %>

    <% if ("registered".equals(success)) { %>
        <div class="message success">
            Dentist registered successfully.
        </div>
    <% } else if ("updated".equals(success)) { %>
        <div class="message success">
            Dentist updated successfully.
        </div>
    <% } else if ("deactivated".equals(success)) { %>
        <div class="message success">
            Dentist deactivated successfully.
        </div>
    <% } %>

    <!-- REGISTER DENTIST -->
    <div class="card">
        <div class="card-header">
            <div>
                <h2 class="card-title">Register New Dentist</h2>
                <p class="card-subtitle">Add a licensed practitioner to the clinic schedule and practitioner roster.</p>
            </div>
        </div>

        <form method="post" action="<%= request.getContextPath() %>/dentists">
            <div class="form-grid">
                <div class="form-group">
                    <label for="dentistNumber">Dentist Number <span class="required-indicator">*</span></label>
                    <input
                        type="text"
                        id="dentistNumber"
                        name="dentistNumber"
                        required
                        maxlength="20"
                        placeholder="e.g. DEN-001"
                    >
                </div>

                <div class="form-group">
                    <label for="fullName">Full Name <span class="required-indicator">*</span></label>
                    <input
                        type="text"
                        id="fullName"
                        name="fullName"
                        required
                        maxlength="100"
                        placeholder="e.g. Dr. Jane Smith"
                    >
                </div>

                <div class="form-group">
                    <label for="specialization">Specialization <span class="required-indicator">*</span></label>
                    <input
                        type="text"
                        id="specialization"
                        name="specialization"
                        required
                        maxlength="100"
                        placeholder="e.g. Orthodontics, Periodontics"
                    >
                </div>

                <div class="form-group">
                    <label for="contactNumber">Contact Number <span class="required-indicator">*</span></label>
                    <input
                        type="tel"
                        id="contactNumber"
                        name="contactNumber"
                        required
                        maxlength="20"
                        placeholder="e.g. 0771234567"
                    >
                </div>
            </div>

            <div class="form-actions">
                <button type="submit" class="btn btn-primary">Register Dentist</button>
            </div>
        </form>
    </div>

    <!-- SEARCH DENTIST -->
    <div class="card">
        <div class="card-header">
            <div>
                <h2 class="card-title">Search Dentist</h2>
                <p class="card-subtitle">Search registered dentists by dentist number to view credentials or update profile.</p>
            </div>
        </div>

        <form class="search-form" method="get" action="<%= request.getContextPath() %>/dentists">
            <input
                type="text"
                name="dentistNumber"
                placeholder="Enter dentist number (e.g. DEN-001)"
                required
            >
            <button type="submit" class="btn btn-dark">Search Dentist</button>
        </form>

        <% if (searchedDentist != null) { %>
            <div style="margin-top: 24px;">
                <div class="details-grid">
                    <div class="detail-box">
                        <div class="detail-label">Dentist Number</div>
                        <div class="detail-value"><%= searchedDentist.getDentistNumber() %></div>
                    </div>
                    <div class="detail-box">
                        <div class="detail-label">Doctor Name</div>
                        <div class="detail-value"><%= searchedDentist.getFullName() %></div>
                    </div>
                    <div class="detail-box">
                        <div class="detail-label">Specialization</div>
                        <div class="detail-value"><%= searchedDentist.getSpecialization() %></div>
                    </div>
                    <div class="detail-box">
                        <div class="detail-label">Contact Number</div>
                        <div class="detail-value"><%= searchedDentist.getContactNumber() %></div>
                    </div>
                    <div class="detail-box">
                        <div class="detail-label">Status</div>
                        <div class="detail-value">
                            <span class="status <%= searchedDentist.isActive() ? "status-ACTIVE" : "status-INACTIVE" %>">
                                <%= searchedDentist.isActive() ? "Active" : "Inactive" %>
                            </span>
                        </div>
                    </div>
                </div>

                <!-- UPDATE DENTIST FORM -->
                <div class="edit-section">
                    <h3>Update Dentist Profile</h3>
                    <form method="post" action="<%= request.getContextPath() %>/dentists">
                        <input type="hidden" name="action" value="update">
                        <input type="hidden" name="id" value="<%= searchedDentist.getId() %>">

                        <div class="form-grid">
                            <div class="form-group">
                                <label for="editFullName">Full Name <span class="required-indicator">*</span></label>
                                <input
                                    type="text"
                                    id="editFullName"
                                    name="fullName"
                                    value="<%= searchedDentist.getFullName() %>"
                                    required
                                    maxlength="100"
                                >
                            </div>

                            <div class="form-group">
                                <label for="editSpecialization">Specialization <span class="required-indicator">*</span></label>
                                <input
                                    type="text"
                                    id="editSpecialization"
                                    name="specialization"
                                    value="<%= searchedDentist.getSpecialization() %>"
                                    required
                                    maxlength="100"
                                >
                            </div>

                            <div class="form-group">
                                <label for="editContactNumber">Contact Number <span class="required-indicator">*</span></label>
                                <input
                                    type="tel"
                                    id="editContactNumber"
                                    name="contactNumber"
                                    value="<%= searchedDentist.getContactNumber() %>"
                                    required
                                    maxlength="20"
                                >
                            </div>
                        </div>

                        <div class="form-actions">
                            <button type="submit" class="btn btn-primary">Update Dentist</button>
                        </div>
                    </form>
                </div>

                <!-- DEACTIVATE DENTIST -->
                <% if (searchedDentist.isActive()) { %>
                    <div class="edit-section">
                        <h3>Deactivate Dentist</h3>
                        <p style="color: var(--muted); font-size: 13px; margin-bottom: 14px;">
                            Deactivating will mark the practitioner as inactive in the system.
                        </p>
                        <form method="post" action="<%= request.getContextPath() %>/dentists">
                            <input type="hidden" name="action" value="deactivate">
                            <input type="hidden" name="id" value="<%= searchedDentist.getId() %>">
                            <button type="submit" class="btn btn-danger">Deactivate Dentist</button>
                        </form>
                    </div>
                <% } %>
            </div>
        <% } else if (request.getParameter("dentistNumber") != null) { %>
            <div class="message error" style="margin-top: 20px; margin-bottom: 0;">
                No dentist found with that dentist number.
            </div>
        <% } %>
    </div>

    <!-- ACTIVE DENTISTS TABLE -->
    <% if (dentists != null) { %>
        <div class="card">
            <div class="card-header">
                <div>
                    <h2 class="card-title">Active Practicing Dentists</h2>
                    <p class="card-subtitle">List of dental professionals currently available for appointments.</p>
                </div>
            </div>

            <% if (dentists.isEmpty()) { %>
                <div class="empty-state">
                    No active dentists found in the clinic directory.
                </div>
            <% } else { %>
                <div class="table-container">
                    <table class="app-table">
                        <thead>
                        <tr>
                            <th>Dentist #</th>
                            <th>Doctor Name</th>
                            <th>Specialization</th>
                            <th>Contact</th>
                            <th>Status</th>
                            <th>Actions</th>
                        </tr>
                        </thead>
                        <tbody>
                        <% for (Dentist d : dentists) { %>
                            <tr>
                                <td class="code-highlight"><%= d.getDentistNumber() %></td>
                                <td style="font-weight: 600;"><%= d.getFullName() %></td>
                                <td><%= d.getSpecialization() %></td>
                                <td><%= d.getContactNumber() %></td>
                                <td>
                                    <span class="status <%= d.isActive() ? "status-ACTIVE" : "status-INACTIVE" %>">
                                        <%= d.isActive() ? "Active" : "Inactive" %>
                                    </span>
                                </td>
                                <td>
                                    <a class="action-link" href="<%= request.getContextPath() %>/dentists?dentistNumber=<%= d.getDentistNumber() %>">
                                        View / Edit
                                    </a>
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
    Sunrise Dental Management System &bull; Professional Dental Care &amp; Clinical Operations
</footer>

</body>
</html>