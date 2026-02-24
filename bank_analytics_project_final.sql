-- ============================================================
--  BANKING TRANSACTION ANALYTICS PROJECT
--  Author: Mohamed Bokhamy
--  Major:  Business Intelligence / Finance / Marketing
--  Table:  banking_transactions_usa_2023_2024
-- ============================================================

USE bank_analytics;

-- ============================================================
-- SECTION 1: DATA EXPLORATION
-- ============================================================

-- 1.1 How many rows do we have?
SELECT COUNT(*) AS total_rows 
FROM banking_transactions_usa_2023_2024;

-- 1.2 Preview the data
SELECT * 
FROM banking_transactions_usa_2023_2024 
LIMIT 10;

-- 1.3 Date range
SELECT
    MIN(Transaction_Date) AS earliest_transaction,
    MAX(Transaction_Date) AS latest_transaction
FROM banking_transactions_usa_2023_2024;

-- 1.4 Debit vs Credit count
SELECT
    Transaction_Type,
    COUNT(*) AS count
FROM banking_transactions_usa_2023_2024
GROUP BY Transaction_Type;

-- 1.5 Spending categories
SELECT
    Category,
    COUNT(*) AS count
FROM banking_transactions_usa_2023_2024
GROUP BY Category
ORDER BY count DESC;

-- 1.6 Payment methods used
SELECT
    Payment_Method,
    COUNT(*) AS count
FROM banking_transactions_usa_2023_2024
GROUP BY Payment_Method
ORDER BY count DESC;

-- 1.7 Check for NULL values
SELECT
    SUM(CASE WHEN Transaction_ID     IS NULL THEN 1 ELSE 0 END) AS null_ids,
    SUM(CASE WHEN Account_Number     IS NULL THEN 1 ELSE 0 END) AS null_accounts,
    SUM(CASE WHEN Transaction_Amount IS NULL THEN 1 ELSE 0 END) AS null_amounts,
    SUM(CASE WHEN Transaction_Date   IS NULL THEN 1 ELSE 0 END) AS null_dates,
    SUM(CASE WHEN Category           IS NULL THEN 1 ELSE 0 END) AS null_categories
FROM banking_transactions_usa_2023_2024;


-- ============================================================
-- SECTION 2: DATA CLEANING
-- ============================================================
-- Run this ONCE before analysis. 

SET SQL_SAFE_UPDATES = 0;

-- 2.1 Remove transactions with zero or negative amounts
DELETE FROM banking_transactions_usa_2023_2024
WHERE Transaction_Amount <= 0;

-- 2.2 Standardize Transaction_Type capitalization
UPDATE banking_transactions_usa_2023_2024
SET Transaction_Type = CONCAT(
    UPPER(SUBSTRING(Transaction_Type, 1, 1)),
    LOWER(SUBSTRING(Transaction_Type, 2))
);

-- 2.3 Turn safe updates back on
SET SQL_SAFE_UPDATES = 1;

-- 2.4 Verify cleaning
SELECT Transaction_Type, COUNT(*) AS count
FROM banking_transactions_usa_2023_2024
GROUP BY Transaction_Type;


-- ============================================================
-- SECTION 3: KEY BUSINESS METRICS (KPIs)
-- ============================================================

-- 3.1 Overall Summary KPIs (main dashboard cards)
SELECT
    COUNT(*)                                    AS total_transactions,
    ROUND(SUM(Transaction_Amount), 2)           AS total_volume,
    ROUND(AVG(Transaction_Amount), 2)           AS avg_transaction,
    ROUND(MAX(Transaction_Amount), 2)           AS largest_transaction,
    ROUND(MIN(Transaction_Amount), 2)           AS smallest_transaction,
    COUNT(DISTINCT Account_Number)              AS unique_customers,
    ROUND(AVG(Customer_Age), 1)                 AS avg_customer_age
FROM banking_transactions_usa_2023_2024;

-- 3.2 Monthly Transaction Trends (LINE CHART)
SELECT
    DATE_FORMAT(Transaction_Date, '%Y-%m')      AS month,
    COUNT(*)                                    AS num_transactions,
    ROUND(SUM(Transaction_Amount), 2)           AS total_volume,
    ROUND(AVG(Transaction_Amount), 2)           AS avg_amount
FROM banking_transactions_usa_2023_2024
GROUP BY DATE_FORMAT(Transaction_Date, '%Y-%m')
ORDER BY month;

-- 3.3 Debit vs Credit breakdown (PIE CHART)
SELECT
    Transaction_Type,
    COUNT(*)                                            AS num_transactions,
    ROUND(SUM(Transaction_Amount), 2)                   AS total_amount,
    ROUND(COUNT(*) * 100.0 / SUM(COUNT(*)) OVER(), 2)  AS pct_of_total
FROM banking_transactions_usa_2023_2024
GROUP BY Transaction_Type;

-- 3.4 Payment method breakdown (BAR CHART)
SELECT
    Payment_Method,
    COUNT(*)                                            AS num_transactions,
    ROUND(SUM(Transaction_Amount), 2)                   AS total_amount,
    ROUND(COUNT(*) * 100.0 / SUM(COUNT(*)) OVER(), 2)  AS pct_of_total
FROM banking_transactions_usa_2023_2024
GROUP BY Payment_Method
ORDER BY num_transactions DESC;


-- ============================================================
-- SECTION 4: CUSTOMER ANALYSIS
-- ============================================================

-- 4.1 Top 10 customers by total spending
SELECT
    Account_Number,
    COUNT(*)                            AS num_transactions,
    ROUND(SUM(Transaction_Amount), 2)   AS total_spent,
    ROUND(AVG(Transaction_Amount), 2)   AS avg_transaction
FROM banking_transactions_usa_2023_2024
WHERE Transaction_Type = 'Debit'
GROUP BY Account_Number
ORDER BY total_spent DESC
LIMIT 10;

-- 4.2 Spending by customer age group
-- Groups customers into generations
SELECT
    CASE
        WHEN Customer_Age < 26 THEN 'Gen Z (Under 26)'
        WHEN Customer_Age < 42 THEN 'Millennial (26-41)'
        WHEN Customer_Age < 58 THEN 'Gen X (42-57)'
        ELSE 'Boomer (58+)'
    END AS age_group,
    COUNT(*)                            AS num_transactions,
    ROUND(SUM(Transaction_Amount), 2)   AS total_spent,
    ROUND(AVG(Transaction_Amount), 2)   AS avg_spent
FROM banking_transactions_usa_2023_2024
WHERE Transaction_Type = 'Debit'
GROUP BY age_group
ORDER BY total_spent DESC;

-- 4.3 Spending by gender
SELECT
    Customer_Gender,
    COUNT(*)                            AS num_transactions,
    ROUND(SUM(Transaction_Amount), 2)   AS total_spent,
    ROUND(AVG(Transaction_Amount), 2)   AS avg_spent
FROM banking_transactions_usa_2023_2024
WHERE Transaction_Type = 'Debit'
GROUP BY Customer_Gender
ORDER BY total_spent DESC;

-- 4.4 Customer segmentation by activity level
SELECT
    activity_segment,
    COUNT(*) AS num_customers
FROM (
    SELECT
        Account_Number,
        CASE
            WHEN COUNT(*) >= 50 THEN 'HIGH'
            WHEN COUNT(*) >= 20 THEN 'MEDIUM'
            ELSE 'LOW'
        END AS activity_segment
    FROM banking_transactions_usa_2023_2024
    GROUP BY Account_Number
) AS segmented
GROUP BY activity_segment;

-- 4.5 Top occupations by spending
SELECT
    Customer_Occupation,
    COUNT(*)                            AS num_transactions,
    ROUND(SUM(Transaction_Amount), 2)   AS total_spent,
    ROUND(AVG(Transaction_Amount), 2)   AS avg_spent
FROM banking_transactions_usa_2023_2024
WHERE Transaction_Type = 'Debit'
GROUP BY Customer_Occupation
ORDER BY total_spent DESC
LIMIT 10;


-- ============================================================
-- SECTION 5: SPENDING CATEGORY ANALYSIS
-- ============================================================

-- 5.1 Total spending by category (BAR CHART)
SELECT
    Category,
    COUNT(*)                            AS num_transactions,
    ROUND(SUM(Transaction_Amount), 2)   AS total_spent,
    ROUND(AVG(Transaction_Amount), 2)   AS avg_spent
FROM banking_transactions_usa_2023_2024
WHERE Transaction_Type = 'Debit'
GROUP BY Category
ORDER BY total_spent DESC;

-- 5.2 Monthly spending per category (TREND CHART)
SELECT
    DATE_FORMAT(Transaction_Date, '%Y-%m')  AS month,
    Category,
    ROUND(SUM(Transaction_Amount), 2)       AS total_spent
FROM banking_transactions_usa_2023_2024
WHERE Transaction_Type = 'Debit'
GROUP BY month, Category
ORDER BY month, total_spent DESC;

-- 5.3 Top 10 merchants by revenue
SELECT
    Merchant_Name,
    COUNT(*)                            AS num_transactions,
    ROUND(SUM(Transaction_Amount), 2)   AS total_received
FROM banking_transactions_usa_2023_2024
GROUP BY Merchant_Name
ORDER BY total_received DESC
LIMIT 10;

-- 5.4 Category preference by age group
SELECT
    CASE
        WHEN Customer_Age < 26 THEN 'Gen Z'
        WHEN Customer_Age < 42 THEN 'Millennial'
        WHEN Customer_Age < 58 THEN 'Gen X'
        ELSE 'Boomer'
    END AS age_group,
    Category,
    ROUND(SUM(Transaction_Amount), 2) AS total_spent
FROM banking_transactions_usa_2023_2024
WHERE Transaction_Type = 'Debit'
GROUP BY age_group, Category
ORDER BY age_group, total_spent DESC;


-- ============================================================
-- SECTION 6: GEOGRAPHIC ANALYSIS
-- ============================================================

-- 6.1 Transaction volume by city (MAP VISUAL)
SELECT
    City,
    COUNT(*)                            AS num_transactions,
    ROUND(SUM(Transaction_Amount), 2)   AS total_amount,
    ROUND(AVG(Transaction_Amount), 2)   AS avg_amount
FROM banking_transactions_usa_2023_2024
GROUP BY City
ORDER BY total_amount DESC;

-- 6.2 Top 10 cities by transaction count
SELECT
    City,
    COUNT(*) AS num_transactions
FROM banking_transactions_usa_2023_2024
GROUP BY City
ORDER BY num_transactions DESC
LIMIT 10;


-- ============================================================
-- SECTION 7: FRAUD / RISK ANALYSIS
-- ============================================================

-- 7.1 Flag unusually large transactions (more than 3x the average)
SELECT
    Transaction_ID,
    Account_Number,
    Transaction_Date,
    Transaction_Amount,
    Merchant_Name,
    Category,
    City,
    Payment_Method,
    Customer_Age,
    'SUSPICIOUS - HIGH AMOUNT' AS flag_reason
FROM banking_transactions_usa_2023_2024
WHERE Transaction_Amount > (
    SELECT AVG(Transaction_Amount) * 3
    FROM banking_transactions_usa_2023_2024
)
ORDER BY Transaction_Amount DESC
LIMIT 20;

-- 7.2 Riskiest payment methods by transaction size
SELECT
    Payment_Method,
    ROUND(MAX(Transaction_Amount), 2)   AS max_transaction,
    ROUND(AVG(Transaction_Amount), 2)   AS avg_transaction,
    COUNT(*)                            AS total_transactions
FROM banking_transactions_usa_2023_2024
GROUP BY Payment_Method
ORDER BY max_transaction DESC;

-- 7.3 Large transactions by category
SELECT
    Category,
    ROUND(MAX(Transaction_Amount), 2)   AS max_transaction,
    ROUND(AVG(Transaction_Amount), 2)   AS avg_transaction,
    ROUND(MIN(Transaction_Amount), 2)   AS min_transaction
FROM banking_transactions_usa_2023_2024
GROUP BY Category
ORDER BY max_transaction DESC;


-- ============================================================
-- SECTION 8: DASHBOARD-READY VIEWS
-- ============================================================
-- Connect these views directly to Power BI or Looker Studio!

-- View 1: Monthly Summary
CREATE OR REPLACE VIEW vw_monthly_summary AS
SELECT
    DATE_FORMAT(Transaction_Date, '%Y-%m')  AS month,
    COUNT(*)                                AS total_transactions,
    ROUND(SUM(Transaction_Amount), 2)       AS total_volume,
    ROUND(AVG(Transaction_Amount), 2)       AS avg_transaction
FROM banking_transactions_usa_2023_2024
GROUP BY DATE_FORMAT(Transaction_Date, '%Y-%m');

-- View 2: Customer Summary
CREATE OR REPLACE VIEW vw_customer_summary AS
SELECT
    Account_Number,
    Customer_Age,
    Customer_Gender,
    Customer_Occupation,
    COUNT(*)                            AS total_transactions,
    ROUND(SUM(Transaction_Amount), 2)   AS total_volume,
    ROUND(AVG(Transaction_Amount), 2)   AS avg_transaction,
    CASE
        WHEN COUNT(*) >= 50 THEN 'HIGH'
        WHEN COUNT(*) >= 20 THEN 'MEDIUM'
        ELSE 'LOW'
    END AS activity_segment
FROM banking_transactions_usa_2023_2024
GROUP BY Account_Number, Customer_Age, Customer_Gender, Customer_Occupation;

-- View 3: Category Summary
CREATE OR REPLACE VIEW vw_category_summary AS
SELECT
    Category,
    COUNT(*)                            AS num_transactions,
    ROUND(SUM(Transaction_Amount), 2)   AS total_spent,
    ROUND(AVG(Transaction_Amount), 2)   AS avg_spent
FROM banking_transactions_usa_2023_2024
WHERE Transaction_Type = 'Debit'
GROUP BY Category;

-- View 4: City Summary
CREATE OR REPLACE VIEW vw_city_summary AS
SELECT
    City,
    COUNT(*)                            AS num_transactions,
    ROUND(SUM(Transaction_Amount), 2)   AS total_amount,
    ROUND(AVG(Transaction_Amount), 2)   AS avg_amount
FROM banking_transactions_usa_2023_2024
GROUP BY City;

-- View 5: Demographics Summary (NEW - uses your extra columns!)
CREATE OR REPLACE VIEW vw_demographics_summary AS
SELECT
    Customer_Gender,
    CASE
        WHEN Customer_Age < 26 THEN 'Gen Z'
        WHEN Customer_Age < 42 THEN 'Millennial'
        WHEN Customer_Age < 58 THEN 'Gen X'
        ELSE 'Boomer'
    END AS age_group,
    COUNT(*)                            AS num_transactions,
    ROUND(SUM(Transaction_Amount), 2)   AS total_spent,
    ROUND(AVG(Transaction_Amount), 2)   AS avg_spent
FROM banking_transactions_usa_2023_2024
WHERE Transaction_Type = 'Debit'
GROUP BY Customer_Gender, age_group;

-- Confirm all views created successfully
SHOW FULL TABLES WHERE Table_type = 'VIEW';
