<%@ page contentType="text/html;charset=UTF-8" %>

<%@ page import="java.util.List" %>
<%@ page import="com.sunrisedental.model.Treatment" %>

<%
    List<Treatment> treatments =
            (List<Treatment>) request.getAttribute("treatments");

    Treatment searchedTreatment =
            (Treatment) request.getAttribute("searchedTreatment");
%>

<!DOCTYPE html>
<html lang="en">

<head>

    <meta charset="UTF-8">

    <meta name="viewport"
          content="width=device-width, initial-scale=1.0">

    <title>Treatments - Sunrise Dental</title>

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

        .search-form {
            display: flex;
            gap: 10px;
        }

        .search-form input {
            flex: 1;
            padding: 11px;
            border: 1px solid #ccc;
            border-radius: 6px;
            font-size: 14px;
        }

        button {
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

        .price {
            font-weight: bold;
        }

        .status {
            display: inline-block;
            padding: 5px 10px;
            border-radius: 20px;
            background: #dcfce7;
            color: #166534;
            font-size: 13px;
        }

        .details-table {
            margin-top: 0;
        }

        .details-table th {
            width: 220px;
        }

        @media (max-width: 768px) {

            .container {
                padding: 15px;
            }

            .search-form {
                flex-direction: column;
            }

            table {
                display: block;
                overflow-x: auto;
                white-space: nowrap;
            }

        }

    </style>

</head>

<body>

<header class="header">

    <h1>Sunrise Dental - Treatments</h1>

    <a class="back"
       href="<%= request.getContextPath() %>/dashboard">
        ← Dashboard
    </a>

</header>


<main class="container">


    <!-- SEARCH -->

    <div class="card">

        <h2>Search Treatment</h2>

        <form class="search-form"
              method="get"
              action="<%= request.getContextPath() %>/treatments">

            <input
                    type="text"
                    name="treatmentCode"
                    placeholder="Enter treatment code e.g. TRT-001"
                    required>

            <button type="submit">
                Search
            </button>

        </form>


        <% if (searchedTreatment != null) { %>

            <table class="details-table">

                <tr>
                    <th>Treatment Code</th>
                    <td>
                        <%= searchedTreatment.getTreatmentCode() %>
                    </td>
                </tr>

                <tr>
                    <th>Treatment Name</th>
                    <td>
                        <%= searchedTreatment.getTreatmentName() %>
                    </td>
                </tr>

                <tr>
                    <th>Description</th>
                    <td>
                        <%= searchedTreatment.getDescription() %>
                    </td>
                </tr>

                <tr>
                    <th>Treatment Cost</th>
                    <td class="price">
                        Rs. <%= String.format(
                                "%.2f",
                                searchedTreatment.getTreatmentCost()
                        ) %>
                    </td>
                </tr>

                <tr>
                    <th>Consultation Fee</th>
                    <td class="price">
                        Rs. <%= String.format(
                                "%.2f",
                                searchedTreatment.getConsultationFee()
                        ) %>
                    </td>
                </tr>

                <tr>
                    <th>Status</th>
                    <td>
                        <span class="status">Active</span>
                    </td>
                </tr>

            </table>

        <% } else if (
                request.getParameter("treatmentCode") != null) {
        %>

            <div class="message error">
                No active treatment found with that treatment code.
            </div>

        <% } %>

    </div>


    <!-- ACTIVE TREATMENTS -->

    <% if (treatments != null) { %>

        <div class="card">

            <h2>Available Treatments</h2>

            <table>

                <thead>

                <tr>
                    <th>Code</th>
                    <th>Treatment</th>
                    <th>Description</th>
                    <th>Treatment Cost</th>
                    <th>Consultation Fee</th>
                    <th>Status</th>
                </tr>

                </thead>

                <tbody>

                <% for (Treatment treatment : treatments) { %>

                    <tr>

                        <td>
                            <strong>
                                <%= treatment.getTreatmentCode() %>
                            </strong>
                        </td>

                        <td>
                            <%= treatment.getTreatmentName() %>
                        </td>

                        <td>
                            <%= treatment.getDescription() %>
                        </td>

                        <td class="price">
                            Rs. <%= String.format(
                                    "%.2f",
                                    treatment.getTreatmentCost()
                            ) %>
                        </td>

                        <td class="price">
                            Rs. <%= String.format(
                                    "%.2f",
                                    treatment.getConsultationFee()
                            ) %>
                        </td>

                        <td>
                            <span class="status">
                                Active
                            </span>
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