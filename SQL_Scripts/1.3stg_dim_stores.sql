--creating the stg_dim_stores
IF OBJECT_ID('[stg_brightlearn_sales].[dbo].[stg_dim_stores]', 'U') IS NOT NULL
BEGIN
    DROP TABLE [stg_brightlearn_sales].[dbo].[stg_dim_stores];
END;
GO

-- create dim_stores
create table [stg_brightlearn_sales].[dbo].[stg_dim_stores]
([store_id] int identity(1,1) primary key
      ,[store_name] nvarchar (250) null
      ,[store_city] nvarchar (250) null
      ,[store_province] nvarchar (250) null
      ,[store_region] nvarchar (250) null
      ,[store_manager] nvarchar (250) null
       ,[Cashier_name] nvarchar (250) null
       ,[LoadDate] DATETIME DEFAULT GETDATE()
       );
Go
      

--insert data into the created table 
insert into[stg_brightlearn_sales].[dbo].[stg_dim_stores]
(
[store_name]
,[store_city]
,[store_province]
,[store_region]
,[store_manager] 
,[Cashier_name]
)

select distinct 
 [store_name]
, [store_city]
, [store_province]
,[store_region]
,[store_manager]
,[cashier_name]
from [stg_brightlearn_sales].[dbo].[BrightLearn_Raw_Data]

--Testing if data in loaded
select * from [stg_brightlearn_sales].[dbo].[stg_dim_stores]

--creating stored procedure for creating stg_dim_stores
CREATE PROCEDURE dbo.sp_Create_stg_dim_stores
AS
BEGIN

    -- Drop the table if it exists
    IF OBJECT_ID('stg_brightlearn_sales.dbo.stg_dim_stores', 'U') IS NOT NULL
    BEGIN
        DROP TABLE stg_brightlearn_sales.dbo.stg_dim_stores;
    END;

    -- Create the table
    CREATE TABLE stg_brightlearn_sales.dbo.stg_dim_stores
    (
        store_id INT IDENTITY(1,1) PRIMARY KEY,
        store_name NVARCHAR(250) NULL,
        store_city NVARCHAR(250) NULL,
        store_province NVARCHAR(250) NULL,
        store_region NVARCHAR(250) NULL,
        store_manager NVARCHAR(250) NULL,
        cashier_name NVARCHAR(250) NULL,
        LoadDate DATETIME NOT NULL DEFAULT GETDATE()
    );
END;
GO

--Stored procedures for loading data into stg_dim_stores
CREATE PROCEDURE dbo.sp_Load_stg_dim_stores
AS
BEGIN
    INSERT INTO stg_brightlearn_sales.dbo.stg_dim_stores
    (
        store_name,
        store_city,
        store_province,
        store_region,
        store_manager,
        cashier_name
    )
    SELECT DISTINCT
        store_name,
        store_city,
        store_province,
        store_region,
        store_manager,
        cashier_name
    FROM stg_brightlearn_sales.dbo.BrightLearn_Raw_Data;
END;
GO