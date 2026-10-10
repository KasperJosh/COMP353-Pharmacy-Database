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
