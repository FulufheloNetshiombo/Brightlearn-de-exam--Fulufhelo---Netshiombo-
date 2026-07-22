# Brightlearn-Data-Engineering-Capstone-project

## Introduction

BrightLearn is a retail company operating multiple stores across South Africa. For this project, a CSV file containing sales transactions from January to June 2024 was provided. The dataset included customer, product, store, payment, inventory, and sales information but contained several data quality issues such as missing values, duplicate records, inconsistent date formats and inconsistent text formatting.

The objective of this project was to design and implement an end to end data warehouse solution using Microsoft SQL Server and SQL Server Integration Services (SSIS). The solution follows a Medallion Architecture to organise data into raw, cleaned, and curated layers, and a Star Schema to support efficient reporting and analysis.

An ETL pipeline was developed to extract data from the CSV file, clean and standardise the data, load it into dimension and fact tables within the data warehouse. SQL views were then created to answer the business questions provided in the project scope, enabling the analysis of sales performance, customer behaviour, product performance, inventory and store performance.

This project demonstrates practical experience in data engineering, including ETL development, data cleaning, dimensional modelling, SQL programming, SSIS automation and building a reporting ready data warehouse.


## Project Overview

The BrightLearn Sales Data Engineering Project was developed to transform raw transactional sales data into a structured and reliable data warehouse that supports business reporting and decision making. The project uses Microsoft SQL Server, SQL Server Integration Services (SSIS) and Transact-SQL (T-SQL) to build an end to end ETL pipeline that extracts data from a CSV file, transforms and cleans the data and loads it into a dimensional data warehouse.

The solution follows a Medallion Architecture, where data progresses through the raw, staging, clean staging and data warehouse layers. This approach ensures that the original data is preserved while improving data quality before it is used for reporting and analysis.

The data warehouse was designed using a Star Schema, consisting of dimension tables for customers, products, stores, payments and dates together with a central sales fact table. This design improves query performance, simplifies data analysis and supports business intelligence reporting.

To automate the ETL process, SQL stored procedures and SSIS packages were developed to create database objects, load data between layers and populate the data warehouse. SQL views were then created to answer the business questions provided in the project scope, which includes product performance, revenue trends, customer loyalty, store performance, inventory monitoring and sales analysis.

The completed solution provides a scalable, accurate, and reporting ready data warehouse that enables BrightLearn to analyse business performance and make informed data driven decisions.

## Solution Architecture

The BrightLearn Sales solution follows a layered architecture that moves data from the source CSV file through staging, cleaning and into a reporting ready data warehouse. SQL Server Integration Services (SSIS) and SQL stored procedures automate the ETL process, while SQL views are used to answer the required business questions.

<img width="1536" height="1024" alt="ChatGPT Image Jul 22, 2026, 10_01_50 PM" src="https://github.com/user-attachments/assets/a5e5aa74-3f4a-443e-a509-d61bb4f89248" />

## End to End ETL Process

The ETL pipeline was developed using SSIS, SQL stored procedures and T-SQL to extract data from the source CSV file, transform it into a consistent format and load it into a Star Schema data warehouse.

Step 1: Extract

The source CSV file was imported into SQL Server using SSIS and stored in the BrightLearn_Raw_Data table without any modifications to preserve the original dataset.

Step 2: Load to Staging (Bronze Layer)

The raw data was separated into staging dimension tables (stg_dim_customer, stg_dim_product, stg_dim_store, stg_dim_payment and stg_dim_date) using SELECT DISTINCT to organise the data into business entities.

Step 3: Transform (Silver Layer)

The staging data was cleaned and standardised before loading it into the data warehouse. The transformations included:

Removing duplicate records.
Converting text to lowercase.
Trimming leading and trailing spaces.
Standardising customer phone numbers by adding the +27 country code where required.
Converting different date formats into a standard SQL DATE format.
Handling missing values.
Standardising data types.

Step 4: Load to the Data Warehouse (Gold Layer)

The cleaned dimension tables were loaded into the data warehouse, followed by the sales fact table. The fact table was designed using foreign keys from all dimension tables and includes the business measures used for reporting, such as transaction amount, unit price, cost price, quantity sold, line amount, stock on hand, reorder threshold and transaction discount. Numeric and monetary columns were converted to appropriate SQL data types to ensure accurate calculations and reporting.

Step 5: Reporting

SQL views (vw_BQ01 to vw_BQ08) were created to answer the required business questions, providing insights into sales performance, customer spending, store performance, product sales, inventory levels and revenue trends.

## Data Exploration and Data Cleaning

Before the ETL process, the dataset was analysed to identify data quality issues that could affect reporting and analysis. The assessment found duplicate records, missing values, inconsistent date formats, mixed letter casing, leading and trailing spaces, inconsistent phone number formats, and incorrect data types in numeric and monetary columns.

To improve data quality, the following cleaning activities were performed:

1. Removed duplicate records using SELECT DISTINCT.

2. Converted text columns to lowercase and removed leading and trailing spaces.

3. Standardised customer phone numbers by adding the +27 country code where required.

4. Converted multiple date formats into a standard SQL DATE format.

5. Replaced missing values with appropriate defaults such as Unknown, 0, or 2099-12-31, depending on the column.

6. Populated missing product categories using matching product records.

7. Converted numeric and monetary columns, including transaction amount, unit price, cost price, line amount, quantity, stock on hand, reorder threshold, and transaction discount, to appropriate SQL data types.

These transformations ensured that the data loaded into the data warehouse was accurate, consistent and ready for reporting and business analysis.

## Data Warehouse Design

The BrightLearn Sales data warehouse was built in Draw.io using a Star Schema, which I chosen because of its simple structure, improved query performanceand ease of reporting. The schema consists of five dimension tables (Customer, Product, Store, Payment, and Date) linked to a central Sales Fact table through primary and foreign key relationships.

The dimension tables store descriptive business information, while the fact table stores measurable sales data, including transaction amount, unit price, cost price, quantity sold, line amount, stock on hand, reorder threshold and transaction discount. This design provides a single source of truth and enables efficient reporting, analysis and business intelligence.

## Business Questions and Findings

To meet the reporting requirements, eight SQL views (`vw_BQ01` to `vw_BQ08`) were created to answer the business questions provided in the project scope. The analysis produced the following key findings:

* The **5-Piece Kitchen Knife Set** was the highest revenue generating product between January and June 2024.
* **BrightMart Sandton City** consistently recorded the highest monthly revenue, while revenue across all stores increased by **37.01%** from May to June after fluctuations in previous months.
* The top 10 highest spending customers were predominantly **Gold** loyalty members.
* No customers qualified for the **Win-Back Campaign**, as no registered loyalty customer had their last purchase before **28 April 2024**.
* **Silver** loyalty members recorded the highest average transaction value, followed by **Gold** and **Bronze** customers.
* **Groceries** was the best selling product category across all stores based on total quantity sold.
* No store product combinations had stock levels below the reorder threshold during the June 2024 inventory snapshot, indicating that inventory levels were sufficient.

These findings demonstrate how the data warehouse supports business decision making by providing reliable insights into sales performance, customer behaviour, product performance, store performance and inventory management.

## Challenges Encountered

Several challenges were encountered during the development of this project, particularly during the data preparation and ETL stages.

* The source data contained inconsistent date formats, which required conversion into a standard SQL `DATE` format.
* Duplicate records were identified and removed to prevent inaccurate reporting.
* Missing values in several columns, including product categoriesa and had to be handled using default values or matching records.
* Text fields contained inconsistent casing and unnecessary spaces, requiring standardisation using `LOWER()` and `TRIM()`.
* Customer phone numbers were stored in different formats and were standardised by adding the **+27** country code where required.
* Numeric and monetary columns required conversion to appropriate SQL data types to ensure accurate calculations.
* Foreign key relationships had to be carefully maintained when loading the fact table to preserve referential integrity.
* SQL Server and SSIS configuration issues, including package validation and connection setup, were resolved to ensure the ETL pipeline executed successfully.

Overcoming these challenges improved the overall quality of the data and resulted in a reliable, consistent and reporting ready data warehouse.

## Technologies Used

## Microsoft SQL Server (SSMS)

Used for database management, including creating databases, tables, stored procedures, views, and executing SQL queries throughout the project.

## SQL Server Integration Services (SSIS)

Used to automate the ETL process by importing the CSV file and moving data through the Bronze, Silver, and Gold layers.

## Transact-SQL (T-SQL)

Used to create database objects, implement data transformations, perform data cleaning, and load data into the staging and data warehouse tables.

## Visual Studio

Used to develop, configure, and manage SSIS packages for the ETL pipeline.

## CSV File

Served as the source dataset containing BrightLearn sales transactions from January to June 2024.

## Git

Used for version control to track changes and manage the project's source code.

## GitHub

Used to host the project repository, document the solution, and showcase the completed data engineering project.

## Repository strructure

The repository is organised into folders that separate the different components of the project, making it easier to understand, maintain, and navigate.

**Bright_Learn_Sales_SSIS**

Contains all SSIS packages developed to automate the ETL process, including extracting data from the CSV file, transforming it, and loading it into the staging and data warehouse layers.

**Data_Modeling**

Contains the Star Schema data model illustrating the relationships between the dimension tables and the central fact table used in the data warehouse.

**Data_Quality_Report**

Contains a report detailing the data quality issues identified in the source dataset, the steps taken to resolve each issue and the impact those issues would have had on reporting if they had not been addressed.

**Project_Scope**

Contains the original project brief provided for the assessment, including the business requirements and the reporting questions that the solution was required to answer.

**Raw_Data**

Contains the original BrightLearn sales CSV file used as the source data for the ETL process.

**SQL_Scripts**

Contains all SQL scripts developed during the project, including database creation scripts, staging table scripts, data cleaning scripts, data warehouse scripts, stored procedures and SQL views used for reporting.

**README.md**

Provides an overview of the project, including the solution architecture, ETL process, data warehouse design, business questions, findings, technologies used, repository structure and lessons learned.

## ## Lessons Learned

This project provided valuable hands on experience in building an end to end data engineering solution. It improved my skills in ETL development, data transformation, data quality management, dimensional modelling, SQL programming, SSIS, and designing a reporting ready data warehouse. It also reinforced the importance of clean, consistent data in supporting accurate reporting and informed business decisions. I also learned about the importance of each role in the data space to enhance the process.

## Future Improvements

As I continue developing my data engineering skills, I plan to:

* Build more end to end data engineering projects using larger and more complex datasets.
* Expand my knowledge of cloud data platforms such as **Microsoft Azure** and **Snowflake**.
* Strengthen my skills in **Python** for data engineering, including data transformation and workflow automation.
* Learn orchestration tools such as **Apache Airflow** to manage and schedule ETL pipelines.
* Gain experience with **CI/CD** practices to automate the deployment of data engineering solutions.
* Improve my data visualization skills by building interactive dashboards using **Power BI**.
* Continue exploring data warehouse optimisation techniques to improve ETL performance and query efficiency.

These goals will help me strengthen my technical expertise and prepare me to build scalable, production ready data engineering solutions.

## Conclusion

The BrightLearn Sales Data Engineering Project successfully transformed raw transactional data into a structured, reporting ready data warehouse using Microsoft SQL Server, SSIS and T-SQL. By implementing a Medallion Architecture and a Star Schema, the project improved data quality, streamlined the ETL process and provided a reliable foundation for business reporting.

Through data cleaning, dimensional modelling, ETL automation, and SQL view development, the solution answered the required business questions and generated meaningful insights into sales performance, customer behaviour, store performance and inventory management.

This project demonstrates my ability to design and build an end to end data engineering solution, applying industry standard practices to deliver accurate, scalable and reliable data for business decision making.

