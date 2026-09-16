/* =============================================================================
   HOSPITAL MANAGEMENT SYSTEM — SQL PRACTICE SCRIPT
   =============================================================================
   Topics   : Aggregate functions, GROUP BY / HAVING, Joins, Subqueries
   Database : hospital_management1
   Dialect  : MySQL 8.x / PostgreSQL 12+ (LIMIT syntax; use TOP for SQL Server)
   Tables   : Patients, Doctors, Departments, Appointments,
              Admissions, Medicines, Prescriptions, Bills
   Questions: 45

   HOW TO RUN
     1. Execute PART 1 to create the schema.
     2. Switch into the database:
          MySQL       ->  USE hospital_management1;
          PostgreSQL  ->  \c hospital_management1
     3. Execute PART 2 to load the sample data.
     4. Run the queries in PART 3 individually.
   ============================================================================= */


/* =============================================================================
   PART 1 — SCHEMA DEFINITION
   ============================================================================= */

CREATE DATABASE hospital_management1;

-- Switch into the new database before continuing.
-- USE hospital_management1;


-- Patients: one row per registered patient.
CREATE TABLE Patients (
    patient_id    INT PRIMARY KEY,
    patient_name  VARCHAR(50),
    age           INT,
    city          VARCHAR(50)
);

-- Departments: lookup table of hospital departments.
CREATE TABLE Departments (
    department_id    INT PRIMARY KEY,
    department_name  VARCHAR(50)
);

-- Doctors: each doctor belongs to exactly one department.
-- NUMERIC(10,2) allows up to 10 digits with 2 decimal places.
CREATE TABLE Doctors (
    doctor_id      INT PRIMARY KEY,
    doctor_name    VARCHAR(50),
    department_id  INT,
    salary         NUMERIC(10,2),
    FOREIGN KEY (department_id) REFERENCES Departments(department_id)
);

-- Appointments: a consultation between one patient and one doctor.
-- status holds 'Completed' or 'Cancelled'.
CREATE TABLE Appointments (
    appointment_id    INT PRIMARY KEY,
    patient_id        INT,
    doctor_id         INT,
    appointment_date  DATE,
    status            VARCHAR(20),
    FOREIGN KEY (patient_id) REFERENCES Patients(patient_id),
    FOREIGN KEY (doctor_id)  REFERENCES Doctors(doctor_id)
);

-- Admissions: in-patient stays. A NULL discharge_date means still admitted.
CREATE TABLE Admissions (
    admission_id    INT PRIMARY KEY,
    patient_id      INT,
    admission_date  DATE,
    discharge_date  DATE,
    FOREIGN KEY (patient_id) REFERENCES Patients(patient_id)
);

-- Medicines: catalogue with unit price.
CREATE TABLE Medicines (
    medicine_id    INT PRIMARY KEY,
    medicine_name  VARCHAR(50),
    price          NUMERIC(10,2)
);

-- Prescriptions: bridge table between appointments and medicines.
CREATE TABLE Prescriptions (
    prescription_id  INT PRIMARY KEY,
    appointment_id   INT,
    medicine_id      INT,
    quantity         INT,
    FOREIGN KEY (appointment_id) REFERENCES Appointments(appointment_id),
    FOREIGN KEY (medicine_id)    REFERENCES Medicines(medicine_id)
);

-- Bills: billing record for an appointment.
CREATE TABLE Bills (
    bill_id         INT PRIMARY KEY,
    patient_id      INT,
    appointment_id  INT,
    bill_amount     NUMERIC(10,2),
    FOREIGN KEY (patient_id)     REFERENCES Patients(patient_id),
    FOREIGN KEY (appointment_id) REFERENCES Appointments(appointment_id)
);


/* =============================================================================
   PART 2 — SAMPLE DATA
   Insert order matters: parents (Patients, Departments, Medicines) first.
   ============================================================================= */

-- 10 patients, ages 29-75, spread across 8 cities.
INSERT INTO Patients VALUES
(1,'Arun Kumar',65,'Chennai'),
(2,'Priya Devi',45,'Puducherry'),
(3,'Ravi Shankar',72,'Bangalore'),
(4,'Meena Rani',58,'Mumbai'),
(5,'Karthik Raj',34,'Chennai'),
(6,'Divya Sri',67,'Puducherry'),
(7,'Suresh Babu',51,'Hyderabad'),
(8,'Anitha Devi',29,'Coimbatore'),
(9,'Vijay Kumar',75,'Madurai'),
(10,'Sneha Priya',40,'Salem');

-- 6 departments. Dermatology (6) deliberately has no doctors — used by Q16.
INSERT INTO Departments VALUES
(1,'Cardiology'),
(2,'Neurology'),
(3,'Orthopedics'),
(4,'Pediatrics'),
(5,'General Medicine'),
(6,'Dermatology');

-- 10 doctors, two per department for departments 1-5.
INSERT INTO Doctors VALUES
(101,'Dr. Rajesh',1,95000),
(102,'Dr. Priya',1,85000),
(103,'Dr. Kumar',2,120000),
(104,'Dr. Anitha',2,90000),
(105,'Dr. Suresh',3,75000),
(106,'Dr. Meena',3,110000),
(107,'Dr. Arun',4,65000),
(108,'Dr. Divya',4,88000),
(109,'Dr. Ravi',5,130000),
(110,'Dr. Sneha',5,100000);

-- 20 appointments across Jan-Jun 2026.
-- Patient 10 has no appointments — used by Q14.
INSERT INTO Appointments VALUES
(1001,1,101,'2026-01-10','Completed'),(1002,1,102,'2026-01-15','Completed'),
(1003,2,103,'2026-02-05','Completed'),(1004,3,101,'2026-02-10','Completed'),
(1005,3,104,'2026-02-15','Cancelled'),(1006,4,105,'2026-03-01','Completed'),
(1007,5,106,'2026-03-05','Completed'),(1008,6,107,'2026-03-10','Cancelled'),
(1009,6,108,'2026-03-15','Completed'),(1010,7,109,'2026-04-01','Completed'),
(1011,8,110,'2026-04-05','Completed'),(1012,1,103,'2026-04-10','Completed'),
(1013,9,101,'2026-04-15','Cancelled'),(1014,9,102,'2026-04-20','Completed'),
(1015,2,106,'2026-05-01','Completed'),(1016,3,109,'2026-05-05','Completed'),
(1017,4,106,'2026-05-10','Cancelled'),(1018,5,110,'2026-05-15','Completed'),
(1019,7,109,'2026-05-20','Completed'),(1020,9,103,'2026-06-01','Completed');

-- One admission per patient, all discharged.
INSERT INTO Admissions VALUES
(501,1,'2026-01-10','2026-01-15'),(502,3,'2026-02-10','2026-02-18'),
(503,4,'2026-03-01','2026-03-05'),(504,6,'2026-03-10','2026-03-15'),
(505,7,'2026-04-01','2026-04-07'),(506,9,'2026-04-15','2026-04-22'),
(507,2,'2026-05-01','2026-05-04'),(508,5,'2026-05-10','2026-05-14'),
(509,8,'2026-05-15','2026-05-18'),(510,10,'2026-06-01','2026-06-05');

-- Medicine catalogue, unit prices 50-200.
INSERT INTO Medicines VALUES
(201,'Paracetamol',50),(202,'Amoxicillin',120),
(203,'Azithromycin',150),(204,'Ibuprofen',80),
(205,'Metformin',100),(206,'Atorvastatin',200),
(207,'Omeprazole',90),(208,'Cetirizine',60),
(209,'Aspirin',70),(210,'Pantoprazole',110);

-- Prescriptions. Appointment 1001 has two lines — one appointment can carry
-- multiple medicines.
INSERT INTO Prescriptions VALUES
(301,1001,201,2),(302,1001,207,1),(303,1002,202,2),(304,1003,203,1),(305,1004,201,3),
(306,1005,204,2),(307,1006,205,2),(308,1007,206,1),(309,1008,208,2),(310,1009,201,2),
(311,1010,209,1),(312,1011,210,2),(313,1012,201,3),(314,1013,204,2),(315,1014,207,1),
(316,1015,202,2),(317,1016,203,1),(318,1017,201,2),(319,1018,205,1),(320,1019,206,2);

-- Bills, one per completed appointment.
-- Required by Q9, Q31, Q36 and Q44 — without these rows those queries return
-- NULL or an empty result set.
INSERT INTO Bills VALUES
(901,1,1001,5000),(902,1,1002,3500),(903,2,1003,7200),(904,3,1004,4100),
(905,4,1006,6800),(906,5,1007,2900),(907,6,1009,8300),(908,7,1010,5600),
(909,8,1011,3100),(910,1,1012,4600),(911,9,1014,9400),(912,2,1015,4700),
(913,3,1016,6200),(914,5,1018,5300),(915,7,1019,7800),(916,9,1020,8900);


/* =============================================================================
   PART 3 — QUERIES
   ============================================================================= */

/* -----------------------------------------------------------------------------
   SECTION A — BASIC SELECT AND FILTERING (Q1-Q5)
   ----------------------------------------------------------------------------- */

-- Q1. List all patients.
SELECT *
FROM Patients;


-- Q2. List all doctors.
SELECT *
FROM Doctors;


-- Q3. List all departments.
SELECT *
FROM Departments;


-- Q4. List patients older than 60.
-- WHERE filters rows before they are returned.
SELECT *
FROM Patients
WHERE age > 60;


-- Q5. List doctors earning more than 80,000.
SELECT *
FROM Doctors
WHERE salary > 80000;


/* -----------------------------------------------------------------------------
   SECTION B — AGGREGATE FUNCTIONS, GROUP BY, HAVING (Q6-Q10)
   ----------------------------------------------------------------------------- */

-- Q6. Count the total number of patients.
-- COUNT(*) counts rows, including rows with NULL columns.
SELECT COUNT(*) AS patient_count
FROM Patients;


-- Q7. Count the number of doctors in each department.
-- GROUP BY collapses the table into one row per department_id.
SELECT department_id,
       COUNT(*) AS doctor_count
FROM Doctors
GROUP BY department_id;


-- Q8. Find the average salary of all doctors.
-- AVG ignores NULL values.
SELECT AVG(salary) AS average_salary
FROM Doctors;


-- Q9. Find the total value of all bills.
SELECT SUM(bill_amount) AS total_bill_amount
FROM Bills;


-- Q10. Find departments that employ more than 3 doctors.
-- HAVING filters after grouping; WHERE cannot reference an aggregate.
-- Returns no rows with this dataset — each department has exactly 2 doctors.
SELECT department_id,
       COUNT(*) AS doctor_count
FROM Doctors
GROUP BY department_id
HAVING COUNT(*) > 3;


/* -----------------------------------------------------------------------------
   SECTION C — JOINS (Q11-Q17)
   ----------------------------------------------------------------------------- */

-- Q11. Show each doctor with their department name.
-- INNER JOIN returns only rows that match on both sides.
SELECT d.doctor_name,
       dp.department_name
FROM Doctors d
JOIN Departments dp ON d.department_id = dp.department_id;


-- Q12. Show each patient with the doctors they consulted.
-- One row per appointment, so a repeat visitor appears more than once.
SELECT p.patient_name,
       d.doctor_name
FROM Patients p
JOIN Appointments a ON p.patient_id = a.patient_id
JOIN Doctors d      ON a.doctor_id  = d.doctor_id;


-- Q13. Show each patient with their doctor and that doctor's department.
SELECT p.patient_name,
       d.doctor_name,
       dp.department_name
FROM Patients p
JOIN Appointments a ON p.patient_id    = a.patient_id
JOIN Doctors d      ON a.doctor_id     = d.doctor_id
JOIN Departments dp ON d.department_id = dp.department_id;


-- Q14. Find patients who have never booked an appointment.
-- Anti-join pattern: LEFT JOIN keeps every patient, then IS NULL keeps only
-- those with no matching appointment. Expected result: patient 10.
SELECT p.*
FROM Patients p
LEFT JOIN Appointments a ON p.patient_id = a.patient_id
WHERE a.patient_id IS NULL;


-- Q15. Find doctors who have never been assigned an appointment.
-- Same anti-join pattern. Expected result: no rows.
SELECT d.*
FROM Doctors d
LEFT JOIN Appointments a ON d.doctor_id = a.doctor_id
WHERE a.doctor_id IS NULL;


-- Q16. Find departments that have no doctors.
-- Expected result: Dermatology.
SELECT dp.*
FROM Departments dp
LEFT JOIN Doctors d ON dp.department_id = d.department_id
WHERE d.doctor_id IS NULL;


-- Q17. Produce a full appointment report with patient and doctor names.
SELECT a.appointment_id,
       p.patient_name,
       d.doctor_name,
       a.appointment_date,
       a.status
FROM Appointments a
JOIN Patients p ON a.patient_id = p.patient_id
JOIN Doctors d  ON a.doctor_id  = d.doctor_id;


/* -----------------------------------------------------------------------------
   SECTION D — SUBQUERIES (Q18-Q25)
   ----------------------------------------------------------------------------- */

-- Q18. Find doctors earning above the hospital-wide average salary.
-- Scalar subquery: the inner query returns a single value.
SELECT *
FROM Doctors
WHERE salary > (SELECT AVG(salary) FROM Doctors);


-- Q19. Find doctors earning above the average salary of their OWN department.
-- Correlated subquery: the inner query references the outer row (d.department_id)
-- and is evaluated once per candidate row.
SELECT d.*
FROM Doctors d
WHERE d.salary > (SELECT AVG(d2.salary)
                  FROM Doctors d2
                  WHERE d2.department_id = d.department_id);


-- Q20. Find the highest-paid doctor.
-- Comparing with = MAX(...) also returns ties, unlike ORDER BY ... LIMIT 1.
SELECT *
FROM Doctors
WHERE salary = (SELECT MAX(salary) FROM Doctors);


-- Q21. Find the second-highest doctor salary.
-- Take the maximum of everything strictly below the overall maximum.
SELECT MAX(salary) AS second_highest_salary
FROM Doctors
WHERE salary < (SELECT MAX(salary) FROM Doctors);


-- Setup for Q22 and Q23: add a department that has no doctors, so the inner
-- subquery in both returns an empty set.
INSERT INTO Departments VALUES (7,'HR');


-- Q22. Find doctors earning more than ALL doctors in the HR department.
-- > ALL (empty set) evaluates to TRUE, so every doctor is returned.
SELECT *
FROM Doctors
WHERE salary > ALL (SELECT salary
                    FROM Doctors
                    WHERE department_id = (SELECT department_id
                                           FROM Departments
                                           WHERE department_name = 'HR'));


-- Q23. Find doctors earning more than ANY doctor in the HR department.
-- > ANY (empty set) evaluates to FALSE, so no rows are returned — the exact
-- opposite of Q22 on the same data. This contrast is the point of the pair.
SELECT *
FROM Doctors
WHERE salary > ANY (SELECT salary
                    FROM Doctors
                    WHERE department_id = (SELECT department_id
                                           FROM Departments
                                           WHERE department_name = 'HR'));


-- Q24. Find patients older than the average patient age.
SELECT *
FROM Patients
WHERE age > (SELECT AVG(age) FROM Patients);


-- Q25. Find patients who have at least one appointment.
-- EXISTS stops at the first match, so SELECT 1 is enough — the selected value
-- is never read.
SELECT *
FROM Patients p
WHERE EXISTS (SELECT 1
              FROM Appointments a
              WHERE a.patient_id = p.patient_id);


/* -----------------------------------------------------------------------------
   SECTION E — TOP-N / RANKING (Q26-Q35)

   Pattern: aggregate -> ORDER BY the aggregate DESC -> LIMIT 1.
   Caveat : LIMIT 1 silently discards ties. Use RANK() OVER (ORDER BY ...) if
            every tied row should be returned.
   Dialect: LIMIT is MySQL/PostgreSQL. SQL Server uses SELECT TOP 1.
   ----------------------------------------------------------------------------- */

-- Q26. Find the department with the most doctors.
SELECT department_id,
       COUNT(*) AS doctor_count
FROM Doctors
GROUP BY department_id
ORDER BY doctor_count DESC
LIMIT 1;


-- Q27. Find the department with the highest average salary.
SELECT department_id,
       AVG(salary) AS average_salary
FROM Doctors
GROUP BY department_id
ORDER BY average_salary DESC
LIMIT 1;


-- Q28. Find the doctor who treated the most distinct patients (completed visits).
-- COUNT(DISTINCT ...) prevents a repeat visitor being counted twice.
SELECT doctor_id,
       COUNT(DISTINCT patient_id) AS patient_count
FROM Appointments
WHERE status = 'Completed'
GROUP BY doctor_id
ORDER BY patient_count DESC
LIMIT 1;


-- Q29. Find the patient with the most appointments booked, any status.
SELECT patient_id,
       COUNT(*) AS appointment_count
FROM Appointments
GROUP BY patient_id
ORDER BY appointment_count DESC
LIMIT 1;


-- Q30. Find the doctor with the most cancelled appointments.
SELECT doctor_id,
       COUNT(*) AS cancelled_count
FROM Appointments
GROUP BY doctor_id
HAVING SUM(CASE WHEN status = 'Cancelled' THEN 1 ELSE 0 END) > 0
ORDER BY cancelled_count DESC
LIMIT 1;
-- Simpler equivalent, filtering before grouping:
-- SELECT doctor_id, COUNT(*) AS cancelled_count
-- FROM Appointments WHERE status = 'Cancelled'
-- GROUP BY doctor_id ORDER BY cancelled_count DESC LIMIT 1;


-- Q31. Find the department that generated the highest total billing.
-- Chain: Bills -> Appointments -> Doctors -> department_id.
SELECT d.department_id,
       SUM(b.bill_amount) AS total_bill
FROM Bills b
JOIN Appointments a ON b.appointment_id = a.appointment_id
JOIN Doctors d      ON a.doctor_id      = d.doctor_id
GROUP BY d.department_id
ORDER BY total_bill DESC
LIMIT 1;


-- Q32. Find patients who were never admitted as in-patients.
SELECT p.*
FROM Patients p
LEFT JOIN Admissions a ON p.patient_id = a.patient_id
WHERE a.patient_id IS NULL;


-- Q33. Find the top earner within each department.
-- Correlated subquery comparing each doctor to their department's maximum.
SELECT *
FROM Doctors d
WHERE d.salary = (SELECT MAX(d2.salary)
                  FROM Doctors d2
                  WHERE d2.department_id = d.department_id);


-- Q34. Find the most prescribed medicine by total units dispensed.
-- SUM(quantity), not COUNT(*) — one prescription may cover several units.
SELECT medicine_id,
       SUM(quantity) AS total_quantity
FROM Prescriptions
GROUP BY medicine_id
ORDER BY total_quantity DESC
LIMIT 1;


-- Q35. Find the top-selling medicine by revenue (quantity x unit price).
-- medicine_name must appear in GROUP BY: it is selected but not aggregated.
SELECT m.medicine_id,
       m.medicine_name,
       SUM(p.quantity * m.price) AS total_sales
FROM Medicines m
JOIN Prescriptions p ON m.medicine_id = p.medicine_id
GROUP BY m.medicine_id, m.medicine_name
ORDER BY total_sales DESC
LIMIT 1;


/* -----------------------------------------------------------------------------
   SECTION F — ADVANCED FILTERING AND DERIVED TABLES (Q36-Q45)
   ----------------------------------------------------------------------------- */

-- Q36. Find bills above the average bill amount.
SELECT *
FROM Bills
WHERE bill_amount > (SELECT AVG(bill_amount) FROM Bills);


-- Q37. Find departments whose average salary beats the hospital-wide average.
-- HAVING compared against a scalar subquery.
SELECT department_id,
       AVG(salary) AS average_salary
FROM Doctors
GROUP BY department_id
HAVING AVG(salary) > (SELECT AVG(salary) FROM Doctors);


-- Q38. Find patients who consulted more than one distinct doctor.
SELECT patient_id,
       COUNT(DISTINCT doctor_id) AS doctor_count
FROM Appointments
GROUP BY patient_id
HAVING COUNT(DISTINCT doctor_id) > 1;


-- Q39. Find doctors whose patients come from more than one city.
SELECT a.doctor_id,
       COUNT(DISTINCT p.city) AS city_count
FROM Appointments a
JOIN Patients p ON a.patient_id = p.patient_id
GROUP BY a.doctor_id
HAVING COUNT(DISTINCT p.city) > 1;


-- Q40. Find departments that handled more than 5 appointments.
SELECT d.department_id,
       COUNT(*) AS appointment_count
FROM Appointments a
JOIN Doctors d ON a.doctor_id = d.doctor_id
GROUP BY d.department_id
HAVING COUNT(*) > 5;


-- Q41. Find patients whose total billing exceeds the average patient total.
-- Derived table: the inner query in the FROM clause produces one total per
-- patient; the outer query averages those totals. The alias (x) is mandatory.
SELECT patient_id,
       SUM(bill_amount) AS total_bill
FROM Bills
GROUP BY patient_id
HAVING SUM(bill_amount) > (SELECT AVG(x.total_bill)
                           FROM (SELECT SUM(bill_amount) AS total_bill
                                 FROM Bills
                                 GROUP BY patient_id) x);


-- Q42. Find doctors who treated more distinct patients than the average doctor.
-- Same derived-table pattern applied to a COUNT.
SELECT doctor_id,
       COUNT(DISTINCT patient_id) AS patient_count
FROM Appointments
GROUP BY doctor_id
HAVING COUNT(DISTINCT patient_id) > (SELECT AVG(x.patient_count)
                                     FROM (SELECT COUNT(DISTINCT patient_id) AS patient_count
                                           FROM Appointments
                                           GROUP BY doctor_id) x);


-- Q43. Calculate the length of stay for each admission.
-- DATEDIFF is MySQL. PostgreSQL: discharge_date - admission_date.
SELECT admission_id,
       patient_id,
       DATEDIFF(discharge_date, admission_date) AS days_admitted
FROM Admissions
ORDER BY days_admitted DESC;


-- Q44. Show each department with its doctor count, including empty departments.
-- COUNT(d.doctor_id) counts non-NULL values, so empty departments show 0
-- rather than 1 as COUNT(*) would.
SELECT dp.department_id,
       dp.department_name,
       COUNT(d.doctor_id) AS doctor_count
FROM Departments dp
LEFT JOIN Doctors d ON dp.department_id = d.department_id
GROUP BY dp.department_id, dp.department_name
ORDER BY doctor_count DESC;


-- Q45. Show the completion rate of appointments per doctor.
-- CASE inside an aggregate acts as a conditional count.
-- Multiply by 100.0 (not 100) to force decimal division.
SELECT doctor_id,
       COUNT(*) AS total_appointments,
       SUM(CASE WHEN status = 'Completed' THEN 1 ELSE 0 END) AS completed,
       ROUND(SUM(CASE WHEN status = 'Completed' THEN 1 ELSE 0 END) * 100.0
             / COUNT(*), 2) AS completion_rate_pct
FROM Appointments
GROUP BY doctor_id
ORDER BY completion_rate_pct DESC;


/* =============================================================================
   END OF SCRIPT
   ============================================================================= */
