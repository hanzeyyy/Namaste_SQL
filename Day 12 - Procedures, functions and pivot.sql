-----procedure and functions-----
--when we want to run multiple sql queries
create procedure spemp 
as
select * from employee;

--to view the precedure
exec spemp;


alter procedure spemp (@salary int)
as
select * from employee where salary > @salary;

exec spemp @salary = 10000;


alter procedure spemp (@salary int, @dept_id int)
as
select * from employee where salary > @salary and dept_id = @dept_id;

exec spemp @salary = 10000, @dept_id = 100;


alter procedure spemp (@salary int, @dept_id int)
as
select * from employee where salary > @salary and dept_id > @dept_id;

exec spemp 10000, 100;
--values are passed correspondingly


alter procedure spemp (@salary int, @dept_id int)
as
select * from employee where salary > @salary and dept_id > @dept_id
select * from dept;

exec spemp 10000, 100;
--without filter we get all the records from dept table


alter procedure spemp (@salary int, @dept_id int)
as
select * from employee where salary > @salary and dept_id > @dept_id
select * from dept where dep_id = @dept_id;

exec spemp 10000, 100;
--the parameters in the procedure must match with exec statement 


alter procedure spemp (@salary int, @dept_id1 int, @dept_id2 int)
as
select * from employee where salary > @salary and dept_id = @dept_id1
select * from dept where dep_id = @dept_id2;

exec spemp 10000, 100, 200;


--we can also use insert statement in procedure
alter procedure spemp (@salary int, @dept_id int)
as
insert into dept values (800,'HR1')
select * from employee where salary > @salary and dept_id = @dept_id
select * from dept where dep_id = @dept_id;

exec spemp 10000, 100;


--suppose we want to display some message after running the query
alter procedure spemp (@dept_id int)
as
	declare @cnt int
	select @cnt = count(1) from employee where dept_id = @dept_id
	if @cnt = 0
	print 'there is no employee in this dept'
;

exec spemp @dept_id = 900;


alter procedure spemp (@dept_id int)
as
	declare @cnt int
	select @cnt = count(1) from employee where dept_id = @dept_id
	if @cnt = 0
	print 'there is no employee in this dept'
	else
	print @cnt
;

exec spemp @dept_id = 200;
--there are 4 records


alter procedure spemp (@dept_id int)
as
	declare @cnt int
	select @cnt = count(1) from employee where dept_id = @dept_id
	if @cnt = 0
	print 'there is no employee in this dept'
	else
	print 'total employees ' + cast(@cnt as varchar(5))
;

exec spemp @dept_id = 200;

--or

alter procedure spemp (@dept_id int, @cnt int out)
as
	select @cnt = count(1) from employee where dept_id = @dept_id
	if @cnt = 0
	print 'there is no employee in this dept'
	else
	print 'total employees ' + cast(@cnt as varchar(5))
;

declare @cnt1 int
exec spemp 200, @cnt1 out
print @cnt1;


--there are many inbuilt functions in mysql server
--we can create manual functions as well
create function fnproduct (@a int, @b int)
returns integer
as 
begin
return (select @a * @b)
end

select [dbo].[fnproduct] (4,5) as product;

select datepart(year, order_date) as year_order,
order_date, row_id, quantity, 
[dbo].[fnproduct] (row_id, quantity) as product_of_2
from orders;

--similarly we can use decimal, float etc
alter function fnproduct (@a int, @b decimal(10,2))
returns decimal(10,2)
as 
begin
return (select @a * @b)
end

select [dbo].[fnproduct] (4,5.9) as product;

select datepart(year, order_date) as year_order,
order_date, row_id, quantity, 
[dbo].[fnproduct] (row_id, quantity) as product_of_2
from orders;


-----pivot and unpivot-----
select category,
sum(case when datepart(year, order_date) = 2020 then sales end) as sum_sales_2020,
sum(case when datepart(year, order_date) = 2021 then sales end) as sum_sales_2021
from orders
group by category;
--this is one way of doing pivot

select * from
	(select category, datepart(year, order_date) as year_order, sales
	from orders) as t1
pivot
	(sum(sales) for year_order in ([2020], [2021])) t2;
--we can use only 1 pivot

select * from
	(select category, region, sales
	from orders) as t1
pivot
	(sum(sales) for region in (East, West)) t2;


select * from
	(select category, region, sales
	from orders) as t1
pivot
	(sum(sales) for region in (East, West, South)) t2;
--we can use either count or sum aggregation


--we can store this table as a new table
select * into sales_year_wise from
	(select category, region, sales
	from orders) as t1
pivot
	(sum(sales) for region in (East, West, South)) t2;

select * from sales_year_wise;


select * into orders_back from orders;
--create a backup table with same records

select * from orders_back;

truncate table orders;
--deletes all records

select * from orders;

insert into orders select * from orders_back;
--transfers all the records back

select * from orders;
---commit and rollback---
--commit -> any modification wil be committed and cannot be rolledback
--rollback -> an update/modification can be rolledback
--both are DML
--truncate (DDL) cannot be rolled back
