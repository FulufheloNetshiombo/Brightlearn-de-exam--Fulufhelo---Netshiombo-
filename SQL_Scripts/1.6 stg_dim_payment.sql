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

--Testing if data has been loaded
select * from [stg_brightlearn_sales].[dbo].[stg_dim_payment]

--Creating stored procedure for creating table
CREATE PROCEDURE dbo.sp_Create_stg_dim_payment
AS
BEGIN
    -- Drop the table if it exists
    IF OBJECT_ID('stg_brightlearn_sales.dbo.stg_dim_payment', 'U') IS NOT NULL
    BEGIN
        DROP TABLE stg_brightlearn_sales.dbo.stg_dim_payment;
    END;

    -- Create the table
    CREATE TABLE stg_brightlearn_sales.dbo.stg_dim_payment
    (
        payment_id INT IDENTITY(1,1) PRIMARY KEY,
        payment_method NVARCHAR(250) NULL,
        LoadDate DATETIME NOT NULL DEFAULT GETDATE()
    );
END;
GO

--Creating stored procedure for inserting data
CREATE PROCEDURE dbo.sp_Load_stg_dim_payment
AS
BEGIN
    -- Load payment methods
    INSERT INTO stg_brightlearn_sales.dbo.stg_dim_payment
    (
        payment_method
    )
    SELECT DISTINCT
        payment_method
    FROM stg_brightlearn_sales.dbo.BrightLearn_Raw_Data;
END;
GO
