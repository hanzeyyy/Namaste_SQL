-------string function-------
select * from orders;


--let's take string only
select order_id ,customer_name 
from orders;


-----len function-----
--length(column name) -> tells the length/characters of a string
--length -> tells the length/characters of a string
select order_id, customer_name,
len(customer_name) as length_of_name
from orders;
--len counts leading spaces as well


-----left function-----
--left(column name, length) -> shows us the length of desired length
--left -> shows us the length of desired length
--i.e. limit/cuts undersirable length starting from left
select order_id ,customer_name,
left(customer_name, 6) as name_6
from orders;


-----right function-----
--right(column name, length) -> shows us the length of desired length
--right -> shows us the length of desired length
--i.e. limit/cuts undersirable length starting from right
select order_id ,customer_name,
right(customer_name, 5) as name_5
from orders;


select order_id ,customer_name,
left(customer_name, 6) as left_name_6,
right(customer_name, 6) as right_name_6
from orders;


-----substring function-----
--substring(column name, starting character of string, required character length)
select order_id ,customer_name,
left(customer_name, 6) as left_name_6,
right(customer_name, 6) as right_name_6,
substring(customer_name, 3,5) as substring_3_5
from orders;


select order_id ,customer_name, 
left(customer_name, 6) as left_name_6,
right(customer_name, 6) as right_name_6,
substring(customer_name, 3,5) as substring_3_5,
substring(order_id, 4,4) as order_year
from orders;


-----charindex-----
--charindex(desired character, column name) -> tells us the position of desired character
select order_id ,customer_name,
left(customer_name, 6) as left_name_6,
right(customer_name, 6) as right_name_6,
substring(customer_name, 3,5) as substring_3_5,
charindex(' ', customer_name) as space_position
from orders;


--if the characters are repeating then it shows the position of first occuring character
select order_id ,customer_name,
left(customer_name, 6) as left_name_6,
right(customer_name, 6) as right_name_6,
substring(customer_name, 3,5) as substring_3_5,
charindex(' ', customer_name) as space_position,
charindex('n', customer_name) as n_position
from orders;


--if we want to see the position of all 3 occurance
select order_id ,customer_name,
left(customer_name, 6) as left_name_6,
right(customer_name, 6) as right_name_6,
substring(customer_name, 3,5) as substring_3_5,
charindex(' ', customer_name) as space_position,
charindex('n', customer_name,1) as n1_position,
charindex('n', customer_name,5) as n2_position,
charindex('n', customer_name,11) as n3_position
from orders;
--if there is no occurance, it shows 0
--charindex(desired character, column name, starting position)
select 
charindex('n', customer_name) as n1_position,
charindex('n', customer_name, charindex('n', customer_name)+1) as n2_position
from orders;


-----concat function-----
--concat(column 1, desired format, column 2) -> adds two column
select order_id ,customer_name,
left(customer_name, 6) as left_name_6,
right(customer_name, 6) as right_name_6,
substring(customer_name, 3,5) as substring_3_5,
charindex(' ', customer_name) as space_position,
charindex('n', customer_name) as n_position,
concat(order_id, ' ', customer_name) as con_cat
from orders;
--or
select order_id ,customer_name,
order_id+' '+customer_name as id_and_name
from orders;


--we can find space using substring then use left to find first name
select order_id ,customer_name,
left(customer_name, 6) as left_name_6,
right(customer_name, 6) as right_name_6,
substring(customer_name, 3,5) as substring_3_5,
left(customer_name, charindex(' ', customer_name)) as first_name,
charindex(' ', customer_name) as space_position,
charindex('n', customer_name) as n_position,
concat(order_id, ' ', customer_name) as con_cat,
order_id+'-'+customer_name as id_and_name
from orders;


select customer_name,
left(customer_name, charindex(' ', customer_name)) as first_name,
right(customer_name, charindex(' ', customer_name)) as last_name
from orders;


-----replace function-----
--replace(column name, character to be replaced, character to replace with) 
--replace -> replace some character with other character
select order_id ,customer_name,
replace(order_id, 'CA', 'UK') as CA_to_UK
from orders;


-----translate-----
--translate(column name, character to be translated, character to translate with)
--translate -> translates corresponding characters
--one to one mapping
select order_id ,customer_name,
replace(customer_name, 'CA', 'UK') as replace_CA_to_UK,
translate(customer_name, 'CA', 'UK') as translate_CA_to_UK
from orders;


-----reverse------
--reverse(column name)
--reverse -> reverses string positons
select order_id,
reverse(order_id) as reversed_order_id
from orders;


-----trim-----
--trim(string)
--trim -> removes trailing and leading spaces
select trim(' Hanzala ')  as name
from orders;


--------null handling function-------
-----isnull----- 
--isnull(column name, desired character) 
--isnull -> changes null to something meaningful
select order_id, city, 
isnull(city, 'unknown') as new_city
from orders
order by city;

select order_id, city, 
isnull(city, 'Austim') as new_city
from orders
order by city;


-----coalesce----- 
--coalesce(column name1, column name2, column name3, desired character)
--coalesce -> checks left to right and assign something meaningful
select order_id, city, 
isnull(city, 'unknown') as new_city,
coalesce(city, state, region,'unknown') as new_city
from orders
order by city;


-----cast----- 
--cast(column name as desired format)
--cast -> convert one datatype to another
select order_id, sales,
cast(sales as integer) as sales_to_int
from orders;


-----round----- 
--round(column name, decimal places)
--round -> round off to one decimal place
select order_id, sales,
cast(sales as integer) as sales_to_int,
round(sales, 1) as sales_rounded
from orders;


-------set query-------
create table orders_west
(
	order_id int,
	region varchar(10),
	sales int
);


create table orders_east
(
	order_id int,
	region varchar(10),
	sales int
);

insert into orders_west values (1, 'west', 100), (2, 'west', 200);
insert into orders_east values (3, 'east', 100), (4, 'east', 300);

select * from orders_west;
select * from orders_east;

-----union all-----
--union all -> joins two tables vertically together
select * from orders_west
union all
select * from orders_east;


-----union-----
--union -> joins two/multiple tables vertically together but removes duplicate rows
insert into orders_west values (3, 'east', 100); 
select * from orders_west
select * from orders_east;

select * from orders_west
union all
select * from orders_east;

select * from orders_west
union
select * from orders_east;

select * from orders
union all
select * from orders;

select * from orders
union
select * from orders;


----intersect-----
--intersect -> shows common data from two/multiple tables
select * from orders_west
intersect
select * from orders_east;

select * from orders
intersect
select * from orders;


-----except-----
--except -> table 1 - table 2
select * from orders_west;
select * from orders_east;

select * from orders_west
except
select * from orders_east;
--orders_west - orders_east


select * from orders_east
except
select * from orders_west;
--orders_east - orders_west

