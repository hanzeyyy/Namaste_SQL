-- ===============================
-- VIEWS
-- ===============================

-- Simple view on orders
CREATE VIEW dbo.orders_view AS 
SELECT * FROM dbo.orders;

-- Summary view by hierarchy
CREATE VIEW dbo.orders_summary_view AS
SELECT 
    'category' AS hierarchy_type, 
    category AS hierarchy_name,
    SUM(CASE WHEN region = 'West' THEN sales ELSE 0 END) AS total_sales_in_west_region,
    SUM(CASE WHEN region = 'East' THEN sales ELSE 0 END) AS total_sales_in_east_region
FROM dbo.orders
GROUP BY category

UNION ALL

SELECT 
    'sub_category' AS hierarchy_type, 
    sub_category AS hierarchy_name,
    SUM(CASE WHEN region = 'West' THEN sales ELSE 0 END) AS total_sales_in_west_region,
    SUM(CASE WHEN region = 'East' THEN sales ELSE 0 END) AS total_sales_in_east_region
FROM dbo.orders
GROUP BY sub_category

UNION ALL

SELECT 
    'ship_mode' AS hierarchy_type, 
    ship_mode AS hierarchy_name,
    SUM(CASE WHEN region = 'West' THEN sales ELSE 0 END) AS total_sales_in_west_region,
    SUM(CASE WHEN region = 'East' THEN sales ELSE 0 END) AS total_sales_in_east_region
FROM dbo.orders
GROUP BY ship_mode;

-- ===============================
-- CONSTRAINTS & KEYS
-- ===============================

-- Ensure dept.dep_id is NOT NULL and PRIMARY KEY
ALTER TABLE dbo.dept 
    ALTER COLUMN dep_id INT NOT NULL;
ALTER TABLE dbo.dept 
    ADD CONSTRAINT PK_dept PRIMARY KEY (dep_id);

-- Employee table with foreign key to dept
CREATE TABLE dbo.emp (
    emp_id INT PRIMARY KEY,
    emp_name VARCHAR(50),
    dept_id INT,
    CONSTRAINT FK_emp_dept FOREIGN KEY (dept_id) REFERENCES dbo.dept(dep_id)
);

-- Examples of inserting data
INSERT INTO dbo.dept VALUES (500, 'Operations');
INSERT INTO dbo.emp VALUES (1, 'Hanzeyyy', 500);

-- ===============================
-- IDENTITY EXAMPLE
-- ===============================

CREATE TABLE dbo.dept1 (
    id INT IDENTITY(1,1) PRIMARY KEY,
    dep_id INT,
    dep_name VARCHAR(50)
);

INSERT INTO dbo.dept1(dep_id, dep_name) VALUES (100, 'HR');
INSERT INTO dbo.dept1(dep_id, dep_name) VALUES (200, 'Analytics');
INSERT INTO dbo.dept1(dep_id, dep_name) VALUES (300, 'IT');
