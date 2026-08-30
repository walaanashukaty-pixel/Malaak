create table if not exists public.malaak_journey_plans (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null references auth.users(id) on delete cascade,
  version integer not null check (version > 0),
  primary_domain text null,
  primary_goal text null,
  support_domain text null,
  support_goal text null,
  monitor_domains text[] not null default '{}'::text[],
  later_domains text[] not null default '{}'::text[],
  reasoning_summary_ar text not null default '',
  based_on_formulation_version integer not null check (based_on_formulation_version > 0),
  review_due_at timestamptz not null,
  status text not null default 'active' check (status in ('active','maintenance','paused')),
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),
  unique (user_id, version)
);

create index if not exists malaak_journey_plans_user_created_idx
  on public.malaak_journey_plans(user_id, created_at desc);

create unique index if not exists malaak_journey_plans_one_active_idx
  on public.malaak_journey_plans(user_id)
  where status in ('active','maintenance');

alter table public.malaak_journey_plans enable row level security;

revoke all privileges on table public.malaak_journey_plans from anon, authenticated;
grant select on table public.malaak_journey_plans to authenticated;

create policy malaak_journey_plans_own_select
  on public.malaak_journey_plans
  for select
  to authenticated
  using ((select auth.uid()) = user_id);
