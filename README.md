# Northwind SQL Analytics

## Overview
This repository contains a SQL data analysis case study based on the classic Northwind sample database.
The project focuses on applying analytical and business-oriented SQL techniques to answer real-world questions related to revenue, customer behavior, retention, and operational performance.

The analysis was designed as a portfolio project for Data Analyst / BI Analyst roles, emphasizing query readability, logical structure, and business interpretation rather than query optimization alone.

---

## Tech Stack
- **Database:** MySQL
- **Query Language:** SQL

---

## Key Techniques Demonstrated
- Multi-table joins and aggregation
- Common Table Expressions (CTEs), including recursive CTEs
- Window functions (`ROW_NUMBER`, `DENSE_RANK`, `NTILE`, `LAG`, `SUM() OVER`, `AVG() OVER`)
- Time-series and seasonality analysis
- Statistical analysis (mean, median, standard deviation)
- Cohort and customer retention analysis
- Conditional logic using `CASE`
- Manual pivoting with conditional aggregation
- Date dimension modeling
- User-defined functions (UDFs)
- Stored procedures for reusable analytical logic

---

## Repository Structure

```
northwind-sql-analytics/
├── README.md
├── docs/
│   └── Northwind_SQL_Portfolio.pdf
└── sql/
    ├── 01_foundational_analysis.sql
    ├── 02_temporal_analysis.sql
    ├── 03_case_pivot.sql
    ├── 04_cohorts_retention.sql
    ├── 05_date_dimension.sql
    ├── 06_udf.sql
    └── 07_procedures.sql
```


---

## How to Use
- SQL files in the `sql/` directory contain queries grouped by analytical topic.
- The `docs/` directory includes a PDF version of the full portfolio with detailed explanations and business context.
- Queries are written for MySQL syntax and can be executed directly against the Northwind database.

---

## Notes
This project prioritizes analytical clarity and business relevance.
It is intended as a portfolio demonstration rather than a performance-optimized production system.

