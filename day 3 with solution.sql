select * from orders;
-- write a sql to get all the orders where customers name has "a" as second character and "d" as fourth character (58 rows)
select customer_name from orders
where customer_name like '_a_d%'
order by customer_name;

select * from orders;
-- write a sql to get all the orders placed in the month of dec 2020 (352 rows)
select order_date from orders
where order_date between '2020-12-1' and '2020-12-31'
order by order_date;

select * from orders;
-- write a query to get all the orders where ship_mode is neither in 'Standard Class' nor in 'First Class' and ship_date is after nov 2020 (944 rows)
select ship_mode, ship_date from orders
where ship_mode not in ('Standard Class', 'First Class') and ship_date > '2020-11-30'
;

select * from orders;
-- write a query to get all the orders where customer name neither start with "A" and nor ends with "n" (9815 rows)
select customer_name from orders
where customer_name not like 'A%n';

select * from orders;
-- write a query to get all the orders where profit is negative (1871 rows)
select profit from orders
where profit < 0;

select * from orders;
-- write a query to get all the orders where either quantity is less than 3 or profit is 0 (3348)
select quantity, profit from orders
where quantity < 3 or profit = 0; 

select * from orders;
-- your manager handles the sales for South region and he wants you to create a report of all the orders in his region where some discount is provided to the customers (815 rows)
select region, discount from orders
where region = 'South' and discount >0;

select * from orders;
-- write a query to find top 5 orders with highest sales in furniture category 


select * from orders;
-- write a query to find all the records in technology and furniture category for the orders placed in the year 2020 only (1021 rows)


select * from orders;
-- write a query to find all the orders where order date is in year 2020 but ship date is in 2021 (33 rows)