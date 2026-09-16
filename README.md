# Hospital Management — SQL Practice

A self-contained SQL script covering aggregate functions, joins and subqueries, built around a small hospital management schema. 45 numbered questions, each with the query and an explanatory comment.

## Contents

| File | Description |
|---|---|
| `hospital_management_sql_practice.sql` | Schema, sample data and all 45 queries |

## Schema

Eight tables:

| Table | Rows | Description |
|---|---|---|
| `Patients` | 10 | Registered patients |
| `Departments` | 6 | Hospital departments |
| `Doctors` | 10 | Doctors, each in one department |
| `Appointments` | 20 | Patient–doctor consultations |
| `Admissions` | 10 | In-patient stays |
| `Medicines` | 10 | Medicine catalogue with unit prices |
| `Prescriptions` | 20 | Medicines issued per appointment |
| `Bills` | 16 | Billing records |

Relationships:

```
Departments 1---* Doctors 1---* Appointments *---1 Patients
                                    |                 |
                                    |                 +---* Admissions
                                    +---* Prescriptions *---1 Medicines
                                    +---* Bills
```

## Getting started

```sql
-- 1. Create the schema
--    Run PART 1 of the script

-- 2. Select the database
USE hospital_management1;        -- MySQL
-- \c hospital_management1       -- PostgreSQL

-- 3. Load the sample data
--    Run PART 2

-- 4. Run individual queries from PART 3
```

## Question index

### Section A — Basic SELECT and filtering
| # | Question |
|---|---|
| Q1 | List all patients |
| Q2 | List all doctors |
| Q3 | List all departments |
| Q4 | Patients older than 60 |
| Q5 | Doctors earning more than 80,000 |

### Section B — Aggregate functions, GROUP BY, HAVING
| # | Question |
|---|---|
| Q6 | Total number of patients |
| Q7 | Doctor count per department |
| Q8 | Average doctor salary |
| Q9 | Total value of all bills |
| Q10 | Departments with more than 3 doctors |

### Section C — Joins
| # | Question |
|---|---|
| Q11 | Each doctor with their department name |
| Q12 | Each patient with the doctors they consulted |
| Q13 | Patient, doctor and department together |
| Q14 | Patients who never booked an appointment |
| Q15 | Doctors never assigned an appointment |
| Q16 | Departments with no doctors |
| Q17 | Full appointment report with names |

### Section D — Subqueries
| # | Question |
|---|---|
| Q18 | Doctors above the hospital-wide average salary |
| Q19 | Doctors above their own department's average |
| Q20 | Highest-paid doctor |
| Q21 | Second-highest salary |
| Q22 | Salary greater than ALL doctors in an empty department |
| Q23 | Salary greater than ANY doctor in an empty department |
| Q24 | Patients older than the average age |
| Q25 | Patients with at least one appointment (`EXISTS`) |

### Section E — Top-N / ranking
| # | Question |
|---|---|
| Q26 | Department with the most doctors |
| Q27 | Department with the highest average salary |
| Q28 | Doctor who treated the most distinct patients |
| Q29 | Patient with the most appointments |
| Q30 | Doctor with the most cancellations |
| Q31 | Department with the highest total billing |
| Q32 | Patients never admitted |
| Q33 | Top earner within each department |
| Q34 | Most prescribed medicine by units |
| Q35 | Top-selling medicine by revenue |

### Section F — Advanced filtering and derived tables
| # | Question |
|---|---|
| Q36 | Bills above the average bill amount |
| Q37 | Departments above the hospital-wide average salary |
| Q38 | Patients who consulted more than one doctor |
| Q39 | Doctors with patients from more than one city |
| Q40 | Departments handling more than 5 appointments |
| Q41 | Patients billed above the average patient total |
| Q42 | Doctors above the average distinct-patient count |
| Q43 | Length of stay per admission |
| Q44 | Doctor count per department, including empty ones |
| Q45 | Appointment completion rate per doctor |

## Concepts covered

- `WHERE` vs `HAVING` — filtering before and after grouping
- `COUNT(*)` vs `COUNT(column)` vs `COUNT(DISTINCT column)`
- `INNER JOIN`, `LEFT JOIN`, and the `LEFT JOIN ... IS NULL` anti-join pattern
- Scalar, correlated and nested subqueries
- `ALL` vs `ANY` against an empty result set — Q22 and Q23 return opposite results on identical data
- `EXISTS` for existence checks
- Derived tables (subqueries in `FROM`) for aggregating an aggregate
- `CASE` inside an aggregate as a conditional count

## Dialect notes

Written for MySQL 8.x and PostgreSQL 12+.

- `LIMIT n` — SQL Server uses `SELECT TOP n` instead
- `DATEDIFF(a, b)` in Q43 is MySQL; PostgreSQL uses `a - b`
- `LIMIT 1` discards ties. Use `RANK() OVER (ORDER BY ...)` where every tied row should be returned
