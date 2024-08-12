use salemanagerment;

-- 1. Create a trigger before_total_quantity_update to update total quantity of product when Quantity_On_Hand and Quantity_sell change values. Then Update total quantity when Product P1004 have Quantity_On_Hand = 30, quantity_sell =35.
delimiter //

CREATE TRIGGER before_total_quantity_update
BEFORE UPDATE ON product
FOR EACH ROW
BEGIN
    DECLARE total_quantity INT;
    if OLD.Quantity_On_Hand <> NEW.Quantity_On_Hand OR OLD.Quantity_Sell <> NEW.Quantity_Sell
    THEN SET total_quantity = NEW.Quantity_On_Hand + NEW.Quantity_Sell;
	end if;
END;
//

delimiter ;

-- Update the product P1004 with new values for Quantity_On_Hand and Quantity_Sell
update product 
set Quantity_On_Hand = 30, Quantity_Sell = 35 
where Product_Number = 'P1004';
select * from product;

-- 2. Create a trigger before_remark_salesman_update to update Percentage of per_remarks in a salesman table (will be stored in PER_MARKS column) : per_remarks = target_achieved*100/sales_target.
alter table Salesman add column per_remarks decimal(5, 2);

DELIMITER //

create trigger before_remark_salesman_update
before update on Salesman
for each row
begin
    set new.per_remarks = (new.Target_Achieved * 100.0) / new.Sales_Target;
end;
//

delimiter ;


-- 3. Create a trigger before_product_insert to insert a product in product table.
delimiter //

create trigger before_product_insert
before insert on SaleManagerment.product
for each row
begin
    if left(new.Product_Number, 1) <> 'P' then
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Product_Number must start with "P".';
    end if;

    if new.Cost_Price <= 0 then
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Cost_Price must be greater than 0.';
    end if;

    set new.Profit = new.Sell_Price - new.Cost_Price;
    set new.Total_Quantity = new.Quantity_On_Hand + new.Quantity_Sell;
end;
//

delimiter ;


select * from product;
-- 4. Create a trigger to before update the delivery status to "Delivered" when an order is marked as "Successful".
delimiter //

create trigger before_update_successful_order
before update on SalesOrder
for each row
begin
    if new.Order_Status = 'Successful' then set new.Delivery_Status = 'Delivered';
    end if;
end;
//

delimiter ;

update salesorder 
set Order_Status = 'Successful' 
where Order_Number = 'O20014';
select * from salesorder;

-- 5. Create a trigger to update the remarks "Good" when a new salesman is inserted.

delimiter //

create trigger before_salesman_insert
before insert on Salesman
for each row
begin
    set new.remarks = 'Good';
end;
//

delimiter ;

-- 6. Create a trigger to enforce that the first digit of the pin code in the "Clients" table must be 7.
delimiter //

create trigger enforce_pincode
before insert on clients
for each row
begin
    if left(new.Pincode, 1) != '7' then
        signal sqlstate '45000'
        set message_text = 'The first digit of the Pincode must be 7';
    end if;
end;
//

delimiter ;

-- 7. Create a trigger to update the city for a specific client to "Unknown" when the client is deleted
delimiter //

create trigger before_client_delete
before delete on clients
for each row
begin
    update clients
    set City = 'Unknown' where Client_Number = old.Client_Number;
    signal sqlstate '45000'
    set message_text = 'Client deletion prevented, city set to "Unknown" instead.';
end
//
delimiter ;

-- 8. Create a trigger after_product_insert to insert a product and update profit and total_quantity in product table.
delimiter //
create trigger after_product_insert
after insert on product
for each row
begin
    set @profit = (new.Sell_Price - new.Cost_Price) * new.Quantity_Sell;

    update product
    set profit = @calculated_profit,
        total_quantity = new.Quantity_On_Hand + new.Quantity_Sell
    where Product_Number = new.Product_Number;
end;
//

delimiter ;

-- 9. Create a trigger to update the delivery status to "On Way" for a specific order when an order is inserted.
delimiter //
create trigger after_delivery_status_insert
after insert on salesorder
for each row
begin
    update salesorder
    set Delivery_Status = 'On Way'
    where Order_Number = new.Order_Number;
end;
//

delimiter ;

-- 10. Create a trigger before_remark_salesman_update to update Percentage of per_remarks in a salesman table (will be stored in PER_MARKS column) If per_remarks >= 75%, his remarks should be ‘Good’. If 50% <= per_remarks < 75%, he is labeled as 'Average'. If per_remarks <50%, he is considered 'Poor'.
delimiter //

create trigger before_remark_salesman_update_Based_on_per_remarks_update
before update on Salesman
for each row
begin   
   set new.per_remarks = (new.Target_Achieved * 100.0) / new.Sales_Target;
   update salesman set  NEW.remarks  = case when per_remarks >= 75 then 'Good' else
			case when per_remarks >= 50 then 'Average' else 'Poor' 
			end end;
end;
//

delimiter ;

-- 11. Create a trigger to check if the delivery date is greater than the order date, if not, do not insert it.
delimiter //

create trigger before_insert_salesorder
before insert on SalesOrder
for each row
begin
    if new.Delivery_Date <= new.Order_Date then
        signal sqlstate '45000'
        set message_text = 'Delivery_Date must be greater than Order_Date.';
    end if;
end;
//

delimiter ;

-- 12. Create a trigger to update Quantity_On_Hand when ordering a product (Order_Quantity)
delimiter //

create trigger after_order_insert
after insert on SalesOrderDetails
for each row
begin
    if (select Quantity_On_Hand from product where Product_Number = new.Product_Number) < new.Order_Quantity 
    then SIGNAL SQLSTATE '45000'
         SET MESSAGE_TEXT = 'Insufficient stock for Product_Number: ';
    else
        update product
        set Quantity_On_Hand = Quantity_On_Hand - new.Order_Quantity
        where Product_Number = new.Product_Number;
    End if;
end;
//

delimiter ;


-- 1. Find the average salesman’s salary.
delimiter //
create function average_salesman_salary()
returns decimal(15, 2)
deterministic
begin
    declare avg_salary decimal(15, 2);
    select avg(Salary) into avg_salary
    from Salesman;

    return avg_salary;
end;
//

delimiter ;

select average_salesman_salary();


-- 2. Find the name of the highest paid salesman.
delimiter //
create function highest_paid_salesman()
returns varchar(100)
deterministic
begin
    declare highest_paid_salesman_name varchar(100);
    select Salesman_Name from salesman where Salary = (select max(Salary) from salesman)  limit 1 into highest_paid_salesman_name;
    return highest_paid_salesman_name;
end;
//

delimiter ;
-- drop function  highest_paid_salesman;
select highest_paid_salesman()

-- 3. Find the name of the salesman who is paid the lowest salary.
delimiter //
create function lowest_paid_salesman()
returns varchar(100)
deterministic
begin
    declare lowest_paid_salesman varchar(100);
    select Salesman_Name from salesman where Salary = (select min(Salary) from salesman)  limit 1 into lowest_paid_salesman;
    return lowest_paid_salesman;
end;
//

delimiter ;
select lowest_paid_salesman()

-- 4. Determine the total number of salespeople employed by the company.
delimiter //
create function count_total_salesman()
returns int
deterministic
begin
    declare totalSalesman int;
    select count(*) into totalSalesman from Salesman;

    return totalSalesman;
end;
//

delimiter ;
-- drop function  count_total_salesman;

select count_total_salesman();

-- 5. Compute the total salary paid to the company's salesman.
delimiter //
create function count_total_paid()
returns decimal(15,4)
deterministic
begin
    declare totalPaid decimal(15,4);
    select sum(Salary) into totalPaid from Salesman;

    return totalPaid;
end;
//

delimiter ;
-- drop function  count_total_salesman;

select count_total_paid();

-- 6. Find Clients in a Province
delimiter //

create function clients_in_a_province(iProvince varchar(15))
returns int
deterministic
begin
    declare numsClients int;

    select count(Province) into numsClients
    from clients
    where Province = iProvince;
    return numsClients;
end;
//

delimiter ;

select clients_in_a_province('Binh Duong');

-- 7. Calculate Total Sales
delimiter //
create function count_total_sales()
returns int
deterministic
begin
    declare totalSales int;
    select sum(Order_Quantity) into totalSales from salesorderdetails;

    return totalSales;
end;
//

delimiter ;
-- drop function  count_total_sales;

select count_total_sales();

-- 8. Calculate Total Order Amount
delimiter //

create function calculate_total_order_amount(order_number varchar(15))
returns decimal(15, 2)
deterministic
begin
    declare total_amount decimal(15, 2);

    select sum(sd.Order_Quantity * p.Sell_Price) into total_amount
    from SalesOrderDetails sd
    inner join product p on sd.Product_Number = p.Product_Number
    where sd.Order_Number = order_number;
    return total_amount;
end;
//

delimiter ;
select calculate_total_order_amount("O20001");

