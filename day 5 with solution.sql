select * from orders;
select * from returns;
-- write a query to get region wise count of return orders
select o.region, 
count(distinct r.order_Id) as returned_orders
from orders o
inner join returns r on o.order_id = r.order_Id
group by o.region;


select * from orders;
select * from returns;
-- write a query to get category wise sales of orders that were not returned
select o.category, 
sum(o.sales) as total_sales
from orders o
left join returns r on o.order_id =r.order_id
where r.return_reason is null
group by o.category;


select * from employee;
select * from dept;
-- write a query to print dep name and average salary of employees in that dep .
select d.dep_name, avg(e.salary) as avg_salary
from dept d
inner join employee e on e.dept_id = d.dep_id
group by d.dep_name;


select * from employee;
select * from dept;
-- write a query to print dep names where none of the employees have same salary.
select d.dep_name
from dept d
inner join employee e on d.dep_id =e.dept_id
group by d.dep_name
having count(distinct e.salary) = 1;


select * from orders;
select * from returns;
-- write a query to print sub categories where we have all 3 kinds of returns (others, bad quality , wrong items)
select o.sub_category
from orders o
inner join returns r on o.order_id  = r.order_Id
group by o.sub_category
having count(distinct r.return_reason) = 3;


select * from orders;
select * from returns;
-- write a query to find cities where not even a single order was returned.
select o.city
from orders o
left join returns r on o.order_id = r.order_Id
group by o.city
having count(r.order_id)=0;


select * from orders;
select * from returns;
-- write a query to find top 3 subcategories by sales of returned orders in east region
select top 3 o.sub_category,
sum(o.sales) as total_sales
from orders o
inner join returns r on o.order_id = r.order_Id
where region = 'East'
group by o.sub_category
order by total_sales desc;


select * from dept;
select * from employee;
-- write a query to print dep name for which there is no employee
select d.dep_id, d.dep_name
from dept d
left join employee e on d.dep_id = e.dept_id
where e.emp_name is null
group by d.dep_id, d.dep_name;


select * from dept;
select * from employee;
-- write a query to print employees name for dep id is not available in dept table
select e.emp_name
from employee e
left join dept d on e.dept_id = d.dep_id
where d.dep_id is null;
