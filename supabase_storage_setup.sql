-- =====================================================
-- KRISHOK BAZAR — Supabase Storage Setup for Product Images
-- =====================================================
-- Run this SQL in your Supabase Dashboard:
--   → SQL Editor → New Query → Paste & Run
-- =====================================================

-- 1. Create a public storage bucket for product images
INSERT INTO storage.buckets (id, name, public, file_size_limit, allowed_mime_types)
VALUES (
    'product-images',
    'product-images',
    true,                                               -- public bucket (images viewable without auth)
    5242880,                                            -- 5MB max file size
    ARRAY['image/jpeg', 'image/png', 'image/webp', 'image/gif']::text[]
)
ON CONFLICT (id) DO NOTHING;

-- 2. Allow anyone to upload files (for admin panel uploads)
CREATE POLICY "Allow public upload to product-images"
ON storage.objects FOR INSERT
WITH CHECK (bucket_id = 'product-images');

-- 3. Allow anyone to read/view images (public product images)
CREATE POLICY "Allow public read product-images"
ON storage.objects FOR SELECT
USING (bucket_id = 'product-images');

-- 4. Allow anyone to update/overwrite images
CREATE POLICY "Allow public update product-images"
ON storage.objects FOR UPDATE
USING (bucket_id = 'product-images')
WITH CHECK (bucket_id = 'product-images');

-- 5. Allow anyone to delete images (admin cleanup)
CREATE POLICY "Allow public delete product-images"
ON storage.objects FOR DELETE
USING (bucket_id = 'product-images');

-- =====================================================
-- ✅ DONE! Storage bucket "product-images" is ready.
-- Now admin panel can upload images → get public URL
-- =====================================================
