# Malaak Supabase V3 Backend

## Data model

Malaak uses normalized user-owned tables instead of the older Figma KV table:

- `malaak_profiles`
- `malaak_journals`
- `malaak_journeys`
- `malaak_memories`
- `malaak_messages`

Every row is scoped by `user_id` referencing `auth.users(id)` with `on delete cascade`.

## Security

All Malaak tables have RLS enabled. The only application-role policy allows authenticated users to operate on rows where:

```sql
(select auth.uid()) = user_id
```

`anon` has no table privileges. `authenticated` has the four CRUD privileges required by the client/RPC flow.

## State synchronization

Flutter keeps a user-specific local cache. The two RPCs are:

```text
malaak_get_state()
malaak_sync_state(jsonb)
```

`malaak_sync_state` performs a transactional full-state replacement for the signed-in user. Local dirty state is retried before cloud download so a failed upload is not silently overwritten by a stale server state.

This is intentionally a V3 implementation. A later production-scale sync layer should use per-row deltas/revisions and conflict handling for concurrent multi-device edits.

## V2 migration behavior

The old SharedPreferences key is claimed by the first authenticated account on that physical install. A marker prevents the same legacy state from being imported into another account on the same device.

## Secrets

Never put provider secrets in Flutter. `OPENAI_API_KEY` belongs in Supabase Edge Function Secrets.
