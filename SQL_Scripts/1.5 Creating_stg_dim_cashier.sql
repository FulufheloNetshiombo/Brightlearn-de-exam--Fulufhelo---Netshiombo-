--creating the stg_dim_stores
IF OBJECT_ID('stg_brighlearn_sales.dbo.stg_dim_cashier', 'U') IS not NULL
BEGIN
drop table [stg_brightlearn_sales].[dbo].[stg_dim_cashier];
end;
create table [stg_brightlearn_sales].[dbo].[stg_dim_cashier]
([cashier_id] int identity(1,1) primary key
      ,[cashier_name] nvarchar (250) null);
      
      

--insert data into the created table 
insert into [stg_brightlearn_sales].[dbo].[stg_dim_cashier] (cashier_name)
select distinct cashier_name
from [stg_brightlearn_sales].[dbo].[BrightLearn_Raw_Data]
