---View the dataset
select *
from dbo.[SQL - Retail Sales Analysis_utf ]

---Verify the number of records 
Select count(*)
from dbo.[SQL - Retail Sales Analysis_utf ]

----Data Cleaning----------------------------------------
----Check NUll values------------------------------------
select *
from dbo.[SQL - Retail Sales Analysis_utf ]
where 
	transactions_id is NULL
	or quantity is NULL

----Delete records with NUll values----------------------------------
Delete 
from dbo.[SQL - Retail Sales Analysis_utf ]
where 
	transactions_id is NULL
	or quantity is NULL

----Data Exploration -----------------------------------------------
----Caculate total sale value--------------------------
Select sum(total_sale) as TotalSales
from dbo.[SQL - Retail Sales Analysis_utf ]

----How many unique customers in total?
Select count(distinct(customer_id)) as Total_Customer
from dbo.[SQL - Retail Sales Analysis_utf ]

---Number of categories and types?
Select count(distinct(category)) as Total_Category
from dbo.[SQL - Retail Sales Analysis_utf ]

Select distinct(category) as Category_type
from dbo.[SQL - Retail Sales Analysis_utf ]

---Data Analysis & Business Key Problem------------------------------------------------------------------- 
---Q1. Write a SQL query to retrieve all columns for sales made on 2022-11-05.
---Q2. Write a SQL query to retrieve all transactions where the category is clothing and the quantity sold is more than 4 in the month of Nov-2022?
---Q3. Write a SQL query to calculate the total sales (total_sale) for each category.
---Q4. Write a SQL query to find the average age of customers who purchased items from the beauty category.
---Q5. Write a SQL query to find all transactions where total_sale is greater than 1000.
---Q6. Write a SQL query to find the total number of transactions made by each gender in each category.
---Q7. Write a SQL query to calculate the average sale for each month. Find out the best-selling month in each year?
---Q8. Write a SQL query to find the top 5 customers based on the highest total sales.
---Q9. Write a SQL query to find the number of unique customers who purchased items from each category.
---Q10. Write a SQL query to create each shift and the number of orders.
--------------------------------------------------------------------------------------------------------------

---Q1. Write a SQL query to retrieve all columns for sales made on 2022-11-05.
Select *
from dbo.[SQL - Retail Sales Analysis_utf ]
where sale_date = '2022-11-05'

---Q2. Write a SQL query to retrieve all transactions where the category is clothing and the quantity sold is more than 4 in the month of Nov-2022
Select * 
from dbo.[SQL - Retail Sales Analysis_utf ]
where category = 'Clothing'
	and (CAST(DATEPART(YEAR, sale_date) AS VARCHAR(4)) + '-' +
		RIGHT('0' + CAST(DATEPART(MONTH, sale_date) AS VARCHAR(2)), 2)) = '2022-11'
	and quantity >= 4

---Q3. Write a SQL query to calculate the total sales (total_sale) for each category.
Select category, sum(total_sale) as TotalSalesByCategory
from dbo.[SQL - Retail Sales Analysis_utf ]
group by category

---Q4. Write a SQL query to find the average age of customers who purchased items from the beauty category.
Select AVG(age) as Average_age
from dbo.[SQL - Retail Sales Analysis_utf ]
where category = 'Beauty'
and age is not null

---Q5. Write a SQL query to find all transactions where total_sale is greater than 1000.
Select *
from dbo.[SQL - Retail Sales Analysis_utf ]
where total_sale > 1000

---Q6. Write a SQL query to find the total number of transactions made by each gender in each category.
Select category, gender, count(transactions_id) as TotalTransaction
from dbo.[SQL - Retail Sales Analysis_utf ]
group by category, gender
order by 1

---Q7. Write a SQL query to calculate the average sale for each month. Find out the best-selling month in each year?
----USE CTE

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

---Q8. Write a SQL query to find the top 5 customers based on the highest total sales.
WITH TOP_5_Customers AS(
	Select customer_id, sum(total_sale) as TotalSalesByCustomer
	from dbo.[SQL - Retail Sales Analysis_utf ]
	group by customer_id
--	ORDER BY  2 DESC
)

SELECT TOP 5 customer_id, TotalSalesByCustomer
from TOP_5_Customers
order by TotalSalesByCustomer DESC

---Q9. Write a SQL query to find the number of unique customers who purchased items from each category.

Select category, count(DISTINCT customer_id) as Count_Unique_Customers
from dbo.[SQL - Retail Sales Analysis_utf ]
group by category

---Q10. Write a SQL query to create each shift and the number of orders in each shift.
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

----End of Project

