-- COMP 353 Assignment 2 - PART III TEST DATA
-- 

USE pharmacy_database;

-- ==========================================================
-- (a) Existing patient 222222222 gets prescriptions from 3 doctors
-- (base: doctor 111111111 and prescription 1 already exist)
-- ==========================================================
INSERT INTO Doctor (doctorSIN, name, specialty, yearsOfExperience) VALUES
    ('444444444', 'Dr. Test Rivera', 'Family Medicine', 8),
    ('555555555', 'Dr. Test Patel', 'Internal Medicine', 12),
    ('666666666', 'Dr. Test Chen', 'General Medicine', 6);

INSERT INTO Prescription
    (prescriptionID, prescriptionDate, quantity, tradeName, pharmCompanyName, patientSIN, doctorSIN)
VALUES
    (2, '2026-10-11', 20, 'Tylenol', 'Johnson & Johnson', '222222222', '444444444'),
    (3, '2026-10-12', 15, 'Tylenol', 'Johnson & Johnson', '222222222', '555555555');

-- ==========================================================
-- (b) Dr. Test Chen is also a patient, treated by doctor 111111111
-- (e) Aaron and Nora have no insurance. Extra insured patient
--     gives Dr. Test Chen a primary patient.
-- ==========================================================
INSERT INTO Patient
    (patientSIN, name, medicareCardNumber, insurance, policyNumber,
     homeAddress, emailAddress, phoneNumber, dateOfBirth, primaryDoctorSIN)
VALUES
    ('666666666', 'Dr. Test Chen', 'TESTMED666', 'Test Insurance', 'POL666',
     '66 Example Street', 'test.chen@example.test', '514-555-0666', '1987-06-06', '111111111'),
    ('777777777', 'Nora Sample', 'TESTMED777', NULL, NULL,
     '77 Example Street', 'nora@example.test', '514-555-0777', '1990-07-07', '555555555'),
    ('888888888', 'Aaron Sample', 'TESTMED888', NULL, NULL,
     '88 Example Street', 'aaron@example.test', '514-555-0888', '1992-08-08', '444444444'),
    ('999999999', 'Taylor Example', 'TESTMED999', 'Test Insurance', 'POL999',
     '99 Example Street', 'taylor@example.test', '514-555-0999', '1993-09-09', '666666666');

-- ==========================================================
-- (c) Unsold drug; another sample drug used to populate Sells
-- ==========================================================
INSERT INTO Drug (tradeName, pharmCompanyName, formula) VALUES
    ('TestUnsoldDrug', 'Johnson & Johnson', 'TEST-FORMULA'),
    ('TestSoldDrug', 'Johnson & Johnson', 'TEST-SOLD-FORMULA');

-- ==========================================================
-- (d) 49 new pharmacies + original PH0000001 = 50 pharmacies
-- We must temporarily break the circular Pharmacy/Pharmacist FK.
-- Do not use SET FOREIGN_KEY_CHECKS=0 (it can hide invalid data).
-- ==========================================================
-- Temporarily break the circular dependency
ALTER TABLE Pharmacy
DROP FOREIGN KEY fk_pharmacy_main_pharmacist;

-- Allow new pharmacies to be inserted before their pharmacists
ALTER TABLE Pharmacy
MODIFY COLUMN mainPharmacistSIN CHAR(9) NULL;

-- Verify
SHOW COLUMNS FROM Pharmacy
LIKE 'mainPharmacistSIN';


-- Insert 49 new pharmacies with a temporarily NULL main pharmacist.
INSERT INTO Pharmacy (pharmacyID, pharmacyName, mainPharmacistSIN) VALUES
    ('PH0000002', 'Test Pharmacy 02', NULL),
    ('PH0000003', 'Test Pharmacy 03', NULL),
    ('PH0000004', 'Test Pharmacy 04', NULL),
    ('PH0000005', 'Test Pharmacy 05', NULL),
    ('PH0000006', 'Test Pharmacy 06', NULL),
    ('PH0000007', 'Test Pharmacy 07', NULL),
    ('PH0000008', 'Test Pharmacy 08', NULL),
    ('PH0000009', 'Test Pharmacy 09', NULL),
    ('PH0000010', 'Test Pharmacy 10', NULL),
    ('PH0000011', 'Test Pharmacy 11', NULL),
    ('PH0000012', 'Test Pharmacy 12', NULL),
    ('PH0000013', 'Test Pharmacy 13', NULL),
    ('PH0000014', 'Test Pharmacy 14', NULL),
    ('PH0000015', 'Test Pharmacy 15', NULL),
    ('PH0000016', 'Test Pharmacy 16', NULL),
    ('PH0000017', 'Test Pharmacy 17', NULL),
    ('PH0000018', 'Test Pharmacy 18', NULL),
    ('PH0000019', 'Test Pharmacy 19', NULL),
    ('PH0000020', 'Test Pharmacy 20', NULL),
    ('PH0000021', 'Test Pharmacy 21', NULL),
    ('PH0000022', 'Test Pharmacy 22', NULL),
    ('PH0000023', 'Test Pharmacy 23', NULL),
    ('PH0000024', 'Test Pharmacy 24', NULL),
    ('PH0000025', 'Test Pharmacy 25', NULL),
    ('PH0000026', 'Test Pharmacy 26', NULL),
    ('PH0000027', 'Test Pharmacy 27', NULL),
    ('PH0000028', 'Test Pharmacy 28', NULL),
    ('PH0000029', 'Test Pharmacy 29', NULL),
    ('PH0000030', 'Test Pharmacy 30', NULL),
    ('PH0000031', 'Test Pharmacy 31', NULL),
    ('PH0000032', 'Test Pharmacy 32', NULL),
    ('PH0000033', 'Test Pharmacy 33', NULL),
    ('PH0000034', 'Test Pharmacy 34', NULL),
    ('PH0000035', 'Test Pharmacy 35', NULL),
    ('PH0000036', 'Test Pharmacy 36', NULL),
    ('PH0000037', 'Test Pharmacy 37', NULL),
    ('PH0000038', 'Test Pharmacy 38', NULL),
	('PH0000039', 'Test Pharmacy 39', NULL),
    ('PH0000040', 'Test Pharmacy 40', NULL),
    ('PH0000041', 'Test Pharmacy 41', NULL),
    ('PH0000042', 'Test Pharmacy 42', NULL),
    ('PH0000043', 'Test Pharmacy 43', NULL),
    ('PH0000044', 'Test Pharmacy 44', NULL),
    ('PH0000045', 'Test Pharmacy 45', NULL),
    ('PH0000046', 'Test Pharmacy 46', NULL),
    ('PH0000047', 'Test Pharmacy 47', NULL),
    ('PH0000048', 'Test Pharmacy 48', NULL),
    ('PH0000049', 'Test Pharmacy 49', NULL),
    ('PH0000050', 'Test Pharmacy 50', NULL);

-- Each test pharmacy gets its own pharmacist.
INSERT INTO Pharmacist (pharmacistSIN, name, pharmacyID) VALUES
    ('700000002', 'Test Pharmacist 02', 'PH0000002'),
    ('700000003', 'Test Pharmacist 03', 'PH0000003'),
    ('700000004', 'Test Pharmacist 04', 'PH0000004'),
    ('700000005', 'Test Pharmacist 05', 'PH0000005'),
    ('700000006', 'Test Pharmacist 06', 'PH0000006'),
    ('700000007', 'Test Pharmacist 07', 'PH0000007'),
    ('700000008', 'Test Pharmacist 08', 'PH0000008'),
    ('700000009', 'Test Pharmacist 09', 'PH0000009'),
    ('700000010', 'Test Pharmacist 10', 'PH0000010'),
    ('700000011', 'Test Pharmacist 11', 'PH0000011'),
    ('700000012', 'Test Pharmacist 12', 'PH0000012'),
    ('700000013', 'Test Pharmacist 13', 'PH0000013'),
    ('700000014', 'Test Pharmacist 14', 'PH0000014'),
    ('700000015', 'Test Pharmacist 15', 'PH0000015'),
    ('700000016', 'Test Pharmacist 16', 'PH0000016'),
    ('700000017', 'Test Pharmacist 17', 'PH0000017'),
    ('700000018', 'Test Pharmacist 18', 'PH0000018'),
    ('700000019', 'Test Pharmacist 19', 'PH0000019'),
    ('700000020', 'Test Pharmacist 20', 'PH0000020'),
    ('700000021', 'Test Pharmacist 21', 'PH0000021'),
    ('700000022', 'Test Pharmacist 22', 'PH0000022'),
    ('700000023', 'Test Pharmacist 23', 'PH0000023'),
    ('700000024', 'Test Pharmacist 24', 'PH0000024'),
    ('700000025', 'Test Pharmacist 25', 'PH0000025'),
    ('700000026', 'Test Pharmacist 26', 'PH0000026'),
    ('700000027', 'Test Pharmacist 27', 'PH0000027'),
    ('700000028', 'Test Pharmacist 28', 'PH0000028'),
    ('700000029', 'Test Pharmacist 29', 'PH0000029'),
    ('700000030', 'Test Pharmacist 30', 'PH0000030'),
    ('700000031', 'Test Pharmacist 31', 'PH0000031'),
    ('700000032', 'Test Pharmacist 32', 'PH0000032'),
    ('700000033', 'Test Pharmacist 33', 'PH0000033'),
    ('700000034', 'Test Pharmacist 34', 'PH0000034'),
    ('700000035', 'Test Pharmacist 35', 'PH0000035'),
    ('700000036', 'Test Pharmacist 36', 'PH0000036'),
    ('700000037', 'Test Pharmacist 37', 'PH0000037'),
    ('700000038', 'Test Pharmacist 38', 'PH0000038'),
    ('700000039', 'Test Pharmacist 39', 'PH0000039'),
    ('700000040', 'Test Pharmacist 40', 'PH0000040'),
    ('700000041', 'Test Pharmacist 41', 'PH0000041'),
    ('700000042', 'Test Pharmacist 42', 'PH0000042'),
    ('700000043', 'Test Pharmacist 43', 'PH0000043'),
    ('700000044', 'Test Pharmacist 44', 'PH0000044'),
    ('700000045', 'Test Pharmacist 45', 'PH0000045'),
    ('700000046', 'Test Pharmacist 46', 'PH0000046'),
    ('700000047', 'Test Pharmacist 47', 'PH0000047'),
    ('700000048', 'Test Pharmacist 48', 'PH0000048'),
    ('700000049', 'Test Pharmacist 49', 'PH0000049'),
    ('700000050', 'Test Pharmacist 50', 'PH0000050');

-- Assign the pharmacist who works at each pharmacy as its manager.
UPDATE Pharmacy P
JOIN Pharmacist F
    ON P.pharmacyID = F.pharmacyID
SET P.mainPharmacistSIN = F.pharmacistSIN
WHERE P.pharmacyID BETWEEN 'PH0000002' AND 'PH0000050';

-- Reinstate the original mandatory-main-pharmacist constraints.
ALTER TABLE Pharmacy
MODIFY COLUMN mainPharmacistSIN CHAR(9) NOT NULL;

ALTER TABLE Pharmacy
ADD CONSTRAINT fk_pharmacy_main_pharmacist
FOREIGN KEY (mainPharmacistSIN, pharmacyID)
REFERENCES Pharmacist(pharmacistSIN, pharmacyID);

-- Supply at least two drugs at each pharmacy (including original).
INSERT INTO Sells (pharmacyID, tradeName, pharmCompanyName, price)
SELECT pharmacyID, 'Tylenol', 'Johnson & Johnson', 19.99
FROM Pharmacy
WHERE pharmacyID BETWEEN 'PH0000002' AND 'PH0000050';

INSERT INTO Sells (pharmacyID, tradeName, pharmCompanyName, price)
SELECT pharmacyID, 'TestSoldDrug', 'Johnson & Johnson', 9.99
FROM Pharmacy
WHERE pharmacyID BETWEEN 'PH0000001' AND 'PH0000050';

-- Add a second company so ORDER BY can be tested, not just the HAVING.
INSERT INTO PharmaceuticalCompany
    (pharmCompanyName, websiteAddress, emailAddress, companyAddress, phoneNumber)
VALUES
    ('Test Pharma B', 'https://example.test/pharma-b', 'pharma-b@example.test',
     '100 Example Boulevard', '514-555-0000');

-- Existing J&J contract ID 1 remains: adding 50 => 51 contracts,
-- covering 50 distinct pharmacies. Test Pharma B gets 50.
INSERT INTO Contract
    (contractID, startDate, endDate, contractText, pharmCompanyName, pharmacyID, supervisorSIN)
VALUES
    (1001, '2026-01-01', '2027-12-31', 'Test J&J agreement 01', 'Johnson & Johnson', 'PH0000001', '333333333'),
    (1002, '2026-01-01', '2027-12-31', 'Test J&J agreement 02', 'Johnson & Johnson', 'PH0000002', '700000002'),
    (1003, '2026-01-01', '2027-12-31', 'Test J&J agreement 03', 'Johnson & Johnson', 'PH0000003', '700000003'),
    (1004, '2026-01-01', '2027-12-31', 'Test J&J agreement 04', 'Johnson & Johnson', 'PH0000004', '700000004'),
    (1005, '2026-01-01', '2027-12-31', 'Test J&J agreement 05', 'Johnson & Johnson', 'PH0000005', '700000005'),
    (1006, '2026-01-01', '2027-12-31', 'Test J&J agreement 06', 'Johnson & Johnson', 'PH0000006', '700000006'),
    (1007, '2026-01-01', '2027-12-31', 'Test J&J agreement 07', 'Johnson & Johnson', 'PH0000007', '700000007'),
    (1008, '2026-01-01', '2027-12-31', 'Test J&J agreement 08', 'Johnson & Johnson', 'PH0000008', '700000008'),
    (1009, '2026-01-01', '2027-12-31', 'Test J&J agreement 09', 'Johnson & Johnson', 'PH0000009', '700000009'),
    (1010, '2026-01-01', '2027-12-31', 'Test J&J agreement 10', 'Johnson & Johnson', 'PH0000010', '700000010'),
    (1011, '2026-01-01', '2027-12-31', 'Test J&J agreement 11', 'Johnson & Johnson', 'PH0000011', '700000011'),
    (1012, '2026-01-01', '2027-12-31', 'Test J&J agreement 12', 'Johnson & Johnson', 'PH0000012', '700000012'),
    (1013, '2026-01-01', '2027-12-31', 'Test J&J agreement 13', 'Johnson & Johnson', 'PH0000013', '700000013'),
    (1014, '2026-01-01', '2027-12-31', 'Test J&J agreement 14', 'Johnson & Johnson', 'PH0000014', '700000014'),
    (1015, '2026-01-01', '2027-12-31', 'Test J&J agreement 15', 'Johnson & Johnson', 'PH0000015', '700000015'),
    (1016, '2026-01-01', '2027-12-31', 'Test J&J agreement 16', 'Johnson & Johnson', 'PH0000016', '700000016'),
    (1017, '2026-01-01', '2027-12-31', 'Test J&J agreement 17', 'Johnson & Johnson', 'PH0000017', '700000017'),
    (1018, '2026-01-01', '2027-12-31', 'Test J&J agreement 18', 'Johnson & Johnson', 'PH0000018', '700000018'),
    (1019, '2026-01-01', '2027-12-31', 'Test J&J agreement 19', 'Johnson & Johnson', 'PH0000019', '700000019'),
    (1020, '2026-01-01', '2027-12-31', 'Test J&J agreement 20', 'Johnson & Johnson', 'PH0000020', '700000020'),
    (1021, '2026-01-01', '2027-12-31', 'Test J&J agreement 21', 'Johnson & Johnson', 'PH0000021', '700000021'),
    (1022, '2026-01-01', '2027-12-31', 'Test J&J agreement 22', 'Johnson & Johnson', 'PH0000022', '700000022'),
    (1023, '2026-01-01', '2027-12-31', 'Test J&J agreement 23', 'Johnson & Johnson', 'PH0000023', '700000023'),
    (1024, '2026-01-01', '2027-12-31', 'Test J&J agreement 24', 'Johnson & Johnson', 'PH0000024', '700000024'),
    (1025, '2026-01-01', '2027-12-31', 'Test J&J agreement 25', 'Johnson & Johnson', 'PH0000025', '700000025'),
    (1026, '2026-01-01', '2027-12-31', 'Test J&J agreement 26', 'Johnson & Johnson', 'PH0000026', '700000026'),
    (1027, '2026-01-01', '2027-12-31', 'Test J&J agreement 27', 'Johnson & Johnson', 'PH0000027', '700000027'),
	(1028, '2026-01-01', '2027-12-31', 'Test J&J agreement 28', 'Johnson & Johnson', 'PH0000028', '700000028'),
    (1029, '2026-01-01', '2027-12-31', 'Test J&J agreement 29', 'Johnson & Johnson', 'PH0000029', '700000029'),
    (1030, '2026-01-01', '2027-12-31', 'Test J&J agreement 30', 'Johnson & Johnson', 'PH0000030', '700000030'),
    (1031, '2026-01-01', '2027-12-31', 'Test J&J agreement 31', 'Johnson & Johnson', 'PH0000031', '700000031'),
    (1032, '2026-01-01', '2027-12-31', 'Test J&J agreement 32', 'Johnson & Johnson', 'PH0000032', '700000032'),
    (1033, '2026-01-01', '2027-12-31', 'Test J&J agreement 33', 'Johnson & Johnson', 'PH0000033', '700000033'),
    (1034, '2026-01-01', '2027-12-31', 'Test J&J agreement 34', 'Johnson & Johnson', 'PH0000034', '700000034'),
    (1035, '2026-01-01', '2027-12-31', 'Test J&J agreement 35', 'Johnson & Johnson', 'PH0000035', '700000035'),
    (1036, '2026-01-01', '2027-12-31', 'Test J&J agreement 36', 'Johnson & Johnson', 'PH0000036', '700000036'),
    (1037, '2026-01-01', '2027-12-31', 'Test J&J agreement 37', 'Johnson & Johnson', 'PH0000037', '700000037'),
    (1038, '2026-01-01', '2027-12-31', 'Test J&J agreement 38', 'Johnson & Johnson', 'PH0000038', '700000038'),
    (1039, '2026-01-01', '2027-12-31', 'Test J&J agreement 39', 'Johnson & Johnson', 'PH0000039', '700000039'),
    (1040, '2026-01-01', '2027-12-31', 'Test J&J agreement 40', 'Johnson & Johnson', 'PH0000040', '700000040'),
    (1041, '2026-01-01', '2027-12-31', 'Test J&J agreement 41', 'Johnson & Johnson', 'PH0000041', '700000041'),
    (1042, '2026-01-01', '2027-12-31', 'Test J&J agreement 42', 'Johnson & Johnson', 'PH0000042', '700000042'),
    (1043, '2026-01-01', '2027-12-31', 'Test J&J agreement 43', 'Johnson & Johnson', 'PH0000043', '700000043'),
    (1044, '2026-01-01', '2027-12-31', 'Test J&J agreement 44', 'Johnson & Johnson', 'PH0000044', '700000044'),
    (1045, '2026-01-01', '2027-12-31', 'Test J&J agreement 45', 'Johnson & Johnson', 'PH0000045', '700000045'),
    (1046, '2026-01-01', '2027-12-31', 'Test J&J agreement 46', 'Johnson & Johnson', 'PH0000046', '700000046'),
    (1047, '2026-01-01', '2027-12-31', 'Test J&J agreement 47', 'Johnson & Johnson', 'PH0000047', '700000047'),
    (1048, '2026-01-01', '2027-12-31', 'Test J&J agreement 48', 'Johnson & Johnson', 'PH0000048', '700000048'),
    (1049, '2026-01-01', '2027-12-31', 'Test J&J agreement 49', 'Johnson & Johnson', 'PH0000049', '700000049'),
    (1050, '2026-01-01', '2027-12-31', 'Test J&J agreement 50', 'Johnson & Johnson', 'PH0000050', '700000050');

INSERT INTO Contract
    (contractID, startDate, endDate, contractText, pharmCompanyName, pharmacyID, supervisorSIN)
VALUES
    (2001, '2026-02-01', '2027-12-31', 'Test Pharma B agreement 01', 'Test Pharma B', 'PH0000001', '333333333'),
    (2002, '2026-02-01', '2027-12-31', 'Test Pharma B agreement 02', 'Test Pharma B', 'PH0000002', '700000002'),
    (2003, '2026-02-01', '2027-12-31', 'Test Pharma B agreement 03', 'Test Pharma B', 'PH0000003', '700000003'),
    (2004, '2026-02-01', '2027-12-31', 'Test Pharma B agreement 04', 'Test Pharma B', 'PH0000004', '700000004'),
    (2005, '2026-02-01', '2027-12-31', 'Test Pharma B agreement 05', 'Test Pharma B', 'PH0000005', '700000005'),
    (2006, '2026-02-01', '2027-12-31', 'Test Pharma B agreement 06', 'Test Pharma B', 'PH0000006', '700000006'),
    (2007, '2026-02-01', '2027-12-31', 'Test Pharma B agreement 07', 'Test Pharma B', 'PH0000007', '700000007'),
    (2008, '2026-02-01', '2027-12-31', 'Test Pharma B agreement 08', 'Test Pharma B', 'PH0000008', '700000008'),
    (2009, '2026-02-01', '2027-12-31', 'Test Pharma B agreement 09', 'Test Pharma B', 'PH0000009', '700000009'),
    (2010, '2026-02-01', '2027-12-31', 'Test Pharma B agreement 10', 'Test Pharma B', 'PH0000010', '700000010'),
    (2011, '2026-02-01', '2027-12-31', 'Test Pharma B agreement 11', 'Test Pharma B', 'PH0000011', '700000011'),
    (2012, '2026-02-01', '2027-12-31', 'Test Pharma B agreement 12', 'Test Pharma B', 'PH0000012', '700000012'),
    (2013, '2026-02-01', '2027-12-31', 'Test Pharma B agreement 13', 'Test Pharma B', 'PH0000013', '700000013'),
    (2014, '2026-02-01', '2027-12-31', 'Test Pharma B agreement 14', 'Test Pharma B', 'PH0000014', '700000014'),
    (2015, '2026-02-01', '2027-12-31', 'Test Pharma B agreement 15', 'Test Pharma B', 'PH0000015', '700000015'),
    (2016, '2026-02-01', '2027-12-31', 'Test Pharma B agreement 16', 'Test Pharma B', 'PH0000016', '700000016'),
    (2017, '2026-02-01', '2027-12-31', 'Test Pharma B agreement 17', 'Test Pharma B', 'PH0000017', '700000017'),
    (2018, '2026-02-01', '2027-12-31', 'Test Pharma B agreement 18', 'Test Pharma B', 'PH0000018', '700000018'),
    (2019, '2026-02-01', '2027-12-31', 'Test Pharma B agreement 19', 'Test Pharma B', 'PH0000019', '700000019'),
    (2020, '2026-02-01', '2027-12-31', 'Test Pharma B agreement 20', 'Test Pharma B', 'PH0000020', '700000020'),
    (2021, '2026-02-01', '2027-12-31', 'Test Pharma B agreement 21', 'Test Pharma B', 'PH0000021', '700000021'),
    (2022, '2026-02-01', '2027-12-31', 'Test Pharma B agreement 22', 'Test Pharma B', 'PH0000022', '700000022'),
    (2023, '2026-02-01', '2027-12-31', 'Test Pharma B agreement 23', 'Test Pharma B', 'PH0000023', '700000023'),
    (2024, '2026-02-01', '2027-12-31', 'Test Pharma B agreement 24', 'Test Pharma B', 'PH0000024', '700000024'),
    (2025, '2026-02-01', '2027-12-31', 'Test Pharma B agreement 25', 'Test Pharma B', 'PH0000025', '700000025'),
    (2026, '2026-02-01', '2027-12-31', 'Test Pharma B agreement 26', 'Test Pharma B', 'PH0000026', '700000026'),
    (2027, '2026-02-01', '2027-12-31', 'Test Pharma B agreement 27', 'Test Pharma B', 'PH0000027', '700000027'),
    (2028, '2026-02-01', '2027-12-31', 'Test Pharma B agreement 28', 'Test Pharma B', 'PH0000028', '700000028'),
    (2029, '2026-02-01', '2027-12-31', 'Test Pharma B agreement 29', 'Test Pharma B', 'PH0000029', '700000029'),
    (2030, '2026-02-01', '2027-12-31', 'Test Pharma B agreement 30', 'Test Pharma B', 'PH0000030', '700000030'),
    (2031, '2026-02-01', '2027-12-31', 'Test Pharma B agreement 31', 'Test Pharma B', 'PH0000031', '700000031'),
    (2032, '2026-02-01', '2027-12-31', 'Test Pharma B agreement 32', 'Test Pharma B', 'PH0000032', '700000032'),
    (2033, '2026-02-01', '2027-12-31', 'Test Pharma B agreement 33', 'Test Pharma B', 'PH0000033', '700000033'),
    (2034, '2026-02-01', '2027-12-31', 'Test Pharma B agreement 34', 'Test Pharma B', 'PH0000034', '700000034'),
    (2035, '2026-02-01', '2027-12-31', 'Test Pharma B agreement 35', 'Test Pharma B', 'PH0000035', '700000035'),
    (2036, '2026-02-01', '2027-12-31', 'Test Pharma B agreement 36', 'Test Pharma B', 'PH0000036', '700000036'),
    (2037, '2026-02-01', '2027-12-31', 'Test Pharma B agreement 37', 'Test Pharma B', 'PH0000037', '700000037'),
    (2038, '2026-02-01', '2027-12-31', 'Test Pharma B agreement 38', 'Test Pharma B', 'PH0000038', '700000038'),
    (2039, '2026-02-01', '2027-12-31', 'Test Pharma B agreement 39', 'Test Pharma B', 'PH0000039', '700000039'),
    (2040, '2026-02-01', '2027-12-31', 'Test Pharma B agreement 40', 'Test Pharma B', 'PH0000040', '700000040'),
    (2041, '2026-02-01', '2027-12-31', 'Test Pharma B agreement 41', 'Test Pharma B', 'PH0000041', '700000041'),
    (2042, '2026-02-01', '2027-12-31', 'Test Pharma B agreement 42', 'Test Pharma B', 'PH0000042', '700000042'),
    (2043, '2026-02-01', '2027-12-31', 'Test Pharma B agreement 43', 'Test Pharma B', 'PH0000043', '700000043'),
    (2044, '2026-02-01', '2027-12-31', 'Test Pharma B agreement 44', 'Test Pharma B', 'PH0000044', '700000044'),
    (2045, '2026-02-01', '2027-12-31', 'Test Pharma B agreement 45', 'Test Pharma B', 'PH0000045', '700000045'),
    (2046, '2026-02-01', '2027-12-31', 'Test Pharma B agreement 46', 'Test Pharma B', 'PH0000046', '700000046'),
    (2047, '2026-02-01', '2027-12-31', 'Test Pharma B agreement 47', 'Test Pharma B', 'PH0000047', '700000047'),
    (2048, '2026-02-01', '2027-12-31', 'Test Pharma B agreement 48', 'Test Pharma B', 'PH0000048', '700000048'),
    (2049, '2026-02-01', '2027-12-31', 'Test Pharma B agreement 49', 'Test Pharma B', 'PH0000049', '700000049'),
    (2050, '2026-02-01', '2027-12-31', 'Test Pharma B agreement 50', 'Test Pharma B', 'PH0000050', '700000050');

-- ==========================================================
-- Check expected answers from the five Part III queries.
-- (a): one or more rows including base patient 222222222
-- (b): Dr. Test Chen | Dr. John Doe / original doctor name
-- (c): TestUnsoldDrug | Johnson & Johnson
-- (d): Johnson & Johnson: 51 contracts / 50 pharmacies;
--      Test Pharma B: 50 contracts / 50 pharmacies
-- (e): Aaron Sample, Nora Sample (alphabetical order)
-- ==========================================================

-- (a)
SELECT P.name
FROM Patient P
JOIN Prescription R ON P.patientSIN = R.patientSIN
GROUP BY P.patientSIN, P.name
HAVING COUNT(DISTINCT R.doctorSIN) >= 3;

-- (b)
SELECT D1.name AS DoctorPatient, D2.name AS TreatingDoctor
FROM Doctor D1
JOIN Patient P ON D1.doctorSIN = P.patientSIN
JOIN Doctor D2 ON P.primaryDoctorSIN = D2.doctorSIN;

-- (c)
SELECT D.tradeName, D.pharmCompanyName
FROM Drug D
LEFT JOIN Sells S
  ON D.tradeName = S.tradeName AND D.pharmCompanyName = S.pharmCompanyName
WHERE S.pharmacyID IS NULL;

-- (d)
SELECT PC.pharmCompanyName, PC.websiteAddress, PC.emailAddress,
       PC.companyAddress, PC.phoneNumber, COUNT(*) AS totalContracts
FROM PharmaceuticalCompany PC
JOIN Contract C ON PC.pharmCompanyName = C.pharmCompanyName
GROUP BY PC.pharmCompanyName, PC.websiteAddress, PC.emailAddress,
         PC.companyAddress, PC.phoneNumber
HAVING COUNT(DISTINCT C.pharmacyID) >= 50
ORDER BY totalContracts DESC;

-- (e)
SELECT P.patientSIN, P.name, P.medicareCardNumber, P.homeAddress,
       P.emailAddress, P.phoneNumber, P.dateOfBirth
FROM Patient P
WHERE P.insurance IS NULL
ORDER BY P.name ASC;