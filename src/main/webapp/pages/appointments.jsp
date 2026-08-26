<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.Map" %>
<%@ page import="java.util.HashMap" %>
<%@ page import="com.sunrisedental.model.Appointment" %>
<%@ page import="com.sunrisedental.model.Patient" %>
<%@ page import="com.sunrisedental.model.Dentist" %>
<%@ page import="com.sunrisedental.model.Treatment" %>
<%@ page import="com.sunrisedental.model.User" %>

<%
    User user = (User) session.getAttribute("loggedInUser");
    if (user == null) {
        user = (User) request.getAttribute("user");
    }

    List<Appointment> appointments = (List<Appointment>) request.getAttribute("appointments");
    Appointment searchedAppointment = (Appointment) request.getAttribute("searchedAppointment");
    List<Patient> patients = (List<Patient>) request.getAttribute("patients");
    List<Dentist> dentists = (List<Dentist>) request.getAttribute("dentists");
    List<Treatment> treatments = (List<Treatment>) request.getAttribute("treatments");
    String error = (String) request.getAttribute("error");
    String success = request.getParameter("success");

    Map<Long, String> patientMap = new HashMap<>();
    Map<Long, Patient> patientObjMap = new HashMap<>();
    if (patients != null) {
        for (Patient p : patients) {
            patientMap.put(p.getId(), p.getFullName() + " (" + p.getPatientNumber() + ")");
            patientObjMap.put(p.getId(), p);
        }
    }

    Map<Long, String> dentistMap = new HashMap<>();
    Map<Long, Dentist> dentistObjMap = new HashMap<>();
    if (dentists != null) {
        for (Dentist d : dentists) {
            dentistMap.put(d.getId(), d.getFullName() + " (" + d.getSpecialization() + ")");
            dentistObjMap.put(d.getId(), d);
        }
    }

    Map<Long, String> treatmentMap = new HashMap<>();
    Map<Long, Treatment> treatmentObjMap = new HashMap<>();
    if (treatments != null) {
        for (Treatment t : treatments) {
            treatmentMap.put(t.getId(), t.getTreatmentName() + " (" + t.getTreatmentCode() + ")");
            treatmentObjMap.put(t.getId(), t);
        }
    }
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Appointments - Sunrise Dental</title>
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
        <a class="nav-link active" href="<%= request.getContextPath() %>/appointments">Appointments</a>
        <a class="nav-link" href="<%= request.getContextPath() %>/patients">Patients</a>
        <a class="nav-link" href="<%= request.getContextPath() %>/dentists">Dentists</a>
        <a class="nav-link" href="<%= request.getContextPath() %>/treatments">Treatments</a>
        <a class="nav-link" href="<%= request.getContextPath() %>/bills">Billing</a>
        <a class="nav-link" href="<%= request.getContextPath() %>/reports">Reports</a>
        <a class="nav-link" href="<%= request.getContextPath() %>/help">Help</a>
        <% if (user != null && "ADMIN".equalsIgnoreCase(user.getRole())) { %>
            <a class="nav-link" href="<%= request.getContextPath() %>/users">User Management</a>
        <% } %>
    </div>
</nav>

<main class="container">

    <div class="page-header">
        <div class="page-header-text">
            <h1>Appointments</h1>
            <p>Schedule and manage patient appointments.</p>
        </div>
        <div class="page-header-actions">
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
        <div class="card-header">
            <div>
                <h2 class="card-title">Schedule New Appointment</h2>
                <p class="card-subtitle">Select patient, dentist, and treatment procedure to book a session.</p>
            </div>
        </div>

        <form method="post" action="<%= request.getContextPath() %>/appointments">
            <div class="form-grid">
                <div class="form-group">
                    <label for="appointmentNumber">Appointment Number <span class="required-indicator">*</span></label>
                    <input
                        type="text"
                        id="appointmentNumber"
                        name="appointmentNumber"
                        required
                        maxlength="20"
                        placeholder="e.g. APP-001"
                    >
                </div>

                <div class="form-group">
                    <label for="patientId">Patient <span class="required-indicator">*</span></label>
                    <select id="patientId" name="patientId" required>
                        <option value="">-- Select Patient --</option>
                        <% if (patients != null) { %>
                            <% for (Patient p : patients) { %>
                                <option value="<%= p.getId() %>"><%= p.getFullName() %> (<%= p.getPatientNumber() %>)</option>
                            <% } %>
                        <% } %>
                    </select>
                </div>

                <div class="form-group">
                    <label for="dentistId">Dentist <span class="required-indicator">*</span></label>
                    <select id="dentistId" name="dentistId" required>
                        <option value="">-- Select Dentist --</option>
                        <% if (dentists != null) { %>
                            <% for (Dentist d : dentists) { %>
                                <option value="<%= d.getId() %>"><%= d.getFullName() %> (<%= d.getSpecialization() %>)</option>
                            <% } %>
                        <% } %>
                    </select>
                </div>

                <div class="form-group">
                    <label for="treatmentId">Treatment <span class="required-indicator">*</span></label>
                    <select id="treatmentId" name="treatmentId" required>
                        <option value="">-- Select Treatment --</option>
                        <% if (treatments != null) { %>
                            <% for (Treatment t : treatments) { %>
                                <option value="<%= t.getId() %>"><%= t.getTreatmentName() %> (<%= t.getTreatmentCode() %>)</option>
                            <% } %>
                        <% } %>
                    </select>
                </div>

                <div class="form-group">
                    <label for="appointmentDate">Appointment Date <span class="required-indicator">*</span></label>
                    <input type="date" id="appointmentDate" name="appointmentDate" required>
                </div>

                <div class="form-group">
                    <label for="appointmentTime">Appointment Time <span class="required-indicator">*</span></label>
                    <input type="time" id="appointmentTime" name="appointmentTime" required>
                </div>

                <div class="form-group full">
                    <label for="notes">Clinical Notes</label>
                    <input
                        type="text"
                        id="notes"
                        name="notes"
                        maxlength="500"
                        placeholder="Optional clinical or consultation notes"
                    >
                </div>
            </div>

            <div class="form-actions">
                <button type="submit" class="btn btn-primary">Schedule Appointment</button>
            </div>
        </form>
    </div>

    <!-- SEARCH APPOINTMENT -->
    <div class="card">
        <div class="card-header">
            <div>
                <h2 class="card-title">Search Appointment</h2>
                <p class="card-subtitle">Lookup appointment by unique code to manage or change status.</p>
            </div>
        </div>

        <form class="search-form" method="get" action="<%= request.getContextPath() %>/appointments">
            <input
                type="text"
                name="appointmentNumber"
                placeholder="Enter appointment number (e.g. APP-001)"
                required
            >
            <button type="submit" class="btn btn-dark">Search Appointment</button>
        </form>

        <% if (searchedAppointment != null) {
            Patient searchedPatientObj = patientObjMap.get(searchedAppointment.getPatientId());
            Dentist searchedDentistObj = dentistObjMap.get(searchedAppointment.getDentistId());
            Treatment searchedTreatmentObj = treatmentObjMap.get(searchedAppointment.getTreatmentId());
        %>
            <div style="margin-top: 24px;">
                <div class="details-grid">
                    <div class="detail-box">
                        <div class="detail-label">Appointment Number</div>
                        <div class="detail-value"><%= searchedAppointment.getAppointmentNumber() %></div>
                    </div>
                    <div class="detail-box">
                        <div class="detail-label">Patient Name</div>
                        <div class="detail-value"><%= searchedPatientObj != null ? searchedPatientObj.getFullName() : ("ID: " + searchedAppointment.getPatientId()) %></div>
                    </div>
                    <div class="detail-box">
                        <div class="detail-label">Patient Number</div>
                        <div class="detail-value"><%= searchedPatientObj != null ? searchedPatientObj.getPatientNumber() : "-" %></div>
                    </div>
                    <div class="detail-box">
                        <div class="detail-label">Contact Number</div>
                        <div class="detail-value"><%= searchedPatientObj != null && searchedPatientObj.getContactNumber() != null ? searchedPatientObj.getContactNumber() : "-" %></div>
                    </div>
                    <div class="detail-box">
                        <div class="detail-label">Dentist</div>
                        <div class="detail-value"><%= searchedDentistObj != null ? searchedDentistObj.getFullName() + " (" + searchedDentistObj.getSpecialization() + ")" : ("ID: " + searchedAppointment.getDentistId()) %></div>
                    </div>
                    <div class="detail-box">
                        <div class="detail-label">Treatment</div>
                        <div class="detail-value"><%= searchedTreatmentObj != null ? searchedTreatmentObj.getTreatmentName() + " (" + searchedTreatmentObj.getTreatmentCode() + ")" : ("ID: " + searchedAppointment.getTreatmentId()) %></div>
                    </div>
                    <div class="detail-box">
                        <div class="detail-label">Date &amp; Time</div>
                        <div class="detail-value"><%= searchedAppointment.getAppointmentDate() %> at <%= searchedAppointment.getAppointmentTime() %></div>
                    </div>
                    <div class="detail-box">
                        <div class="detail-label">Current Status</div>
                        <div class="detail-value">
                            <span class="status status-<%= searchedAppointment.getStatus() %>">
                                <%= searchedAppointment.getStatus() %>
                            </span>
                        </div>
                    </div>
                    <div class="detail-box full" style="grid-column: 1 / -1;">
                        <div class="detail-label">Patient Residential Address</div>
                        <div class="detail-value" style="font-weight: 500; font-size: 13px;">
                            <%= searchedPatientObj != null && searchedPatientObj.getAddress() != null ? searchedPatientObj.getAddress() : "-" %>
                        </div>
                    </div>
                    <div class="detail-box full" style="grid-column: 1 / -1;">
                        <div class="detail-label">Clinical Notes</div>
                        <div class="detail-value" style="font-weight: 500; font-size: 13px;">
                            <%= searchedAppointment.getNotes() != null && !searchedAppointment.getNotes().isEmpty() ? searchedAppointment.getNotes() : "No notes recorded" %>
                        </div>
                    </div>
                </div>

                <!-- QUICK STATUS UPDATE -->
                <div class="edit-section">
                    <h3>Quick Status Update</h3>
                    <div class="status-btn-group">
                        <form method="post" action="<%= request.getContextPath() %>/appointments">
                            <input type="hidden" name="action" value="status">
                            <input type="hidden" name="id" value="<%= searchedAppointment.getId() %>">
                            <input type="hidden" name="status" value="SCHEDULED">
                            <button type="submit" class="btn btn-secondary btn-sm">Set SCHEDULED</button>
                        </form>

                        <form method="post" action="<%= request.getContextPath() %>/appointments">
                            <input type="hidden" name="action" value="status">
                            <input type="hidden" name="id" value="<%= searchedAppointment.getId() %>">
                            <input type="hidden" name="status" value="COMPLETED">
                            <button type="submit" class="btn btn-success btn-sm">Set COMPLETED</button>
                        </form>

                        <form method="post" action="<%= request.getContextPath() %>/appointments">
                            <input type="hidden" name="action" value="status">
                            <input type="hidden" name="id" value="<%= searchedAppointment.getId() %>">
                            <input type="hidden" name="status" value="CANCELLED">
                            <button type="submit" class="btn btn-danger btn-sm">Set CANCELLED</button>
                        </form>

                        <form method="post" action="<%= request.getContextPath() %>/appointments">
                            <input type="hidden" name="action" value="status">
                            <input type="hidden" name="id" value="<%= searchedAppointment.getId() %>">
                            <input type="hidden" name="status" value="NO_SHOW">
                            <button type="submit" class="btn btn-warning btn-sm">Set NO SHOW</button>
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

                        <div class="form-grid">
                            <div class="form-group">
                                <label for="editPatientId">Patient <span class="required-indicator">*</span></label>
                                <select id="editPatientId" name="patientId" required>
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
                                <label for="editDentistId">Dentist <span class="required-indicator">*</span></label>
                                <select id="editDentistId" name="dentistId" required>
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
                                <label for="editTreatmentId">Treatment <span class="required-indicator">*</span></label>
                                <select id="editTreatmentId" name="treatmentId" required>
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
                                <label for="editStatus">Status <span class="required-indicator">*</span></label>
                                <select id="editStatus" name="status" required>
                                    <option value="SCHEDULED" <%= "SCHEDULED".equals(searchedAppointment.getStatus()) ? "selected" : "" %>>SCHEDULED</option>
                                    <option value="COMPLETED" <%= "COMPLETED".equals(searchedAppointment.getStatus()) ? "selected" : "" %>>COMPLETED</option>
                                    <option value="CANCELLED" <%= "CANCELLED".equals(searchedAppointment.getStatus()) ? "selected" : "" %>>CANCELLED</option>
                                    <option value="NO_SHOW" <%= "NO_SHOW".equals(searchedAppointment.getStatus()) ? "selected" : "" %>>NO SHOW</option>
                                </select>
                            </div>

                            <div class="form-group">
                                <label for="editAppointmentDate">Appointment Date <span class="required-indicator">*</span></label>
                                <input
                                    type="date"
                                    id="editAppointmentDate"
                                    name="appointmentDate"
                                    value="<%= searchedAppointment.getAppointmentDate() %>"
                                    required
                                >
                            </div>

                            <div class="form-group">
                                <label for="editAppointmentTime">Appointment Time <span class="required-indicator">*</span></label>
                                <input
                                    type="time"
                                    id="editAppointmentTime"
                                    name="appointmentTime"
                                    value="<%= searchedAppointment.getAppointmentTime() %>"
                                    required
                                >
                            </div>

                            <div class="form-group full">
                                <label for="editNotes">Clinical Notes</label>
                                <input
                                    type="text"
                                    id="editNotes"
                                    name="notes"
                                    value="<%= searchedAppointment.getNotes() != null ? searchedAppointment.getNotes() : "" %>"
                                    maxlength="500"
                                >
                            </div>
                        </div>

                        <div class="form-actions">
                            <button type="submit" class="btn btn-primary">Update Appointment</button>
                        </div>
                    </form>
                </div>
            </div>

        <% } else if (request.getParameter("appointmentNumber") != null) { %>
            <div class="message error" style="margin-top: 20px; margin-bottom: 0;">
                No appointment found with that appointment number.
            </div>
        <% } %>
    </div>

    <!-- APPOINTMENTS LIST -->
    <% if (appointments != null) { %>
        <div class="card">
            <div class="card-header">
                <div>
                    <h2 class="card-title">All Clinic Appointments</h2>
                    <p class="card-subtitle">Complete schedule of scheduled and completed dental appointments.</p>
                </div>
            </div>

            <% if (appointments.isEmpty()) { %>
                <div class="empty-state">
                    No appointments found in the system.
                </div>
            <% } else { %>
                <div class="table-container">
                    <table class="app-table">
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
                                <td class="code-highlight"><%= a.getAppointmentNumber() %></td>
                                <td><%= patientMap.getOrDefault(a.getPatientId(), "ID: " + a.getPatientId()) %></td>
                                <td><%= dentistMap.getOrDefault(a.getDentistId(), "ID: " + a.getDentistId()) %></td>
                                <td><%= treatmentMap.getOrDefault(a.getTreatmentId(), "ID: " + a.getTreatmentId()) %></td>
                                <td><%= a.getAppointmentDate() %></td>
                                <td><%= a.getAppointmentTime() %></td>
                                <td>
                                    <span class="status status-<%= a.getStatus() %>">
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
        </div>
    <% } %>

</main>

<footer class="footer">
    Sunrise Dental Management System &bull; Professional Dental Care &amp; Clinical Operations
</footer>

</body>
</html>