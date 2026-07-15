--create stg_dim_customer table

IF OBJECT_ID('stg_brighlearn_sales.dbo.stg_dim_customer', 'U') IS not NULL
BEGIN
drop table [stg_brightlearn_sales].[dbo].[stg_dim_customer];
end;
create table [stg_brightlearn_sales].[dbo].[stg_dim_customer]
([customer_id] int identity(1,1) primary key
      ,[customer_first_name] nvarchar (250) null
      ,[customer_last_name] nvarchar (250) null
      ,[customer_email] nvarchar (250) null
      ,[customer_phone] nvarchar (250) null
      ,[customer_city] nvarchar (250) null
      ,[customer_province] nvarchar (250) null
      ,[customer_loyalty_tier] nvarchar (250) null);


--insert data into the created table 
insert into[stg_brightlearn_sales].[dbo].[stg_dim_customer] (customer_first_name,customer_last_name,customer_email,customer_phone,customer_city,customer_province,customer_loyalty_tier)
select distinct customer_first_name,customer_last_name,customer_email,customer_phone,customer_city,customer_province,customer_loyalty_tier
from [stg_brightlearn_sales].[dbo].[BrightLearn_Raw_Data]

--Testing if the data was inserted
select * from [stg_brightlearn_sales].[dbo].[stg_dim_customer]

