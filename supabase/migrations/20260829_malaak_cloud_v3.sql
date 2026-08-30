create table if not exists public.malaak_profiles (
  user_id uuid primary key references auth.users(id) on delete cascade,
  display_name text not null default '',
  allow_patterns boolean not null default true,
  allow_journal_analysis boolean not null default false,
  include_in_reports boolean not null default true,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

create table if not exists public.malaak_journals (
  id text not null,
  user_id uuid not null references auth.users(id) on delete cascade,
  title text not null default 'موقف جديد',
  body text not null,
  tag text not null default 'تسجيل شخصي',
  include_in_reports boolean not null default true,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),
  primary key (user_id, id)
);

create table if not exists public.malaak_journeys (
  user_id uuid not null references auth.users(id) on delete cascade,
  domain_id text not null,
  status text not null default 'مراقبة',
  completed_practices integer not null default 0 check (completed_practices >= 0),
  updated_at timestamptz not null default now(),
  primary key (user_id, domain_id)
);

create table if not exists public.malaak_memories (
  id text not null,
  user_id uuid not null references auth.users(id) on delete cascade,
  type text not null check (type in ('fact','goal','preference','pattern','hypothesis')),
  value text not null,
  confidence text not null default 'medium' check (confidence in ('low','medium','high')),
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),
  primary key (user_id, id)
);

create table if not exists public.malaak_messages (
  id text not null,
  user_id uuid not null references auth.users(id) on delete cascade,
  text text not null,
  is_user boolean not null,
  created_at timestamptz not null default now(),
  primary key (user_id, id)
);

create index if not exists malaak_journals_user_created_idx on public.malaak_journals(user_id, created_at desc);
create index if not exists malaak_memories_user_type_idx on public.malaak_memories(user_id, type);
create index if not exists malaak_messages_user_created_idx on public.malaak_messages(user_id, created_at);

alter table public.malaak_profiles enable row level security;
alter table public.malaak_journals enable row level security;
alter table public.malaak_journeys enable row level security;
alter table public.malaak_memories enable row level security;
alter table public.malaak_messages enable row level security;

create policy "malaak_profiles_own_rows" on public.malaak_profiles
  for all to authenticated
  using (auth.uid() = user_id)
  with check (auth.uid() = user_id);

create policy "malaak_journals_own_rows" on public.malaak_journals
  for all to authenticated
  using (auth.uid() = user_id)
  with check (auth.uid() = user_id);

create policy "malaak_journeys_own_rows" on public.malaak_journeys
  for all to authenticated
  using (auth.uid() = user_id)
  with check (auth.uid() = user_id);

create policy "malaak_memories_own_rows" on public.malaak_memories
  for all to authenticated
  using (auth.uid() = user_id)
  with check (auth.uid() = user_id);

create policy "malaak_messages_own_rows" on public.malaak_messages
  for all to authenticated
  using (auth.uid() = user_id)
  with check (auth.uid() = user_id);

create or replace function public.malaak_get_state()
returns jsonb
language sql
security invoker
set search_path = public
as $$
  select jsonb_build_object(
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
    e->>'id',
    v_uid,
    coalesce(e->>'title', 'موقف جديد'),
    coalesce(e->>'body', ''),
    coalesce(e->>'tag', 'تسجيل شخصي'),
    coalesce((e->>'includeInReports')::boolean, true),
    coalesce((e->>'createdAt')::timestamptz, now()),
    now()
  from jsonb_array_elements(coalesce(p_state->'journals', '[]'::jsonb)) e;

  delete from public.malaak_journeys where user_id = v_uid;
  insert into public.malaak_journeys (user_id, domain_id, status, completed_practices, updated_at)
  select
    v_uid,
    coalesce(value->>'domainId', key),
    coalesce(value->>'status', 'مراقبة'),
    coalesce((value->>'completedPractices')::integer, 0),
    coalesce((value->>'updatedAt')::timestamptz, now())
  from jsonb_each(coalesce(p_state->'journeys', '{}'::jsonb));

  delete from public.malaak_memories where user_id = v_uid;
  insert into public.malaak_memories (id, user_id, type, value, confidence, created_at, updated_at)
  select
    e->>'id',
    v_uid,
    coalesce(e->>'type', 'fact'),
    coalesce(e->>'value', ''),
    coalesce(e->>'confidence', 'medium'),
    coalesce((e->>'createdAt')::timestamptz, now()),
    now()
  from jsonb_array_elements(coalesce(p_state->'memories', '[]'::jsonb)) e;

  delete from public.malaak_messages where user_id = v_uid;
  insert into public.malaak_messages (id, user_id, text, is_user, created_at)
  select
    e->>'id',
    v_uid,
    coalesce(e->>'text', ''),
    coalesce((e->>'isUser')::boolean, false),
    coalesce((e->>'createdAt')::timestamptz, now())
  from jsonb_array_elements(coalesce(p_state->'messages', '[]'::jsonb)) e;

  return jsonb_build_object('syncedAt', now());
end;
$$;

grant execute on function public.malaak_get_state() to authenticated;
grant execute on function public.malaak_sync_state(jsonb) to authenticated;
