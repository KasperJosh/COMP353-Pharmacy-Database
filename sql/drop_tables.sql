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
