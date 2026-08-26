<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="java.util.List" %>
<%@ page import="com.sunrisedental.model.Patient" %>
<%@ page import="com.sunrisedental.model.User" %>

<%
    User user = (User) session.getAttribute("loggedInUser");
    if (user == null) {
        user = (User) request.getAttribute("user");
    }

    List<Patient> patients =
            (List<Patient>) request.getAttribute("patients");

    Patient searchedPatient =
            (Patient) request.getAttribute("searchedPatient");

    String error =
            (String) request.getAttribute("error");

    String success =
            request.getParameter("success");
%>

<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Patients - Sunrise Dental</title>
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
        <a class="nav-link active" href="<%= request.getContextPath() %>/patients">Patients</a>
        <a class="nav-link" href="<%= request.getContextPath() %>/dentists">Dentists</a>
        <a class="nav-link" href="<%= request.getContextPath() %>/treatments">Treatments</a>
        <a class="nav-link" href="<%= request.getContextPath() %>/bills">Billing</a>
        <a class="nav-link" href="<%= request.getContextPath() %>/reports">Reports</a>
        <a class="nav-link" href="<%= request.getContextPath() %>/help">Help</a>
    </div>
</nav>

<main class="container">

    <div class="page-header">
        <div class="page-header-text">
            <h1>Patients</h1>
            <p>Manage patient information and registered patient records.</p>
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
            Patient registered successfully.
        </div>
    <% } else if ("updated".equals(success)) { %>
        <div class="message success">
            Patient updated successfully.
        </div>
    <% } %>

    <!-- REGISTER PATIENT -->
    <div class="card">
        <div class="card-header">
            <div>
                <h2 class="card-title">Register New Patient</h2>
                <p class="card-subtitle">Enter identification, personal, and contact details to enroll a patient.</p>
            </div>
        </div>

        <form method="post" action="<%= request.getContextPath() %>/patients">
            <div class="form-grid">
                <div class="form-group">
                    <label for="patientNumber">Patient Number <span class="required-indicator">*</span></label>
                    <input
                        type="text"
                        id="patientNumber"
                        name="patientNumber"
                        required
                        maxlength="20"
                        placeholder="e.g. PAT-001"
                    >
                </div>

                <div class="form-group">
                    <label for="fullName">Full Name <span class="required-indicator">*</span></label>
                    <input
                        type="text"
                        id="fullName"
                        name="fullName"
                        required
                        maxlength="100"
                        placeholder="Enter full name"
                    >
                </div>

                <div class="form-group">
                    <label for="contactNumber">Contact Number <span class="required-indicator">*</span></label>
                    <input
                        type="tel"
                        id="contactNumber"
                        name="contactNumber"
                        required
                        maxlength="20"
                        placeholder="e.g. 0771234567"
                    >
                </div>

                <div class="form-group">
                    <label for="dateOfBirth">Date of Birth</label>
                    <input
                        type="date"
                        id="dateOfBirth"
                        name="dateOfBirth"
                    >
                </div>

                <div class="form-group">
                    <label for="email">Email Address</label>
                    <input
                        type="email"
                        id="email"
                        name="email"
                        maxlength="100"
                        placeholder="e.g. patient@example.com"
                    >
                </div>

                <div class="form-group">
                    <label for="gender">Gender</label>
                    <select id="gender" name="gender">
                        <option value="">-- Select Gender --</option>
                        <option value="Male">Male</option>
                        <option value="Female">Female</option>
                        <option value="Other">Other</option>
                    </select>
                </div>

                <div class="form-group full">
                    <label for="address">Residential Address <span class="required-indicator">*</span></label>
                    <input
                        type="text"
                        id="address"
                        name="address"
                        required
                        maxlength="255"
                        placeholder="Enter street, city, and postal code"
                    >
                </div>
            </div>

            <div class="form-actions">
                <button type="submit" class="btn btn-primary">Register Patient</button>
            </div>
        </form>
    </div>

    <!-- SEARCH PATIENT -->
    <div class="card">
        <div class="card-header">
            <div>
                <h2 class="card-title">Search Patient</h2>
                <p class="card-subtitle">Find registered patient records by patient number.</p>
            </div>
        </div>

        <form class="search-form" method="get" action="<%= request.getContextPath() %>/patients">
            <input
                type="text"
                name="patientNumber"
                placeholder="Enter patient number (e.g. PAT-001)"
                required
            >
            <button type="submit" class="btn btn-dark">Search Patient</button>
        </form>

        <% if (searchedPatient != null) { %>
            <div style="margin-top: 24px;">
                <div class="details-grid">
                    <div class="detail-box">
                        <div class="detail-label">Patient Number</div>
                        <div class="detail-value"><%= searchedPatient.getPatientNumber() %></div>
                    </div>
                    <div class="detail-box">
                        <div class="detail-label">Full Name</div>
                        <div class="detail-value"><%= searchedPatient.getFullName() %></div>
                    </div>
                    <div class="detail-box">
                        <div class="detail-label">Contact Number</div>
                        <div class="detail-value"><%= searchedPatient.getContactNumber() %></div>
                    </div>
                    <div class="detail-box">
                        <div class="detail-label">Date of Birth</div>
                        <div class="detail-value"><%= searchedPatient.getDateOfBirth() != null ? searchedPatient.getDateOfBirth() : "-" %></div>
                    </div>
                    <div class="detail-box">
                        <div class="detail-label">Email</div>
                        <div class="detail-value" style="font-size: 14px;"><%= searchedPatient.getEmail() != null && !searchedPatient.getEmail().isEmpty() ? searchedPatient.getEmail() : "-" %></div>
                    </div>
                    <div class="detail-box">
                        <div class="detail-label">Gender</div>
                        <div class="detail-value"><%= searchedPatient.getGender() != null && !searchedPatient.getGender().isEmpty() ? searchedPatient.getGender() : "-" %></div>
                    </div>
                    <div class="detail-box full" style="grid-column: 1 / -1;">
                        <div class="detail-label">Address</div>
                        <div class="detail-value" style="font-weight: 500; font-size: 14px;"><%= searchedPatient.getAddress() != null ? searchedPatient.getAddress() : "-" %></div>
                    </div>
                </div>
            </div>
        <% } else if (request.getParameter("patientNumber") != null) { %>
            <div class="message error" style="margin-top: 20px; margin-bottom: 0;">
                No patient found with that patient number.
            </div>
        <% } %>
    </div>

    <!-- REGISTERED PATIENTS TABLE -->
    <% if (patients != null) { %>
        <div class="card">
            <div class="card-header">
                <div>
                    <h2 class="card-title">Registered Patients Directory</h2>
                    <p class="card-subtitle">All active patient profiles enrolled in the clinic database.</p>
                </div>
            </div>

            <% if (patients.isEmpty()) { %>
                <div class="empty-state">
                    No patients registered in the system.
                </div>
            <% } else { %>
                <div class="table-container">
                    <table class="app-table">
                        <thead>
                        <tr>
                            <th>Patient #</th>
                            <th>Full Name</th>
                            <th>Contact</th>
                            <th>Date of Birth</th>
                            <th>Gender</th>
                            <th>Address</th>
                            <th>Email</th>
                        </tr>
                        </thead>
                        <tbody>
                        <% for (Patient p : patients) { %>
                            <tr>
                                <td class="code-highlight"><%= p.getPatientNumber() %></td>
                                <td style="font-weight: 600;"><%= p.getFullName() %></td>
                                <td><%= p.getContactNumber() %></td>
                                <td><%= p.getDateOfBirth() != null ? p.getDateOfBirth() : "-" %></td>
                                <td><%= p.getGender() != null && !p.getGender().isEmpty() ? p.getGender() : "-" %></td>
                                <td style="color: var(--muted); max-width: 200px; white-space: normal;"><%= p.getAddress() != null ? p.getAddress() : "-" %></td>
                                <td><%= p.getEmail() != null && !p.getEmail().isEmpty() ? p.getEmail() : "-" %></td>
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