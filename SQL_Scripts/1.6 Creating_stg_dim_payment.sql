-- Drop dim payment if it already exist

IF OBJECT_ID('[stg_brightlearn_sales].[dbo].[stg_dim_payment]', 'U') IS NOT NULL
BEGIN
    DROP TABLE [stg_brightlearn_sales].[dbo].[stg_dim_payment];
END;
GO

-- creating the stg_dim_stores
create table [stg_brightlearn_sales].[dbo].[stg_dim_payment]
([payment_id] int identity(1,1) primary key
      ,[payment_method] nvarchar (250) null
       ,[LoadDate] DATETIME DEFAULT GETDATE());
      
      

--insert data into the created table 
insert into [stg_brightlearn_sales].[dbo].[stg_dim_payment] 
(
[payment_method]
)
select distinct 
[payment_method]
from [stg_brightlearn_sales].[dbo].[BrightLearn_Raw_Data]
