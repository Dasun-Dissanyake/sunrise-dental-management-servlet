<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="com.sunrisedental.model.User" %>
<%@ page import="com.sunrisedental.model.DashboardAppointment" %>
<%@ page import="java.util.List" %>

<%
User user = (User) request.getAttribute("user");


List<DashboardAppointment> recentAppointments =
        (List<DashboardAppointment>) request.getAttribute("recentAppointments");

Integer totalPatients =
        (Integer) request.getAttribute("totalPatients");

Integer totalAppointments =
        (Integer) request.getAttribute("totalAppointments");

Integer todaysAppointments =
        (Integer) request.getAttribute("todaysAppointments");

Double totalRevenue =
        (Double) request.getAttribute("totalRevenue");

if (totalPatients == null) {
    totalPatients = 0;
}

if (totalAppointments == null) {
    totalAppointments = 0;
}

if (todaysAppointments == null) {
    todaysAppointments = 0;
}

if (totalRevenue == null) {
    totalRevenue = 0.0;
}

if (recentAppointments == null) {
    recentAppointments = new java.util.ArrayList<>();
}


%>

<!DOCTYPE html>

<html lang="en">

<head>


<meta charset="UTF-8">

<meta name="viewport"
      content="width=device-width, initial-scale=1.0">

<title>Dashboard - Sunrise Dental</title>

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
    }

    .welcome {
        margin-bottom: 30px;
    }

    .welcome h1 {
        margin-bottom: 8px;
    }

    .welcome p {
        margin-bottom: 5px;
    }

    /* Dashboard Statistics */

    .stats {
        display: grid;
        grid-template-columns: repeat(
            auto-fit,
            minmax(220px, 1fr)
        );
        gap: 20px;
        margin-bottom: 30px;
    }

    .stat-card {
        background: white;
        padding: 22px;
        border-radius: 10px;
        border: 1px solid #e5e5e5;
    }

    .stat-label {
        font-size: 14px;
        color: #6b7280;
        margin-bottom: 10px;
    }

    .stat-value {
        font-size: 28px;
        font-weight: bold;
        color: #111827;
    }

    .stat-revenue {
        color: #166534;
    }

    /* Management Cards */

    .cards {
        display: grid;
        grid-template-columns: repeat(
            auto-fit,
            minmax(240px, 1fr)
        );
        gap: 20px;
    }

    .card {
        background: white;
        padding: 25px;
        border-radius: 10px;
        border: 1px solid #e5e5e5;
    }

    .card h3 {
        margin-bottom: 10px;
    }

    .card p {
        line-height: 1.5;
        color: #555;
    }

    .card a {
        display: inline-block;
        margin-top: 15px;
        text-decoration: none;
        color: #2563eb;
    }

    .card a:hover {
        text-decoration: underline;
    }

    /* Recent Appointments */

    .recent-section {
        margin-top: 30px;
        background: white;
        padding: 25px;
        border-radius: 10px;
        border: 1px solid #e5e5e5;
    }

    .recent-section h2 {
        margin-bottom: 5px;
    }

    .recent-section > p {
        color: #6b7280;
        margin-bottom: 20px;
    }

    .table-container {
        overflow-x: auto;
    }

    .appointment-table {
        width: 100%;
        border-collapse: collapse;
    }

    .appointment-table th,
    .appointment-table td {
        padding: 14px 12px;
        text-align: left;
        border-bottom: 1px solid #e5e7eb;
    }

    .appointment-table th {
        font-size: 13px;
        color: #6b7280;
        background: #f9fafb;
    }

    .appointment-table td {
        font-size: 14px;
    }

    .status {
        display: inline-block;
        padding: 5px 10px;
        border-radius: 20px;
        font-size: 12px;
        font-weight: bold;
    }

    .status-SCHEDULED {
        background: #dbeafe;
        color: #1d4ed8;
    }

    .status-COMPLETED {
        background: #dcfce7;
        color: #166534;
    }

    .status-CANCELLED {
        background: #fee2e2;
        color: #991b1b;
    }

    .status-NO_SHOW {
        background: #fef3c7;
        color: #92400e;
    }

    .no-appointments {
        text-align: center;
        padding: 30px;
        color: #6b7280;
    }

    @media (max-width: 900px) {

        .container {
            padding: 20px;
        }

        .header {
            padding: 0 20px;
        }

        .appointment-table {
            min-width: 800px;
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
        <%= user != null ? user.getFullName() : "User" %>
    </span>

    <a
        class="logout"
        href="<%= request.getContextPath() %>/logout">
        Logout
    </a>

</div>


</header>

<main class="container">


<!-- Welcome Section -->

<section class="welcome">

    <h1>
        Welcome, <%= user != null ? user.getFullName() : "User" %>
    </h1>

    <p>
        Sunrise Dental Management System
    </p>

    <p>
        Role:
        <strong>
            <%= user != null ? user.getRole() : "" %>
        </strong>
    </p>

</section>


<!-- Dashboard Statistics -->

<section class="stats">

    <div class="stat-card">

        <div class="stat-label">
            Total Patients
        </div>

        <div class="stat-value">
            <%= totalPatients %>
        </div>

    </div>


    <div class="stat-card">

        <div class="stat-label">
            Total Appointments
        </div>

        <div class="stat-value">
            <%= totalAppointments %>
        </div>

    </div>


    <div class="stat-card">

        <div class="stat-label">
            Today's Appointments
        </div>

        <div class="stat-value">
            <%= todaysAppointments %>
        </div>

    </div>


    <div class="stat-card">

        <div class="stat-label">
            Total Revenue
        </div>

        <div class="stat-value stat-revenue">
            Rs. <%= String.format("%,.2f", totalRevenue) %>
        </div>

    </div>

</section>


<!-- Management Sections -->

<section class="cards">

    <div class="card">

        <h3>
            Appointments
        </h3>

        <p>
            Register and manage patient appointments.
        </p>

        <a href="<%= request.getContextPath() %>/appointments">
            Manage Appointments →
        </a>

    </div>


    <div class="card">

        <h3>
            Patients
        </h3>

        <p>
            View and manage patient information.
        </p>

        <a href="<%= request.getContextPath() %>/patients">
            Manage Patients →
        </a>

    </div>


    <div class="card">

        <h3>
            Dentists
        </h3>

        <p>
            View and manage dentist information.
        </p>

        <a href="<%= request.getContextPath() %>/dentists">
            Manage Dentists →
        </a>

    </div>


    <div class="card">

        <h3>
            Treatments
        </h3>

        <p>
            View and manage available dental treatments.
        </p>

        <a href="<%= request.getContextPath() %>/treatments">
            Manage Treatments →
        </a>

    </div>


    <div class="card">

        <h3>
            Billing
        </h3>

        <p>
            Calculate and manage patient bills.
        </p>

        <a href="<%= request.getContextPath() %>/bills">
            Manage Billing →
        </a>

    </div>


    <div class="card">

        <h3>
            Reports
        </h3>

        <p>
            View appointment, revenue and treatment reports.
        </p>

        <a href="<%= request.getContextPath() %>/reports/appointments">
            View Reports →
        </a>

    </div>

</section>


<!-- Recent Appointments -->

<section class="recent-section">

    <h2>
        Recent Appointments
    </h2>

    <p>
        Latest appointments registered in the system.
    </p>

    <% if (recentAppointments.isEmpty()) { %>

        <div class="no-appointments">
            No recent appointments found.
        </div>

    <% } else { %>

        <div class="table-container">

            <table class="appointment-table">

                <thead>

                <tr>

                    <th>
                        Appointment No.
                    </th>

                    <th>
                        Patient
                    </th>

                    <th>
                        Dentist
                    </th>

                    <th>
                        Treatment
                    </th>

                    <th>
                        Date
                    </th>

                    <th>
                        Time
                    </th>

                    <th>
                        Status
                    </th>

                </tr>

                </thead>

                <tbody>

                <% for (DashboardAppointment appointment : recentAppointments) { %>

                    <tr>

                        <td>
                            <%= appointment.getAppointmentNumber() %>
                        </td>

                        <td>
                            <%= appointment.getPatientName() %>
                        </td>

                        <td>
                            <%= appointment.getDentistName() %>
                        </td>

                        <td>
                            <%= appointment.getTreatmentName() %>
                        </td>

                        <td>
                            <%= appointment.getAppointmentDate() %>
                        </td>

                        <td>
                            <%= appointment.getAppointmentTime() %>
                        </td>

                        <td>

                            <span class="status status-<%= appointment.getStatus() %>">
                                <%= appointment.getStatus() %>
                            </span>

                        </td>

                    </tr>

                <% } %>

                </tbody>

            </table>

        </div>

    <% } %>

</section>


</main>

</body>

</html>
