use salemanagerment;
-- 1. How to check constraint in a table?
SELECT CONSTRAINT_NAME, CONSTRAINT_TYPE
FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS
WHERE TABLE_NAME = 'clients';

-- 2. Create a separate table name as “ProductCost” from “Product” table, which contains the information about product name and its buying price.
create table ProductCost as select Product_Name, Cost_Price from product;
select * from ProductCost;

-- 3. Compute the profit percentage for all products. Note: profit = (sell-cost)/cost*100
alter table product add column profit float;
update product set profit = (sell_price - cost_price) / cost_price * 100;
select * from product;

-- 4. If a salesman exceeded his sales target by more than equal to 75%, his remarks should be ‘Good’.
alter table salesman add column label varchar(24);
update salesman
set label = case when Target_Achieved >= 0.75 * Sales_Target then 'Good' else
					case when Target_Achieved < 0.75 * Sales_Target and Target_Achieved >= 0.5 * Sales_Target then 'Average' else 'Poor' 
					end 
			end;
select * from salesman;


-- 5. If a salesman does not reach more than 75% of his sales objective, he is labeled as 'Average'.
update salesman
set label = case when Target_Achieved >= 0.75 * Sales_Target then 'Good' else
					case when Target_Achieved < 0.75 * Sales_Target and Target_Achieved >= 0.5 * Sales_Target then 'Average' else 'Poor' 
					end 
			end;
select * from salesman;

-- 6. If a salesman does not meet more than half of his sales objective, he is considered 'Poor'.
update salesman
set label = case when Target_Achieved >= 0.75 * Sales_Target then 'Good' else
					case when Target_Achieved < 0.75 * Sales_Target and Target_Achieved >= 0.5 * Sales_Target then 'Average' else 'Poor' 
					end 
			end;
select * from salesman;

-- 7. Find the total quantity for each product. (Query)
select Product_Name, Quantity_On_Hand + Quantity_On_Hand as Total from product;

-- 8. Add a new column and find the total quantity for each product.
alter table product add column Total_Quantity int;
update product set Total_Quantity = Quantity_On_Hand + Quantity_On_Hand;
select * from product;

-- 9. If the Quantity on hand for each product is more than 10, change the discount rate to 10 otherwise set to 5.
alter table product add column Discount_Rate int;
update product set Discount_Rate = case when Quantity_On_Hand > 10 then 10 else 5 end;
select * from product;
            
-- 10. If the Quantity on hand for each product is more than equal to 20, change the discount rate to 10, if it is between 10 and 20 then change to 5, if it is more than 5 then change to 3 otherwise set to 0.
update product set Discount_Rate = case when Quantity_On_Hand >= 20 then 10 else 
									case when Quantity_On_Hand >= 10 then 5 else
                                    case when Quantity_On_Hand >= 5 then 3 else 0
                                    end end	end;
select * from product;

-- 11. The first number of pin code in the client table should be start with 7.
alter table  clients add check (Pincode like "7%" );

-- 12. Creates a view name as clients_view that shows all customers information from Thu Dau Mot.
Create view clients_view as
select * from clients  where City = "Thu Dau Mot";
select * from clients_view;

-- 13. Drop the “client_view”.
drop view clients_view;

-- 14. Creates a view name as clients_order that shows all clients and their order details from Thu Dau Mot.
Create view clients_order as
select c.*, sod.* from clients  as c inner join salesorder as so on so.Client_Number = c.Client_Number
									 inner join salesorderdetails as sod on sod.Order_Number = so.Order_Number where c.City = "Thu Dau Mot";
select * from clients_order;

-- 15. Creates a view that selects every product in the "Products" table with a sell price higher than the average sell price.
Create view product_sellPrice_higher_than_avg_sellprice as
select * from product where Sell_Price > (select avg(Sell_Price) from product);

select * from product_sellPrice_higher_than_avg_sellprice;

-- 16. Creates a view name as salesman_view that show all salesman information and products (product names, product price, quantity order) were sold by them.
Create view salesman_view as
select s.*, p.Product_Name, p.Sell_Price, sod.Order_Quantity from salesman s inner join salesorder so on s.Salesman_Number = so.Salesman_Number
						   inner join salesorderdetails sod on sod.Order_Number = so.Order_Number
                           inner join product p on p.Product_Number = sod.Product_Number
where s.Salesman_Number = so.Salesman_Number;
select * from salesman_view;

-- 17. Creates a view name as sale_view that show all salesman information and product (product names, product price, quantity order) were sold by them with order_status = 'Successful'.
Create view sale_view as
select s.*, p.Product_Name, p.Sell_Price, sod.Order_Quantity from salesman s inner join salesorder so on s.Salesman_Number = so.Salesman_Number
						   inner join salesorderdetails sod on sod.Order_Number = so.Order_Number
                           inner join product p on p.Product_Number = sod.Product_Number
where so.Order_Status like "Successful";
select * from sale_view;

-- 18. Creates a view name as sale_amount_view that show all salesman information and sum order quantity of product greater than and equal 20 pieces were sold by them with order_status = 'Successful'
drop view if exists sale_amount_view;
Create view sale_amount_view as
select s.*, sum(sod.Order_Quantity) Quantity from salesman s inner join salesorder so on s.Salesman_Number = so.Salesman_Number
						   inner join salesorderdetails sod on sod.Order_Number = so.Order_Number
                           inner join product p on p.Product_Number = sod.Product_Number
where so.Order_Status like "Successful"
group by s.Salesman_Number
having sum(Order_Quantity) >= 20;
select * from sale_amount_view;

-- 19. Amount paid and amounted due should not be negative when you are inserting the data.
alter table  clients add check (Amount_Paid >= 0 and Amount_Due >= 0 );

-- 20. Remove the constraint from pincode;
alter table  clients drop constraint clients_chk_2;

-- 21. The sell price and cost price should be unique.
alter table product add constraint product_price_unique unique(Sell_Price,Cost_Price);

-- 22. The sell price and cost price should not be unique.
alter table  product drop constraint product_price_unique;

-- 23. Remove unique constraint from product name.
alter table  product drop constraint Product_Name;

-- 24. Update the delivery status to “Delivered” for the product number P1007.
update salesorder so inner join salesorderdetails sod on sod.Order_Number = so.Order_Number
		set so.Delivery_Status = "Delivered" where sod.Product_Number = "P1007" ;

-- 25. Change address and city to ‘Phu Hoa’ and ‘Thu Dau Mot’ where client number is C104.
update clients set Address = "Phu Hoa", City ="Thu Dau Mot" where Client_Number = "C104";

-- 26. Add a new column to “Product” table named as “Exp_Date”, data type is Date.
alter table product add column Exp_Date Date;

-- 27. Add a new column to “Clients” table named as “Phone”, data type is varchar and size is 15.
alter table Clients add column Phone varchar(15);

-- 28. Update remarks as “Good” for all salesman.
update salesman set label = "Good";
select * from salesman;

-- 29. Change remarks to "bad" whose salesman number is "S004".
update salesman set label = "bad" where Salesman_Number = "S004";
select * from salesman;

-- 30. Modify the data type of “Phone” in “Clients” table with varchar from size 15 to size is 10.
alter table salesman modify column Phone varchar(10);

-- 31. Delete the “Phone” column from “Clients” table.
alter table salesman drop column Phone;

-- 32. alter table Clients drop column Phone;
alter table salesman drop column Phone;

-- 33. Change the sell price of Mouse to 120.
update product set Sell_Price = 120 where Product_Name ="Mouse";

-- 34. Change the city of client number C104 to “Ben Cat”.
update clients set City = "Ben Cat" where Client_Number ="C104";

-- 35. If On_Hand_Quantity greater than 5, then 10% discount. If On_Hand_Quantity greater than 10, then 15% discount. Othrwise, no discount.
update product set Discount_Rate = case when Quantity_On_Hand > 10 then 15 else 
								   case when Quantity_On_Hand > 5 then 10 else 0
                                    end end;
