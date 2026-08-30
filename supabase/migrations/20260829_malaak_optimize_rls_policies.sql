drop policy if exists "malaak_profiles_own_rows" on public.malaak_profiles;
create policy "malaak_profiles_own_rows" on public.malaak_profiles
  for all to authenticated
  using ((select auth.uid()) = user_id)
  with check ((select auth.uid()) = user_id);

drop policy if exists "malaak_journals_own_rows" on public.malaak_journals;
create policy "malaak_journals_own_rows" on public.malaak_journals
  for all to authenticated
  using ((select auth.uid()) = user_id)
  with check ((select auth.uid()) = user_id);

drop policy if exists "malaak_journeys_own_rows" on public.malaak_journeys;
create policy "malaak_journeys_own_rows" on public.malaak_journeys
  for all to authenticated
  using ((select auth.uid()) = user_id)
  with check ((select auth.uid()) = user_id);

drop policy if exists "malaak_memories_own_rows" on public.malaak_memories;
create policy "malaak_memories_own_rows" on public.malaak_memories
  for all to authenticated
  using ((select auth.uid()) = user_id)
  with check ((select auth.uid()) = user_id);

drop policy if exists "malaak_messages_own_rows" on public.malaak_messages;
create policy "malaak_messages_own_rows" on public.malaak_messages
  for all to authenticated
  using ((select auth.uid()) = user_id)
  with check ((select auth.uid()) = user_id);
