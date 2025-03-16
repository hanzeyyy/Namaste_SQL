drop table amazon_order;
--DDL
create table amazon_order
(
  order_id integer,
  order_date date,
  product_name varchar(100),
  total_price decimal(5,2),
  payment_method varchar(20)
);

--DML
insert into amazon_order values (1, '2024-05-05', 'Baby Milk', 30.5, 'UPI');
insert into amazon_order values (2, '2024-08-05', 'Baby Pad', 40.15, 'UPI');
insert into amazon_order values (3, '2024-06-05', 'Baby Cream', 530., 'Cash');
insert into amazon_order values (4, '2024-07-05', 'Baby Soap', 140.5, 'Credit Card');

--DQL
select * from amazon_order;
--here we can't use drop & create table command, since, we can lose all data
--we have order name in date format, but we are also interested in finding at what time the order was placed
--DDL -> Data Definition Language
-----alter-----
--change datatype of a column 
alter table amazon_order 
alter column order_date datetime;
select * from amazon_order;

insert into amazon_order values (5, '2022-9-4 12:05:45', 'Shoes', 750, 'UPI');
select * from amazon_order;

-----add-----
--adding a column in an existing table	
--suppose we want to add more columns in our table
alter table amazon_order 
add user_name varchar(20);
select * from amazon_order;
--the new column will be added at the end
--by default, it will be NULL(special keyword/character, it means unknown)

insert into amazon_order values(6,'2023-7-7 14:09:55', null, 998, 'UPI', 'Hanzala');
select * from amazon_order;

--since we have added one additional column in our table, we need to be careful while using it
--let's say we added a data column but later realised we don't want it
-----drop-----
--delete a column from an existing table
alter table amazon_order 
add category varchar(20);
select * from amazon_order;

alter table amazon_order 
drop column category;
select * from amazon_order;
--we can drop/delete a column using alter & drop command

--always be careful while changing one datatype to another (say integer to date is not feasible)
--in other words, datatype should be compatible
--if table is empty, then we can change any datatype to any other datatype
--varchar can accomodate anything
 
-----not null-----
--constraints 1
--let's say,  we don't want some data in null format i.e. someone must input correct datatype
--drop table flipkart_orders;
create table flipkart_orders
(
	order_id integer not null,
	order_date datetime,
	product_name varchar(20),
	total_price decimal(6,2),
	payment_method varchar(10),
);

insert into flipkart_orders values(1, '2023-10-31 15:04:55', 'Adidas tshit', 2699, 'UPI');
select  * from flipkart_orders;

--insert into amazon_order values (null, '2024-08-05', 'Baby Pad', 40.15, 'UPI');
--shows error

-----check(column_name  in (' '))-----
--constraint 2
--let's say,we want to accept payment only in upi & cash
drop table flipkart_orders;
create table flipkart_orders
(
	order_id integer not null,
	order_date datetime,
	product_name varchar(20),
	total_price decimal(6,2),
	payment_method varchar(10) check(payment_method in ('UPI', 'Cash'))
);

insert into flipkart_orders values(1, '2023-10-31 15:04:55', 'Adidas tshit', 2699, 'upi');
select  * from flipkart_orders;
--Note - not case sensitive

--insert into amazon_order values (2, '2024-08-05', 'Baby Pad', 40.15, 'Card');
--shows error

--we can use check command in other ways as well
drop table flipkart_orders;
create table flipkart_orders
(
	order_id integer not null,
	order_date datetime,
	product_name varchar(20),
	total_price decimal(6,2),
	payment_method varchar(10) check(payment_method in ('UPI', 'Cash')),
	discount integer check(discount<=15)
);

insert into flipkart_orders values(1, '2023-10-31 15:04:55', 'Adidas tshit', 2699, 'upi',10);
select  * from flipkart_orders;

delete from flipkart_orders 
where order_id=1;

select  * from flipkart_orders;
	
-----unique-----
--constraint 3
drop table flipkart_orders;
create table flipkart_orders
(
	order_id integer not null unique,
	order_date datetime,
	product_name varchar(20),
	total_price decimal(6,2),
	payment_method varchar(10) check(payment_method in ('UPI', 'Cash')),
	discount integer check(discount<=20)
);

insert into flipkart_orders values(1, '2023-10-31 15:04:55', 'Adidas tshit', 2699, 'upi',10);
insert into flipkart_orders values (2, '2024-08-05', 'Baby Pad', 40.15, 'upi', 15);

--insert into flipkart_orders values (2, '2024-06-05', 'Baby Cream', 530., 'Cash', 7);
--shows error
select  * from flipkart_orders;

-----default-----
--constraint 4
drop table flipkart_orders;
create table flipkart_orders
(
	order_id integer not null unique,
	order_date datetime,
	product_name varchar(20),
	total_price decimal(6,2),
	payment_method varchar(10) check(payment_method in ('UPI', 'Cash')),
	discount integer check(discount<=20),
	category varchar(10) default 'Mens Wear'
);

insert into flipkart_orders values(1, '2023-10-31 15:04:55', 'Adidas tshit', 2699, 'upi',10,'Kids Wear');
insert into flipkart_orders values(2, '2023-10-31 15:04:55', 'Adidas tshit', 2699, 'upi',10,null);
insert into flipkart_orders values(3, '2023-10-31 15:04:55', 'Adidas tshit', 2699, 'upi',10,'');
--solution is that we need to pass column names along with column values
insert into flipkart_orders(order_id, order_date, product_name, total_price, payment_method, discount) values (4, '2023-10-31 15:04:55', 'Adidas tshit', 2699, 'upi',10);
insert into flipkart_orders(order_id, order_date, product_name, total_price, payment_method) values (5, '2023-10-31 15:04:55', 'Adidas tshit', 2699, 'upi');
select  * from flipkart_orders;

--we can as many as constraint we  like
drop table flipkart_orders;
create table flipkart_orders
(
	order_id integer not null unique,
	order_date datetime,
	product_name varchar(20),
	total_price decimal(6,2),
	payment_method varchar(10) check(payment_method in ('UPI', 'Cash')) default 'UPI',
	discount integer check(discount<=20),
	category varchar(10) default 'Mens Wear'
);

insert into flipkart_orders values(1, '2023-10-31 15:04:55', 'Adidas tshit', 2699, 'upi',10,'Kids Wear');
insert into flipkart_orders values(2, '2023-10-31 15:04:55', 'Adidas tshit', 2699, 'upi',10,null);
insert into flipkart_orders values(3, '2023-10-31 15:04:55', 'Adidas tshit', 2699, 'upi',10,'');
--solution is that we need to pass column names along with column values
insert into flipkart_orders(order_id, order_date, product_name, total_price, payment_method, discount) values (4, '2023-10-31 15:04:55', 'Adidas tshit', 2699, 'upi',10);
insert into flipkart_orders(order_id, order_date, product_name, total_price, payment_method) values (5, '2023-10-31 15:04:55', 'Adidas tshit', 2699, 'upi');
insert into flipkart_orders(order_id, order_date, product_name, total_price) values (6, '2023-10-31 15:04:55', 'Adidas tshit', 2699);
select  * from flipkart_orders;

--what if we just write default in column name instead of passing column name & then values
drop table flipkart_orders;
create table flipkart_orders
(
	order_id integer not null unique,
	order_date datetime,
	product_name varchar(20),
	total_price decimal(6,2),
	payment_method varchar(10) check(payment_method in ('UPI', 'Cash')) default 'UPI',
	discount integer check(discount<=20),
	category varchar(10) default 'Mens Wear'
);

insert into flipkart_orders values(1, '2023-10-31 15:04:55', 'Adidas tshit', 2699, 'upi',10,default);
select  * from flipkart_orders;

-----primary key-----
--primary key is unique + not null constraint
--constraint 4
drop table flipkart_orders;
create table flipkart_orders
(
	order_id integer,
	order_date datetime,
	product_name varchar(20),
	total_price decimal(6,2),
	payment_method varchar(10) check(payment_method in ('UPI', 'Cash')) default 'UPI',
	discount integer check(discount<=20),
	category varchar(10) default 'Mens Wear',
	primary key (order_id)
);

insert into flipkart_orders values(1, '2023-10-31 15:04:55', 'Adidas tshit', 2699, 'upi',10,default);
select  * from flipkart_orders;

--primary key can also be a combination of two columns
drop table flipkart_orders;
create table flipkart_orders
(
	order_id integer,
	order_date datetime,
	product_name varchar(20),
	total_price decimal(6,2),
	payment_method varchar(10) check(payment_method in ('UPI', 'Cash')) default 'UPI',
	discount integer check(discount<=20),
	category varchar(10) default 'Mens Wear',
	primary key (order_id,product_name)
);

insert into flipkart_orders values(1, '2023-10-31 15:04:55', 'Adidas tshit', 2699, 'upi',10,default);
insert into flipkart_orders values(1, '2023-10-31 15:04:55', 'Adidas shoes', 2199, 'upi',10,default);
select  * from flipkart_orders;

--Note - there can be only one primary key
-- there can be multiple unique key

--we have used delete command earlier, let's revise it & add little more knowledge
drop table flipkart_orders;
create table flipkart_orders
(
	order_id integer,
	order_date datetime,
	product_name varchar(20),
	total_price decimal(6,2),
	payment_method varchar(10) check(payment_method in ('UPI', 'Cash')) default 'UPI',
	discount integer check(discount<=20),
	category varchar(10) default 'Mens Wear',
	primary key (order_id,product_name)
);

insert into flipkart_orders values(1, '2023-10-31 15:04:55', 'Adidas tshit', 2699, 'upi',10,default);
insert into flipkart_orders values(1, '2023-10-31 15:04:55', 'Adidas shoes', 2199, 'upi',10,default);
insert into flipkart_orders values(2, '2023-10-31 15:04:55', 'Adidas shirt', 4699, 'upi',10,default);
insert into flipkart_orders values(3, '2023-10-31 15:04:55', 'Adidas slipper', 1199, 'upi',10,default);
select  * from flipkart_orders;

delete from flipkart_orders;
select  * from flipkart_orders;
-- this command deleted all rows present in the table
--what if we want to delete a single row
drop table flipkart_orders;
create table flipkart_orders
(
	order_id integer,
	order_date datetime,
	product_name varchar(20),
	total_price decimal(6,2),
	payment_method varchar(10) check(payment_method in ('UPI', 'Cash')) default 'UPI',
	discount integer check(discount<=20),
	category varchar(10) default 'Mens Wear',
	primary key (order_id,product_name)
);

insert into flipkart_orders values(1, '2023-10-31 15:04:55', 'Adidas tshit', 2699, 'upi',10,default);
insert into flipkart_orders values(1, '2023-10-31 15:04:55', 'Adidas shoes', 2199, 'upi',10,default);
insert into flipkart_orders values(2, '2023-10-31 15:04:55', 'Adidas shirt', 4699, 'upi',10,default);
insert into flipkart_orders values(3, '2023-10-31 15:04:55', 'Adidas slipper', 1199, 'upi',10,default);
select  * from flipkart_orders;

--delete with a filter condition
delete from flipkart_orders 
where order_id=2;
select  * from flipkart_orders;
--hence only 3rd row is deleted
--insert & delete are DML

-----Update & set-----
update flipkart_orders 
set discount=15;
select  * from flipkart_orders;
--update reflect all data present in the row as delete reflect on rows

--what if we want to update only one row
update flipkart_orders 
set discount=20 
where order_id=3;
select  * from flipkart_orders;
	 
--we can even update the name of things in the table
update flipkart_orders 
set product_name='Adidas wearable' 
where product_name='Adidas tshit';
select  * from flipkart_orders;

--we can updatde multiple columns altogether
update flipkart_orders 
set product_name='Adidas tshirt', total_price=2779 
where product_name='Adidas wearable';
select  * from flipkart_orders;
