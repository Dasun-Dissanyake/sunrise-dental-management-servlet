<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="com.sunrisedental.model.User" %>

<%
    User user = (User) session.getAttribute("loggedInUser");
    if (user == null) {
        user = (User) request.getAttribute("user");
    }
%>

<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>System Help & User Guide - Sunrise Dental</title>
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/sunrise-theme.css">
    <style>
        .help-section-card {
            margin-bottom: 24px;
        }

        .help-steps {
            list-style: none;
            padding: 0;
            margin: 16px 0 0 0;
            counter-reset: help-counter;
        }

        .help-step-item {
            position: relative;
            padding-left: 48px;
            margin-bottom: 18px;
            counter-increment: help-counter;
        }

        .help-step-item:last-child {
            margin-bottom: 0;
        }

        .help-step-badge {
            position: absolute;
            left: 0;
            top: 0;
            width: 32px;
            height: 32px;
            background: var(--primary);
            color: var(--white);
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            font-weight: 700;
            font-size: 14px;
            box-shadow: var(--shadow-sm);
        }

        .help-step-title {
            font-weight: 700;
            font-size: 15px;
            color: var(--dark);
            margin-bottom: 4px;
        }

        .help-step-desc {
            font-size: 13px;
            color: var(--muted);
            line-height: 1.5;
        }

        .help-note-box {
            margin-top: 14px;
            padding: 12px 16px;
            background: var(--surface-secondary);
            border-left: 4px solid var(--primary);
            border-radius: var(--radius-sm);
            font-size: 13px;
            color: var(--text-dark);
        }

        .quick-nav-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
            gap: 12px;
            margin-bottom: 24px;
        }

        .quick-nav-card {
            background: var(--surface);
            border: 1px solid var(--border-light);
            border-radius: var(--radius-md);
            padding: 14px 18px;
            display: flex;
            align-items: center;
            gap: 12px;
            text-decoration: none;
            color: var(--dark);
            font-weight: 600;
            font-size: 14px;
            transition: all 0.2s ease;
        }

        .quick-nav-card:hover {
            border-color: var(--primary);
            background: var(--white);
            transform: translateY(-2px);
            box-shadow: var(--shadow-sm);
        }

        .quick-nav-icon {
            width: 32px;
            height: 32px;
            border-radius: 8px;
            background: var(--primary-light);
            color: var(--primary-dark);
            display: flex;
            align-items: center;
            justify-content: center;
            font-weight: 800;
            font-size: 14px;
        }
    </style>
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
        <a class="nav-link" href="<%= request.getContextPath() %>/bills">Billing</a>
        <a class="nav-link" href="<%= request.getContextPath() %>/reports">Reports</a>
        <a class="nav-link active" href="<%= request.getContextPath() %>/help">Help</a>
    </div>
</nav>

<main class="container">

    <div class="page-header">
        <div class="page-header-text">
            <h1>Staff User Guide &amp; System Help</h1>
            <p>Step-by-step instructions for clinic operations, scheduling, billing, and reporting.</p>
        </div>
        <div class="page-header-actions">
            <button type="button" class="btn btn-secondary" onclick="window.print()">
                Print Guide
            </button>
            <a class="back-link" href="<%= request.getContextPath() %>/dashboard">
                &larr; Back to Dashboard
            </a>
        </div>
    </div>

    <!-- QUICK JUMP LINKS -->
    <div class="quick-nav-grid">
        <a class="quick-nav-card" href="#getting-started">
            <div class="quick-nav-icon">1</div>
            <span>Getting Started</span>
        </a>
        <a class="quick-nav-card" href="#patients-help">
            <div class="quick-nav-icon">2</div>
            <span>Patients</span>
        </a>
        <a class="quick-nav-card" href="#appointments-help">
            <div class="quick-nav-icon">3</div>
            <span>Appointments</span>
        </a>
        <a class="quick-nav-card" href="#treatments-help">
            <div class="quick-nav-icon">4</div>
            <span>Treatments</span>
        </a>
        <a class="quick-nav-card" href="#billing-help">
            <div class="quick-nav-icon">5</div>
            <span>Billing</span>
        </a>
        <a class="quick-nav-card" href="#reports-help">
            <div class="quick-nav-icon">6</div>
            <span>Reports</span>
        </a>
    </div>

    <!-- 1. GETTING STARTED -->
    <div id="getting-started" class="card help-section-card">
        <div class="card-header">
            <div>
                <h2 class="card-title">1. Getting Started</h2>
                <p class="card-subtitle">Staff authentication, system navigation, and safe logout.</p>
            </div>
        </div>

        <ul class="help-steps">
            <li class="help-step-item">
                <div class="help-step-badge">1</div>
                <div class="help-step-title">Logging In to the System</div>
                <div class="help-step-desc">
                    Navigate to the Sign In portal. Enter your authorized username and password. Click <strong>"Sign In to Dashboard"</strong>. Passwords are securely hashed with BCrypt. If credentials are empty or incorrect, a friendly error alert will prompt you to re-enter.
                </div>
            </li>
            <li class="help-step-item">
                <div class="help-step-badge">2</div>
                <div class="help-step-title">Understanding the Dashboard</div>
                <div class="help-step-desc">
                    Upon login, the dashboard displays live Key Performance Indicators (KPIs) including <strong>Total Patients</strong>, <strong>Total Appointments</strong>, <strong>Today's Appointments</strong>, and <strong>Total Revenue</strong>. Below the metrics, quick management cards provide direct access to Appointments, Patients, Dentists, Treatments, Billing, and Reports. A real-time table lists recent clinic appointments.
                </div>
            </li>
            <li class="help-step-item">
                <div class="help-step-badge">3</div>
                <div class="help-step-title">Safely Exiting the System (Logout)</div>
                <div class="help-step-desc">
                    When your shift ends or you leave the computer unattended, click the <strong>"Logout"</strong> link in the top-right corner of the header. This securely invalidates your HTTP session, clears all authentication tokens, and redirects back to the login screen. Protected pages cannot be accessed after logout.
                </div>
            </li>
        </ul>
    </div>

    <!-- 2. PATIENT MANAGEMENT -->
    <div id="patients-help" class="card help-section-card">
        <div class="card-header">
            <div>
                <h2 class="card-title">2. Patients Management</h2>
                <p class="card-subtitle">Registering new patients and looking up existing medical profiles.</p>
            </div>
        </div>

        <ul class="help-steps">
            <li class="help-step-item">
                <div class="help-step-badge">1</div>
                <div class="help-step-title">Registering a New Patient</div>
                <div class="help-step-desc">
                    Navigate to the <strong>"Patients"</strong> tab. Fill out the registration form: Patient Number (e.g. <code>PAT-001</code>), Full Name, Contact Number, Residential Address, Date of Birth, Gender, and Email. Click <strong>"Register Patient"</strong>. All required fields are validated server-side, and duplicate patient numbers are prevented.
                </div>
            </li>
            <li class="help-step-item">
                <div class="help-step-badge">2</div>
                <div class="help-step-title">Searching for a Patient</div>
                <div class="help-step-desc">
                    In the Search Patient box, type the unique Patient Number (e.g. <code>PAT-001</code>) and click <strong>"Search Patient"</strong>. The patient's full identification, phone number, address, email, and birth date will be displayed in an organized profile card.
                </div>
            </li>
            <li class="help-step-item">
                <div class="help-step-badge">3</div>
                <div class="help-step-title">Viewing the Patient Directory</div>
                <div class="help-step-desc">
                    The <strong>"Registered Patients Directory"</strong> table at the bottom displays all active patient profiles sorted by recent registration.
                </div>
            </li>
        </ul>
    </div>

    <!-- 3. APPOINTMENTS SCHEDULING -->
    <div id="appointments-help" class="card help-section-card">
        <div class="card-header">
            <div>
                <h2 class="card-title">3. Appointments Scheduling</h2>
                <p class="card-subtitle">Booking appointments, managing doctor schedules, and updating clinical statuses.</p>
            </div>
        </div>

        <ul class="help-steps">
            <li class="help-step-item">
                <div class="help-step-badge">1</div>
                <div class="help-step-title">Registering a New Appointment</div>
                <div class="help-step-desc">
                    Navigate to <strong>"Appointments"</strong>. Enter a unique Appointment Number (e.g. <code>APP-001</code>), select the registered Patient, practicing Dentist, and desired Treatment procedure from the dropdown lists. Choose the appointment Date and Time, and optionally add Clinical Notes. Click <strong>"Schedule Appointment"</strong>.
                </div>
            </li>
            <li class="help-step-item">
                <div class="help-step-badge">2</div>
                <div class="help-step-title">Preventing Schedule Conflicts</div>
                <div class="help-step-desc">
                    The system automatically checks if the selected dentist already has an appointment booked at the requested date and time to prevent double-booking.
                </div>
            </li>
            <li class="help-step-item">
                <div class="help-step-badge">3</div>
                <div class="help-step-title">Searching and Viewing Appointment Details</div>
                <div class="help-step-desc">
                    Enter the Appointment Number in the search card and click <strong>"Search Appointment"</strong>. The complete details will appear: Appointment #, Patient Name, Patient Residential Address, Contact Number, Dentist Name & Specialization, Treatment Procedure, Date & Time, Status, and Clinical Notes.
                </div>
            </li>
            <li class="help-step-item">
                <div class="help-step-badge">4</div>
                <div class="help-step-title">Updating Appointment Status & Details</div>
                <div class="help-step-desc">
                    Use the <strong>"Quick Status Update"</strong> buttons to instantly set an appointment to <em>SCHEDULED</em>, <em>COMPLETED</em>, <em>CANCELLED</em>, or <em>NO SHOW</em>. You can also modify doctor assignments or reschedule dates using the Edit form.
                </div>
            </li>
        </ul>
    </div>

    <!-- 4. TREATMENTS -->
    <div id="treatments-help" class="card help-section-card">
        <div class="card-header">
            <div>
                <h2 class="card-title">4. Treatments &amp; Fee Schedule</h2>
                <p class="card-subtitle">Reviewing available clinical procedures and standard fee pricing.</p>
            </div>
        </div>

        <ul class="help-steps">
            <li class="help-step-item">
                <div class="help-step-badge">1</div>
                <div class="help-step-title">Viewing Available Treatments</div>
                <div class="help-step-desc">
                    Navigate to the <strong>"Treatments"</strong> tab to view all active dental procedures, descriptions, procedural Treatment Costs, and standard Consultation Fees.
                </div>
            </li>
            <li class="help-step-item">
                <div class="help-step-badge">2</div>
                <div class="help-step-title">Searching by Treatment Code</div>
                <div class="help-step-desc">
                    Enter a Treatment Code (e.g. <code>TRT-001</code>) into the search box to lookup the specific price and fee details for that clinical procedure.
                </div>
            </li>
        </ul>
    </div>

    <!-- 5. BILLING & INVOICES -->
    <div id="billing-help" class="card help-section-card">
        <div class="card-header">
            <div>
                <h2 class="card-title">5. Billing &amp; Invoices</h2>
                <p class="card-subtitle">Generating invoices, calculating totals, and printing official receipts.</p>
            </div>
        </div>

        <ul class="help-steps">
            <li class="help-step-item">
                <div class="help-step-badge">1</div>
                <div class="help-step-title">Finding an Appointment to Bill</div>
                <div class="help-step-desc">
                    Navigate to the <strong>"Billing"</strong> tab. In the search card, enter the numeric Appointment ID and click <strong>"Find Appointment for Billing"</strong>. The system will retrieve the appointment, patient information, and treatment pricing.
                </div>
            </li>
            <li class="help-step-item">
                <div class="help-step-badge">2</div>
                <div class="help-step-title">Understanding Charges and Generating the Bill</div>
                <div class="help-step-desc">
                    The bill calculation formula is:
                    <div class="help-note-box">
                        <strong>Total Amount Payable = Consultation Fee + Treatment Cost</strong>
                    </div>
                    Assign a unique Bill Receipt Number (e.g. <code>REC-000001</code>) and click <strong>"Generate Bill"</strong>. The system verifies that no duplicate bill exists for the appointment and records the transaction.
                </div>
            </li>
            <li class="help-step-item">
                <div class="help-step-badge">3</div>
                <div class="help-step-title">Searching and Printing Official Receipts</div>
                <div class="help-step-desc">
                    Enter a Bill Number in the search box to view the finalized receipt. Click <strong>"Print Official Receipt"</strong> to open the printer-friendly dialog formatted specifically for clean clinic paper receipts.
                </div>
            </li>
        </ul>
    </div>

    <!-- 6. REPORTS -->
    <div id="reports-help" class="card help-section-card">
        <div class="card-header">
            <div>
                <h2 class="card-title">6. Reports &amp; Analytics</h2>
                <p class="card-subtitle">Generating financial breakdowns, practitioner volume, and appointment analytics.</p>
            </div>
        </div>

        <ul class="help-steps">
            <li class="help-step-item">
                <div class="help-step-badge">1</div>
                <div class="help-step-title">Setting a Date Range</div>
                <div class="help-step-desc">
                    Navigate to <strong>"Reports"</strong>. Pick a Start Date and End Date using the date pickers and click <strong>"Generate Report"</strong>. By default, the current month is selected.
                </div>
            </li>
            <li class="help-step-item">
                <div class="help-step-badge">2</div>
                <div class="help-step-title">Analyzing Clinic Performance</div>
                <div class="help-step-desc">
                    The generated report provides:
                    <ul style="margin: 8px 0 8px 20px; font-size: 13px; color: var(--muted);">
                        <li><strong>Revenue Summary:</strong> Total Revenue, Total Consultation Fees, Total Treatment Revenue, Total Invoices, and Average Bill.</li>
                        <li><strong>Treatment Performance:</strong> Appointment volume and revenue per treatment type.</li>
                        <li><strong>Dentist Performance:</strong> Total appointments, completed, cancelled, and no-shows per doctor.</li>
                        <li><strong>Patient Activity:</strong> Total visits, completed sessions, and last visit date per patient.</li>
                    </ul>
                </div>
            </li>
            <li class="help-step-item">
                <div class="help-step-badge">3</div>
                <div class="help-step-title">Appointment Status Report</div>
                <div class="help-step-desc">
                    Click <strong>"Appointment Status Report &rarr;"</strong> in the page header to view a specialized breakdown of appointments by status (Scheduled, Completed, Cancelled, No Show) over any date range.
                </div>
            </li>
            <li class="help-step-item">
                <div class="help-step-badge">4</div>
                <div class="help-step-title">Printing Reports</div>
                <div class="help-step-desc">
                    Click the <strong>"Print Report"</strong> button on any report page to produce a clean, printer-optimized summary for management review.
                </div>
            </li>
        </ul>
    </div>

</main>

<footer class="footer">
    Sunrise Dental Management System &bull; Professional Dental Care &amp; Clinical Operations
</footer>

</body>
</html>
