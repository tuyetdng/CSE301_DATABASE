DROP DATABASE IF EXISTS HumanResourceManag;
CREATE database HumanResourceManag;
DROP TABLE IF EXISTS HumanResourceManag.EMPLOYEES;
CREATE TABLE HumanResourceManag.EMPLOYEES (
    employeeID VARCHAR(3) PRIMARY KEY,
    lastName VARCHAR(20) NOT NULL,
    middleName VARCHAR(20),
    firstName VARCHAR(20) NOT NULL,
    dateOfBirth DATE NOT NULL,
    gender VARCHAR(5) NOT NULL,
    salary DECIMAL(10, 2),
    address VARCHAR(100) NOT NULL,
    managerID VARCHAR(3),
    departmentID INT
);

-- ALTER TABLE HumanResourceManag.EMPLOYEES
-- DROP CONSTRAINT fk_manager;

DROP TABLE IF EXISTS HumanResourceManag.DEPARTMENT;
CREATE TABLE HumanResourceManag.DEPARTMENT (
    departmentID INT PRIMARY KEY,
    departmentName VARCHAR(10) NOT NULL,
    managerID VARCHAR(3),
    dateOfEmployment DATE NOT NULL,
    FOREIGN KEY (managerID) REFERENCES EMPLOYEES(employeeID)
);

-- ALTER TABLE HumanResourceManag.DEPARTMENT
-- DROP CONSTRAINT fk_manager_dep;

DROP TABLE IF EXISTS HumanResourceManag.DEPARTMENTADDRESS;
create table HumanResourceManag.DEPARTMENTADDRESS(
	departmentID INT,
    address VARCHAR (30),
	PRIMARY KEY (departmentID, address),
    FOREIGN KEY (departmentID) REFERENCES DEPARTMENT(departmentID)
);

DROP TABLE IF EXISTS HumanResourceManag.PROJECTS;
create table HumanResourceManag.PROJECTS(
	projectID int PRIMARY KEY,
    projectName varchar(30) NOT NULL,
    projectAddress varchar(100) NOT NULL,
    departmentID int,
    FOREIGN KEY (departmentID) REFERENCES DEPARTMENT(departmentID)
);

DROP TABLE IF EXISTS HumanResourceManag.ASSIGNMENT;
create table HumanResourceManag.ASSIGNMENT(
	employeeID varchar(3),
    projectID int,
    workingHour float NOT NULL,
    PRIMARY KEY (employeeID, projectID),
    FOREIGN KEY (employeeID) REFERENCES EMPLOYEES(employeeID),
    FOREIGN KEY (projectID) REFERENCES PROJECTS(projectID)
);

DROP TABLE IF EXISTS HumanResourceManag.RELATIVE;
create table HumanResourceManag.RELATIVE(
	employeeID varchar(3),
    relativeName varchar(50),
    gender varchar(5) NOT NULL,
    date0fBirth date,
    relationship varchar(30) NOT NULL,
    PRIMARY KEY (employeeID, relativeName),
	FOREIGN KEY (employeeID) REFERENCES EMPLOYEES(employeeID)
);

insert into HumanResourceManag.EMPLOYEES values
('123', 'Dinh', 'Ba', 'Tien', '1995-1-9', 'Nam', '30000','731 Tran Hung Dao Q1 TPHCM', '333', 5),
('333', 'Nguyen', 'Thanh', 'Tung', '1945-8-12', 'Nam', '40000','638 Nguyen Van Cu Q5 TPHCM', '888', 5),
('453', 'Tran', 'Than', 'Tâm', '1962-7-31', 'Nam', '25000','543 Mai Thi Luu Ba Dinh Ha Noi', '333', 5),
('666', 'Nguyen', 'Manh', 'Hung', '1952-9-15', 'Nam', '38000','975 Le Lai P3 Vung Tau', '333', 5),
('777', 'Tran', 'Hong', 'Quang', '1959-3-29', 'Nam', '25000','980 Le Hong Phong Vung Tau', '987', 4),
('888', 'Vuong', 'Ngoc', 'Quyen', '1927-10-10', 'Nu', '55000','450 Trung Vuong My Tho TG', NULL, 1),
('987', 'Le', 'Thi', 'Nhan', '1931-6-20', 'Nu', '43000','291 Ho Van Hue TPHCM', '888', 4),
('999', 'Bui', 'Thuy', 'Vu', '1958-7-19', 'Nam', '25000','332 Nguyen Thai Hoc Quy Nhon', '987', 4);


insert into HumanResourceManag.DEPARTMENT values
(1, 'Quan ly', '888', '1971-6-19'),
(4, 'Dieu hanh', '777','1985-01-01'),
(5, 'Nghien cuu', '333', '1978-5-22');

ALTER TABLE HumanResourceManag.EMPLOYEES ADD CONSTRAINT fk_manager_p
FOREIGN KEY (managerID) REFERENCES HumanResourceManag.EMPLOYEES(employeeID),
ADD CONSTRAINT fk_department_p FOREIGN KEY (departmentID) REFERENCES HumanResourceManag.DEPARTMENT(departmentID);

ALTER TABLE HumanResourceManag.DEPARTMENT ADD CONSTRAINT fk_manager_dep_p
FOREIGN KEY (managerID) REFERENCES HumanResourceManag.EMPLOYEES(employeeID);

insert into HumanResourceManag.DEPARTMENTADDRESS values
(1, 'TP HCM'),
(4, 'HA NOI'),
(5, 'NHA TRANG'),
(5, 'TP HCM'),
(5, 'VUNG TAU');

insert into HumanResourceManag.PROJECTS values
(1 ,'San pham X', 'VUNG TAU', 5),
(2, 'San pham Y', 'NHA TRANG', 5),
(3, 'San pham Z', 'TP HCM', 5),
(10, 'Tin hoc hoa', 'HA NOI', 4),
(20, 'Cap Quang', 'TP HCM', 1),
(30, 'Dao tao', 'HA NOI', 4);


insert into HumanResourceManag.ASSIGNMENT values
('123', 1 ,22.5),
('123', 2 ,7.5),
('123', 3 ,10),
('333', 10, 10),
('333', 20, 10),
('453', 1 ,20),
('453', 2 ,20),
('666', 3 ,40),
('888' ,20 ,0),
('987', 20, 15);

insert into HumanResourceManag.RELATIVE values
('123','Chau','Nu','1978-12-31','Con gai'),
('123','Duy','Nam','1978-1-1','Con trai'),
('123','Phuong','Nu','1957-5-5','Vo chong'),
('333','Duong','Nu','1948-5-3','Vo chong'),
('333','Quang','Nu','1976-4-5','Con gai'),
('333','Tung','Nam','1973-10-25','Con trai'),
('987','Dang','Nam','1932-2-29','Vo chong');
