--Drop table if it exist
IF OBJECT_ID('stg_brightlearn_sales.dbo.stg_clean_product', 'U') IS NOT NULL
BEGIN
    DROP TABLE stg_brightlearn_sales.dbo.stg_clean_product;
END;
GO

--Create the stg_clean_product
CREATE TABLE stg_brightlearn_sales.dbo.stg_clean_product
(
    product_id INT IDENTITY(1,1) PRIMARY KEY,
    product_name NVARCHAR(250) NOT NULL,
    category NVARCHAR(250) NOT NULL,
    sub_category NVARCHAR(250) NOT NULL,
    sku NVARCHAR(250) NOT NULL,
    supplier NVARCHAR(250) NOT NULL,
    LoadDate DATETIME NOT NULL DEFAULT GETDATE()
);
GO

--insert data into stg_clean_product
INSERT INTO stg_brightlearn_sales.dbo.stg_clean_product
(
    product_name,
    category,
    sub_category,
    sku,
    supplier
)
SELECT DISTINCT

    LOWER(TRIM(p.product_name)),

    LOWER(TRIM(COALESCE(p.category, c.category, 'unknown'))),

    LOWER(TRIM(p.sub_category)),

    LOWER(TRIM(p.sku)),

    LOWER(TRIM(p.supplier))

FROM stg_brightlearn_sales.dbo.stg_dim_product p

LEFT JOIN stg_brightlearn_sales.dbo.stg_dim_product c
    ON p.product_name = c.product_name
   AND p.sub_category = c.sub_category
   AND p.supplier = c.supplier
   AND p.sku = c.sku
   AND c.category IS NOT NULL;

   --Testing if the data is loaded
   select * from stg_brightlearn_sales.dbo.stg_clean_product 

   -- create stored procedure for cerating tabl

   CREATE PROCEDURE dbo.sp_Create_stg_clean_product
AS
BEGIN
    -- Drop the table if it exists
    IF OBJECT_ID('stg_brightlearn_sales.dbo.stg_clean_product', 'U') IS NULL
    BEGIN

    -- Create the table
    CREATE TABLE stg_brightlearn_sales.dbo.stg_clean_product
    (
        product_id INT IDENTITY(1,1) PRIMARY KEY,
        product_name NVARCHAR(250) NOT NULL,
        category NVARCHAR(250) NOT NULL,
        sub_category NVARCHAR(250) NOT NULL,
        sku NVARCHAR(250) NOT NULL,
        supplier NVARCHAR(250) NOT NULL,
        LoadDate DATETIME NOT NULL DEFAULT GETDATE()
    );
    END
END;
GO

-- create stored procedure to insert data into the table

CREATE PROCEDURE dbo.sp_Load_stg_clean_product
AS
BEGIN
    -- Load cleaned data
    TRUNCATE TABLE stg_brightlearn_sales.dbo.stg_clean_product
    INSERT INTO stg_brightlearn_sales.dbo.stg_clean_product
    (
        product_name,
        category,
        sub_category,
        sku,
        supplier
    )
    SELECT DISTINCT
        LOWER(TRIM(p.product_name)),

        LOWER(TRIM(COALESCE(p.category, c.category, 'unknown'))),

        LOWER(TRIM(p.sub_category)),

        LOWER(TRIM(p.sku)),

        LOWER(TRIM(p.supplier))

    FROM stg_brightlearn_sales.dbo.stg_dim_product AS p

    LEFT JOIN stg_brightlearn_sales.dbo.stg_dim_product AS c
        ON p.product_name = c.product_name
       AND p.sub_category = c.sub_category
       AND p.supplier = c.supplier
       AND p.sku = c.sku
       AND c.category IS NOT NULL;
END;
GO
