CREATE TABLE Patients (    patient_id INT PRIMARY KEY,    patient_name VARCHAR(100) NOT NULL);

CREATE TABLE Patient_Phones (
    phone_id INT PRIMARY KEY,
    patient_id INT NOT NULL,
    patient_phone VARCHAR(15) NOT NULL,
    FOREIGN KEY (patient_id) REFERENCES Patients(patient_id)
);

CREATE TABLE Departments (
    department_id INT PRIMARY KEY,
    department_name VARCHAR(100) NOT NULL
);

CREATE TABLE Doctors (
    doctor_id INT PRIMARY KEY,
    doctor_name VARCHAR(100) NOT NULL,
    department_id INT NOT NULL,
    FOREIGN KEY (department_id) REFERENCES Departments(department_id)
);

CREATE TABLE Doctor_Specializations (
    specialization_id INT PRIMARY KEY,
    doctor_id INT NOT NULL,
    specialization_name VARCHAR(100) NOT NULL,
    FOREIGN KEY (doctor_id) REFERENCES Doctors(doctor_id)
);

CREATE TABLE Appointments (
    appointment_id INT PRIMARY KEY,
    patient_id INT NOT NULL,
    appointment_date DATE NOT NULL,
    appointment_time TIME NOT NULL,
    appointment_status VARCHAR(50) NOT NULL,
    FOREIGN KEY (patient_id) REFERENCES Patients(patient_id)
);

CREATE TABLE Consultations (
    consultation_id INT PRIMARY KEY,
    appointment_id INT NOT NULL,
    consultation_date DATE NOT NULL,
    observations TEXT,
    previous_consultation_id INT NULL,
    FOREIGN KEY (appointment_id) REFERENCES Appointments(appointment_id),
    FOREIGN KEY (previous_consultation_id) REFERENCES Consultations(consultation_id)
);

CREATE TABLE Consultation_Doctors (
    consultation_doctor_id INT PRIMARY KEY,
    consultation_id INT NOT NULL,
    doctor_id INT NOT NULL,
    role VARCHAR(100) NOT NULL,
    
    FOREIGN KEY (consultation_id) REFERENCES Consultations(consultation_id),
    FOREIGN KEY (doctor_id) REFERENCES Doctors(doctor_id)
);


CREATE TABLE Diagnoses (
    diagnosis_id INT PRIMARY KEY,
    consultation_id INT NOT NULL,
    diagnosis_details VARCHAR(255) NOT NULL,
    diagnosis_type VARCHAR(50),
    FOREIGN KEY (consultation_id) REFERENCES Consultations(consultation_id)
);

CREATE TABLE Treatments (
    treatment_id INT PRIMARY KEY,
    consultation_id INT NOT NULL,
    treatment_details TEXT NOT NULL,
    treatment_cost DECIMAL(10,2) NOT NULL,
    FOREIGN KEY (consultation_id) REFERENCES Consultations(consultation_id)
);

CREATE TABLE Medicines (
    medicine_id INT PRIMARY KEY,
    medicine_name VARCHAR(100) NOT NULL,
    medicine_price DECIMAL(10,2) NOT NULL
);

CREATE TABLE Prescriptions (
    prescription_id INT PRIMARY KEY,
    consultation_id INT NOT NULL,
    prescription_date DATE NOT NULL,
    FOREIGN KEY (consultation_id) REFERENCES Consultations(consultation_id)
);

CREATE TABLE Prescription_Details (
    prescription_detail_id INT PRIMARY KEY,
    prescription_id INT NOT NULL,
    medicine_id INT NOT NULL,
    dosage VARCHAR(100) NOT NULL,
    duration VARCHAR(50) NOT NULL,
    
    FOREIGN KEY (prescription_id) REFERENCES Prescriptions(prescription_id),
    FOREIGN KEY (medicine_id) REFERENCES Medicines(medicine_id)
);


CREATE TABLE Bills (
    bill_id INT PRIMARY KEY,
    consultation_id INT NOT NULL,
    consultation_charge DECIMAL(10,2) NOT NULL,
    treatment_charge DECIMAL(10,2) NOT NULL,
    medicine_charge DECIMAL(10,2) NOT NULL,
    bill_date DATE NOT NULL,
    FOREIGN KEY (consultation_id) REFERENCES Consultations(consultation_id)
);

CREATE TABLE Payments (
    payment_id INT PRIMARY KEY,
    bill_id INT NOT NULL,
    payment_date DATE NOT NULL,
    payment_amount DECIMAL(10,2) NOT NULL,
    payment_status VARCHAR(50) NOT NULL,
    FOREIGN KEY (bill_id) REFERENCES Bills(bill_id)
);



INSERT INTO Patients VALUES
(1, 'Rahul Sharma'),
(2, 'Anita Nair'),
(3, 'Vikram Das');

INSERT INTO Patient_Phones VALUES
(1, 1, '9876543210'),
(2, 2, '9876543211'),
(3, 3, '9876543212');

INSERT INTO Departments VALUES
(1, 'Cardiology'),
(2, 'Neurology'),
(3, 'Orthopedics');

INSERT INTO Doctors VALUES
(1, 'Dr. Meera Nair', 1),
(2, 'Dr. John Mathew', 2),
(3, 'Dr. Priya Das', 3);

INSERT INTO Doctor_Specializations VALUES
(1, 1, 'Interventional Cardiology'),
(2, 2, 'Brain Disorders'),
(3, 3, 'Joint Replacement');

INSERT INTO Appointments VALUES
(1, 1, '2026-04-20', '10:00:00', 'Completed'),
(2, 2, '2026-04-21', '11:00:00', 'Completed'),
(3, 3, '2026-04-22', '12:00:00', 'Pending');

INSERT INTO Consultations VALUES
(1, 1, '2026-04-20', 'Chest pain and shortness of breath', NULL),
(2, 2, '2026-04-21', 'Frequent headaches and dizziness', NULL),
(3, 3, '2026-04-22', 'Knee pain and swelling', NULL);

INSERT INTO Consultation_Doctors VALUES
(1, 1, 1, 'Primary Consultant'),
(2, 2, 2, 'Primary Consultant'),
(3, 3, 3, 'Primary Consultant');

INSERT INTO Diagnoses VALUES
(1, 1, 'Angina', 'Primary'),
(2, 2, 'Migraine', 'Primary'),
(3, 3, 'Arthritis', 'Primary');

INSERT INTO Treatments VALUES
(1, 1, 'ECG and medication', 1500.00),
(2, 2, 'MRI scan and pain relief', 2200.00),
(3, 3, 'Physiotherapy', 1800.00);

INSERT INTO Medicines VALUES
(1, 'Aspirin', 50.00),
(2, 'Sumatriptan', 120.00),
(3, 'Ibuprofen', 80.00);

INSERT INTO Prescriptions VALUES
(1, 1, '2026-04-20'),
(2, 2, '2026-04-21'),
(3, 3, '2026-04-22');

INSERT INTO Prescription_Details VALUES
(1, 1, 1, '1 tablet daily', '10 days'),
(2, 2, 2, '1 tablet during headache', '5 days'),
(3, 3, 3, '1 tablet twice daily', '7 days');

INSERT INTO Bills VALUES
(1, 1, 500.00, 1500.00, 50.00, '2026-04-20'),
(2, 2, 600.00, 2200.00, 120.00, '2026-04-21'),
(3, 3, 550.00, 1800.00, 80.00, '2026-04-22');

INSERT INTO Payments VALUES
(1, 1, '2026-04-20', 2050.00, 'Paid'),
(2, 2, '2026-04-21', 2920.00, 'Paid'),
(3, 3, '2026-04-22', 0.00, 'Pending');




SELECT p.patient_name, c.consultation_date, d.doctor_name, 
       dg.diagnosis_details, m.medicine_name
FROM Patients p
JOIN Appointments a ON p.patient_id = a.patient_id
JOIN Consultations c ON a.appointment_id = c.appointment_id
JOIN Consultation_Doctors cd ON c.consultation_id = cd.consultation_id
JOIN Doctors d ON cd.doctor_id = d.doctor_id
JOIN Diagnoses dg ON c.consultation_id = dg.consultation_id
JOIN Prescriptions pr ON c.consultation_id = pr.consultation_id
JOIN Prescription_Details pd ON pr.prescription_id = pd.prescription_id
JOIN Medicines m ON pd.medicine_id = m.medicine_id
WHERE p.patient_id = 1;


SELECT d.doctor_name, COUNT(*) AS total_consultations
FROM Doctors d
JOIN Consultation_Doctors cd ON d.doctor_id = cd.doctor_id
GROUP BY d.doctor_name
ORDER BY total_consultations DESC
LIMIT 1;


SELECT p.patient_name,
       SUM((b.consultation_charge + b.treatment_charge + b.medicine_charge) - pay.payment_amount) AS due_amount
FROM Patients p
JOIN Appointments a ON p.patient_id = a.patient_id
JOIN Consultations c ON a.appointment_id = c.appointment_id
JOIN Bills b ON c.consultation_id = b.consultation_id
JOIN Payments pay ON b.bill_id = pay.bill_id
WHERE pay.payment_status = 'Pending'
GROUP BY p.patient_name;




BEGIN TRANSACTION;

INSERT INTO Consultations VALUES (4, 3, '2026-04-25', 'Fever and cough', NULL);
INSERT INTO Diagnoses VALUES (4, 4, 'Viral Fever', 'Primary');
INSERT INTO Prescriptions VALUES (4, 4, '2026-04-25');
INSERT INTO Prescription_Details VALUES (4, 4, 1, '1 tablet twice daily', '5 days');
INSERT INTO Bills VALUES (4, 4, 500.00, 300.00, 50.00, '2026-04-25');
INSERT INTO Payments VALUES (4, 4, '2026-04-25', 0.00, 'Pending');

COMMIT;
