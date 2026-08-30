revoke all privileges on table public.malaak_profiles from anon, authenticated;
revoke all privileges on table public.malaak_journals from anon, authenticated;
revoke all privileges on table public.malaak_journeys from anon, authenticated;
revoke all privileges on table public.malaak_memories from anon, authenticated;
revoke all privileges on table public.malaak_messages from anon, authenticated;

grant select, insert, update, delete on table public.malaak_profiles to authenticated;
grant select, insert, update, delete on table public.malaak_journals to authenticated;
grant select, insert, update, delete on table public.malaak_journeys to authenticated;
grant select, insert, update, delete on table public.malaak_memories to authenticated;
grant select, insert, update, delete on table public.malaak_messages to authenticated;

revoke execute on function public.malaak_get_state() from public, anon;
revoke execute on function public.malaak_sync_state(jsonb) from public, anon;
grant execute on function public.malaak_get_state() to authenticated;
grant execute on function public.malaak_sync_state(jsonb) to authenticated;
