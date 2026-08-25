<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="com.sunrisedental.model.User" %>
<%@ page import="com.sunrisedental.model.TreatmentReport" %>
<%@ page import="com.sunrisedental.model.DentistReport" %>
<%@ page import="com.sunrisedental.model.PatientReport" %>
<%@ page import="java.util.List" %>

<%
    User user = (User) session.getAttribute("loggedInUser");
    if (user == null) {
        user = (User) request.getAttribute("user");
    }

    String startDate =
            request.getAttribute("startDate") != null
                    ? request.getAttribute("startDate").toString()
                    : "";

    String endDate =
            request.getAttribute("endDate") != null
                    ? request.getAttribute("endDate").toString()
                    : "";

    Double totalRevenue =
            (Double) request.getAttribute("totalRevenue");

    Double totalConsultationFees =
            (Double) request.getAttribute("totalConsultationFees");

    Double totalTreatmentRevenue =
            (Double) request.getAttribute("totalTreatmentRevenue");

    Integer totalBills =
            (Integer) request.getAttribute("totalBills");

    Double averageBillAmount =
            (Double) request.getAttribute("averageBillAmount");

    List<TreatmentReport> treatmentReports =
            (List<TreatmentReport>) request.getAttribute("treatmentReports");

    List<DentistReport> dentistReports =
            (List<DentistReport>) request.getAttribute("dentistReports");

    List<PatientReport> patientReports =
            (List<PatientReport>) request.getAttribute("patientReports");

    String error =
            (String) request.getAttribute("error");

    if (totalRevenue == null) {
        totalRevenue = 0.0;
    }

    if (totalConsultationFees == null) {
        totalConsultationFees = 0.0;
    }

    if (totalTreatmentRevenue == null) {
        totalTreatmentRevenue = 0.0;
    }

    if (totalBills == null) {
        totalBills = 0;
    }

    if (averageBillAmount == null) {
        averageBillAmount = 0.0;
    }
%>

<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Reports - Sunrise Dental</title>
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
    </div>
</nav>

<main class="container">

    <div class="page-header">
        <div class="page-header-text">
            <h1>Reports</h1>
            <p>View financial, treatment, dentist and patient reports.</p>
        </div>
        <div class="page-header-actions">
            <a class="btn btn-secondary" href="<%= request.getContextPath() %>/reports/appointments">
                Appointment Status Report &rarr;
            </a>
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

    <!-- DATE FILTER -->
    <div class="filter-card">
        <div class="card-header">
            <div>
                <h2 class="card-title">Report Date Range</h2>
                <p class="card-subtitle">Select date range to filter financial and performance records.</p>
            </div>
        </div>

        <form class="filter-form" method="get" action="<%= request.getContextPath() %>/reports">
            <div class="form-group">
                <label for="startDate">Start Date <span class="required-indicator">*</span></label>
                <input
                    type="date"
                    id="startDate"
                    name="startDate"
                    value="<%= startDate %>"
                    required
                >
            </div>

            <div class="form-group">
                <label for="endDate">End Date <span class="required-indicator">*</span></label>
                <input
                    type="date"
                    id="endDate"
                    name="endDate"
                    value="<%= endDate %>"
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

    <!-- REVENUE SUMMARY -->
    <section style="margin-bottom: 32px;">
        <div class="section-heading">
            <div>
                <h2>Revenue Summary</h2>
                <p>Overall financial breakdown of clinical revenues and billing metrics.</p>
            </div>
        </div>

        <div class="summary-grid">
            <div class="summary-card" style="border-top-color: var(--primary);">
                <div class="summary-label">Total Revenue</div>
                <div class="summary-value revenue">
                    Rs. <%= String.format("%,.2f", totalRevenue) %>
                </div>
            </div>

            <div class="summary-card">
                <div class="summary-label">Consultation Fees</div>
                <div class="summary-value">
                    Rs. <%= String.format("%,.2f", totalConsultationFees) %>
                </div>
            </div>

            <div class="summary-card">
                <div class="summary-label">Treatment Revenue</div>
                <div class="summary-value">
                    Rs. <%= String.format("%,.2f", totalTreatmentRevenue) %>
                </div>
            </div>

            <div class="summary-card">
                <div class="summary-label">Total Invoices</div>
                <div class="summary-value">
                    <%= totalBills %>
                </div>
            </div>

            <div class="summary-card">
                <div class="summary-label">Average Bill</div>
                <div class="summary-value">
                    Rs. <%= String.format("%,.2f", averageBillAmount) %>
                </div>
            </div>
        </div>
    </section>

    <!-- TREATMENT REPORT -->
    <div class="card">
        <div class="card-header">
            <div>
                <h2 class="card-title">Treatment Performance</h2>
                <p class="card-subtitle">Appointment volumes and revenue generated per treatment type.</p>
            </div>
        </div>

        <% if (treatmentReports != null && !treatmentReports.isEmpty()) { %>
            <div class="table-container">
                <table class="app-table">
                    <thead>
                    <tr>
                        <th>Treatment</th>
                        <th>Appointments</th>
                        <th>Revenue</th>
                    </tr>
                    </thead>
                    <tbody>
                    <% for (TreatmentReport report : treatmentReports) { %>
                        <tr>
                            <td style="font-weight: 600;">
                                <%= report.getTreatmentName() %>
                            </td>
                            <td>
                                <%= report.getAppointmentCount() %>
                            </td>
                            <td class="price" style="color: var(--primary-dark);">
                                Rs. <%= String.format("%,.2f", report.getRevenue()) %>
                            </td>
                        </tr>
                    <% } %>
                    </tbody>
                </table>
            </div>
        <% } else { %>
            <div class="empty-state">
                No treatment data available for this date range.
            </div>
        <% } %>
    </div>

    <!-- DENTIST REPORT -->
    <div class="card">
        <div class="card-header">
            <div>
                <h2 class="card-title">Dentist Performance</h2>
                <p class="card-subtitle">Consultation volume, completed appointments, cancellations and no-shows per doctor.</p>
            </div>
        </div>

        <% if (dentistReports != null && !dentistReports.isEmpty()) { %>
            <div class="table-container">
                <table class="app-table">
                    <thead>
                    <tr>
                        <th>Dentist</th>
                        <th>Total Appointments</th>
                        <th>Completed</th>
                        <th>Cancelled</th>
                        <th>No Show</th>
                    </tr>
                    </thead>
                    <tbody>
                    <% for (DentistReport report : dentistReports) { %>
                        <tr>
                            <td style="font-weight: 600;">
                                <%= report.getDentistName() %>
                            </td>
                            <td>
                                <strong><%= report.getTotalAppointments() %></strong>
                            </td>
                            <td>
                                <span class="status status-COMPLETED"><%= report.getCompletedAppointments() %></span>
                            </td>
                            <td>
                                <span class="status status-CANCELLED"><%= report.getCancelledAppointments() %></span>
                            </td>
                            <td>
                                <span class="status status-NO_SHOW"><%= report.getNoShowAppointments() %></span>
                            </td>
                        </tr>
                    <% } %>
                    </tbody>
                </table>
            </div>
        <% } else { %>
            <div class="empty-state">
                No dentist data available for this date range.
            </div>
        <% } %>
    </div>

    <!-- PATIENT REPORT -->
    <div class="card">
        <div class="card-header">
            <div>
                <h2 class="card-title">Patient Activity</h2>
                <p class="card-subtitle">Patient booking statistics and date of last visit.</p>
            </div>
        </div>

        <% if (patientReports != null && !patientReports.isEmpty()) { %>
            <div class="table-container">
                <table class="app-table">
                    <thead>
                    <tr>
                        <th>Patient</th>
                        <th>Total Appointments</th>
                        <th>Completed</th>
                        <th>Last Appointment</th>
                    </tr>
                    </thead>
                    <tbody>
                    <% for (PatientReport report : patientReports) { %>
                        <tr>
                            <td style="font-weight: 600;">
                                <%= report.getPatientName() %>
                            </td>
                            <td>
                                <%= report.getTotalAppointments() %>
                            </td>
                            <td>
                                <span class="status status-COMPLETED"><%= report.getCompletedAppointments() %></span>
                            </td>
                            <td>
                                <%= report.getLastAppointment() != null ? report.getLastAppointment() : "-" %>
                            </td>
                        </tr>
                    <% } %>
                    </tbody>
                </table>
            </div>
        <% } else { %>
            <div class="empty-state">
                No patient data available for this date range.
            </div>
        <% } %>
    </div>

</main>

<footer class="footer">
    Sunrise Dental Management System &bull; Professional Dental Care &amp; Clinical Operations
</footer>

</body>
</html>