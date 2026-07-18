-- Drop the table if it exists
IF OBJECT_ID('stg_brightlearn_sales.dbo.stg_clean_payment', 'U') IS NOT NULL
BEGIN
    DROP TABLE stg_brightlearn_sales.dbo.stg_clean_payment;
END;
GO

-- Create the clean payment table
CREATE TABLE stg_brightlearn_sales.dbo.stg_clean_payment
(
    payment_id INT IDENTITY(1,1) PRIMARY KEY,
    payment_method NVARCHAR(250) NOT NULL,
    LoadDate DATETIME NOT NULL DEFAULT GETDATE()
);
GO

-- Load cleaned data
INSERT INTO stg_brightlearn_sales.dbo.stg_clean_payment
(
    payment_method
)
SELECT DISTINCT
    LOWER(TRIM(payment_method))
FROM stg_brightlearn_sales.dbo.stg_dim_payment;
GO

-- Testing if the data is loaded
SELECT * FROM stg_brightlearn_sales.dbo.stg_clean_payment;

--Creating stored procedure to create the table
CREATE PROCEDURE dbo.sp_Create_stg_clean_payment
AS
BEGIN
    -- Drop the table if it exists
    IF OBJECT_ID('stg_brightlearn_sales.dbo.stg_clean_payment', 'U') IS NOT NULL
    BEGIN
        DROP TABLE stg_brightlearn_sales.dbo.stg_clean_payment;
    END;

    -- Create the table
    CREATE TABLE stg_brightlearn_sales.dbo.stg_clean_payment
    (
        payment_id INT IDENTITY(1,1) PRIMARY KEY,
        payment_method NVARCHAR(250) NOT NULL,
        LoadDate DATETIME NOT NULL DEFAULT GETDATE()
    );
END;
GO

-- create stored procedure for inserting data
CREATE PROCEDURE dbo.sp_Load_stg_clean_payment
AS
BEGIN
    -- Load cleaned data
    INSERT INTO stg_brightlearn_sales.dbo.stg_clean_payment
    (
        payment_method
    )
    SELECT DISTINCT
        LOWER(TRIM(payment_method))
    FROM stg_brightlearn_sales.dbo.stg_dim_payment;
END;
GO
