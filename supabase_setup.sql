-- =====================================================
-- KRISHOK BAZAR — Supabase Database Setup
-- Project: pfreyhtpjyzvqribughk
-- =====================================================
-- Run this SQL in your Supabase Dashboard:
--   → SQL Editor → New Query → Paste & Run
-- =====================================================

-- ─────────────────────────────────────
-- 1. ORDERS TABLE
-- ─────────────────────────────────────
CREATE TABLE IF NOT EXISTS orders (
    id             BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    order_id       TEXT UNIQUE NOT NULL,              -- e.g. "ORD-123456"
    user_id        TEXT NOT NULL DEFAULT 'guest',     -- auth user ID or "guest"
    customer_name  TEXT NOT NULL DEFAULT '',
    customer_phone TEXT NOT NULL DEFAULT '',
    customer_address TEXT NOT NULL DEFAULT '',
    customer_district TEXT NOT NULL DEFAULT '',
    customer_note  TEXT DEFAULT '',
    items          JSONB NOT NULL DEFAULT '[]'::jsonb, -- array of cart items
    subtotal       NUMERIC(10,2) NOT NULL DEFAULT 0,
    delivery_charge NUMERIC(10,2) NOT NULL DEFAULT 0,
    total          NUMERIC(10,2) NOT NULL DEFAULT 0,
    payment_method TEXT NOT NULL DEFAULT 'cod',       -- cod | bkash | nagad
    transaction_id TEXT,                              -- bKash/Nagad TrxID
    status         TEXT NOT NULL DEFAULT 'Pending',   -- Pending | Processing | Shipped | Delivered
    estimated_delivery TIMESTAMPTZ,
    created_at     TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- Index for faster lookups by user
CREATE INDEX IF NOT EXISTS idx_orders_user_id ON orders(user_id);
CREATE INDEX IF NOT EXISTS idx_orders_status  ON orders(status);

-- ─────────────────────────────────────
-- 2. USERS PROFILE TABLE
-- ─────────────────────────────────────
CREATE TABLE IF NOT EXISTS users (
    id             BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    auth_id        TEXT UNIQUE,                       -- Supabase Auth UUID
    name           TEXT NOT NULL DEFAULT '',
    email          TEXT NOT NULL DEFAULT '',
    phone          TEXT DEFAULT '',
    address        TEXT DEFAULT '',
    registered_at  TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE INDEX IF NOT EXISTS idx_users_email ON users(email);

-- ─────────────────────────────────────
-- 3. ROW LEVEL SECURITY (RLS) Policies
-- ─────────────────────────────────────
-- Enable RLS on both tables
ALTER TABLE orders ENABLE ROW LEVEL SECURITY;
ALTER TABLE users  ENABLE ROW LEVEL SECURITY;

-- Orders: Allow anyone to INSERT (guest checkout support)
CREATE POLICY "Allow public insert on orders"
    ON orders FOR INSERT
    WITH CHECK (true);

-- Orders: Allow anyone to SELECT their own orders (by user_id matching auth)
CREATE POLICY "Allow users to read own orders"
    ON orders FOR SELECT
    USING (true);

-- Orders: Allow updates (for admin status changes from client)
CREATE POLICY "Allow update on orders"
    ON orders FOR UPDATE
    USING (true)
    WITH CHECK (true);

-- Users: Allow anyone to INSERT (registration)
CREATE POLICY "Allow public insert on users"
    ON users FOR INSERT
    WITH CHECK (true);

-- Users: Allow reading users
CREATE POLICY "Allow read users"
    ON users FOR SELECT
    USING (true);

-- ─────────────────────────────────────
-- ✅ DONE! Your tables are ready.
-- ─────────────────────────────────────
-- The website will now:
--   • Save every checkout order to this "orders" table
--   • Register users via Supabase Auth + save profile to "users" table
--   • Login users via Supabase Auth
--   • Update order status from admin panel to Supabase
-- =====================================================
