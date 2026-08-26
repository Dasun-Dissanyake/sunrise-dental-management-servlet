<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="com.sunrisedental.model.User" %>
<%@ page import="java.util.Map" %>

<%
    User user = (User) session.getAttribute("loggedInUser");
    if (user == null) {
        user = (User) request.getAttribute("user");
    }

    String startDate =
            request.getAttribute("startDate") != null
                    ? String.valueOf(request.getAttribute("startDate"))
                    : "";

    String endDate =
            request.getAttribute("endDate") != null
                    ? String.valueOf(request.getAttribute("endDate"))
                    : "";

    Integer totalAppointments =
            (Integer) request.getAttribute("totalAppointments");

    Map<String, Integer> statusReport =
            (Map<String, Integer>)
                    request.getAttribute("statusReport");

    if (totalAppointments == null) {
        totalAppointments = 0;
    }

    int scheduled = 0;
    int completed = 0;
    int cancelled = 0;
    int noShow = 0;

    if (statusReport != null) {
        scheduled = statusReport.getOrDefault("SCHEDULED", 0);
        completed = statusReport.getOrDefault("COMPLETED", 0);
        cancelled = statusReport.getOrDefault("CANCELLED", 0);
        noShow = statusReport.getOrDefault("NO_SHOW", 0);
    }
%>

<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Appointment Report - Sunrise Dental</title>
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
        <a class="nav-link" href="<%= request.getContextPath() %>/treatments">Treatments</a>
        <a class="nav-link" href="<%= request.getContextPath() %>/bills">Billing</a>
        <a class="nav-link active" href="<%= request.getContextPath() %>/reports">Reports</a>
        <a class="nav-link" href="<%= request.getContextPath() %>/help">Help</a>
    </div>
</nav>

<main class="container">

    <div class="page-header">
        <div class="page-header-text">
            <h1>Appointment Report</h1>
            <p>View appointment statistics for a selected date range.</p>
        </div>
        <div class="page-header-actions">
            <a class="btn btn-secondary" href="<%= request.getContextPath() %>/reports">
                &larr; Main Reports
            </a>
            <a class="back-link" href="<%= request.getContextPath() %>/dashboard">
                &larr; Back to Dashboard
            </a>
        </div>
    </div>

    <!-- DATE FILTER -->
    <div class="filter-card">
        <div class="card-header">
            <div>
                <h2 class="card-title">Filter Date Range</h2>
                <p class="card-subtitle">Select date range to view appointment status distributions.</p>
            </div>
        </div>

        <form class="filter-form" method="get" action="<%= request.getContextPath() %>/reports/appointments">
            <div class="form-group">
                <label for="startDate">Start Date <span class="required-indicator">*</span></label>
                <input
                    type="date"
                    id="startDate"
                    name="startDate"
                    value="<%= !"null".equals(startDate) ? startDate : "" %>"
                    required
                >
            </div>

            <div class="form-group">
                <label for="endDate">End Date <span class="required-indicator">*</span></label>
                <input
                    type="date"
                    id="endDate"
                    name="endDate"
                    value="<%= !"null".equals(endDate) ? endDate : "" %>"
                    required
                >
            </div>

            <button type="submit" class="btn btn-primary">
                Generate Report
            </button>

            <button type="button" class="btn btn-secondary" onclick="window.print()">
                Print Report
            </button>
        </form>
    </div>

    <!-- SUMMARY -->
    <div class="summary-grid" style="grid-template-columns: repeat(auto-fit, minmax(240px, 1fr));">
        <div class="summary-card" style="border-top-color: var(--primary);">
            <div class="summary-label">Total Appointments</div>
            <div class="summary-value" style="font-size: 32px; color: var(--dark);">
                <%= totalAppointments %>
            </div>
        </div>
    </div>

    <!-- REPORT TABLE -->
    <div class="card">
        <div class="card-header">
            <div>
                <h2 class="card-title">Appointment Status</h2>
                <p class="card-subtitle">Categorization of appointments during the selected period.</p>
            </div>
        </div>

        <div class="table-container">
            <table class="app-table">
                <thead>
                <tr>
                    <th>Status</th>
                    <th>Number of Appointments</th>
                </tr>
                </thead>
                <tbody>
                <tr>
                    <td>
                        <span class="status status-SCHEDULED">Scheduled</span>
                    </td>
                    <td style="font-weight: 700; font-size: 15px;">
                        <%= scheduled %>
                    </td>
                </tr>
                <tr>
                    <td>
                        <span class="status status-COMPLETED">Completed</span>
                    </td>
                    <td style="font-weight: 700; font-size: 15px;">
                        <%= completed %>
                    </td>
                </tr>
                <tr>
                    <td>
                        <span class="status status-CANCELLED">Cancelled</span>
                    </td>
                    <td style="font-weight: 700; font-size: 15px;">
                        <%= cancelled %>
                    </td>
                </tr>
                <tr>
                    <td>
                        <span class="status status-NO_SHOW">No Show</span>
                    </td>
                    <td style="font-weight: 700; font-size: 15px;">
                        <%= noShow %>
                    </td>
                </tr>
                </tbody>
            </table>
        </div>
    </div>

</main>

<footer class="footer">
    Sunrise Dental Management System &bull; Professional Dental Care &amp; Clinical Operations
</footer>

</body>
</html>