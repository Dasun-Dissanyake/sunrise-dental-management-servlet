<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="com.sunrisedental.model.User" %>

<%
User user = (User) request.getAttribute("user");
%>

<!DOCTYPE html>

<html lang="en">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">


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

    .container {
        padding: 30px;
    }

    .welcome {
        margin-bottom: 30px;
    }

    .welcome h1 {
        margin-bottom: 8px;
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

    .card a {
        display: inline-block;
        margin-top: 15px;
        text-decoration: none;
        color: #2563eb;
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
        <%= user.getFullName() %>
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
        Welcome, <%= user.getFullName() %>
    </h1>

    <p>
        Sunrise Dental Management System
    </p>

    <p>
        Role:
        <strong>
            <%= user.getRole() %>
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
            <%= request.getAttribute("totalPatients") %>
        </div>

    </div>


    <div class="stat-card">

        <div class="stat-label">
            Total Appointments
        </div>

        <div class="stat-value">
            <%= request.getAttribute("totalAppointments") %>
        </div>

    </div>


    <div class="stat-card">

        <div class="stat-label">
            Today's Appointments
        </div>

        <div class="stat-value">
            <%= request.getAttribute("todayAppointments") %>
        </div>

    </div>


    <div class="stat-card">

        <div class="stat-label">
            Total Revenue
        </div>

        <div class="stat-value stat-revenue">

            Rs.
            <%= String.format(
                    "%.2f",
                    request.getAttribute("totalRevenue")
            ) %>

        </div>

    </div>

</section>


<!-- Management Sections -->

<section class="cards">


    <!-- Appointments -->

    <div class="card">

        <h3>
            Appointments
        </h3>

        <p>
            Register and manage patient appointments.
        </p>

        <a
            href="<%= request.getContextPath() %>/appointments">

            Manage Appointments →

        </a>

    </div>


    <!-- Patients -->

    <div class="card">

        <h3>
            Patients
        </h3>

        <p>
            View and manage patient information.
        </p>

        <a
            href="<%= request.getContextPath() %>/patients">

            Manage Patients →

        </a>

    </div>


    <!-- Dentists -->

    <div class="card">

        <h3>
            Dentists
        </h3>

        <p>
            View and manage dentist information.
        </p>

        <a
            href="<%= request.getContextPath() %>/dentists">

            Manage Dentists →

        </a>

    </div>


    <!-- Treatments -->

    <div class="card">

        <h3>
            Treatments
        </h3>

        <p>
            View and manage available dental treatments.
        </p>

        <a
            href="<%= request.getContextPath() %>/treatments">

            Manage Treatments →

        </a>

    </div>


    <!-- Billing -->

    <div class="card">

        <h3>
            Billing
        </h3>

        <p>
            Calculate and manage patient bills.
        </p>

        <a
            href="<%= request.getContextPath() %>/bills">

            Manage Billing →

        </a>

    </div>


</section>


</main>

</body>

</html>
