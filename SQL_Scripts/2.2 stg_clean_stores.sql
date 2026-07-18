--Drop stg_clean_customer if it exist
IF OBJECT_ID('[stg_brightlearn_sales].[dbo].[stg_clean_stores]', 'U') IS NOT NULL
BEGIN
    DROP TABLE [stg_brightlearn_sales].[dbo].[stg_clean_stores];
END;
GO
-- Create stg_clean_stores table
CREATE TABLE stg_brightlearn_sales.dbo.stg_clean_stores
(
    store_id INT IDENTITY(1,1) PRIMARY KEY,
    store_name NVARCHAR(250) NOT NULL,
    store_city NVARCHAR(250) NOT NULL,
    store_province NVARCHAR(250) NOT NULL,
    store_region NVARCHAR(250) NOT NULL,
    store_manager NVARCHAR(250) NOT NULL,
    cashier_name NVARCHAR(250) NOT NULL,
    LoadDate DATETIME NOT NULL DEFAULT GETDATE()
);
GO

-- load data into stg_clean_stores
INSERT INTO stg_brightlearn_sales.dbo.stg_clean_stores
(
    store_name,
    store_city,
    store_province,
    store_region,
    store_manager,
    cashier_name
)
SELECT DISTINCT
    LOWER(TRIM(store_name)),
    LOWER(TRIM(store_city)),
    LOWER(TRIM(store_province)),
    LOWER(TRIM(store_region)),
    LOWER(TRIM(store_manager)),
    LOWER(TRIM(cashier_name))
FROM stg_brightlearn_sales.dbo.stg_dim_stores;
GO

-- create stored procedure for creating stg_clean_stores
CREATE PROCEDURE dbo.sp_Create_stg_clean_stores
AS
BEGIN
    -- Drop the table if it exists
    IF OBJECT_ID('stg_brightlearn_sales.dbo.stg_clean_store', 'U') IS NOT NULL
    BEGIN
        DROP TABLE stg_brightlearn_sales.dbo.stg_clean_store;
    END;

    -- Create the table
    CREATE TABLE stg_brightlearn_sales.dbo.stg_clean_store
    (
        store_id INT IDENTITY(1,1) PRIMARY KEY,
        store_name NVARCHAR(250) NOT NULL,
        store_city NVARCHAR(250) NOT NULL,
        store_province NVARCHAR(250) NOT NULL,
        store_region NVARCHAR(250) NOT NULL,
        store_manager NVARCHAR(250) NOT NULL,
        cashier_name NVARCHAR(250) NOT NULL,
        LoadDate DATETIME NOT NULL DEFAULT GETDATE()
    );
END;
GO

--creatig stored procedures for loading data into the stg_clean_stores
CREATE PROCEDURE dbo.sp_Load_stg_clean_store
AS
BEGIN
    INSERT INTO stg_brightlearn_sales.dbo.stg_clean_stores
    (
        store_name,
        store_city,
        store_province,
        store_region,
        store_manager,
        cashier_name
    )
    SELECT DISTINCT
        LOWER(TRIM(store_name)),
        LOWER(TRIM(store_city)),
        LOWER(TRIM(store_province)),
        LOWER(TRIM(store_region)),
        LOWER(TRIM(store_manager)),
        LOWER(TRIM(cashier_name))
    FROM stg_brightlearn_sales.dbo.stg_dim_stores;
END;
GO
