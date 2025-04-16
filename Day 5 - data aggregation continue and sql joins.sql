--------Database joins-------
select * from returns; --296 records
select * from orders; --9994 records

--we want to join 'order' table and 'returns' table together
-----inner join-----
--inner joins connect the common records present in the tables
select o.order_id, r.return_reason
from orders o
inner join returns r on o.order_id = r.order_id;
--800 records

--what I did is that I changed the column name and then imported again / simply remane the file from database
--note: sir has already given the code in day 2 material, we can simply run that code 
--someone during the lecture said to go to edit->intellisense->refresh local cache
--we did the above step since it was showing us some warning
--SQL Aliase -> SQL aliases are used to give a table, or a column in a table, a temporary name (orders o, returns r)
--Aliases are often used to make column names more readable.

--let's add order_date column as well
select o.order_id, o.order_date, r.return_reason
from orders o
inner join returns r on o.order_id = r.order_id;
--the above code has joined 'orders' & 'return' table
--return table has 296 rows & orders table has 9,994 rows
--after joining both tables, we get 800 rows
--if we see distinct rows in the joined table, we will get 296 rows
select distinct o.order_id, r.return_reason
from orders o
inner join returns r on o.order_id = r.order_id;

--if we simply write order_id, return_reason, then sql is confused as two table have a common column
--to clear this confusion, write o.order_id i.e. order.order_id &  r.return_reason i.e. return_return_reason
--again we are not using order.order_id as the name becomes too long

--if we want to see all the tables
select * 
from orders o 
inner join returns r on o.order_id = r.order_id
order by row_id;

--what if we just want to see joined columns from order table
select o.* 
from orders o
inner join returns r on o.order_id = r.order_id
order by row_id;

--what if we just want to see joined columns from returns table
select r.* 
from orders o
inner join returns r on o.order_id = r.order_id
order by row_id;

--what if we want order id from order table and return reason from return table
select o.order_id, r.return_reason
from orders o
inner join returns r on o.order_id = r.order_id
order by  row_id;

--if we write 
select o.*, return_reason
from orders o
inner join returns r on o.order_id = r.order_id
order by row_id;
--then also our code works since return reason column is not present in order table

--it is always a good practice to use aliase since it helps to keep track from which table a column is coming from 
select  o.order_id, r.return_reason
from orders o 
inner join returns r on o.order_id = r.order_id;

--so far we are seeing joined table for only return reason 
--what if we want to see all the orders which have been returned and not returned
-----left join------
--left join means all the records of left table (here order table) is joined to right table
select o.order_id, r.return_reason
from orders o
left join returns r on o.order_id = r.order_id;
--this code shows us 9994 rows

--along with this we want to see order id from returs table as well
select o.order_id, r.return_reason, 
r.order_id as return_order_id
from orders o
left join returns r on o.order_id = r.order_id;

--since order id can be identical, let's add product id also
select o.order_id, o.product_id, r.return_reason, 
r.order_id as return_order_id 
from orders o 
left join returns r on o.order_id  = r.order_id;

--common interview question
--we want all rows where order has not been returned
select o.order_id, product_id, r.return_reason, 
r.order_id as return_order_id
from orders o 
left join returns r on o.order_id = r.order_id
where r.order_id is null; --or we can use r.return_reason
--order of execution: from->join->where->select	 

--we want to check how much sales we made 
select r.return_reason, 
sum(sales) as total_sales
from orders o
left join returns r on o.order_id = r.order_id
group by r.return_reason;

--we can also check the profit made
select r.return_reason, 
sum(sales) as total_sales, 
sum(profit) as total_profit
from orders o
left join returns r on o.order_id = r.order_id
group by r.return_reason
order by r.return_reason;

--if we use inner join instead of left join, we will not get null row
select r.return_reason, 
sum(sales) as total_sales, 
sum(profit) as total_profit
from orders o
inner join returns r on o.order_id = r.order_id
group by r.return_reason
order by r.return_reason;

--NOTE: if only 'join' is mentioned then by default it is inner join

--drop table employee;
create table employee(
    emp_id int,
    emp_name varchar(20),
    dept_id int,
    salary int,
    manager_id int,
    emp_age int
);


insert into employee values(1,'Ankit',100,10000,4,39);
insert into employee values(2,'Mohit',100,15000,5,48);
insert into employee values(3,'Vikas',100,10000,4,37);
insert into employee values(4,'Rohit',100,5000,2,16);
insert into employee values(5,'Mudit',200,12000,6,55);
insert into employee values(6,'Agam',200,12000,2,14);
insert into employee values(7,'Sanjay',200,9000,2,13);
insert into employee values(8,'Ashish',200,5000,2,12);
insert into employee values(9,'Mukesh',300,6000,6,51);
insert into employee values(10,'Rakesh',500,7000,6,50);

--drop table dept;
create table dept(
    dep_id int,
    dep_name varchar(20)
);
insert into dept values(100,'Analytics');
insert into dept values(200,'IT');
insert into dept values(300,'HR');
insert into dept values(400,'Text Analytics');

select * from employee;
select * from dept;

-----cross join-----
--if we don't give my condition, then each record of one table gets joined to every other record of another table
select * 
from employee, 
dept
order by employee.emp_id;

--1=1 is not a condition (it is just something which is always true) 
select * 
from employee
inner join dept on 1=1
order by employee.emp_id;
--40 records

--inner join 
select * from employee;
select * from dept;
--in this two tables, dep_id is a common column/record
--we will join employee & dept using dept_id
select * from employee e
inner  join dept d on e.dept_id = d.dep_id;  

--we need only four columns/records to do our analysis
select e.emp_id, e.emp_name, e.dept_id, d.dep_name
from employee e
inner join dept d on e.dept_id = d.dep_id;
--when we are using inner join, emp_id 10 is being excluded since it isn't matching witbh the applied condition

--but we want to see every employee record (use left join)
select e.emp_id, e.emp_name, e.dept_id, d.dep_name
from employee e
left join dept d on e.dept_id = d.dep_id;

-----right join-----
--right join right left table (here dept table)
select e.emp_id, e.emp_name, e.dept_id, d.dep_name
from employee e
right join dept d on e.dept_id = d.dep_id;

--we can simply interchange table name instead of using right join  
select e.emp_id, e.emp_name, e.dept_id, d.dep_name
from dept d
left join employee e on e.dept_id = d.dep_id;

select e.emp_id, e.emp_name, e.dept_id, d.dep_id, d.dep_name
from dept d
left join employee e on e.dept_id = d.dep_id;
--we are not getting 500 dept_id record since it is not present in the dept table

-----full outer join-----
--select everything present in both the tables irrespective of provided condition
select e.emp_id, e.emp_name, e.dept_id, d.dep_name
from employee e
full outer join dept d on e.dept_id = d.dep_id;
--here we get 11 rows which includes dept_id 300 & dept_id 500 aslo

select e.emp_id, e.emp_name, e.dept_id, d.dep_id, d.dep_name
from employee e
full outer join dept d on e.dept_id = d.dep_id;

--drop table people;
create table people
(
  manager varchar(20),
  region varchar(10)
);

insert into people values ('Saide Pawthrone', 'West');
insert into people values ('Chuck Magee', 'East');
insert into people values ('Roxanne Rodriguez', 'Central');
insert into people values ('Fred Suzuki', 'South');

select * from people;

select o.order_id, product_id, r.return_reason
from orders o 
inner join returns r on o.order_id  = r.order_id;

--let's say we want to join people table to already joined orders and return table
select o.order_id, o.product_id, r.return_reason, p.region, p.manager
from orders o 
inner join returns r on o.order_id  = r.order_id
inner join people p on p.region = o.region;
--there is no limit on using inner join 
--we can add 20-30 tables as well




