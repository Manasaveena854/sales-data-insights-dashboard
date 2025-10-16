
ALTER TABLE sales_data_clean
ALTER COLUMN "Quantity" TYPE NUMERIC;

copy sales_data_clean("OrderID", "OrderDate", "Region", "Product", "Category", "Quantity", "UnitPrice", "Revenue")
FROM '/Users/manasaveena/Desktop/Sales_Data_Insights_Dashboard/sales_data_clean.csv'
DELIMITER ','
CSV HEADER;

-- Check first 10 rows
SELECT * FROM sales_data_clean
LIMIT 10;

1.--Total revenue by region with average order value
SELECT 
    "Region", 
    COUNT("OrderID") AS Total_Orders,
    SUM("Revenue") AS Total_Revenue,
    ROUND(SUM("Revenue")/COUNT("OrderID"), 2) AS Avg_Order_Value
FROM sales_data_clean
GROUP BY "Region"
ORDER BY Total_Revenue DESC;

2.--Monthly revenue trend and Month-over-Month growth

WITH Monthly_Revenue AS (
    SELECT 
        TO_CHAR("OrderDate", 'YYYY-MM') AS Month, 
        SUM("Revenue") AS Revenue
    FROM sales_data_clean
    GROUP BY Month
)
SELECT 
    Month,
    Revenue,
    ROUND((Revenue - LAG(Revenue) OVER (ORDER BY Month)) / LAG(Revenue) OVER (ORDER BY Month) * 100, 2) AS MoM_Growth_Percent
FROM Monthly_Revenue;

3.--Top 10 products by total revenue and average quantity sold
SELECT 
    "Product", 
    SUM("Revenue") AS Total_Revenue,
    ROUND(AVG("Quantity"), 2) AS Avg_Quantity_Sold
FROM sales_data_clean
GROUP BY "Product"
ORDER BY Total_Revenue DESC
LIMIT 10;

4.--Bottom 3 underperforming product categories
SELECT 
    "Category",
    SUM("Revenue") AS Total_Revenue,
    COUNT(DISTINCT "Product") AS Product_Count
FROM sales_data_clean
GROUP BY "Category"
ORDER BY Total_Revenue ASC
LIMIT 3;

5.--Regional contribution per category
SELECT
    "Region",
    "Category",
    SUM("Revenue") AS Total_Revenue,
    ROUND(SUM("Revenue") * 100.0 / SUM(SUM("Revenue")) OVER(PARTITION BY "Region"), 2) AS Revenue_Percent_Of_Region
FROM sales_data_clean
GROUP BY "Region", "Category"
ORDER BY "Region", Total_Revenue DESC;

6.---Identify top 5 peak sales days
SELECT 
    "OrderDate",
    COUNT("OrderID") AS Total_Orders,
    SUM("Revenue") AS Total_Revenue
FROM sales_data_clean
GROUP BY "OrderDate"
ORDER BY Total_Revenue DESC
LIMIT 5;

7.--Average unit price and total revenue by product
SELECT 
    "Product",
    ROUND(AVG("UnitPrice"), 2) AS Avg_UnitPrice,
    SUM("Revenue") AS Total_Revenue
FROM sales_data_clean
GROUP BY "Product"
ORDER BY Total_Revenue DESC
LIMIT 10;

8.---Total revenue and orders by category
SELECT 
    "Category",
    COUNT("OrderID") AS Total_Orders,
    SUM("Revenue") AS Total_Revenue,
    ROUND(SUM("Revenue")/COUNT("OrderID"), 2) AS Avg_Order_Value
FROM sales_data_clean
GROUP BY "Category"
ORDER BY Total_Revenue DESC;

9.--Quarterly revenue trend

SELECT 
    TO_CHAR("OrderDate", 'YYYY-Q') AS Quarter,
    SUM("Revenue") AS Total_Revenue,
    COUNT("OrderID") AS Total_Orders
FROM sales_data_clean
GROUP BY Quarter
ORDER BY Quarter;




