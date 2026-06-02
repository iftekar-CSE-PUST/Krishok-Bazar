-- =====================================================
-- KRISHOK BAZAR — Products Table for Supabase
-- =====================================================
-- Run this in Supabase Dashboard → SQL Editor
-- =====================================================

CREATE TABLE IF NOT EXISTS products (
    id             BIGINT PRIMARY KEY,
    name           TEXT NOT NULL,
    category       TEXT NOT NULL DEFAULT 'Seeds',
    price          NUMERIC(10,2) NOT NULL DEFAULT 0,
    old_price      NUMERIC(10,2) DEFAULT 0,
    unit           TEXT DEFAULT '',
    rating         NUMERIC(3,1) DEFAULT 4.5,
    stock          INTEGER NOT NULL DEFAULT 0,
    image          TEXT DEFAULT '',
    description    TEXT DEFAULT '',
    created_at     TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at     TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- Allow public read (everyone sees products)
ALTER TABLE products ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Allow public read products"
ON products FOR SELECT USING (true);

CREATE POLICY "Allow public insert products"
ON products FOR INSERT WITH CHECK (true);

CREATE POLICY "Allow public update products"
ON products FOR UPDATE USING (true) WITH CHECK (true);

CREATE POLICY "Allow public delete products"
ON products FOR DELETE USING (true);

-- =====================================================
-- Seed the default 10 products
-- =====================================================
INSERT INTO products (id, name, category, price, old_price, unit, rating, stock, image, description) VALUES
(1, 'সবুজ সাথী কীটনাশক', 'Pesticides', 450, 520, '৫০০ মিলি', 4.5, 50, 'https://images.unsplash.com/photo-1586771107445-d3ca888129ff?auto=format&fit=crop&w=400&q=80', 'উচ্চ ক্ষমতাসম্পন্ন কীটনাশক, ফসলের পোকা দমনে অত্যন্ত কার্যকর।'),
(2, 'উন্নত ধানের বীজ', 'Seeds', 1200, 0, '১০ কেজি', 4.8, 100, 'https://images.unsplash.com/photo-1586281380349-632531db7ed4?auto=format&fit=crop&w=400&q=80', 'উচ্চ ফলনশীল বোরো ধানের বীজ। ভালো অঙ্কুরোদগম হার।'),
(3, 'জৈব কম্পোস্ট সার', 'Fertilizer', 300, 350, '২৫ কেজি', 4.6, 200, 'https://images.unsplash.com/photo-1628352081506-83c43123ed6d?auto=format&fit=crop&w=400&q=80', 'মাটির উর্বরতা বৃদ্ধিতে ১০০% প্রাকৃতিক ও রাসায়নিক মুক্ত সার।'),
(4, 'লাল তীরের টমেটো বীজ', 'Seeds', 150, 0, '১০ গ্রাম', 4.4, 80, 'https://images.unsplash.com/photo-1592841200221-a6898f307baa?auto=format&fit=crop&w=400&q=80', 'হাইব্রিড টমেটো বীজ, প্রতিটি গাছে প্রচুর ফলন।'),
(5, 'ছত্রাকনাশক প্রোটেক্ট প্লাস', 'Pesticides', 380, 0, '২৫০ গ্রাম', 4.3, 60, 'https://images.unsplash.com/photo-1530507629858-e4977d30e9e0?auto=format&fit=crop&w=400&q=80', 'ব্লাস্ট ও পাতা পচা রোগ প্রতিরোধে কার্যকর ছত্রাকনাশক।'),
(6, 'হাইব্রিড ভুট্টা বীজ', 'Seeds', 850, 950, '৫ কেজি', 4.7, 70, 'https://images.unsplash.com/photo-1551754655-cd27e38d2076?auto=format&fit=crop&w=400&q=80', 'উচ্চ ফলনশীল হাইব্রিড ভুট্টা বীজ, খরা সহনশীল।'),
(7, 'ইউরিয়া সার (প্রিমিয়াম)', 'Fertilizer', 1100, 0, '৫০ কেজি', 4.5, 150, 'https://images.unsplash.com/photo-1416879595882-3373a0480b5b?auto=format&fit=crop&w=400&q=80', 'উচ্চ মানের নাইট্রোজেন সমৃদ্ধ ইউরিয়া সার, দ্রুত বৃদ্ধির জন্য।'),
(8, 'মরিচের উন্নত বীজ', 'Seeds', 220, 280, '২০ গ্রাম', 4.6, 90, 'https://images.unsplash.com/photo-1583119022894-919a68a3d0e3?auto=format&fit=crop&w=400&q=80', 'ঝাল ও ফলন দুটোই বেশি, রোগ প্রতিরোধী কাঁচা মরিচের বীজ।'),
(9, 'ভার্মি কম্পোস্ট (কেঁচো সার)', 'Fertilizer', 260, 0, '১০ কেজি', 4.9, 120, 'https://images.unsplash.com/photo-1466692476868-aef1dfb1e735?auto=format&fit=crop&w=400&q=80', 'সম্পূর্ণ জৈব কেঁচো সার, সবজি ও ফল চাষে আদর্শ।'),
(10, 'আগাছানাশক উইড ক্লিন', 'Pesticides', 520, 0, '১ লিটার', 4.2, 0, 'https://images.unsplash.com/photo-1492496913980-501348b61469?auto=format&fit=crop&w=400&q=80', 'ক্ষেতের অবাঞ্ছিত আগাছা দূর করতে নিরাপদ ও কার্যকর।')
ON CONFLICT (id) DO NOTHING;

-- ✅ DONE!
