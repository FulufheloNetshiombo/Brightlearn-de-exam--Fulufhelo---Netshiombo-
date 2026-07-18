-- drop table
IF OBJECT_ID('dwh_brightlearn_sales.dbo.dwh_dim_payment', 'U') IS NOT NULL
BEGIN
    DROP TABLE dwh_brightlearn_sales.dbo.dwh_dim_payment;
END;
GO
-- create table 
CREATE TABLE dwh_brightlearn_sales.dbo.dwh_dim_payment
(
    payment_id INT PRIMARY KEY,
    payment_method NVARCHAR(250) NOT NULL,
    createdDate DATETIME2(0) NOT NULL DEFAULT GETDATE(),
    modifiedDate DATETIME2(0) NULL
);
GO

-- insert data
INSERT INTO dwh_brightlearn_sales.dbo.dwh_dim_payment
(
    payment_id,
    payment_method
)
SELECT DISTINCT
    payment_id,
    payment_method
FROM stg_brightlearn_sales.dbo.stg_clean_payment;
GO

-- created stored procedure for creating table
CREATE PROCEDURE dbo.sp_Create_dwh_dim_payment
AS
BEGIN
    IF OBJECT_ID('dwh_brightlearn_sales.dbo.dwh_dim_payment', 'U') IS NOT NULL
    BEGIN
        DROP TABLE dwh_brightlearn_sales.dbo.dwh_dim_payment;
    END;

    CREATE TABLE dwh_brightlearn_sales.dbo.dwh_dim_payment
    (
        payment_id INT PRIMARY KEY,
        payment_method NVARCHAR(250) NOT NULL,
        createdDate DATETIME2(0) NOT NULL DEFAULT GETDATE(),
        modifiedDate DATETIME2(0) NULL
    );
END;
GO
-- create store procedure for loading
CREATE PROCEDURE dbo.sp_Load_dwh_dim_payment
AS
BEGIN
    INSERT INTO dwh_brightlearn_sales.dbo.dwh_dim_payment
    (
        payment_id,
        payment_method
    )
    SELECT DISTINCT
        payment_id,
        payment_method
    FROM stg_brightlearn_sales.dbo.stg_clean_payment;
END;
GO
