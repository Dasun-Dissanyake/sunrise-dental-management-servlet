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
                            <span class="status status-ACTIVE">Active</span>
                        </div>
                    </div>
                    <div class="detail-box">
                        <div class="detail-label">Description</div>
                        <div class="detail-value" style="font-weight: 500; font-size: 13px;">
                            <%= searchedTreatment.getDescription() != null ? searchedTreatment.getDescription() : "-" %>
                        </div>
                    </div>
                </div>
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