IF OBJECT_ID('stg_brightlearn_sales.dbo.stg_clean_fact_sales', 'U') IS NOT NULL
BEGIN
    DROP TABLE stg_brightlearn_sales.dbo.stg_clean_fact_sales;
END;
GO
--Create table 
CREATE TABLE stg_brightlearn_sales.dbo.stg_clean_fact_sales
(
    fact_id INT IDENTITY(1,1) PRIMARY KEY,

    -- Foreign Keys
    customer_id INT NOT NULL,
    product_id INT NOT NULL,
    store_id INT NOT NULL,
    payment_id INT NOT NULL,
    date_id INT NOT NULL,

    -- Measures
    transaction_amount DECIMAL(18,2) NOT NULL,
    unit_price DECIMAL(18,2) NOT NULL,
    cost_price DECIMAL(18,2) NOT NULL,
    qty INT NOT NULL,
    line_amount DECIMAL(18,2) NOT NULL,
    stock_on_hand INT NOT NULL,
    reorder_threshold INT NOT NULL,
    transaction_discount DECIMAL(18,2) NOT NULL,

    LoadDate DATETIME NOT NULL DEFAULT GETDATE(),

    CONSTRAINT FK_Fact_Customer
        FOREIGN KEY (customer_id)
        REFERENCES stg_brightlearn_sales.dbo.stg_clean_customer(customer_id),

    CONSTRAINT FK_Fact_Product
        FOREIGN KEY (product_id)
        REFERENCES stg_brightlearn_sales.dbo.stg_clean_product(product_id),

    CONSTRAINT FK_Fact_Store
        FOREIGN KEY (store_id)
        REFERENCES stg_brightlearn_sales.dbo.stg_clean_stores(store_id),

    CONSTRAINT FK_Fact_Payment
        FOREIGN KEY (payment_id)
        REFERENCES stg_brightlearn_sales.dbo.stg_clean_payment(payment_id),

    CONSTRAINT FK_Fact_Date
        FOREIGN KEY (date_id)
        REFERENCES stg_brightlearn_sales.dbo.stg_clean_date(date_id)
);
GO

-- insert data in the clean fact
TRUNCATE TABLE stg_brightlearn_sales.dbo.stg_clean_fact_sales;
GO

INSERT INTO stg_brightlearn_sales.dbo.stg_clean_fact_sales
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

    c.customer_id,
    p.product_id,
    s.store_id,
    pm.payment_id,
    d.date_id,

    ISNULL(TRY_CONVERT(DECIMAL(18,2), r.transaction_amount), 0.00) AS transaction_amount,
    ISNULL(TRY_CONVERT(DECIMAL(18,2), r.unit_price), 0.00) AS unit_price,
    ISNULL(TRY_CONVERT(DECIMAL(18,2), r.cost_price), 0.00) AS cost_price,
    ISNULL(r.qty, 0) AS qty,
    ISNULL(TRY_CONVERT(DECIMAL(18,2), r.line_amount), 0.00) AS line_amount,
    ISNULL(r.stock_on_hand, 0) AS stock_on_hand,
    ISNULL(r.reorder_threshold, 0) AS reorder_threshold,
    ISNULL(TRY_CONVERT(DECIMAL(18,2), r.transaction_discount), 0.00) AS transaction_discount

FROM stg_brightlearn_sales.dbo.BrightLearn_Raw_Data AS r

INNER JOIN stg_brightlearn_sales.dbo.stg_clean_customer AS c
    ON LOWER(LTRIM(RTRIM(r.customer_first_name))) = c.customer_first_name
   AND LOWER(LTRIM(RTRIM(r.customer_last_name))) = c.customer_last_name
   AND LOWER(LTRIM(RTRIM(r.customer_email))) = c.customer_email

INNER JOIN stg_brightlearn_sales.dbo.stg_clean_product AS p
    ON LOWER(LTRIM(RTRIM(r.product_name))) = p.product_name
   AND LOWER(LTRIM(RTRIM(r.sku))) = p.sku

INNER JOIN stg_brightlearn_sales.dbo.stg_clean_stores AS s
    ON LOWER(LTRIM(RTRIM(r.store_name))) = s.store_name
   AND LOWER(LTRIM(RTRIM(r.cashier_name))) = s.cashier_name

INNER JOIN stg_brightlearn_sales.dbo.stg_clean_payment AS pm
    ON LOWER(LTRIM(RTRIM(r.payment_method))) = pm.payment_method

INNER JOIN stg_brightlearn_sales.dbo.stg_clean_date AS d
    ON d.transaction_date = COALESCE
    (
        TRY_CONVERT(DATE, r.transaction_date, 23),
        TRY_CONVERT(DATE, r.transaction_date, 106),
        TRY_CONVERT(DATE, r.transaction_date, 103)
    )
   AND d.customer_date = ISNULL
    (
        TRY_CONVERT(DATE, r.customer_since),
        '2099-12-31'
    );
GO
-- Testing if data is inserted
select * from stg_brightlearn_sales.dbo.stg_clean_fact_sales

--stored procedure for creating fact table
CREATE PROCEDURE dbo.sp_Create_stg_clean_fact_sales
AS
BEGIN
    -- Drop table if it exists
    IF OBJECT_ID('stg_brightlearn_sales.dbo.stg_clean_fact_sales', 'U') IS NOT NULL
    BEGIN
        DROP TABLE stg_brightlearn_sales.dbo.stg_clean_fact_sales;
    END;

    -- Create fact table
    CREATE TABLE stg_brightlearn_sales.dbo.stg_clean_fact_sales
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

        LoadDate DATETIME NOT NULL DEFAULT GETDATE(),

        CONSTRAINT FK_Fact_Customer
            FOREIGN KEY (customer_id)
            REFERENCES stg_brightlearn_sales.dbo.stg_clean_customer(customer_id),

        CONSTRAINT FK_Fact_Product
            FOREIGN KEY (product_id)
            REFERENCES stg_brightlearn_sales.dbo.stg_clean_product(product_id),

        CONSTRAINT FK_Fact_Store
            FOREIGN KEY (store_id)
            REFERENCES stg_brightlearn_sales.dbo.stg_clean_stores(store_id),

        CONSTRAINT FK_Fact_Payment
            FOREIGN KEY (payment_id)
            REFERENCES stg_brightlearn_sales.dbo.stg_clean_payment(payment_id),

        CONSTRAINT FK_Fact_Date
            FOREIGN KEY (date_id)
            REFERENCES stg_brightlearn_sales.dbo.stg_clean_date(date_id)
    );
END;
GO
--Creating stored procedure for loading data
CREATE PROCEDURE dbo.sp_Load_stg_clean_fact_sales
AS
BEGIN
    -- Load fact table
    INSERT INTO stg_brightlearn_sales.dbo.stg_clean_fact_sales
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

        c.customer_id,
        p.product_id,
        s.store_id,
        pm.payment_id,
        d.date_id,

        ISNULL(TRY_CONVERT(DECIMAL(18,2), r.transaction_amount), 0.00),
        ISNULL(TRY_CONVERT(DECIMAL(18,2), r.unit_price), 0.00),
        ISNULL(TRY_CONVERT(DECIMAL(18,2), r.cost_price), 0.00),
        ISNULL(r.qty, 0),
        ISNULL(TRY_CONVERT(DECIMAL(18,2), r.line_amount), 0.00),
        ISNULL(r.stock_on_hand, 0),
        ISNULL(r.reorder_threshold, 0),
        ISNULL(TRY_CONVERT(DECIMAL(18,2), r.transaction_discount), 0.00)

    FROM stg_brightlearn_sales.dbo.BrightLearn_Raw_Data AS r

    INNER JOIN stg_brightlearn_sales.dbo.stg_clean_customer AS c
        ON LOWER(LTRIM(RTRIM(r.customer_first_name))) = c.customer_first_name
       AND LOWER(LTRIM(RTRIM(r.customer_last_name))) = c.customer_last_name
       AND LOWER(LTRIM(RTRIM(r.customer_email))) = c.customer_email

    INNER JOIN stg_brightlearn_sales.dbo.stg_clean_product AS p
        ON LOWER(LTRIM(RTRIM(r.product_name))) = p.product_name
       AND LOWER(LTRIM(RTRIM(r.sku))) = p.sku

    INNER JOIN stg_brightlearn_sales.dbo.stg_clean_stores AS s
        ON LOWER(LTRIM(RTRIM(r.store_name))) = s.store_name
       AND LOWER(LTRIM(RTRIM(r.cashier_name))) = s.cashier_name

    INNER JOIN stg_brightlearn_sales.dbo.stg_clean_payment AS pm
        ON LOWER(LTRIM(RTRIM(r.payment_method))) = pm.payment_method

    INNER JOIN stg_brightlearn_sales.dbo.stg_clean_date AS d
        ON d.transaction_date = COALESCE
        (
            TRY_CONVERT(DATE, r.transaction_date, 23),
            TRY_CONVERT(DATE, r.transaction_date, 106),
            TRY_CONVERT(DATE, r.transaction_date, 103)
        )
       AND d.customer_date = ISNULL
        (
            TRY_CONVERT(DATE, r.customer_since),
            '2099-12-31'
        );
END;
GO
