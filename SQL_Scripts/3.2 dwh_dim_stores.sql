-- drop table if already exist
IF OBJECT_ID('dwh_brightlearn_sales.dbo.dwh_dim_store', 'U') IS NOT NULL
BEGIN
    DROP TABLE dwh_brightlearn_sales.dbo.dwh_dim_store;
END;
GO

CREATE TABLE dwh_brightlearn_sales.dbo.dwh_dim_store
(
    store_id INT PRIMARY KEY,
    store_name NVARCHAR(250) NOT NULL,
    store_city NVARCHAR(250) NOT NULL,
    store_province NVARCHAR(250) NOT NULL,
    store_region NVARCHAR(250) NOT NULL,
    store_manager NVARCHAR(250) NOT NULL,
    cashier_name NVARCHAR(250) NOT NULL,

    createdDate DATETIME2(0) NOT NULL DEFAULT GETDATE()
 
);
GO

-- insert data
INSERT INTO dwh_brightlearn_sales.dbo.dwh_dim_store
(
    store_id,
    store_name,
    store_city,
    store_province,
    store_region,
    store_manager,
    cashier_name
)
SELECT DISTINCT
    store_id,
    store_name,
    store_city,
    store_province,
    store_region,
    store_manager,
    cashier_name
FROM stg_brightlearn_sales.dbo.stg_clean_stores;
GO

-- stored procedure to create table
CREATE PROCEDURE dbo.sp_Create_dwh_dim_store
AS
BEGIN
    -- Drop table if it exists
    IF OBJECT_ID('dwh_brightlearn_sales.dbo.dwh_dim_store', 'U') IS NOT NULL
    BEGIN
        DROP TABLE dwh_brightlearn_sales.dbo.dwh_dim_store;
    END;

    -- Create table
    CREATE TABLE dwh_brightlearn_sales.dbo.dwh_dim_store
    (
        store_id INT PRIMARY KEY,
        store_name NVARCHAR(250) NOT NULL,
        store_city NVARCHAR(250) NOT NULL,
        store_province NVARCHAR(250) NOT NULL,
        store_region NVARCHAR(250) NOT NULL,
        store_manager NVARCHAR(250) NOT NULL,
        cashier_name NVARCHAR(250) NOT NULL,
        createdDate DATETIME2(0) NOT NULL DEFAULT GETDATE(),
        modifiedDate DATETIME2(0) NULL
    );
END;
GO
-- stored procedure to load data
CREATE PROCEDURE dbo.usp_Load_dwh_dim_store
AS
BEGIN
    -- Clear existing data
    TRUNCATE TABLE dwh_brightlearn_sales.dbo.dwh_dim_store;

    -- Load data
    INSERT INTO dwh_brightlearn_sales.dbo.dwh_dim_store
    (
        store_id,
        store_name,
        store_city,
        store_province,
        store_region,
        store_manager,
        cashier_name
    )
    SELECT DISTINCT
        store_id,
        store_name,
        store_city,
        store_province,
        store_region,
        store_manager,
        cashier_name
    FROM stg_brightlearn_sales.dbo.stg_clean_stores;
END;
GO