create table if not exists public.malaak_learning_states (
  user_id uuid not null references auth.users(id) on delete cascade,
  domain_id text not null,
  state jsonb not null default '{}'::jsonb,
  updated_at timestamptz not null default now(),
  primary key (user_id, domain_id)
);

alter table public.malaak_learning_states enable row level security;

drop policy if exists "malaak_learning_states_own_rows" on public.malaak_learning_states;
create policy "malaak_learning_states_own_rows"
on public.malaak_learning_states
for all
to authenticated
using ((select auth.uid()) = user_id)
with check ((select auth.uid()) = user_id);

revoke all privileges on table public.malaak_learning_states from anon;
grant select, insert, update, delete on table public.malaak_learning_states to authenticated;
