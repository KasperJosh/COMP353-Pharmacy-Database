-- COMPLETE CODE IN 1 SQL File 

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


-- -----------------------------------------------------------------------------------
-- b) Providing one INSERT statement that will populate the table with data

-- DOCTOR
INSERT INTO Doctor
(doctorSIN, name, homeAddress, emailAddress, phoneNumber,
 dateOfBirth, specialty, yearsOfExperience)
VALUES
('111111111', 'Dr. Jean-Francois Morin', '3755 Chemin de la Cote Sainte-Catherine',
 'j-f_morin@mcgill.ca', '514-340-8222',
 '1980-05-15', 'Cardiac Surgery', 20);


-- PATIENT
INSERT INTO Patient
(patientSIN, name, medicareCardNumber, insurance, policyNumber,
 homeAddress, emailAddress, phoneNumber, dateOfBirth,
 primaryDoctorSIN)
VALUES
('222222222', 'Joshua Visario', 'QC1234567890',
 'Beneva', 'POL1001',
 '1455 Blvd. De Maisonneuve Ouest', 'j_visar@live.concordia.ca',
 '514-714-0905', '1999-05-09', '111111111');


-- PHARMACEUTICAL COMPANY
INSERT INTO PharmaceuticalCompany
(pharmCompanyName, websiteAddress, emailAddress,
 companyAddress, phoneNumber)
VALUES
('Johnson & Johnson', 'https://johnson&johnson.com',
 'johnson&johnson.ca', '1 Kenvue Way, Summit, NJ 07901, United States',
 '514-999-9999');


-- PHARMACY
-- Main pharmacist will be assigned after Pharmacist is inserted.
INSERT INTO Pharmacy
(pharmacyID, pharmacyName, pharmAddress, websiteAddress,
 emailAddress, phoneNumber, mainPharmacistSIN)
VALUES
('PH0000001', 'Pharmaprix', '1500 Rue Sainte-Catherine Ouest, Montreal',
 'https://pharmaprix.com',
 'pharmaprix@gmail.com', '514-933-4744', NULL);


-- PHARMACIST
INSERT INTO Pharmacist
(pharmacistSIN, name, homeAddress, emailAddress,
 phoneNumber, dateOfBirth, yearsOfExperience, pharmacyID)
VALUES
('333333333', 'Rebecca Do', '3755 Chemin de la Cote Sainte-Catherine, Montreal',
 'rebecca.do@gmail.com', '514-555-0105',
 '2000-06-20', 2, 'PH0000001');


-- Assign the main pharmacist.
UPDATE Pharmacy
SET mainPharmacistSIN = '333333333'
WHERE pharmacyID = 'PH0000001';


-- Restore both mandatory NOT NULL and workplace-matching FK.
ALTER TABLE Pharmacy
MODIFY COLUMN mainPharmacistSIN CHAR(9) NOT NULL;

ALTER TABLE Pharmacy
ADD CONSTRAINT fk_pharmacy_main_pharmacist
    FOREIGN KEY (mainPharmacistSIN, pharmacyID)
    REFERENCES Pharmacist(pharmacistSIN, pharmacyID);

-- DRUG
INSERT INTO Drug
(tradeName, pharmCompanyName, formula)
VALUES
('Tylenol', 'Johnson & Johnson', 'C8H9NO2');


-- PRESCRIPTION
INSERT INTO Prescription
(prescriptionID, prescriptionDate, quantity,
 tradeName, pharmCompanyName, patientSIN, doctorSIN)
VALUES
(1, '2026-10-10', 30,
 'Tylenol', 'Johnson & Johnson', '222222222', '111111111');


-- CONTRACT
INSERT INTO Contract
(contractID, startDate, endDate, contractText,
 pharmCompanyName, pharmacyID, supervisorSIN)
VALUES
(1, '2026-01-01', '2027-12-31',
 'Supply agreement for Tylenol.',
 'Johnson & Johnson', 'PH0000001', '333333333');


-- SELLS
INSERT INTO Sells
(pharmacyID, tradeName, pharmCompanyName, price)
VALUES
('PH0000001', 'Tylenol', 'Johnson & Johnson', 19.99);


-- PRESCRIPTION PURCHASE
INSERT INTO PrescriptionPurchase
(purchaseID, prescriptionID, pharmacyID, approvedBySIN)
VALUES
(1, 1, 'PH0000001', '333333333');


-- Testings
SELECT * FROM Doctor;
SELECT * FROM Patient;
SELECT * FROM PharmaceuticalCompany;
SELECT * FROM Pharmacy;
SELECT * FROM Pharmacist;
SELECT * FROM Drug;
SELECT * FROM Prescription;
SELECT * FROM Contract;
SELECT * FROM Sells;
SELECT * FROM PrescriptionPurchase;

-- Checking the constraints
SHOW CREATE TABLE Pharmacy;
SHOW CREATE TABLE Pharmacist;
SHOW CREATE TABLE Prescription;
SHOW CREATE TABLE Sells;


-- Part C Delete records inserted in Part II--------------------------------------------

-- Delete prescription purchase
DELETE FROM PrescriptionPurchase
WHERE purchaseID = 1;

-- Delete contract
DELETE FROM Contract
WHERE contractID = 1;

-- Delete Sells relationship
DELETE FROM Sells
WHERE pharmacyID = 'PH0000001'
  AND tradeName = 'Tylenol'
  AND pharmCompanyName = 'Johnson & Johnson';

-- Delete prescription
DELETE FROM Prescription
WHERE prescriptionID = 1;

-- Delete drug
DELETE FROM Drug
WHERE tradeName = 'Tylenol'
  AND pharmCompanyName = 'Johnson & Johnson';

-- Delete patient
DELETE FROM Patient
WHERE patientSIN = '222222222';

-- Temporarily remove circular FK
ALTER TABLE Pharmacy
DROP FOREIGN KEY fk_pharmacy_main_pharmacist;

-- Delete pharmacist
DELETE FROM Pharmacist
WHERE pharmacistSIN = '333333333';

-- Delete pharmacy
DELETE FROM Pharmacy
WHERE pharmacyID = 'PH0000001';

-- Restore the foreign key
ALTER TABLE Pharmacy
ADD CONSTRAINT fk_pharmacy_main_pharmacist
FOREIGN KEY (mainPharmacistSIN, pharmacyID)
REFERENCES Pharmacist(pharmacistSIN, pharmacyID);

-- Delete doctor
DELETE FROM Doctor
WHERE doctorSIN = '111111111';

-- Delete pharmaceutical company
DELETE FROM PharmaceuticalCompany
WHERE pharmCompanyName = 'Johnson & Johnson';


-- Testings 

SELECT * FROM Doctor;
SELECT * FROM Patient;
SELECT * FROM Pharmacy;
SELECT * FROM Pharmacist;
SELECT * FROM Drug;
SELECT * FROM Prescription;
SELECT * FROM Contract;
SELECT * FROM PrescriptionPurchase;
SELECT * FROM Sells;
SELECT * FROM PharmaceuticalCompany;

SHOW TABLES;



-- Part d Delete Tables that you created in part a (Using DROP)-------------------------------

-- Remove circular foreign key constraint
ALTER TABLE Pharmacy
DROP FOREIGN KEY fk_pharmacy_main_pharmacist;

-- Drop dependent tables first
DROP TABLE IF EXISTS PrescriptionPurchase;
DROP TABLE IF EXISTS Contract;
DROP TABLE IF EXISTS Sells;
DROP TABLE IF EXISTS Prescription;

-- Drop remaining tables
DROP TABLE IF EXISTS Drug;
DROP TABLE IF EXISTS Patient;
DROP TABLE IF EXISTS Pharmacist;
DROP TABLE IF EXISTS Pharmacy;
DROP TABLE IF EXISTS PharmaceuticalCompany;
DROP TABLE IF EXISTS Doctor;

-- Verify that all tables have been deleted
SHOW TABLES;