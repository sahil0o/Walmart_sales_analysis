
-- 1) Database creation

CREATE DATABASE IF NOT EXISTS walmart;


-- 2) Table creation

CREATE TABLE sales(
    invoice_id VARCHAR(30) NOT NULL PRIMARY KEY,
    branch VARCHAR(5) NOT NULL,
    city VARCHAR(30) NOT NULL,
    customer_type VARCHAR(30) NOT NULL,
    gender VARCHAR(10) NOT NULL,
    product_line VARCHAR(100) NOT NULL,
    unit_price DECIMAL(10,2) NOT NULL,
    quantity INT NOT NULL,
    VAT DECIMAL(6,4) NOT NULL,
    total DECIMAL(12,4) NOT NULL,
    sale_date DATETIME NOT NULL,
    sale_time TIME NOT NULL,
    payment VARCHAR(15) NOT NULL,
    cogs DECIMAL(10,2) NOT NULL,
    gross_margin_percent DECIMAL(5,4),
    gross_income DECIMAL(12,4) NOT NULL,
    rating DECIMAL(3,1)
);

-- 3) import data from csv file

-- 4) Check if data is imported properly

SELECT * FROM NewTable;

-- 5) adding new column for time of day 

-- part 1 : check if the query is working
SELECT 
	time,
	(CASE
		WHEN `time` BETWEEN "00:00:00" AND "12:00:00" THEN "Morning"
		WHEN `time` BETWEEN "12:00:00" AND "16:00:00" THEN "Afternoon"
		ELSE "Evening"
	END) AS time_of_day 
FROM NewTable;

-- part 2 : create a new column
ALTER TABLE NewTable ADD COLUMN time_of_day VARCHAR(20);

UPDATE NewTable 
SET time_of_day=(CASE
		WHEN `time` BETWEEN "00:00:00" AND "12:00:00" THEN "Morning"
		WHEN `time` BETWEEN "12:00:00" AND "16:00:00" THEN "Afternoon"
		ELSE "Evening"
	END)

-- 6) adding new column day name

-- part 1 : check if the query is working

SELECT
	date,
	DAYNAME(date)
FROM NewTable;

-- part 2 : create a new column
ALTER TABLE NewTable ADD COLUMN day_name VARCHAR(20);

UPDATE NewTable 
SET day_name = DAYNAME(date);

-- 7) adding new column month name
-- part 1 : check if the query is working
SELECT
	date,
	MONTHNAME(date)
FROM NewTable;

-- part 2 : create a new column
ALTER TABLE NewTable ADD COLUMN month_name VARCHAR(20);

UPDATE NewTable 
SET month_name = MONTHNAME(date);

-- steps 5,6,7 can be avoided as time_of_day , day and month can be accessed directly from date. But it helps
-- to visualise data better.

--- Data analysis

-- 1) unique cities

SELECT 
	DISTINCT city
FROM NewTable;

SELECT 
    COUNT(DISTINCT city) AS unique_city_count
FROM NewTable;


-- 2) branches 

SELECT 
    COUNT(DISTINCT branch) AS unique_branch_count
FROM NewTable;


-- 3) which branch in which city 

SELECT 
	DISTINCT city,
	branch
FROM NewTable;

-- 4) Number of branches in each city

SELECT 
    COUNT(branch) as number_of_branches,
    city
FROM NewTable
GROUP BY branch, city
ORDER BY number_of_branches DESC;

-- 5) unique products and number of unique products

-- part 1: Unique products
SELECT 
	DISTINCT Product line
FROM NewTable;

-- part 2 : Number of unique products
SELECT 
	COUNT(DISTINCT Product line) as products
FROM NewTable;

-- 6) most common payment method : Ewallet

-- list of all payment options with their usage count
SELECT 
	payment, 
    COUNT(payment) as payment_count
FROM NewTable
GROUP BY payment
ORDER BY payment_count DESC;

-- if only interested in answer
SELECT 
	payment, 
    COUNT(payment) as payment_count
FROM NewTable
GROUP BY payment
ORDER BY payment_count DESC
LIMIT 1;

-- 7) most selling product : Fashion accessory
SELECT 
	Product_line, 
    COUNT(Product_line) as product_count
FROM NewTable
GROUP BY Product_line
ORDER BY product_count DESC ;

SELECT 
	Product_line, 
    COUNT(Product_line) as product_count
FROM NewTable
GROUP BY Product_line
ORDER BY product_count DESC
LIMIT 1;

-- 8) comparing products on the basis of total sales amount and gross income

SELECT 
	Product_line, 
    COUNT(Product_line) as product_count,
    SUM(gross income) as gross_profit,
    SUM(total) as sales
FROM NewTable
GROUP BY Product_line
ORDER BY revenue DESC , tot DESC;

-- 9) sales and gross income by month 

SELECT 
	month_name,
	SUM(gross income) as gross_profit
	SUM(total) as sales
	FROM NewTable
GROUP BY month_name
ORDER BY revenue DESC;


-- 10) sales and gross income by city

SELECT 
	city,
	SUM(total) as sales,
	SUM(gross income) as gross_profit
	FROM NewTable
GROUP BY city
ORDER BY gross_profit DESC, sales DESC;


-- 11) Comparing Quantity by gender

SELECT 
	Gender,
	COUNT(Quantity) as total_quantity
FROM NewTable
GROUP BY Gender
ORDER BY total_quantity DESC;

-- 12) Comparing sales and gross income by gender
SELECT 
	Gender,
	SUM(total) as sales,
	SUM(gross income) as gross_profit
	FROM NewTable
GROUP BY Gender
ORDER BY gross_profit DESC, sales DESC;


-- 13) sales in each time of day per weekday 

SELECT 
	time_of_day, 
	COUNT(Quantity) as products_sold
FROM NewTable
GROUP BY time_of_day
ORDER By products_sold DESC;


SELECT 
	time_of_day,
	SUM(total) as sales,
	SUM(gross income) as gross_profit
	FROM NewTable
GROUP BY time_of_day
ORDER BY gross_profit DESC, sales DESC;


-- 14) which type of customer type bring more profit 

SELECT 
    SUM(gross income) AS total_revenue,
    Customer type
FROM NewTable
GROUP BY Customer type
ORDER BY total_revenue DESC;



-- 15) which time of day do customer give most ratings 
SELECT 
	time_of_day,
	AVG(rating) as rating
FROM NewTable
GROUP BY time_of_day;
ORDER BY rating DESC;

-- 16) which day has best avg ratings 
SELECT 
	day_name,
	AVG(rating) as rate
FROM NewTable
GROUP BY day_name
ORDER BY rate DESC;

-- 17) Distribution of ratings over cities and days

SELECT 
    city,
    day_name,
    AVG(rating) AS rating
FROM NewTable
GROUP BY day_name, city
ORDER BY 
    FIELD(day_name, 'Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday'),
    city;

-- 18) product vs city

SELECT 
    product_line,
    city,
    COUNT(product_line) AS product_count,
    SUM(gross_income) AS total_revenue  -- Sums the gross income for each product line in each city
FROM NewTable
GROUP BY city, product_line
ORDER BY city, product_count DESC;

-- 19) sales vs day analysis
SELECT 
	(day_name),
	SUM(Total) as sales,
	SUM(gross income) AS total_revenue
FROM NewTable
GROUP BY (day_name)
ORDER BY total_revenue DESC;

SELECT 
	(day_name),
	SUM(Quantity) as Quantity_sold,
	SUM(gross income) AS total_revenue
FROM NewTable
GROUP BY (day_name)
ORDER BY total_revenue DESC;



-- 20) city vs payment method

SELECT 
    city, 
    payment, 
    COUNT(*) AS total_transactions, 
    SUM(gross income) AS total_revenue
FROM NewTable
GROUP BY city, payment
ORDER BY city
