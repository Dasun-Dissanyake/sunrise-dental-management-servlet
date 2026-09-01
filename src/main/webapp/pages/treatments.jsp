<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="java.util.List" %>
<%@ page import="com.sunrisedental.model.Treatment" %>
<%@ page import="com.sunrisedental.model.User" %>

<%
    User user = (User) session.getAttribute("loggedInUser");
    if (user == null) {
        user = (User) request.getAttribute("user");
    }

    List<Treatment> treatments =
            (List<Treatment>) request.getAttribute("treatments");

    Treatment searchedTreatment =
            (Treatment) request.getAttribute("searchedTreatment");

    String error = (String) request.getAttribute("error");
    String success = request.getParameter("success");
%>

<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Treatments - Sunrise Dental</title>
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
        <a class="nav-link" href="<%= request.getContextPath() %>/dentists">Dentists</a>
        <a class="nav-link active" href="<%= request.getContextPath() %>/treatments">Treatments</a>
        <a class="nav-link" href="<%= request.getContextPath() %>/bills">Billing</a>
        <a class="nav-link" href="<%= request.getContextPath() %>/reports">Reports</a>
        <a class="nav-link" href="<%= request.getContextPath() %>/help">Help</a>
        <% if (user != null && "ADMIN".equalsIgnoreCase(user.getRole())) { %>
            <a class="nav-link" href="<%= request.getContextPath() %>/users">User Management</a>
        <% } %>
    </div>
</nav>

<main class="container">

    <div class="page-header">
        <div class="page-header-text">
            <h1>Treatments</h1>
            <p>Manage available dental treatments and pricing.</p>
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

    <% if ("registered".equals(success) || "added".equals(success)) { %>
        <div class="message success">
            Treatment added successfully.
        </div>
    <% } else if ("deactivated".equals(success)) { %>
        <div class="message success">
            Treatment deactivated successfully.
        </div>
    <% } %>

    <!-- ADD NEW TREATMENT -->
    <div class="card">
        <div class="card-header">
            <div>
                <h2 class="card-title">Add New Treatment</h2>
                <p class="card-subtitle">Create a new dental procedure with procedural pricing and consultation fee.</p>
            </div>
        </div>

        <form method="post" action="<%= request.getContextPath() %>/treatments">
            <input type="hidden" name="action" value="add">
            <div class="form-grid">
                <div class="form-group">
                    <label for="treatmentCode">Treatment Code <span class="required-indicator">*</span></label>
                    <input
                        type="text"
                        id="treatmentCode"
                        name="treatmentCode"
                        required
                        maxlength="50"
                        placeholder="e.g. TRT-001"
                    >
                </div>

                <div class="form-group">
                    <label for="treatmentName">Treatment Name <span class="required-indicator">*</span></label>
                    <input
                        type="text"
                        id="treatmentName"
                        name="treatmentName"
                        required
                        maxlength="100"
                        placeholder="e.g. Root Canal Treatment"
                    >
                </div>

                <div class="form-group">
                    <label for="treatmentCost">Treatment Cost (Rs.) <span class="required-indicator">*</span></label>
                    <input
                        type="number"
                        id="treatmentCost"
                        name="treatmentCost"
                        required
                        step="0.01"
                        min="0"
                        placeholder="e.g. 15000.00"
                    >
                </div>

                <div class="form-group">
                    <label for="consultationFee">Consultation Fee (Rs.) <span class="required-indicator">*</span></label>
                    <input
                        type="number"
                        id="consultationFee"
                        name="consultationFee"
                        required
                        step="0.01"
                        min="0"
                        placeholder="e.g. 2000.00"
                    >
                </div>

                <div class="form-group full" style="grid-column: 1 / -1;">
                    <label for="description">Description</label>
                    <input
                        type="text"
                        id="description"
                        name="description"
                        maxlength="500"
                        placeholder="Optional description of clinical procedure"
                    >
                </div>
            </div>

            <div class="form-actions">
                <button type="submit" class="btn btn-primary">Add Treatment</button>
            </div>
        </form>
    </div>

    <!-- SEARCH TREATMENT -->
    <div class="card">
        <div class="card-header">
            <div>
                <h2 class="card-title">Search Treatment</h2>
                <p class="card-subtitle">Search by treatment code to lookup procedural pricing and fee schedules.</p>
            </div>
        </div>

        <form class="search-form" method="get" action="<%= request.getContextPath() %>/treatments">
            <input
                type="text"
                name="treatmentCode"
                placeholder="Enter treatment code (e.g. TRT-001)"
                required
            >
            <button type="submit" class="btn btn-dark">Search Treatment</button>
        </form>

        <% if (searchedTreatment != null) { %>
            <div style="margin-top: 24px;">
                <div class="details-grid">
                    <div class="detail-box">
                        <div class="detail-label">Treatment Code</div>
                        <div class="detail-value"><%= searchedTreatment.getTreatmentCode() %></div>
                    </div>
                    <div class="detail-box">
                        <div class="detail-label">Treatment Name</div>
                        <div class="detail-value"><%= searchedTreatment.getTreatmentName() %></div>
                    </div>
                    <div class="detail-box">
                        <div class="detail-label">Treatment Cost</div>
                        <div class="detail-value" style="color: var(--primary-dark);">
                            Rs. <%= String.format("%,.2f", searchedTreatment.getTreatmentCost()) %>
                        </div>
                    </div>
                    <div class="detail-box">
                        <div class="detail-label">Consultation Fee</div>
                        <div class="detail-value">
                            Rs. <%= String.format("%,.2f", searchedTreatment.getConsultationFee()) %>
                        </div>
                    </div>
                    <div class="detail-box">
                        <div class="detail-label">Status</div>
                        <div class="detail-value">
                            <span class="status <%= searchedTreatment.isActive() ? "status-ACTIVE" : "status-INACTIVE" %>">
                                <%= searchedTreatment.isActive() ? "Active" : "Inactive" %>
                            </span>
                        </div>
                    </div>
                    <div class="detail-box">
                        <div class="detail-label">Description</div>
                        <div class="detail-value" style="font-weight: 500; font-size: 13px;">
                            <%= searchedTreatment.getDescription() != null ? searchedTreatment.getDescription() : "-" %>
                        </div>
                    </div>
                </div>

                <% if (searchedTreatment.isActive()) { %>
                    <div class="edit-section">
                        <h3>Deactivate Treatment</h3>
                        <p style="color: var(--muted); font-size: 13px; margin-bottom: 14px;">
                            Deactivating will mark this treatment as inactive and remove it from appointment booking.
                        </p>
                        <form method="post" action="<%= request.getContextPath() %>/treatments" onsubmit="return confirm('Are you sure you want to deactivate this treatment?');">
                            <input type="hidden" name="action" value="deactivate">
                            <input type="hidden" name="id" value="<%= searchedTreatment.getId() %>">
                            <button type="submit" class="btn btn-danger">Deactivate Treatment</button>
                        </form>
                    </div>
                <% } %>
            </div>
        <% } else if (request.getParameter("treatmentCode") != null) { %>
            <div class="message error" style="margin-top: 20px; margin-bottom: 0;">
                No active treatment found with that treatment code.
            </div>
        <% } %>
    </div>

    <!-- ACTIVE TREATMENTS -->
    <% if (treatments != null) { %>
        <div class="card">
            <div class="card-header">
                <div>
                    <h2 class="card-title">Available Dental Treatments</h2>
                    <p class="card-subtitle">Complete schedule of active clinical treatments and service fees.</p>
                </div>
            </div>

            <% if (treatments.isEmpty()) { %>
                <div class="empty-state">
                    No active treatments available in the system.
                </div>
            <% } else { %>
                <div class="table-container">
                    <table class="app-table">
                        <thead>
                        <tr>
                            <th>Code</th>
                            <th>Treatment</th>
                            <th>Description</th>
                            <th>Treatment Cost</th>
                            <th>Consultation Fee</th>
                            <th>Status</th>
                            <th>Actions</th>
                        </tr>
                        </thead>
                        <tbody>
                        <% for (Treatment treatment : treatments) { %>
                            <tr>
                                <td class="code-highlight">
                                    <%= treatment.getTreatmentCode() %>
                                </td>
                                <td style="font-weight: 600;">
                                    <%= treatment.getTreatmentName() %>
                                </td>
                                <td style="color: var(--muted); max-width: 320px; white-space: normal;">
                                    <%= treatment.getDescription() != null ? treatment.getDescription() : "-" %>
                                </td>
                                <td class="price" style="color: var(--primary-dark);">
                                    Rs. <%= String.format("%,.2f", treatment.getTreatmentCost()) %>
                                </td>
                                <td class="price">
                                    Rs. <%= String.format("%,.2f", treatment.getConsultationFee()) %>
                                </td>
                                <td>
                                    <span class="status status-ACTIVE">
                                        Active
                                    </span>
                                </td>
                                <td>
                                    <div style="display: flex; gap: 8px; align-items: center;">
                                        <a class="action-link" href="<%= request.getContextPath() %>/treatments?treatmentCode=<%= treatment.getTreatmentCode() %>">
                                            View
                                        </a>
                                        <form method="post" action="<%= request.getContextPath() %>/treatments" style="display: inline;" onsubmit="return confirm('Are you sure you want to deactivate this treatment?');">
                                            <input type="hidden" name="action" value="deactivate">
                                            <input type="hidden" name="id" value="<%= treatment.getId() %>">
                                            <button type="submit" class="btn btn-danger btn-sm" style="padding: 4px 10px; font-size: 12px; cursor: pointer;">Deactivate</button>
                                        </form>
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
    Sunrise Dental Management System &bull; Professional Dental Care &amp; Clinical Operations
</footer>

</body>
</html>