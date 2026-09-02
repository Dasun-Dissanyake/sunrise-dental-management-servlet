# Sunrise Dental Management System

## Overview

The **Sunrise Dental Management System** is a web-based application developed to support the daily operations of a private dental clinic. The system replaces manual paper-based processes with a centralized digital solution for managing users, patients, dentists, treatments, appointments, billing and reports.

## Main Features

* User authentication and role-based access control
* Patient management
* Dentist management
* Treatment management
* Appointment registration and management
* Dentist availability and appointment conflict validation
* Automated bill calculation
* Receipt generation and printing
* Dashboard and reporting
* Help section
* Input validation and error handling

## User Roles

The system supports three main user roles:

* **Administrator** – manages users and system information.
* **Receptionist** – manages patients, appointments and billing.
* **Dentist** – accesses relevant appointment and patient information.

## Technologies Used

### Frontend

* HTML
* CSS
* JavaScript
* JSP

### Backend

* Java 23
* Jakarta Servlets
* Maven
* Apache Tomcat 11

### Database

* MySQL
* JDBC / MySQL Connector/J

### Testing

* JUnit 5
* Mockito

## System Architecture

The application follows a layered architecture:

```text
JSP / HTML / CSS / JavaScript
            ↓
     Servlet / Controller
            ↓
          Service
            ↓
            DAO
            ↓
        JDBC / MySQL
```

This separation improves maintainability and allows the different application components to be developed and tested independently.

## Database

The system uses a MySQL relational database containing the following main tables:

* `users`
* `patients`
* `dentists`
* `treatments`
* `appointments`
* `bills`

Foreign keys and database constraints are used to maintain data integrity and relationships between entities.

## Security

The system implements:

* Session-based authentication
* Role-based authorization
* BCrypt password hashing
* Prepared statements for database operations
* Input validation
* Protection against unauthorized access

## Testing

Automated tests were implemented using JUnit and Mockito to verify service and servlet functionality, validation rules and business logic.

The final test execution completed successfully with:

**106 tests – 0 failures – 0 errors – 0 skipped**

## Project Structure

```text
sunrise-dental/
├── database/
├── src/
│   ├── main/
│   │   ├── java/
│   │   └── webapp/
│   └── test/
├── pom.xml
├── README.md
└── .gitignore
```

## Setup

1. Install JDK 23, Maven, MySQL and Apache Tomcat 11.
2. Create the required MySQL database.
3. Execute the SQL script located in the `database` directory.
4. Configure the database connection according to the project configuration.
5. Build the project using Maven:

```bash
mvn clean package
```

6. Deploy the generated WAR file to Apache Tomcat 11.
7. Start Tomcat and access the application through a web browser.

## Project Status

**Final Version – Completed**

The core functionality of the Sunrise Dental Management System has been implemented, tested and prepared for deployment.
