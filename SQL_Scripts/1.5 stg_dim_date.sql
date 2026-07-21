--Drop the fact tables
DROP TABLE IF EXISTS dwh_brightlearn_sales.dbo.dwh_fact_sales;
DROP TABLE IF EXISTS stg_brightlearn_sales.dbo.stg_clean_fact_sales;
GO
--Drop table if already exists
IF OBJECT_ID('stg_brightlearn_sales.dbo.stg_dim_date', 'U') IS NOT NULL
BEGIN
    DROP TABLE stg_brightlearn_sales.dbo.stg_dim_date;
END;
GO

--Create dim date table
CREATE TABLE stg_brightlearn_sales.dbo.stg_dim_date
(
    date_id INT IDENTITY(1,1) PRIMARY KEY,
    transaction_date date,
    customer_date date,
    LoadDate DATETIME NOT NULL DEFAULT GETDATE()
);
GO

--insert data into stg_dim_date

INSERT INTO stg_brightlearn_sales.dbo.stg_dim_date
(
    transaction_date,
    customer_date
)
SELECT DISTINCT

    COALESCE
    (
        TRY_CONVERT(DATE, transaction_date, 23),   -- 2024-06-04
        TRY_CONVERT(DATE, transaction_date, 106),  -- 23 Apr 2024
        TRY_CONVERT(DATE, transaction_date, 103)   -- 11/05/2024 (dd/MM/yyyy)
    ) AS transaction_date,

    ISNULL
    (
        TRY_CONVERT(DATE, customer_since),
        '2099-12-31'
    ) AS customer_date

FROM stg_brightlearn_sales.dbo.BrightLearn_Raw_Data;
-- testing if the code is loaded
SELECT
    *,
    DATENAME(MONTH, transaction_date) AS transaction_month,
    DATENAME(MONTH, customer_date) AS customer_month
FROM stg_brightlearn_sales.dbo.stg_dim_date;

--Create stored procedure for creating table

CREATE PROCEDURE dbo.sp_Create_stg_dim_date
AS
BEGIN
    -- Drop dependent tables if they exist
    DROP TABLE IF EXISTS dwh_brightlearn_sales.dbo.dwh_fact_sales;
    DROP TABLE IF EXISTS stg_brightlearn_sales.dbo.stg_clean_fact_sales;

    -- Drop the staging date table if it exists
    IF OBJECT_ID('stg_brightlearn_sales.dbo.stg_dim_date', 'U') IS NOT NULL
    BEGIN
        DROP TABLE stg_brightlearn_sales.dbo.stg_dim_date;
    END;

    -- Create the staging date table
    CREATE TABLE stg_brightlearn_sales.dbo.stg_dim_date
    (
        date_id INT IDENTITY(1,1) PRIMARY KEY,
        transaction_date DATE NULL,
        customer_date DATE NULL,
        LoadDate DATETIME NOT NULL DEFAULT GETDATE()
    );
END;
GO
-- Stored procedure to insert data
CREATE PROCEDURE dbo.sp_Load_stg_dim_date
AS
BEGIN
    -- Clear existing data
    TRUNCATE TABLE stg_brightlearn_sales.dbo.stg_dim_date;

    -- Load data
    INSERT INTO stg_brightlearn_sales.dbo.stg_dim_date
    (
        transaction_date,
        customer_date
    )
    SELECT DISTINCT

        COALESCE
        (
            TRY_CONVERT(DATE, transaction_date, 23),   -- yyyy-MM-dd
            TRY_CONVERT(DATE, transaction_date, 106),  -- dd MMM yyyy
            TRY_CONVERT(DATE, transaction_date, 103)   -- dd/MM/yyyy
        ) AS transaction_date,

        ISNULL
        (
            TRY_CONVERT(DATE, customer_since),
            '2099-12-31'
        ) AS customer_date

    FROM stg_brightlearn_sales.dbo.BrightLearn_Raw_Data;
END;
GO