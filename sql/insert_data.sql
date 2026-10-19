-- -----------------------------------------------------------------------------------
-- b) Providing one INSERT statement that will populate the table with data

USE pharmacy_database;

-- DOCTOR
INSERT INTO Doctor
(doctorSIN, name, homeAddress, emailAddress, phoneNumber,
 dateOfBirth, specialty, yearsOfExperience)
VALUES
('111111111', 'Dr. John Doe', '3755 Chemin de la Cote Sainte-Catherine',
 'j_doe@mcgill.ca', '514-340-8222',
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