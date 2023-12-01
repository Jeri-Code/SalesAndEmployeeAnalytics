############################# 
-- Window Function Customer, Employee, Sales Data Analysis
############################# 

-- Retrieve all the data in the projectdb database

SELECT *
FROM employees;

SELECT *
FROM departments;

SELECT *
FROM regions;

SELECT *
FROM customers;

SELECT *
FROM sales;

#############################
-- Task 1
-- ROW_NUMBER()
-- Investigating Employee and HR related data
############################# 

-- 1.1
-- ROW_NUMBER()
-- Retrieve a list of employee_id, first_name, hire_date,
-- and department of all employees ordered by the hire date

SELECT employee_id,
	first_name,
	department,
	hire_date,
	ROW_NUMBER() OVER (ORDER BY hire_date) AS row_n
FROM employees;


-- 1.2
-- ROW_NUMBER() PARTITION BY
-- Retrieve the employee_id, first_name,
-- hire_date of employees for different departments

SELECT employee_id,
	first_name,
	department,
	hire_date,
	ROW_NUMBER() OVER (PARTITION BY department
						ORDER BY hire_date) AS row_n
FROM employees;


############################# 
-- Task 2
-- RANK()
-- 2.1 - 2.3 Investigating Employee Salary
-- 2.4 Investigating Customer Purchases
############################# 

-- 2.1
-- RANK() PARTITION BY
-- Retrieve a list of employees ordered by rank by department for salary

SELECT first_name,
	email,
	department,
	salary,
	RANK() OVER (PARTITION BY department
				ORDER BY salary DESC) AS pos
FROM employees;


-- 2.2
-- RANK() WHERE
-- Retrieve the hire_date. Return details of employees hired on or before
-- 31st Dec, 2005 and are in First Aid, Movies and Computers departments

SELECT first_name,
	email,
	department,
	salary,
	hire_date,
	RANK() OVER (PARTITION BY department
					ORDER BY salary DESC) AS pos
FROM employees
WHERE hire_date <= '2005-12-31'
	AND department IN ('First_Aid','Movies','Computers');
	

-- 2.3
-- RANK() Sub-Select
-- Retrieve the fifth ranked salary for each department

SELECT *
FROM
	(SELECT first_name, last_name,
			email,
			department,
			salary,
			hire_date,
			RANK() OVER (PARTITION BY department
							ORDER BY salary DESC) AS pos
		FROM employees) AS ss
WHERE pos <= 5;


-- 2.4
-- Difference between ROW_NUMBER, RANK, DENSE_RANK
-- Common table expression to retrieve the customer_id, 
-- and how many times the customer has purchased from the mall

WITH purchase_count AS
	(SELECT customer_id,
			COUNT (sales) AS purchase
		FROM sales
		GROUP BY customer_id
		ORDER BY purchase DESC;)
SELECT customer_id,
	purchase,
	ROW_NUMBER() OVER (ORDER BY purchase DESC) AS row_n,
	RANK() OVER (ORDER BY purchase DESC) AS rank_n,
	DENSE_RANK() OVER (ORDER BY purchase DESC) AS dense_rank_n
FROM purchase_count
ORDER BY purchase DESC;


#############################
-- Task 3
-- NTILE() Paging
-- Investigating Employee Salaries
#############################

-- 3.1: Grouping
-- Group the employees table into five groups based on the order of their salaries

SELECT first_name,
	department,
	salary,
	NTILE(5) OVER (ORDER BY salary DESC)
FROM employees;


-- 3.2 
-- NTILE Multiple Grouping
-- Group the employees into various group splits

SELECT first_name,
	department,
	salary,
	NTILE(5) OVER (ORDER BY salary DESC) g1,
	NTILE(10) OVER (ORDER BY salary DESC) g2,
	NTILE(100) OVER (ORDER BY salary DESC) g3
FROM employees;

-- 3.3
-- NTILE() PARTITION BY
-- Group the employees table into five groups for
-- each department based on the order of their salaries

SELECT first_name,
	email,
	department,
	salary,
	NTILE(5) OVER (PARTITION BY department
				  	ORDER BY salary DESC)
FROM employees;


-- 3.4 
-- CTE Grouping
-- Group employees into 5 groups based on the order of their salary
-- Find the average salary for each group of employees

WITH salary_ranks AS
	(SELECT first_name,
			email,
			department,
			salary,
			NTILE(5) OVER (ORDER BY salary DESC) AS rank_of_salary
		FROM employees)
SELECT rank_of_salary,
	ROUND(AVG(salary), 2) AS avg_salary
FROM salary_ranks
GROUP BY rank_of_salary
ORDER BY rank_of_salary;


############################# 
-- Task 4 
-- Aggregate Window Functions - Part One
-- COUNT, SUM
#############################

-- 4.1 
-- COUNT() PARTITION BY
-- Retrieve the first names, department and
-- number of employees working in that department

SELECT first_name,
	department,
	COUNT(*) OVER (PARTITION BY department) AS dept_count
FROM employees;

-- Not optimal Subquery method
SELECT first_name,
	department,
	(SELECT COUNT(*) AS dept_count
		FROM employees e1
		WHERE e1.department = e2.department )
FROM employees e2
GROUP BY department,
	first_name
ORDER BY department;


-- 4.2 
-- SUM()
-- Total Salary for all employees

SELECT first_name,
	department,
	hire_date,
	SUM(salary) OVER (ORDER BY hire_date) AS total_salary
FROM employees;


-- 4.3
-- SUM() PARTITION BY
-- Total Salary for each department

SELECT first_name,
	department,
	hire_date,
	salary,
	SUM(salary) OVER (PARTITION BY department) AS total_salary
FROM employees;


-- 4.4
-- Total Salary for each department order running total by hire_date
-- Created Running_total column for each department

SELECT first_name,
	hire_date,
	department,
	salary,
	SUM(salary) OVER (PARTITION BY department
					 	ORDER BY hire_date) AS running_total
FROM employees;


############################# 
-- Task 5
-- Aggregate Window Functions - Part Two
############################# 


-- 5.1
-- COUNT Multiple PARTITION BY 
-- Retrieve the first names, department and
-- number of employees working in that department and region

SELECT first_name,
	department,
	region_id,
	COUNT(*) OVER (PARTITION BY department) AS dept_count,
	COUNT(*) OVER (PARTITION BY region_id) AS region_count
FROM employees;


-- 5.2
-- COUNT PARTITION WHERE
-- Retrieve the first names, department and number of 
-- employees working in that department and in region 2

SELECT first_name,
	department,
	region_id,
	COUNT(*) OVER (PARTITION BY region_id)AS region_count
FROM employees
WHERE region_id = 2;


-- 5.3:
-- Calculate the cumulative sum of customers purchase for the different ship mode

-- Common table expression to retrieve the customer_id,
-- ship_mode, and how many times the customer has purchased from the mall
WITH purchase_count AS
	(SELECT customer_id,
			ship_mode,
			COUNT(sales) AS purchase
		FROM sales
		GROUP BY customer_id, ship_mode
		ORDER BY purchase DESC) 
		
SELECT customer_id,
	ship_mode,
	purchase,
	SUM(purchase) OVER (PARTITION BY ship_mode
						ORDER BY customer_id ASC) AS sum_of_sales
FROM purchase_count;


#############################
-- Task 6
-- Window Frames - Part One
############################# 

-- 6.1
-- RANGE BETWEEN UNBOUNDED PRECEDING AND CURRENT
-- Calculate the running total of salary

SELECT first_name,
	hire_date,
	salary,
	SUM(salary) OVER (ORDER BY hire_date 
					  	RANGE BETWEEN 
						UNBOUNDED PRECEDING 
						AND CURRENT ROW) AS running_total
FROM employees;


-- 6.2
-- ROWS BETWEEN PRECEDING AND CURRENT ROW
-- Add the current row and previous row

SELECT first_name,
	hire_date,
	salary,
	SUM (salary) OVER(ORDER BY hire_date 
					  	ROWS BETWEEN 
						1 PRECEDING 
						AND CURRENT ROW) AS running_total
FROM employees;


-- 6.3 
-- Current and past 2 row salary and takes the average (3 rows)
-- Find the running average

SELECT first_name,
	hire_date,
	salary,
	ROUND(AVG(salary)OVER (ORDER BY hire_date 
						   	ROWS BETWEEN 
							2 PRECEDING 
							AND CURRENT ROW),2) AS running_avg
FROM employees;


############################# 
-- Task 7
-- Window Frames - Part Two
############################# 

-- 7.1
-- FIRST_VALUE, LAST_VALUE
-- Retrieve the FIRST and LAST department in the departments table

SELECT department,
	division,
	FIRST_VALUE(department) OVER(ORDER BY department ASC) AS first_department, 
	LAST_VALUE(department) OVER (ORDER BY department ASC 
								 	RANGE BETWEEN 
								 	UNBOUNDED PRECEDING 
								 	AND UNBOUNDED FOLLOWING) AS last_department
FROM departments;


-- 7.2
-- Retrieve running max and next running max from the total number of purchases
-- customers have made at the mall

WITH purchase_count AS
	(SELECT customer_id,
			count(sales) AS purchase
		FROM sales
		GROUP BY customer_id
		ORDER BY purchase DESC)
SELECT customer_id,
	purchase,
	ship_mode,
	max(purchase) over(ORDER BY customer_id ASC) AS max_of_sales,
	max(purchase) over(ORDER BY customer_id ASC 
					   	ROWS BETWEEN 
					   	CURRENT ROW AND 
					   	1 FOLLOWING) AS next_max_of_sales
FROM purchase_count;


############################# 
-- Task 8
-- GROUPING SETS, ROLLUP() & CUBE()
-- Investigating shipping, sales, and financial data
############################# 
 

-- Find the sum of the quantity for different ship_mode, category and sub_category
-- Find the grand total

-- 8.1 
-- GROUPING SETS


SELECT ship_mode,
	category,
	sub_category,
	SUM(quantity)
FROM sales
GROUP BY GROUPING
SETS (ship_mode,
		category,
		sub_category, ());
		
		
-- 8.2  
-- ROLLUP()

SELECT ship_mode,
	category,
	sub_category,
	SUM(quantity)
FROM sales
GROUP BY ROLLUP (ship_mode, category, sub_category);


-- 8.3 
-- CUBE()

SELECT ship_mode,
	category,
	sub_category,
	SUM(quantity)
FROM sales
GROUP BY CUBE (ship_mode, category, sub_category);