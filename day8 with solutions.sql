--1 https://www.namastesql.com/coding-problem/38-product-reviews
/*
Your task is to write an SQL query to find all product reviews containing the word "excellent" or 
"amazing" in the review text. However, you want to exclude reviews that contain the word 
"not" immediately before "excellent" or "amazing". 
Please note that the words can be in upper or lower case or combination of both. 
Your query should return the review_id,product_id, and review_text for each review meeting the criteria, 
display the output in ascending order of review_id.
*/

create table product_reviews
(
	review_id int,
	product_id int,
	review_text varchar(40)
);

insert into product_reviews values (1, 101, 'The product is excellent!');
insert into product_reviews values (2, 102, 'This product is Amazing.');
insert into product_reviews values (3, 103, 'Not an excellent product');
insert into product_reviews values (4, 104, 'The quality is excellent!');
insert into product_reviews values (5, 105, 'An amazing product!');
insert into product_reviews values (6, 106, 'The is not an amazing product');
insert into product_reviews values (7, 107, 'The product is not excellent!');
insert into product_reviews values (8, 108, 'This is not an excellent product');
insert into product_reviews values (9, 109, 'The product is not amazing');
insert into product_reviews values (10, 110, 'An excellent product, not amazing');
insert into product_reviews values (11, 101, 'A good product');

select * from product_reviews;

select review_id, product_id, review_text
from product_reviews
where (lower(review_text) like '%amazing%' or 
	  lower(review_text) like '%excellent%') and
	  lower(review_text) not like '%not amazing%' and 
	  lower(review_text) not like '%not excellent%'
order by review_id;
	

--2 https://www.namastesql.com/coding-problem/61-category-sales-part-1
CREATE TABLE sales (
    id INT,
    product_id INT,
    category VARCHAR(50),
    amount INT,
    order_date DATE
);

insert into sales (id, product_id, category, amount, order_date) values
(1, 101, 'Electronics', 1500, '2022-02-05'),
(2, 102, 'Electronics', 2000, '2022-02-10'),
(3, 103, 'Clothing', 500, '2022-02-15'),
(4, 104, 'Clothing', 800, '2022-02-18'),
(5, 105, 'Books', 300, '2022-02-25'),
(6, 106, 'Electronics', 1300, '2022-03-08'),
(7, 107, 'Clothing', 600, '2022-03-13'),
(8, 108, 'Books', 400, '2022-03-20'),
(9, 109, 'Electronics', 2200, '2022-04-05'),
(10, 110, 'Clothing', 700, '2022-04-10'),
(11, 111, 'Books', 500, '2022-04-15'),
(12, 112, 'Electronics', 2500, '2022-05-05'),
(13, 113, 'Clothing', 900, '2022-05-10'),
(14, 114, 'Books', 600, '2022-05-15'),
(15, 105, 'Books', 100, '2022-02-25');

select * from sales;

select category,
sum(amount) as total_sales
from sales
where weekday(order_date) between 0 and 4 and
	  order_date between '2022-01-01' and '2022-02-28'  
group by category
order by total_sales;


--3 https://www.namastesql.com/coding-problem/62-category-sales-part-2
CREATE TABLE sales_2 (
    sales_id INT,
    category_id VARCHAR(50),
    amount INT,
    sales_date DATE
);

insert into sales_2 (sales_id, category_id, amount, sales_date) values
(1, 1, 500, '2022-01-05'),
(2, 1, 800, '2022-02-10'),
(4, 3, 200, '2022-02-20'),
(5, 3, 150, '2022-03-01'),
(6, 4, 400, '2022-02-25'),
(7, 4, 600, '2022-03-05');

create table categories 
(
	category_id int,
	category_name varchar(12)
);

insert into categories values 
(1, 'Electronics'), (2, 'Clothing'),
(3, 'Books'), (4, 'Home Decor');

select * from sales_2;
select * from categories;
/*
Write an SQL query to retrieve the total sales amount in each category. 
Include all categories, if no products were sold in a category display as 0. 
Display the output in ascending order of total_sales.
*/
select c.category_name,
sum( case when s.amount is not null then s.amount else 0 end ) as total_sales
from categories c
left join sales_2 s on c.category_id = s.category_id
group by c.category_name
order by total_sales;


--4 https://www.namastesql.com/coding-problem/71-department-average-salary
CREATE TABLE employees_a8 (
    employee_id INT,
    employee_name VARCHAR(100),
    salary INT,
    department_id INT
);

INSERT INTO employees_a8 (employee_id, employee_name, salary, department_id) VALUES
(1, 'John Doe', 50000, 1),
(2, 'Jane Smith', 60000, 1),
(3, 'Alice Johnson', 70000, 2),
(4, 'Bob Brown', 55000, 2),
(5, 'Emily Clark', 48000, 1),
(6, 'Michael Lee', 62000, 3),
(7, 'Sarah Taylor', 53000, 3),
(8, 'David Martinez', 58000, 1),
(9, 'Laura White', 65000, 1),
(10, 'Chris Wilson', 56000, 3);

create table departments_a8 
(
	department_id int,
	department_name varchar(10)
);

insert into departments_a8 values
(1, 'Sales'),(2, 'Marketing'), (3, 'Finance');

select * from employees_a8;
select * from departments_a8;
/*
. Your task is to write a SQL query to find the average salary of employees in each department, 
but only include departments that have more than 2 employees . 
Display department name and average salary round to 2 decimal places. 
Sort the result by average salary in descending order.
*/

select d.department_name,
round(avg(e.salary), 2) as avg_salary
from departments_a8 d
left join employees_a8 e on d.department_id = e.department_id 
group by d.department_name
having count(d.department_id) > 2
order by avg_salary desc;


--5 https://www.namastesql.com/coding-problem/72-product-sales'
create table products_a8
(
	product_id int,
	product_name varchar(10),
	price int
);

insert into products_a8 values
(1, 'Laptop', 800),(2, 'Smartphone', 600),(3, 'Headphones', 50),(4, 'Tablet', 400);

CREATE TABLE sales_a8 (
    sale_id INT PRIMARY KEY,
    product_id INT,
    quantity INT,
    sale_date DATE
);

INSERT INTO sales_a8 (sale_id, product_id, quantity, sale_date) VALUES
(1, 1, 3, '2023-05-15'),
(2, 2, 2, '2023-05-16'),
(3, 3, 5, '2023-05-17'),
(4, 1, 2, '2023-05-18'),
(5, 4, 1, '2023-05-19'),
(6, 2, 3, '2023-05-20'),
(7, 3, 4, '2023-05-21'),
(8, 1, 1, '2023-05-22'),
(9, 2, 4, '2023-05-23'),
(10, 4, 2, '2023-05-24'),
(11, 1, 5, '2023-05-25'),
(12, 2, 1, '2023-05-26'),
(13, 3, 3, '2023-05-27'),
(14, 1, 2, '2023-05-28'),
(15, 4, 3, '2023-05-29'),
(16, 2, 2, '2023-05-30'),
(17, 3, 5, '2023-05-31'),
(18, 1, 4, '2023-06-01'),
(19, 2, 3, '2023-06-02'),
(20, 4, 1, '2023-06-03');

select * from products_a8;
select * from sales_a8;

-- write a SQL query to find the total sales amount for each product. 
-- Display product name and total sales (sort the result by product name)
select p.product_name,
sum(p.price*s.quantity) as total_sales
from products_a8 p
inner join sales_a8 s on p.product_id = s.product_id
group by p.product_name
order by p.product_name;


--6 https://www.namastesql.com/coding-problem/73-category-product-count
create table catgories_a8
(
	category varchar(15),
	products varchar(30)
);

insert into catgories_a8 values
('Electronis', 'TV, Radio, Laptop'), ('Furniture', 'Chair'),
('Clothing', 'Shirt, Pants, Jacket,Shoes'), ('Groceries','Rice, Sugar');

select * from catgories_a8;
--write a SQL query to count the number of products in each category (Sort the result by product count)
select category,
len(products) as length_of_products,
len(replace(products, ',','')) as no_comma_length,
len(products) - len(replace(products, ',','')) + 1 as no_of_products --since products = comma + 1
from catgories_a8
order by no_of_products;


--7 https://www.namastesql.com/coding-problem/103-employee-mentor
create table employee_s_a8 
(
	id int,
	name varchar(10),
	mentor_id int
);

INSERT INTO employee_s_a8 (id, name, mentor_id) VALUES
(1, 'Arjun', NULL),
(2, 'Sneha', 1),
(3, 'Vikram', NULL),
(4, 'Rahul', 3),
(5, 'Priya', 2),
(6, 'Neha', 3),
(7, 'Rohan', 1),
(8, 'Amit', 4);

select * from employee_s_a8;
-- find the names of all employees who were not mentored by the employee with id = 3
select name
from employee_s_a8
where mentor_id != 3 or mentor_id is null;
