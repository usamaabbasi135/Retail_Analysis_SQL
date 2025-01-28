# Retail_Analysis_SQL
This project demonstrate my SQL skills and techniques used by data analysts to explore, clean, and analyze retail sales data. The project involves setting up a retail sales database, performing exploratory data analysis (EDA), and answering specific business questions through SQL queries.

## Objectives

1. **Set up a retail sales database**: Create and populate a retail sales database with the provided sales data.
2. **Data Cleaning**: Identify and remove any records with missing or null values.
3. **Exploratory Data Analysis (EDA)**: Perform basic exploratory data analysis to understand the dataset.
4. **Business Analysis**: Use SQL to answer specific business questions and derive insights from the sales data.

## Project Structure

### 1. Database Setup

- **Database Creation**: The project starts by creating a database named `retail_sales`.
- **Table Creation**: A table named `retail_sale` is created to store the sales data. The table structure includes columns for transaction ID, sale date, sale time, customer ID, gender, age, product category, quantity sold, price per unit, cost of goods sold (COGS), and total sale amount.

```sql
CREATE DATABASE retail_sales;

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
```

### 2. Data Exploration & Cleaning

- **Record Count**: Determine the total number of records in the dataset.
- **Customer Count**: Find out how many unique customers are in the dataset.
- **Category Count**: Identify all unique product categories in the dataset.
- **Null Value Check**: Check for any null values in the dataset and delete records with missing data.

```sql
SELECT 
	COUNT(*)
FROM
	retail_sale;

SELECT
	COUNT(DISTINCT customer_id)
AS
	total_customers
FROM
	retail_sale;

SELECT
	DISTINCT 
	category
	AS
	Category_List
FROM
	retail_sale;

SELECT *  FROM 
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
```

### 3. Data Analysis & Findings

The following SQL queries were developed to answer specific business questions:

1. **List all the sales made on 5th November 2022**:
```sql
SELECT 
	*
FROM
	retail_sale
WHERE
	sale_date = '2022-11-05';
```

2. **Compare the sales of clothing in the month of november for every year**:
```sql
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
```

3. **List all the sales records where category is clothing and quantity is more than 3 in the month of november 11 Records**:
```sql
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
```

4. **Calculate total orders and sales for each category**:
```sql
SELECT
	category,
	SUM(total_sale) as Total_Sales,
	Count(transactions_id) as Quantity
FROM
	retail_sale
group by category;
```

5. **Calculate the average age of customers who purchased items from the 'Beauty' category**:
```sql
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
```

6. **List down all transactions where sale are greater than 1000**:
```sql
SELECT 
	*
FROM
	retail_sale
WHERE 
	total_sale > 1000;
```

7. **Calculate the total number of transacetion per gender per category**:
```sql
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
```

8. **Calculate average sale for each month. Find out the best selling month in each year**:
```sql
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
```

9. **Find top 5 customers based on the sales value**:
```sql
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
```

10. **Find number of unique customers who purchased items from each category.**:
```sql
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
```

11. **Find out number of orders during each shift. (Morning <= 12 , Afternoon Between 12 & 17, Evening > 17)**:
```sql
SELECT  
	CASE 
 		WHEN sale_time < '12:00:00' THEN 'Morning'
		WHEN sale_time BETWEEN '12:00:00' AND '17:00:00' THEN 'Afternoon'
		ELSE 'Evening'
		END as 
	Shift_Time,
COUNT(*)
FROM 
retail_sale 
GROUP BY 1;
```

## Findings

- **Customer Demographics**: The dataset includes customers from various age groups, with sales distributed across different categories such as Clothing and Beauty.
- **High-Value Transactions**: Several transactions had a total sale amount greater than 1000, indicating premium purchases.
- **Sales Trends**: Monthly analysis shows variations in sales, helping identify peak seasons.
- **Customer Insights**: The analysis identifies the top-spending customers and the most popular product categories.

## Conclusion

This project is covering database setup, data cleaning, exploratory data analysis, and business-driven SQL queries. The findings from this project can help drive business decisions by understanding sales patterns, customer behavior, and product performance.

## How to Use

1. **Clone the Repository**: Clone this project repository from GitHub.
2. **Set Up the Database**: Run the SQL scripts provided in the `Retail Sales Analysis Queries.sql` file to create and populate the database.
3. **Run the Queries**: Use the SQL queries provided in the `Retail Sales Analysis Queries.sql` file to perform your analysis.
4. **Explore and Modify**: Feel free to modify the queries to explore different aspects of the dataset or answer additional business questions.

## Author - Usama Bin Hafeez Abbasi

This project is part of my portfolio, showcasing the SQL skills essential for data analyst roles. If you have any questions, feedback, or would like to collaborate, feel free to get in touch!

## Follow Me

For more content on SQL, data analysis, and other data-related topics, make sure to follow me on social media and join our community:

- **YouTube**: [Subscribe to my channel](https://www.youtube.com/@usamaabbasi7570)
- **LinkedIn**: [Connect with me professionally](https://www.linkedin.com/in/usamaabbasiai/)

Thank you for your support, and I look forward to connecting with you!
