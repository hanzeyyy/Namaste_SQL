select * from orders;

----distinct command----
-- to get distinct value of a column
-- suppose if we want to see how many distinct/different items/data are present in the table
select distinct ship_mode 
from orders;

--we can select multiple columns also
select distinct ship_mode, order_id  
from orders; 

--we can arrange them in ascending/descending order as pleased
select distinct order_id, ship_mode 
from orders
order by order_id;

--if we use the command below then nothing wil happen as order_id is distinct
select distinct * from orders;

-------filters-------
-----where-----
--suppose we can want to see only one particular thing 
select * from orders 
where order_date = '2020-11-08';

---!(not equal)---
select top 100 order_date, quantity 
from orders 
where quantity != 14
order by quantity desc;

--this shows us all the records before '2020-12-08'
select * from orders
where order_date < '2020-12-08'
order by order_date desc;

--what if we want to see the orders palced between two dates
-----between-----
select * from orders
where order_date between '2020-12-08' and '2020-12-12'
order by order_date desc;

--applicable to integers as well
select quantity from orders
where quantity between 3 and 5
order by quantity desc;

-----where & in-----(for multiple columns since we simply cannot use comma)
select * from orders
where ship_mode in ('First Class', 'Same Day')
order by ship_mode desc;

select quantity from orders
where quantity in (3,5)
order by quantity desc;
-- 4 is not included in the range

--differenciate 'between' and 'where'
--between gives us the result within a certain range (including upper and lower limit) while where gives us the result in upper limit and lower limit

-----where & not in-----
--(excluding)
select * from orders
where ship_mode not in ('First Class', 'Same Day')
order by ship_mode desc;

select * from orders
where quantity not in (3,5)
order by quantity;

select distinct ship_mode 
from orders
order by ship_mode desc;
--4 records

select distinct ship_mode 
from orders
where ship_mode not in ('First Class', 'Same Day')
order by ship_mode desc;
--2 records

--when speaking of 'not in'/'in', it is convenient to use in (why complicate things?)
 
--data sorting happends as per ASCII code
select distinct ship_mode 
from orders
where ship_mode > 'First Class';

-----and-----
--if we want to add 2 filters say ship mode in first class & segment in consumer
select * from orders
where ship_mode = 'First class' and segment = 'consumer';

----or-----
--if we want either one say ship mode in first class or segment in consumer
select * from orders
where ship_mode = 'First class' or segment = 'consumer';

--we can write a code in more than one ways (eg below)
select distinct ship_mode from orders
where ship_mode in ('First Class', 'Same Day')
order by ship_mode desc;
--second way
select distinct ship_mode from orders
where ship_mode = 'First Class' or ship_mode = 'Same Day'
order by ship_mode desc;

--or filter always increases the no. of rows
--and filter always decreases the no. of rows
select * from orders
where quantity >7 and ship_mode = 'First class';

select quantity, ship_mode 
from orders
where quantity >7 and ship_mode = 'First class'
order by quantity;

/* in the live lecture, a lot of students were asking Ankit about datetime, Ankit told that by default time is set as 00:00:00
but since there was still some confusion, Ankit told about this function which act as a filter - cast(order_date as date) as
column_name (a new column is added in the output) */
select cast(order_date as date) as order_date_new, * from orders
where cast(order_date as date) = '2020-11-8';
--this will be taught in functions

-----adding a new column-----
--suppose we want to add a new column say ratio which is profit/sales
select * , 
profit/sales as ratio 
from orders;

--we can multiple column as well
select *, 
profit/sales as ratio, 
profit+sales as total 
from orders;

-----getdate()-----
--this gives us the current date as a new column
select *, 
profit/sales as ratio, 
profit+sales as total,  
getdate() as current_orderdate 
from orders; 

-----like & %-----
--pattern matching like operator
select order_id, order_date, customer_name 
from orders
where customer_name = 'Claire Gute';
--this shows us 5 records

--but what if we want see all the customers whose name starts with 'c'
select order_id, order_date, customer_name 
from orders
where customer_name like 'C%';
--this shows us 818 records

--but what if we want see all the customers whose name starts with 'schild'
select order_id, order_date, customer_name 
from orders
where customer_name like '%schild';
--this shows us 14 records

--but what if we want see all the customers whose name starts & ends with anthing but has 'ven' in between
select order_id, order_date, customer_name 
from orders
where customer_name like '%ven%';
--this shows us 107 records

--but what if we want see all the customers whose name starts & ends with 'A'
select order_id, order_date, customer_name 
from orders
where customer_name like 'A%a';

-----upper(column name) as newcolumnname-----
--Currently we are using sql server which is case insenstive
--but it may happn that someone has changed it to case sensitive say "Alex AvilA"
--then we can change all the words of the name to upper case
select order_id, order_date, customer_name, 
upper(customer_name) as customer_upper 
from orders
where upper(customer_name) like 'A%A';

-----_-----
--suppose we want to see a name whose second character is 'l'
--_ means that here can be any character
--no. of _ represents no. of characters
select order_id, order_date, customer_name 
from orders
where customer_name like '_l%';

-----escape-----
--what if we want to escape % or _ character
select order_id, order_date, customer_name 
from orders
where customer_name like '_l%'  escape '%';

-----[]-----
--what if we want the second charcter to be either a or l
--we can see any no. of characters inside []
select order_id, order_date, customer_name 
from orders
where customer_name like 'C[al]%';

-----[^]-----
--what if we don't want the second character to be a or l
--simply saying ^ means negate
select order_id, order_date, customer_name 
from orders
where customer_name like 'C[^al]%';

-----[-]-----
--what if we want to have a range instead of just some finite characters
select order_id, order_date, customer_name 
from orders
where customer_name like 'C[a-l]%';

select order_id, order_date, customer_name 
from orders
where customer_name like 'C[^a-l]%';

--we can use [] for integer as well
select order_id, order_date, customer_name 
from orders
where order_id like 'CA-20[1-2]%';

-- we can use [] multiple times as well
select order_id, order_date, customer_name 
from orders
where order_id like 'CA-20[1-2][1-9]%';
