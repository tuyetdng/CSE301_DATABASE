use salemanagerment;
-- 1. SQL statement returns the cities (only distinct values) from both the "Clients" and the "salesman" table.
SELECT City FROM Clients
UNION
SELECT City FROM salesman;

-- 2. SQL statement returns the cities (duplicate values also) both the "Clients" and the "salesman" table.
SELECT City FROM Clients
UNION ALL
SELECT City FROM salesman;

-- 3. SQL statement returns the Ho Chi Minh cities (only distinct values) from the "Clients" and the "salesman" table.
SELECT City FROM Clients WHERE City like "Ho Chi Minh"
UNION
SELECT City FROM salesman WHERE City like "Ho Chi Minh";

-- 4. SQL statement returns the Ho Chi Minh cities (duplicate values also) from the "Clients" and the "salesman" table.
SELECT City FROM Clients WHERE City like "Ho Chi Minh"
UNION ALL
SELECT City FROM salesman WHERE City like "Ho Chi Minh";

-- 5. SQL statement lists all Clients and salesman.
select Client_Number from Clients union select Salesman_Number from salesman;

-- 6. Write a SQL query to find all salesman and clients located in the city of Ha Noi on a table with information: ID, Name, City and Type.
select * from (select Client_Number ID, Client_Name `Name`, City, 'client' `Type` from clients where city like "Hanoi"
union all select Salesman_Number ID, Salesman_Name `Name`, City, 'salesman' `Type` from salesman  where city like "Hanoi") as T
order by `name`;

-- 7. Write a SQL query to find those salesman and clients who have placed more than one order. Return ID, name and order by ID.
select T.ID, T.Name,count(Order_Number)  from (
	select Client_Number ID, Client_Name `Name` from clients c
    union all 
	select Salesman_Number ID, Salesman_Name `Name` from salesman s) as T 
		   inner join salesorder so on T.ID = so.Client_Number or T.ID = so.Salesman_Number
group by T.ID, T.Name
having count(Order_Number) > 1
order by ID;

-- 8. Retrieve Name, Order Number (order by order number) and Type of client or salesman with the client names who placed orders and the salesman names who processed those orders.
select c.Client_Name, so.Order_Number, 'client' `Type` from clients c
inner join salesorder so on c.Client_Number = so.Client_Number
union all
select Salesman_Name ,  so.Order_Number, 'salesman' `Type` from salesman s
inner join salesorder so on s.Salesman_Number = so.Salesman_Number
order by Order_Number;

-- 9. Write a SQL query to create a union of two queries that shows the salesman, cities, and target_Achieved of all salesmen. Those with a target of 60 or greater will have the words 'High Achieved', while the others will have the words 'Low Achieved'.
alter table salesman add column label varchar(24);
update salesman set label = case when Target_Achieved >= 60 then 'High Achieved' else 'Low Achieved' end;
select Salesman_Number, Salesman_Name, City, Target_Achieved, label from salesman WHERE label like 'High Achieved'
union all 
select Salesman_Number, Salesman_Name, City, Target_Achieved, label from salesman WHERE label like 'Low Achieved';

-- 10. Write query to creates lists all products (Product_Number AS ID, Product_Name AS Name, Quantity_On_Hand AS Quantity) and their stock status. Products with a positive quantity in stock are labeled as 'More 5 pieces in Stock'. Products with zero quantity are labeled as ‘Less 5 pieces in Stock'
select Product_Number AS ID, Product_Name AS Name, Quantity_On_Hand AS Quantity, 'More 5 pieces in Stock' `stock_status` from product WHERE Quantity_On_Hand > 0
union all 
select Product_Number AS ID, Product_Name AS Name, Quantity_On_Hand AS Quantity, 'Less 5 pieces in Stock' `stock_status` from product WHERE Quantity_On_Hand = 0;

-- 11. Create a procedure stores get_clients _by_city () saves the all Clients in table. Then Call procedure stores.
delimiter $$
create procedure get_client_by_city(IN cityin varchar(38))
begin
	select * from clients
    where city = cityin;
end$$
delimiter ;

call get_client_by_city("Hanoi");

-- 12. Drop get_clients _by_city () procedure stores
drop procedure get_client_by_city;

-- 13. Create a stored procedure to update the delivery status for a given order number. Change value delivery status of order number “O20006” and “O20008” to “On Way”.
delimiter $$
create procedure update_the_delivery_status(IN Order_Numberin varchar(38))
begin
	update  salesorder set Delivery_Status ='On Way' 
    where Order_Number = Order_Numberin;
end$$
delimiter ;
call update_the_delivery_status("O20006");
call update_the_delivery_status("O20008");
drop procedure update_the_delivery_status;
-- 14. Create a stored procedure to retrieve the total quantity for each product.
delimiter $$
create procedure retrieve_the_total_quantity()
begin
	select Product_Name ,Quantity_On_Hand + Quantity_Sell as Quantity
	from product;

end$$
delimiter ;
call retrieve_the_total_quantity;

-- 15. Create a stored procedure to update the remarks for a specific salesman.
alter table salesman add column remark varchar(24);
delimiter $$
create procedure retrieve_the_remarks(IN Salesman_Numberin varchar(38), remarksin varchar(38))
begin
	update  salesman set remark =  remarksin
    where Salesman_Number = Salesman_Numberin;

end$$
delimiter ;
call retrieve_the_remarks('S001', 'Good');
select * from salesman;

-- 16. Create a procedure stores find_clients() saves all of clients and can call each client by client_number.
delimiter $$
create procedure find_clients(IN Client_Numberin varchar(38))
begin
	select * from clients where Client_Number = Client_Numberin;

end$$
delimiter ;
call find_clients('C101');

-- 17. Create a procedure stores salary_salesman() saves all of clients (salesman_number, salesman_name, salary) having salary >15000. Then execute the first 2 rows and the first 4 rows from the salesman table.
delimiter $$
create procedure salary_salesman(IN limittime int)
begin
	select c.Client_Number,c.Client_Name, s.salesman_number, s.salesman_name, s.salary 
    from salesman s  inner join salesorder so on so.Salesman_Number = s.Salesman_Number
					 inner join clients c on so.Client_Number = c.Client_Number
	where s.salary > 15000
    limit limittime;

end$$
delimiter ;
call salary_salesman(2);
call salary_salesman(4);

-- 18. Procedure MySQL MAX() function retrieves maximum salary from MAX_SALARY of salary table.
delimiter $$
create procedure MAX_SALARY()
begin
	select max(Salary) maxSalary_Saleman from (select Salary from salesman) as T;

end$$
delimiter ;
call MAX_SALARY;

-- 19. Create a procedure stores execute finding amount of order_status by values order status of salesorder table.
delimiter $$
create procedure amount_of_order_status()
begin
	select Order_Status, count(Order_Status) amount from salesorder
    group by Order_Status;

end$$
delimiter ;
call amount_of_order_status;

-- 21. Count the number of salesman with following conditions : SALARY < 20000; SALARY > 20000; SALARY = 20000.
delimiter $$
create procedure amount_of_salesman_salary_condition()
begin
	select 'SALARY < 20000' `condition`, count(Salesman_Number) amount from salesman
     where Salary < 20000
     group by `condition`
     union select 'SALARY > 20000' `condition`, count(Salesman_Number) amount from salesman
     where Salary > 20000
     group by `condition`
     union select 'SALARY = 20000' `condition`, count(Salesman_Number) amount from salesman
     where Salary = 20000
     group by `condition`;

end$$
delimiter ;
call amount_of_salesman_salary_condition;

-- 22. Create a stored procedure to retrieve the total sales for a specific salesman.
delimiter $$
create procedure total_sales_for_a_specific_salesman(IN Salesman_Numberin varchar(38))
begin
	select salesman_number, salesman_name, Target_Achieved as totalSales from salesman
    where Salesman_Number = Salesman_Numberin;

end$$
delimiter ;
call total_sales_for_a_specific_salesman('S001');

-- 23. Create a stored procedure to add a new product: Input variables: Product_Number, Product_Name, Quantity_On_Hand, Quantity_Sell, Sell_Price, Cost_Price.
delimiter $$
create procedure add_new_product (IN Product_Number varchar(15), Product_Name varchar(25), Quantity_On_Hand int, Quantity_Sell int, Sell_Price decimal(15,4), Cost_Price decimal(15,4))
begin
	insert into salemanagerment.product values
    (Product_Number,Product_Name,Quantity_On_Hand,Quantity_Sell,Sell_Price,Cost_Price);

end$$
delimiter ;
call add_new_product('P2222','SmartWatch',12,25,1500,1100);
select * from product;

-- 24. Create a stored procedure for calculating the total order value and classification:
-- This stored procedure receives the order code (p_Order_Number) và return the total value 
-- (p_TotalValue) and order classification (p_OrderStatus). - - - 
-- Using the cursor (CURSOR) to browse all the products in the order (SalesOrderDetails ). 
-- LOOP/While: Browse each product and calculate the total order value. 
-- CASE WHEN: Classify orders based on total value: 
-- Greater than or equal to 10000: "Large" 
-- Greater than or equal to 5000: "Midium" 
-- Less than 5000: "Small" 

DELIMITER $$

create procedure CalculateOrderValueAndClassification(
    in p_Order_Number varchar(15),
    out p_TotalValue decimal(15,4),
    out p_OrderStatus varchar(15)
)
begin
    declare v_Product_Number varchar(15);
    declare v_Order_Quantity int;
    declare v_Sell_Price decimal(15, 4);
    declare v_TotalValue decimal(15, 4) default 0;
    declare done int default 0;

    declare cur cursor for 
        select sod.Product_Number, sod.Order_Quantity, p.Sell_Price
        from SalesOrderDetails sod inner join product p on sod.Product_Number = p.Product_Number
        where sod.Order_Number = p_Order_Number;
    
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = 1;

    open cur;
    read_loop: loop
        fetch cur into v_Product_Number, v_Order_Quantity, v_Sell_Price;
        if done then
            leave read_loop;
        end if;
        set v_TotalValue = v_TotalValue + (v_Order_Quantity * v_Sell_Price);
   end loop;
    close cur;

    set p_TotalValue = v_TotalValue;

    case when v_TotalValue >= 10000 then set p_OrderStatus = 'Large';
        when v_TotalValue >= 5000 then set p_OrderStatus = 'Medium';
        else set p_OrderStatus = 'Small';
    end case;
end $$

DELIMITER ;

set @TotalValue = 0;
set @OrderStatus = '';
call CalculateOrderValueAndClassification('O20006', @TotalValue, @OrderStatus);
select @TotalValue, @OrderStatus;


