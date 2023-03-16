/*
ALTER TABLE [doctor] DROP CONSTRAINT FK_DoctorAdress;
ALTER TABLE [patient] DROP CONSTRAINT FK_PatientAdress;
ALTER TABLE [prescription] DROP CONSTRAINT FK_PrescriptionDoctor;
ALTER TABLE [prescription] DROP CONSTRAINT FK_PrescriptionPatient;
ALTER TABLE [list_of_medicaments] DROP CONSTRAINT FK_ListMedicamentsPrescription;
ALTER TABLE [list_of_medicaments] DROP CONSTRAINT FK_ListMedicamentsMedicament;

DROP TABLE IF EXISTS [address]; 
DROP TABLE IF EXISTS [doctor]; 
DROP TABLE IF EXISTS [patient]; 
DROP TABLE IF EXISTS [medicament]; 
DROP TABLE IF EXISTS [prescription]; 
DROP TABLE IF EXISTS [list_of_medicaments]; 
*/


CREATE TABLE [address] (
  [id] bigint PRIMARY KEY IDENTITY(1, 1) ,
  [street] varchar(255),
  [street_number] int,
  [city] varchar(255),
  [zip_code] varchar(6)
);

INSERT INTO address(street,street_number,city,zip_code) VALUES ('Doktorská', 1, 'Engetov', '123 00');
INSERT INTO address(street,street_number,city,zip_code) VALUES ('Pacientská', 1, 'Engetov', '111 11');
INSERT INTO address(street,street_number,city,zip_code) VALUES ('Pacientská', 2, 'Engetov', '567 89');


CREATE TABLE [doctor] (
  [id] bigint IDENTITY(1, 1) PRIMARY KEY,
  [name] varchar(255),
  [surname] varchar(255),
  [address_id] bigint,
  [phone_number] varchar(20),
  [email] varchar(255)
);

INSERT INTO doctor(name,surname,address_id,phone_number,email) VALUES ('Jan', 'Doktor', 1, '+420 123 456 789', 'doktor@engeto.cz');
INSERT INTO doctor(name,surname,address_id,phone_number,email) VALUES ('Petr', 'Pacient Doktor', 2, '+420 123 456 789', 'doktor2@engeto.cz');


CREATE TABLE [patient] (
  [id] bigint IDENTITY(1, 1) PRIMARY KEY,
  [name] varchar(255),
  [surname] varchar(255),
  [address_id] bigint,
  [insurance_company] varchar(255)
);

INSERT INTO patient(name,surname,address_id,insurance_company) VALUES ('Petr', 'Pacient Doktor', 2, 'Engeto insurance');
INSERT INTO patient(name,surname,address_id,insurance_company) VALUES ('Libor', 'Pacient', 3, 'Engeto insurance');
INSERT INTO patient(name,surname,address_id,insurance_company) VALUES ('Stanislav', 'Pacient', 3, 'State insurance');

CREATE TABLE [medicament] (
  [id] bigint IDENTITY(1, 1) PRIMARY KEY,
  [name] varchar(255),
  [price_insurance] float,
  [price_patient] float,
  [unit] varchar(10)
);

INSERT INTO medicament(name,price_insurance,price_patient,unit) VALUES ('Super Pills', 10.5, 4, 'package');
INSERT INTO medicament(name,price_insurance,price_patient,unit) VALUES ('Extra Pills', 18.1, 8.2, 'package');
INSERT INTO medicament(name,price_insurance,price_patient,unit) VALUES ('Common Pills', 5, 6.1, 'package');
INSERT INTO medicament(name,price_insurance,price_patient,unit) VALUES ('Super Sirup', 12, 8, 'milliliter');
INSERT INTO medicament(name,price_insurance,price_patient,unit) VALUES ('Extra Sirup', 16.3, 10.3, 'milliliter');

CREATE TABLE [prescription] (
  [id] bigint IDENTITY(1, 1) PRIMARY KEY,
  [doctor_id] bigint,
  [patient_id] bigint,
  [valid_from] datetime,
  [valid_to] datetime,
  [is_released] smallint
);

INSERT INTO prescription(doctor_id,patient_id,valid_from,valid_to,is_released) VALUES (1, 1, '2019-10-06 11:35:12', '2019-10-16 11:35:12', 1);
INSERT INTO prescription(doctor_id,patient_id,valid_from,valid_to,is_released) VALUES (1, 2, '2019-10-06 12:00:06', '2019-10-16 12:00:06', 0);
INSERT INTO prescription(doctor_id,patient_id,valid_from,valid_to,is_released) VALUES (1, 3, '2019-10-06 14:04:53', '2019-10-16 14:04:53', 1);
INSERT INTO prescription(doctor_id,patient_id,valid_from,valid_to,is_released) VALUES (1, 1, '2019-10-08 08:05:40', '2019-10-18 08:05:40', 1);
INSERT INTO prescription(doctor_id,patient_id,valid_from,valid_to,is_released) VALUES (1, 1, '2019-11-11 09:12:42', '2019-11-21 09:12:42', 0);
INSERT INTO prescription(doctor_id,patient_id,valid_from,valid_to,is_released) VALUES (1, 2, '2019-11-11 10:07:35', '2019-11-21 10:07:35', 0);

CREATE TABLE [list_of_medicaments] (
  [prescription_id] bigint,
  [medicament_id] bigint,
  [amount] int,
  PRIMARY KEY ([prescription_id], [medicament_id])
);

INSERT INTO list_of_medicaments(prescription_id,medicament_id,amount) VALUES (1, 1, 2);
INSERT INTO list_of_medicaments(prescription_id,medicament_id,amount) VALUES (1, 4, 100);
INSERT INTO list_of_medicaments(prescription_id,medicament_id,amount) VALUES (2, 3, 2);
INSERT INTO list_of_medicaments(prescription_id,medicament_id,amount) VALUES (2, 4, 250);
INSERT INTO list_of_medicaments(prescription_id,medicament_id,amount) VALUES (3, 1, 1);
INSERT INTO list_of_medicaments(prescription_id,medicament_id,amount) VALUES (3, 2, 3);
INSERT INTO list_of_medicaments(prescription_id,medicament_id,amount) VALUES (3, 3, 2);
INSERT INTO list_of_medicaments(prescription_id,medicament_id,amount) VALUES (4, 3, 1);
INSERT INTO list_of_medicaments(prescription_id,medicament_id,amount) VALUES (4, 4, 150);
INSERT INTO list_of_medicaments(prescription_id,medicament_id,amount) VALUES (5, 1, 3);
INSERT INTO list_of_medicaments(prescription_id,medicament_id,amount) VALUES (5, 2, 1);
INSERT INTO list_of_medicaments(prescription_id,medicament_id,amount) VALUES (5, 4, 300);
INSERT INTO list_of_medicaments(prescription_id,medicament_id,amount) VALUES (5, 5, 300);
INSERT INTO list_of_medicaments(prescription_id,medicament_id,amount) VALUES (6, 2, 4);
INSERT INTO list_of_medicaments(prescription_id,medicament_id,amount) VALUES (6, 5, 400);
INSERT INTO list_of_medicaments(prescription_id,medicament_id,amount) VALUES (6, 1, 2);

ALTER TABLE [doctor] ADD CONSTRAINT FK_DoctorAdress FOREIGN KEY ([address_id]) REFERENCES [address] ([id]);

ALTER TABLE [patient] ADD CONSTRAINT FK_PatientAdress FOREIGN KEY ([address_id]) REFERENCES [address] ([id]);

ALTER TABLE [prescription] ADD CONSTRAINT FK_PrescriptionDoctor FOREIGN KEY ([doctor_id]) REFERENCES [doctor] ([id]);

ALTER TABLE [prescription] ADD CONSTRAINT FK_PrescriptionPatient FOREIGN KEY ([patient_id]) REFERENCES [patient] ([id]);

ALTER TABLE [list_of_medicaments] ADD CONSTRAINT FK_ListMedicamentsPrescription FOREIGN KEY ([prescription_id]) REFERENCES [prescription] ([id]);

ALTER TABLE [list_of_medicaments] ADD CONSTRAINT FK_ListMedicamentsMedicament FOREIGN KEY ([medicament_id]) REFERENCES [medicament] ([id]);



