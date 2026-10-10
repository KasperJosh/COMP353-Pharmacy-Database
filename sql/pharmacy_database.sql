CREATE DATABASE IF NOT EXISTS pharmacy_database;
USE pharmacy_database;


CREATE TABLE Doctor (
    doctorSIN CHAR(9) PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    homeAddress VARCHAR(255),
    emailAddress VARCHAR(255),
    phoneNumber VARCHAR(255),
    dateOfBirth DATE,
    specialty VARCHAR(100),
    yearsOfExperience INT
);

CREATE TABLE Patient (
    patientSIN CHAR(9) PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    medicareCardNumber VARCHAR(20),
    insurance VARCHAR(100),
    policyNumber VARCHAR(50),
    homeAddress VARCHAR(255),
    emailAddress VARCHAR(255),
    phoneNumber VARCHAR(255),
    dateOfBirth DATE,
    primaryDoctorSIN CHAR(9) NOT NULL,

    -- Defining the doctor foreign key
    CONSTRAINT fk_patient_doctor
        FOREIGN KEY (primaryDoctorSIN)
        REFERENCES Doctor(doctorSIN)
);