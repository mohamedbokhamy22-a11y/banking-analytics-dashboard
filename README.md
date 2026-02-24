# 🏦 Banking Transaction Analytics Dashboard

## 📊 Project Overview
A end-to-end Business Intelligence project analyzing **10,000+ real banking transactions** from the USA (2023–2024). This project covers the full BI workflow: data ingestion, SQL-based analysis, cloud database deployment, and an interactive dashboard.

**Live Dashboard:** https://lookerstudio.google.com/s/hxX5jS7_3lM

---

## 🎯 Business Questions Answered
- What is the total transaction volume and average transaction amount?
- Which spending categories drive the most revenue?
- How do transaction trends change month over month?
- Which payment methods are most popular?
- How does spending differ across gender and age groups?
- Which transactions are potentially fraudulent?

---

## 🛠️ Tools & Technologies
| Tool | Purpose |
|------|---------|
| MySQL | Data storage, cleaning, and analysis |
| MySQL Workbench | SQL development environment |
| Railway (Cloud MySQL) | Cloud database hosting |
| Google Looker Studio | Interactive dashboard and visualization |
| GitHub | Version control and project sharing |

---

## 📁 Dataset
- **Source:** [USA Banking Transactions Dataset 2023–2024](https://www.kaggle.com/datasets/pradeepkumar2424/usa-banking-transactions-dataset-2023-2024) (Kaggle)
- **Size:** 10,000+ transactions
- **Period:** January 2023 – January 2025
- **Key Fields:** Transaction ID, Account Number, Transaction Date, Amount, Category, Payment Method, City, Customer Age, Customer Gender, Customer Occupation, Fraud Flag

---

## 🗂️ Project Structure
```
banking-analytics/
│
├── bank_analytics_project_final.sql   # Main SQL project file
└── README.md                          # Project documentation
```

---

## 📋 SQL Project Breakdown

### Section 1 – Data Exploration
- Preview data structure and column types
- Check date range of transactions
- Identify transaction types and spending categories
- Detect NULL values and data quality issues

### Section 2 – Data Cleaning
- Remove transactions with zero or negative amounts
- Standardize text formatting across columns
- Verify data integrity after cleaning

### Section 3 – Key Business Metrics (KPIs)
- Total transaction volume: **$13,497,554.54**
- Average transaction amount
- Largest and smallest transactions
- Monthly transaction trends
- Debit vs Credit breakdown

### Section 4 – Customer Analysis
- Top 10 customers by spending
- Customer segmentation (HIGH / MEDIUM / LOW activity)
- Spending breakdown by age group (Gen Z, Millennial, Gen X, Boomer)
- Spending differences by gender
- Top occupations by transaction volume

### Section 5 – Spending Category Analysis
- Total spending per category
- Monthly category trends
- Top 10 merchants by revenue

### Section 6 – Geographic Analysis
- Transaction volume by city
- Top 10 cities by number of transactions

### Section 7 – Fraud & Risk Analysis
- Flag transactions more than 3x the average amount
- Identify customers with unusually high transaction frequency
- Risk analysis by category and payment method

### Section 8 – Dashboard-Ready Views
Created 5 SQL Views to feed directly into Looker Studio:
- `vw_monthly_summary` — Monthly trends
- `vw_customer_summary` — Customer segmentation
- `vw_category_summary` — Spending by category
- `vw_city_summary` — Geographic breakdown
- `vw_demographics_summary` — Age and gender analysis

---

## 📈 Dashboard Highlights
The live Looker Studio dashboard includes:
- 💰 **KPI Scorecard** — Total transaction volume ($13.5M)
- 📊 **Bar Chart** — Spending by category (Utilities #1)
- 📈 **Time Series** — Transaction trends Jan 2023 – Jan 2025
- 🥧 **Pie Chart** — Payment method breakdown (equal split across 5 methods)
- 🥧 **Pie Chart** — Gender spending distribution
- 🚨 **Fraud Scorecard** — Fraud flag count

---

## 💡 Key Insights
1. **Utilities, Entertainment and Travel** are the top 3 spending categories, accounting for the majority of debit transactions
2. **Payment methods are evenly distributed** — E-Wallet, Credit Card, Debit Card, Online Transfer and Cash each account for roughly 20% of transactions
3. **Spending is nearly equal across genders** — Female (34.2%), Male (33.3%), Others (32.5%), suggesting the bank serves a diverse and balanced customer base

---

## 🚀 How to Run This Project
1. Download the dataset from Kaggle (link above)
2. Open `bank_analytics_project_final.sql` in MySQL Workbench
3. Run each section one by one (highlight a query → Cmd+Shift+Enter on Mac)
4. Connect your MySQL database to Google Looker Studio
5. Use the 5 views from Section 8 as your data sources

---

 👤 Author:
**Mohamed Bokhamy Majoring in**
**Business Intelligence & Finance & Marketing**  

📧 **Mohamedbokhamy22@augustana.edu**
💼 LinkedIn URL: www.linkedin.com/in/mohamedbokhamy-a9a493332  
🐙 [Your GitHub URL]
