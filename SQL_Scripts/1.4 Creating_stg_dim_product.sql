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
