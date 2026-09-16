Create Database hospital_management1;
Create Table Patients (patient_id INT Primary Key, patient_name VARCHAR(50), age INT, city VARCHAR(50));
Create Table Doctors (doctor_id INT Primary Key, doctor_name VARCHAR(50), department_id INT, salary NUMERIC(10,2));
Create Table Departments (department_id INT Primary Key, department_name VARCHAR(50));
Create Table Appointments (appointment_id INT Primary Key, patient_id INT, doctor_id INT, appointment_date DATE, status VARCHAR(20));
Create Table Admissions (admission_id INT Primary Key, patient_id INT, admission_date DATE, discharge_date DATE);
Create Table Medicines (medicine_id INT Primary Key, medicine_name VARCHAR(50), price NUMERIC(10,2));
Create Table Prescriptions (prescription_id INT Primary Key, appointment_id INT, medicine_id INT, quantity INT);
Create Table Bills (bill_id INT Primary Key, patient_id INT, appointment_id INT, bill_amount NUMERIC(10,2));
Insert Into Patients Values 
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
Insert Into Departments Values
(1,'Cardiology'),
(2,'Neurology'),
(3,'Orthopedics'),
(4,'Pediatrics'),
(5,'General Medicine'),
(6,'Dermatology');
Insert Into Doctors Values 
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
Insert Into Appointments Values 
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
Insert Into Admissions Values 
(501,1,'2026-01-10','2026-01-15'),(502,3,'2026-02-10','2026-02-18'),
(503,4,'2026-03-01','2026-03-05'),(504,6,'2026-03-10','2026-03-15'),
(505,7,'2026-04-01','2026-04-07'),(506,9,'2026-04-15','2026-04-22'),
(507,2,'2026-05-01','2026-05-04'),(508,5,'2026-05-10','2026-05-14'),
(509,8,'2026-05-15','2026-05-18'),(510,10,'2026-06-01','2026-06-05');
Insert Into Medicines Values 
(201,'Paracetamol',50),(202,'Amoxicillin',120),
(203,'Azithromycin',150),(204,'Ibuprofen',80),
(205,'Metformin',100),(206,'Atorvastatin',200),
(207,'Omeprazole',90),(208,'Cetirizine',60),
(209,'Aspirin',70),(210,'Pantoprazole',110);
Insert Into Prescriptions Values 
(301,1001,201,2),(302,1001,207,1),(303,1002,202,2),(304,1003,203,1),(305,1004,201,3),
(306,1005,204,2),(307,1006,205,2),(308,1007,206,1),(309,1008,208,2),(310,1009,201,2),
(311,1010,209,1),(312,1011,210,2),(313,1012,201,3),(314,1013,204,2),(315,1014,207,1),
(316,1015,202,2),(317,1016,203,1),(318,1017,201,2),(319,1018,205,1),(320,1019,206,2);
Select * From Patients;
Select * From Doctors;
Select * From Departments;
Select * From Patients Where age > 60;
Select * From Doctors Where salary > 80000;
Select COUNT(*) AS patient_count From Patients;
Select department_id,COUNT(*) AS doctor_count From Doctors GROUP BY department_id;
Select AVG(salary) AS average_salary From Doctors;
Select SUM(bill_amount) AS total_bill_amount From Bills;
Select department_id,COUNT(*) AS doctor_count From Doctors GROUP BY department_id HAVING COUNT(*) > 3;
Select d.doctor_name,dp.department_name From Doctors d JOIN Departments dp ON d.department_id=dp.department_id;
Select p.patient_name,d.doctor_name From Patients p 
JOIN Appointments a ON p.patient_id=a.patient_id JOIN Doctors d ON a.doctor_id=d.doctor_id;
Select p.patient_name,d.doctor_name,dp.department_name From Patients p JOIN Appointments a ON p.patient_id=a.patient_id 
JOIN Doctors d ON a.doctor_id=d.doctor_id JOIN Departments dp ON d.department_id=dp.department_id;
Select p.* From Patients p LEFT JOIN Appointments a ON p.patient_id=a.patient_id Where a.patient_id IS NULL;
Select d.* From Doctors d LEFT JOIN Appointments a ON d.doctor_id=a.doctor_id Where a.doctor_id IS NULL;
SelectSelect dp.* From Departments dp LEFT JOIN Doctors d ON dp.department_id=d.department_id Where d.doctor_id IS NULL;
Select a.appointment_id,p.patient_name,d.doctor_name,a.appointment_date,a.status From Appointments a JOIN Patients p
ON a.patient_id=p.patient_id JOIN Doctors d ON a.doctor_id=d.doctor_id;
Select * From Doctors Where salary>(Select AVG(salary) From Doctors);
Select d.* From Doctors d Where salary>(Select AVG(d2.salary) From Doctors d2 Where d2.department_id=d.department_id);
Select * From Doctors Where salary=(Select MAX(salary) From Doctors);
Select MAX(salary) From Doctors Where salary<(Select MAX(salary) From Doctors);
INSERT INTO Departments VALUES (7,'HR');
Select * From Doctors Where salary>ALL(Select salary From Doctors Where department_id=
(Select department_id From Departments Where department_name='HR'));
Select * From Doctors Where salary>ANY(Select salary From Doctors Where department_id=
(Select department_id FromFrom Departments Where department_name='HR'));
Select * From Patients Where age>(Select AVG(age) From Patients);
Select * From Patients p Where EXISTS(Select 1 From Appointments a Where a.patient_id=p.patient_id);
Select department_id,COUNT(*) AS doctor_count From Doctors GROUP BY department_id ORDER BY doctor_count DESC LIMIT 1;
Select department_id,AVG(salary) AS average_salary From Doctors GROUP BY department_id ORDER BY average_salary DESC LIMIT 1;
Select doctor_id,COUNT(DISTINCT patient_id) AS patient_count From Appointments Where status='Completed' GROUP BY doctor_id 
ORDER BY patient_count DESC LIMIT 1;
Select patient_id,COUNT(*) AS appointment_count From Appointments GROUP BY patient_id ORDER BY appointment_count DESC LIMIT 1;
Select doctor_id,COUNT(*) AS cancelled_count From Appointments Where status='Cancelled' GROUP BY doctor_id 
ORDER BY cancelled_count DESC LIMIT 1;
Select d.department_id,SUM(b.bill_amount) AS total_bill From Bills b JOIN Appointments a ON b.appointment_id=a.appointment_id 
JOIN Doctors d ON a.doctor_id=d.doctor_id GROUP BY d.department_id ORDER BY total_bill DESC LIMIT 1;
Select p.* From Patients p LEFT JOIN Admissions a ON p.patient_id=a.patient_id Where a.patient_id IS NULL;
Select d.* From Doctors d LEFT JOIN Appointments a ON d.doctor_id=a.doctor_id Where a.doctor_id IS NULL;
Select medicine_id,SUM(quantity) AS total_quantity From Prescriptions GROUP BY medicine_id ORDER BY total_quantity DESC LIMIT 1;
Select m.medicine_id,m.medicine_name,SUM(p.quantity*m.price) AS total_sales From Medicines m JOIN Prescriptions p ON 
m.medicine_id=p.medicine_id GROUP BY m.medicine_id,m.medicine_name ORDER BY total_sales DESC LIMIT 1;
Select * From Bills Where bill_amount>(Select AVG(bill_amount) From Bills);
Select d.* From Doctors d Where salary>(Select AVG(d2.salary) From Doctors d2 Where d2.department_id=d.department_id);
Select department_id,AVG(salary) AS average_salary From Doctors GROUP BY department_id HAVING AVG(salary)>(Select AVG(salary)
From Doctors);
Select MAX(salary) AS second_highest_salary From Doctors Where salary<(Select MAX(salary) From Doctors);
Select * From Doctors d Where salary=(Select MAX(salary) From Doctors d2 Where d2.department_id=d.department_id);
Select patient_id,COUNT(DISTINCT doctor_id) AS doctor_count From Appointments GROUP BY patient_id HAVING COUNT
(DISTINCT doctor_id)>1;
Select a.doctor_id,COUNT(DISTINCT p.city) AS city_count From Appointments a JOIN Patients p ON 
a.patient_id=p.patient_id GROUP BY a.doctor_id HAVING COUNT(DISTINCT p.city)>1;
Select d.department_id,COUNT(*) AS appointment_count From Appointments a JOIN Doctors d ON a.doctor_id=d.doctor_id 
GROUP BY d.department_id HAVING COUNT(*)>5;
Select patient_id,SUM(bill_amount) AS total_bill From Bills GROUP BY patient_id HAVING SUM(bill_amount)>
(Select AVG(total_bill) From (Select SUM(bill_amount) AS total_bill From Bills GROUP BY patient_id) x);
Select doctor_id,COUNT(DISTINCT patient_id) AS patient_count From Appointments GROUP BY doctor_id HAVING COUNT
(DISTINCT patient_id)>(Select AVG(patient_count) From (Select COUNT(DISTINCT patient_id) AS patient_count From
Appointments GROUP BY doctor_id) x);











