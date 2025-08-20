# Retail Sales Analysis SQL Project

## Project Overview

**Project Title**: Retail Sales Analysis  
**Level**: Beginner  
**Database**: `SQL - Retail Sales Analysis_utf`

This project is designed to demonstrate SQL skills and techniques typically used by data analysts to explore, clean, and analyze retail sales data. The project involves setting up a retail sales database, performing exploratory data analysis (EDA), and answering specific business questions through SQL queries. This project is ideal for those who are starting their journey in data analysis and want to build a solid foundation in SQL.

## Objectives

1. **Set up a retail sales database**: Create and populate a retail sales database with the provided sales data.
2. **Data Cleaning**: Identify and remove any records with missing or null values.
3. **Exploratory Data Analysis (EDA)**: Perform basic exploratory data analysis to understand the dataset.
4. **Business Analysis**: Use SQL to answer specific business questions and derive insights from the sales data.

## Project Structure

### 1. Database Setup

- **Database Creation**: The project starts by creating a database named `SQL - Retail Sales Analysis_utf `.
The database contains several records of transaction ID, sale date, sale time, customer ID, gender, age, product category, quantity sold, price per unit, cost of goods sold (COGS), and total sale amount.

select *
from dbo.[SQL - Retail Sales Analysis_utf ]

### 2. Data Exploration & Cleaning

- **Record Count**: Determine the total number of records in the dataset.
Select count(*)
from dbo.[SQL - Retail Sales Analysis_utf ]
- **Customer Count**: Find out how many unique customers are in the dataset.
Select count(distinct(customer_id)) as Total_Customer
from dbo.[SQL - Retail Sales Analysis_utf ]

- **Category Count**: Identify all unique product categories in the dataset.
Select count(distinct(category)) as Total_Category
from dbo.[SQL - Retail Sales Analysis_utf ]
Select distinct(category) as Category_type
from dbo.[SQL - Retail Sales Analysis_utf ]

- **Null Value Check**: Check for any null values in the dataset and delete records with missing data.
select *
from dbo.[SQL - Retail Sales Analysis_utf ]
where 
	transactions_id is NULL
	or quantiy is NULL

----Delete records with NUll values----------------------------------
Delete 
from dbo.[SQL - Retail Sales Analysis_utf ]
where 
	transactions_id is NULL
	or quantiy is NULL

### 3. Data Analysis & Findings

The following SQL queries were developed to answer specific business questions:

1. **Write a SQL query to retrieve all columns for sales made on '2022-11-0.**:
Select *
from dbo.[SQL - Retail Sales Analysis_utf ]
where sale_date = '2022-11-05'

2.**Write a SQL query to retrieve all transactions where the category is clothing and the quantity sold is more than 4 in the month of Nov-2022?**:
Select * 
from dbo.[SQL - Retail Sales Analysis_utf ]
where category = 'Clothing'
	and (CAST(DATEPART(YEAR, sale_date) AS VARCHAR(4)) + '-' +
		RIGHT('0' + CAST(DATEPART(MONTH, sale_date) AS VARCHAR(2)), 2)) = '2022-11'
	and quantiy >= 4
 
3. **Write a SQL query to calculate the total sales (total_sale) for each category.**:
Select category, sum(total_sale) as TotalSalesByCategory
from dbo.[SQL - Retail Sales Analysis_utf ]
group by category

4. **Write a SQL query to find the average age of customers who purchased items from the beauty category.**:
Select AVG(age) as Average_age
from dbo.[SQL - Retail Sales Analysis_utf ]
where category = 'Beauty'
and age is not null

5. **Write a SQL query to find all transactions where the total_sale is greater than 1000.**:
Select *
from dbo.[SQL - Retail Sales Analysis_utf ]
where total_sale > 1000
   
6. **Write a SQL query to find the total number of transactions (transaction_id) made by each gender in each category.**:
Select category, gender, count(transactions_id) as TotalTransaction
from dbo.[SQL - Retail Sales Analysis_utf ]
group by category, gender
order by 1

7. **Write a SQL query to calculate the average sale for each month. Find out best-selling month in each year.**:
WITH Best_Selling_Month AS(
	SELECT
		YEAR(sale_date) AS year_val,
		MONTH(sale_date) AS month_val,
		AVG(total_sale) AS AvgSales,
		RANK() OVER (PARTITION BY YEAR(sale_date) ORDER BY AVG(total_sale) DESC) AS RankByAvgSale
	FROM
		dbo.[SQL - Retail Sales Analysis_utf ]
	GROUP BY
		YEAR(sale_date),
		MONTH(sale_date) 
)

Select  year_val, month_val, AvgSales
	FROM Best_Selling_Month 
	WHERE RankByAvgSale = 1
 
8. **Write a SQL query to find top 5 customers based on the highest total sales.**:
WITH TOP_5_Customers AS(
	Select customer_id, sum(total_sale) as TotalSalesByCustomer
	from dbo.[SQL - Retail Sales Analysis_utf ]
	group by customer_id
--	ORDER BY  2 DESC
)

SELECT TOP 5 customer_id, TotalSalesByCustomer
from TOP_5_Customers
order by TotalSalesByCustomer DESC

9. **Write a SQL query to find the number of unique customers who purchased items from each category.**:
Select category, count(DISTINCT customer_id) as Count_Unique_Customers
from dbo.[SQL - Retail Sales Analysis_utf ]
group by category

10. **Write a SQL query to create each shift and number of orders (Example Morning <12, Afternoon Between 12 & 17, Evening >17)**:
WITh Hourly_Sale AS(
SELECT 
    CASE
        WHEN CAST(sale_time AS TIME) >= '06:00:00' AND CAST(sale_time AS TIME) < '12:00:00' THEN 'Morning'
        WHEN CAST(sale_time AS TIME) >= '12:00:00' AND CAST(sale_time AS TIME) < '18:00:00' THEN 'Afternoon'
        ELSE 'Evening'
    END AS Shift
FROM
    dbo.[SQL - Retail Sales Analysis_utf ]
)

SELECT shift, count(*) as total_orders
FROM Hourly_Sale
group by shift 
    
## Findings

- **Customer Demographics**: The dataset includes customers from various age groups, with sales distributed across different categories such as Clothing, Beauty and Electronics.
- **High-Value Transactions**: Several transactions had a total sale amount greater than 1000, indicating premium purchases.
- **Sales Trends**: Monthly analysis shows variations in sales, helping identify peak seasons.
- **Customer Insights**: The analysis identifies the top-spending customers and the most popular product categories.

## Reports

- **Sales Summary**: A detailed report summarizing total sales, customer demographics, and category performance.
- **Trend Analysis**: Insights into sales trends across different months and shifts.
- **Customer Insights**: Reports on top customers and unique customer counts per category.

## Conclusion

This project serves as a comprehensive introduction to SQL for data analysts, covering database setup, data cleaning, exploratory data analysis, and business-driven SQL queries. The findings from this project can help drive business decisions by understanding sales patterns, customer behaviour, and product performance.

## How to Use

1. **Clone the Repository**: Clone this project repository from GitHub.
2. **Set Up the Database**: Run the SQL scripts provided in the `database_setup.sql` file to create and populate the database.
3. **Run the Queries**: Use the SQL queries provided in the `analysis_queries.sql` file to perform your analysis.
4. **Explore and Modify**: Feel free to modify the queries to explore different aspects of the dataset or answer additional business questions.

## Author - Rengina Rahman

This project is part of my portfolio, showcasing the SQL skills essential for data analyst roles. If you have any questions, feedback, or would like to collaborate, feel free to get in touch!

Thank you for your support, and I look forward to connecting with you!
