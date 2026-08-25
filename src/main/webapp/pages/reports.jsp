<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="com.sunrisedental.model.User" %>
<%@ page import="com.sunrisedental.model.TreatmentReport" %>
<%@ page import="com.sunrisedental.model.DentistReport" %>
<%@ page import="com.sunrisedental.model.PatientReport" %>
<%@ page import="java.util.List" %>

<%
    User user = (User) request.getAttribute("user");

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

    <meta name="viewport"
          content="width=device-width, initial-scale=1.0">

    <title>Reports - Sunrise Dental</title>

    <style>

        * {
            box-sizing: border-box;
            margin: 0;
            padding: 0;
        }

        body {
            font-family: Arial, sans-serif;
            background: #f5f7fb;
            color: #333;
        }

        .header {
            background: #ffffff;
            height: 70px;
            display: flex;
            align-items: center;
            justify-content: space-between;
            padding: 0 30px;
            border-bottom: 1px solid #ddd;
        }

        .logo {
            font-size: 22px;
            font-weight: bold;
        }

        .user-section {
            display: flex;
            align-items: center;
            gap: 15px;
        }

        .logout {
            text-decoration: none;
            padding: 8px 15px;
            border: 1px solid #ddd;
            border-radius: 6px;
            color: #333;
            background: #fff;
        }

        .logout:hover {
            background: #f5f5f5;
        }

        .container {
            padding: 30px;
            max-width: 1400px;
            margin: auto;
        }

        .page-header {
            margin-bottom: 25px;
        }

        .page-header h1 {
            margin-bottom: 8px;
        }

        .page-header p {
            color: #6b7280;
        }

        .back-link {
            display: inline-block;
            margin-bottom: 20px;
            text-decoration: none;
            color: #2563eb;
        }

        .filter-card {
            background: white;
            padding: 25px;
            border-radius: 10px;
            border: 1px solid #e5e5e5;
            margin-bottom: 25px;
        }

        .filter-card h2 {
            margin-bottom: 20px;
            font-size: 20px;
        }

        .filter-form {
            display: flex;
            align-items: end;
            gap: 20px;
            flex-wrap: wrap;
        }

        .form-group {
            display: flex;
            flex-direction: column;
            gap: 7px;
        }

        .form-group label {
            font-size: 14px;
            font-weight: bold;
        }

        .form-group input {
            padding: 10px 12px;
            border: 1px solid #d1d5db;
            border-radius: 6px;
            font-size: 14px;
        }

        .btn {
            padding: 10px 18px;
            border-radius: 6px;
            border: none;
            cursor: pointer;
            font-size: 14px;
        }

        .btn-primary {
            background: #2563eb;
            color: white;
        }

        .btn-primary:hover {
            background: #1d4ed8;
        }

        .btn-secondary {
            background: #ffffff;
            color: #333;
            border: 1px solid #d1d5db;
        }

        .btn-secondary:hover {
            background: #f5f5f5;
        }

        .error {
            background: #fee2e2;
            color: #991b1b;
            border: 1px solid #fecaca;
            padding: 12px 15px;
            border-radius: 6px;
            margin-bottom: 20px;
        }

        .section {
            margin-bottom: 30px;
        }

        .section h2 {
            margin-bottom: 15px;
            font-size: 21px;
        }

        .summary-grid {
            display: grid;
            grid-template-columns: repeat(
                auto-fit,
                minmax(200px, 1fr)
            );
            gap: 20px;
        }

        .summary-card {
            background: white;
            padding: 22px;
            border-radius: 10px;
            border: 1px solid #e5e5e5;
        }

        .summary-label {
            color: #6b7280;
            font-size: 14px;
            margin-bottom: 10px;
        }

        .summary-value {
            font-size: 25px;
            font-weight: bold;
            color: #111827;
        }

        .revenue {
            color: #166534;
        }

        .table-card {
            background: white;
            border-radius: 10px;
            border: 1px solid #e5e5e5;
            overflow-x: auto;
        }

        table {
            width: 100%;
            border-collapse: collapse;
        }

        th,
        td {
            padding: 14px 15px;
            text-align: left;
            border-bottom: 1px solid #e5e7eb;
        }

        th {
            background: #f9fafb;
            color: #6b7280;
            font-size: 13px;
        }

        td {
            font-size: 14px;
        }

        tbody tr:last-child td {
            border-bottom: none;
        }

        .empty {
            text-align: center;
            padding: 30px;
            color: #6b7280;
        }

        .print-section {
            display: flex;
            justify-content: flex-end;
            margin-bottom: 20px;
        }

        @media print {

            body {
                background: white;
            }

            .header,
            .filter-card,
            .back-link,
            .print-section {
                display: none;
            }

            .container {
                padding: 0;
                max-width: none;
            }

            .summary-card,
            .table-card {
                border: 1px solid #ccc;
            }

            .section {
                page-break-inside: avoid;
            }
        }

        @media (max-width: 700px) {

            .header {
                padding: 0 15px;
            }

            .container {
                padding: 20px 15px;
            }

            .filter-form {
                flex-direction: column;
                align-items: stretch;
            }

            .form-group input {
                width: 100%;
            }

            .btn {
                width: 100%;
            }
        }

    </style>

</head>

<body>

<header class="header">

    <div class="logo">
        Sunrise Dental
    </div>

    <div class="user-section">

        <span>
            <%= user != null ? user.getFullName() : "Administrator" %>
        </span>

        <a class="logout"
           href="<%= request.getContextPath() %>/logout">
            Logout
        </a>

    </div>

</header>

<main class="container">

    <a class="back-link"
       href="<%= request.getContextPath() %>/dashboard">
        ← Back to Dashboard
    </a>

    <div class="page-header">

        <h1>Reports</h1>

        <p>
            View appointment, revenue, treatment, dentist and patient reports.
        </p>

    </div>

    <% if (error != null) { %>

        <div class="error">
            <%= error %>
        </div>

    <% } %>

    <!-- DATE FILTER -->

    <section class="filter-card">

        <h2>Report Date Range</h2>

        <form class="filter-form"
              method="get"
              action="<%= request.getContextPath() %>/reports">

            <div class="form-group">

                <label for="startDate">
                    Start Date
                </label>

                <input
                        type="date"
                        id="startDate"
                        name="startDate"
                        value="<%= startDate %>"
                        required>

            </div>

            <div class="form-group">

                <label for="endDate">
                    End Date
                </label>

                <input
                        type="date"
                        id="endDate"
                        name="endDate"
                        value="<%= endDate %>"
                        required>

            </div>

            <button
                    type="submit"
                    class="btn btn-primary">
                Generate Report
            </button>

        </form>

    </section>

    <div class="print-section">

        <button
                type="button"
                class="btn btn-secondary"
                onclick="window.print()">
            Print Report
        </button>

    </div>

    <!-- REVENUE SUMMARY -->

    <section class="section">

        <h2>Revenue Summary</h2>

        <div class="summary-grid">

            <div class="summary-card">

                <div class="summary-label">
                    Total Revenue
                </div>

                <div class="summary-value revenue">
                    Rs. <%= String.format(
                            "%,.2f",
                            totalRevenue
                    ) %>
                </div>

            </div>

            <div class="summary-card">

                <div class="summary-label">
                    Consultation Fees
                </div>

                <div class="summary-value">
                    Rs. <%= String.format(
                            "%,.2f",
                            totalConsultationFees
                    ) %>
                </div>

            </div>

            <div class="summary-card">

                <div class="summary-label">
                    Treatment Revenue
                </div>

                <div class="summary-value">
                    Rs. <%= String.format(
                            "%,.2f",
                            totalTreatmentRevenue
                    ) %>
                </div>

            </div>

            <div class="summary-card">

                <div class="summary-label">
                    Total Bills
                </div>

                <div class="summary-value">
                    <%= totalBills %>
                </div>

            </div>

            <div class="summary-card">

                <div class="summary-label">
                    Average Bill
                </div>

                <div class="summary-value">
                    Rs. <%= String.format(
                            "%,.2f",
                            averageBillAmount
                    ) %>
                </div>

            </div>

        </div>

    </section>

    <!-- TREATMENT REPORT -->

    <section class="section">

        <h2>Treatment Performance</h2>

        <div class="table-card">

            <table>

                <thead>

                <tr>
                    <th>Treatment</th>
                    <th>Appointments</th>
                    <th>Revenue</th>
                </tr>

                </thead>

                <tbody>

                <% if (treatmentReports != null &&
                       !treatmentReports.isEmpty()) { %>

                    <% for (TreatmentReport report :
                            treatmentReports) { %>

                        <tr>

                            <td>
                                <%= report.getTreatmentName() %>
                            </td>

                            <td>
                                <%= report.getAppointmentCount() %>
                            </td>

                            <td>
                                Rs.
                                <%= String.format(
                                        "%,.2f",
                                        report.getRevenue()
                                ) %>
                            </td>

                        </tr>

                    <% } %>

                <% } else { %>

                    <tr>
                        <td colspan="3" class="empty">
                            No treatment data available for this date range.
                        </td>
                    </tr>

                <% } %>

                </tbody>

            </table>

        </div>

    </section>

    <!-- DENTIST REPORT -->

    <section class="section">

        <h2>Dentist Performance</h2>

        <div class="table-card">

            <table>

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

                <% if (dentistReports != null &&
                       !dentistReports.isEmpty()) { %>

                    <% for (DentistReport report :
                            dentistReports) { %>

                        <tr>

                            <td>
                                <%= report.getDentistName() %>
                            </td>

                            <td>
                                <%= report.getTotalAppointments() %>
                            </td>

                            <td>
                                <%= report.getCompletedAppointments() %>
                            </td>

                            <td>
                                <%= report.getCancelledAppointments() %>
                            </td>

                            <td>
                                <%= report.getNoShowAppointments() %>
                            </td>

                        </tr>

                    <% } %>

                <% } else { %>

                    <tr>
                        <td colspan="5" class="empty">
                            No dentist data available for this date range.
                        </td>
                    </tr>

                <% } %>

                </tbody>

            </table>

        </div>

    </section>

    <!-- PATIENT REPORT -->

    <section class="section">

        <h2>Patient Activity</h2>

        <div class="table-card">

            <table>

                <thead>

                <tr>
                    <th>Patient</th>
                    <th>Total Appointments</th>
                    <th>Completed</th>
                    <th>Last Appointment</th>
                </tr>

                </thead>

                <tbody>

                <% if (patientReports != null &&
                       !patientReports.isEmpty()) { %>

                    <% for (PatientReport report :
                            patientReports) { %>

                        <tr>

                            <td>
                                <%= report.getPatientName() %>
                            </td>

                            <td>
                                <%= report.getTotalAppointments() %>
                            </td>

                            <td>
                                <%= report.getCompletedAppointments() %>
                            </td>

                            <td>
                                <%= report.getLastAppointment() != null
                                        ? report.getLastAppointment()
                                        : "-" %>
                            </td>

                        </tr>

                    <% } %>

                <% } else { %>

                    <tr>
                        <td colspan="4" class="empty">
                            No patient data available for this date range.
                        </td>
                    </tr>

                <% } %>

                </tbody>

            </table>

        </div>

    </section>

</main>

</body>

</html>