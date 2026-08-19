<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.Map" %>
<%@ page import="java.util.HashMap" %>
<%@ page import="com.sunrisedental.model.Appointment" %>
<%@ page import="com.sunrisedental.model.Patient" %>
<%@ page import="com.sunrisedental.model.Dentist" %>
<%@ page import="com.sunrisedental.model.Treatment" %>

<%
    List<Appointment> appointments = (List<Appointment>) request.getAttribute("appointments");
    Appointment searchedAppointment = (Appointment) request.getAttribute("searchedAppointment");
    List<Patient> patients = (List<Patient>) request.getAttribute("patients");
    List<Dentist> dentists = (List<Dentist>) request.getAttribute("dentists");
    List<Treatment> treatments = (List<Treatment>) request.getAttribute("treatments");
    String error = (String) request.getAttribute("error");
    String success = request.getParameter("success");

    Map<Long, String> patientMap = new HashMap<>();
    if (patients != null) {
        for (Patient p : patients) {
            patientMap.put(p.getId(), p.getFullName() + " (" + p.getPatientNumber() + ")");
        }
    }

    Map<Long, String> dentistMap = new HashMap<>();
    if (dentists != null) {
        for (Dentist d : dentists) {
            dentistMap.put(d.getId(), d.getFullName() + " (" + d.getSpecialization() + ")");
        }
    }

    Map<Long, String> treatmentMap = new HashMap<>();
    if (treatments != null) {
        for (Treatment t : treatments) {
            treatmentMap.put(t.getId(), t.getTreatmentName() + " (" + t.getTreatmentCode() + ")");
        }
    }
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Appointments - Sunrise Dental</title>
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
            padding: 20px 30px;
            border-bottom: 1px solid #ddd;
            display: flex;
            justify-content: space-between;
            align-items: center;
        }

        .header h1 {
            font-size: 22px;
        }

        .back {
            text-decoration: none;
            color: #2563eb;
        }

        .container {
            padding: 30px;
            max-width: 1200px;
            margin: auto;
        }

        .card {
            background: white;
            padding: 25px;
            margin-bottom: 25px;
            border-radius: 10px;
            border: 1px solid #e5e5e5;
        }

        .card h2 {
            margin-bottom: 20px;
        }

        .form-grid {
            display: grid;
            grid-template-columns: repeat(2, 1fr);
            gap: 15px;
        }

        .form-group {
            display: flex;
            flex-direction: column;
            gap: 6px;
        }

        .form-group.full {
            grid-column: span 2;
        }

        label {
            font-weight: bold;
        }

        input,
        select {
            padding: 11px;
            border: 1px solid #ccc;
            border-radius: 6px;
            font-size: 14px;
        }

        button, .btn {
            margin-top: 20px;
            padding: 11px 20px;
            border: none;
            border-radius: 6px;
            cursor: pointer;
            background: #2563eb;
            color: white;
            font-size: 14px;
            text-decoration: none;
            display: inline-block;
        }

        .btn-success {
            background: #16a34a;
        }
        .btn-success:hover {
            background: #15803d;
        }

        .btn-warning {
            background: #ea580c;
        }
        .btn-warning:hover {
            background: #c2410c;
        }

        .btn-danger {
            background: #dc2626;
        }
        .btn-danger:hover {
            background: #b91c1c;
        }

        .message {
            padding: 12px;
            margin-bottom: 20px;
            border-radius: 6px;
        }

        .error {
            background: #fee2e2;
            color: #991b1b;
        }

        .success {
            background: #dcfce7;
            color: #166534;
        }

        .search-form {
            display: flex;
            gap: 10px;
        }

        .search-form input {
            flex: 1;
        }

        table {
            width: 100%;
            border-collapse: collapse;
            margin-top: 20px;
        }

        th,
        td {
            padding: 12px;
            border-bottom: 1px solid #ddd;
            text-align: left;
        }

        th {
            background: #f5f7fb;
        }

        .action-link {
            color: #2563eb;
            text-decoration: none;
            font-weight: bold;
        }

        .action-link:hover {
            text-decoration: underline;
        }

        .edit-section {
            margin-top: 25px;
            padding-top: 20px;
            border-top: 1px solid #eee;
        }

        .status-badge {
            display: inline-block;
            padding: 4px 10px;
            border-radius: 12px;
            font-size: 12px;
            font-weight: bold;
            text-transform: uppercase;
        }

        .status-SCHEDULED {
            background: #e0f2fe;
            color: #0369a1;
        }

        .status-COMPLETED {
            background: #dcfce7;
            color: #15803d;
        }

        .status-CANCELLED {
            background: #fee2e2;
            color: #b91c1c;
        }

        .status-NO_SHOW {
            background: #fef3c7;
            color: #b45309;
        }

        .status-btn-group {
            display: flex;
            gap: 10px;
            flex-wrap: wrap;
            margin-top: 15px;
        }
    </style>
</head>
<body>

<header class="header">
    <h1>Sunrise Dental - Appointments</h1>
    <a class="back" href="<%= request.getContextPath() %>/dashboard">← Dashboard</a>
</header>

<main class="container">

    <% if (error != null) { %>
        <div class="message error">
            <%= error %>
        </div>
    <% } %>

    <% if ("registered".equals(success)) { %>
        <div class="message success">
            Appointment registered successfully.
        </div>
    <% } else if ("updated".equals(success)) { %>
        <div class="message success">
            Appointment updated successfully.
        </div>
    <% } else if ("status_updated".equals(success)) { %>
        <div class="message success">
            Appointment status updated successfully.
        </div>
    <% } %>

    <!-- REGISTER APPOINTMENT -->
    <div class="card">
        <h2>Register New Appointment</h2>
        <form method="post" action="<%= request.getContextPath() %>/appointments">
            <div class="form-grid">
                <div class="form-group">
                    <label>Appointment Number</label>
                    <input type="text" name="appointmentNumber" required maxlength="20" placeholder="e.g. APP-001">
                </div>

                <div class="form-group">
                    <label>Patient</label>
                    <select name="patientId" required>
                        <option value="">-- Select Patient --</option>
                        <% if (patients != null) { %>
                            <% for (Patient p : patients) { %>
                                <option value="<%= p.getId() %>"><%= p.getFullName() %> (<%= p.getPatientNumber() %>)</option>
                            <% } %>
                        <% } %>
                    </select>
                </div>

                <div class="form-group">
                    <label>Dentist</label>
                    <select name="dentistId" required>
                        <option value="">-- Select Dentist --</option>
                        <% if (dentists != null) { %>
                            <% for (Dentist d : dentists) { %>
                                <option value="<%= d.getId() %>"><%= d.getFullName() %> (<%= d.getSpecialization() %>)</option>
                            <% } %>
                        <% } %>
                    </select>
                </div>

                <div class="form-group">
                    <label>Treatment</label>
                    <select name="treatmentId" required>
                        <option value="">-- Select Treatment --</option>
                        <% if (treatments != null) { %>
                            <% for (Treatment t : treatments) { %>
                                <option value="<%= t.getId() %>"><%= t.getTreatmentName() %> (<%= t.getTreatmentCode() %>)</option>
                            <% } %>
                        <% } %>
                    </select>
                </div>

                <div class="form-group">
                    <label>Appointment Date</label>
                    <input type="date" name="appointmentDate" required>
                </div>

                <div class="form-group">
                    <label>Appointment Time</label>
                    <input type="time" name="appointmentTime" required>
                </div>

                <div class="form-group full">
                    <label>Notes</label>
                    <input type="text" name="notes" maxlength="500" placeholder="Optional notes">
                </div>
            </div>

            <button type="submit">Register Appointment</button>
        </form>
    </div>

    <!-- SEARCH APPOINTMENT -->
    <div class="card">
        <h2>Search Appointment</h2>
        <form class="search-form" method="get" action="<%= request.getContextPath() %>/appointments">
            <input type="text" name="appointmentNumber" placeholder="Enter appointment number" required>
            <button type="submit">Search</button>
        </form>

        <% if (searchedAppointment != null) { %>
            <table>
                <tr>
                    <th>Appointment Number</th>
                    <td><%= searchedAppointment.getAppointmentNumber() %></td>
                </tr>
                <tr>
                    <th>Patient</th>
                    <td><%= patientMap.getOrDefault(searchedAppointment.getPatientId(), "Patient ID: " + searchedAppointment.getPatientId()) %></td>
                </tr>
                <tr>
                    <th>Dentist</th>
                    <td><%= dentistMap.getOrDefault(searchedAppointment.getDentistId(), "Dentist ID: " + searchedAppointment.getDentistId()) %></td>
                </tr>
                <tr>
                    <th>Treatment</th>
                    <td><%= treatmentMap.getOrDefault(searchedAppointment.getTreatmentId(), "Treatment ID: " + searchedAppointment.getTreatmentId()) %></td>
                </tr>
                <tr>
                    <th>Date</th>
                    <td><%= searchedAppointment.getAppointmentDate() %></td>
                </tr>
                <tr>
                    <th>Time</th>
                    <td><%= searchedAppointment.getAppointmentTime() %></td>
                </tr>
                <tr>
                    <th>Status</th>
                    <td>
                        <span class="status-badge status-<%= searchedAppointment.getStatus() %>">
                            <%= searchedAppointment.getStatus() %>
                        </span>
                    </td>
                </tr>
                <tr>
                    <th>Notes</th>
                    <td><%= searchedAppointment.getNotes() != null ? searchedAppointment.getNotes() : "-" %></td>
                </tr>
            </table>

            <!-- QUICK STATUS UPDATE -->
            <div class="edit-section">
                <h3>Update Status</h3>
                <div class="status-btn-group">
                    <form method="post" action="<%= request.getContextPath() %>/appointments" style="display:inline;">
                        <input type="hidden" name="action" value="status">
                        <input type="hidden" name="id" value="<%= searchedAppointment.getId() %>">
                        <input type="hidden" name="status" value="SCHEDULED">
                        <button type="submit" class="btn" style="margin-top:0;">Set SCHEDULED</button>
                    </form>

                    <form method="post" action="<%= request.getContextPath() %>/appointments" style="display:inline;">
                        <input type="hidden" name="action" value="status">
                        <input type="hidden" name="id" value="<%= searchedAppointment.getId() %>">
                        <input type="hidden" name="status" value="COMPLETED">
                        <button type="submit" class="btn btn-success" style="margin-top:0;">Set COMPLETED</button>
                    </form>

                    <form method="post" action="<%= request.getContextPath() %>/appointments" style="display:inline;">
                        <input type="hidden" name="action" value="status">
                        <input type="hidden" name="id" value="<%= searchedAppointment.getId() %>">
                        <input type="hidden" name="status" value="CANCELLED">
                        <button type="submit" class="btn btn-danger" style="margin-top:0;">Set CANCELLED</button>
                    </form>

                    <form method="post" action="<%= request.getContextPath() %>/appointments" style="display:inline;">
                        <input type="hidden" name="action" value="status">
                        <input type="hidden" name="id" value="<%= searchedAppointment.getId() %>">
                        <input type="hidden" name="status" value="NO_SHOW">
                        <button type="submit" class="btn btn-warning" style="margin-top:0;">Set NO SHOW</button>
                    </form>
                </div>
            </div>

            <!-- EDIT DETAILS FORM -->
            <div class="edit-section">
                <h3>Edit Appointment Details</h3>
                <form method="post" action="<%= request.getContextPath() %>/appointments">
                    <input type="hidden" name="action" value="update">
                    <input type="hidden" name="id" value="<%= searchedAppointment.getId() %>">
                    <input type="hidden" name="appointmentNumber" value="<%= searchedAppointment.getAppointmentNumber() %>">

                    <div class="form-grid" style="margin-top: 15px;">
                        <div class="form-group">
                            <label>Patient</label>
                            <select name="patientId" required>
                                <% if (patients != null) { %>
                                    <% for (Patient p : patients) { %>
                                        <option value="<%= p.getId() %>" <%= p.getId().equals(searchedAppointment.getPatientId()) ? "selected" : "" %>>
                                            <%= p.getFullName() %> (<%= p.getPatientNumber() %>)
                                        </option>
                                    <% } %>
                                <% } %>
                            </select>
                        </div>

                        <div class="form-group">
                            <label>Dentist</label>
                            <select name="dentistId" required>
                                <% if (dentists != null) { %>
                                    <% for (Dentist d : dentists) { %>
                                        <option value="<%= d.getId() %>" <%= d.getId().equals(searchedAppointment.getDentistId()) ? "selected" : "" %>>
                                            <%= d.getFullName() %> (<%= d.getSpecialization() %>)
                                        </option>
                                    <% } %>
                                <% } %>
                            </select>
                        </div>

                        <div class="form-group">
                            <label>Treatment</label>
                            <select name="treatmentId" required>
                                <% if (treatments != null) { %>
                                    <% for (Treatment t : treatments) { %>
                                        <option value="<%= t.getId() %>" <%= t.getId().equals(searchedAppointment.getTreatmentId()) ? "selected" : "" %>>
                                            <%= t.getTreatmentName() %> (<%= t.getTreatmentCode() %>)
                                        </option>
                                    <% } %>
                                <% } %>
                            </select>
                        </div>

                        <div class="form-group">
                            <label>Status</label>
                            <select name="status" required>
                                <option value="SCHEDULED" <%= "SCHEDULED".equals(searchedAppointment.getStatus()) ? "selected" : "" %>>SCHEDULED</option>
                                <option value="COMPLETED" <%= "COMPLETED".equals(searchedAppointment.getStatus()) ? "selected" : "" %>>COMPLETED</option>
                                <option value="CANCELLED" <%= "CANCELLED".equals(searchedAppointment.getStatus()) ? "selected" : "" %>>CANCELLED</option>
                                <option value="NO_SHOW" <%= "NO_SHOW".equals(searchedAppointment.getStatus()) ? "selected" : "" %>>NO SHOW</option>
                            </select>
                        </div>

                        <div class="form-group">
                            <label>Appointment Date</label>
                            <input type="date" name="appointmentDate" value="<%= searchedAppointment.getAppointmentDate() %>" required>
                        </div>

                        <div class="form-group">
                            <label>Appointment Time</label>
                            <input type="time" name="appointmentTime" value="<%= searchedAppointment.getAppointmentTime() %>" required>
                        </div>

                        <div class="form-group full">
                            <label>Notes</label>
                            <input type="text" name="notes" value="<%= searchedAppointment.getNotes() != null ? searchedAppointment.getNotes() : "" %>" maxlength="500">
                        </div>
                    </div>

                    <button type="submit">Update Appointment</button>
                </form>
            </div>

        <% } else if (request.getParameter("appointmentNumber") != null) { %>
            <div class="message error" style="margin-top: 20px;">
                No appointment found with that appointment number.
            </div>
        <% } %>
    </div>

    <!-- APPOINTMENTS LIST -->
    <% if (appointments != null) { %>
        <div class="card">
            <h2>All Appointments</h2>
            <table>
                <thead>
                <tr>
                    <th>Appointment #</th>
                    <th>Patient</th>
                    <th>Dentist</th>
                    <th>Treatment</th>
                    <th>Date</th>
                    <th>Time</th>
                    <th>Status</th>
                    <th>Actions</th>
                </tr>
                </thead>
                <tbody>
                <% for (Appointment a : appointments) { %>
                    <tr>
                        <td><%= a.getAppointmentNumber() %></td>
                        <td><%= patientMap.getOrDefault(a.getPatientId(), "ID: " + a.getPatientId()) %></td>
                        <td><%= dentistMap.getOrDefault(a.getDentistId(), "ID: " + a.getDentistId()) %></td>
                        <td><%= treatmentMap.getOrDefault(a.getTreatmentId(), "ID: " + a.getTreatmentId()) %></td>
                        <td><%= a.getAppointmentDate() %></td>
                        <td><%= a.getAppointmentTime() %></td>
                        <td>
                            <span class="status-badge status-<%= a.getStatus() %>">
                                <%= a.getStatus() %>
                            </span>
                        </td>
                        <td>
                            <a class="action-link" href="<%= request.getContextPath() %>/appointments?appointmentNumber=<%= a.getAppointmentNumber() %>">
                                View / Edit
                            </a>
                        </td>
                    </tr>
                <% } %>
                </tbody>
            </table>
        </div>
    <% } %>

</main>

</body>
</html>