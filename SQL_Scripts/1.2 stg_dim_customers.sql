--Drop Customer Dimension if it exists

IF OBJECT_ID('[stg_brightlearn_sales].[dbo].[stg_dim_customer]', 'U') IS NOT NULL
BEGIN
    DROP TABLE [stg_brightlearn_sales].[dbo].[stg_dim_customer];
END;
GO

-- Create table
CREATE TABLE [stg_brightlearn_sales].[dbo].[stg_dim_customer]
(
    [customer_id] INT IDENTITY(1,1) PRIMARY KEY,
    [customer_first_name] NVARCHAR(255) NULL,
    [customer_last_name] NVARCHAR(255) NULL,
    [customer_email] NVARCHAR(255) NULL,
    [customer_phone] NVARCHAR(255) NULL,
    [customer_city] NVARCHAR(255) NULL,
    [customer_province] NVARCHAR(255) NULL,
    [customer_loyalty_tier] NVARCHAR(255) NULL,
    [LoadDate] DATETIME DEFAULT GETDATE()
);
GO

-- Load data in the dim_customer

INSERT INTO [stg_brightlearn_sales].[dbo].[stg_dim_customer]
(
    [customer_first_name],
    [customer_last_name],
    [customer_email],
    [customer_phone],
    [customer_city],
    [customer_province],
    [customer_loyalty_tier]
    
)
SELECT DISTINCT
    [customer_first_name],
    [customer_last_name],
    [customer_email],
    [customer_phone],
    [customer_city],
    [customer_province],
    [customer_loyalty_tier]
FROM [stg_brightlearn_sales].[dbo].[brightlearn_raw_data];
GO
--Testing if data is inserted
select * from [stg_brightlearn_sales].[dbo].[stg_dim_customer]

-- Creating stg_dim_customer stored procedure
CREATE PROCEDURE dbo.sp_Create_stg_dim_customer
AS
BEGIN
    -- Drop the table if it exists
    IF OBJECT_ID('stg_brightlearn_sales.dbo.stg_dim_customer', 'U') IS NOT NULL
    BEGIN
        DROP TABLE stg_brightlearn_sales.dbo.stg_dim_customer;
    END;

    -- Create the table
    CREATE TABLE stg_brightlearn_sales.dbo.stg_dim_customer
    (
        customer_id INT IDENTITY(1,1) PRIMARY KEY,
        customer_first_name NVARCHAR(255) NULL,
        customer_last_name NVARCHAR(255) NULL,
        customer_email NVARCHAR(255) NULL,
        customer_phone NVARCHAR(255) NULL,
        customer_city NVARCHAR(255) NULL,
        customer_province NVARCHAR(255) NULL,
        customer_loyalty_tier NVARCHAR(255) NULL,
        LoadDate DATETIME NOT NULL DEFAULT GETDATE()
    );
END;
GO

--create stored procedure to load data
CREATE PROCEDURE dbo.sp_Load_stg_dim_customer
AS
BEGIN
    -- Load data
    INSERT INTO stg_brightlearn_sales.dbo.stg_dim_customer
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
        customer_first_name,
        customer_last_name,
        customer_email,
        customer_phone,
        customer_city,
        customer_province,
        customer_loyalty_tier
    FROM stg_brightlearn_sales.dbo.brightlearn_raw_data;
END;
GO