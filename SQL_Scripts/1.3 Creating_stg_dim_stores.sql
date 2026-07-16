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
