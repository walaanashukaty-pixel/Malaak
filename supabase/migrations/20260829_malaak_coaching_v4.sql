create table if not exists public.malaak_coaching_turns (
  id text not null,
  user_id uuid not null references auth.users(id) on delete cascade,
  mode text not null default 'fallback',
  state text not null default 'unknown',
  need text not null default 'unknown',
  pattern text not null default 'unknown',
  pattern_confidence text not null default 'low' check (pattern_confidence in ('low','medium','high')),
  goal text not null default '',
  intervention_code text,
  action text not null default '',
  follow_up jsonb,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),
  primary key (user_id, id)
);

create table if not exists public.malaak_followups (
  id text not null,
  user_id uuid not null references auth.users(id) on delete cascade,
  timing text not null default 'none' check (timing in ('later_today','tomorrow','after_event','none')),
  prompt text not null default '',
  journey_domain_id text,
  created_at timestamptz not null default now(),
  completed_at timestamptz,
  updated_at timestamptz not null default now(),
  primary key (user_id, id)
);

create index if not exists malaak_coaching_turns_user_created_idx
  on public.malaak_coaching_turns(user_id, created_at desc);
create index if not exists malaak_followups_user_created_idx
  on public.malaak_followups(user_id, created_at desc);

alter table public.malaak_coaching_turns enable row level security;
alter table public.malaak_followups enable row level security;

drop policy if exists "malaak_coaching_turns_own_rows" on public.malaak_coaching_turns;
create policy "malaak_coaching_turns_own_rows" on public.malaak_coaching_turns
  for all to authenticated
  using ((select auth.uid()) = user_id)
  with check ((select auth.uid()) = user_id);

drop policy if exists "malaak_followups_own_rows" on public.malaak_followups;
create policy "malaak_followups_own_rows" on public.malaak_followups
  for all to authenticated
  using ((select auth.uid()) = user_id)
  with check ((select auth.uid()) = user_id);

revoke all privileges on table public.malaak_coaching_turns from anon, authenticated;
revoke all privileges on table public.malaak_followups from anon, authenticated;
grant select, insert, update, delete on table public.malaak_coaching_turns to authenticated;
grant select, insert, update, delete on table public.malaak_followups to authenticated;

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
    intervention_code, action, follow_up, created_at, updated_at
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
