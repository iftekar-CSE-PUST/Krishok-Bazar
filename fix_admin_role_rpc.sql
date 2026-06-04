-- Fix Admin Role Detection (Supabase)
-- Run this in Supabase SQL Editor.
-- Replace the email below if your admin email is different.

alter table public.users
add column if not exists role text default 'user';

-- Make sure your admin profile row is linked to the Auth user and has role='admin'
insert into public.users (auth_id, name, email, role, registered_at)
select
  id::text,
  'Admin Tusar',
  'riadraj009@gmail.com',
  'admin',
  now()
from auth.users
where lower(email) = lower('riadraj009@gmail.com')
on conflict do nothing;

update public.users
set
  auth_id = (select id::text from auth.users where lower(email) = lower('riadraj009@gmail.com') limit 1),
  name = 'Admin Tusar',
  email = 'riadraj009@gmail.com',
  role = 'admin'
where lower(email) = lower('riadraj009@gmail.com')
   or auth_id = (select id::text from auth.users where lower(email) = lower('riadraj009@gmail.com') limit 1);

-- Secure RPC: frontend does NOT need admin email/password in code.
-- The function returns the logged-in user's role based on auth.uid()/JWT email.
create or replace function public.get_my_profile()
returns jsonb
language sql
security definer
set search_path = public
as $$
  select coalesce(
    (
      select jsonb_build_object(
        'name', u.name,
        'email', u.email,
        'role', coalesce(u.role, 'user')
      )
      from public.users u
      where u.auth_id = auth.uid()::text
         or lower(u.email) = lower(coalesce(auth.jwt()->>'email', ''))
      order by case when u.auth_id = auth.uid()::text then 0 else 1 end
      limit 1
    ),
    jsonb_build_object(
      'name', coalesce(auth.jwt()->'user_metadata'->>'name', split_part(coalesce(auth.jwt()->>'email', ''), '@', 1)),
      'email', auth.jwt()->>'email',
      'role', 'user'
    )
  );
$$;

grant execute on function public.get_my_profile() to authenticated;

-- Check result in table:
select auth_id, name, email, role
from public.users
where lower(email) = lower('riadraj009@gmail.com');
