-- Enable realtime updates for store_settings table in Supabase
-- Run in Supabase SQL Editor.

-- Make sure table exists
create table if not exists public.store_settings (
  key text primary key,
  value text,
  updated_at timestamptz default now()
);

-- Realtime needs replica identity for UPDATE/DELETE old values (recommended)
alter table public.store_settings replica identity full;

-- Add table to Supabase realtime publication if not already added
DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1
    FROM pg_publication_tables
    WHERE pubname = 'supabase_realtime'
      AND schemaname = 'public'
      AND tablename = 'store_settings'
  ) THEN
    ALTER PUBLICATION supabase_realtime ADD TABLE public.store_settings;
  END IF;
END $$;

-- Read policy for website
alter table public.store_settings enable row level security;

drop policy if exists "store_settings_read_all" on public.store_settings;
create policy "store_settings_read_all"
on public.store_settings
for select
to anon, authenticated
using (true);

-- Insert blank default rows if missing
insert into public.store_settings (key, value) values
  ('phone', ''),
  ('email', ''),
  ('address', ''),
  ('facebook_url', ''),
  ('whatsapp_url', ''),
  ('youtube_url', ''),
  ('bkash_number', ''),
  ('nagad_number', '')
on conflict (key) do nothing;

-- Test update example (optional):
-- update public.store_settings set value = 'test' where key = 'phone';
