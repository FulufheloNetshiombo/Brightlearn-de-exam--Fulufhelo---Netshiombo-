-- drop table if table exist
IF OBJECT_ID('dwh_brightlearn_sales.dbo.dwh_dim_date', 'U') IS NOT NULL
BEGIN
    DROP TABLE dwh_brightlearn_sales.dbo.dwh_dim_date;
END;
GO
-- create table 
CREATE TABLE dwh_brightlearn_sales.dbo.dwh_dim_date
(
    date_id INT PRIMARY KEY,
    transaction_date DATE NOT NULL,
    customer_date DATE NOT NULL,
    createdDate DATETIME2(0) NOT NULL DEFAULT GETDATE(),
    
);
GO

--insert data
INSERT INTO dwh_brightlearn_sales.dbo.dwh_dim_date
(
    date_id,
    transaction_date,
    customer_date
)
SELECT DISTINCT
    date_id,
    transaction_date,
    customer_date
FROM stg_brightlearn_sales.dbo.stg_clean_date;
GO

-- stored procedures to create table
CREATE PROCEDURE dbo.sp_Create_dwh_dim_date
AS
BEGIN
    IF OBJECT_ID('dwh_brightlearn_sales.dbo.dwh_dim_date', 'U') IS NOT NULL
    BEGIN
        DROP TABLE dwh_brightlearn_sales.dbo.dwh_dim_date;
    END;

    CREATE TABLE dwh_brightlearn_sales.dbo.dwh_dim_date
    (
        date_id INT PRIMARY KEY,
        transaction_date DATE NOT NULL,
        customer_date DATE NOT NULL,
        createdDate DATETIME2(0) NOT NULL DEFAULT GETDATE(),
        modifiedDate DATETIME2(0) NULL
    );
END;
GO
-- stored procedure to load
CREATE PROCEDURE .dbo.sp_Load_dwh_dim_date
AS
BEGIN
    TRUNCATE TABLE dwh_brightlearn_sales.dbo.dwh_dim_date;

    INSERT INTO dwh_brightlearn_sales.dbo.dwh_dim_date
    (
        date_id,
        transaction_date,
        customer_date
    )
    SELECT DISTINCT
        date_id,
        transaction_date,
        customer_date
    FROM stg_brightlearn_sales.dbo.stg_clean_date;
END;
GO