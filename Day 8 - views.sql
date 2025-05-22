--select * from orders;
-------views-------
--it copies the definition and (just) contains the physical structure but has no data stored 
create view orders_view as 
select * from orders;

--select * from orders_view;
--NamasteSQL->Views->dbo.orders_views->Script view as->create to->copy to clipboard
--this gives the following result below

/*
USE [NamasteSQL]
GO

/****** Object:  View [dbo].[orders_view]    Script Date: 11-12-2024 23:02:52 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

create view [dbo].[orders_view] as 
select * from orders;
GO
*/

--what is the advantge of views?
--1. we can temporarily store the data and share it with anyone to see the result
create view orders_summary_view  as
select 'category' as hierarchy_type, category as hierarchy_name,
sum( case  when region = 'West' then sales end) as total_sales_in_west_region,
sum( case  when region = 'East' then sales end) as total_sales_in_east_region
from orders
group by category
union all
select 'sub_category' as hierarchy_type, sub_category as hierarchy_name,
sum( case  when region = 'West' then sales end) as total_sales_in_west_region,
sum( case  when region = 'East' then sales end) as total_sales_in_east_region
from orders
group by sub_category
union all
select 'ship_mode' as hierarchy_type, ship_mode as hierarchy_name,
sum(case  when region = 'West' then sales end) as total_sales_in_west_region,
sum(case  when region = 'East' then sales end) as total_sales_in_east_region
from orders
group by ship_mode;

select * from orders_summary_view;

--we can change the view, drop it and change it

--we can make view from another database as well
create view emp_master as 
select * from master.dbo.employee;

select * from master.dbo.employee;

-------constraint-------
-----referential integrity constraint-----
--references (column name)
select * from employee;
select * from dept;
--in order to use referential integrity constraint, the column name should be set as primary key (not null as well)
alter table dept alter column dep_id int not null;
alter table dept add constraint primary_key primary key (dep_id);

--let's create another table to finally use referential integrity constraint
create table emp
(
	emp_id int,
	emp_name varchar(10),
	dept_id int references dept(dep_id) --foreign key
)

insert into emp values (1, 'Hanzala', 100);

select * from emp;
select * from dept;

insert into dept values (500, 'Operations');
insert into emp values (1, 'Hanzeyyy', 500);

select * from emp;
select * from dept;

-----identity-----
--identity(starting value, incrementing value)
create table dept1
(
	id int identity(1,1),
	dep_id int,
	dep_name varchar(10)
)

insert into dept1(dep_id, dep_name) values (100, 'HR');
insert into dept1(dep_id, dep_name) values (200, 'Analytics');
insert into dept1 values (300, 'IT'); --still works
select * from dept1;

-----foreign key------
-- 
