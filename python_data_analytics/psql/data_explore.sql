-- ============================================================
-- Retail Data Exploration
-- Database: retail_dw
-- Purpose: Initial data profiling and business understanding
-- ============================================================

-- Q1: Inspect table schema
\d+ retail;

-- Q2: Show first 10 rows
SELECT * 
FROM retail
LIMIT 10;

-- Q3: Total number of records
SELECT COUNT(*) AS total_records
FROM retail;

-- Q4: Number of unique customers
SELECT COUNT(DISTINCT customer_id) AS unique_customers
FROM retail;

-- Q5: Invoice date range
SELECT 
    MIN(invoice_date) AS min_date,
    MAX(invoice_date) AS max_date
FROM retail;

-- Q6: Number of unique products (SKUs)
SELECT COUNT(DISTINCT stock_code) AS unique_skus
FROM retail;

-- Q7: Average invoice amount (excluding cancelled invoices)
SELECT 
    AVG(invoice_total) AS avg_invoice_amount
FROM (
    SELECT 
        invoice_no,
        SUM(quantity * unit_price) AS invoice_total
    FROM retail
    GROUP BY invoice_no
    HAVING SUM(quantity * unit_price) > 0
) sub;

-- Q8: Total revenue
SELECT 
    SUM(quantity * unit_price) AS total_revenue
FROM retail;

-- Q9: Total revenue by year and month (YYYYMM)
SELECT
    (EXTRACT(YEAR FROM invoice_date) * 100 
     + EXTRACT(MONTH FROM invoice_date))::INT AS yyyymm,
    SUM(quantity * unit_price) AS monthly_revenue
FROM retail
GROUP BY yyyymm
ORDER BY yyyymm;

