select * from orders;
--1. write a query to find premium customers from orders data. 
--premium customers are those who have done more orders than average no of orders per customer.
with prem_cus as
	(select customer_id,
	count(distinct order_id) as no_of_order
	from orders
	group by customer_id)
select * from prem_cus
where no_of_order > (select avg(no_of_order) from prem_cus);


select * from employee;
--2. write a query to find employees whose salary is more than average salary of employees in their department
--using sub query
select *
from employee e
inner join 	(select dept_id,
			avg(salary) as avg_dep_sal
			from employee
			group by dept_id) d  
on e.dept_id = d.dept_id
where e.salary > d.avg_dep_sal;


--using cte
with avg_salary as
	(select dept_id,
	avg(salary) as avg_sal
	from employee
	group by dept_id)
select * from employee e
inner join avg_salary a on e.dept_id = a.dept_id
where e.salary > a.avg_sal;


select * from employee;
--3. write a query to find employees whose age is more than average age of all the employees.
---using subquery---
--with avg age in output
select * 
from employee e1
inner join (select avg(emp_age) as avg_age
		   from employee) e2
on 1=1
where e1.emp_age > e2.avg_age;


--without avg age in output
select * from employee 
where emp_age > (select avg(emp_age) as avg_age from employee);


--with cte
with avg_emp_age as
	(select avg(emp_age) as avg_age
	from employee)
select * from employee e
inner join avg_emp_age a on 1=1
where e.emp_age > a.avg_age;


select * from employee;
--4. write a query to print emp name, salary and dep id of highest salaried employee in each department 
--using subquery
select e.emp_name, e.salary, e.dept_id
from employee e
inner join 	(select dept_id,
			max(salary) as max_sal
			from employee
			group by dept_id) d
on e.dept_id = d.dept_id
where e.salary = d.max_sal;


--using cte
with max_emp_sal as
	(select dept_id,
	max(salary) as max_sal
	from employee
	group by dept_id)
select e.emp_name, e.salary, e.dept_id
from employee e
inner join max_emp_sal m on e.dept_id = m.dept_id
where e.salary = m.max_sal;


select * from employee;
--5. write a query to print emp name, salary and dep id of highest salaried overall
--using subquery
select e.emp_name, e.salary, e.dept_id
from employee e
inner join (select max(salary) as max_sal
			from employee) d
on 1 = 1
where e.salary = d.max_sal;

--without joins
select * from employee 
where salary = (select max(salary) from employee)

--using cte
with max_emp_sal as 
	(select max(salary) as max_sal
	from employee) 
select e.emp_name, e.salary, e.dept_id
from employee e
inner join max_emp_sal m on 1=1
where e.salary = m.max_sal;


select * from orders;
--6. write a query to print product id and total sales of highest selling products 
--(by no of units sold) in each category
with product_quantity as
	(select product_id, category,
	 sum(quantity) as total_quantity
	 from orders
	 group by product_id, category),
	 cat_max_quantity as
	 (select category,
	 max(total_quantity) as max_quantity
	 from product_quantity
	 group by category)
select * from product_quantity p
inner join cat_max_quantity c on p.category=c.category
where p.total_quantity  = c.max_quantity



--7. https://www.namastesql.com/coding-problem/8-library-borrowing-habits
CREATE TABLE Books 
(
    BookID INT,
    BookName VARCHAR(30),
    Genre VARCHAR(20)
);

INSERT INTO Books (BookID, BookName, Genre) VALUES
(1, 'The Great Gatsby', 'Fiction'),
(2, 'To Kill a Mockingbird', 'Fiction'),
(3, '1984', 'Fiction'),
(4, 'The Catcher in the Rye', 'Fiction'),
(5, 'Pride and Prejudice', 'Romance'),
(6, 'Romeo and Juliet', 'Romance'),
(7, 'The Notebook', 'Romance'),
(8, 'The Hunger Games', 'Science Fiction'),
(9, 'Dune', 'Science Fiction'),
(10, 'Foundation', 'Science Fiction');

CREATE TABLE Borrowers 
(
    BorrowerID INT,
    BorrowerName VARCHAR(10),
    BookID INT
);

INSERT INTO Borrowers (BorrowerID, BorrowerName, BookID) VALUES
(1, 'Alice', 1),
(2, 'Bob', 2),
(3, 'Charlie', 3),
(4, 'David', 4),
(5, 'Eve', 5),
(6, 'Frank', 6),
(7, 'Grace', 7),
(1, 'Alice', 5),
(2, 'Bob', 6),
(3, 'Charlie', 7),
(4, 'David', 8),
(6, 'Frank', 10),
(8, 'Harry', 2),
(9, 'Ivy', 3);

select * from Books;
select * from Borrowers;
--Write an SQL query to display the name of each borrower along with a comma-separated list of the books
--they have borrowed in alphabetical order, display the output in ascending order of Borrower Name.
with cte as
	(select br.BorrowerName, bo.BookName
	from Borrowers br
	inner join Books bo on br.BookID = bo.BookID)
select BorrowerName,
string_agg(bookname, ', ') within group (order by bookname asc) as books_borrowed
from cte
group by borrowerName;


--8. https://www.namastesql.com/coding-problem/52-loan-repayment
create table loans
(
	loan_id int,
	customer_id int,
	loan_amount int,
	due_date date
);

INSERT INTO Loans (loan_id, customer_id, loan_amount, due_date) VALUES
(1, 1, 5000.00, '2023-01-15'),
(2, 2, 8000.00, '2023-02-20'),
(3, 3, 10000.00, '2023-03-10'),
(4, 4, 6000.00, '2023-04-05'),
(5, 5, 7000.00, '2023-05-01');


create table payments
(
	amount_paid int,
	loan_id int,
	payment_date date,
	payment_id int
)

INSERT INTO payments VALUES
(1, 1, '2023-01-10', 2000.00),
(2, 1, '2023-02-10', 1500.00),
(3, 2, '2023-02-20', 8000.00),
(4, 3, '2023-04-20', 5000.00),
(5, 4, '2023-03-15', 2000.00),
(6, 4, '2023-04-02', 4000.00),
(7, 5, '2023-04-02', 4000.00),
(8, 5, '2023-05-02', 3000.00);

select * from loans;
select * from payments;
/*
Write an SQL query to create 2 flags for each loan as per below rules. 
Display loan id, loan amount, due date and the 2 flags.
1- fully_paid_flag: 1 if the loan was fully repaid irrespective of payment date else it should be 0.
2- on_time_flag : 1 if the loan was fully repaid on or before due date else 0.
*/
select l.loan_id, l.loan_amount, l.due_date
from loans l
inner join (select loan_id,
				   case when 1 = 1 then 1 else 0 end as fully_paid_flag,
				   case when payment_date <= due_date then 1 else 0 end on_time_flag
			from payments) p 
on l.loan_id = p.loan_id

SELECT l.loan_id, l.loan_amount, l.due_date,
case when sum(p.amount_paid) = l.loan_amount then 1 else 0 end as fully_paid_flag,
case when sum(case when p.payment_date <= l.due_date then p.amount_paid end) = l.loan_amount then 1 else 0 end as on_time_flag 
from loans l
left join payments p on l.loan_id = p.loan_id
group by l.loan_id, l.loan_amount, l.due_date
order by l.loan_id;


--9. https://www.namastesql.com/coding-problem/55-lowest-price
create table products
(
	category varchar(10),
	id int,
	name varchar(20),
	price int
);

INSERT INTO products (id, name, category, price) VALUES
(1, 'Cripps Pink', 'apple', 10.00),
(2, 'Navel Orange', 'orange', 12.00),
(3, 'Golden Delicious', 'apple', 6.00),
(4, 'Clementine', 'orange', 14.00),
(5, 'Pinot Noir', 'grape', 20.00),
(6, 'Bing Cherries', 'cherry', 36.00),
(7, 'Sweet Cherries', 'cherry', 40.00);

create table purchases
(
	id int,
	product_id int,
	stars int
);

INSERT INTO purchases (id, product_id, stars) VALUES
(1, 1, 2),
(2, 3, 3),
(3, 2, 2),
(4, 4, 4),
(5, 6, 5),
(6, 6, 4),
(7, 7, 5);

select * from products;
select * from purchases;
/*
For each category, 
find the lowest price among all products that received at least one 4-star or above rating from customers.
If a product category did not have any products that received at least one 4-star or above rating, 
the lowest price is considered to be 0. 
The final output should be sorted by product category in alphabetical order.
*/
select p.category,
coalesce(min(case when pur.product_id is not null then price end), 0) as price
from products p
left join purchases pur on p.id = pur.product_id and pur.stars in (4,5)
group by category
order by category;
