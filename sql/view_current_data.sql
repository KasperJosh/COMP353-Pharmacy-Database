-- COMP 353 Assignment 2 — View Current Pharmacy Database Data
-- Read-only: these statements do NOT insert, update, delete, or drop anything.
-- Execute after connecting to the MySQL server.

USE pharmacy_database;

-- 1) Verify the selected database and see the tables
SELECT DATABASE() AS active_database;
SHOW TABLES;

-- 2) Show the current number of records in each table
SELECT 'Doctor' AS table_name, COUNT(*) AS row_count FROM Doctor
UNION ALL SELECT 'Patient', COUNT(*) FROM Patient
UNION ALL SELECT 'PharmaceuticalCompany', COUNT(*) FROM PharmaceuticalCompany
UNION ALL SELECT 'Pharmacy', COUNT(*) FROM Pharmacy
UNION ALL SELECT 'Pharmacist', COUNT(*) FROM Pharmacist
UNION ALL SELECT 'Drug', COUNT(*) FROM Drug
UNION ALL SELECT 'Prescription', COUNT(*) FROM Prescription
UNION ALL SELECT 'Contract', COUNT(*) FROM Contract
UNION ALL SELECT 'Sells', COUNT(*) FROM Sells
UNION ALL SELECT 'PrescriptionPurchase', COUNT(*) FROM PrescriptionPurchase;

-- 3) Display ALL existing rows in each of your 10 tables.
-- MySQL Workbench / MySQL Shell will show one result set per SELECT.

-- People
SELECT * FROM Doctor ORDER BY doctorSIN;
SELECT * FROM Patient ORDER BY patientSIN;
SELECT * FROM Pharmacist ORDER BY pharmacistSIN;

-- Companies, stores and drugs
SELECT * FROM PharmaceuticalCompany ORDER BY pharmCompanyName;
SELECT * FROM Pharmacy ORDER BY pharmacyID;
SELECT * FROM Drug ORDER BY pharmCompanyName, tradeName;

-- Transactions and relationships
SELECT * FROM Prescription ORDER BY prescriptionID;
SELECT * FROM Contract ORDER BY contractID;
SELECT * FROM Sells ORDER BY pharmacyID, pharmCompanyName, tradeName;
SELECT * FROM PrescriptionPurchase ORDER BY purchaseID;