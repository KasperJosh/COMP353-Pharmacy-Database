# Pharmacy Chain Database Management System

**COMP 353 — Databases | Assignment 2 | Concordia University**  
**Author:** Joshua Visario  
**Technology:** MySQL 8, SQL, Visual Studio Code / MySQL Shell, MySQL Workbench, diagrams.net (draw.io)

A relational database project that models a pharmacy chain's patients, medical professionals, drugs, prescriptions, sales, and pharmaceutical supply contracts. The project progresses from an **entity–relationship (ER) diagram** to a **10-table relational schema**, then demonstrates schema creation, data insertion, referential integrity, deletion, and analytical SQL queries.

> **Academic project:** This is a database-design exercise, not a production pharmacy application or electronic health record (EHR). Use fictional data only. The original coursework may contain personally identifying example values; replace those before publishing any SQL files or database exports.

## Table of contents

- [Project structure](#project-structure)
- [Database design](#database-design)
- [Key design decisions](#key-design-decisions)
- [Getting started](#getting-started)
- [Running and testing Part III](#running-and-testing-part-iii)
- [Assignment deliverables](#assignment-deliverables)
- [Constraints and limitations](#constraints-and-limitations)
- [Troubleshooting](#troubleshooting)
- [What I learned](#what-i-learned)

## Project structure

The SQL files are organized by purpose, so creating tables, inserting data, querying, and deleting data can be performed independently.

```text
COMP353-Pharmacy-Database/
├── README.md
└── sql/
    ├── schema.sql               # Part II(a): create database and 10 tables
    ├── insert_data.sql          # Part II(b): original sample data and final FK setup
    ├── delete_data.sql          # Part II(c): delete original sample rows
    ├── drop_tables.sql          # Part II(d): drop the tables
    ├── part3_queries.sql        # Part III: five analytical queries
    ├── part3_testData.sql       # Extra records to exercise the Part III queries
    ├── view_current_data.sql    # Read-only inspection of tables and row counts
    └── pharmacy_database.sql    # Additional SQL file; check for overlapping setup
```

> **Note:** `pharmacy_database.sql` also appears in the project folder. Its execution role depends on its current contents; use the task-specific files above for the workflow described here, and avoid executing overlapping schema or insert scripts twice. ER-diagram and assignment PDF files can be kept separately with course documentation.

## Database design

The relational implementation contains **10 tables**.

| Table | Purpose | Primary key |
| --- | --- | --- |
| `Doctor` | Physician identity, specialty, and experience | `doctorSIN` |
| `Patient` | Patient details, insurance, and primary physician | `patientSIN` |
| `Pharmacist` | Pharmacist details and employing pharmacy | `pharmacistSIN` |
| `Pharmacy` | Pharmacy location and designated main pharmacist | `pharmacyID` |
| `PharmaceuticalCompany` | Manufacturer contact information | `pharmCompanyName` |
| `Drug` | Drug trade name and formula, identified within a company | (`tradeName`, `pharmCompanyName`) |
| `Prescription` | Doctor–patient–drug prescriptions, date, and quantity | `prescriptionID` |
| `Contract` | Pharmacy–company contracts and current supervisor | `contractID` |
| `Sells` | Which pharmacies sell which drugs, at what price | (`pharmacyID`, `tradeName`, `pharmCompanyName`) |
| `PrescriptionPurchase` | Prescription purchases and approving pharmacist | `purchaseID` |

### Relationships

| Relationship | Cardinality / rule |
| --- | --- |
| Patient → primary Doctor | Many-to-one; each patient has one primary physician |
| Drug → PharmaceuticalCompany (`Produces`) | Many-to-one; a drug is identified within its producing company |
| Pharmacy ↔ Drug (`Sells`) | Many-to-many, with a price per pharmacy–drug pair |
| Pharmacist → Pharmacy (`Employs`) | Many-to-one in this design; each pharmacist works at one pharmacy |
| Pharmacy ↔ main Pharmacist | One-to-one designation under the employment assumption; main pharmacist works at that pharmacy |
| Prescription → Patient, Doctor, Drug | Many-to-one from each prescription to each referenced entity |
| Contract → Pharmacy, PharmaceuticalCompany, Pharmacist | Many-to-one from each contract to its pharmacy, company, and current supervisor |
| PrescriptionPurchase → Prescription, Pharmacy, Pharmacist | Many-to-one; an approving pharmacist must work at the purchase pharmacy |

### ER model

- **Weak entity:** `Drug`, whose key combines its `tradeName` (partial identifier) with the identifying pharmaceutical company.
- **Associative entities:** `Prescription` (linking Doctor, Patient, and Drug) and `Contract` (linking Pharmacy and PharmaceuticalCompany).
- **Relationship with attributes:** `Sells`, whose `price` belongs to a pharmacy–drug offering in the original requirements.
- **Separate purchase records:** `PrescriptionPurchase` records a purchase independently of the prescription's definition.

The ER diagram and full assignment report document the conceptual model and the decisions behind this relational implementation.

## Key design decisions

### 1. Weak `Drug` entity and composite keys

The same drug trade name can be associated with different manufacturers. The unique drug identifier therefore uses both attributes:

```sql
PRIMARY KEY (tradeName, pharmCompanyName)
```

The composite key is also referenced by `Prescription` and `Sells`.

### 2. One retained prescription per doctor–patient–drug combination

```sql
UNIQUE (doctorSIN, patientSIN, tradeName, pharmCompanyName)
```

This prevents storing multiple rows for an identical combination. **It does not automatically retain the latest prescription:** a later prescription must update the existing row using `UPDATE` or an insert-or-update operation.

### 3. Main pharmacist and circular foreign keys

`Pharmacy` identifies its main pharmacist, while `Pharmacist` identifies the pharmacy where the person works. These references create a **circular dependency** during initial setup.

The sample-data initialization follows this order:

1. Create `Pharmacy` with `mainPharmacistSIN` temporarily nullable.
2. Create `Pharmacist` with its foreign key to `Pharmacy`.
3. Insert a pharmacy, then insert its pharmacist.
4. Update the pharmacy to assign that pharmacist as the main pharmacist.
5. Change `mainPharmacistSIN` to `NOT NULL` and add the composite foreign key `(mainPharmacistSIN, pharmacyID)` referencing `Pharmacist(pharmacistSIN, pharmacyID)`.

The final composite foreign key ensures the selected main pharmacist **works at the same pharmacy**. The complete constraint is established by `insert_data.sql`, not by the initial `CREATE TABLE Pharmacy` statement alone.

### 4. Approving pharmacists

`PrescriptionPurchase` uses a composite foreign key on `(approvedBySIN, pharmacyID)` to ensure that the approving pharmacist is employed at the pharmacy processing the purchase.

### 5. Contract supervision

Each contract stores one non-null `supervisorSIN` referencing `Pharmacist`. The database stores the **current** supervisor; historical supervisor assignments are not tracked.

### 6. Hypothetical fixed drug prices (Part I, Question 4)

The original design permits pharmacies to charge different prices for the same drug, so `price` belongs in `Sells`. If all pharmacies must charge the same price for a drug, the conceptual modification is:

```text
Original: Drug(tradeName, pharmCompanyName, formula)
          Sells(pharmacyID, tradeName, pharmCompanyName, price)

Revised:  Drug(tradeName, pharmCompanyName, formula, price)
          Sells(pharmacyID, tradeName, pharmCompanyName)
```

**The implemented SQL retains the original variable-price design.** The fixed-price version is a proposed schema change for the assignment, not a second implementation.

## Getting started

### Prerequisites

- MySQL Server 8.x and a working local connection.
- MySQL Workbench **or** the MySQL Shell extension for Visual Studio Code.
- The SQL scripts in the `sql/` directory.

### Recommended execution order

Run these against a **disposable coursework database**. `schema.sql` starts by dropping and recreating `pharmacy_database`, which **permanently removes its existing tables and rows**.

| Step | Script | Purpose |
| --- | --- | --- |
| 1 | `sql/schema.sql` | Create `pharmacy_database` and its 10 empty tables. |
| 2 | `sql/insert_data.sql` | Insert original sample records and finalize main-pharmacist constraints. |
| 3 | `sql/view_current_data.sql` | Inspect the populated tables without changing any data. |
| 4 | `sql/part3_queries.sql` | Run the five Part III queries on the available data. |
| 5 (optional) | `sql/part3_testData.sql` | Add a larger fictional dataset so each Part III query has meaningful results. |
| 6 (optional) | `sql/part3_queries.sql` | Re-run the queries on that expanded dataset. |

**Do not run** `delete_data.sql` or `drop_tables.sql` before analyzing the data. They demonstrate separate assignment requirements and remove rows or tables.

In MySQL Workbench or VS Code, select `pharmacy_database` as the active database, or execute:

```sql
USE pharmacy_database;
SELECT DATABASE();
SHOW TABLES;
```

After setting up all tables, `SHOW TABLES` should return **10 tables**. To verify that the main-pharmacist constraints were added, use:

```sql
SHOW CREATE TABLE Pharmacy;
SHOW CREATE TABLE Pharmacist;
```

### Viewing current data

`view_current_data.sql` is a **read-only** script. It provides table row counts and `SELECT *` outputs for all 10 tables. It shows the *live contents* of your MySQL database; it is **not** a saved snapshot or a database export.

## Running and testing Part III

`part3_queries.sql` contains the five queries required by the assignment.

| Question | Goal | Main SQL concepts |
| --- | --- | --- |
| **(a)** | Find patients associated with at least three distinct prescribing doctors | `JOIN`, `GROUP BY`, `HAVING`, `COUNT(DISTINCT)` |
| **(b)** | Find doctors who are also patients and identify their primary physicians | Two joins to `Doctor`, table aliases |
| **(c)** | Find drugs that no pharmacy sells | Composite `LEFT JOIN`, `IS NULL` |
| **(d)** | List companies contracting with at least 50 distinct pharmacies, sorted by total number of contracts | `JOIN`, `COUNT(*)`, `COUNT(DISTINCT)`, `HAVING`, `ORDER BY` |
| **(e)** | List uninsured patients with specified contact details, ordered by name | `IS NULL`, `ORDER BY` |

**Interpretation of (a):** The submitted query uses recorded prescriptions as evidence of a patient–doctor relationship. A primary physician who has not issued a recorded prescription is not counted by this particular query.

### Expanded test dataset

The original Part II(b) insert script provides a small sample—normally one record per table—and some valid Part III queries return **zero rows** on that dataset. The optional `part3_testData.sql` adds extra fictional records to test all five queries, including **49 additional pharmacies**, their pharmacists, and contracts with **50 distinct pharmacies**.

The expanded data was used to demonstrate the following expected results:

| Query | Expected demonstration result |
| --- | --- |
| **(a)** | Original patient appears with prescriptions from three distinct doctors |
| **(b)** | Dr. Test Chen → Dr. John Doe |
| **(c)** | `TestUnsoldDrug` — Johnson & Johnson |
| **(d)** | Johnson & Johnson: **51 contracts**; Test Pharma B: **50 contracts** |
| **(e)** | Aaron Sample, then Nora Sample (ascending name order) |

**Verified example:** Query (d) was run against the expanded data and returned 51 and 50 contracts in descending order. The other entries are expected results of the test setup, not a claim that every query was independently verified.

> **Important test-data caution:** `part3_testData.sql` is **not safe to re-run unchanged**: its `INSERT` statements use fixed primary keys, and it temporarily alters the circular Pharmacy–Pharmacist constraint. Run it on a fresh database after steps 1–2, and allow the script to finish restoring the `NOT NULL` and foreign-key constraints. If an execution stops midway, inspect the tables and constraints before resuming; do not simply run the full script again.

## Assignment deliverables

| Assignment part | Deliverable | Location |
| --- | --- | --- |
| **Part I** | Conceptual ER diagram, cardinalities, relational mapping, and fixed-price variation | Assignment report / ER diagram document |
| **Part II(a)** | `CREATE TABLE` statements and constraints | `sql/schema.sql` |
| **Part II(b)** | Original example inserts | `sql/insert_data.sql` |
| **Part II(c)** | Delete the rows inserted in Part II(b) | `sql/delete_data.sql` |
| **Part II(d)** | Drop the tables created in Part II(a) | `sql/drop_tables.sql` |
| **Part III** | Five SQL queries | `sql/part3_queries.sql` |
| **Supplementary** | Expanded query-test data and live-table inspection | `sql/part3_testData.sql`, `sql/view_current_data.sql` |

`delete_data.sql` is written for the **original sample records**, not necessarily for every row added by the expanded Part III test dataset. Use a fresh disposable database for cleanup demonstrations after extensive testing.

## Constraints and limitations

The project enforces primary keys, selected `NOT NULL` constraints, foreign keys, composite keys, and prescription uniqueness. Some requirements are documented but **not fully enforced** by the SQL schema alone:

- Every doctor has at least one patient.
- Every pharmacy sells several drugs.
- A newer prescription replaces the previous stored prescription for the same doctor–patient–drug combination.
- A drug purchased at a pharmacy is necessarily listed in that pharmacy's `Sells` records.
- The database does not preserve past contract-supervisor assignments.

These would require additional validation, application logic, procedures/triggers, or schema extensions in a more complete system. The project also does not provide a production UI, authentication, auditing, clinical safeguards, or healthcare privacy controls.

## Troubleshooting

| Error / symptom | Likely cause | Suggested action |
| --- | --- | --- |
| **1046: No database selected** | The connection has no default schema | Execute `USE pharmacy_database;`. |
| **1050: Table already exists** | Schema creation was executed again | Do not re-run `schema.sql` unless intentionally resetting. |
| **1062: Duplicate entry** | An `INSERT` with the same primary key already succeeded | Inspect existing records and resume after the completed statement. |
| **1146: Table doesn't exist** | Wrong active database or schema not created | Run `SELECT DATABASE();` and `SHOW TABLES;`. |
| **1452: Cannot add or update a child row** | A referenced parent row is missing | Insert parent records (for example Doctor, Patient, Drug) first. |
| **1048: Column cannot be null** | `mainPharmacistSIN` is `NOT NULL` during staged test inserts | Use the documented nullable-column initialization sequence, then restore constraints. |
| **1136: Column count doesn't match value count** | Different number of columns and values in an `INSERT` | Check each row in the `VALUES` clause. |
| **Correct query returns zero rows** | Sample data does not meet the query's conditions | Run the optional expanded test data on a fresh instance. |

A successful SQL statement generally **remains applied** even if a later statement in the script fails. Check database state before retrying an interrupted script.

## What I learned

This assignment provided hands-on practice with:

- Translating business requirements into an ER diagram and relational schema.
- Identifying weak and associative entities.
- Designing primary keys, composite keys, foreign keys, and uniqueness constraints.
- Managing circular referential dependencies during initialization.
- Writing DDL (`CREATE`, `ALTER`, `DROP`) and DML (`INSERT`, `SELECT`, `UPDATE`, `DELETE`).
- Writing multi-table joins, anti-joins, aggregations, and filtered queries.
- Building test data that validates query behavior rather than merely populating tables.

---

**Course:** COMP 353 — Databases, Concordia University  
**Purpose:** Academic learning and demonstration. Not intended for real clinical deployment.
