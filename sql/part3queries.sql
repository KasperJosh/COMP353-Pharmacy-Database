-- Part 3 SQL Queries


-- a) List the name of patients who are patients of at least three different doctors

SELECT P.name
FROM Patient P
JOIN Prescription R
    ON P.patientSIN = R.patientSIN
GROUP BY P.patientSIN, P.name
HAVING COUNT(DISTINCT R.doctorSIN) >= 3;


-- b) For every doctor who is also a patient, give the doctor’s name and the name of the doctor treating him/her.

SELECT D1.name AS DoctorPatient, D2.name AS TreatingDoctor
FROM Doctor D1
JOIN Patient P
    ON D1.doctorSIN  = P.patientSIN
JOIN Doctor D2
    ON P.primaryDoctorSIN = D2.doctorSIN;


-- c) For every trade name drug that is not being sold by any pharmacy, provide the trade
-- name of the drug and the name of the pharmaceutical company of the drug.

SELECT D.tradeName, D.pharmCompanyName
FROM Drug D
LEFT JOIN Sells S
    ON D.tradename = S.tradeName
    AND D.pharmCompanyName = S.pharmCompanyName
WHERE S.pharmacyID IS NULL;


-- d) Provide details of all pharmaceutical companies that have contracts with at least 50
-- pharmacies. Details include name, website address, email address, address, phone
-- number and the total number of contracts of the pharmaceutical company. Results should
-- be displayed sorted in descending order by number of contracts.

SELECT
    PC.pharmCompanyName,
    PC.websiteAddress,
    PC.emailAddress,
    PC.companyAddress,
    PC.phoneNumber,
    COUNT(*) AS totalContracts
FROM PharmaceuticalCompany PC
JOIN Contract C
    ON PC.pharmCompanyName = C.pharmCompanyName
GROUP BY
    PC.pharmCompanyName,
    PC.websiteAddress,
    PC.emailAddress,
    PC.companyAddress,
    PC.phoneNumber
HAVING COUNT(DISTINCT C.pharmacyID) >= 50
ORDER BY totalContracts DESC;


-- e) List the name of all patients who do not have insurance. Details include SIN, name, Medicare card number, 
-- addresses, email address, phone number and date of birth. Results should be displayed sorted in ascending order by name. 

SELECT
    P.patientSIN,
    P.name,
    P.medicareCardNumber,
    P.homeAddress,
    P.emailAddress,
    P.phoneNumber,
    P.dateOfBirth
FROM Patient P
WHERE P.insurance IS NULL
ORDER BY P.name ASC;