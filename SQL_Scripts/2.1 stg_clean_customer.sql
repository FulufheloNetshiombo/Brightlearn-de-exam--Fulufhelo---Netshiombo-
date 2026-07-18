--Drop clean Customer if it exists

IF OBJECT_ID('[stg_brightlearn_sales].[dbo].[stg_clean_customer]', 'U') IS NOT NULL
BEGIN
    DROP TABLE [stg_brightlearn_sales].[dbo].[stg_clean_customer];
END;
GO

--Create table clean customer
CREATE TABLE stg_brightlearn_sales.dbo.stg_clean_customer
(
    customer_id INT IDENTITY(1,1) PRIMARY KEY,
    customer_first_name NVARCHAR(255) NOT NULL,
    customer_last_name NVARCHAR(255) NOT NULL,
    customer_email NVARCHAR(255) NOT NULL,
    customer_phone NVARCHAR(255) NOT NULL,
    customer_city NVARCHAR(255) NOT NULL,
    customer_province NVARCHAR(255) NOT NULL,
    customer_loyalty_tier NVARCHAR(255) NOT NULL,
    LoadDate DATETIME DEFAULT GETDATE()
);
GO

--Loading data into cleancustomer
INSERT INTO stg_brightlearn_sales.dbo.stg_clean_customer
(
    customer_first_name,
    customer_last_name,
    customer_email,
    customer_phone,
    customer_city,
    customer_province,
    customer_loyalty_tier
)
SELECT DISTINCT

    LOWER(ISNULL(NULLIF(TRIM(customer_first_name), ''), 'unknown')),

    LOWER(ISNULL(NULLIF(TRIM(customer_last_name), ''), 'unknown')),

    LOWER(ISNULL(NULLIF(TRIM(customer_email), ''), 'unknown')),

    CASE
        WHEN LEN(REPLACE(TRIM(customer_phone), ' ', '')) = 9
            THEN '+27' + REPLACE(TRIM(customer_phone), ' ', '')
        ELSE
            LOWER(ISNULL(NULLIF(TRIM(customer_phone), ''), 'unknown'))
    END,

    LOWER(ISNULL(NULLIF(TRIM(customer_city), ''), 'unknown')),

    LOWER(ISNULL(NULLIF(TRIM(customer_province), ''), 'unknown')),

    LOWER(ISNULL(NULLIF(TRIM(customer_loyalty_tier), ''), 'unknown'))

FROM [stg_brightlearn_sales].[dbo].[stg_dim_customer];
GO

--Testing if the data is loaded
select * from stg_brightlearn_sales.dbo.stg_clean_customer

--Stored procedure for creating clean customer table
CREATE PROCEDURE [dbo].[sp_Create_stg_clean_customer]
AS
BEGIN
  
    IF OBJECT_ID('stg_brightlearn_sales.dbo.stg_clean_customer', 'U') IS NOT NULL
    BEGIN
        DROP TABLE stg_brightlearn_sales.dbo.stg_clean_customer;
    END;

    CREATE TABLE stg_brightlearn_sales.dbo.stg_clean_customer
    (
        customer_id INT IDENTITY(1,1) PRIMARY KEY,
        customer_first_name NVARCHAR(255) NOT NULL,
        customer_last_name NVARCHAR(255) NOT NULL,
        customer_email NVARCHAR(255) NOT NULL,
        customer_phone NVARCHAR(255) NOT NULL,
        customer_city NVARCHAR(255) NOT NULL,
        customer_province NVARCHAR(255) NOT NULL,
        customer_loyalty_tier NVARCHAR(255) NOT NULL,
        LoadDate DATETIME NOT NULL DEFAULT GETDATE()
    );
END;
GO

--Create stored procedure for loading data
CREATE PROCEDURE dbo.p_Load_stg_clean_customer
AS 
BEGIN
    INSERT INTO stg_brightlearn_sales.dbo.stg_clean_customer
    (
        customer_first_name,
        customer_last_name,
        customer_email,
        customer_phone,
        customer_city,
        customer_province,
        customer_loyalty_tier
    )
    SELECT DISTINCT
        LOWER(ISNULL(NULLIF(TRIM(customer_first_name), ''), 'unknown')) AS customer_first_name,

        LOWER(ISNULL(NULLIF(TRIM(customer_last_name), ''), 'unknown')) AS customer_last_name,

        LOWER(ISNULL(NULLIF(TRIM(customer_email), ''), 'unknown')) AS customer_email,

        CASE
            WHEN LEN(REPLACE(TRIM(customer_phone), ' ', '')) = 9
                THEN '+27' + REPLACE(TRIM(customer_phone), ' ', '')
            ELSE LOWER(ISNULL(NULLIF(TRIM(customer_phone), ''), 'unknown'))
        END AS customer_phone,

        LOWER(ISNULL(NULLIF(TRIM(customer_city), ''), 'unknown')) AS customer_city,

        LOWER(ISNULL(NULLIF(TRIM(customer_province), ''), 'unknown')) AS customer_province,

        LOWER(ISNULL(NULLIF(TRIM(customer_loyalty_tier), ''), 'unknown')) AS customer_loyalty_tier

    FROM stg_brightlearn_sales.dbo.stg_dim_customer;
END;
GO
