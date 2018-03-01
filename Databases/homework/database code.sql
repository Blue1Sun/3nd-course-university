
--отлелы
CREATE TABLE Departs (
Number numeric(4) Primary key,
Name varchar(100) Not null);

--кабинеты
CREATE TABLE Rooms (
Room_Num numeric(3) primary key,
  Depart numeric(4) REFERENCES Departs(Number),
  Phone varchar(20) not null
);

--клиенты
CREATE TABLE Clients (
Id numeric(7) primary key,
  Surname varchar(50) not null,
  Name varchar(50) not null,
  Sex char(1) not null,
  Phone varchar(10) not null,
  Address varchar(100) not null
);

--должности
create table Posts (
Post numeric(50) primary key,
  Salary numeric(7) not null
);

--доктора
CREATE TABLE Doctors (
Id numeric(4) primary key,
  Surname varchar(50) not null,
  Name varchar(50) not null,
  Sex char(1) not null,
  Birth date not null,
  Pass_Num char(10) not null unique,
  Pass_Date date not null,
  Pass_Given varchar(50) not null,
  Inn char(12) not null unique,
  Depart numeric(4) references Departs(Number),
  Position varchar(50) references Posts(Post),
  Role varchar(25) not null,
  Login varchar(30) not null
);

--образование
CREATE TABLE Education (
Id numeric(4) references Doctors(Id),
  Type varchar(20) not null,
  Specialization varchar(40),
  Diploma varchar(15),
  Grad_year numeric(4) not null
);

--адреса-телефоны
CREATE TABLE Address_Phone (
Id numeric(4) references Doctors(Id),
  Sddress varchar(50),
  Phone varchar(30)
);

--диагнозы
CREATE TABLE Diagnoses (
Id numeric(4) primary key,
  Name varchar(100) not null unique,
  Severity numeric(1) not null
);

--симптомы
CREATE TABLE Symptoms (
Id numeric(5) primary key,
  Name varchar(100) not null unique
);

--диагнозы-симптомы
CREATE TABLE Diag_Symp (
Symptom numeric(5) references Symptoms(Id),
  Diagnose numeric(4) references Diagnoses(Id)
);

--услуги
CREATE TABLE Services (
Id numeric(2) primary key,
  Name varchar(100) not null unique,
  Cost numeric(6) not null,
  Depart numeric(4) references Departs(Number)
);

--лекарства
CREATE TABLE Medicines (
Id numeric(4) primary key,
  Name varchar(50) not null unique
);

--услуги-лекарства
CREATE TABLE Serv_Med (
Service numeric(5) references Services(Id),
  Medicine numeric(4) references Medicines(Id)
);

--оборудование
CREATE TABLE Equipment (
Id numeric(2) primary key,
  Name varchar(100) not null unique
);

--услуги-оборудование
CREATE TABLE Serv_Equip (
Service numeric(5) references Services(Id),
  Equipment numeric(2) references Equipment(Id)
);

--животные
CREATE TABLE Pets (
Id numeric(7) primary key,
  Name varchar(30) not null,
  Owner numeric(7) references Clients(Id),
  Species varchar(30) not null,
  Breed varchar(50),
  Weight numeric(5,5),
  Height numeric(5,5),
  Width numeric(5,5),
  Length numeric(5,5),
  Sex char(1),
  Birth date
);

--прием
CREATE TABLE Appointnent (
Doctor numeric(4) not null,
  Date_Time datetime,
  Pet numeric(7) references Pets(Id),
  Service numeric(2) references Services(Id),
  Room numeric(3) references Rooms(Rum_Num),
  primary key (Doctor, Date_Time)
);

--карточка
CREATE TABLE Card (
Id numeric(5) primary key,
  Diagnose numeric(4) references Diagnoses(Id),
  Reg_date datetime not null,
  Doctor numeric(4) not null,
  Rec_Date date,
  foreign key (Doctor, Reg_date) references Appointnent(Doctor, Date_Time)
);