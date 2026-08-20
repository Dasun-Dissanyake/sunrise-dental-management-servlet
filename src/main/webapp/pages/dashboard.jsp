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

        .cards {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(240px, 1fr));
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

        <a class="logout"
           href="<%= request.getContextPath() %>/logout">
            Logout
        </a>

    </div>

</header>

<main class="container">

    <section class="welcome">

        <h1>Welcome, <%= user.getFullName() %></h1>

        <p>
            Sunrise Dental Management System
        </p>

        <p>
            Role: <strong><%= user.getRole() %></strong>
        </p>

    </section>


    <section class="cards">

        <div class="card">

            <h3>Appointments</h3>

            <p>
                Register and manage patient appointments.
            </p>

            <a href="<%= request.getContextPath() %>/appointments">
                Manage Appointments →
            </a>

        </div>


        <div class="card">

            <h3>Patients</h3>

            <p>
                View and manage patient information.
            </p>

            <a href="<%= request.getContextPath() %>/patients">
                Manage Patients →
            </a>

        </div>


        <div class="card">

            <h3>Dentists</h3>

            <p>
                View and manage dentist information.
            </p>

            <a href="<%= request.getContextPath() %>/dentists">
                Manage Dentists →
            </a>

        </div>

        <div class="card">
    <h3>Treatments</h3>
    <p>
        View and manage available dental treatments.
    </p>
    <a href="<%= request.getContextPath() %>/treatments">
        Manage Treatments →
    </a>
</div>


        <div class="card">

            <h3>Billing</h3>

            <p>
                Calculate and manage patient bills.
            </p>

<a href="<%= request.getContextPath() %>/bills">
    Manage Billing →
</a>

        </div>

    </section>

</main>

</body>

</html>