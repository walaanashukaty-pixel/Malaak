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
    ), '[]'::jsonb)
  );
$$;

grant execute on function public.malaak_get_state() to authenticated;
