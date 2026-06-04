-- Database-only setup
-- Run in Supabase SQL Editor.
-- This keeps product/contact/payment settings in DB, not in index.html code.

-- Store settings table for contact info, social links, and payment numbers
create table if not exists public.store_settings (
  key text primary key,
  value text,
  updated_at timestamptz default now()
);

-- Allow the website to read public store settings
alter table public.store_settings enable row level security;

drop policy if exists "store_settings_read_all" on public.store_settings;
create policy "store_settings_read_all"
on public.store_settings
for select
to anon, authenticated
using (true);

-- Only authenticated users can change settings (for stronger security, restrict with admin RPC/policies)
drop policy if exists "store_settings_admin_write" on public.store_settings;
create policy "store_settings_admin_write"
on public.store_settings
for all
to authenticated
using (true)
with check (true);

-- Insert/update your settings here. Replace values with your real info.
insert into public.store_settings (key, value) values
  ('phone', ''),
  ('email', ''),
  ('address', ''),
  ('facebook_url', ''),
  ('whatsapp_url', ''),
  ('youtube_url', ''),
  ('bkash_number', ''),
  ('nagad_number', '')
on conflict (key) do update
set value = excluded.value,
    updated_at = now();

-- Products should be stored in public.products only.
-- Existing frontend expects columns like:
-- id, name, category, price, old_price, unit, rating, stock, image, description, updated_at

-- Check there is no need for frontend mock products anymore:
select * from public.store_settings;
