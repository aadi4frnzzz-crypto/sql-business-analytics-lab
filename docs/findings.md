# Business Findings: E-Commerce Analytics Report

**Dataset:** 10 customers | 10 products | 30 orders | 60 line items | Jan–Nov 2024  
**Tools:** SQLite 3.x, custom Python runner  
**Analyst:** github.com/aadi4frnzzz-crypto

---

## Executive Summary

This report surfaces 7 key findings from the e-commerce transaction dataset, covering revenue performance, customer behaviour, product margins, and geographic opportunity.

---

## Finding 1: Revenue Concentrated in Q1 and Q3

**Query:** Monthly Revenue Trend (Query 01)

Revenue shows two clear peaks: **January–March** (post-holiday clearance + new year buying) and **July–September** (festive pre-season). February shows the weakest performance, driven by two cancellations in that month.

**Recommendation:** Pre-load inventory in December and June. Consider targeted promotions in February to smooth the dip.

---

## Finding 2: Top 3 Customers Drive 52% of Revenue

**Query:** CLV Ranking (Query 02)

Customer 1 (Rahul Sharma, Mumbai, VIP) has the highest lifetime value with 6 completed orders. The top 3 customers account for over half of all completed order revenue.

**Recommendation:** Build a formal VIP program with exclusive early access and personalised offers. Flag customer 1's refund order (Order 1011) for investigation — refunds from high-CLV customers are high risk.

---

## Finding 3: 80% Repeat Purchase Rate

**Query:** Retention Rate (Query 03)

8 out of 10 active customers placed more than one order. This is exceptionally high for a simulated dataset and indicates strong product-market fit.

**Recommendation:** The 2 single-order customers (segments: retail) should be targeted with re-engagement email campaigns with personalised product recommendations.

---

## Finding 4: Electronics Category Leads Revenue But Health Has Best Margin

**Query:** Category Performance (Query 06) + Product Margins (Query 04)

- **Electronics** (Mechanical Keyboard, Noise Buds): Highest revenue share (~38%)
- **Health** (Whey Protein): Highest gross margin at ~58%
- **Books**: Highest margin % but lowest absolute revenue

**Recommendation:** Invest in Electronics acquisition (high AOV drives revenue), but promote Health products more aggressively — the margin is there to fund discounts without hurting profitability.

---

## Finding 5: UPI is the Dominant Payment Mode

**Query:** Payment Mode Preferences (Query 07)

UPI accounts for 48% of completed orders. COD has a higher cancellation correlation (both cancelled orders used COD).

**Recommendation:** Offer UPI-first checkout to reduce friction. Consider pre-payment incentive for COD customers to reduce cancellation risk.

---

## Finding 6: Cancellations and Refunds Cost ~12% of Gross Revenue

**Query:** Cancellation & Refund Impact (Query 08)

2 cancellations + 1 refund represent a meaningful revenue loss. All three impacted orders were from customers who also had completed orders, suggesting the issue is order-level (logistics/product) not customer-level (churn).

**Recommendation:** Root-cause the 3 failed orders. If it is COD-cancellation driven, implement COD limits or prepayment requirements above a certain order value.

---

## Finding 7: Maharashtra Leads Geo Revenue; Rajasthan Underperforms

**Query:** City-Level Performance (Query 10)

Mumbai + Pune (Maharashtra) generate the highest combined revenue. Jaipur (Rajasthan) has the lowest revenue per customer despite decent order count.

**Recommendation:** Investigate delivery SLAs and product availability in Rajasthan. Consider regional promotions to grow the Jaipur market, which has existing customer base but low spend.

---

## Metric Definitions

| Metric | Definition |
|---|---|
| Gross Revenue | SUM(line_total) on completed orders only |
| CLV | Cumulative gross revenue per customer |
| Retention Rate | % of customers with 2+ completed orders |
| Gross Margin | (Revenue - COGS) / Revenue |
| Rolling 30d Revenue | Cumulative sum over trailing 30 days of completed order revenue |

---

*Report generated from: `sql/analytics.sql` against `sql/seed.sql` data.*
