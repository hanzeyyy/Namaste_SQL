--DDL -> Data Definition Language 
create table amazon_order
(
  order_id integer,
  order_date date,
  product_name varchar(50),
  total_price decimal(5,2),
  payment_method varchar(20)
);

-- always put ';' at the end 
/*
data types--
integers -> 1,2,3,-1,-2 etc
data -> 'yyyy-mm-dd' -> '2024-05-05'
string -> varchar(length) -> baby milk(100) { don't give too much length, since it will increase size }
decimal(length,precision) -> decimal(5,2) -> 245.45 { length minus precision is the no. of digits used }
if we use decimal(5,2) , say 1234.45, then it will show error since 5-2 = 3 (1234 is 4 digits )

dbo refers (database object) default schema
what is scheme?
schema is like a folder which we have in our drives
*/

--DML - Data Manipulation Language
insert into amazon_order values (1, '2024-05-05', 'Baby Milk', 30.5, 'UPI');
insert into amazon_order values (2, '2024-08-05', 'Baby Pad', 40.15, 'UPI');
insert into amazon_order values (3, '2024-06-05', 'Baby Cream', 530., 'Cash');
insert into amazon_order values (4, '2024-07-05', 'Baby Soap', 140.5, 'Credit Card');

-- order is very important
/*
we use insert into *** values to insert data in the database
() in bracket we insert the items in the row.
use '' for data & string
*/

/*
so far we have created a table and insert data into it 
but now we wish to see the table
*/
-- SQL -> Structured Query launguage

-- DQL - Data Query Language
select * from amazon_order;
/*
this simply means that show me all the rows & columns (*) from the table amazon_order
NOTE: this command shows us all the data present in the table
but if we want to see any specific data then what?
then instead of using * just write the column name
*/
-- limiting columns or selecting specific columns
select order_id 
from amazon_order;
-- but what if we want to see more than one column
select order_id, order_date 
from amazon_order;
--here order doesn't matter
--but what if a column contains millions of records
-- limiting tows or selecting specific rows
select top 2 * from amazon_order;
-- this shows us top 2 rows

-- data sorting
select * from amazon_order
order by order_date;
-- this command sort the data in ascending order (by default )
-- if wanna see descending, just add 'desc'
select * from amazon_order
order by order_date desc;

-- we realised that the table we have created is not what we want
--Delete a table
--drop table amazon_order;
--this is a DDL command

--what if we want to delete rows and not table
--to delete data
--delete from amazon_order;
-- this is DML command
select * from amazon_order;

create hr_new.test
(
  id integer,	
  name varchar(10)
)
insert into hr_new.test values(1,'Hanzala');

select * from hr_new.test
