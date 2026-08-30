create table if not exists public.malaak_initial_maps (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null references auth.users(id) on delete cascade,
  primary_concern text not null,
  life_context text not null,
  current_impact text not null check (current_impact in ('low','moderate','high')),
  immediate_safety jsonb not null default '{}'::jsonb,
  desired_change text not null,
  coaching_preference text not null check (coaching_preference in ('listen','organize','challenge_thoughts','act','calm')),
  privacy_scope jsonb not null default '{}'::jsonb,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),
  unique (user_id)
);

create table if not exists public.malaak_observations (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null references auth.users(id) on delete cascade,
  source_type text not null,
  source_id text null,
  occurred_at timestamptz not null default now(),
  context_domain text not null default 'self',
  trigger text null,
  event_fact text null,
  automatic_thought text null,
  emotion text null,
  intensity_before smallint null check (intensity_before between 0 and 10),
  body_signals jsonb not null default '[]'::jsonb,
  urge text null,
  need text null,
  behavior text null,
  outcome text null,
  intensity_after smallint null check (intensity_after between 0 and 10),
  recovery_minutes integer null check (recovery_minutes is null or recovery_minutes >= 0),
  intervention_code text null,
  intervention_version integer null,
  intervention_helpfulness text null,
  extraction_origin text not null check (extraction_origin in ('user_structured','user_confirmed','model_extracted')),
  confirmed_by_user boolean not null default false,
  created_at timestamptz not null default now()
);

create index if not exists malaak_observations_user_occurred_idx
  on public.malaak_observations(user_id, occurred_at desc);
create index if not exists malaak_observations_user_domain_idx
  on public.malaak_observations(user_id, context_domain, occurred_at desc);

create table if not exists public.malaak_hypotheses (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null references auth.users(id) on delete cascade,
  domain text not null,
  pattern_key text not null,
  statement_ar text not null,
  status text not null default 'candidate' check (status in ('candidate','repeated','user_validated','user_rejected','dormant')),
  confidence_label text not null default 'low' check (confidence_label in ('low','medium','high')),
  supporting_observation_ids uuid[] not null default '{}'::uuid[],
  contradicting_observation_ids uuid[] not null default '{}'::uuid[],
  support_count integer not null default 0 check (support_count >= 0),
  distinct_days integer not null default 0 check (distinct_days >= 0),
  distinct_contexts integer not null default 0 check (distinct_contexts >= 0),
  first_seen_at timestamptz not null default now(),
  last_seen_at timestamptz not null default now(),
  user_validation text null check (user_validation is null or user_validation in ('yes','partly','no')),
  user_feedback text null,
  rejected_at timestamptz null,
  updated_at timestamptz not null default now(),
  unique (user_id, domain, pattern_key)
);

create index if not exists malaak_hypotheses_user_status_idx
  on public.malaak_hypotheses(user_id, status, last_seen_at desc);

create table if not exists public.malaak_formulations (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null references auth.users(id) on delete cascade,
  version integer not null check (version > 0),
  status text not null default 'active' check (status in ('active','archived')),
  primary_context text null,
  current_state_summary text not null default '',
  vulnerability_factors jsonb not null default '[]'::jsonb,
  trigger_patterns jsonb not null default '[]'::jsonb,
  interpretation_patterns jsonb not null default '[]'::jsonb,
  emotion_patterns jsonb not null default '[]'::jsonb,
  need_patterns jsonb not null default '[]'::jsonb,
  behavior_patterns jsonb not null default '[]'::jsonb,
  short_term_consequences jsonb not null default '[]'::jsonb,
  long_term_consequences jsonb not null default '[]'::jsonb,
  protective_factors jsonb not null default '[]'::jsonb,
  current_goals jsonb not null default '[]'::jsonb,
  validated_insights jsonb not null default '[]'::jsonb,
  unknowns jsonb not null default '[]'::jsonb,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),
  unique (user_id, version)
);

create unique index if not exists malaak_formulations_one_active_idx
  on public.malaak_formulations(user_id)
  where status = 'active';

alter table public.malaak_initial_maps enable row level security;
alter table public.malaak_observations enable row level security;
alter table public.malaak_hypotheses enable row level security;
alter table public.malaak_formulations enable row level security;

revoke all privileges on table public.malaak_initial_maps from anon, authenticated;
revoke all privileges on table public.malaak_observations from anon, authenticated;
revoke all privileges on table public.malaak_hypotheses from anon, authenticated;
revoke all privileges on table public.malaak_formulations from anon, authenticated;

grant select on table public.malaak_initial_maps to authenticated;
grant select on table public.malaak_observations to authenticated;
grant select on table public.malaak_hypotheses to authenticated;
grant select on table public.malaak_formulations to authenticated;

create policy malaak_initial_maps_own_select on public.malaak_initial_maps
  for select to authenticated using ((select auth.uid()) = user_id);
create policy malaak_observations_own_select on public.malaak_observations
  for select to authenticated using ((select auth.uid()) = user_id);
create policy malaak_hypotheses_own_select on public.malaak_hypotheses
  for select to authenticated using ((select auth.uid()) = user_id);
create policy malaak_formulations_own_select on public.malaak_formulations
  for select to authenticated using ((select auth.uid()) = user_id);

create or replace function public.malaak_save_initial_map(p_map jsonb)
returns public.malaak_initial_maps
language plpgsql
security definer
set search_path = public, auth
as $$
declare
  v_uid uuid := auth.uid();
  v_row public.malaak_initial_maps;
begin
  if v_uid is null then raise exception 'authentication_required'; end if;
  if coalesce(trim(p_map->>'primaryConcern'),'') = '' then raise exception 'primary_concern_required'; end if;
  if coalesce(trim(p_map->>'lifeContext'),'') = '' then raise exception 'life_context_required'; end if;
  if coalesce(p_map->>'currentImpact','') not in ('low','moderate','high') then raise exception 'invalid_current_impact'; end if;
  if coalesce(trim(p_map->>'desiredChange'),'') = '' then raise exception 'desired_change_required'; end if;
  if coalesce(p_map->>'coachingPreference','') not in ('listen','organize','challenge_thoughts','act','calm') then raise exception 'invalid_coaching_preference'; end if;

  insert into public.malaak_initial_maps(
    user_id, primary_concern, life_context, current_impact, immediate_safety,
    desired_change, coaching_preference, privacy_scope, updated_at
  ) values (
    v_uid,
    trim(p_map->>'primaryConcern'),
    trim(p_map->>'lifeContext'),
    p_map->>'currentImpact',
    coalesce(p_map->'immediateSafety','{}'::jsonb),
    trim(p_map->>'desiredChange'),
    p_map->>'coachingPreference',
    coalesce(p_map->'privacyScope','{}'::jsonb),
    now()
  )
  on conflict (user_id) do update set
    primary_concern=excluded.primary_concern,
    life_context=excluded.life_context,
    current_impact=excluded.current_impact,
    immediate_safety=excluded.immediate_safety,
    desired_change=excluded.desired_change,
    coaching_preference=excluded.coaching_preference,
    privacy_scope=excluded.privacy_scope,
    updated_at=now()
  returning * into v_row;
  return v_row;
end;
$$;

create or replace function public.malaak_submit_observation(p_observation jsonb)
returns public.malaak_observations
language plpgsql
security definer
set search_path = public, auth
as $$
declare
  v_uid uuid := auth.uid();
  v_origin text := coalesce(p_observation->>'extractionOrigin','user_structured');
  v_row public.malaak_observations;
begin
  if v_uid is null then raise exception 'authentication_required'; end if;
  if v_origin not in ('user_structured','user_confirmed') then raise exception 'client_origin_not_allowed'; end if;
  if coalesce(trim(p_observation->>'sourceType'),'') = '' then raise exception 'source_type_required'; end if;

  insert into public.malaak_observations(
    user_id, source_type, source_id, occurred_at, context_domain, trigger, event_fact,
    automatic_thought, emotion, intensity_before, body_signals, urge, need, behavior,
    outcome, intensity_after, recovery_minutes, intervention_code, intervention_version,
    intervention_helpfulness, extraction_origin, confirmed_by_user
  ) values (
    v_uid,
    trim(p_observation->>'sourceType'),
    nullif(trim(p_observation->>'sourceId'),''),
    coalesce((p_observation->>'occurredAt')::timestamptz, now()),
    coalesce(nullif(trim(p_observation->>'contextDomain'),''),'self'),
    nullif(trim(p_observation->>'trigger'),''),
    nullif(trim(p_observation->>'eventFact'),''),
    nullif(trim(p_observation->>'automaticThought'),''),
    nullif(trim(p_observation->>'emotion'),''),
    case when p_observation ? 'intensityBefore' then (p_observation->>'intensityBefore')::smallint else null end,
    coalesce(p_observation->'bodySignals','[]'::jsonb),
    nullif(trim(p_observation->>'urge'),''),
    nullif(trim(p_observation->>'need'),''),
    nullif(trim(p_observation->>'behavior'),''),
    nullif(trim(p_observation->>'outcome'),''),
    case when p_observation ? 'intensityAfter' then (p_observation->>'intensityAfter')::smallint else null end,
    case when p_observation ? 'recoveryMinutes' then (p_observation->>'recoveryMinutes')::integer else null end,
    nullif(trim(p_observation->>'interventionCode'),''),
    case when p_observation ? 'interventionVersion' then (p_observation->>'interventionVersion')::integer else null end,
    nullif(trim(p_observation->>'interventionHelpfulness'),''),
    v_origin,
    coalesce((p_observation->>'confirmedByUser')::boolean, v_origin='user_confirmed')
  ) returning * into v_row;
  return v_row;
end;
$$;

create or replace function public.malaak_reject_hypothesis(p_hypothesis_id uuid, p_feedback text default null)
returns public.malaak_hypotheses
language plpgsql
security definer
set search_path = public, auth
as $$
declare
  v_uid uuid := auth.uid();
  v_row public.malaak_hypotheses;
begin
  if v_uid is null then raise exception 'authentication_required'; end if;
  update public.malaak_hypotheses
     set status='user_rejected', user_validation='no', user_feedback=nullif(trim(p_feedback),''), rejected_at=now(), updated_at=now()
   where id=p_hypothesis_id and user_id=v_uid
   returning * into v_row;
  if v_row.id is null then raise exception 'hypothesis_not_found'; end if;
  return v_row;
end;
$$;

revoke all on function public.malaak_save_initial_map(jsonb) from public, anon;
revoke all on function public.malaak_submit_observation(jsonb) from public, anon;
revoke all on function public.malaak_reject_hypothesis(uuid,text) from public, anon;
grant execute on function public.malaak_save_initial_map(jsonb) to authenticated;
grant execute on function public.malaak_submit_observation(jsonb) to authenticated;
grant execute on function public.malaak_reject_hypothesis(uuid,text) to authenticated;

create or replace function public.malaak_store_formulation_snapshot(p_user_id uuid, p_snapshot jsonb)
returns public.malaak_formulations
language plpgsql
security definer
set search_path = public, auth
as $$
declare
  v_version integer;
  v_row public.malaak_formulations;
begin
  if p_user_id is null then raise exception 'user_id_required'; end if;
  if p_snapshot is null or jsonb_typeof(p_snapshot) <> 'object' then raise exception 'snapshot_required'; end if;

  perform pg_advisory_xact_lock(hashtextextended(p_user_id::text, 0));
  select coalesce(max(version), 0) + 1 into v_version
    from public.malaak_formulations
   where user_id = p_user_id;

  update public.malaak_formulations
     set status='archived', updated_at=now()
   where user_id=p_user_id and status='active';

  insert into public.malaak_formulations(
    user_id, version, status, primary_context, current_state_summary,
    vulnerability_factors, trigger_patterns, interpretation_patterns, emotion_patterns,
    need_patterns, behavior_patterns, short_term_consequences, long_term_consequences,
    protective_factors, current_goals, validated_insights, unknowns
  ) values (
    p_user_id,
    v_version,
    'active',
    nullif(trim(p_snapshot->>'primary_context'),''),
    coalesce(p_snapshot->>'current_state_summary',''),
    coalesce(p_snapshot->'vulnerability_factors','[]'::jsonb),
    coalesce(p_snapshot->'trigger_patterns','[]'::jsonb),
    coalesce(p_snapshot->'interpretation_patterns','[]'::jsonb),
    coalesce(p_snapshot->'emotion_patterns','[]'::jsonb),
    coalesce(p_snapshot->'need_patterns','[]'::jsonb),
    coalesce(p_snapshot->'behavior_patterns','[]'::jsonb),
    coalesce(p_snapshot->'short_term_consequences','[]'::jsonb),
    coalesce(p_snapshot->'long_term_consequences','[]'::jsonb),
    coalesce(p_snapshot->'protective_factors','[]'::jsonb),
    coalesce(p_snapshot->'current_goals','[]'::jsonb),
    coalesce(p_snapshot->'validated_insights','[]'::jsonb),
    coalesce(p_snapshot->'unknowns','[]'::jsonb)
  ) returning * into v_row;

  return v_row;
end;
$$;

revoke all on function public.malaak_store_formulation_snapshot(uuid,jsonb) from public, anon, authenticated;
grant execute on function public.malaak_store_formulation_snapshot(uuid,jsonb) to service_role;
