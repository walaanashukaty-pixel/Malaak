# Malaak AI — Supabase Edge Function

Flutter no longer calls an arbitrary raw AI endpoint. It invokes the authenticated Supabase Edge Function:

```text
malaak-ai
```

Source:

```text
supabase/functions/malaak-ai/index.ts
```

## Authentication

- Supabase Edge Function JWT verification is enabled.
- The function also checks the verified JWT payload and accepts only `role=authenticated` with a user `sub`.
- An anon/publishable-key-only request must not be allowed to consume paid AI inference.

## Request from Flutter

```json
{
  "message": "زوجي ما رد وحاسة بخوف",
  "context": {
    "displayName": "...",
    "journeys": {},
    "memories": [],
    "recentMessages": []
  }
}
```

Journal text is appended only if the user has enabled journal analysis.
Patterns and hypotheses are omitted if the user has disabled pattern memory.

## Response

```json
{
  "mode": "ai",
  "reply": "..."
}
```

Possible modes include:

- `ai`
- `safety`
- `configuration_required`
- `fallback`

## Required secret

Set on Supabase, never in the APK:

```text
OPENAI_API_KEY
```

Optional:

```text
MALAAK_OPENAI_MODEL
```

The source currently falls back to `gpt-5.6-luna` when no model override is configured.

## Safety boundary

The Edge Function contains a deliberately conservative first safety route for explicit self-harm, harm-to-others, or active partner-danger language. It is not intended to be the final clinical safety architecture. Before public release, add:

- broader risk classification,
- region-aware crisis/safety resources,
- rate limits and abuse controls,
- audit-safe event telemetry without exposing journal content,
- curated intervention eligibility/contraindication checks,
- escalation criteria for human professional support.
