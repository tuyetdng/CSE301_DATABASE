DROP DATABASE IF EXISTS SaleManagerment;
create database SaleManagerment;

DROP TABLE IF EXISTS SaleManagerment.clients;
CREATE TABLE SaleManagerment.`clients` (
    Client_Number VARCHAR(10),
    Client_Name VARCHAR(25) NOT NULL,
    Address VARCHAR(30),
    City VARCHAR(30),
    Pincode INT NOT NULL,
    Province CHAR(25),
    Amount_Paid DECIMAL(15 , 4 ),
    Amount_Due DECIMAL(15 , 4 ),
    CHECK (Client_Number LIKE '%'),
    PRIMARY KEY (client_Number)
);

DROP TABLE IF EXISTS SaleManagerment.product;
CREATE TABLE SaleManagerment.`product` (
    Product_Number VARCHAR(15),
    Product_Name VARCHAR(25) NOT NULL UNIQUE,
    Quantity_On_Hand INT NOT NULL,
    Quantity_Sell INT NOT NULL,
    Sell_Price DECIMAL(15 , 4 ) NOT NULL,
    Cost_Price DECIMAL(15 , 4 ) NOT NULL,
    CHECK (Product_Number LIKE 'P%'),
    CHECK (Cost_Price <> 0),
    PRIMARY KEY (Product_Number)
);


DROP TABLE IF EXISTS SaleManagerment.Salesman;
create table SaleManagerment.`Salesman`(
Salesman_Number varchar(15),
Salesman_Name varchar(25) not null,
Address varchar(30),
City varchar(30),
Pincode int not null,
Province char(25) default('Viet Nam'),
Salary decimal(15,4) not null,
Sales_Target int not null,
Target_Achieved int,
Phone char(10) not null unique, check(Salesman_Number like '%'),
check(Salary<>0),
check(Sales_Target<>0),
primary key(Salesman_Number));

DROP TABLE IF EXISTS SaleManagerment.SalesOrder;
CREATE TABLE SaleManagerment.`SalesOrder` (
    Order_Number VARCHAR(15),
    Order_Date DATE,
    Client_Number VARCHAR(15),
    Salesman_Number VARCHAR(15),
    Delivery_Status CHAR(15),
    Delivery_Date DATE,
    Order_Status VARCHAR(15),
    PRIMARY KEY (Order_Number),
    FOREIGN KEY (Client_Number)
        REFERENCES clients (Client_Number),
    FOREIGN KEY (Salesman_Number)
        REFERENCES salesman (Salesman_Number),
    CHECK (Order_Number LIKE 'O%'),
    CHECK (Client_Number LIKE 'C%'),
    CHECK (Salesman_Number LIKE '%'),
    CHECK (Delivery_Status IN ('Delivered' , 'On Way', 'Ready to Ship')),
    CHECK (Delivery_Date > Order_Date),
    CHECK (Order_Status IN ('In Process' , 'Successful', 'Cancelled'))
);



DROP TABLE IF EXISTS SaleManagerment.SalesOrderDetails;
CREATE TABLE SaleManagerment.`SalesOrderDetails` (
    Order_Number VARCHAR(15),
    Product_Number VARCHAR(15),
    Order_Quantity INT,
    CHECK (order_number LIKE 'O%'),
    CHECK (Product_Number LIKE 'P%'),
    FOREIGN KEY (Order_Number)
        REFERENCES salesorder (Order_Number),
    FOREIGN KEY (Product_Number)
        REFERENCES product (Product_Number)
);

insert into salemanagerment.`clients` values
('C101','Mai Xuan','Phu Hoa','Dai An',700001,'Binh Duong',10000,5000),
('C102','Le Xuan','Phu Hoa','Thu Dau Mot',700051,'Binh Duong',18000,3000),
('C103','Trinh Huu','Phu Loi','Da Lat',700051,'Lam Dong ',7000,3200),
('C104','Tran Tuan','Phu Tan','Thu Dau Mot',700080,'Binh Duong',8000,0),
('C105','Ho Nhu','Chanh My','Hanoi',700005,'Hanoi',7000,150),
('C106','Tran Hai','Phu Hoa','Ho Chi Minh',700002,'Ho Chi Minh',7000,1300),
('C107','Nguyen Thanh','Hoa Phu','Dai An',700023,'Binh Duong',8500,7500),
('C108','Nguyen Sy','Tan An','Da Lat',700032,'Lam Dong ',15000,1000),
('C109','Duong Thanh','Phu Hoa','Ho Chi Minh',700011,'Ho Chi Minh',12000,8000),
('C110','Tran Minh','Phu My','Hanoi',700005,'Hanoi',9000,1000);


insert into salemanagerment.product values
('P1001','TV',10,30,1000,800),
('P1002','Laptop',12,25,1500,1100),
('P1003','AC',23,10,400,300),
('P1004','Modem',22,16,250,230),
('P1005','Pen',19,13,12,8),
('P1006','Mouse',5,10,100,105),
('P1007','Keyboard',45,60,120,90),
('P1008','Headset',63,75,50,40);


insert into salemanagerment.salesman values
('S001','Huu','Phu Tan','Ho Chi Minh',700002,'Ho Chi Minh',15000,50,35,'0902361123'),
('S002','Phat','Tan An','Hanoi',700005,'Hanoi',25000,100,110,'0903216542'),
('S003','Khoa','Phu Hoa','Thu Dau Mot',700051,'Binh Duong',17500,40,30,'0904589632'),
('S004','Tien','Phu Hoa','Dai An',700023,'Binh Duong',16500,70,72,'0908654723'),
('S005','Deb','Hoa Phu','Thu Dau Mot',700051,'Binh Duong',13500,60,48,'0903213659'),
('S006','Tin','Chanh My','Da Lat',700032,'Lam Dong',20000,80,55,'0907853497'),
('S007','Quang','Chanh My','Da Lat',700032,'Lam Dong',25000,90,95,'0900853487'),
('S008','Hoa','Hoa Phu','Thu Dau Mot',700051,'Binh Duong',13500,50,75,'0998213659');

 
insert into salemanagerment.salesorder values 
('O20001','2022-01-15','C101','S003','Delivered','2022-02-10','Successful'),
('O20002','2022-01-25','C102','S003','Delivered','2022-02-15','Cancelled'),
('O20003','2022-01-31','C103','S002','Delivered','2022-04-03','Successful'),
('O20004','2022-02-10','C104','S003','Delivered','2022-04-23','Successful'),
('O20005','2022-02-18','C101','S003','On Way',null,'Cancelled'),
('O20006','2022-02-22','C105','S005','Ready to Ship',null,'In Process'),
('O20007','2022-04-03','C106','S001','Delivered','2022-05-08','Successful'),
('O20008','2022-04-16','C102','S006','Ready to Ship',null,'In Process'),
('O20009','2022-04-24','C101','S004','On Way',null,'Successful'),
('O20010','2022-04-29','C106','S006','Delivered','2022-05-08','Successful'),
('O20011','2022-05-08','C107','S005','Ready to Ship',null,'Cancelled'),
('O20012','2022-05-12','C108','S004','On Way',null,'Successful'),
('O20013','2022-05-16','C109','S001','Ready to Ship',null,'In Process'),
('O20014','2022-05-16','C110','S001','On Way',null,'Successful'),
('O20015','2022-05-12','C108','S007','On Way', '2022-05-15','Successful'),
('O20016','2022-05-16','C109','S008','Ready to Ship',null,'In Process');

insert into salemanagerment.SalesOrderDetails values
('O20001','P1001',5),
('O20001','P1002',4),
('O20002','P1007',10),
('O20003','P1003',12),
('O20004','P1004',3),
('O20005','P1001',8),
('O20005','P1008',15),
('O20005','P1002',14),
('O20006','P1002',5),
('O20007','P1005',6),
('O20008','P1004',8),
('O20009','P1008',2),
('O20010','P1006',11),
('O20010','P1001',9),
('O20011','P1007',6),
('O20012','P1005',3),
('O20012','P1001',2),
('O20013','P1006',10),
('O20014','P1002',20),
('O20015','P1008',15),
('O20015','P1007',10),
('O20016','P1007',20),
('O20016','P1003',5);

DESCRIBE salemanagerment.clients;
DESCRIBE salemanagerment.product;
DESCRIBE salemanagerment.salesman;
DESCRIBE salemanagerment.salesorder;
DESCRIBE salemanagerment.salesorderdetails;

SELECT  * FROM salemanagerment.clients;
SELECT  * FROM salemanagerment.product;
SELECT  * FROM salemanagerment.salesman;
SELECT  * FROM salemanagerment.salesorder;
SELECT  * FROM salemanagerment.salesorderdetails;
