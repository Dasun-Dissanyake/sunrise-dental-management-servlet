<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="com.sunrisedental.model.Bill" %>
<%@ page import="com.sunrisedental.model.Appointment" %>
<%@ page import="com.sunrisedental.model.Treatment" %>

<%
    Bill searchedBill = (Bill) request.getAttribute("searchedBill");
    Appointment appointment = (Appointment) request.getAttribute("appointment");
    Treatment treatment = (Treatment) request.getAttribute("treatment");

    String error = (String) request.getAttribute("error");

    String successParam = request.getParameter("success");
    String errorParam = request.getParameter("error");

    String successMessage = null;

    if ("generated".equals(successParam)) {
        successMessage = "Bill generated successfully.";
    }

    if ("exists".equals(errorParam)) {
        error = "A bill already exists for this appointment.";
    } else if ("failed".equals(errorParam)) {
        error = "Unable to generate the bill.";
    } else if ("invalid".equals(errorParam)) {
        error = "Invalid billing request.";
    }
%>

<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">

    <title>Billing - Sunrise Dental</title>

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

        .header-links {
            display: flex;
            align-items: center;
            gap: 15px;
        }

        .back-link,
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
            max-width: 1200px;
            margin: auto;
        }

        .page-header {
            margin-bottom: 25px;
        }

        .page-header h1 {
            margin-bottom: 8px;
        }

        .card {
            background: white;
            padding: 25px;
            border-radius: 10px;
            border: 1px solid #e5e5e5;
            margin-bottom: 20px;
        }

        .card h2 {
            margin-bottom: 20px;
            font-size: 20px;
        }

        .search-form {
            display: flex;
            gap: 10px;
            flex-wrap: wrap;
        }

        input {
            padding: 11px 12px;
            border: 1px solid #ccc;
            border-radius: 6px;
            font-size: 14px;
        }

        .search-form input {
            flex: 1;
            min-width: 250px;
        }

        button {
            padding: 11px 18px;
            border: none;
            border-radius: 6px;
            cursor: pointer;
            font-size: 14px;
        }

        .btn-primary {
            background: #2563eb;
            color: white;
        }

        .btn-secondary {
            background: #6b7280;
            color: white;
        }

        .btn-print {
            background: #111827;
            color: white;
        }

        .message {
            padding: 12px 15px;
            border-radius: 6px;
            margin-bottom: 20px;
        }

        .success {
            background: #dcfce7;
            color: #166534;
            border: 1px solid #bbf7d0;
        }

        .error {
            background: #fee2e2;
            color: #991b1b;
            border: 1px solid #fecaca;
        }

        .details-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(220px, 1fr));
            gap: 15px;
        }

        .detail {
            background: #f8fafc;
            padding: 15px;
            border-radius: 7px;
            border: 1px solid #e5e7eb;
        }

        .detail-label {
            font-size: 12px;
            color: #6b7280;
            margin-bottom: 6px;
        }

        .detail-value {
            font-weight: bold;
        }

        .bill-form {
            display: flex;
            flex-direction: column;
            gap: 15px;
        }

        .form-group {
            display: flex;
            flex-direction: column;
            gap: 6px;
        }

        .form-group label {
            font-weight: bold;
            font-size: 14px;
        }

        .form-group input {
            width: 100%;
            max-width: 400px;
        }

        .amount-table {
            width: 100%;
            border-collapse: collapse;
            margin-top: 10px;
        }

        .amount-table td {
            padding: 14px 10px;
            border-bottom: 1px solid #eee;
        }

        .amount-table td:last-child {
            text-align: right;
            font-weight: bold;
        }

        .total-row td {
            font-size: 18px;
            border-top: 2px solid #333;
            border-bottom: none;
        }

        .bill-actions {
            margin-top: 20px;
            display: flex;
            gap: 10px;
        }

        .bill-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 20px;
            flex-wrap: wrap;
            gap: 10px;
        }

        .bill-number {
            font-size: 20px;
            font-weight: bold;
        }

        @media print {

            .header,
            .search-card,
            .bill-actions,
            .page-header {
                display: none;
            }

            body {
                background: white;
            }

            .container {
                max-width: 100%;
                padding: 0;
            }

            .card {
                border: none;
            }
        }
    </style>
</head>

<body>

<header class="header">

    <div class="logo">
        Sunrise Dental
    </div>

    <div class="header-links">

        <a class="back-link"
           href="<%= request.getContextPath() %>/dashboard">
            Dashboard
        </a>

        <a class="logout"
           href="<%= request.getContextPath() %>/logout">
            Logout
        </a>

    </div>

</header>

<main class="container">

    <section class="page-header">

        <h1>Billing</h1>

        <p>
            Generate and manage patient bills.
        </p>

    </section>

    <% if (successMessage != null) { %>

        <div class="message success">
            <%= successMessage %>
        </div>

    <% } %>

    <% if (error != null) { %>

        <div class="message error">
            <%= error %>
        </div>

    <% } %>


    <!-- SEARCH -->

    <section class="card search-card">

        <h2>Search Bill</h2>

        <form class="search-form"
              method="get"
              action="<%= request.getContextPath() %>/bills">

            <input
                    type="text"
                    name="billNumber"
                    placeholder="Enter Bill Number">

            <button
                    type="submit"
                    class="btn-primary">
                Search Bill
            </button>

        </form>

        <br>

        <form class="search-form"
              method="get"
              action="<%= request.getContextPath() %>/bills">

            <input
                    type="number"
                    name="appointmentId"
                    placeholder="Enter Appointment ID"
                    min="1">

            <button
                    type="submit"
                    class="btn-secondary">
                Find Appointment
            </button>

        </form>

    </section>


    <!-- EXISTING BILL -->

    <% if (searchedBill != null) { %>

        <section class="card">

            <div class="bill-header">

                <div>
                    <h2>Bill Details</h2>

                    <div class="bill-number">
                        <%= searchedBill.getBillNumber() %>
                    </div>
                </div>

                <button
                        type="button"
                        class="btn-print"
                        onclick="window.print()">
                    Print Bill
                </button>

            </div>

            <div class="details-grid">

                <div class="detail">

                    <div class="detail-label">
                        Bill Number
                    </div>

                    <div class="detail-value">
                        <%= searchedBill.getBillNumber() %>
                    </div>

                </div>

                <div class="detail">

                    <div class="detail-label">
                        Bill Date
                    </div>

                    <div class="detail-value">
                        <%= searchedBill.getBillDate() %>
                    </div>

                </div>

                <div class="detail">

                    <div class="detail-label">
                        Appointment ID
                    </div>

                    <div class="detail-value">
                        <%= searchedBill.getAppointmentId() %>
                    </div>

                </div>

            </div>

            <table class="amount-table">

                <tr>
                    <td>Consultation Fee</td>
                    <td>
                        Rs. <%= String.format(
                                "%.2f",
                                searchedBill.getConsultationFee()
                        ) %>
                    </td>
                </tr>

                <tr>
                    <td>Treatment Cost</td>
                    <td>
                        Rs. <%= String.format(
                                "%.2f",
                                searchedBill.getTreatmentCost()
                        ) %>
                    </td>
                </tr>

                <tr class="total-row">
                    <td>Total Amount</td>
                    <td>
                        Rs. <%= String.format(
                                "%.2f",
                                searchedBill.getTotalAmount()
                        ) %>
                    </td>
                </tr>

            </table>

        </section>

    <% } %>


    <!-- APPOINTMENT -->

    <% if (appointment != null && searchedBill == null) { %>

        <section class="card">

            <h2>Appointment Details</h2>

            <div class="details-grid">

                <div class="detail">

                    <div class="detail-label">
                        Appointment Number
                    </div>

                    <div class="detail-value">
                        <%= appointment.getAppointmentNumber() %>
                    </div>

                </div>

                <div class="detail">

                    <div class="detail-label">
                        Appointment Date
                    </div>

                    <div class="detail-value">
                        <%= appointment.getAppointmentDate() %>
                    </div>

                </div>

                <div class="detail">

                    <div class="detail-label">
                        Appointment Time
                    </div>

                    <div class="detail-value">
                        <%= appointment.getAppointmentTime() %>
                    </div>

                </div>

                <div class="detail">

                    <div class="detail-label">
                        Status
                    </div>

                    <div class="detail-value">
                        <%= appointment.getStatus() %>
                    </div>

                </div>

                <% if (treatment != null) { %>

                    <div class="detail">

                        <div class="detail-label">
                            Treatment
                        </div>

                        <div class="detail-value">
                            <%= treatment.getTreatmentName() %>
                        </div>

                    </div>

                    <div class="detail">

                        <div class="detail-label">
                            Treatment Code
                        </div>

                        <div class="detail-value">
                            <%= treatment.getTreatmentCode() %>
                        </div>

                    </div>

                <% } %>

            </div>

        </section>


        <!-- GENERATE BILL -->

        <section class="card">

            <h2>Generate Bill</h2>

            <% if (treatment != null) { %>

                <table class="amount-table">

                    <tr>
                        <td>Consultation Fee</td>
                        <td>
                            Rs. <%= String.format(
                                    "%.2f",
                                    treatment.getConsultationFee()
                            ) %>
                        </td>
                    </tr>

                    <tr>
                        <td>Treatment Cost</td>
                        <td>
                            Rs. <%= String.format(
                                    "%.2f",
                                    treatment.getTreatmentCost()
                            ) %>
                        </td>
                    </tr>

                    <tr class="total-row">
                        <td>Total Amount</td>
                        <td>
                            Rs. <%= String.format(
                                    "%.2f",
                                    treatment.getConsultationFee()
                                    + treatment.getTreatmentCost()
                            ) %>
                        </td>
                    </tr>

                </table>

                <form
                        class="bill-form"
                        method="post"
                        action="<%= request.getContextPath() %>/bills">

                    <input
                            type="hidden"
                            name="action"
                            value="generate">

                    <input
                            type="hidden"
                            name="appointmentId"
                            value="<%= appointment.getId() %>">

                    <div class="form-group">

                        <label for="billNumber">
                            Bill Number
                        </label>

                        <input
                                type="text"
                                id="billNumber"
                                name="billNumber"
                                placeholder="e.g. BILL-001"
                                maxlength="20"
                                required>

                    </div>

                    <div class="bill-actions">

                        <button
                                type="submit"
                                class="btn-primary">
                            Generate Bill
                        </button>

                    </div>

                </form>

            <% } else { %>

                <div class="message error">
                    Treatment information could not be loaded
                    for this appointment.
                </div>

            <% } %>

        </section>

    <% } %>

</main>

</body>
</html>