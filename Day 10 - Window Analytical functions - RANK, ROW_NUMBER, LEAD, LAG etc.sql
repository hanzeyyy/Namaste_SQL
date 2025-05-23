-------windows functions-------
-----row_number()-----
--row_number is running number
select * from employee;

select *, 
row_number() over(order by salary desc) as rn
from employee;
--the employee with highest salary got row number 1
/*
emp_id	emp_name	dept_id	salary	manager_id	emp_age	dob			rn
2		Mohit		100		15000	5			48		1976-12-07	1
5		Mudit		200		12000	6			55		1969-12-07	2
6		Agam		200		12000	2			14		2010-12-07	3
3		Vikas		100		10000	4			37		1987-12-07	4
1		Ankit		100		10000	4			39		1985-12-07	5
7		Sanjay		200		9000	2			13		2011-12-07	6
11		Ramesh		300		8000	6			52		1970-12-02	7
10		Rakesh		700		7000	6			50		1974-12-07	8
9		Mukesh		300		6000	6			51		1973-12-07	9
4		Rohit		100		5000	2			16		2008-12-07	10
8		Ashish		200		5000	2			12		2012-12-07	11
*/

--now we wish to generate row number seperately for each department
select *,
row_number() over(partition by dept_id order by salary desc) as rn
from employee;
--partition makes diffferent windows for each department
--each dept will get new row number 
/*
emp_id	emp_name	dept_id	salary	manager_id	emp_age	dob			rn
2		Mohit		100		15000	5			48		1976-12-07	1
3		Vikas		100		10000	4			37		1987-12-07	2
1		Ankit		100		10000	4			39		1985-12-07	3
4		Rohit		100		5000	2			16		2008-12-07	4
5		Mudit		200		12000	6			55		1969-12-07	1
6		Agam		200		12000	2			14		2010-12-07	2
7		Sanjay		200		9000	2			13		2011-12-07	3
8		Ashish		200		5000	2			12		2012-12-07	4
11		Ramesh		300		8000	6			52		1970-12-02	1
9		Mukesh		300		6000	6			51		1973-12-07	2
10		Rakesh		700		7000	6			50		1974-12-07	1
*/

select *,
row_number() over(partition by dept_id order by salary desc, emp_name asc) as rn
from employee;
--first it is sorted by salary and then by employee name 

select *,
row_number() over(partition by dept_id) as rn
from employee;
--error -> The function 'row_number' must have an OVER clause with ORDER BY

--using sub-query
select * from 
(select *,
row_number() over(partition by dept_id order by salary desc, emp_name asc) as rn
from employee) as A
where rn<=2;

--using cte
with cte as 
(select *,
row_number() over(partition by dept_id order by salary desc, emp_name asc) as rn
from employee) 
select * from cte
where rn<=2;

-----rank()-----
--give ranks to rows, skip the same record and proceeds nexts
select *,
row_number() over(order by salary) as rn,
rank() over(order by salary) as rnk
from employee;
/*
emp_id	emp_name	dept_id	salary	manager_id	emp_age	dob			rn	rnk
4		Rohit		100		5000	2			16		2008-12-07	1	1
8		Ashish		200		5000	2			12		2012-12-07	2	1  --since both have the same salary
9		Mukesh		300		6000	6			51		1973-12-07	3	3  --skip 2
10		Rakesh		700		7000	6			50		1974-12-07	4	4
11		Ramesh		300		8000	6			52		1970-12-02	5	5
7		Sanjay		200		9000	2			13		2011-12-07	6	6
3		Vikas		100		10000	4			37		1987-12-07	7	7
1		Ankit		100		10000	4			39		1985-12-07	8	7
5		Mudit		200		12000	6			55		1969-12-07	9	9
6		Agam		200		12000	2			14		2010-12-07	10	9
2		Mohit		100		15000	5			48		1976-12-07	11	11
*/

select *,
row_number() over(partition by dept_id order by salary desc) as rn,
rank() over(partition by dept_id order by salary desc) as rnk
from employee;
/*
emp_id	emp_name	dept_id	salary	manager_id	emp_age	dob			rn	rnk
2		Mohit		100		15000	5			48		1976-12-07	1	1
3		Vikas		100		10000	4			37		1987-12-07	2	2	--since it has same salary
1		Ankit		100		10000	4			39		1985-12-07	3	2
4		Rohit		100		5000	2			16		2008-12-07	4	4
5		Mudit		200		12000	6			55		1969-12-07	1	1
6		Agam		200		12000	2			14		2010-12-07	2	1
7		Sanjay		200		9000	2			13		2011-12-07	3	3
8		Ashish		200		5000	2			12		2012-12-07	4	4
11		Ramesh		300		8000	6			52		1970-12-02	1	1
9		Mukesh		300		6000	6			51		1973-12-07	2	2
10		Rakesh		700		7000	6			50		1974-12-07	1	1
*/

select *,
row_number() over(partition by dept_id order by salary desc) as rn,
rank() over(partition by dept_id order by salary desc) as rnk,
row_number() over(partition by dept_id, salary order by salary desc) as rn2 --this query runs first and then others
from employee;
--combintion of (dept_id, salary) is one window now

select *,
row_number() over(partition by dept_id order by salary desc) as rn,
rank() over(partition by dept_id order by salary desc) as rnk,
row_number() over(partition by dept_id, salary order by salary desc) as rn2, 
rank() over(partition by dept_id, salary order by salary desc) as rnk2
from employee;

-----dense_rank()-----
--similar to rank but doesn't skip anything
select *,
row_number() over(order by salary desc) as rn,
rank() over(order by salary desc) as rnk,
dense_rank() over(order by salary desc) as d_rnk
from employee;


select *,
row_number() over(partition by dept_id order by salary desc) as rn,
rank() over(order by salary desc) as rnk,
dense_rank() over(order by salary desc) as d_rnk
from employee;


select *,
row_number() over(partition by dept_id order by salary desc) as rn,
rank() over(partition by dept_id order by salary desc) as rnk,
dense_rank() over(order by salary desc) as d_rnk
from employee;


select *,
row_number() over(partition by dept_id order by salary desc) as rn,
rank() over(partition by dept_id order by salary desc) as rnk,
dense_rank() over(partition by dept_id order by salary desc) as d_rnk
from employee;

/*
	 row_number	rank	dense_rank
100  1			1		1	
100	 2			1		2
200	 3			3		3
300	 4			4		4
*/

select * from orders;
--write a query to print top 5 selling product from each category print
select *,
rank() over (partition by category order by sales desc) as nk
from orders;
--this qucery is wrong because rank windows function added do sum of sales

with cte_product_sales as 
(select category, product_id,
sum(sales) as category_sales
from orders
group by category, product_id) 
select *,
rank() over(partition by category order by category_sales desc) as rk
from cte_product_sales;
--this shows for all the records but we want for only 5

with cte_product_sales as 
(select category, product_id,
sum(sales) as category_sales
from orders
group by category, product_id),

rnk_sales as 
(select *,
rank() over(partition by category order by category_sales desc) as rnk
from cte_product_sales)

select * from rnk_sales
where rnk<=5;


with rnk_sales as
(select category, product_id,
rank() over(partition by category order by sum(sales) desc) as rnk		
from orders
group by category, product_id)

select * from rnk_sales
where rnk<=5;


-----lead(column name, number, default)-----
--lead column by a number 
select *,
lead(emp_id, 1) over (order by salary desc) as lead_emp
from employee;
--the lead to next emp_id is 5 or the next record lead to next emp_id with 5

select *,
lead(salary, 2) over (order by salary desc) as lead_sal
from employee;

select *,
lead(salary, 2, 5000) over (order by salary desc) as lead_sal
from employee;
--5000 is default value

select *,
lead(salary, 2, salary) over (order by salary desc) as lead_sal
from employee;
--salary is default value (can put anything)

select *,
lead(salary, 1) over(partition by dept_id order by salary desc) as lead_sal
from employee;

-----lag()-----
--
select *,
lag(salary, 1) over (order by salary desc) as lag_sal
from employee;

select *,
lag(salary, 1) over (partition by dept_id order by salary desc) as lag_sal
from employee;

select *,
lead(salary, 1) over (partition by dept_id order by salary asc) as lead_sal,
lag(salary, 1) over (partition by dept_id order by salary desc) as lag_sal
from employee;

-----first_value(column name)-----
--assign the first value of the row to rest of the rows
select *,
first_value(salary) over (partition by dept_id order by salary desc) as first_sal
--last_value(salary) over (partition by dept_id order by salary desc) as last_sal
from employee;
