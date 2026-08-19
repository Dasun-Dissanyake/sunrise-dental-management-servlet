<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="java.util.List" %>
<%@ page import="com.sunrisedental.model.Dentist" %>

<%
    List<Dentist> dentists = (List<Dentist>) request.getAttribute("dentists");
    Dentist searchedDentist = (Dentist) request.getAttribute("searchedDentist");
    String error = (String) request.getAttribute("error");
    String success = request.getParameter("success");
    String errorParam = request.getParameter("error");
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Dentists - Sunrise Dental</title>
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

        .actions-row {
            display: flex;
            gap: 15px;
            align-items: center;
        }
    </style>
</head>
<body>

<header class="header">
    <h1>Sunrise Dental - Dentists</h1>
    <a class="back" href="<%= request.getContextPath() %>/dashboard">← Dashboard</a>
</header>

<main class="container">

    <% if (error != null) { %>
        <div class="message error">
            <%= error %>
        </div>
    <% } %>

    <% if ("invalid".equals(errorParam)) { %>
        <div class="message error">
            Invalid dentist information provided.
        </div>
    <% } else if ("notfound".equals(errorParam)) { %>
        <div class="message error">
            Dentist record not found.
        </div>
    <% } %>

    <% if ("registered".equals(success)) { %>
        <div class="message success">
            Dentist registered successfully.
        </div>
    <% } else if ("updated".equals(success)) { %>
        <div class="message success">
            Dentist updated successfully.
        </div>
    <% } else if ("deactivated".equals(success)) { %>
        <div class="message success">
            Dentist deactivated successfully.
        </div>
    <% } %>

    <!-- REGISTER DENTIST -->
    <div class="card">
        <h2>Register New Dentist</h2>
        <form method="post" action="<%= request.getContextPath() %>/dentists">
            <div class="form-grid">
                <div class="form-group">
                    <label>Dentist Number</label>
                    <input type="text" name="dentistNumber" required maxlength="20" placeholder="e.g. D001">
                </div>

                <div class="form-group">
                    <label>Full Name</label>
                    <input type="text" name="fullName" required maxlength="100" placeholder="e.g. Dr. John Silva">
                </div>

                <div class="form-group">
                    <label>Specialization</label>
                    <input type="text" name="specialization" required maxlength="100" placeholder="e.g. General Dentistry">
                </div>

                <div class="form-group">
                    <label>Contact Number</label>
                    <input type="tel" name="contactNumber" required maxlength="20" placeholder="e.g. 0771234567">
                </div>
            </div>

            <button type="submit">Register Dentist</button>
        </form>
    </div>

    <!-- SEARCH DENTIST -->
    <div class="card">
        <h2>Search Dentist</h2>
        <form class="search-form" method="get" action="<%= request.getContextPath() %>/dentists">
            <input type="text" name="dentistNumber" placeholder="Enter dentist number" required>
            <button type="submit">Search</button>
        </form>

        <% if (searchedDentist != null) { %>
            <table>
                <tr>
                    <th>Dentist Number</th>
                    <td><%= searchedDentist.getDentistNumber() %></td>
                </tr>
                <tr>
                    <th>Full Name</th>
                    <td><%= searchedDentist.getFullName() %></td>
                </tr>
                <tr>
                    <th>Specialization</th>
                    <td><%= searchedDentist.getSpecialization() %></td>
                </tr>
                <tr>
                    <th>Contact Number</th>
                    <td><%= searchedDentist.getContactNumber() %></td>
                </tr>
                <tr>
                    <th>Status</th>
                    <td><%= searchedDentist.isActive() ? "Active" : "Inactive" %></td>
                </tr>
            </table>

            <div class="edit-section">
                <h3>Update Dentist Details</h3>
                <form method="post" action="<%= request.getContextPath() %>/dentists">
                    <input type="hidden" name="action" value="update">
                    <input type="hidden" name="id" value="<%= searchedDentist.getId() %>">

                    <div class="form-grid" style="margin-top: 15px;">
                        <div class="form-group">
                            <label>Full Name</label>
                            <input type="text" name="fullName" value="<%= searchedDentist.getFullName() %>" required maxlength="100">
                        </div>

                        <div class="form-group">
                            <label>Specialization</label>
                            <input type="text" name="specialization" value="<%= searchedDentist.getSpecialization() %>" required maxlength="100">
                        </div>

                        <div class="form-group">
                            <label>Contact Number</label>
                            <input type="tel" name="contactNumber" value="<%= searchedDentist.getContactNumber() %>" required maxlength="20">
                        </div>
                    </div>

                    <div class="actions-row">
                        <button type="submit">Update Dentist</button>
                    </div>
                </form>

                <form method="post" action="<%= request.getContextPath() %>/dentists" style="margin-top: 10px;" onsubmit="return confirm('Are you sure you want to deactivate this dentist?');">
                    <input type="hidden" name="action" value="deactivate">
                    <input type="hidden" name="id" value="<%= searchedDentist.getId() %>">
                    <button type="submit" class="btn btn-danger">Deactivate Dentist</button>
                </form>
            </div>

        <% } else if (request.getParameter("dentistNumber") != null) { %>
            <div class="message error" style="margin-top: 20px;">
                No dentist found with that dentist number.
            </div>
        <% } %>
    </div>

    <!-- ACTIVE DENTISTS LIST -->
    <% if (dentists != null) { %>
        <div class="card">
            <h2>Active Dentists</h2>
            <table>
                <thead>
                <tr>
                    <th>Dentist Number</th>
                    <th>Full Name</th>
                    <th>Specialization</th>
                    <th>Contact Number</th>
                    <th>Actions</th>
                </tr>
                </thead>
                <tbody>
                <% for (Dentist dentist : dentists) { %>
                    <tr>
                        <td><%= dentist.getDentistNumber() %></td>
                        <td><%= dentist.getFullName() %></td>
                        <td><%= dentist.getSpecialization() %></td>
                        <td><%= dentist.getContactNumber() %></td>
                        <td>
                            <a class="action-link" href="<%= request.getContextPath() %>/dentists?dentistNumber=<%= dentist.getDentistNumber() %>">
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