-- BQ-01 What were the top 5 best-selling products by total revenue between January and June 2024? -- BQ-01 What were the top 5 best-selling products by total revenue between January and June 2024?

CREATE VIEW dbo.vw_BQ01
AS
SELECT TOP (5)
    p.product_name,
    SUM(f.line_amount) AS total_revenue
FROM dwh_brightlearn_sales.dbo.dwh_fact_sales AS f
INNER JOIN dwh_brightlearn_sales.dbo.dwh_dim_product AS p
    ON f.product_id = p.product_id
INNER JOIN dwh_brightlearn_sales.dbo.dwh_dim_date AS d
    ON f.date_id = d.date_id
WHERE d.transaction_date BETWEEN '2024-01-01' AND '2024-06-30'
GROUP BY p.product_name;
GO

-- BQ-02 What was the total revenue per store, broken down by month, for the January–June 2024 period?
CREATE VIEW dbo.vw_BQ02
AS
SELECT
    s.store_name,
    MONTH(d.transaction_date) AS month_number,
    DATENAME(MONTH, d.transaction_date) AS sales_month,
    SUM(f.line_amount) AS total_revenue
FROM dwh_brightlearn_sales.dbo.dwh_fact_sales AS f
INNER JOIN dwh_brightlearn_sales.dbo.dwh_dim_store AS s
    ON f.store_id = s.store_id
INNER JOIN dwh_brightlearn_sales.dbo.dwh_dim_date AS d
    ON f.date_id = d.date_id
WHERE d.transaction_date BETWEEN '2024-01-01' AND '2024-06-30'
GROUP BY
    s.store_name,
    MONTH(d.transaction_date),
    DATENAME(MONTH, d.transaction_date);
GO

-- BQ-03 What is the month-over-month revenue growth rate across all stores combined?
CREATE VIEW dbo.vw_BQ03
AS
WITH MonthlyRevenue AS
(
    SELECT
        YEAR(d.transaction_date) AS revenue_year,
        MONTH(d.transaction_date) AS revenue_month,
        DATENAME(MONTH, d.transaction_date) AS month_name,
        SUM(f.line_amount) AS total_revenue
    FROM dwh_brightlearn_sales.dbo.dwh_fact_sales AS f
    INNER JOIN dwh_brightlearn_sales.dbo.dwh_dim_date AS d
        ON f.date_id = d.date_id
    WHERE d.transaction_date BETWEEN '2024-01-01' AND '2024-06-30'
    GROUP BY
        YEAR(d.transaction_date),
        MONTH(d.transaction_date),
        DATENAME(MONTH, d.transaction_date)
)
SELECT
    CurrentMonth.revenue_year,
    CurrentMonth.revenue_month,
    CurrentMonth.month_name,
    CurrentMonth.total_revenue,
    PreviousMonth.total_revenue AS previous_month_revenue,
    ROUND(
        ((CurrentMonth.total_revenue - PreviousMonth.total_revenue) * 100.0)
        / PreviousMonth.total_revenue,
        2
    ) AS growth_rate_percent
FROM MonthlyRevenue AS CurrentMonth
LEFT JOIN MonthlyRevenue AS PreviousMonth
ON CurrentMonth.revenue_year = PreviousMonth.revenue_year
AND CurrentMonth.revenue_month = PreviousMonth.revenue_month + 1;
GO

-- BQ-04 Who are the top 10 loyalty customers ranked by total spend over the reporting period?
CREATE VIEW dbo.vw_BQ04
AS
SELECT TOP 10
    c.customer_first_name,
    c.customer_last_name,
    c.customer_loyalty_tier,
    SUM(f.transaction_amount) AS total_spend

FROM dwh_brightlearn_sales.dbo.dwh_fact_sales AS f

JOIN dwh_brightlearn_sales.dbo.dwh_dim_customer AS c
    ON f.customer_id = c.customer_id

GROUP BY
    c.customer_first_name,
    c.customer_last_name,
    c.customer_loyalty_tier

ORDER BY
    total_spend DESC;

  -- BQ-05 Which registered loyalty customers have not made a purchase since 28 April 2024?These customers must be flagged for a targetedwin-back campaign.
  CREATE VIEW dbo.vw_BQ05
AS
SELECT
    c.customer_id,
    c.customer_first_name,
    c.customer_last_name,
    MAX(d.transaction_date) AS last_purchase_date,
    'Win-Back Campaign' AS campaign_flag
FROM dwh_brightlearn_sales.dbo.dwh_fact_sales AS f
INNER JOIN dwh_brightlearn_sales.dbo.dwh_dim_customer AS c
ON f.customer_id = c.customer_id
INNER JOIN dwh_brightlearn_sales.dbo.dwh_dim_date AS d
ON f.date_id = d.date_id
WHERE c.customer_loyalty_tier IS NOT NULL
GROUP BY
    c.customer_id,
    c.customer_first_name,
    c.customer_last_name
HAVING MAX(d.transaction_date) < '2024-04-28';
GO

-- BQ-06 What is the average transaction value broken down by customer loyalty tier (Bronze, Silver, Gold)?
CREATE VIEW dbo.vw_BQ06
AS
SELECT
    c.customer_loyalty_tier,
    AVG(f.line_amount) AS average_transaction_value
FROM dwh_brightlearn_sales.dbo.dwh_fact_sales AS f
INNER JOIN dwh_brightlearn_sales.dbo.dwh_dim_customer AS c
ON f.customer_id = c.customer_id
WHERE c.customer_loyalty_tier IN ('Bronze', 'Silver', 'Gold')
GROUP BY c.customer_loyalty_tier;
GO

-- BQ-07 What is the total quantity sold per product category,
  CREATE VIEW dbo.vw_BQ07
AS
SELECT
    p.category,
    s.store_name,
    SUM(f.qty) AS total_quantity_sold
FROM dwh_brightlearn_sales.dbo.dwh_fact_sales AS f
INNER JOIN dwh_brightlearn_sales.dbo.dwh_dim_product AS p
ON f.product_id = p.product_id
INNER JOIN dwh_brightlearn_sales.dbo.dwh_dim_store AS s
ON f.store_id = s.store_id
INNER JOIN dwh_brightlearn_sales.dbo.dwh_dim_date AS d
ON f.date_id = d.date_id
WHERE d.transaction_date BETWEEN '2024-01-01' AND '2024-06-30'
GROUP BY
    p.category,
    s.store_name;
GO

-- BQ-08 Based on the June 2024 inventory snapshot embedded in the source data, which store-product combinations currently have stock levels below their reorder threshold?
CREATE VIEW dbo.vw_BQ08
AS
SELECT DISTINCT
    s.store_name,
    p.product_name,
    f.stock_on_hand,
    f.reorder_threshold
FROM dwh_brightlearn_sales.dbo.dwh_fact_sales AS f
INNER JOIN dwh_brightlearn_sales.dbo.dwh_dim_store AS s
    ON f.store_id = s.store_id
INNER JOIN dwh_brightlearn_sales.dbo.dwh_dim_product AS p
    ON f.product_id = p.product_id
INNER JOIN dwh_brightlearn_sales.dbo.dwh_dim_date AS d
    ON f.date_id = d.date_id
WHERE
    d.transaction_date BETWEEN '2024-06-01' AND '2024-06-30'
    AND f.stock_on_hand < f.reorder_threshold;
GO