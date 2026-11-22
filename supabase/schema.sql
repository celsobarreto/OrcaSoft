-- OrçaSoftware: armazenamento por conta autenticada do Supabase
create table if not exists public.orca_user_data (
  user_id uuid primary key references auth.users(id) on delete cascade,
  data jsonb not null default '{}'::jsonb,
  updated_at timestamptz not null default now()
);

alter table public.orca_user_data enable row level security;
grant select, insert, update, delete on public.orca_user_data to authenticated;

drop policy if exists "orca_users_manage_own_data" on public.orca_user_data;
create policy "orca_users_manage_own_data"
  on public.orca_user_data
  for all
  to authenticated
  using (auth.uid() = user_id)
  with check (auth.uid() = user_id);
