<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="com.sunrisedental.model.Bill" %>
<%@ page import="com.sunrisedental.model.Appointment" %>
<%@ page import="com.sunrisedental.model.Treatment" %>
<%@ page import="com.sunrisedental.model.Patient" %>
<%@ page import="com.sunrisedental.model.User" %>

<%
    User user = (User) session.getAttribute("loggedInUser");
    if (user == null) {
        user = (User) request.getAttribute("user");
    }

    Bill searchedBill =
            (Bill) request.getAttribute("searchedBill");

    Appointment appointment =
            (Appointment) request.getAttribute("appointment");

    Treatment treatment =
            (Treatment) request.getAttribute("treatment");

    Patient patient =
            (Patient) request.getAttribute("patient");

    String error =
            (String) request.getAttribute("error");

    String successParam =
            request.getParameter("success");

    String errorParam =
            request.getParameter("error");

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
        <a class="nav-link active" href="<%= request.getContextPath() %>/bills">Billing</a>
        <a class="nav-link" href="<%= request.getContextPath() %>/reports">Reports</a>
        <a class="nav-link" href="<%= request.getContextPath() %>/help">Help</a>
        <% if (user != null && "ADMIN".equalsIgnoreCase(user.getRole())) { %>
            <a class="nav-link" href="<%= request.getContextPath() %>/users">User Management</a>
        <% } %>
    </div>
</nav>

<main class="container">

    <!-- NORMAL SCREEN CONTENT -->
    <div class="screen-content">

        <div class="page-header">
            <div class="page-header-text">
                <h1>Billing</h1>
                <p>Generate, search and manage patient invoices.</p>
            </div>
            <div class="page-header-actions">
                <a class="back-link" href="<%= request.getContextPath() %>/dashboard">
                    &larr; Back to Dashboard
                </a>
            </div>
        </div>

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
        <div class="card search-card">
            <div class="card-header">
                <div>
                    <h2 class="card-title">Search Invoices &amp; Appointments</h2>
                    <p class="card-subtitle">Lookup bills by bill receipt number or appointment reference.</p>
                </div>
            </div>

            <form class="search-form" method="get" action="<%= request.getContextPath() %>/bills">
                <input
                    type="text"
                    name="billNumber"
                    placeholder="Enter Bill / Receipt Number (e.g. REC-000001)"
                >
                <button type="submit" class="btn btn-primary">Search Bill</button>
            </form>

            <div style="margin-top: 18px; padding-top: 18px; border-top: 1px solid var(--border-light);">
                <form class="search-form" method="get" action="<%= request.getContextPath() %>/bills">
                    <input
                        type="number"
                        name="appointmentId"
                        placeholder="Enter Appointment ID (to generate bill)"
                        min="1"
                    >
                    <button type="submit" class="btn btn-secondary">Find Appointment for Billing</button>
                </form>
            </div>
        </div>

        <!-- EXISTING BILL DETAILS -->
        <% if (searchedBill != null) { %>
            <div class="card">
                <div class="card-header">
                    <div>
                        <h2 class="card-title">Bill Invoice Details</h2>
                        <p class="card-subtitle">Invoice Reference: <strong style="color: var(--primary-dark);"><%= searchedBill.getBillNumber() %></strong></p>
                    </div>
                    <button type="button" class="btn btn-dark" onclick="window.print()">
                        Print Official Receipt
                    </button>
                </div>

                <% if (patient != null) { %>
                    <h3 style="font-size: 13px; font-weight: 700; color: var(--muted); text-transform: uppercase; letter-spacing: 0.5px; margin-bottom: 12px;">
                        Patient Information
                    </h3>
                    <div class="details-grid">
                        <div class="detail-box">
                            <div class="detail-label">Patient Name</div>
                            <div class="detail-value"><%= patient.getFullName() %></div>
                        </div>
                        <div class="detail-box">
                            <div class="detail-label">Patient Number</div>
                            <div class="detail-value"><%= patient.getPatientNumber() %></div>
                        </div>
                        <div class="detail-box">
                            <div class="detail-label">Contact Number</div>
                            <div class="detail-value"><%= patient.getContactNumber() %></div>
                        </div>
                    </div>
                <% } %>

                <h3 style="font-size: 13px; font-weight: 700; color: var(--muted); text-transform: uppercase; letter-spacing: 0.5px; margin-top: 18px; margin-bottom: 12px;">
                    Invoice Information
                </h3>
                <div class="details-grid">
                    <div class="detail-box">
                        <div class="detail-label">Bill Number</div>
                        <div class="detail-value"><%= searchedBill.getBillNumber() %></div>
                    </div>
                    <div class="detail-box">
                        <div class="detail-label">Bill Date</div>
                        <div class="detail-value"><%= searchedBill.getBillDate() %></div>
                    </div>
                    <div class="detail-box">
                        <div class="detail-label">Appointment ID</div>
                        <div class="detail-value"><%= searchedBill.getAppointmentId() %></div>
                    </div>
                </div>

                <h3 style="font-size: 13px; font-weight: 700; color: var(--muted); text-transform: uppercase; letter-spacing: 0.5px; margin-top: 18px; margin-bottom: 8px;">
                    Charges Breakdown
                </h3>
                <table class="amount-table">
                    <tr>
                        <td>Consultation Fee</td>
                        <td>Rs. <%= String.format("%,.2f", searchedBill.getConsultationFee()) %></td>
                    </tr>
                    <tr>
                        <td>Treatment Cost</td>
                        <td>Rs. <%= String.format("%,.2f", searchedBill.getTreatmentCost()) %></td>
                    </tr>
                    <tr class="total-row">
                        <td>Total Amount Payable</td>
                        <td>Rs. <%= String.format("%,.2f", searchedBill.getTotalAmount()) %></td>
                    </tr>
                </table>
            </div>
        <% } %>

        <!-- APPOINTMENT DETAILS & GENERATE BILL FORM -->
        <% if (appointment != null && searchedBill == null) { %>
            <div class="card">
                <div class="card-header">
                    <div>
                        <h2 class="card-title">Appointment Details</h2>
                        <p class="card-subtitle">Appointment Reference: <strong><%= appointment.getAppointmentNumber() %></strong></p>
                    </div>
                </div>

                <div class="details-grid">
                    <div class="detail-box">
                        <div class="detail-label">Appointment Number</div>
                        <div class="detail-value"><%= appointment.getAppointmentNumber() %></div>
                    </div>
                    <div class="detail-box">
                        <div class="detail-label">Date &amp; Time</div>
                        <div class="detail-value"><%= appointment.getAppointmentDate() %> at <%= appointment.getAppointmentTime() %></div>
                    </div>
                    <div class="detail-box">
                        <div class="detail-label">Status</div>
                        <div class="detail-value">
                            <span class="status status-<%= appointment.getStatus() %>">
                                <%= appointment.getStatus() %>
                            </span>
                        </div>
                    </div>
                    <% if (patient != null) { %>
                        <div class="detail-box">
                            <div class="detail-label">Patient Name</div>
                            <div class="detail-value"><%= patient.getFullName() %></div>
                        </div>
                    <% } %>
                    <% if (treatment != null) { %>
                        <div class="detail-box">
                            <div class="detail-label">Treatment</div>
                            <div class="detail-value"><%= treatment.getTreatmentName() %></div>
                        </div>
                        <div class="detail-box">
                            <div class="detail-label">Treatment Code</div>
                            <div class="detail-value"><%= treatment.getTreatmentCode() %></div>
                        </div>
                    <% } %>
                </div>
            </div>

            <div class="card">
                <div class="card-header">
                    <div>
                        <h2 class="card-title">Generate Invoice</h2>
                        <p class="card-subtitle">Confirm charges and assign a receipt number to generate the patient bill.</p>
                    </div>
                </div>

                <% if (treatment != null) { %>
                    <table class="amount-table">
                        <tr>
                            <td>Consultation Fee</td>
                            <td>Rs. <%= String.format("%,.2f", treatment.getConsultationFee()) %></td>
                        </tr>
                        <tr>
                            <td>Treatment Cost</td>
                            <td>Rs. <%= String.format("%,.2f", treatment.getTreatmentCost()) %></td>
                        </tr>
                        <tr class="total-row">
                            <td>Total Amount Payable</td>
                            <td>
                                Rs. <%= String.format("%,.2f", treatment.getConsultationFee() + treatment.getTreatmentCost()) %>
                            </td>
                        </tr>
                    </table>

                    <form class="bill-form" method="post" action="<%= request.getContextPath() %>/bills">
                        <input type="hidden" name="action" value="generate">
                        <input type="hidden" name="appointmentId" value="<%= appointment.getId() %>">

                        <div class="form-group" style="max-width: 420px;">
                            <label for="billNumber">Bill Receipt Number <span class="required-indicator">*</span></label>
                            <input
                                type="text"
                                id="billNumber"
                                name="billNumber"
                                placeholder="e.g. REC-000001"
                                maxlength="20"
                                required
                            >
                        </div>

                        <div class="form-actions">
                            <button type="submit" class="btn btn-primary">
                                Generate Bill
                            </button>
                        </div>
                    </form>
                <% } else { %>
                    <div class="message error">
                        Treatment information could not be loaded for this appointment.
                    </div>
                <% } %>
            </div>
        <% } %>

    </div>

    <!-- PRINTABLE RECEIPT -->
    <% if (searchedBill != null) { %>
        <section class="print-receipt">
            <div class="print-header">
                <h1>SUNRISE DENTAL</h1>
                <p>Dental Care &amp; Treatment Center</p>
                <p>Colombo, Sri Lanka</p>
            </div>

            <div class="receipt-title">
                <h2>PATIENT BILL / RECEIPT</h2>
            </div>

            <div class="receipt-meta">
                <div>
                    <strong>Bill Number:</strong> <%= searchedBill.getBillNumber() %>
                </div>
                <div>
                    <strong>Bill Date:</strong> <%= searchedBill.getBillDate() %>
                </div>
            </div>

            <% if (patient != null) { %>
                <div class="receipt-section">
                    <h3>Patient Information</h3>
                    <div class="receipt-details">
                        <div class="receipt-detail">
                            <span>Patient Name:</span>
                            <span><%= patient.getFullName() %></span>
                        </div>
                        <div class="receipt-detail">
                            <span>Patient Number:</span>
                            <span><%= patient.getPatientNumber() %></span>
                        </div>
                        <div class="receipt-detail">
                            <span>Contact Number:</span>
                            <span><%= patient.getContactNumber() %></span>
                        </div>
                    </div>
                </div>
            <% } %>

            <% if (appointment != null) { %>
                <div class="receipt-section">
                    <h3>Appointment Information</h3>
                    <div class="receipt-details">
                        <div class="receipt-detail">
                            <span>Appointment ID:</span>
                            <span><%= appointment.getId() %></span>
                        </div>
                        <div class="receipt-detail">
                            <span>Appointment Number:</span>
                            <span><%= appointment.getAppointmentNumber() %></span>
                        </div>
                        <div class="receipt-detail">
                            <span>Date:</span>
                            <span><%= appointment.getAppointmentDate() %></span>
                        </div>
                        <div class="receipt-detail">
                            <span>Time:</span>
                            <span><%= appointment.getAppointmentTime() %></span>
                        </div>
                    </div>
                </div>
            <% } %>

            <% if (treatment != null) { %>
                <div class="receipt-section">
                    <h3>Treatment Information</h3>
                    <div class="receipt-details">
                        <div class="receipt-detail">
                            <span>Treatment:</span>
                            <span><%= treatment.getTreatmentName() %></span>
                        </div>
                        <div class="receipt-detail">
                            <span>Treatment Code:</span>
                            <span><%= treatment.getTreatmentCode() %></span>
                        </div>
                    </div>
                </div>
            <% } %>

            <div class="receipt-section">
                <h3>Charges Breakdown</h3>
                <table class="receipt-table">
                    <thead>
                    <tr>
                        <th>Description</th>
                        <th>Amount</th>
                    </tr>
                    </thead>
                    <tbody>
                    <tr>
                        <td>Consultation Fee</td>
                        <td>Rs. <%= String.format("%,.2f", searchedBill.getConsultationFee()) %></td>
                    </tr>
                    <tr>
                        <td>Treatment Cost</td>
                        <td>Rs. <%= String.format("%,.2f", searchedBill.getTreatmentCost()) %></td>
                    </tr>
                    <tr class="receipt-total">
                        <td>TOTAL AMOUNT</td>
                        <td>Rs. <%= String.format("%,.2f", searchedBill.getTotalAmount()) %></td>
                    </tr>
                    </tbody>
                </table>
            </div>

            <div class="receipt-footer">
                <div class="thank-you">Thank you for choosing Sunrise Dental.</div>
                <div>Please retain this receipt for your records.</div>
                <div>This is a computer-generated receipt.</div>
            </div>
        </section>
    <% } %>

</main>

<footer class="footer">
    Sunrise Dental Management System &bull; Professional Dental Care &amp; Clinical Operations
</footer>

</body>
</html>
