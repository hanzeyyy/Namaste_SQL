-----advance update-----
select * from employee;
select * from dept;

--let's make back up of above table since we will be doing a lot of modifications 
select * into employee_back from employee;
select * into dept_back from dept;

select * from employee_back;
select * from dept_back;


--let's say we want to increase the salary of HR department by 1%
update employee_back
set salary = salary * 1.1
where dept_id in (select dep_id from dept_back where dep_name = 'HR');

select * from employee_back;


--let's say we want to see the department name in employee_back table
--so, first we need to create a new column named as dep_name
alter table employee_back
add dep_name varchar(15);

select * from employee_back;


update employee_back
set dep_name = d.dep_name
from employee_back e
inner join dept_back d on e.dept_id = d.dep_id;

select * from employee_back;


--let's say, we want to increase the salary of 'Analytics' deparmtment by 20%
update employee_back
set salary = salary * 1.2
from employee_back e
inner join dept_back d on e.dept_id = d.dep_id
where d.dep_name = 'Analytics';

select * from employee_back;

--let's create a duplicate of dep_id in dept_back table
select * from dept_back;
insert into dept_back values (100, 'Marketing');

select * from dept_back;

update employee_back
set dep_name = d.dep_name
from employee_back e
inner join dept_back d on e.dept_id = d.dep_id;

select * from employee_back;


-----advance delete-----
--let's sa we want to delete that dept_id in employee_back table which is not present in dept_back table
select * from employee_back;

delete from employee_back 
where dept_id not in (select dep_id from dept_back);

select * from employee_back;


--suppose we want to delete all the employee name from HR department
delete employee_back
from employee_back e
inner join dept_back d on e.dept_id = d.dep_id
where d.dep_name = 'HR';

select * from employee_back;


-----exist/not exist clause-----
--exits always returns either true or false
--used in where fitler
select * from employee;
select * from dept_back;

select * from employee e
where exists ( select 1 from dept_back d where e.dept_id = d.dep_id);
--dept_id = 700 not there since it is false

select * from employee e
where not exists ( select 1 from dept_back d where e.dept_id = d.dep_id);
--dept_id = 700 is only there since it is true


---Data Definition Language---
--create, drop, alter etc

--Data Manipulation Language
--insert, update, delete etc

--Data Query Language
--select 

--Data Control Language
--grant and revoke

--to give access to guest user on any table
grant select on employee to guest;
--guest user can use select statement in employee table 


grant select, insert on employee to guest;
--guest user can use select and insert statement in employee table 


grant select, insert, create table, update on employee to public;
--public user's can use select, insert, create table, and update statement in employee table


grant select on schema::dbo to public;
--public user's can use select statement in all tables


revoke select on employee from guest;
--revoke select statemet access from guest


create role role_sales
grant select on employee to role_sales;

alter role role_sales
add member guest;


--suppose we can given grant to one user and he wants to grant it to anothe user
grant select on employee to guest with grant option;


--Transaction control Language
--commit and rollback
--applicable to DML
--insert, update, delete
begin tran d
update employee 
set salary = 20000
where emp_id = 1;
commit tran d;

select * from employee
--once's committed, we cannot change 

begin tran d
update employee 
set salary = 25000
where emp_id = 1;
rollback tran d;

select * from employee
--NOTE: the salary of employee with emp_id = 1 is still 20000


update employee
set salary = 60000
where emp_id = 1;
rollback;

select * from employee;


-----pivot and unpivot-----
--pivot means converting rows into columns 
--unpivot means converting columns into rows

