select * from orders;

-----sub query-----
--1. find average order value
select avg(sales) as avg_order_value
from orders;
--average value is Rs 229.8

/* 
this value is wrong since each order can have multiple products which needs to be sumed and then taken in consideration for average
E.g. let's say
order_id  product_id  sales
1	      100		  500
1		  200		  700
2		  300		  600
average order = (500+700+600)/3 = 600
but this is wrong

order_id  product_id  sales
1	      100		  500
1		  200		  700
2		  300		  600
we need to add the sales value of product_id 100 & 200 since both comes under order_id 1
order_id    sales
1	        1200
2		    600
average order = (1200+600)/2 = 900 
this implies we need some intermediate result
*/

select order_id, 
sum(sales) as order_sales
from orders
group by order_id;
--this table shows us the aggregated values of each order
--we will this as a virtual table to find average
select avg(order_sales) as average_order_value from
(select order_id, 
sum(sales) as order_sales
from orders
group by order_id) as sales_aggregated;
--average value is Rs 458.6
--we see the average value is higher (by a difference of 228.2)

--2. find all the orders whose sales is more than average order value
/* 
order_id    sales
1	        1200
2		    600
average order = 900
output -> order_id 1 
*/
select order_id 
from orders
group by order_id
having sum(sales) > (select avg(order_sales) as average_order_value from
(select order_id,
sum(sales) as order_sales
from orders 
group by order_id) as sales_aggregated);

--let's check
select sales from orders
where order_id = 'CA-2018-100090';
--sum = 502.4 + 196.7 = 699.1 > 500'

select * from employee;
select * from dept;
update employee 
set dept_id = 700
where dept_id = 500;
select * from employee;

insert into employee values (11, 'Ramesh', 300, 8000, 6, 52, '1970-12-02');
select * from employee;

--we can use sub-query instead of joins
select * from employee
where dept_id not in (select dep_id from dept);
--we can say inner query inside close parentheis and outer query (main/outer) outside close parenthesis

select * from employee
where dept_id not in (100,200,300);
--we can give only one result from inner query
--we can not give multiple column name and multiple results in inner query

/* e.g.
select * from employee
where dept_id not in (select dep_id, dep_name from dept);
or
select * from employee
where dept_id > (select dep_id from dept);
*/

select * from employee
where dept_id not in (select min(dep_id) from dept);

select *, (select avg(salary) from employee) as avg_sales from employee;
--average salary is Rs 9000

select avg(salary) as avg_sales from employee 
where dept_id != 700;
--average salary is Rs 9200

select *, (select avg(salary) from employee) as avg_sales from employee
where dept_id in (select dep_id from dept);
--average salary is Rs 9000 coz (select avg(salary) from employee) is running first (inner query) 

--let's join two sub-queries with inner join
select A.*, B.* 
from 
(select order_id, sum(sales) as order_sales
from orders
group by order_id) as A
inner join 
(select avg(orders_aggregated.order_sales) as avg_value_order from 
(select order_id, sum(sales) as order_sales
from orders
group by order_id) as orders_aggregated ) as B
on 1=1;

select A.*, B.* 
from 
(select order_id, sum(sales) as order_sales
from orders
group by order_id) as A
inner join 
(select avg(orders_aggregated.order_sales) as avg_value_order from 
(select order_id, sum(sales) as order_sales
from orders
group by order_id) as orders_aggregated ) as B
on 1=1
where order_sales > avg_value_order;

select emp.*, dep.avg_dept_salary from employee emp
inner join
(select dept_id, avg(salary) as avg_dept_salary
from employee
group by dept_id) as dep
on emp.dept_id = dep.dept_id;

--instead of using dep.avg_dept_salary, if we use dep.* then gives us an additinal column in the output table as dept_id (which is unnecessory)
select emp.*, dep.* from employee emp
inner join
(select dept_id, avg(salary) as avg_dept_salary
from employee
group by dept_id) as dep
on emp.dept_id = dep.dept_id;

--Assignment discussion
select * from icc_world_cup;
/*
points table
team name		matches played		matches won		matches lost
India			2					2				0
Sri Lanka		2					0				2
South Africa	1					0				1
England			2					1				1
New zealand		1					1				0
Australia		2					1				1
*/

select team_name, 
count(1) as matches_played, 
sum(win_flag) as matches_won, 
count(1) - sum(win_flag) as matches_lost
from
(select team_1 as team_name, 
case when team_1 = winner then 1 else 0 end as win_flag
from icc_world_cup
union all --if we use union instead of union all then it might remove some duplicate
select team_2 as team_name, 
case when team_2 = winner then 1 else 0 end as win_flag
from icc_world_cup) A
group by team_name;

-------CTE-------
--CTEs -> Common Table Expression
--let's solve the above query using CTE
with A as
(select team_1 as team_name, 
case when team_1 = winner then 1 else 0 end as win_flag
from icc_world_cup
union all 
select team_2 as team_name, 
case when team_2 = winner then 1 else 0 end as win_flag
from icc_world_cup)
select team_name, 

count(1) as matches_played, 
sum(win_flag) as matches_won, 
count(1) - sum(win_flag) as matches_lost --final query
from 

A --cte A
group by team_name;

--let's see any example
select emp.*, dep.avg_dept_salary from employee emp
inner join
(select dept_id, avg(salary) as avg_dept_salary
from employee
group by dept_id) as dep
on emp.dept_id = dep.dept_id;

--let's solve this query using CTE
with dep as
(select dept_id, avg(salary) as avg_dept_salary
from employee
group by dept_id) 

select emp.*, dep.* from employee emp
inner join 

dep
on emp.dept_id = dep.dept_id;


/*
Advantage: 1. CTE is more structured (easy to read and understand) compared to using multiple sub-queries
sub-queries -> query0 ( query1 (query2) ) )
CTE -> query2
	   query1
	   query0
2. we can use one CTE in another cte keeping check on order
3. better performance
*/
--let's take another example
select A.*, B.* 
from 
(select order_id, sum(sales) as order_sales
from orders
group by order_id) as A
inner join 
(select avg(orders_aggregated.order_sales) as avg_value_order from 
(select order_id, sum(sales) as order_sales
from orders
group by order_id) as orders_aggregated) as B
on 1=1
where order_sales > avg_value_order;

--let's solve this query using CTE
with order_wise_sales as 
(select order_id, sum(sales) as order_sales
from orders
group by order_id)

select A.*, B.* 
from order_wise_sales A
inner join 
(select avg(orders_aggregated.order_sales) as avg_value_order 
from order_wise_sales as orders_aggregated) B
on 1=1
where order_sales > avg_value_order;

--let's do this query using multiple CTEs
with order_wise_sales as 
(select order_id, sum(sales) as order_sales
from orders
group by order_id),

B as (select avg(orders_aggregated.order_sales) as avg_value_order 
from order_wise_sales as orders_aggregated)

select A.*, B.* from order_wise_sales A
inner join B
on 1=1
where order_sales > avg_value_order;

--let's see another example
select *, (select avg(salary) from employee) as avg_sales from employee
where dept_id in (select dep_id from dept);

--this query is already simple sub-query if we use CTE then it's of no use (why complicate things)
with depts as (select dep_id from dept)
select * from employee
where dept_id in (select dep_id from depts);

with order_wise_sales as 
(select order_id, sum(sales) as order_sales
from orders
group by order_id),

B as (select avg(orders_aggregated.order_sales) as avg_value_order 
from order_wise_sales as orders_aggregated),

C as (select * from employee)

select A.*, B.* from order_wise_sales A
inner join B
on 1=1
where order_sales > avg_value_order;
--here C is not used in main query, so it is not executed as all
