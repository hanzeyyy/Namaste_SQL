select * from icc_world_cup;
-- 1. write a query to produce below output from icc_world_cup table.
	-- team_name, no_of_matches_played , no_of_wins , no_of_losses
select team_1 as team_name,
count(team_1) as no_of_matches_played,
count(case when team_1 = Winner then 1 end)  as no_of_wins,
count(case when team_1 != Winner then 1 end)  as no_of_losses
from icc_world_cup
union all
select team_2 as team_name,
count(team_2) as no_of_matches_played,
count(case when team_2 = Winner then 1 else 0 end) as no_of_wins,
count(case when team_2 != Winner then 1 end)  as no_of_losses
from icc_world_cup;
--need to use subquery or CTE to solve this query

--using CTE
with all_teams as 
(select team_1 as team, case when team_1=winner then 1 else 0 end as win_flag from icc_world_cup
union all
select team_2 as team, case when team_2=winner then 1 else 0 end as win_flag from icc_world_cup)
select team,count(1) as total_matches_played , sum(win_flag) as matches_won,count(1)-sum(win_flag) as matches_lost
from all_teams
group by team


select * from orders;
-- 2. write a query to print first name and last name of a customer using orders table
	--(everything after first space can be considered as last name)
	--customer_name, first_name, last_name
select customer_name,
left(customer_name, charindex(' ', customer_name)) as first_name,
right(customer_name, charindex(' ', customer_name)) as last_name
from orders;


select * from  drivers;
-- 3. write a query to print below output using drivers table. 
-- Profit rides are the no of rides where end location of a ride is same as start location of immediate next ride for a driver
/*
id, total_rides , profit_rides
dri_1,5,1
dri_2,2,0
*/
select d1.id, count(1) as total_rides,
--count(case when d1.end_loc = d2.start_loc then 1 end) as profit_ride
count(d2.id) as profit_ride --better performance using this
from drivers d1
left join drivers d2 on d1.id = d2.id and d1.end_loc = d2.start_loc and d1.end_time = d2.start_time
group by d1.id;


-- 4. write a query to print customer name and no of occurence of character 'n' in the customer name.
	-- customer_name , count_of_occurence_of_n
select customer_name, 
len(customer_name) as length_of_customer_name,
lower(customer_name) as lower_case_name,
replace(lower(customer_name),'n','') replace_n_to_space,
len(replace(lower(customer_name),'n','')) as new_length_of_customer_name,
len(customer_name)-len(replace(lower(customer_name),'n','')) as count_of_occurence_of_n
from orders;


select * from orders;
-- 5. write a query to print below output from orders data. example output
/*
hierarchy type,hierarchy name ,total_sales_in_west_region,total_sales_in_east_region
category , Technology, ,
category, Furniture, ,
category, Office Supplies, ,
sub_category, Art , ,
sub_category, Furnishings, ,
and so on all the category ,subcategory and ship_mode hierarchies 
*/
select 'category' as hierarchy_type,
category as hierarchy_name,
sum(case when region = 'west' then sales else 0 end) as total_sales_in_west_region,
sum(case when region = 'east' then sales else 0 end) as total_sales_in_east_region
from orders
group by category
union  all
select 'sub_category' as hierarchy_type,
sub_category as hierarchy_name,
sum(case when region = 'west' then sales else 0 end) as total_sales_in_west_region,
sum(case when region = 'east' then sales else 0 end) as total_sales_in_east_region
from orders
group  by sub_category
union all
select 'ship_mode' as hierarchy_type,
ship_mode as hierarchy_name,
sum(case when region = 'west' then sales else 0 end) as total_sales_in_west_region,
sum(case when region = 'east' then sales else 0 end) as total_sales_in_east_region
from orders
group  by ship_mode;
--NOTE: column names in the output are taken from first query, the names in the rest query doesn't matter


--6.  the first 2 characters of order_id represents the country of order placed. 
-- write a query to print total no of orders placed in each country
	-- (an order can have 2 rows in the data when more than 1 item was purchased in the order but it should be considered as 1 order)
select left(order_id, 2) as country_order,
count(distinct order_id) as total_orders
from orders
group by left(order_id, 2);
