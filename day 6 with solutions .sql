alter table employee add dob date;
update employee set dob = dateadd(year,-1*emp_age,getdate());

select * from employee;
-- write a query to print emp name , their manager name and difference in their age (in days) 
	-- for employees whose year of birth is before their managers year of birth
select e1.emp_name, e2.emp_name as manager_name, datediff(day, e1.dob, e2.dob) as age_difference
from employee e1
inner join employee e2 on e1.manager_id = e2.emp_id
where e1.emp_age > e2.emp_age;


select * from orders;
select * from returns;
-- write a query to find subcategories who never had any return orders in the month of november (irrespective of years)
select  o.sub_category
from orders o
left join returns r on o.order_id = r.order_Id
where datepart(month, order_date) = 11 
group by o.sub_category
having count(r.order_id) = 0; 

select * from orders;
-- orders table can have multiple rows for a particular order_id when customers buys more than 1 product in an order.
	-- write a query to find order ids where there is only 1 product bought by the customer.
select order_id
from orders 
group by order_id
having count(1) = 1;


select * from employee;
-- write a query to print manager names along with the comma separated list(order by emp salary) of all employees directly reporting to him.
select e2.emp_name as manager_name, 
string_agg(e1.emp_name, ', ') within group (order by e1.salary) as list_of_emp
from employee e1
join employee e2 on e1.manager_id = e2.emp_id
group by e2.emp_name;


select * from orders;
-- write a query to get number of business days between order_date and ship_date (exclude weekends). 
	-- Assume that all order date and ship date are on weekdays only
select order_date, ship_date,
datediff(day, order_date, ship_date) - 2*datediff(week, order_date, ship_date) as business_days
from orders
order by business_days;


-- write a query to print 3 columns : category, total_sales and (total sales of returned orders)
select o.category,
sum(o.sales) as total_sales, 
sum(case when r.return_reason is not null then sales end) as total_sales_of_returned_ordes
from orders o
left join returns r on o.order_id = r.order_id
group by o.category;


select * from orders;
-- write a query to print below 3 columns
	-- category, total_sales_2019(sales in year 2019), total_sales_2020(sales in year 2020)
select category,
sum (case when datepart(year, order_date) = 2019 then sales end ) as sales_in_2019,
sum (case when datepart(year, order_date) = 2020 then sales end ) as sales_in_2020
from orders
group by category;


-- write a query print top 5 cities in west region by average no of days between order date and ship date.
select top 5 city,
avg(datediff(day, order_date, ship_date)) as avg_days
from orders
where region = 'West'
group by city;


select * from employee;
-- write a query to print emp name, manager name and senior manager name (senior manager is manager's manager)
select e1.emp_name, e2.emp_name as manager_name, e3.emp_name as managers_manager 
from employee e1
join employee e2 on e1.manager_id = e2.emp_id
join employee e3 on e2.manager_id = e3.emp_id;
