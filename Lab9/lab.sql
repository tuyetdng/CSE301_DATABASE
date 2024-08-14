DROP DATABASE IF EXISTS managementproject;
CREATE database managementproject;
use managementproject;
CREATE TABLE EMPLOYEES (
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

CREATE TABLE DEPARTMENT (
    departmentID INT PRIMARY KEY,
    departmentName VARCHAR(10) NOT NULL,
    managerID VARCHAR(3),
    dateOfEmployment DATE NOT NULL,
    FOREIGN KEY (managerID) REFERENCES EMPLOYEES(employeeID)
);

-- ALTER TABLE HumanResourceManag.DEPARTMENT
-- DROP CONSTRAINT fk_manager_dep;

create table DEPARTMENTADDRESS(
	departmentID INT,
    address VARCHAR (30),
	PRIMARY KEY (departmentID, address),
    FOREIGN KEY (departmentID) REFERENCES DEPARTMENT(departmentID)
);

create table PROJECTS(
	projectID int PRIMARY KEY,
    projectName varchar(30) NOT NULL,
    projectAddress varchar(100) NOT NULL,
    departmentID int,
    FOREIGN KEY (departmentID) REFERENCES DEPARTMENT(departmentID)
);

create table ASSIGNMENT(
	employeeID varchar(3),
    projectID int,
    workingHour float NOT NULL,
    PRIMARY KEY (employeeID, projectID),
    FOREIGN KEY (employeeID) REFERENCES EMPLOYEES(employeeID),
    FOREIGN KEY (projectID) REFERENCES PROJECTS(projectID)
);

create table RELATIVE(
	employeeID varchar(3),
    relativeName varchar(50),
    gender varchar(5) NOT NULL,
    date0fBirth date,
    relationship varchar(30) NOT NULL,
    PRIMARY KEY (employeeID, relativeName),
	FOREIGN KEY (employeeID) REFERENCES EMPLOYEES(employeeID)
);

insert into EMPLOYEES values
('123', 'Dinh', 'Ba', 'Tien', '1995-1-9', 'Nam', '30000','731 Tran Hung Dao Q1 TPHCM', '333', 5),
('333', 'Nguyen', 'Thanh', 'Tung', '1945-8-12', 'Nam', '40000','638 Nguyen Van Cu Q5 TPHCM', '888', 5),
('453', 'Tran', 'Than', 'Tâm', '1962-7-31', 'Nam', '25000','543 Mai Thi Luu Ba Dinh Ha Noi', '333', 5),
('666', 'Nguyen', 'Manh', 'Hung', '1952-9-15', 'Nam', '38000','975 Le Lai P3 Vung Tau', '333', 5),
('777', 'Tran', 'Hong', 'Quang', '1959-3-29', 'Nam', '25000','980 Le Hong Phong Vung Tau', '987', 4),
('888', 'Vuong', 'Ngoc', 'Quyen', '1927-10-10', 'Nu', '55000','450 Trung Vuong My Tho TG', NULL, 1),
('987', 'Le', 'Thi', 'Nhan', '1931-6-20', 'Nu', '43000','291 Ho Van Hue TPHCM', '888', 4),
('999', 'Bui', 'Thuy', 'Vu', '1958-7-19', 'Nam', '25000','332 Nguyen Thai Hoc Quy Nhon', '987', 4);


insert into DEPARTMENT values
(1, 'Quan ly', '888', '1971-6-19'),
(4, 'Dieu hanh', '777','1985-01-01'),
(5, 'Nghien cuu', '333', '1978-5-22');

ALTER TABLE EMPLOYEES ADD CONSTRAINT fk_manager_p
FOREIGN KEY (managerID) REFERENCES EMPLOYEES(employeeID),
ADD CONSTRAINT fk_department_p FOREIGN KEY (departmentID) REFERENCES DEPARTMENT(departmentID);

ALTER TABLE DEPARTMENT ADD CONSTRAINT fk_manager_dep_p
FOREIGN KEY (managerID) REFERENCES EMPLOYEES(employeeID);

insert into DEPARTMENTADDRESS values
(1, 'TP HCM'),
(4, 'HA NOI'),
(5, 'NHA TRANG'),
(5, 'TP HCM'),
(5, 'VUNG TAU');

insert into PROJECTS values
(1 ,'San pham X', 'VUNG TAU', 5),
(2, 'San pham Y', 'NHA TRANG', 5),
(3, 'San pham Z', 'TP HCM', 5),
(10, 'Tin hoc hoa', 'HA NOI', 4),
(20, 'Cap Quang', 'TP HCM', 1),
(30, 'Dao tao', 'HA NOI', 4);


insert into ASSIGNMENT values
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

insert into RELATIVE values
('123','Chau','Nu','1978-12-31','Con gai'),
('123','Duy','Nam','1978-1-1','Con trai'),
('123','Phuong','Nu','1957-5-5','Vo chong'),
('333','Duong','Nu','1948-5-3','Vo chong'),
('333','Quang','Nu','1976-4-5','Con gai'),
('333','Tung','Nam','1973-10-25','Con trai'),
('987','Dang','Nam','1932-2-29','Vo chong');

-- II. Creating constraint for database:
-- 1. Check constraint to value of gender in “Nam” or “Nu”.
ALTER TABLE EMPLOYEES 
ADD CONSTRAINT fk_gender_e check (gender like "Nam" or gender like "Nu");
ALTER TABLE relative 
ADD CONSTRAINT fk_gender_r check (gender like "Nam" or gender like "Nu");

-- 2. Check constraint to value of salary > 0.
ALTER TABLE EMPLOYEES 
ADD CONSTRAINT fk_salary_e check (salary > 0);

-- 3. Check constraint to value of relationship in Relative table in “Vo chong”, “Con trai”, “Con gai”, “Me ruot”, “Cha ruot”. 
ALTER TABLE relative 
ADD CONSTRAINT fk_relative_r check (relationship in ( "Vo chong","Con trai","Con gai","Me ruot", "Cha ruot"));


-- 1. Look for employees with salaries above 25,000 in room 4 or employees with salaries above 30,000 in room 5.
select * from employees where departmentID = 4 and salary > 25000 
union select * from employees where departmentID = 5 and salary > 30000 ;

-- 2. Provide full names of employees in HCM city.
select lastName, middleName, firstName from employees where address like  "_%TPHCM";

-- 3. Indicate the date of birth of Dinh Ba Tien staff.
select dateOfBirth from employees where lastName like "Dinh" and middleName like "Ba"  and firstName like "Tien";

-- 4. The names of the employees of Room 5 are involved in the "San pham X" project and this employee is directly managed by "Nguyen Thanh Tung".
select e.lastName, e.middleName, e.firstName 
from employees e inner join  assignment a on e.employeeID = a.employeeID
				 inner join projects p on p.projectID = a.projectID
                 inner join  employees es on es.employeeID = e.managerID
where e.departmentID = 5  and p.projectName like "San pham X" and es.lastName like "Nguyen" and es.middleName like "Thanh" and es.firstName like "Tung";

-- 5. Find the names of department heads of each department.
select e.lastName, e.middleName, e.firstName, d.departmentName
from employees e inner join  department d on e.employeeID = d.managerID;

-- 6. Find projectID, projectName, projectAddress, departmentID, departmentName, managerID, date0fEmployment.
select p.*, d.* from department d inner join projects p on d.departmentID = p.departmentID;

-- 7. Find the names of female employees and their relatives.
select e.lastName, e.middleName, e.firstName, r.relativeName 
from employees e inner join relative r on e.employeeID = r.employeeID;

-- 8. For all projects in "Hanoi", list the project code (projectID), the code of the project lead department (departmentID), the full name of the manager (lastName, middleName, firstName) as well as the address (Address) and date of birth (date0fBirth) of the Employees.
select p.projectID, p.departmentID, e.lastName, e.middleName, e.firstName, e.address, e.dateOfBirth
from projects p inner join department d on p.departmentID = d.departmentID
				inner join employees e on e.employeeID = d.managerID
where p.projectAddress like "HA NOI";

-- 9. For each employee, include the employee's full name and the employee's line manager.
select e.lastName, e.middleName, e.firstName,  es.lastName as ManagerLastName  , es.middleName as ManagerMiddleName , es.firstName as ManagerFirstName
from employees e inner join employees es on es.employeeID = e.managerID;

-- 10. For each employee, indicate the employee's full name and the full name of the head of the department in which the employee works.
select e.lastName, e.middleName, e.firstName,  es.lastName as headLastName  , es.middleName as headMiddleName , es.firstName as headFirstName
from employees e inner join department d on d.departmentID = e.departmentID
inner join  employees es on es.employeeID = d.managerID;

-- 11. Provide the employee's full name (lastName, middleName, firstName) and the names of the projects in which the employee participated, if any.
select e.lastName, e.middleName, e.firstName, p.projectName
from employees e inner join  assignment a on e.employeeID = a.employeeID
				 inner join projects p on p.projectID = a.projectID;

-- 12. For each scheme, list the scheme name (projectName) and the total number of hours worked per week of all employees attending that scheme.
select p.projectName, sum(a.workingHour)
from assignment a inner join projects p on p.projectID = a.projectID
group by  p.projectName;

-- 13. For each department, list the name of the department (departmentName) and the average salary of the employees who work for that department.
select d.departmentName, avg(e.salary)
from employees e inner join department d on d.departmentID = e.departmentID
group by d.departmentName;

-- 14. For departments with an average salary above 30,000, list the name of the department and the number of employees of that department.
select d.departmentName, avg(e.salary), count(e.departmentID)
from employees e inner join department d on d.departmentID = e.departmentID
group by d.departmentName
having avg(e.salary) > 30000;

-- 15. Indicate the list of schemes (projectID) that has: workers with them (lastName) as 'Dinh' or, whose head of department presides over the scheme with them (lastName) as 'Dinh'.
select p.projectID
from projects p inner join assignment a on p.projectID = a.projectID
				inner join department d on d.departmentID = p.departmentID
                inner join employees ew on ew.employeeID = a.employeeID
                inner join employees eh on eh.employeeID = d.managerID
where ew.lastName like "Dinh" or eh.lastName like "Dinh";

-- 16. List of employees (lastName, middleName, firstName) with more than 2 relatives.
select e.lastName, e.middleName, e.firstName, count(r.employeeID) as number_of_relative
from employees e inner join  relative r on e.employeeID = r.employeeID
group by r.employeeID
having count(r.employeeID) > 2;

-- 17. List of employees (lastName, middleName, firstName) without any relatives.
select e.lastName, e.middleName, e.firstName
from employees e
     left join relative r on e.employeeID = r.employeeID
where r.employeeID is null;

-- 18. List of department heads (lastName, middleName, firstName) with at least one relative.
select e.lastName, e.middleName, e.firstName, count(r.employeeID) as number_of_relative
from employees e inner join department d on d.managerID = e.employeeID
				 inner join  relative r on e.employeeID = r.employeeID
group by r.employeeID
having count(r.employeeID) >= 1;

-- 19. Find the surname (lastName) of unmarried department heads.
select e.lastName
from employees e inner join department d on e.employeeID = d.managerID
left join relative r on e.employeeID = r.employeeID
where r.employeeID is null;

-- 20. Indicate the full name of the employee (lastName, middleName, firstName) whose salary is above the average salary of the "Research" department.
select e.lastName, e.middleName, e.firstName from employees e
where e.salary > (
    select avg(e1.salary)
    from employees e1 inner join department d on e1.departmentID = d.departmentID
    where d.departmentName = 'Nghien cuu');


-- 21. Indicate the name of the department and the full name of the head of the department with the largest number of employees. 
select d.departmentName, e.lastName, e.middleName, e.firstName
from department d inner join employees e on d.managerID = e.employeeID
where d.departmentID = (
    select departmentID  from employees
    group by departmentID
    order by count(employeeID) desc
    limit 1
);

-- 22. Find the full names (lastName, middleName, firstName) and addresses (Address) of employees who work on a project in 'HCMC' but the department they belong to is not located in 'HCMC'.
select distinct e.lastName, e.middleName, e.firstName, e.address
from employees e inner join department d on d.managerID = e.employeeID
				 inner join  departmentaddress da on da.departmentID = d.departmentID
where e.address like  "_%TPHCM" and da.address not like  "_%TPHCM";

-- 23. Find the names and addresses of employees who work on a scheme in a city but the department to which they belong is not located in that city
select distinct e.lastName, e.middleName, e.firstName, e.address
from employees e inner join department d on d.managerID = e.employeeID
				 inner join  departmentaddress da on da.departmentID = d.departmentID
where e.address <> da.address;