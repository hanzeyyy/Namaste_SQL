/*
database holds millions of data in it and it may be stored in a randon order
so, when we try to retrieve any data from the database, 
it searches for that particular record.
so, it's better to sort the data first
however, sql does linear search (from top to bottom)

Index comes into picture. 
Index indicates the location of each sub-database which enables sql to find the data easily (just like a book)

There are two types of index:
1. clustered index
2. non-clustered index (binary search)  

In clustered index, database is sorted physically irrespective of how we input it
since, a database has multiple columns, clustred index can be created based on only one column (cannot use multiple column)

In non-clustered index, a new structure is created in a sorted manner with address of each row 
NOTE: when we create a primary key, clustered index is created based on the primary key (by default)
*/


create table emp_index
(
	emp_id int,
	emp_name varchar(20),
	salary int
);

insert into emp_index values (1, 'Ankit', 10000), (3, 'Rahul', 10000),(2, 'Manish', 10000),(4, 'Pushkar', 10000);

select * from emp_index;
/*
emp_id	emp_name	salary
1		Ankit		10000
3		Rahul		10000
2		Manish		10000
4		Pushkar		10000
*/
--the emp_id's are not in order
--and there is no primary key

drop table emp_index;
create table emp_index
(
	emp_id int primary key,
	emp_name varchar(20),
	salary int
);

insert into emp_index values (1, 'Ankit', 10000), (3, 'Rahul', 10000),(2, 'Manish', 10000),(4, 'Pushkar', 10000);

select * from emp_index;
--we have created the same table again but with a primary key
--we can see that the primary key is set as clustered index (by default)
--NOTE: the emp_id's are in order automatically
/*
emp_id	emp_name	salary
1		Ankit		10000
2		Manish		10000
3		Rahul		10000
4		Pushkar		10000
*/


-----syntax to create index-----
--create non/clustered index index_name on table_name (coulmn_name)
create nonclustered index index_name on emp_index (emp_name);

select * from emp_index;


--we to see non/clustered index?
execute sp_helpindex emp_index;
/*
index_name							index_description										index_keys
index_name							nonclustered located on PRIMARY							emp_name
PK__emp_inde__1299A86117243E63		clustered, unique, primary key located on PRIMARY		emp_id
*/


select row_number() over(order by a.row_id) as rn, 
a.* into orders_index
from orders a, (select top 100 * from orders) b;
--here we have joined 2 tables without using join condition
--999400

select count(1) as no_of_rows from orders_index;
--999400 records

select * from orders_index;


select * from orders_index
where rn = 100;

create nonclustered index idx_rn on orders_index (rn);

select * from orders_index
where rn = 100;

select rn from orders_index
where rn = 100;

select rn, customer_id from orders_index
where rn = 100;

--what if we want customer_id as well
drop index idx_rn on orders_index;
create nonclustered index idx_rn on orders_index (rn) include(customer_id);
-- we stored rn along with customer_id (no lookup now) 
select rn, customer_id from orders_index
where rn = 100;

create clustered index c_idx_rn on orders_index (rn);
--there can be only one clustered index
--there can be many nonclustered index
--the only downside of clustered index is that the inserts will be very slow
--to tackle this, we can drop the index and then create new index with inserts included in it (common interview question)


--there are unique and nonunique index (by default nonclustured index are nonunique) as well
--unique index -> can be created on a column which has unique values 
create nonclustered index idx_cus on orders_index (customer_id);

select top 10 * from orders_index;

select * from orders_index 
where customer_name =  'Claire Gute';
--rows to be read = 999400
select top 10 * from orders_index;

select * from orders_index 
where customer_id =  'CG-12520';
--rows to be read = 780

select * from orders_index 
where customer_id like  'Cl%';

select customer_id,
sum(sales) as sales
from orders_index 
where customer_id like  'Cl%'
group by customer_id;


drop index idx_cus on orders_index;
create nonclustered index idx_cus on orders_index (customer_id asc, customer_name desc);

select customer_id, customer_name from orders_index 
where customer_id like  'Cl%' and customer_name like 'C%';


drop index idx_cus on orders_index;
create nonclustered index idx_cus on orders_index (customer_id asc, sales desc);

select customer_id, customer_name, sales from orders_index 
where customer_id like  'Cl%' and sales > 100;
--index and vlookup

-----duplicates-----
create table emp_dup
(
	emp_id int,
	emp_name varchar(20),
	create_time datetime
);

insert into emp_dup values (1, 'Ankit', '2022-12-22 10:40:01');
insert into emp_dup values (2, 'Vivek', '2022-12-22 10:40:01');
insert into emp_dup values (1, 'Ankit', '2022-12-22 10:42:01');

select * from emp_dup;

select emp_id from emp_dup 
group by emp_id
having count(emp_id) > 1;


delete from emp_dup
where emp_id in 
(
	select emp_id from emp_dup 
	group by emp_id
	having count(emp_id) > 1
);
--this approach deletes all duplicates

select * from emp_dup;

insert into emp_dup values (1, 'Ankit', getdate());
select * from emp_dup;

insert into emp_dup values (1, 'Ankit', getdate());
select * from emp_dup;

update emp_dup
set create_time = '2025-05-25 11:40:00'
where emp_id = 2;

select * from emp_dup;

--how to delete only one duplicate record
select emp_id,
min(create_time) as create_time
from emp_dup 
group by emp_id
having count(emp_id) > 1;
--we get only one record
/*
emp_id	create_time
1		2025-05-25 11:55:29.410
*/

delete from emp_dup
where emp_id in 
(
	select emp_id,
	min(create_time) as create_time
	from emp_dup 
	group by emp_id
	having count(emp_id) > 1
);
--error: only one expression can be specified in the select list when the subquery is not introduced with EXISTS.
--since, sub-query returns only one output. we cannot implement this
--what to do then?
--use the concept of join 
delete emp_dup 
from emp_dup e
inner join 
(
	select emp_id,
	min(create_time) as create_time
	from emp_dup 
	group by emp_id
	having count(emp_id) > 1
) d
on e.emp_id = d.emp_id and e.create_time = d.create_time;

select * from emp_dup;
--we can use the concept of row_id since it is unique (in oracle, by default it is present)
--we can take a back-up of the existing table and then use it 


create table emp_dup1
(
	emp_id int,
	emp_name varchar(20)
);

insert into emp_dup1 values (1, 'Ankit');
insert into emp_dup1 values (1, 'Ankit');
insert into emp_dup1 values (2, 'Vivek');

select * from emp_dup1;

select distinct * into emp_dub1_back from emp_dup1;
--created a backup

select * from emp_dub1_back;

truncate table emp_dup1;
--deletes all the records

select * from emp_dup1;
--no records left

insert into emp_dup1 select * from emp_dub1_back;

select * from emp_dup1;
--no duplicates present in the table now

--a table can have 100s of duplicate records but we are running delete query only once which deletes only oe duplicate
--how do we deal with this?
--we can keep the record which we need and delete rest of the duplicate records  
select * from emp_dup;
--let's use this table

insert into emp_dup values (1, 'Ankit', getdate());
select * from emp_dup;

insert into emp_dup values (1, 'Ankit', getdate());
select * from emp_dup;

select * from emp_dup e
left join 
(
	select emp_id,
	max(create_time) as create_time
	from emp_dup 
	group by emp_id
) d
on e.emp_id = d.emp_id and e.create_time = d.create_time;


select * from emp_dup e
left join 
(
	select emp_id,
	max(create_time) as create_time
	from emp_dup 
	group by emp_id
) d
on e.emp_id = d.emp_id and e.create_time = d.create_time
where d.emp_id is null;
--we get the duplicte emp_id/record's

delete emp_dup
from emp_dup e
left join 
(
	select emp_id,
	max(create_time) as create_time
	from emp_dup 
	group by emp_id
) d
on e.emp_id = d.emp_id and e.create_time = d.create_time
where d.emp_id is null;
--duplicate records are deleted

select *from emp_dup;
