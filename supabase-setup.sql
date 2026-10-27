-- Meu Controle Financeiro — tabela privada de sincronização
-- Execute no SQL Editor do SEU projeto Supabase.
-- A tabela guarda um documento JSON por usuário, com cartões, faturas,
-- parcelamentos, lançamentos e planejamento. RLS restringe cada linha ao dono.

create table if not exists public.user_finance_data (
  user_id uuid primary key references auth.users(id) on delete cascade,
  payload jsonb not null default '{"transactions":[],"plans":{},"goal":0,"cards":[]}'::jsonb,
  updated_at timestamptz not null default now()
);

alter table public.user_finance_data enable row level security;

revoke all on table public.user_finance_data from anon;
grant select, insert, update, delete on table public.user_finance_data to authenticated;

drop policy if exists "Users can read their own finance data" on public.user_finance_data;
create policy "Users can read their own finance data"
  on public.user_finance_data for select to authenticated
  using (auth.uid() = user_id);

drop policy if exists "Users can insert their own finance data" on public.user_finance_data;
create policy "Users can insert their own finance data"
  on public.user_finance_data for insert to authenticated
  with check (auth.uid() = user_id);

drop policy if exists "Users can update their own finance data" on public.user_finance_data;
create policy "Users can update their own finance data"
  on public.user_finance_data for update to authenticated
  using (auth.uid() = user_id)
  with check (auth.uid() = user_id);

drop policy if exists "Users can delete their own finance data" on public.user_finance_data;
create policy "Users can delete their own finance data"
  on public.user_finance_data for delete to authenticated
  using (auth.uid() = user_id);
