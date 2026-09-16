/*
=======================================================================================================================
Ranking Analysis
=======================================================================================================================
Purpose:
    - To rank items (e.g., products, customers) based on performance or other metrics.
    - To identify top performers or laggards.

SQL Functions Used:
    - Window Ranking Functions: RANK(), DENSE_RANK(), ROW_NUMBER(), TOP
    - Clauses: GROUP BY, ORDER BY
=======================================================================================================================
*/

-- Which 5 products Generating the Highest Revenue?
-- Simple Ranking
SELECT TOP 5
    d.product_name,
    SUM(f.sales_amount) AS total_revenue
FROM gold.fact_sales f
LEFT JOIN gold.dim_products d
    ON f.product_key = d.product_key
GROUP BY d.product_name
ORDER BY SUM(f.sales_amount) DESC;

-- Complex but Flexibly Ranking Using Window Functions
SELECT *
FROM (
    SELECT
        d.product_name,
        SUM(f.sales_amount) AS total_revenue,
        RANK() OVER(ORDER BY SUM(f.sales_amount)) AS rank_product
    FROM gold.fact_sales f
    LEFT JOIN gold.dim_products d
        ON f.product_key = d.product_key
    GROUP BY d.product_name
) AS ranked_products
WHERE rank_product <= 5;

-- What are the 5 worst-performing products in terms of sales?
SELECT TOP 5
    d.product_name,
    SUM(f.sales_amount) AS total_revenue
FROM gold.fact_sales f
LEFT JOIN gold.dim_products d
    ON f.product_key = d.product_key
GROUP BY d.product_name
ORDER BY SUM(f.sales_amount);

-- Find the top 10 customers who have generated the highest revenue
SELECT TOP 10
    d.customer_key,
    d.first_name,
    d.last_name,
    SUM(f.sales_amount) AS total_revenue
FROM gold.fact_sales f
LEFT JOIN gold.dim_customers d
    ON f.customer_key = d.customer_key
GROUP BY d.customer_key,
         d.first_name,
         d.last_name
ORDER BY SUM(f.sales_amount) DESC;

-- The 3 customers with the fewest orders placed
SELECT TOP 3
    d.customer_key,
    d.first_name,
    d.last_name,
    COUNT(DISTINCT f.order_number) AS total_orders
FROM gold.fact_sales f
LEFT JOIN gold.dim_customers d
    ON f.customer_key = d.customer_key
GROUP BY d.customer_key,
         d.first_name,
         d.last_name
ORDER BY total_orders;