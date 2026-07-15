--creating the stg_dim_stores
IF OBJECT_ID('stg_brighlearn_sales.dbo.stg_dim_stores', 'U') IS not NULL
BEGIN
drop table [stg_brightlearn_sales].[dbo].[stg_dim_stores];
end;
create table [stg_brightlearn_sales].[dbo].[stg_dim_stores]
([store_id] int identity(1,1) primary key
      ,[store_name] nvarchar (250) null
      ,[store_city] nvarchar (250) null
      ,[store_province] nvarchar (250) null
      ,[store_region] nvarchar (250) null
      ,[store_manager] nvarchar (250) null);
      

--insert data into the created table 
insert into[stg_brightlearn_sales].[dbo].[stg_dim_stores] (store_name,store_city,store_province,store_region,store_manager)
select distinct store_name, store_city, store_province,store_region,store_manager
from [stg_brightlearn_sales].[dbo].[BrightLearn_Raw_Data]
