create table call_start_logs
(
phone_number varchar(10),
start_time datetime
);
insert into call_start_logs values
('PN1','2022-01-01 10:20:00'),('PN1','2022-01-01 16:25:00'),('PN2','2022-01-01 12:30:00')
,('PN3','2022-01-02 10:00:00'),('PN3','2022-01-02 12:30:00'),('PN3','2022-01-03 09:20:00')
create table call_end_logs
(
phone_number varchar(10),
end_time datetime
);
insert into call_end_logs values
('PN1','2022-01-01 10:45:00'),('PN1','2022-01-01 17:05:00'),('PN2','2022-01-01 12:55:00')
,('PN3','2022-01-02 10:20:00'),('PN3','2022-01-02 12:50:00'),('PN3','2022-01-03 09:40:00')
;
/*
write a query to get start time and end time of each call from above 2 tables.
Also create a column of call duration in minutes.  
Please do take into account that there will be multiple calls from one phone number 
and each entry in start table has a corresponding entry in end table.
*/

select * from call_start_logs;
select * from call_end_logs;

--let's add row number which will help us to join the two tables according to start time and end time
select *,
row_number() over(partition by phone_number order by start_time) as rk
from call_start_logs;

select *,
row_number() over(partition by phone_number order by end_time) as rk
from call_end_logs;

--let's create a CTE and join both the tables
select s.*, e.end_time,
datediff(minute, s.start_time, e.end_time) as duration
from 
	(select *,
	row_number() over(partition by phone_number order by start_time) as rn
	from call_start_logs) s
	inner join 
	(select *,
	row_number() over(partition by phone_number order by end_time) as rn
	from call_end_logs) e
on s.phone_number = e.phone_number and s.rn = e.rn;

-----Aggregation with window functions-----
select * from employee

select *,
avg(salary) over(partition by dept_id) as dept_avg_sal
from employee;
--for aggregation, we don't need to give 'order by' in windows function

select *,
avg(salary) over(partition by dept_id) as dept_avg_sal,
max(salary) over(partition by dept_id) as dept_max_sal,
min(salary) over(partition by dept_id) as dept_min_sal,
count(salary) over(partition by dept_id) as dept_count_sal
from employee;


--let's see what will happen when we use 'order by' in aggregation
select *,
sum(salary) over(partition by dept_id) as sum_of_salary,
sum(salary) over(partition by dept_id order by emp_age asc) as running_sum_of_salary_age_wise,
sum(salary) over(order by emp_age) as running_sum_of_salary_age_wise_without_partition
from employee;


select *,
max(salary) over(partition by dept_id) as max_of_salary,
max(salary) over(partition by dept_id order by emp_age asc) as running_max_of_salary_age_wise,
max(salary) over(order by emp_age) as running_max_of_salary_age_wise_without_partition
from employee;


select *,
max(salary) over(partition by dept_id) as max_of_salary,
max(salary) over(order by salary) as running_max_of_salary_asc,
max(salary) over(order by salary desc) as running_max_of_salary_desc
from employee;


select *,
sum(salary) over(order by salary asc) as running_sum_salary,
sum(salary) over(order by salary desc) as running_sum_salary
from employee;
--aggregate functions aggregates same/duplicate values and shows it as a single value
--to deal with this, add more column so that aggregate function uniquley identifies values


select *,
sum(salary) over(order by salary, emp_id asc) as running_sum_salary,
sum(salary) over(order by salary, emp_id desc) as running_sum_salary
from employee;


select *,
sum(salary) over(order by emp_id) as running_sum_salary
from employee;


select *,
sum(salary) over(partition by dept_id order by emp_id) as running_sum_salary
from employee;


select *,
avg(salary) over(order by emp_id) as running_avg_salary
from employee;


select *,
avg(salary) over(partition by dept_id order by emp_id) as running_avg_salary
from employee;


select *,
count(salary) over(order by emp_id) as running_count_salary
from employee;


select *,
count(salary) over(partition by dept_id order by emp_id) as running_count_salary
from employee;
--similarly for max and min


---rolling sum/count-----
---rows between preceding, current and following row---
select *,
count(salary) over(order by emp_id rows between 2 preceding and current row) as rolling_count_salary
from employee;


select *,
count(salary) over(partition by dept_id order by emp_id rows between 2 preceding and current row) as rolling_count_salary
from employee;


select *,
sum(salary) over(order by emp_id rows between 2 preceding and current row) as rolling_sum_salary
from employee;


select *,
sum(salary) over(partition by dept_id order by emp_id rows between 2 preceding and current row) as rolling_sum_salary
from employee;


select *,
sum(salary) over(order by emp_id rows between 1 preceding and 1 following) as rolling_sum_salary
from employee;


select *,
sum(salary) over(partition by dept_id order by emp_id rows between 1 preceding and 1 following) as rolling_sum_salary
from employee;


--unbounded -> all the previous rows
select *,
sum(salary) over(order by emp_id rows between unbounded preceding and current row) as rolling_sum_salary
from employee;


select *,
sum(salary) over(partition by dept_id order by emp_id rows between unbounded preceding and current row) as rolling_sum_salary
from employee;


select *,
sum(salary) over(order by emp_id rows between unbounded preceding and unbounded following) as total_salary
from employee;


select *,
sum(salary) over(partition by dept_id order by emp_id rows between unbounded preceding and unbounded following) as rolling_sum_salary
from employee;


---first_value and last_value---
--first_value(column name) -> gives the value of first row
--last_value(column name) -> gives the value of last row in running row (not the value of last/bottom row)
select *,
first_value(salary) over(order by salary) as first_salary,
last_value(salary) over(order by salary) as last_salary
from employee;


--to get last value of the table, use unbounded following 
select *,
first_value(salary) over(order by salary) as first_salary,
last_value(salary) over(order by salary rows between current row and unbounded following) as last_salary
from employee;


--alternative of getting last_value is to use first_value in desc order format
select *,
first_value(salary) over(order by salary) as first_salary,
first_value(salary) over(order by salary desc) as last_salary
from employee;


select order_id, sales,
sum(sales) over(order by order_id)as running_sales
from orders;
--since there are duplicates in order_id column, we get agrregated sum 


--to solve this issue, we can use unbounded preceeding 
select order_id, sales,
sum(sales) over(order by order_id rows between unbounded preceding and current row)as running_sales
from orders;


--alternatively, we can give 2 column name as mentioned above to deal with duplicates
select order_id, sales,
sum(sales) over(order by order_id, row_id)as running_sales
from orders;


select datepart(year, order_date) as year_order,
datepart(month, order_date) as month_order,
sum(sales) as total_sales
from orders
group by datepart(year, order_date), datepart(month, order_date)
order by year_order, month_order;


--let's create a CTE 
with month_wise_sales as
	(select datepart(year, order_date) as year_order,
	datepart(month, order_date) as month_order,
	sum(sales) as total_sales
	from orders
	group by datepart(year, order_date), datepart(month, order_date)) 
select year_order, month_order, total_sales,
sum(total_sales) over(order by year_order, month_order rows between 2 preceding and current row) as rolling_3_sales
from month_wise_sales


