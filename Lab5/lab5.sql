use salemanagerment;
-- 1. Display the clients (name) who lives in same city.
select Client_Name from clients
where City in (
	select City from clients
	group by City
	having count(*)>=2)
order by City;

-- 2. Display city, the client names and salesman names who are lives in “Thu Dau Mot” city.
select c.city, c.client_name, s.salesman_name from clients as c inner join salesman as s on c.City like "Thu Dau Mot" and s.City like "Thu Dau Mot";

-- 3. Display client name, client number, order number, salesman number, and product number for each order.
select c.client_name, c.Client_Number, so.Order_Number, s.Salesman_Number, sod.Product_Number from clients as c
inner join
    salesorder as so
on 
    c.Client_Number = so.Client_Number
inner join 
    salesman as s
on 
    s.Salesman_Number = so.Salesman_Number
inner join 
    salesorderdetails as sod
on 
    sod.Order_Number = so.Order_Number;    

-- 4. Find each order (client_number, client_name, order_number) placed by each client.
select c.Client_Number, c.Client_Name, so.Order_Number from clients as c
inner join
    salesorder as so
on 
    c.Client_Number = so.Client_Number;

-- 5. Display the details of clients (client_number, client_name) and the number of orders which is paid by them.
select 
    c.Client_Number, 
    c.Client_Name, 
    COUNT(so.Order_Number) AS Number_Of_Orders
from 
    clients c
inner join
    SalesOrder so 
on 
    c.Client_Number = so.Client_Number
group by 
    c.Client_Number, 
    c.Client_Name;
	
-- 6. Display the details of clients (client_number, client_name) who have paid for more than 2 orders.
select 
    c.Client_Number, 
    c.Client_Name, 
    COUNT(so.Order_Number) AS Number_Of_Orders
from 
    clients c
inner join
    SalesOrder so 
on 
    c.Client_Number = so.Client_Number
group by 
    c.Client_Number, 
    c.Client_Name
having Number_Of_Orders > 2;

-- 7. Display details of clients who have paid for more than 1 order in descending order of client_number.
select 
    c.Client_Number, 
    c.Client_Name, 
    COUNT(so.Order_Number) AS Number_Of_Orders
from 
    clients c
inner join
    SalesOrder so 
on 
    c.Client_Number = so.Client_Number
group by 
    c.Client_Number, 
    c.Client_Name
having Number_Of_Orders > 1
order by c.Client_Number desc;

-- 8. Find the salesman names who sells more than 20 products.
select s.Salesman_Name ,sum(Order_Quantity) Quantity
from salesman s inner join  SalesOrder so on s.Salesman_Number = so.Salesman_Number
			    inner join  salesorderdetails as sod on sod.Order_Number = so.Order_Number  
group by s.Salesman_Name 
having sum(Order_Quantity) > 20;

-- 9. Display the client information (client_number, client_name) and order number of those clients who have order status is cancelled.
select c.Client_Number, c.Client_Name, s.Order_Number
from clients c inner join  salesorder s on s.Client_Number = c.Client_Number
where s.Order_Status like 'Cancelled';

-- 10. Display client name, client number of clients C101 and count the number of orders which were received “successful”.
select  c.Client_Number,  c.Client_Name, COUNT(so.Order_Status)
from clients c inner join SalesOrder so on c.Client_Number = so.Client_Number
where c.Client_Number = 'C101' and so.Order_Status = 'Successful'
group by 
    c.Client_Number, 
    c.Client_Name;

-- 11. Count the number of clients orders placed for each product.
select p.Product_Name ,sum(Order_Quantity) Quantity
from product p inner join  salesorderdetails as sod on sod.Product_Number = p.Product_Number  
group by p.Product_Name;

-- 12. Find product numbers that were ordered by more than two clients then order in descending by product number.
select product_number, count(*)
from (
select distinct b.Product_Number, c.client_number
from  salesorderdetails b 
			inner join salesorder c on b.Order_Number= c.Order_Number) as t
group by Product_Number
having count(*)>2;

-- 13. Find the salesman’s names who is getting the second highest salary.
select Salesman_Name from salesman where Salary = (
	select max(Salary) from salesman
	where Salary <> (select max(Salary) from salesman)
);

-- 14. Find the salesman’s names who is getting second lowest salary.
select Salesman_Name from salesman where Salary = (
	select min(Salary) from salesman
	where Salary <> (select min(Salary) from salesman)
);

-- 15. Write a query to find the name and the salary of the salesman who have a higher salary than the salesman whose salesman number is S001.
select Salesman_Name, Salary from salesman where Salary > (
	select Salary from salesman
	where Salesman_Number like "S001");

-- 16. Write a query to find the name of all salesman who sold the product has number: P1002.
select s.Salesman_Name 
	from salesman s inner join salesorder so on s.Salesman_Number = so.Salesman_Number
					inner join salesorderdetails sod on sod.Order_Number = so.Order_Number
 where sod.Product_Number = 'P1002';
    
-- 17. Find the name of the salesman who sold the product to client C108 with delivery status is “delivered”
select s.Salesman_Name
    from salesman s inner join salesorder so on s.Salesman_Number = so.Salesman_Number
    where so.Client_Number like 'C108' and so.Delivery_Status like 'Delivered';
    
-- 18. Display lists the ProductName in ANY records in the sale Order Details table has Order Quantity equal to 5.
select p.Product_Name from product p inner join SalesOrderDetails sod on p.Product_Number = sod.Product_Number
where sod.Order_Quantity = 5;

-- 19. Write a query to find the name and number of the salesman who sold pen or TV or laptop.
select distinct s.Salesman_Name, s.Salesman_Number
	from salesman s inner join salesorder so on s.Salesman_Number = so.Salesman_Number
					inner join salesorderdetails sod on sod.Order_Number = so.Order_Number
                    inner join product p on p.Product_Number = sod.Product_Number
 where p.Product_Name in ( "Pen","TV","Laptop");

-- 20. Lists the salesman’s name sold product with a product price less than 800 and Quantity_On_Hand more than 50.
select distinct s.Salesman_Name
	from salesman s inner join salesorder so on s.Salesman_Number = so.Salesman_Number
					inner join salesorderdetails sod on sod.Order_Number = so.Order_Number
                    inner join product p on p.Product_Number = sod.Product_Number
 where p.Sell_Price < 800 and p.Quantity_On_Hand >50;

-- 21. Write a query to find the name and salary of the salesman whose salary is greater than the average salary.
select s.Salesman_Name, s.Salary from salesman s 
 where s.Salary > (select avg(Salary) from salesman);

-- 22. Write a query to find the name and Amount Paid of the clients whose amount paid is greater than the average amount paid.
select c.Client_Name, c.Amount_Paid from clients c 
 where c.Amount_Paid > (select avg(Amount_Paid) from clients);

-- 23. Find the product price that was sold to Le Xuan.
select p.Sell_Price 
from product p inner join salesorderdetails sod on p.Product_Number = sod.Product_Number
			   inner join salesorder so on so.Order_Number = sod.Order_Number
               inner join clients c on so.Client_Number = c.Client_Number
where c.Client_Name like 'Le Xuan';

-- 24. Determine the product name, client name and amount due that was delivered.
select p.Product_Name, c.Client_Name, c.Amount_Due 
from product p inner join salesorderdetails sod on p.Product_Number = sod.Product_Number
			   inner join salesorder so on so.Order_Number = sod.Order_Number
               inner join clients c on so.Client_Number = c.Client_Number
where c.Client_Name like 'Le Xuan';

-- 25. Find the salesman’s name and their product name which is cancelled.
 select s.Salesman_Name, p.Product_Name 
from product p inner join salesorderdetails sod on p.Product_Number = sod.Product_Number
			   inner join salesorder so on so.Order_Number = sod.Order_Number
               inner join salesman s on so.Salesman_Number = s.Salesman_Number
where so.Order_Status like 'Cancelled';
 
-- 26. Find product names, prices and delivery status for those products purchased by Nguyen Thanh.
select p.Product_Name, p.Sell_Price, so.Order_Status
from product p inner join salesorderdetails sod on p.Product_Number = sod.Product_Number
			   inner join salesorder so on so.Order_Number = sod.Order_Number
               inner join clients c on so.Client_Number = c.Client_Number
where c.Client_Name like 'Nguyen Thanh';

-- 27. Display the product name, sell price, salesperson name, delivery status, and order quantity information for each customer.
select p.Product_Name, p.Sell_Price, s.Salesman_Name, so.Delivery_Status, sod.Order_Quantity
from salesOrderDetails sod inner join product p on sod.Product_Number = p.Product_Number
						   inner join SalesOrder so on sod.Order_Number = so.Order_Number
						   inner join salesman s on so.Salesman_Number = s.Salesman_Number;

-- 28. Find the names, product names, and order dates of all sales staff whose product order status has been successful but the items have not yet been delivered to the client.
select s.Salesman_Name, p.Product_Name, so.Order_Date
from product p inner join salesorderdetails sod on p.Product_Number = sod.Product_Number
			   inner join salesorder so on so.Order_Number = sod.Order_Number
               inner join salesman s on so.Salesman_Number = s.Salesman_Number
where so.Order_Status like 'Successful' and so.Delivery_Status not like 'Delivered';

-- 29. Find each clients’ product which in on the way.
select c.Client_Name, c.Client_Number, p.Product_Name, sod.Order_Quantity, so.Order_Date, so.Delivery_Status 
from product p inner join salesorderdetails sod on p.Product_Number = sod.Product_Number
			   inner join salesorder so on so.Order_Number = sod.Order_Number
               inner join clients c on so.Client_Number = c.Client_Number
where so.Delivery_Status like 'On Way'; 

-- 30. Find salary and the salesman’s names who is getting the highest salary.
select Salary, Salesman_Name from salesman where Salary = (select max(Salary) from salesman);

-- 31. Find salary and the salesman’s names who is getting second lowest salary.
select Salary, Salesman_Name from salesman where Salary = (
	select min(Salary) from salesman
	where Salary <> (select min(Salary) from salesman)
);
-- 32. Display lists the ProductName in ANY records in the sale Order Details table has Order Quantity more than 9.
select p.Product_Name ,sum(Order_Quantity) Quantity
from product p inner join  salesorderdetails as sod on sod.Product_Number = p.Product_Number  
group by p.Product_Name
having sum(Order_Quantity) > 9; 

-- 33. Find the name of the customer who ordered the same item multiple times.
select c.Client_Name, COUNT(so.Client_Number) num_of_order
from clients c inner join SalesOrder so on c.Client_Number = so.Client_Number
group by c.Client_Name
having COUNT(so.Client_Number) > 1;

-- 34. Write a query to find the name, number and salary of the salemans who earns less than the average salary and works in any of Thu Dau Mot city.
select Salesman_Name, Salesman_Number, Salary from salesman where Salary < (select avg(Salary) from salesman) and City like 'Thu Dau Mot';

-- 35. Write a query to find the name, number and salary of the salemans who earn a salary that is higher than the salary of all the salesman have (Order_status = ‘Cancelled’). Sort the results of the salary of the lowest to highest.
select Salesman_Name, Salesman_Number, Salary from salesman where Salary > (
	select max(s.Salary) from  salesorder so inner join salesman s on so.Salesman_Number = s.Salesman_Number
	where so.Order_Status like 'Cancelled')
order by Salary asc;

-- 36. Write a query to find the 4th maximum salary on the salesman’s table.
-- select Salesman_Name, Salary from salesman order by Salary desc;
select distinct Salary from salesman
order by Salary desc
limit 3, 1;

-- 37. Write a query to find the 3th minimum salary in the salesman’s table.
-- select Salesman_Name, Salary from salesman order by Salary asc;
select distinct Salary from salesman
order by Salary asc
limit 2, 1;

