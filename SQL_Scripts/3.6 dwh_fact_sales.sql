-- drop table if exist
IF OBJECT_ID('dwh_brightlearn_sales.dbo.dwh_fact_sales', 'U') IS NOT NULL
BEGIN
    DROP TABLE dwh_brightlearn_sales.dbo.dwh_fact_sales;
END;
GO

CREATE TABLE dwh_brightlearn_sales.dbo.dwh_fact_sales
(
    fact_id INT IDENTITY(1,1) PRIMARY KEY,

    customer_id INT NOT NULL,
    product_id INT NOT NULL,
    store_id INT NOT NULL,
    payment_id INT NOT NULL,
    date_id INT NOT NULL,

    transaction_amount DECIMAL(18,2) NOT NULL,
    unit_price DECIMAL(18,2) NOT NULL,
    cost_price DECIMAL(18,2) NOT NULL,
    qty INT NOT NULL,
    line_amount DECIMAL(18,2) NOT NULL,
    stock_on_hand INT NOT NULL,
    reorder_threshold INT NOT NULL,
    transaction_discount DECIMAL(18,2) NOT NULL,

    createdDate DATETIME2(0) NOT NULL DEFAULT GETDATE(),
    modifiedDate DATETIME2(0) NULL,

    CONSTRAINT FK_dwh_fact_customer
        FOREIGN KEY (customer_id)
        REFERENCES dwh_brightlearn_sales.dbo.dwh_dim_customer(customer_id),

    CONSTRAINT FK_dwh_fact_product
        FOREIGN KEY (product_id)
        REFERENCES dwh_brightlearn_sales.dbo.dwh_dim_product(product_id),

    CONSTRAINT FK_dwh_fact_store
        FOREIGN KEY (store_id)
        REFERENCES dwh_brightlearn_sales.dbo.dwh_dim_store(store_id),

    CONSTRAINT FK_dwh_fact_payment
        FOREIGN KEY (payment_id)
        REFERENCES dwh_brightlearn_sales.dbo.dwh_dim_payment(payment_id),

    CONSTRAINT FK_dwh_fact_date
        FOREIGN KEY (date_id)
        REFERENCES dwh_brightlearn_sales.dbo.dwh_dim_date(date_id)
);
GO

-- insert data
INSERT INTO dwh_brightlearn_sales.dbo.dwh_fact_sales
(
    customer_id,
    product_id,
    store_id,
    payment_id,
    date_id,
    transaction_amount,
    unit_price,
    cost_price,
    qty,
    line_amount,
    stock_on_hand,
    reorder_threshold,
    transaction_discount
)
SELECT DISTINCT
    customer_id,
    product_id,
    store_id,
    payment_id,
    date_id,
    transaction_amount,
    unit_price,
    cost_price,
    qty,
    line_amount,
    stock_on_hand,
    reorder_threshold,
    transaction_discount
FROM stg_brightlearn_sales.dbo.stg_clean_fact_sales;
GO

-- create stored procedures
CREATE PROCEDURE dbo.sp_Create_dwh_fact_sales
AS
BEGIN
    IF OBJECT_ID('dwh_brightlearn_sales.dbo.dwh_fact_sales', 'U') IS NOT NULL
    BEGIN
        DROP TABLE dwh_brightlearn_sales.dbo.dwh_fact_sales;
    END;

    CREATE TABLE dwh_brightlearn_sales.dbo.dwh_fact_sales
    (
        fact_id INT IDENTITY(1,1) PRIMARY KEY,

        customer_id INT NOT NULL,
        product_id INT NOT NULL,
        store_id INT NOT NULL,
        payment_id INT NOT NULL,
        date_id INT NOT NULL,

        transaction_amount DECIMAL(18,2) NOT NULL,
        unit_price DECIMAL(18,2) NOT NULL,
        cost_price DECIMAL(18,2) NOT NULL,
        qty INT NOT NULL,
        line_amount DECIMAL(18,2) NOT NULL,
        stock_on_hand INT NOT NULL,
        reorder_threshold INT NOT NULL,
        transaction_discount DECIMAL(18,2) NOT NULL,

        createdDate DATETIME2(0) NOT NULL DEFAULT GETDATE(),
        modifiedDate DATETIME2(0) NULL,

        CONSTRAINT FK_dwh_fact_customer
            FOREIGN KEY (customer_id)
            REFERENCES dwh_brightlearn_sales.dbo.dwh_dim_customer(customer_id),

        CONSTRAINT FK_dwh_fact_product
            FOREIGN KEY (product_id)
            REFERENCES dwh_brightlearn_sales.dbo.dwh_dim_product(product_id),

        CONSTRAINT FK_dwh_fact_store
            FOREIGN KEY (store_id)
            REFERENCES dwh_brightlearn_sales.dbo.dwh_dim_store(store_id),

        CONSTRAINT FK_dwh_fact_payment
            FOREIGN KEY (payment_id)
            REFERENCES dwh_brightlearn_sales.dbo.dwh_dim_payment(payment_id),

        CONSTRAINT FK_dwh_fact_date
            FOREIGN KEY (date_id)
            REFERENCES dwh_brightlearn_sales.dbo.dwh_dim_date(date_id)
    );
END;
GO

-- Procedure for loading
CREATE PROCEDURE dbo.sp_Load_dwh_fact_sales
AS
BEGIN

    INSERT INTO dwh_brightlearn_sales.dbo.dwh_fact_sales
    (
        customer_id,
        product_id,
        store_id,
        payment_id,
        date_id,
        transaction_amount,
        unit_price,
        cost_price,
        qty,
        line_amount,
        stock_on_hand,
        reorder_threshold,
        transaction_discount
    )
    SELECT DISTINCT
        customer_id,
        product_id,
        store_id,
        payment_id,
        date_id,
        transaction_amount,
        unit_price,
        cost_price,
        qty,
        line_amount,
        stock_on_hand,
        reorder_threshold,
        transaction_discount
    FROM stg_brightlearn_sales.dbo.stg_clean_fact_sales;
END;
GO