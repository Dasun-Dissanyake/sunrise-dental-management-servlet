<%@ page contentType="text/html;charset=UTF-8" %>

<%@ page import="java.util.List" %>
<%@ page import="com.sunrisedental.model.Patient" %>

<%
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

    <meta name="viewport"
          content="width=device-width, initial-scale=1.0">

    <title>Patients - Sunrise Dental</title>

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

        button {
            margin-top: 20px;
            padding: 11px 20px;
            border: none;
            border-radius: 6px;
            cursor: pointer;
            background: #2563eb;
            color: white;
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

    </style>

</head>

<body>

<header class="header">

    <h1>Sunrise Dental - Patients</h1>

    <a class="back"
       href="<%= request.getContextPath() %>/dashboard">
        ← Dashboard
    </a>

</header>


<main class="container">

    <% if (error != null) { %>

        <div class="message error">
            <%= error %>
        </div>

    <% } %>


    <% if ("registered".equals(success)) { %>

        <div class="message success">
            Patient registered successfully.
        </div>

    <% } %>


    <!-- REGISTER PATIENT -->

    <div class="card">

        <h2>Register New Patient</h2>

        <form method="post"
              action="<%= request.getContextPath() %>/patients">

            <div class="form-grid">

                <div class="form-group">

                    <label>
                        Patient Number
                    </label>

                    <input
                            type="text"
                            name="patientNumber"
                            required
                            maxlength="20"
                            placeholder="e.g. P001">

                </div>


                <div class="form-group">

                    <label>
                        Full Name
                    </label>

                    <input
                            type="text"
                            name="fullName"
                            required
                            maxlength="100">

                </div>


                <div class="form-group full">

                    <label>
                        Address
                    </label>

                    <input
                            type="text"
                            name="address"
                            required
                            maxlength="255">

                </div>


                <div class="form-group">

                    <label>
                        Contact Number
                    </label>

                    <input
                            type="tel"
                            name="contactNumber"
                            required
                            maxlength="20">

                </div>


                <div class="form-group">

                    <label>
                        Date of Birth
                    </label>

                    <input
                            type="date"
                            name="dateOfBirth">

                </div>


                <div class="form-group">

                    <label>
                        Email
                    </label>

                    <input
                            type="email"
                            name="email"
                            maxlength="100">

                </div>


                <div class="form-group">

                    <label>
                        Gender
                    </label>

                    <select name="gender">

                        <option value="">
                            Select Gender
                        </option>

                        <option value="Male">
                            Male
                        </option>

                        <option value="Female">
                            Female
                        </option>

                        <option value="Other">
                            Other
                        </option>

                    </select>

                </div>

            </div>

            <button type="submit">
                Register Patient
            </button>

        </form>

    </div>


    <!-- SEARCH -->

    <div class="card">

        <h2>Search Patient</h2>

        <form class="search-form"
              method="get"
              action="<%= request.getContextPath() %>/patients">

            <input
                    type="text"
                    name="patientNumber"
                    placeholder="Enter patient number"
                    required>

            <button type="submit">
                Search
            </button>

        </form>


        <% if (searchedPatient != null) { %>

            <table>

                <tr>
                    <th>Patient Number</th>
                    <td>
                        <%= searchedPatient.getPatientNumber() %>
                    </td>
                </tr>

                <tr>
                    <th>Name</th>
                    <td>
                        <%= searchedPatient.getFullName() %>
                    </td>
                </tr>

                <tr>
                    <th>Address</th>
                    <td>
                        <%= searchedPatient.getAddress() %>
                    </td>
                </tr>

                <tr>
                    <th>Contact</th>
                    <td>
                        <%= searchedPatient.getContactNumber() %>
                    </td>
                </tr>

                <tr>
                    <th>Email</th>
                    <td>
                        <%= searchedPatient.getEmail() %>
                    </td>
                </tr>

                <tr>
                    <th>Gender</th>
                    <td>
                        <%= searchedPatient.getGender() %>
                    </td>
                </tr>

            </table>

        <% } else if (request.getParameter("patientNumber") != null) { %>

            <div class="message error">
                No patient found with that patient number.
            </div>

        <% } %>

    </div>


    <!-- PATIENT LIST -->

    <% if (patients != null) { %>

        <div class="card">

            <h2>Registered Patients</h2>

            <table>

                <thead>

                <tr>
                    <th>Patient Number</th>
                    <th>Name</th>
                    <th>Contact</th>
                    <th>Email</th>
                    <th>Gender</th>
                </tr>

                </thead>

                <tbody>

                <% for (Patient patient : patients) { %>

                    <tr>

                        <td>
                            <%= patient.getPatientNumber() %>
                        </td>

                        <td>
                            <%= patient.getFullName() %>
                        </td>

                        <td>
                            <%= patient.getContactNumber() %>
                        </td>

                        <td>
                            <%= patient.getEmail() %>
                        </td>

                        <td>
                            <%= patient.getGender() %>
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