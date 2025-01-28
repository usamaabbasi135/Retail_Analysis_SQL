--Retail Sales Analysis Project
CREATE DATABASE retail_sales;

ALTER TABLE 
	retail_sale 
RENAME
	COLUMN
		quantiy
		TO
		quantity;

-- Creating table retail_sales
CREATE TABLE retail_sale
						(
						transactions_id	INT PRIMARY KEY,
						sale_date DATE,
						sale_time TIME,
						customer_id	INT,
						gender VARCHAR(15),
						age	INT,
						category VARCHAR(25),
						quantiy	INT,
						price_per_unit FLOAT,
						cost FLOAT,
						total_sale FLOAT
						);

-- Data Cleaning

-- Exploring Table after creation
SELECT 
	* 
FROM 
	retail_sale;


-- Count of Total Records
SELECT 
	COUNT(*)
FROM
	retail_sale;

-- We have total of 2000 records.


-- Checking null values in all columns

SELECT 
	*
FROM
	retail_sale
WHERE 
	transactions_id IS NULL;


-- We don't have any entry with null transaction id.


SELECT 
	*
FROM
	retail_sale
WHERE 
	sale_date IS NULL;

-- We don't have any entry with null sale_date


SELECT 
	*
FROM
	retail_sale
WHERE 
	sale_time IS NULL;

-- We don't have any entry with null sale_time

SELECT 
	*
FROM
	retail_sale
WHERE 
	customer_id IS NULL;

-- We don't have any entry with null customer_id


SELECT 
	*
FROM
	retail_sale
WHERE 
	gender IS NULL;

-- We don't have any entry with null gender

SELECT 
	*
FROM
	retail_sale
WHERE 
	age IS NULL;

-- We have 1o records where age is NULL

SELECT 
	*
FROM
	retail_sale
WHERE 
	category IS NULL;

-- We don't have any entry with null category

SELECT 
	*
FROM
	retail_sale
WHERE 
	quantity IS NULL;

-- We have 3 records where quantity is NULL

SELECT 
	*
FROM
	retail_sale
WHERE 
	price_per_unit IS NULL;

-- We have 3 records where price_per_unit is NULL

SELECT 
	*
FROM
	retail_sale
WHERE 
	cost IS NULL;

-- We have 3 records where cost is NULL

SELECT 
	*
FROM
	retail_sale
WHERE 
	total_sale IS NULL;

-- We have 3 records where total_sale is NULL


-- Deleting the records with null values in quantity,price,cost and total sales as they are not giving any information for analysis

DELETE  FROM 
	retail_sale
WHERE
	transactions_id IS NULL
	OR
	sale_date IS NULL
	OR
	sale_time IS NULL
	OR
	customer_id IS NULL
	OR
	gender IS NULL
	OR
	category IS NULL
	OR
	quantity IS NULL
	OR
	price_per_unit IS NULL
	OR
	cost IS NULL
	OR
	total_sale IS NULL;

-- Data Exploration
-- How many sales are there? 1997 total sales record
SELECT 
	COUNT(transactions_id)
AS
	total_sales_record
FROM
	retail_sale;

-- How many UNIQUE customers are there? 155 Customers
SELECT
	COUNT(DISTINCT customer_id)
AS
	total_customers
FROM
	retail_sale;

-- How many categories are there?
SELECT
	DISTINCT 
	category
	AS
	Category_List
FROM
	retail_sale;
	
-- Data Analysis as per Business needs

-- List all the sales made on 5th November 2022

SELECT 
	*
FROM
	retail_sale
WHERE
	sale_date = '2022-11-05';


-- Compare the sales of clothing in the month of november for every year.
SELECT 
	category, SUM(Quantity) AS 
	Product_Sold_Count,
	EXTRACT(MONTH FROM sale_date) 
	AS month,
	EXTRACT(Year FROM sale_date) 
	AS year
FROM
	retail_sale
GROUP BY 
	EXTRACT(Year FROM sale_date),EXTRACT(MONTH FROM sale_date),category
HAVING category = 'Clothing'  AND SUM(Quantity) > 10 AND EXTRACT(MONTH FROM sale_date) = 11
ORDER BY year, month asc;

-- List all the sales records where category is clothing and quantity is more than 3 in the month of november 11 Records

SELECT 
	*
FROM
	retail_sale
WHERE 
	category = 'Clothing'
	AND
	TO_CHAR(sale_date, 'YYYY-MM') = '2022-11'
	AND 
	quantity > 3;



-- Calculate total orders and sales for each category
SELECT
	category,
	SUM(total_sale) as Total_Sales,
	Count(transactions_id) as Quantity
FROM
	retail_sale
group by category;

--Calculate the average age of customers who purchased items from the 'Beauty' category

SELECT 
	category, 
	ROUND(AVG(age),2) as Average_Age
FROM
	retail_sale
GROUP BY 
	category
HAVING
	category = 'Beauty'
;

-- List down all transactions where sale are greater than 1000.
SELECT 
	*
FROM
	retail_sale
WHERE 
	total_sale > 1000;

-- Calculate the total number of transacetion per gender per category
SELECT 
	category,
	gender,
	COUNT(transactions_id) as Number_Of_Transactions
FROM
	retail_sale
group by 
	category,gender
ORDER by 
	gender;



-- Calculate average sale for each month. Find out the best selling month in each year.
WITH temp AS
(SELECT
	EXTRACT(YEAR FROM sale_date) As Year,
	EXTRACT (MONTH FROM sale_date) As Month,
	ROUND(AVG(total_sale)) As Average_Sales_Month,
	RANK () OVER (
		PARTITION BY 
		EXTRACT (YEAR FROM sale_date)
		ORDER BY 
		ROUND(AVG(total_sale)),
		EXTRACT (MONTH FROM sale_date)
	) Ranking
FROM 
	retail_sale
GROUP BY
	EXTRACT 
	(YEAR FROM sale_date),
	EXTRACT
	(MONTH FROM sale_date)
)
SELECT 
	Year, 
	Month, 
	Average_Sales_Month
FROM 
	temp 
WHERE 
ranking = 12;


-- Find top 5 customers based on the sales value

SELECT * FROM 
(
				SELECT 
					customer_id, 
					SUM(total_sale) as Total_Revenue_From_Customer,
					ROW_NUMBER() OVER (
				     ORDER BY SUM(total_sale) desc
					) Row_Number
				FROM 
					retail_sale
				GROUP by 
					customer_id
				ORDER BY 
				2 desc
) WHERE Row_Number <=5;


-- Find number of unique customers who purchased items from each category.

SELECT COUNT(*) 
FROM 
	(
		SELECT COUNT(*) 
		FROM
			   (SELECT category, customer_id, SUM(total_sale) 
				FROM 
					retail_sale
				GROUP BY 1,2
				ORDER BY customer_id)
		GROUP BY customer_id 
		HAVING COUNT(customer_id) = 3
	);


-- Find out number of orders during each shift. (Morning <= 12 , Afternoon Between 12 & 17, Evening > 17)

SELECT  
	CASE 
 		WHEN sale_time < '11:59:00' THEN 'Morning'
		WHEN sale_time > '12:00:00' AND sale_time < '17:00:00' THEN 'Afternoon'
		ELSE 'Evening'
		END as 
	Shift_Time,
COUNT(*)
FROM 
retail_sale 
GROUP BY 1;

