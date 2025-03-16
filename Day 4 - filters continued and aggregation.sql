--Assignment 1 discussion
--write a query to get all the orders where customer name neither start with "A" and nor ends with "n" (9815 rows)
select * from orders
where customer_name not like 'A%n';

select * from orders
where not (customer_name like 'A%' and customer_name like '%n');
--The above both codes are same but it's better to use firt format since it runs only one time while second one runs three times

--write a query to find top 5 orders with highest sales in furniture category 
select  top 5 * from orders
where category  = 'Furniture'
order by sales desc;
--order of running above code:  from->where->select->order by->top 5

select * from orders
--suppose someone has put his/her city 'null' and we are supposed to find it
-----is null & is not null-----
--but first let's put some city as null
update orders
set city = null 
where order_id in ('CA-2020-161389', 'US-2021-156909');

select * from orders
where order_id in ('CA-2020-161389', 'US-2021-156909');

select * from orders
where city = null;
--when we execute the above code, we get blank rows since 'null' is an unknown value
--how do we find null?
select * from orders
where city is null;
--2 records

select * from orders
where city is not null;
--9992 records

--so far, we have covered dealing with a single row only  i.e. updating, adding, deleting, inserting etc

-------aggregation-------
-----count(*)-----
--we wish to know how many rows are there in the table
select count(*) from orders;

--we can name this column
select count(*) as total_rows 
from orders;

-----sum()-----
select count(*) as total_rows,
sum(sales) as total_sales
from orders;

-----max()-----
select count(*) as total_rows,
sum(sales) as total_sales,
max(sales) as max_sales
from orders;

-----min()-----
select count(*) as total_rows,
sum(sales) as total_sales,
max(sales) as max_sales,
min(sales) as min_sales
from orders;

-----avg()-----
select count(*) as numberof_rows,
sum(sales) as total_sales,
max(profit) as max_profit,
min(profit) as min_profit,
avg(profit) as avg_profit
from orders;
--the below code is just to verify that we are getting the correct result
select top 1 * from orders order by sales desc;

-----group by-----
--by using the above code, we are able to see all data present in the table
--but what if we want to see the data according to region
select region, 
count(*) as numberof_rows,
sum(sales) as total_sales,
max(profit) as max_profit,
min(profit) as min_profit,
avg(profit) as avg_profit
from orders
group by region;

select region 
from  orders
group by region;
--or
select distinct region 
from orders;

--the advantage of using 'group by' is that we can get aggregrated values
select region,
sum(sales) as total_sales
from orders
group by region;

--if we don't write region after select statement the output won't show region which won't make sense
select sum(sales) as total_sales
from orders
group by region;

--we have to use non-aggregrated columns in group by
--we can use 'group by' for multiple columns also
select region, category,
count(*) as numberof_rows,
sum(sales) as total_sales,
max(sales) as max_sales,
min(profit) as min_profit,
avg(profit) as avg_profit
from orders
group by region, category
order by region;

select region, category,
sum(sales) as total_sales
from orders
group by region, category;

--let's say we want to get output categorized in regions but we don't want category
select region, category,
sum(sales) as total_sales
from orders
group by region;
--this gives error since there can few columns with same region and they can be grouped but there cannot be same category in column
-----important interview question-----
select region, 
sum(sales) as total_sales
from orders
group by region;

--let's see order now(how code runs)
--Note - we are applying filter here i.e. 'where'
select region,
sum(sales) as total_sales
from orders
where profit>50
group by region
order by total_sales desc;
--from->where->group by->select->order by

--suppose we want to see sub category and total sales
select sub_category, 
sum(sales) as total_sales
from orders
group by sub_category
order by total_sales;
--now we wish to see total sales >10,0000
select sub_category, 
sum(sales) as total_sales
from orders
where total_sales>100000
group by sub_category
order by total_sales desc;
--this code doesn't work since total sales which is an aggregrate is not present in the table, only shown in the output
-----having-----
--without filter->10 rows
select sub_category, 
sum(sales) as total_sales
from orders
group by sub_category
having sum(sales)>100000
order by total_sales desc;
--from->group by->having->select->order by
--with filter->7 rows
select sub_category, 
sum(sales) as total_sales
from orders
where profit>50
group by sub_category
having sum(sales)>100000
order by total_sales desc;
--from->where->group by->having->select->order by

--having & where almost works the same, which one is better?
select sub_category, 
sum(sales) as total_sales
from orders
where sub_category = 'Phones'
group by sub_category
order by total_sales desc;

select sub_category,
sum(sales) as total_sales
from orders
group by sub_category
having sub_category = 'Phones'
order by total_sales;
--it is better to use 'where' since it is data filtering while 'having' is data aggregrating
-- for filtering purpose, use where
-- for aggregating purpose, use having

/*
select sub_category,
sum(sales) as total_sales
from orders
group by sub_category
having max(order_date) > '2020-01-01'
order by total_sales;

for the above code, we are supposed to find the output
let's give the input as
chairs, '2019-01-01', 100
chairs, '2019-10-10', 200
book case, '2019-01-01', 300
book case, '2020-10-10', 400

--for the time, let's make the code a little simple and understand the process
select sub_category, 
sum(sales) as total_sales, 
max(order_date)	
from orders
group by sub_category
--having max(order_date) > '2020-01-01'
order by total_sales;

--the output of this above code will
-> chairs, '2019-10-10', 300
-> book case, '2020-10-10', 700

select sub_category,
sum(sales) as total_sales
from orders
group by sub_category
having max(order_date) > '2020-01-01'
order by total_sales;

--the output of this above code will
-> book case, '2020-10-10', 700
*/

-----count-----
select count(*) as total_rows 
from orders;

select count(category) as total_rows 
from orders;

select count(distinct category) as total_rows 
from orders;

select count(distinct region) as total_rows 
from orders;

--we can use anything in place of  *
select count(distinct region) as region_rows,
count(1) as total_rows
from orders;

select count(distinct region) as region_rows,
count(1) as total_rows,
count(city) as total_city
from orders;
--count doesn't count 'null' values since we had put 2 city names as null

select count(distinct region) as region_rows,
count(1) as total_rows,
count(city) as total_city,
sum(sales) as total_sales
from orders;

--tricky question asked in interview
--Note-> aggregrate function ignore null value
/* for the following input, what will the output?
region, sales
'East',100
'East',null
'East',200

select region, avg(sales) as avg_sales
from orders
group by orders

output-> 150
--sum(sales)/count(sales)->300/2
*/

