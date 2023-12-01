# SalesAndEmployeeAnalytics
## Introduction
This project was created in order to strengthen my skills and applications of SQL’s Window functions in a real-world context. The investigation conducted involves a 5-table database containing operational details of a shopping center. This includes employee, sales, and operational data.

> ## Dataset Table Columns
> ### Customers
>
> - customer_id	[PK]: Unique customer identifier
> - bracket_cust_id:	Customer ID with parenthesis
> - customer_name:	Name of the customer
> - segment:	The segment category the customer belongs to
> - age: Age of the customer
> - country:	Country customer resides in
> - city:	City customer resides in

> ### Department
>
> - department	[PK]: retail departments type Clothing, Furniture, Computers etc.
> - division:	Division of the department (Home, Electronics, Health etc.)

> ### Employees
>
> - employee_id	[PK]: Unique employee identifier
> - first_name:	First name of the employee
> - last_name	Last name of the employee
> - email	Email of employee
> - hire_date	Hire date of the employee
> - department	Department Employee belongs to
> - gender	Gender of Employee
> - salary	Salary of emplyoee
> - region_id	Region number employee belongs to

> ### Region
>
> - region_id	[PK] Unique region identifier
> - region	Region: Southwest, Northeast, East Asia etc.
> - country	Country of the region

> ### Sales
>
> - order_line	The line the order is in
> - order_id	The unique ID of the order
> - order_date	Date order was placed
> - ship_date	The date the order was shipped
> - ship_mode	The shipping option chosen for the order
> - customer_id	The customer ID who placed the order
> - product_id	The id of the product in the order
> - category	The category of the item in the order
> - sub_category	The more specificsub category of the item in the order
> - sales	The sale amount of the order in USD
> - quantity	The quantity of the items purchased in the order 
> - discount	The discount rate applied to the order
> - profit	The overall profits gained from the order

Guiding Questions
- How do individual employee salaries differ between departments?
- Max Min?
- Rank?
- Running Totals and Running Averages

- What are customer purchase habits?
  - Purchases based on:
  - Departments
  - Quantities
  - Shipping Modes
  
- How are sales outcomes tied to customer purchasing habits?
  - Profits/Sales numbers based on:
  - Department
  - Division
  - Shipping Mode
  - Yearly Trends
