-- ============================================================================
-- Sunrise Dental Management System
-- Database Setup Script
-- ============================================================================
-- Description: Complete database schema creation script for Sunrise Dental.
-- Database: sunrise_dental_db
-- RDBMS: MySQL 8.0+
-- ============================================================================

CREATE DATABASE IF NOT EXISTS sunrise_dental_db
    CHARACTER SET utf8mb4
    COLLATE utf8mb4_unicode_ci;

USE sunrise_dental_db;

-- ----------------------------------------------------------------------------
-- Disable foreign key checks during setup
-- ----------------------------------------------------------------------------
SET FOREIGN_KEY_CHECKS = 0;

-- ----------------------------------------------------------------------------
-- Drop existing tables in reverse dependency order
-- ----------------------------------------------------------------------------
DROP TABLE IF EXISTS bills;
DROP TABLE IF EXISTS appointments;
DROP TABLE IF EXISTS treatments;
DROP TABLE IF EXISTS dentists;
DROP TABLE IF EXISTS patients;
DROP TABLE IF EXISTS users;

-- ----------------------------------------------------------------------------
-- Re-enable foreign key checks
-- ----------------------------------------------------------------------------
SET FOREIGN_KEY_CHECKS = 1;

-- ============================================================================
-- Table: users
-- Purpose: Stores authentication credentials, system roles, and user status.
-- Application Roles: ADMIN, DENTIST, RECEPTIONIST
-- ============================================================================
CREATE TABLE users (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    username VARCHAR(50) NOT NULL UNIQUE,
    password VARCHAR(255) NOT NULL,
    full_name VARCHAR(100) NOT NULL,
    role ENUM('ADMIN', 'DENTIST', 'RECEPTIONIST') NOT NULL,
    enabled BOOLEAN NOT NULL DEFAULT TRUE,
    created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    INDEX idx_users_username (username),
    INDEX idx_users_role (role)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ============================================================================
-- Table: patients
-- Purpose: Stores patient demographic, contact, and registration details.
-- ============================================================================
CREATE TABLE patients (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    patient_number VARCHAR(50) NOT NULL UNIQUE,
    full_name VARCHAR(100) NOT NULL,
    address TEXT NOT NULL,
    contact_number VARCHAR(20) NOT NULL,
    date_of_birth DATE NULL,
    email VARCHAR(100) NULL,
    gender VARCHAR(20) NULL,
    registration_date DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    active BOOLEAN NOT NULL DEFAULT TRUE,
    INDEX idx_patients_number (patient_number),
    INDEX idx_patients_full_name (full_name),
    INDEX idx_patients_active (active)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ============================================================================
-- Table: dentists
-- Purpose: Stores dentist profiles, specialization, and availability status.
-- ============================================================================
CREATE TABLE dentists (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    dentist_number VARCHAR(50) NOT NULL UNIQUE,
    full_name VARCHAR(100) NOT NULL,
    specialization VARCHAR(100) NOT NULL,
    contact_number VARCHAR(20) NOT NULL,
    created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    active BOOLEAN NOT NULL DEFAULT TRUE,
    INDEX idx_dentists_number (dentist_number),
    INDEX idx_dentists_full_name (full_name),
    INDEX idx_dentists_active (active)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ============================================================================
-- Table: treatments
-- Purpose: Stores available dental procedures, fees, and standard costs.
-- ============================================================================
CREATE TABLE treatments (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    treatment_code VARCHAR(50) NOT NULL UNIQUE,
    treatment_name VARCHAR(100) NOT NULL,
    description TEXT NULL,
    treatment_cost DECIMAL(10, 2) NOT NULL DEFAULT 0.00,
    consultation_fee DECIMAL(10, 2) NOT NULL DEFAULT 0.00,
    created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    active BOOLEAN NOT NULL DEFAULT TRUE,
    INDEX idx_treatments_code (treatment_code),
    INDEX idx_treatments_name (treatment_name),
    INDEX idx_treatments_active (active)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ============================================================================
-- Table: appointments
-- Purpose: Manages dental appointments linking patients, dentists, & treatments.
-- Appointment Statuses: SCHEDULED, COMPLETED, CANCELLED, NO_SHOW
-- ============================================================================
CREATE TABLE appointments (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    appointment_number VARCHAR(50) NOT NULL UNIQUE,
    patient_id BIGINT NOT NULL,
    dentist_id BIGINT NOT NULL,
    treatment_id BIGINT NOT NULL,
    appointment_date DATE NOT NULL,
    appointment_time TIME NOT NULL,
    status ENUM('SCHEDULED', 'COMPLETED', 'CANCELLED', 'NO_SHOW') NOT NULL DEFAULT 'SCHEDULED',
    notes TEXT NULL,
    created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME NULL DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP,
    INDEX idx_appointments_number (appointment_number),
    INDEX idx_appointments_date (appointment_date),
    INDEX idx_appointments_status (status),
    INDEX idx_appointments_patient (patient_id),
    INDEX idx_appointments_dentist (dentist_id),
    INDEX idx_appointments_treatment (treatment_id),
    CONSTRAINT fk_appointments_patient
        FOREIGN KEY (patient_id) REFERENCES patients (id)
        ON DELETE RESTRICT ON UPDATE CASCADE,
    CONSTRAINT fk_appointments_dentist
        FOREIGN KEY (dentist_id) REFERENCES dentists (id)
        ON DELETE RESTRICT ON UPDATE CASCADE,
    CONSTRAINT fk_appointments_treatment
        FOREIGN KEY (treatment_id) REFERENCES treatments (id)
        ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ============================================================================
-- Table: bills
-- Purpose: Stores invoice records generated for completed/scheduled appointments.
-- ============================================================================
CREATE TABLE bills (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    bill_number VARCHAR(50) NOT NULL UNIQUE,
    appointment_id BIGINT NOT NULL UNIQUE,
    consultation_fee DECIMAL(10, 2) NOT NULL DEFAULT 0.00,
    treatment_cost DECIMAL(10, 2) NOT NULL DEFAULT 0.00,
    total_amount DECIMAL(10, 2) NOT NULL DEFAULT 0.00,
    bill_date DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    INDEX idx_bills_number (bill_number),
    INDEX idx_bills_appointment (appointment_id),
    INDEX idx_bills_date (bill_date),
    CONSTRAINT fk_bills_appointment
        FOREIGN KEY (appointment_id) REFERENCES appointments (id)
        ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ============================================================================
-- Seed Initial Data: Default Administrator Account
-- ============================================================================
-- Default Administrator Account Details:
--   Username: admin
--   Password: your-admin-password
--   Role:     ADMIN
--   Enabled:  TRUE (1)
--
-- Password Security:
--   Stored as BCrypt hash (work factor 12)
--   Hash: $2a$12$o.nZ/0x5JX80HmesJJsMHuVwEbTKfoGKE2LeNSge91hgdcc3I1hL6
--   Compatible with: org.mindrot.jbcrypt.BCrypt.checkpw()
-- ============================================================================
INSERT INTO users (username, password, full_name, role, enabled, created_at)
VALUES (
    'admin',
    '$2a$12$o.nZ/0x5JX80HmesJJsMHuVwEbTKfoGKE2LeNSge91hgdcc3I1hL6',
    'System Administrator',
    'ADMIN',
    TRUE,
    NOW()
);
