-- 1.View the first few rows to understand structure and content
SELECT *
FROM brightcoffee
LIMIT 10;

-- 2.Count total rows in the dataset
SELECT COUNT(*) AS total_rows
FROM brightcoffee;

-- 3.Check for NULL values across important columns
SELECT 
  COUNT(*) - COUNT(transaction_id) AS missing_transaction_id,
  COUNT(*) - COUNT(transaction_date) AS missing_transaction_date,
  COUNT(*) - COUNT(transaction_time) AS missing_transaction_time,
  COUNT(*) - COUNT(transaction_qty) AS missing_transaction_qty,
  COUNT(*) - COUNT(store_id) AS missing_store_id,
  COUNT(*) - COUNT(product_id) AS missing_product_id,
  COUNT(*) - COUNT(unit_price) AS missing_unit_price
FROM brightcoffee;

-- 4.Identify duplicate transaction IDs
SELECT transaction_id, COUNT(*) AS count
FROM brightcoffee
GROUP BY transaction_id
HAVING COUNT(*) > 1;

-- 5.Check for invalid quantities (e.g. zero or negative)
SELECT *
FROM brightcoffee
WHERE transaction_qty <= 0;

-- 6.Check for invalid pricing
SELECT *
FROM brightcoffee
WHERE unit_price <= 0;

-- 7.View unique store locations
SELECT DISTINCT store_location
FROM brightcoffee;

-- 8.View unique product types
SELECT DISTINCT product_type
FROM brightcoffee;

-- 8.Find earliest and latest transaction dates
SELECT 
  MIN(transaction_date) AS start_date,
  MAX(transaction_date) AS end_date
FROM brightcoffee;

-- 9.Check time range and confirm formatting
SELECT 
  MIN(transaction_time) AS earliest_time,
  MAX(transaction_time) AS latest_time
FROM brightcoffee;

-- 10.Calculate total revenue
SELECT 
  SUM(transaction_qty*unit_price) AS total_revenue
FROM brightcoffee;

-- 11.Revenue per category
SELECT 
  product_category,
  SUM(transaction_qty * unit_price) AS revenue
FROM brightcoffee
GROUP BY product_category
ORDER BY revenue DESC;

-- 12.Total quantity sold per store
SELECT 
  store_location,
  SUM(transaction_qty) AS total_quantity
FROM brightcoffee
GROUP BY store_location;

-- 13.Daily revenue trend
SELECT 
  transaction_date,
  SUM(transaction_qty * unit_price) AS daily_revenue
FROM brightcoffee
GROUP BY transaction_date
ORDER BY transaction_date;

-- 14.Checking lowest and highest unit price
SELECT 
MIN(unit_price) AS Lowest_price,
MAX(unit_price)  AS Lowest_price
FROM brightcoffee;

-- 15.Extracting the day and the month names
SELECT
Transaction_date,
Dayname(transaction_date) AS Day_name,
Monthname(transaction_date) AS Month_name
FROM brightcoffee;

-- 16. Adding extra columns for further analysis
-- Standardized all column names to consistently start with lowercase letters to avoid inconsistency.
SELECT
Transaction_id AS transaction_id,
Transaction_date AS transaction_date,
Transaction_time AS transaction_time,
Transaction_qty AS transaction_qty,
store_id,
store_location,
product_id,
unit_price,
product_category,
product_type,
product_detail,
-- Adding 3 columns to enhance the table for better insights
-- New columns added
Dayname(transaction_date) AS day_name,
Monthname(transaction_date) AS month_name,
Dayofmonth(transaction_date) AS day_of_month,

--4th column added
CASE
    WHEN Dayname(transaction_date) IN ('Saturday', 'Sunday') THEN 'Weekend'
ELSE 'Weekday'
END AS day_classification,

-- 5th column added
CASE 
    WHEN date_format(transaction_time, 'HH:mm:ss') BETWEEN '05:00:00' AND '08:59:59' THEN 'Morning Peak'
    WHEN date_format(transaction_time, 'HH:mm:ss') BETWEEN '09:00:00' AND '11:59:59' THEN 'Late Morning'
    WHEN date_format(transaction_time, 'HH:mm:ss') BETWEEN '12:00:00' AND '14:59:59' THEN 'Lunch'
    WHEN date_format(transaction_time, 'HH:mm:ss') BETWEEN '15:00:00' AND '17:59:59' THEN 'Afternoon'
    WHEN date_format(transaction_time, 'HH:mm:ss') BETWEEN '18:00:00' AND '21:00:00' THEN 'Evening'
ELSE 'Off Hours'
END AS time_classification,

-- 6th Column added
CASE 
    WHEN (transaction_qty * unit_price) <= 50 THEN 'Low Spend'
    WHEN (transaction_qty * unit_price) <= 200 THEN 'Medium Spend'
    WHEN (transaction_qty * unit_price) <= 300 THEN 'High Spend'
    ELSE 'Premium Spend'
END AS spend_category,

-- 7th column added
Transaction_qty * unit_price AS revenue
FROM brightcoffee;
