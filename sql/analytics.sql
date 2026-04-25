-- ============================================================
-- E-Commerce Analytics: Business KPI Queries
-- All queries run on SQLite 3.35+ and PostgreSQL 14+
-- ============================================================


-- ============================================================
-- 01. MONTHLY REVENUE TREND
-- KPI: Gross revenue from completed orders per month
-- Business use: Spot seasonal peaks, flag declines early
-- ============================================================
SELECT
    strftime('%Y-%m', o.order_date)         AS month,
    COUNT(DISTINCT o.order_id)              AS orders,
    COUNT(DISTINCT o.customer_id)           AS unique_customers,
    ROUND(SUM(oi.line_total), 2)            AS gross_revenue,
    ROUND(AVG(oi.line_total), 2)            AS avg_order_value
FROM orders o
JOIN order_items oi ON o.order_id = oi.order_id
WHERE o.status = 'completed'
GROUP BY month
ORDER BY month;


-- ============================================================
-- 02. CUSTOMER LIFETIME VALUE (CLV) RANKING
-- KPI: Total revenue per customer, ranked
-- Business use: Identify VIP segment and churn risk
-- ============================================================
SELECT
    c.customer_id,
    c.name,
    c.segment,
    c.city,
    COUNT(DISTINCT o.order_id)             AS total_orders,
    ROUND(SUM(oi.line_total), 2)           AS lifetime_value,
    ROUND(AVG(oi.line_total), 2)           AS avg_order_value,
    RANK() OVER (ORDER BY SUM(oi.line_total) DESC) AS clv_rank
FROM customers c
JOIN orders o     ON c.customer_id = o.customer_id AND o.status = 'completed'
JOIN order_items oi ON o.order_id  = oi.order_id
GROUP BY c.customer_id, c.name, c.segment, c.city
ORDER BY clv_rank;


-- ============================================================
-- 03. CUSTOMER RETENTION: REPEAT PURCHASER RATE
-- KPI: % of customers with more than 1 completed order
-- Business use: Core health metric for any e-commerce business
-- ============================================================
WITH order_counts AS (
    SELECT customer_id, COUNT(*) AS completed_orders
    FROM orders
    WHERE status = 'completed'
    GROUP BY customer_id
)
SELECT
    COUNT(*)                                                    AS total_customers_with_orders,
    SUM(CASE WHEN completed_orders > 1 THEN 1 ELSE 0 END)      AS repeat_customers,
    ROUND(
        100.0 * SUM(CASE WHEN completed_orders > 1 THEN 1 ELSE 0 END)
        / COUNT(*), 2
    )                                                           AS retention_rate_pct
FROM order_counts;


-- ============================================================
-- 04. TOP PRODUCTS BY REVENUE AND PROFIT MARGIN
-- KPI: Which SKUs drive the most revenue and margin?
-- Business use: Inventory decisions and promotions targeting
-- ============================================================
SELECT
    p.product_id,
    p.name,
    p.category,
    COUNT(oi.item_id)                                          AS times_ordered,
    SUM(oi.quantity)                                           AS units_sold,
    ROUND(SUM(oi.line_total), 2)                               AS total_revenue,
    ROUND(SUM(oi.quantity * p.cost_price), 2)                  AS total_cost,
    ROUND(SUM(oi.line_total) - SUM(oi.quantity * p.cost_price), 2) AS gross_profit,
    ROUND(
        100.0 * (SUM(oi.line_total) - SUM(oi.quantity * p.cost_price))
        / NULLIF(SUM(oi.line_total), 0), 2
    )                                                          AS margin_pct
FROM products p
JOIN order_items oi ON p.product_id = oi.product_id
JOIN orders o       ON oi.order_id  = o.order_id AND o.status = 'completed'
GROUP BY p.product_id, p.name, p.category
ORDER BY total_revenue DESC;


-- ============================================================
-- 05. ROLLING 30-DAY REVENUE (WINDOW FUNCTION)
-- KPI: Smoothed revenue trend using cumulative window
-- Business use: Reduces noise from day-of-week effects
-- ============================================================
WITH daily_revenue AS (
    SELECT
        o.order_date,
        ROUND(SUM(oi.line_total), 2) AS day_revenue
    FROM orders o
    JOIN order_items oi ON o.order_id = oi.order_id
    WHERE o.status = 'completed'
    GROUP BY o.order_date
)
SELECT
    order_date,
    day_revenue,
    ROUND(SUM(day_revenue) OVER (
        ORDER BY order_date
        ROWS BETWEEN 29 PRECEDING AND CURRENT ROW
    ), 2)                             AS rolling_30d_revenue,
    ROUND(AVG(day_revenue) OVER (
        ORDER BY order_date
        ROWS BETWEEN 6 PRECEDING AND CURRENT ROW
    ), 2)                             AS rolling_7d_avg
FROM daily_revenue
ORDER BY order_date;


-- ============================================================
-- 06. CATEGORY PERFORMANCE BREAKDOWN
-- KPI: Revenue, units, and margin by product category
-- Business use: Budget allocation across categories
-- ============================================================
SELECT
    p.category,
    COUNT(DISTINCT oi.order_id)            AS orders,
    SUM(oi.quantity)                       AS units_sold,
    ROUND(SUM(oi.line_total), 2)           AS revenue,
    ROUND(AVG(oi.discount_pct) * 100, 1)  AS avg_discount_pct,
    ROUND(100.0 * SUM(oi.line_total) /
          SUM(SUM(oi.line_total)) OVER (), 2) AS revenue_share_pct
FROM products p
JOIN order_items oi ON p.product_id  = oi.product_id
JOIN orders o       ON oi.order_id   = o.order_id AND o.status = 'completed'
GROUP BY p.category
ORDER BY revenue DESC;


-- ============================================================
-- 07. PAYMENT MODE PREFERENCES
-- KPI: Order count and revenue split by payment method
-- Business use: Checkout UX prioritisation, cashback deals
-- ============================================================
SELECT
    o.payment_mode,
    COUNT(*)                              AS orders,
    ROUND(SUM(oi.line_total), 2)          AS revenue,
    ROUND(100.0 * COUNT(*) /
          SUM(COUNT(*)) OVER (), 2)       AS order_share_pct
FROM orders o
JOIN order_items oi ON o.order_id = oi.order_id
WHERE o.status = 'completed'
GROUP BY o.payment_mode
ORDER BY orders DESC;


-- ============================================================
-- 08. CANCELLATION & REFUND IMPACT
-- KPI: Lost revenue from cancelled/refunded orders
-- Business use: Measure fulfilment quality, financial exposure
-- ============================================================
WITH revenue_by_status AS (
    SELECT
        o.status,
        COUNT(DISTINCT o.order_id)   AS order_count,
        ROUND(SUM(oi.line_total), 2) AS revenue
    FROM orders o
    JOIN order_items oi ON o.order_id = oi.order_id
    GROUP BY o.status
)
SELECT
    status,
    order_count,
    revenue,
    ROUND(100.0 * revenue / SUM(revenue) OVER (), 2) AS revenue_pct
FROM revenue_by_status
ORDER BY revenue DESC;


-- ============================================================
-- 09. COHORT ANALYSIS: MONTHLY ACQUISITION & REVENUE
-- KPI: Revenue per customer cohort (signup month)
-- Business use: See if newer cohorts are more/less valuable
-- ============================================================
WITH cohort AS (
    SELECT
        c.customer_id,
        strftime('%Y-%m', c.signup_date) AS cohort_month
    FROM customers c
)
SELECT
    co.cohort_month,
    COUNT(DISTINCT co.customer_id)         AS cohort_size,
    COUNT(DISTINCT o.order_id)             AS total_orders,
    ROUND(SUM(oi.line_total), 2)           AS total_revenue,
    ROUND(SUM(oi.line_total) /
          COUNT(DISTINCT co.customer_id), 2) AS revenue_per_customer
FROM cohort co
LEFT JOIN orders o       ON co.customer_id = o.customer_id AND o.status = 'completed'
LEFT JOIN order_items oi ON o.order_id     = oi.order_id
GROUP BY co.cohort_month
ORDER BY co.cohort_month;


-- ============================================================
-- 10. CITY-LEVEL PERFORMANCE (GEO ANALYSIS)
-- KPI: Revenue and order volume by city
-- Business use: Expansion decisions, delivery zone priorities
-- ============================================================
SELECT
    o.state,
    o.city,
    COUNT(DISTINCT o.order_id)                AS orders,
    COUNT(DISTINCT o.customer_id)             AS customers,
    ROUND(SUM(oi.line_total), 2)              AS revenue,
    ROUND(SUM(oi.line_total) /
          COUNT(DISTINCT o.customer_id), 2)   AS revenue_per_customer,
    DENSE_RANK() OVER (
        PARTITION BY o.state
        ORDER BY SUM(oi.line_total) DESC
    )                                         AS rank_in_state
FROM orders o
JOIN order_items oi ON o.order_id = oi.order_id
WHERE o.status = 'completed'
GROUP BY o.state, o.city
ORDER BY revenue DESC;
