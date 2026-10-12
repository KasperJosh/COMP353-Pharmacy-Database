# Pharmacy Chain Database Management System

**COMP 353 — Databases | Assignment 2**  
**Author:** Joshua Visario  
**Institution:** Concordia University  
**Database:** MySQL  
**Project type:** Relational database design and SQL implementation

## Overview

This academic project designs and implements a relational database for a chain of pharmacies. It models patients, doctors, pharmacists, pharmacies, pharmaceutical companies, drugs, prescriptions, purchases, and supply contracts.

The goal is to translate real-world requirements into an **entity–relationship (ER) model**, convert that model to a **relational schema**, implement it using **MySQL**, and answer business questions with SQL queries.

**This is an educational database prototype, not a production pharmacy or electronic health record system.** All demonstration records should be fictional; do not load real patient or staff information.

## Project objectives

- Identify entities, attributes, primary keys, and relationships from business requirements.
- Model cardinalities, weak entities, and associative entities using an ER diagram.
- Convert the conceptual design into relational tables with primary and foreign keys.
- Preserve referential integrity, including composite-key relationships.
- Populate tables with sample records, then demonstrate record and table deletion.
- Query the database using joins, grouping, aggregate functions, and null handling.
- Explain how the schema would change if all pharmacies charged the same price for a given drug.

## Tools and technologies

- **MySQL** — SQL database and referential constraints
- **MySQL Shell for VS Code / MySQL-compatible client** — query execution
- **Visual Studio Code** — SQL editing
- **draw.io (diagrams.net)** — ER diagram development
- **Git and GitHub** — source control and project documentation

## Database design

The implementation uses **10 tables**:

| Table | Purpose | Primary key |
| --- | --- | --- |
| `Doctor` | Stores physicians and their specialties | `doctorSIN` |
| `Patient` | Stores patient details and primary physicians | `patientSIN` |
| `Pharmacist` | Stores pharmacists and their employing pharmacies | `pharmacistSIN` |
| `Pharmacy` | Stores pharmacy locations and their main pharmacists | `pharmacyID` |
| `PharmaceuticalCompany` | Stores pharmaceutical company information | `pharmCompanyName` |
| `Drug` | Stores drugs produced by pharmaceutical companies | (`tradeName`, `pharmCompanyName`) |
| `Prescription` | Associates a doctor, patient, and drug with date and quantity | `prescriptionID` |
| `Contract` | Records contracts between pharmacies and companies | `contractID` |
| `Sells` | Records drugs offered at each pharmacy and their prices | (`pharmacyID`, `tradeName`, `pharmCompanyName`) |
| `PrescriptionPurchase` | Records the pharmacy and pharmacist involved in a purchase | `purchaseID` |

### Main relationships

| Relationship | Meaning | Cardinality |
| --- | --- | --- |
| `hasPrimaryPhysician` | Each patient has one primary physician | Patient → Doctor: N:1 |
| `Produces` | A company produces multiple drugs; each drug belongs to one company | Drug → Company: N:1 |
| `Sells` | Pharmacies sell drugs, potentially at different prices | Pharmacy ↔ Drug: M:N |
| `Employs` | Each pharmacist works at one pharmacy in this model | Pharmacist → Pharmacy: N:1 |
| `hasMainPharmacist` | Each pharmacy designates one of its employees as its main pharmacist | Pharmacy ↔ Pharmacist: 1:1 designation |
| `ForPatient` / `IssuedBy` / `ForDrug` | A prescription references one patient, one prescribing doctor, and one drug | Prescription → each entity: N:1 |
| `withCompany` / `atPharmacy` | Each contract involves one company and one pharmacy | Contract → each entity: N:1 |
| `Supervises` | One pharmacist supervises each contract at a time | Contract → Pharmacist: N:1 |
| `Fulfills` | Each purchase references one prescription | Purchase → Prescription: N:1 |
| `purchasedAt` / `ApprovedBy` | Each purchase occurs at one pharmacy and is approved by one pharmacist | Purchase → each entity: N:1 |

`Prescription` and `Contract` are modeled as **associative entities** because they represent relationships with their own identifiers and attributes. `PrescriptionPurchase` captures purchases separately from prescriptions.

### Weak entity: Drug

`Drug` is modeled as a weak entity identified by its **trade name together with the producing pharmaceutical company**:

```sql
PRIMARY KEY (tradeName, pharmCompanyName)
```

Its composite primary key is referenced by `Prescription` and `Sells`. A foreign key links each drug to `PharmaceuticalCompany`.

### Integrity constraints and design decisions

- **Primary physician:** `Patient.primaryDoctorSIN` is `NOT NULL` and references `Doctor`.
- **Latest prescription per combination:** `Prescription` has a unique constraint on (`doctorSIN`, `patientSIN`, `tradeName`, `pharmCompanyName`). This prevents two stored prescriptions for the same combination; retaining the *latest* entry requires application logic or an explicit update/upsert operation.
- **Main pharmacist:** `Pharmacy.mainPharmacistSIN` must ultimately be non-null and must refer to a pharmacist employed by that same pharmacy. A composite foreign key (`mainPharmacistSIN`, `pharmacyID`) enforces the workplace match.
- **Purchase approval:** `PrescriptionPurchase` uses a composite foreign key (`approvedBySIN`, `pharmacyID`) to require the approving pharmacist to work at the purchasing pharmacy.
- **Contract supervision:** Each `Contract` has a non-null `supervisorSIN` referencing `Pharmacist`. The current supervisor is stored; reassignment history is not.
- **Pricing:** In the original design, `price` belongs to `Sells` because the price can differ between pharmacies.

**Important implementation detail:** `Pharmacy` and `Pharmacist` reference one another. To initialize the sample records, `mainPharmacistSIN` is temporarily nullable. The script inserts a pharmacy, inserts its pharmacist, assigns the main pharmacist, and then adds `NOT NULL` and the composite foreign key. The required constraint is enforced **after this setup sequence**, not by the initial `CREATE TABLE Pharmacy` statement alone.

### Rules not completely enforced by the SQL schema

The submitted design also describes business rules that ordinary foreign keys do not fully enforce, including:

- Every doctor must have at least one patient.
- Every pharmacy must sell several drugs.
- A prescription purchase should only be completed for a drug sold at that pharmacy (if this is required by the business workflow).
- Only the newest prescription is retained when a doctor prescribes the same drug to the same patient again; the unique constraint prevents duplicates but does not automatically choose the newer record.

These would need further business logic, validation, triggers, or a redesigned workflow in a production system.

## Assignment structure

### Part I — Conceptual and logical design

1. Identify entities, attributes, and relationship cardinalities.
2. Create the ER diagram, including `Drug` as a weak entity.
3. Convert the ER model into the 10-table relational schema.
4. Explain the consequences of a hypothetical fixed-drug-price requirement.

**Fixed-price design variation:** If a given drug must cost the same at every pharmacy, move `price` from `Sells` to `Drug`:

```text
Original: Drug(tradeName, pharmCompanyName, formula)
          Sells(pharmacyID, tradeName, pharmCompanyName, price)

Modified: Drug(tradeName, pharmCompanyName, formula, price)
          Sells(pharmacyID, tradeName, pharmCompanyName)
```

The provided Part II implementation uses the **original variable-price design**; the fixed-price design is an analysis of a proposed change.

### Part II — MySQL implementation

| Question | Work performed |
| --- | --- |
| (a) | Create the database and its 10 tables using `CREATE TABLE`, keys, and constraints. |
| (b) | Insert at least one demonstration record into each table, including the staged main-pharmacist setup. |
| (c) | Delete the inserted sample records with `DELETE FROM` in foreign-key-safe order. |
| (d) | Remove the tables with `DROP TABLE`, dropping dependent tables first. |

**Warning:** The assignment script includes destructive statements such as `DROP DATABASE`, `DELETE`, and `DROP TABLE`. Do **not** run the entire script every time you want to test a query. Doing so may remove your records or tables. Execute the appropriate section only, or keep separate setup, insert, cleanup, and query scripts.

## Running the project

### Requirements

1. Install MySQL Server and connect using a MySQL-compatible SQL client, such as MySQL Shell for VS Code or MySQL Workbench.
2. Open the assignment's SQL file in your editor.
3. Work through the script in the following sequence, **using a fresh disposable database** when running the full setup:

   **A. Create the schema:** Execute Part II(a), including the database creation and all 10 `CREATE TABLE` statements.

   **B. Populate the schema:** Execute Part II(b), including the pharmacy/pharmacist initialization and subsequent constraint additions.

   **C. Verify the records:** Run the `SELECT` and `SHOW CREATE TABLE` checks after the inserts.

   **D. Run analytical queries:** Execute Part III queries while the sample data remains present.

   **E. Clean up only when needed:** Execute Part II(c) to delete sample records or Part II(d) to drop the tables.

To inspect the currently selected database and tables, run:

```sql
USE pharmacy_database;
SELECT DATABASE();
SHOW TABLES;
```

To inspect the structure and records of a particular table:

```sql
DESCRIBE Prescription;
SHOW CREATE TABLE Pharmacy;
SELECT * FROM Prescription;
```

**Re-running the script:** Running `CREATE TABLE` for a table that already exists causes MySQL error 1050. Re-inserting the same primary key can cause a duplicate-key error. Resetting the database is destructive, so use it only if you intend to start over.

## Part III — Analytical SQL queries

The assignment asks five questions using the relational schema from Part I.

### (a) Patients associated with at least three different doctors

```sql
SELECT P.name
FROM Patient P
JOIN Prescription R
    ON P.patientSIN = R.patientSIN
GROUP BY P.patientSIN, P.name
HAVING COUNT(DISTINCT R.doctorSIN) >= 3;
```

*Interpretation:* The query counts distinct doctors appearing on a patient's prescriptions. A primary physician who has not issued a recorded prescription is not counted.

### (b) Doctors who are also patients and their treating doctors

```sql
SELECT D1.name AS DoctorPatient,
       D2.name AS TreatingDoctor
FROM Doctor D1
JOIN Patient P
    ON D1.doctorSIN = P.patientSIN
JOIN Doctor D2
    ON P.primaryDoctorSIN = D2.doctorSIN;
```

### (c) Drugs not sold by any pharmacy

```sql
SELECT D.tradeName, D.pharmCompanyName
FROM Drug D
LEFT JOIN Sells S
    ON D.tradeName = S.tradeName
   AND D.pharmCompanyName = S.pharmCompanyName
WHERE S.pharmacyID IS NULL;
```

### (d) Companies with contracts involving at least 50 pharmacies

```sql
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
```

The `HAVING` condition counts **distinct pharmacies**, while `totalContracts` counts **contract rows**.

### (e) Patients without insurance

```sql
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
```

## Testing and expected behavior

The minimum sample dataset includes one record in each table. This verifies basic inserts and foreign-key references, but it does **not** necessarily produce matches for every analytical query:

- Query (a) requires at least three distinct prescribing doctors for the same patient.
- Query (b) requires a person with the same SIN in `Doctor` and `Patient`.
- Query (c) requires a drug with no row in `Sells`.
- Query (d) requires a company contracting with 50 or more distinct pharmacies.
- Query (e) requires a patient whose `insurance` value is `NULL`.

Therefore, an **empty result is not necessarily an incorrect query**. Additional fictional test records can be used to demonstrate the matching cases. Keep the submitted minimum dataset and any larger test dataset clearly separated.

## Project limitations

This is a course assignment rather than a deployable clinical system. It does not include a user interface, authentication/authorization, auditing, encryption strategy, transaction processing for real dispensing workflows, or regulatory compliance controls. The schema's business rules and demonstrations should not be treated as evidence that it is suitable for storing real medical information.

## Repository organization

A suggested GitHub layout is:

```text
COMP353-Pharmacy-Database/
├── README.md
├── sql/
│   └── pharmacy_database.sql
└── docs/
    ├── assignment.pdf
    └── er_diagram.pdf
```

Adjust the paths above to match the actual files in your repository; the assignment PDF and diagram are documentation artifacts, not files automatically created by the SQL script.

## Learning outcomes

Through this project, I practiced translating requirements into an ER model, identifying strong and weak entities, handling associative entities, using composite primary and foreign keys, managing circular references, and writing SQL for creation, insertion, deletion, joins, aggregation, and filtering.

## Academic context

Developed for **COMP 353 — Databases** at Concordia University as an academic assignment. The schema, queries, and examples are for learning and demonstration purposes.
