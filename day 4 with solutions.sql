select * from orders;
-- write a update statement to update city as null for order ids :  CA-2020-161389 , US-2021-156909
update orders
set city = null 
where order_id in ('CA-2020-161389' , 'US-2021-156909');

select * from orders;
-- write a query to find orders where city is null (2 rows)
select * from orders
where city is null;

select * from orders;
-- write a query to get total profit, first order date and latest order date for each category
select category,
sum(profit) as total_profit,
min(order_date) as first_order_date,
max(order_date) as latest_order_date
from orders
group by category;

select * from orders;
-- write a query to find sub-categories where average profit is more than the half of the max profit in that sub-category
select sub_category,
avg(profit) as avg_profit,
max(profit) as max_profit
from orders
group by sub_category 
having avg(profit) > 0.1*max(profit);

--create the exams table with below script;
/*
create table exams 
(
	student_id int, 
	subject varchar(20), 
	marks int
);
insert into exams values (1,'Chemistry',91),(1,'Physics',91),(1,'Maths',92)
,(2,'Chemistry',80),(2,'Physics',90)
,(3,'Chemistry',80),(3,'Maths',80)
,(4,'Chemistry',71),(4,'Physics',54)
,(5,'Chemistry',79);
*/
select * from exams;
--write a query to find students who have got same marks in Physics and Chemistry.
select count(distinct student_id)
from exams
where subject in ('Physics','Chemistry')
having count(marks)=1;

select student_id,
count(*) as total_records,
count(distinct marks) as distinct_marks
from exams
where subject in ('Physics' , 'Chemistry')
group by student_id
having count(*) = 2 and count(distinct marks) = 1;


select * from orders;
-- write a query to find total number of products in each category.
select category,
count(distinct sub_category) as total_product
from orders
group by category
order by category;

select * from orders;
-- write a query to find top 5 sub categories in west region by total quantity sold
select top 5 sub_category, 
sum(quantity) as total_quantity
from orders
where region ='West'
group by sub_category
order by total_quantity desc;

select * from orders;
-- write a query to find total sales for each region and ship mode combination for orders in year 2020
select region, ship_mode,
sum(sales) as total_sales
from orders
group by region, ship_mode
order by region;
