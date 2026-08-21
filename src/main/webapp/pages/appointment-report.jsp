<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="com.sunrisedental.model.User" %>
<%@ page import="java.util.Map" %>

<%
    User user = (User) request.getAttribute("user");

    String startDate =
            String.valueOf(request.getAttribute("startDate"));

    String endDate =
            String.valueOf(request.getAttribute("endDate"));

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

        scheduled =
                statusReport.getOrDefault(
                        "SCHEDULED", 0);

        completed =
                statusReport.getOrDefault(
                        "COMPLETED", 0);

        cancelled =
                statusReport.getOrDefault(
                        "CANCELLED", 0);

        noShow =
                statusReport.getOrDefault(
                        "NO_SHOW", 0);
    }
%>

<!DOCTYPE html>

<html lang="en">

<head>

    <meta charset="UTF-8">

    <meta name="viewport"
          content="width=device-width, initial-scale=1.0">

    <title>Appointment Report - Sunrise Dental</title>

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
            background: #fff;
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

        .page-header {
            margin-bottom: 25px;
        }

        .page-header h1 {
            margin-bottom: 8px;
        }

        .filter-card,
        .summary-card,
        .report-card {
            background: white;
            padding: 25px;
            border-radius: 10px;
            border: 1px solid #e5e5e5;
            margin-bottom: 25px;
        }

        .filters {
            display: flex;
            gap: 20px;
            align-items: end;
            flex-wrap: wrap;
        }

        .form-group {
            display: flex;
            flex-direction: column;
            gap: 8px;
        }

        .form-group label {
            font-size: 14px;
            font-weight: bold;
        }

        .form-group input {
            padding: 10px;
            border: 1px solid #d1d5db;
            border-radius: 6px;
        }

        .btn {
            padding: 10px 18px;
            border: none;
            border-radius: 6px;
            background: #2563eb;
            color: white;
            cursor: pointer;
        }

        .btn:hover {
            background: #1d4ed8;
        }

        .summary-value {
            font-size: 32px;
            font-weight: bold;
        }

        .report-table {
            width: 100%;
            border-collapse: collapse;
        }

        .report-table th,
        .report-table td {
            padding: 14px;
            text-align: left;
            border-bottom: 1px solid #eee;
        }

        .report-table th {
            background: #f9fafb;
        }

        .back-link {
            display: inline-block;
            margin-bottom: 20px;
            color: #2563eb;
            text-decoration: none;
        }

        @media print {

            .header,
            .filter-card,
            .back-link {
                display: none;
            }

            body {
                background: white;
            }

            .container {
                padding: 0;
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

    <a
        class="back-link"
        href="<%= request.getContextPath() %>/dashboard">

        ← Back to Dashboard

    </a>


    <section class="page-header">

        <h1>
            Appointment Report
        </h1>

        <p>
            View appointment statistics for a selected date range.
        </p>

    </section>


    <!-- Date Filter -->

    <section class="filter-card">

        <form
            method="get"
            action="<%= request.getContextPath() %>/reports/appointments">

            <div class="filters">

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
                    class="btn">

                    Generate Report

                </button>


                <button
                    type="button"
                    class="btn"
                    onclick="window.print()">

                    Print Report

                </button>

            </div>

        </form>

    </section>


    <!-- Summary -->

    <section class="summary-card">

        <div>

            <p>
                Total Appointments
            </p>

            <div class="summary-value">

                <%= totalAppointments %>

            </div>

        </div>

    </section>


    <!-- Report -->

    <section class="report-card">

        <h2 style="margin-bottom: 20px;">
            Appointment Status
        </h2>

        <table class="report-table">

            <thead>

            <tr>

                <th>
                    Status
                </th>

                <th>
                    Number of Appointments
                </th>

            </tr>

            </thead>

            <tbody>

            <tr>

                <td>
                    Scheduled
                </td>

                <td>
                    <%= scheduled %>
                </td>

            </tr>

            <tr>

                <td>
                    Completed
                </td>

                <td>
                    <%= completed %>
                </td>

            </tr>

            <tr>

                <td>
                    Cancelled
                </td>

                <td>
                    <%= cancelled %>
                </td>

            </tr>

            <tr>

                <td>
                    No Show
                </td>

                <td>
                    <%= noShow %>
                </td>

            </tr>

            </tbody>

        </table>

    </section>

</main>

</body>

</html>