create table if not exists public.malaak_interventions (
  id uuid primary key default gen_random_uuid(),
  code text not null,
  version integer not null check (version > 0),
  status text not null default 'draft' check (status in ('draft','active','paused','retired','prohibited')),
  title_ar text not null,
  short_description_ar text not null default '',
  framework text not null,
  evidence_tier text not null check (evidence_tier in ('A','B','C','D','X')),
  content_origin text not null default 'original_malaak',
  licensing_status text not null check (licensing_status in ('cleared_original','licensed','review_required','restricted')),
  target_needs text[] not null default '{}',
  target_patterns text[] not null default '{}',
  eligible_states text[] not null default '{}',
  journey_domains text[] not null default '{}',
  exclusions jsonb not null default '[]'::jsonb,
  contraindication_notes_ar text not null default '',
  duration_min smallint not null default 5 check (duration_min between 1 and 120),
  steps_ar jsonb not null default '[]'::jsonb,
  action_template_ar text not null default '',
  measurement_spec jsonb not null default '{}'::jsonb,
  follow_up_spec jsonb not null default '{}'::jsonb,
  fallback_code text,
  requires_user_confirmation boolean not null default false,
  activated_at timestamptz,
  retired_at timestamptz,
  scientific_review_status text not null default 'pending' check (scientific_review_status in ('pending','reviewed','rejected')),
  clinical_boundary_review_status text not null default 'pending' check (clinical_boundary_review_status in ('pending','reviewed','rejected')),
  requires_human_support boolean not null default false,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),
  unique (code, version),
  check (status <> 'active' or evidence_tier <> 'X'),
  check (status <> 'active' or licensing_status in ('cleared_original','licensed')),
  check (status <> 'active' or scientific_review_status = 'reviewed'),
  check (status <> 'active' or clinical_boundary_review_status = 'reviewed')
);

create unique index if not exists malaak_interventions_one_active_revision_idx
  on public.malaak_interventions(code)
  where status = 'active';

create index if not exists malaak_interventions_status_code_idx
  on public.malaak_interventions(status, code, version desc);

create table if not exists public.malaak_intervention_sources (
  id uuid primary key default gen_random_uuid(),
  intervention_id uuid not null references public.malaak_interventions(id) on delete cascade,
  source_type text not null check (source_type in ('guideline','meta_analysis','systematic_review','rct','professional_manual','coaching_reference')),
  citation_text text not null,
  source_url text not null,
  publication_year integer check (publication_year is null or publication_year between 1900 and 2100),
  supports text not null,
  limitations text not null default '',
  license_notes text not null default '',
  reviewed_at timestamptz,
  reviewed_by text not null default '',
  created_at timestamptz not null default now(),
  unique (intervention_id, source_url, supports)
);

create index if not exists malaak_intervention_sources_intervention_idx
  on public.malaak_intervention_sources(intervention_id);

alter table public.malaak_coaching_turns
  add column if not exists intervention_version integer,
  add column if not exists intervention_id uuid references public.malaak_interventions(id) on delete set null;

create index if not exists malaak_coaching_turns_intervention_idx
  on public.malaak_coaching_turns(intervention_id);

alter table public.malaak_interventions enable row level security;
alter table public.malaak_intervention_sources enable row level security;

revoke all privileges on table public.malaak_interventions from anon, authenticated;
revoke all privileges on table public.malaak_intervention_sources from anon, authenticated;
grant select on table public.malaak_interventions to authenticated;
grant select on table public.malaak_intervention_sources to authenticated;

-- Catalog is intentionally read-only to ordinary app users. RLS policies are
-- SELECT-only so authenticated clients may inspect non-sensitive active metadata,
-- while all mutation remains server/admin controlled.
drop policy if exists "malaak_interventions_authenticated_read" on public.malaak_interventions;
create policy "malaak_interventions_authenticated_read"
  on public.malaak_interventions
  for select to authenticated
  using (status in ('active','paused','retired'));

drop policy if exists "malaak_intervention_sources_authenticated_read" on public.malaak_intervention_sources;
create policy "malaak_intervention_sources_authenticated_read"
  on public.malaak_intervention_sources
  for select to authenticated
  using (
    exists (
      select 1
      from public.malaak_interventions i
      where i.id = intervention_id
        and i.status in ('active','paused','retired')
    )
  );

-- Once a revision has ever been activated, scientific content is append-only.
-- Status/retirement timestamps can change; content changes require a new version.
create or replace function public.malaak_guard_intervention_revision()
returns trigger
language plpgsql
set search_path = public
as $$
begin
  if old.activated_at is not null then
    if new.code is distinct from old.code
      or new.version is distinct from old.version
      or new.title_ar is distinct from old.title_ar
      or new.short_description_ar is distinct from old.short_description_ar
      or new.framework is distinct from old.framework
      or new.evidence_tier is distinct from old.evidence_tier
      or new.content_origin is distinct from old.content_origin
      or new.licensing_status is distinct from old.licensing_status
      or new.target_needs is distinct from old.target_needs
      or new.target_patterns is distinct from old.target_patterns
      or new.eligible_states is distinct from old.eligible_states
      or new.journey_domains is distinct from old.journey_domains
      or new.exclusions is distinct from old.exclusions
      or new.contraindication_notes_ar is distinct from old.contraindication_notes_ar
      or new.duration_min is distinct from old.duration_min
      or new.steps_ar is distinct from old.steps_ar
      or new.action_template_ar is distinct from old.action_template_ar
      or new.measurement_spec is distinct from old.measurement_spec
      or new.follow_up_spec is distinct from old.follow_up_spec
      or new.fallback_code is distinct from old.fallback_code
      or new.requires_user_confirmation is distinct from old.requires_user_confirmation
      or new.scientific_review_status is distinct from old.scientific_review_status
      or new.clinical_boundary_review_status is distinct from old.clinical_boundary_review_status
      or new.requires_human_support is distinct from old.requires_human_support
    then
      raise exception 'activated intervention revisions are immutable; create a new version';
    end if;
  end if;
  new.updated_at := now();
  if old.status <> 'active' and new.status = 'active' and new.activated_at is null then
    new.activated_at := now();
  end if;
  if old.status <> 'retired' and new.status = 'retired' and new.retired_at is null then
    new.retired_at := now();
  end if;
  return new;
end;
$$;

drop trigger if exists malaak_guard_intervention_revision_trg on public.malaak_interventions;
create trigger malaak_guard_intervention_revision_trg
before update on public.malaak_interventions
for each row execute function public.malaak_guard_intervention_revision();


-- V5 audit-aware cloud state RPCs
create or replace function public.malaak_get_state()
returns jsonb
language sql
security invoker
set search_path = public
as $$
  select jsonb_build_object(
    'hasProfile', exists(select 1 from public.malaak_profiles p0 where p0.user_id = auth.uid()),
    'journals', coalesce((
      select jsonb_agg(
        jsonb_build_object(
          'id', j.id,
          'body', j.body,
          'createdAt', j.created_at,
          'title', j.title,
          'tag', j.tag,
          'includeInReports', j.include_in_reports
        ) order by j.created_at desc
      )
      from public.malaak_journals j
      where j.user_id = auth.uid()
    ), '[]'::jsonb),
    'journeys', coalesce((
      select jsonb_object_agg(
        x.domain_id,
        jsonb_build_object(
          'domainId', x.domain_id,
          'status', x.status,
          'completedPractices', x.completed_practices,
          'updatedAt', x.updated_at
        )
      )
      from public.malaak_journeys x
      where x.user_id = auth.uid()
    ), '{}'::jsonb),
    'memories', coalesce((
      select jsonb_agg(
        jsonb_build_object(
          'id', m.id,
          'type', m.type,
          'value', m.value,
          'createdAt', m.created_at,
          'confidence', m.confidence
        ) order by m.created_at desc
      )
      from public.malaak_memories m
      where m.user_id = auth.uid()
    ), '[]'::jsonb),
    'preferences', coalesce((
      select jsonb_build_object(
        'allowPatterns', p.allow_patterns,
        'allowJournalAnalysis', p.allow_journal_analysis,
        'includeInReports', p.include_in_reports,
        'displayName', p.display_name
      )
      from public.malaak_profiles p
      where p.user_id = auth.uid()
    ), jsonb_build_object(
      'allowPatterns', true,
      'allowJournalAnalysis', false,
      'includeInReports', true,
      'displayName', ''
    )),
    'messages', coalesce((
      select jsonb_agg(
        jsonb_build_object(
          'id', msg.id,
          'text', msg.text,
          'isUser', msg.is_user,
          'createdAt', msg.created_at
        ) order by msg.created_at asc
      )
      from public.malaak_messages msg
      where msg.user_id = auth.uid()
    ), '[]'::jsonb),
    'coachingTurns', coalesce((
      select jsonb_agg(
        jsonb_build_object(
          'id', ct.id,
          'createdAt', ct.created_at,
          'mode', ct.mode,
          'state', ct.state,
          'need', ct.need,
          'pattern', ct.pattern,
          'patternConfidence', ct.pattern_confidence,
          'goal', ct.goal,
          'interventionCode', ct.intervention_code,
          'interventionVersion', ct.intervention_version,
          'interventionId', ct.intervention_id,
          'action', ct.action,
          'followUp', ct.follow_up
        ) order by ct.created_at asc
      )
      from public.malaak_coaching_turns ct
      where ct.user_id = auth.uid()
    ), '[]'::jsonb),
    'pendingFollowUps', coalesce((
      select jsonb_agg(
        jsonb_build_object(
          'id', f.id,
          'timing', f.timing,
          'prompt', f.prompt,
          'journeyDomainId', f.journey_domain_id,
          'createdAt', f.created_at,
          'completedAt', f.completed_at
        ) order by f.created_at asc
      )
      from public.malaak_followups f
      where f.user_id = auth.uid() and f.completed_at is null
    ), '[]'::jsonb)
  );
$$;

create or replace function public.malaak_sync_state(p_state jsonb)
returns jsonb
language plpgsql
security invoker
set search_path = public
as $$
declare
  v_uid uuid := auth.uid();
  v_prefs jsonb := coalesce(p_state->'preferences', '{}'::jsonb);
begin
  if v_uid is null then
    raise exception 'authentication required';
  end if;

  insert into public.malaak_profiles (
    user_id, display_name, allow_patterns, allow_journal_analysis, include_in_reports, updated_at
  ) values (
    v_uid,
    coalesce(v_prefs->>'displayName', ''),
    coalesce((v_prefs->>'allowPatterns')::boolean, true),
    coalesce((v_prefs->>'allowJournalAnalysis')::boolean, false),
    coalesce((v_prefs->>'includeInReports')::boolean, true),
    now()
  )
  on conflict (user_id) do update set
    display_name = excluded.display_name,
    allow_patterns = excluded.allow_patterns,
    allow_journal_analysis = excluded.allow_journal_analysis,
    include_in_reports = excluded.include_in_reports,
    updated_at = now();

  delete from public.malaak_journals where user_id = v_uid;
  insert into public.malaak_journals (id, user_id, title, body, tag, include_in_reports, created_at, updated_at)
  select
    e->>'id', v_uid, coalesce(e->>'title', 'موقف جديد'), coalesce(e->>'body', ''),
    coalesce(e->>'tag', 'تسجيل شخصي'), coalesce((e->>'includeInReports')::boolean, true),
    coalesce((e->>'createdAt')::timestamptz, now()), now()
  from jsonb_array_elements(coalesce(p_state->'journals', '[]'::jsonb)) e;

  delete from public.malaak_journeys where user_id = v_uid;
  insert into public.malaak_journeys (user_id, domain_id, status, completed_practices, updated_at)
  select
    v_uid, coalesce(value->>'domainId', key), coalesce(value->>'status', 'مراقبة'),
    coalesce((value->>'completedPractices')::integer, 0), coalesce((value->>'updatedAt')::timestamptz, now())
  from jsonb_each(coalesce(p_state->'journeys', '{}'::jsonb));

  delete from public.malaak_memories where user_id = v_uid;
  insert into public.malaak_memories (id, user_id, type, value, confidence, created_at, updated_at)
  select
    e->>'id', v_uid, coalesce(e->>'type', 'fact'), coalesce(e->>'value', ''),
    coalesce(e->>'confidence', 'medium'), coalesce((e->>'createdAt')::timestamptz, now()), now()
  from jsonb_array_elements(coalesce(p_state->'memories', '[]'::jsonb)) e;

  delete from public.malaak_messages where user_id = v_uid;
  insert into public.malaak_messages (id, user_id, text, is_user, created_at)
  select
    e->>'id', v_uid, coalesce(e->>'text', ''), coalesce((e->>'isUser')::boolean, false),
    coalesce((e->>'createdAt')::timestamptz, now())
  from jsonb_array_elements(coalesce(p_state->'messages', '[]'::jsonb)) e;

  delete from public.malaak_coaching_turns where user_id = v_uid;
  insert into public.malaak_coaching_turns (
    id, user_id, mode, state, need, pattern, pattern_confidence, goal,
    intervention_code, intervention_version, intervention_id, action, follow_up, created_at, updated_at
  )
  select
    e->>'id',
    v_uid,
    coalesce(e->>'mode', 'fallback'),
    coalesce(e->>'state', 'unknown'),
    coalesce(e->>'need', 'unknown'),
    coalesce(e->>'pattern', 'unknown'),
    coalesce(e->>'patternConfidence', 'low'),
    coalesce(e->>'goal', ''),
    nullif(e->>'interventionCode', ''),
    nullif(e->>'interventionVersion', '')::integer,
    nullif(e->>'interventionId', '')::uuid,
    coalesce(e->>'action', ''),
    case when e ? 'followUp' and e->'followUp' <> 'null'::jsonb then e->'followUp' else null end,
    coalesce((e->>'createdAt')::timestamptz, now()),
    now()
  from jsonb_array_elements(coalesce(p_state->'coachingTurns', '[]'::jsonb)) e;

  delete from public.malaak_followups where user_id = v_uid;
  insert into public.malaak_followups (
    id, user_id, timing, prompt, journey_domain_id, created_at, completed_at, updated_at
  )
  select
    e->>'id',
    v_uid,
    coalesce(e->>'timing', 'none'),
    coalesce(e->>'prompt', ''),
    nullif(e->>'journeyDomainId', ''),
    coalesce((e->>'createdAt')::timestamptz, now()),
    nullif(e->>'completedAt', '')::timestamptz,
    now()
  from jsonb_array_elements(coalesce(p_state->'pendingFollowUps', '[]'::jsonb)) e;

  return jsonb_build_object('syncedAt', now());
end;
$$;

revoke execute on function public.malaak_get_state() from public, anon;
revoke execute on function public.malaak_sync_state(jsonb) from public, anon;
grant execute on function public.malaak_get_state() to authenticated;
grant execute on function public.malaak_sync_state(jsonb) to authenticated;
