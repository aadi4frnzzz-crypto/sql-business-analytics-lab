-- ============================================================
-- E-Commerce Analytics Lab: Database Schema
-- Compatible with: SQLite 3.x, PostgreSQL 14+
-- ============================================================

-- Dimension: Customers
CREATE TABLE IF NOT EXISTS customers (
    customer_id   INTEGER PRIMARY KEY,
    name          TEXT    NOT NULL,
    email         TEXT    UNIQUE NOT NULL,
    city          TEXT    NOT NULL,
    state         TEXT    NOT NULL,
    signup_date   DATE    NOT NULL,
    segment       TEXT    CHECK(segment IN ('retail','wholesale','vip')) DEFAULT 'retail'
);

-- Dimension: Products
CREATE TABLE IF NOT EXISTS products (
    product_id    INTEGER PRIMARY KEY,
    name          TEXT    NOT NULL,
    category      TEXT    NOT NULL,
    sub_category  TEXT,
    unit_price    REAL    NOT NULL CHECK(unit_price > 0),
    cost_price    REAL    NOT NULL CHECK(cost_price > 0)
);

-- Fact: Orders (header)
CREATE TABLE IF NOT EXISTS orders (
    order_id      INTEGER PRIMARY KEY,
    customer_id   INTEGER NOT NULL REFERENCES customers(customer_id),
    order_date    DATE    NOT NULL,
    status        TEXT    NOT NULL CHECK(status IN ('pending','completed','cancelled','refunded')),
    city          TEXT,
    state         TEXT,
    payment_mode  TEXT    CHECK(payment_mode IN ('upi','card','cod','netbanking'))
);

-- Fact: Order Line Items
CREATE TABLE IF NOT EXISTS order_items (
    item_id       INTEGER PRIMARY KEY AUTOINCREMENT,
    order_id      INTEGER NOT NULL REFERENCES orders(order_id),
    product_id    INTEGER NOT NULL REFERENCES products(product_id),
    quantity      INTEGER NOT NULL CHECK(quantity > 0),
    unit_price    REAL    NOT NULL,
    discount_pct  REAL    DEFAULT 0 CHECK(discount_pct BETWEEN 0 AND 1),
    line_total    REAL    GENERATED ALWAYS AS
                  (ROUND(quantity * unit_price * (1 - discount_pct), 2)) VIRTUAL
);

-- Indexes for query performance
CREATE INDEX IF NOT EXISTS idx_orders_customer   ON orders(customer_id);
CREATE INDEX IF NOT EXISTS idx_orders_date       ON orders(order_date);
CREATE INDEX IF NOT EXISTS idx_orders_status     ON orders(status);
CREATE INDEX IF NOT EXISTS idx_items_order       ON order_items(order_id);
CREATE INDEX IF NOT EXISTS idx_items_product     ON order_items(product_id);
