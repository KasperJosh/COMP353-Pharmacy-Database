-- COMP 353 -- Pharmacy Database
-- PART II 
-- a) TABLES Creation

DROP DATABASE IF EXISTS pharmacy_database;
CREATE DATABASE IF NOT EXISTS pharmacy_database;
USE pharmacy_database;

-- DOCTOR 
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

-- PATIENT
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

    -- Foreign key constraint to Primary Doctor
    CONSTRAINT fk_patient_doctor
        FOREIGN KEY (primaryDoctorSIN)
        REFERENCES Doctor(doctorSIN)
);

-- PHARMACEUTICAL COMPANY
CREATE TABLE PharmaceuticalCompany(
    pharmCompanyName VARCHAR(100) PRIMARY KEY,
    websiteAddress VARCHAR(255),
    emailAddress VARCHAR(255),
    companyAddress VARCHAR(255),
    phoneNumber VARCHAR(20)
);


-- PHARMACY
CREATE TABLE Pharmacy (
    pharmacyID CHAR(9) PRIMARY KEY,
    pharmacyName VARCHAR(100) NOT NULL,
    pharmAddress VARCHAR(255),
    websiteAddress VARCHAR(255),
    emailAddress VARCHAR(255),
    phoneNumber VARCHAR(20),
    mainPharmacistSIN CHAR(9) NULL -- Temporarily

    -- Main pharmacist FK will be added later
);

-- PHARMACIST
CREATE TABLE Pharmacist (
    pharmacistSIN CHAR(9) PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    homeAddress VARCHAR(255),
    emailAddress VARCHAR(255),
    phoneNumber VARCHAR(20),
    dateOfBirth DATE,
    yearsOfExperience INT,
    pharmacyID CHAR(9) NOT NULL,

    -- Unique constraint that a pharmacists works only at one pharmacy 
    -- COMPOSITE KEY
    CONSTRAINT uq_pharmacist_workplace
        UNIQUE (pharmacistSIN, pharmacyID),

    -- Foreign key constraint to pharmacyID
    CONSTRAINT fk_pharmacist_pharmacy
        FOREIGN KEY (pharmacyID)
        REFERENCES Pharmacy(pharmacyID)
);

-- Adding MAIN PHARMACIST FOREIGN KEY
-- Create Pharmacy, Create Pharmacist, Add main pharmacist foreign key afterward
-- ALTER TABLE Pharmacy
-- ADD CONSTRAINT fk_pharmacy_main_pharmacist
--    FOREIGN KEY (mainPharmacistSIN, pharmacyID)
--    REFERENCES Pharmacist(pharmacistSIN, pharmacyID);


-- DRUG (WEAK ENTITY)
CREATE TABLE Drug (
    tradeName VARCHAR(100) NOT NULL,
    pharmCompanyName VARCHAR(100) NOT NULL,
    formula VARCHAR(255),

    -- Since DRUG is a weak entity, it has a COMPOSITE KEY(it's discriminator and the key of the strong entity
    PRIMARY KEY (tradeName, pharmCompanyName),

    -- Foreign key constraint to pharCompanyName
    CONSTRAINT fk_drug_company
        FOREIGN KEY (pharmCompanyName)
        REFERENCES PharmaceuticalCompany(pharmCompanyName)
);


-- PRESCRIPTION
CREATE TABLE Prescription (
    prescriptionID INT PRIMARY KEY,
    prescriptionDate DATE NOT NULL,
    quantity INT NOT NULL,
    tradeName VARCHAR(100) NOT NULL,
    pharmCompanyName VARCHAR(100) NOT NULL,
    patientSIN CHAR(9) NOT NULL,
    doctorSIN CHAR(9) NOT NULL,

    -- Unique Constraint Prescrption relating to the latest prescription
    CONSTRAINT uq_prescription_combination
        UNIQUE (
            doctorSIN,
            patientSIN,
            tradeName,
            pharmCompanyName
        ),

    -- Foreign key constraint to DoctorSIN
    CONSTRAINT fk_prescription_doctor
        FOREIGN KEY (doctorSIN)
        REFERENCES Doctor(doctorSIN),

    -- Foreign key contraint to PatientSIN
    CONSTRAINT fk_prescription_patient
        FOREIGN KEY (patientSIN)
        REFERENCES Patient(patientSIN),

    -- Foreign Key constraint to the weak Drug Entity
    CONSTRAINT fk_prescription_drug
        FOREIGN KEY (tradeName, pharmCompanyName)
        REFERENCES Drug(tradeName, pharmCompanyName)
);

-- CONTRACT
CREATE TABLE Contract (
    contractID INT PRIMARY KEY,
    startDate DATE NOT NULL,
    endDate DATE NOT NULL,
    contractText TEXT NOT NULL,
    pharmCompanyName VARCHAR(100) NOT NULL,
    pharmacyID CHAR(9) NOT NULL,
    supervisorSIN CHAR(9) NOT NULL,

    -- Foreign key constraint to pharmCompanyName
    CONSTRAINT fk_contract_company
        FOREIGN KEY (pharmCompanyName)
        REFERENCES PharmaceuticalCompany(pharmCompanyName),

    -- Foreign Key constraint to pharmacyID
    CONSTRAINT fk_contract_pharmacy
        FOREIGN KEY (pharmacyID)
        REFERENCES Pharmacy(pharmacyID),

    -- Foreign Key constraint to pharmacistSIN
    CONSTRAINT fk_contract_supervisor
        FOREIGN KEY (supervisorSIN)
        REFERENCES Pharmacist(pharmacistSIN)
);

-- PRESCRIPTION PURCHASE
CREATE TABLE PrescriptionPurchase (
    purchaseID INT PRIMARY KEY,
    prescriptionID INT NOT NULL,
    pharmacyID CHAR(9) NOT NULL,
    approvedBySIN CHAR(9) NOT NULL,

    -- Foreign key to prescriptionID
    CONSTRAINT fk_purchase_prescription
        FOREIGN KEY (prescriptionID)
        REFERENCES Prescription(prescriptionID),

    -- Foreign key to pharmacyID
    CONSTRAINT fk_purchase_pharmacy
        FOREIGN KEY (pharmacyID)
        REFERENCES Pharmacy(pharmacyID),

    -- Approving pharmacist must work
    -- at the pharmacy where the purchase occurs
    CONSTRAINT fk_purchase_approver_workplace
        FOREIGN KEY (approvedBySIN, pharmacyID)
        REFERENCES Pharmacist(pharmacistSIN, pharmacyID)
);


-- SELLS (M:N Relationship)

CREATE TABLE Sells (
    pharmacyID CHAR(9) NOT NULL,
    tradeName VARCHAR(100) NOT NULL,
    pharmCompanyName VARCHAR(100) NOT NULL,
    price DECIMAL(10,2) NOT NULL,

    -- Since Drug Entity is a weak entity
    PRIMARY KEY (
        pharmacyID,
        tradeName,
        pharmCompanyName
    ),

    -- Foreign key to pharmacyID
    CONSTRAINT fk_sells_pharmacy
        FOREIGN KEY (pharmacyID)
        REFERENCES Pharmacy(pharmacyID),

    -- Foreign key to Drug Entity
    CONSTRAINT fk_sells_drug
        FOREIGN KEY (tradeName, pharmCompanyName)
        REFERENCES Drug(tradeName, pharmCompanyName)
);


-- Testings
SHOW TABLES;
DESCRIBE Doctor;