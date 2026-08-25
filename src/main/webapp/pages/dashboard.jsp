
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

    if (totalPatients == null) totalPatients = 0;
    if (totalAppointments == null) totalAppointments = 0;
    if (todaysAppointments == null) todaysAppointments = 0;
    if (totalRevenue == null) totalRevenue = 0.0;

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

    <link rel="stylesheet"
      href="<%= request.getContextPath() %>/css/sunrise-theme.css">

</head>


<body>


<header class="header">

    <div class="brand">

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

    </div>


    <div class="user-section">

        <div class="user-info">

            <div class="user-name">
                <%= user != null ? user.getFullName() : "User" %>
            </div>

            <div class="user-role">
                <%= user != null ? user.getRole() : "" %>
            </div>

        </div>


        <a
            class="logout"
            href="<%= request.getContextPath() %>/logout">

            Logout

        </a>

    </div>

</header>


<main class="container">


    <!-- Welcome -->

    <section class="welcome">

        <h1>
            Welcome,
            <%= user != null ? user.getFullName() : "User" %>
        </h1>

        <p>
            Manage your dental center from one place.
        </p>

        <span class="role-badge">
            <%= user != null ? user.getRole() : "" %>
        </span>

    </section>


    <!-- Statistics -->

    <section class="stats">


        <div class="stat-card">

            <div class="stat-top">

                <div class="stat-label">
                    Total Patients
                </div>

                <div class="stat-icon">
                    P
                </div>

            </div>

            <div class="stat-value">
                <%= totalPatients %>
            </div>

        </div>


        <div class="stat-card">

            <div class="stat-top">

                <div class="stat-label">
                    Total Appointments
                </div>

                <div class="stat-icon">
                    A
                </div>

            </div>

            <div class="stat-value">
                <%= totalAppointments %>
            </div>

        </div>


        <div class="stat-card">

            <div class="stat-top">

                <div class="stat-label">
                    Today's Appointments
                </div>

                <div class="stat-icon">
                    T
                </div>

            </div>

            <div class="stat-value">
                <%= todaysAppointments %>
            </div>

        </div>


        <div class="stat-card">

            <div class="stat-top">

                <div class="stat-label">
                    Total Revenue
                </div>

                <div class="stat-icon">
                    Rs
                </div>

            </div>

            <div class="stat-value stat-revenue">
                Rs. <%= String.format("%,.2f", totalRevenue) %>
            </div>

        </div>


    </section>


    <!-- Management -->

    <section class="management-section">


        <div class="section-heading">

            <div>

                <h2>
                    Management
                </h2>

                <p>
                    Access and manage the main areas of Sunrise Dental.
                </p>

            </div>

        </div>


        <div class="cards">


            <!-- Appointments -->

            <div class="card">

                <div class="card-image-wrapper">

                    <img
                        src="<%= request.getContextPath() %>/assets/images/appointments.jpg"
                        alt="Appointments"
                        class="card-image"
                    >

                </div>


                <div class="card-content">

                    <div class="card-icon">
                        A
                    </div>

                    <h3>
                        Appointments
                    </h3>

                    <p>
                        Register, manage and update patient appointments.
                    </p>

                    <a
                        class="card-link"
                        href="<%= request.getContextPath() %>/appointments">

                        Manage Appointments →

                    </a>

                </div>

            </div>


            <!-- Patients -->

            <div class="card">

                <div class="card-image-wrapper">

                    <img
                        src="<%= request.getContextPath() %>/assets/images/patients.jpg"
                        alt="Patients"
                        class="card-image"
                    >

                </div>


                <div class="card-content">

                    <div class="card-icon">
                        P
                    </div>

                    <h3>
                        Patients
                    </h3>

                    <p>
                        View and manage patient information and records.
                    </p>

                    <a
                        class="card-link"
                        href="<%= request.getContextPath() %>/patients">

                        Manage Patients →

                    </a>

                </div>

            </div>


            <!-- Dentists -->

            <div class="card">

                <div class="card-image-wrapper">

                    <img
                        src="<%= request.getContextPath() %>/assets/images/dentists.jpg"
                        alt="Dentists"
                        class="card-image"
                    >

                </div>


                <div class="card-content">

                    <div class="card-icon">
                        D
                    </div>

                    <h3>
                        Dentists
                    </h3>

                    <p>
                        Manage dentist profiles and availability.
                    </p>

                    <a
                        class="card-link"
                        href="<%= request.getContextPath() %>/dentists">

                        Manage Dentists →

                    </a>

                </div>

            </div>


            <!-- Treatments -->

            <div class="card">

                <div class="card-image-wrapper">

                    <img
                        src="<%= request.getContextPath() %>/assets/images/treatments.jpg"
                        alt="Treatments"
                        class="card-image"
                    >

                </div>


                <div class="card-content">

                    <div class="card-icon">
                        T
                    </div>

                    <h3>
                        Treatments
                    </h3>

                    <p>
                        View and manage available dental treatments.
                    </p>

                    <a
                        class="card-link"
                        href="<%= request.getContextPath() %>/treatments">

                        Manage Treatments →

                    </a>

                </div>

            </div>


            <!-- Billing -->

            <div class="card">

                <div class="card-image-wrapper">

                    <img
                        src="<%= request.getContextPath() %>/assets/images/billing.jpg"
                        alt="Billing"
                        class="card-image"
                    >

                </div>


                <div class="card-content">

                    <div class="card-icon">
                        $
                    </div>

                    <h3>
                        Billing
                    </h3>

                    <p>
                        Calculate and manage patient bills and payments.
                    </p>

                    <a
                        class="card-link"
                        href="<%= request.getContextPath() %>/bills">

                        Manage Billing →

                    </a>

                </div>

            </div>


            <!-- Reports -->

            <div class="card">

                <div class="card-image-wrapper">

                    <img
                        src="<%= request.getContextPath() %>/assets/images/reports.jpg"
                        alt="Reports"
                        class="card-image"
                    >

                </div>


                <div class="card-content">

                    <div class="card-icon">
                        R
                    </div>

                    <h3>
                        Reports
                    </h3>

                    <p>
                        View appointment, revenue, treatment and performance reports.
                    </p>

                    <a
                        class="card-link"
                        href="<%= request.getContextPath() %>/reports">

                        View Reports →

                    </a>

                </div>

            </div>


        </div>

    </section>


    <!-- Recent Appointments -->

    <section class="recent-section">


        <div class="recent-header">

            <h2>
                Recent Appointments
            </h2>

            <p>
                Latest appointments registered in the system.
            </p>

        </div>


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

                            <td class="appointment-number">
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

                                <span
                                    class="status status-<%= appointment.getStatus() %>">

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


    <div class="footer">

        Sunrise Dental Management System

    </div>


</main>


</body>

</html>
