select * from employee; -- 10 records
select * from dept; -- 4 records

--in empoloyee table, manager_id tells us that who is the manager of which employee from emp_id
--let's say, we want to see the manager of each employee
--important interview question
-------self join-----
--joining  table with itself
--Note: there is no such thing as self join, we use inner,left,rigth or full outer join only
select emp1.emp_id, emp1.emp_name, emp1.manager_id,
emp2.emp_name as manager_name
from employee emp1
inner join employee emp2 on emp1.manager_id = emp2.emp_id
order by emp1.emp_id;

--we want to see which employee's salary is more than his manager salary
select e1.emp_name, e1.emp_id, e1.manager_id, 
e2.emp_name as manager_name, 
e1.salary as emp_salary, 
e2.salary as manager_salary
from employee e1
inner join employee e2 on e1.manager_id= e2.emp_id
where e1.salary>e2.salary;

select * from employee
--let's say we want to see the average salary using dept_id
select dept_id,
avg(salary) as avg_salary
from employee
group by dept_id;
--4 records

--we want to print all the employee name of a dept in below format
/*
dept_id, list_of_employee
100, Ankit, Mohit, Vikas, Rohit
200, Mudit, Agam, Sanjay, Ashish
300, Mukesh
500, Ramesh
*/
-----String Aggregrate-----
--string_agg(column name, 'how it must be seperated')
select dept_id,
string_agg(emp_name,',') as list_of_employee
from employee
group by dept_id;

-----within group(order by column name)------
--if we want to sort the aggregated string data then we need to use within group command in sql server
--order by emp_name
select dept_id,
string_agg(emp_name,',') within group (order by emp_name) as list_of_employee
from employee
group by dept_id;
--we can use salary, employee age etc as per requirement
--order by salary
select dept_id,
string_agg(emp_name,',') within group (order by salary) as list_of_employee
from employee
group by dept_id;

select * from orders;
-------date function-----
select order_id, order_date 
from orders;

---datepart(format,column name)---
--tells us part of date of our choice
select order_id, order_date,
datepart(year, order_date) as year_of_order
from orders;

--what if we want to see order_date in the year 2020 only
select order_id, order_date,
datepart(year, order_date) as year_of_order
from orders
where datepart(year, order_date) = 2020;

--likewise we can see month, week etc
select order_id, order_date,
datepart(year, order_date) as year_of_order,
datepart(month, order_date) as month_of_order,
datepart(week, order_date) as week_of_order
from orders
where datepart(year, order_date) = 2020;
 
---datename---
--datename(format, column name)
select order_id, order_date,
datepart(year, order_date) as year_of_order,
datepart(month, order_date) as month_of_order,
datepart(week, order_date) as week_of_order,
datename(month, order_date) as month_name,
datename(weekday, order_date) as weekday_name
from orders
where datepart(year, order_date) = 2020
order by order_date;

select order_id, order_date
from orders;
--let's say we want to add/subtract something
---dateadd---
--dateadd(type, how many, column name)
--helps us to add to a particular column
select order_id, order_date,
dateadd(day, 5, order_date) as order_date_5
from orders;

select order_id, order_date,
dateadd(day, 5, order_date) as order_date_day_5,
dateadd(week, 5, order_date) as order_date_week_5
from orders;


select order_id, order_date,
dateadd(day, 5, order_date) as order_date_day_5,
dateadd(day, -5, order_date) as order_date_day_5_minus,
dateadd(week, 5, order_date) as order_date_week_5,
dateadd(week, -5, order_date) as order_date_week_5_minus
from orders;


select order_id, order_date, ship_date
from orders;
---datediff---
--datediff(format, column name1, column name2)
--tells us difference between 2 dates
select order_id, order_date, ship_date,
datediff(day, order_date, ship_date) as date_diff_days
from orders;

select order_id, order_date, ship_date,
datediff(day, order_date, ship_date) as date_diff_days,
datediff(week, order_date, ship_date) as date_diff_weeks
from orders;

select order_id, order_date, ship_date,
datediff(day, order_date, ship_date) as date_diff_days,
datediff(week, order_date, ship_date) as date_diff_weeks,
datediff(month, order_date, ship_date) as date_diff_months
from orders;

select order_id, order_date, ship_date,
datediff(day, order_date, ship_date) as date_diff_days,
datediff(week, order_date, ship_date) as date_diff_weeks,
datediff(month, order_date, ship_date) as date_diff_months,
datediff(year, order_date, ship_date) as date_diff_years
from orders;

/* in c++, we have studied if else condition
if profit < 100 then 'low profit' elseif profit > 200 then 'profit' else end */
-------case when then end-------
select order_id, profit 
from orders;

select order_id, profit,
case 
when profit < 100 then 'Low Profit'
when profit < 250 then 'Medium Profit'
when profit < 400 then 'High Profit'
else 'Very High Profit'
end as profit_category
from orders;
--case statement: order of execution is top to bottom

--if we change the order
select order_id, profit,
case 
when profit < 250 then 'Medium Profit'
when profit < 100 then 'Low Profit'
when profit < 400 then 'High Profit'
else 'Very High Profit'
end as profit_category
from orders;
--then there will be no 'low profit' case

--for better understanding
select order_id, profit,
case 
when profit < 100 then 'Low Profit'
when profit >= 100 and profit < 250 then 'Medium Profit'
when profit >= 250 and profit < 400 then 'High Profit'
else 'Very High Profit'
end as profit_category
from orders;

select order_id, profit,
case 
when profit >= 100 and profit < 250 then 'Medium Profit'
when profit < 100 then 'Low Profit'
when profit >= 250 and profit < 400 then 'High Profit'
else 'Very High Profit'
end as profit_category
from orders;
--in this code, the condition is well defined. so, we can ignore the order of execution


select order_id, profit,
case 
when profit < 0 then 'Loss'
when profit >= 0 and profit < 100 then 'Low Profit'
when profit >= 100 and profit < 250 then 'Medium Profit'
when profit >= 250 and profit < 400 then 'High Profit'
else 'Very High Profit'
end as profit_category
from orders
order by profit;

	
