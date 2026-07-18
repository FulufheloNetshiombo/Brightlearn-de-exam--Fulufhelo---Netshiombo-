-- Drop product Dimension if it exists
IF OBJECT_ID('[stg_brightlearn_sales].[dbo].[stg_dim_product]', 'U') IS NOT NULL
BEGIN
    DROP TABLE [stg_brightlearn_sales].[dbo].[stg_dim_product];
END;
GO

-- creating the stg_dim_product
create table [stg_brightlearn_sales].[dbo].[stg_dim_product]
([product_id] int identity(1,1) primary key
      ,[product_name] nvarchar (250) null
      ,[category] nvarchar (250) null
      ,[sub_category] nvarchar (250) null
      ,[supplier] nvarchar (250) null
      ,[sku] nvarchar (250) null
      ,[LoadDate] DATETIME DEFAULT GETDATE()
      );
      

--insert data into the created table 
insert into[stg_brightlearn_sales].[dbo].[stg_dim_product] 
(
product_name
,[category]
,[sub_category]
,[sku]
,[supplier] )


select distinct
[product_name]
,[category]
,[sub_category]
,[sku]
,[supplier]
from [stg_brightlearn_sales].[dbo].[BrightLearn_Raw_Data]

--Testing if the data is loaded
select * from [stg_brightlearn_sales].[dbo].[stg_dim_product] 

-- create stored procedure for creating table
CREATE PROCEDURE dbo.sp_Create_stg_dim_product
AS
BEGIN
    -- Drop the table if it exists
    IF OBJECT_ID('stg_brightlearn_sales.dbo.stg_dim_product', 'U') IS NOT NULL
    BEGIN
        DROP TABLE stg_brightlearn_sales.dbo.stg_dim_product;
    END;

    -- Create the table
    CREATE TABLE stg_brightlearn_sales.dbo.stg_dim_product
    (
        product_id INT IDENTITY(1,1) PRIMARY KEY,
        product_name NVARCHAR(250) NULL,
        category NVARCHAR(250) NULL,
        sub_category NVARCHAR(250) NULL,
        supplier NVARCHAR(250) NULL,
        sku NVARCHAR(250) NULL,
        LoadDate DATETIME NOT NULL DEFAULT GETDATE()
    );
END;
GO

-- Creating stored procedure to Insert data into the table
CREATE PROCEDURE dbo.sp_Load_stg_dim_product
AS
BEGIN
    -- Load data
    INSERT INTO stg_brightlearn_sales.dbo.stg_dim_product
    (
        product_name,
        category,
        sub_category,
        sku,
        supplier
    )
    SELECT DISTINCT
        product_name,
        category,
        sub_category,
        sku,
        supplier
    FROM stg_brightlearn_sales.dbo.BrightLearn_Raw_Data;
END;
GO
