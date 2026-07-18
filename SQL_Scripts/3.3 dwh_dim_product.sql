-- drop table if already exist
IF OBJECT_ID('dwh_brightlearn_sales.dbo.dwh_dim_product', 'U') IS NOT NULL
BEGIN
    DROP TABLE dwh_brightlearn_sales.dbo.dwh_dim_product;
END;
GO
-- create table
CREATE TABLE dwh_brightlearn_sales.dbo.dwh_dim_product
(
    product_id INT PRIMARY KEY,
    product_name NVARCHAR(250) NOT NULL,
    category NVARCHAR(250) NOT NULL,
    sub_category NVARCHAR(250) NOT NULL,
    sku NVARCHAR(250) NOT NULL,
    supplier NVARCHAR(250) NOT NULL,
    createdDate DATETIME2(0) NOT NULL DEFAULT GETDATE(),
    
);
GO

-- Load data
INSERT INTO dwh_brightlearn_sales.dbo.dwh_dim_product
(
    product_id,
    product_name,
    category,
    sub_category,
    sku,
    supplier
)
SELECT DISTINCT
    product_id,
    product_name,
    category,
    sub_category,
    sku,
    supplier
FROM stg_brightlearn_sales.dbo.stg_clean_product;
GO

-- stored procedures for creating table
CREATE PROCEDURE dbo.sp_Create_dwh_dim_product
AS
BEGIN
    -- Drop table if it exists
    IF OBJECT_ID('dwh_brightlearn_sales.dbo.dwh_dim_product', 'U') IS NOT NULL
    BEGIN
        DROP TABLE dwh_brightlearn_sales.dbo.dwh_dim_product;
    END;

    -- Create table
    CREATE TABLE dwh_brightlearn_sales.dbo.dwh_dim_product
    (
        product_id INT PRIMARY KEY,
        product_name NVARCHAR(250) NOT NULL,
        category NVARCHAR(250) NOT NULL,
        sub_category NVARCHAR(250) NOT NULL,
        sku NVARCHAR(250) NOT NULL,
        supplier NVARCHAR(250) NOT NULL,

        createdDate DATETIME2(0) NOT NULL DEFAULT GETDATE(),
        modifiedDate DATETIME2(0) NULL
    );
END;
GO
-- stored procedures for loading
CREATE PROCEDURE dbo.sp_Load_dwh_dim_product
AS
BEGIN
    -- Clear existing data
    TRUNCATE TABLE dwh_brightlearn_sales.dbo.dwh_dim_product;

    -- Load data
    INSERT INTO dwh_brightlearn_sales.dbo.dwh_dim_product
    (
        product_id,
        product_name,
        category,
        sub_category,
        sku,
        supplier
    )
    SELECT DISTINCT
        product_id,
        product_name,
        category,
        sub_category,
        sku,
        supplier
    FROM stg_brightlearn_sales.dbo.stg_clean_product;
END;
GO
