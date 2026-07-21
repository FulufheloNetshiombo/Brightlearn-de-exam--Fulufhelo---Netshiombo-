-- Drop table if exist
IF OBJECT_ID('dwh_brightlearn_sales.dbo.dwh_dim_customer', 'U') IS NOT NULL
BEGIN
    DROP TABLE dwh_brightlearn_sales.dbo.dwh_dim_customer;
END;
GO
--create table
CREATE TABLE dwh_brightlearn_sales.dbo.dwh_dim_customer
(
    customer_id INT PRIMARY KEY,

    customer_first_name NVARCHAR(255) NOT NULL,
    customer_last_name NVARCHAR(255) NOT NULL,
    customer_email NVARCHAR(255) NOT NULL,
    customer_phone NVARCHAR(255) NOT NULL,
    customer_city NVARCHAR(255) NOT NULL,
    customer_province NVARCHAR(255) NOT NULL,
    customer_loyalty_tier NVARCHAR(255) NOT NULL,

    createdDate DATETIME2(0) NOT NULL DEFAULT GETDATE()
    
);
GO

--insert data
INSERT INTO dwh_brightlearn_sales.dbo.dwh_dim_customer
(
    customer_id,
    customer_first_name,
    customer_last_name,
    customer_email,
    customer_phone,
    customer_city,
    customer_province,
    customer_loyalty_tier
)
SELECT DISTINCT
    customer_id,
    customer_first_name,
    customer_last_name,
    customer_email,
    customer_phone,
    customer_city,
    customer_province,
    customer_loyalty_tier
FROM stg_brightlearn_sales.dbo.stg_clean_customer;
GO

--testing if data is loaed
select * from dwh_brightlearn_sales.dbo.dwh_dim_customer

-- create stored procedure for creating
CREATE PROCEDURE dbo.sp_Create_dwh_dim_customer
AS
BEGIN
    -- Drop table if it exists
    IF OBJECT_ID('dwh_brightlearn_sales.dbo.dwh_dim_customer', 'U') IS NOT NULL
    BEGIN
        DROP TABLE dwh_brightlearn_sales.dbo.dwh_dim_customer;
    END;

    -- Create table
    CREATE TABLE dwh_brightlearn_sales.dbo.dwh_dim_customer
    (
        customer_id INT PRIMARY KEY,
        customer_first_name NVARCHAR(255) NOT NULL,
        customer_last_name NVARCHAR(255) NOT NULL,
        customer_email NVARCHAR(255) NOT NULL,
        customer_phone NVARCHAR(255) NOT NULL,
        customer_city NVARCHAR(255) NOT NULL,
        customer_province NVARCHAR(255) NOT NULL,
        customer_loyalty_tier NVARCHAR(255) NOT NULL,
        createdDate DATETIME2(0) NOT NULL DEFAULT GETDATE(),
        modifiedDate DATETIME2(0) NULL
    );
END;
GO

--Stored procedure to load data
CREATE PROCEDURE dbo.sp_Load_dwh_dim_customer
AS
BEGIN
    -- Clear existing data
    TRUNCATE TABLE dwh_brightlearn_sales.dbo.dwh_dim_customer;

    -- Load data
    INSERT INTO dwh_brightlearn_sales.dbo.dwh_dim_customer
    (
        customer_id,
        customer_first_name,
        customer_last_name,
        customer_email,
        customer_phone,
        customer_city,
        customer_province,
        customer_loyalty_tier
    )
    SELECT DISTINCT
        customer_id,
        customer_first_name,
        customer_last_name,
        customer_email,
        customer_phone,
        customer_city,
        customer_province,
        customer_loyalty_tier
    FROM stg_brightlearn_sales.dbo.stg_clean_customer;
END;
GO