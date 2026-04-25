# sql-business-analytics-lab

![SQL](https://img.shields.io/badge/SQL-SQLite_3.35%2B-blue) ![License](https://img.shields.io/badge/License-MIT-yellow) ![Queries](https://img.shields.io/badge/Queries-10_KPIs-green)

A **production-quality SQL analytics project** using a realistic Indian e-commerce dataset. Demonstrates advanced SQL: window functions, CTEs, cohort analysis, margin calculations, and geo-analytics — all mapped to real business decisions.

## Project Structure

```
sql-business-analytics-lab/
|-- sql/
|   |-- schema.sql      # DDL: 4 tables, constraints, indexes
|   |-- seed.sql        # 10 customers, 10 products, 30 orders, 60 items
|   |-- analytics.sql   # 10 business KPI queries
|-- docs/
|   |-- findings.md     # 7-insight analyst report with recommendations
|-- README.md
```

## Quick Start (SQLite)

```bash
# Clone
git clone https://github.com/aadi4frnzzz-crypto/sql-business-analytics-lab.git
cd sql-business-analytics-lab

# Create database, load schema and seed
sqlite3 ecommerce.db < sql/schema.sql
sqlite3 ecommerce.db < sql/seed.sql

# Run a specific query
sqlite3 -header -column ecommerce.db < sql/analytics.sql
```

## Analytics Queries

| # | Query | SQL Concepts |
|---|---|---|
| 01 | Monthly Revenue Trend | GROUP BY, aggregates |
| 02 | Customer Lifetime Value Ranking | RANK() OVER, JOIN |
| 03 | Repeat Purchase Retention Rate | CTE, CASE WHEN |
| 04 | Top Products by Revenue & Margin | Multi-table JOIN, NULLIF |
| 05 | Rolling 30-Day Revenue | SUM() OVER (ROWS BETWEEN) |
| 06 | Category Performance | SUM() OVER () for share % |
| 07 | Payment Mode Preferences | COUNT() OVER () |
| 08 | Cancellation & Refund Impact | CTE + window ratio |
| 09 | Cohort Analysis (signup month) | LEFT JOIN, cohort CTE |
| 10 | City-Level Geo Performance | DENSE_RANK() OVER PARTITION |

## Dataset

| Table | Rows | Description |
|---|---|---|
| `customers` | 10 | Across 8 Indian cities, 3 segments |
| `products` | 10 | 6 categories including Electronics, Health, Sports |
| `orders` | 30 | Jan–Nov 2024, 4 statuses, 4 payment modes |
| `order_items` | 60 | With discount_pct and computed line_total |

## Key Findings

See [docs/findings.md](docs/findings.md) for the full analyst report. Headlines:

1. Revenue peaks in Q1 and Q3; February is the weakest month
2. Top 3 customers = 52% of total revenue
3. 80% repeat purchase retention rate
4. Electronics leads revenue; Health has the best gross margin
5. UPI is dominant (48% of orders); COD correlates with cancellations
6. Cancellations + refunds cost ~12% of gross revenue
7. Maharashtra leads geo revenue; Rajasthan underperforms per customer

## Design Principles

- **Every query has a business label** — not just "top customers" but "CLV Ranking for VIP program design"
- **Metrics are defined** in `docs/findings.md` — no ambiguity
- **SQLite-first, Postgres-compatible** — runs locally in under 30 seconds
- **Seed data is realistic** — Indian cities, Indian payment modes, Indian product types

## License

MIT
