-- drop table if it exist
IF OBJECT_ID('stg_brightlearn_sales.dbo.stg_clean_date', 'U') IS NOT NULL
BEGIN
    DROP TABLE stg_brightlearn_sales.dbo.stg_clean_date;
END;
GO

-- create date
CREATE TABLE stg_brightlearn_sales.dbo.stg_clean_date
(
    date_id INT IDENTITY(1,1) PRIMARY KEY,
    transaction_date DATE NOT NULL,
    customer_date DATE NOT NULL,
    LoadDate DATETIME NOT NULL DEFAULT GETDATE()
);
GO

-- Load data
INSERT INTO stg_brightlearn_sales.dbo.stg_clean_date
(
    transaction_date,
    customer_date
)
SELECT DISTINCT
    ISNULL(transaction_date, '2099-12-31') AS transaction_date,
    ISNULL(customer_date, '2099-12-31') AS customer_date
FROM stg_brightlearn_sales.dbo.stg_dim_date;
GO

-- create stored procedure for creating table
CREATE PROCEDURE dbo.sp_Create_stg_clean_date
AS
BEGIN
    -- Drop the table if it exists
    IF OBJECT_ID('stg_brightlearn_sales.dbo.stg_clean_date', 'U') IS NOT NULL
    BEGIN
        DROP TABLE stg_brightlearn_sales.dbo.stg_clean_date;
    END;

    -- Create the table
    CREATE TABLE stg_brightlearn_sales.dbo.stg_clean_date
    (
        date_id INT IDENTITY(1,1) PRIMARY KEY,
        transaction_date DATE NOT NULL,
        customer_date DATE NOT NULL,
        LoadDate DATETIME NOT NULL DEFAULT GETDATE()
    );
END;
GO

-- create stored procedure for inserting data
CREATE PROCEDURE .dbo.sp_Load_stg_clean_date
AS
BEGIN
    -- Load cleaned data
    INSERT INTO stg_brightlearn_sales.dbo.stg_clean_date
    (
        transaction_date,
        customer_date
    )
    SELECT DISTINCT
        ISNULL(transaction_date, '2099-12-31') AS transaction_date,
        ISNULL(customer_date, '2099-12-31') AS customer_date
    FROM stg_brightlearn_sales.dbo.stg_dim_date;
END;
GO