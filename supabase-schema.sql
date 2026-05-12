-- GoGo Games Supabase schema
-- Run this in Supabase SQL Editor after creating your project.

create extension if not exists pgcrypto;

create table if not exists public.profiles (
  id uuid primary key references auth.users(id) on delete cascade,
  username text,
  email text,
  plan text not null default 'free' check (plan in ('free', 'pro', 'studio')),
  plays integer not null default 0,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

create table if not exists public.game_plays (
  id uuid primary key default gen_random_uuid(),
  user_id uuid references auth.users(id) on delete set null,
  game_name text not null,
  score integer not null default 0,
  created_at timestamptz not null default now()
);

create table if not exists public.creator_games (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null references auth.users(id) on delete cascade,
  title text not null,
  game_data jsonb not null default '{}'::jsonb,
  is_published boolean not null default false,
  plays integer not null default 0,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

create table if not exists public.payments (
  id uuid primary key default gen_random_uuid(),
  user_id uuid references auth.users(id) on delete set null,
  stripe_session_id text unique,
  stripe_customer_id text,
  plan text check (plan in ('pro', 'studio')),
  amount_cents integer,
  status text not null default 'pending',
  created_at timestamptz not null default now()
);

create or replace function public.handle_new_user()
returns trigger
language plpgsql
security definer
set search_path = public
as $$
begin
  insert into public.profiles (id, username, email)
  values (
    new.id,
    coalesce(new.raw_user_meta_data->>'username', split_part(new.email, '@', 1)),
    new.email
  )
  on conflict (id) do nothing;
  return new;
end;
$$;

drop trigger if exists on_auth_user_created on auth.users;
create trigger on_auth_user_created
after insert on auth.users
for each row execute function public.handle_new_user();

alter table public.profiles enable row level security;
alter table public.game_plays enable row level security;
alter table public.creator_games enable row level security;
alter table public.payments enable row level security;

drop policy if exists "profiles_select_own" on public.profiles;
create policy "profiles_select_own"
on public.profiles for select
using (auth.uid() = id);

drop policy if exists "profiles_insert_own" on public.profiles;
create policy "profiles_insert_own"
on public.profiles for insert
with check (auth.uid() = id);

drop policy if exists "profiles_update_own" on public.profiles;
create policy "profiles_update_own"
on public.profiles for update
using (auth.uid() = id)
with check (auth.uid() = id);

drop policy if exists "game_plays_insert_any_auth" on public.game_plays;
create policy "game_plays_insert_any_auth"
on public.game_plays for insert
with check (auth.uid() = user_id or user_id is null);

drop policy if exists "game_plays_select_public" on public.game_plays;
create policy "game_plays_select_public"
on public.game_plays for select
using (true);

drop policy if exists "creator_games_owner_all" on public.creator_games;
create policy "creator_games_owner_all"
on public.creator_games for all
using (auth.uid() = user_id)
with check (auth.uid() = user_id);

drop policy if exists "creator_games_select_published" on public.creator_games;
create policy "creator_games_select_published"
on public.creator_games for select
using (is_published = true or auth.uid() = user_id);

drop policy if exists "payments_owner_select" on public.payments;
create policy "payments_owner_select"
on public.payments for select
using (auth.uid() = user_id);

-- Plan upgrades should be applied by a trusted server/webhook later.
-- Do not let browser users update payments directly in production.
