# Malaak Flutter Supabase V3 Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Connect the Flutter Android app to the existing Supabase project for real authentication, cloud synchronization, and an authenticated Malaak AI Edge Function while preserving local caching and the approved mobile UX.

**Architecture:** Supabase Auth gates cloud sync but the app retains an account-scoped SharedPreferences cache for resilience. Normalized user-owned tables are synchronized transactionally through two RPC functions (`malaak_get_state`, `malaak_sync_state`). The Flutter client uses `supabase_flutter`; Malaak calls a JWT-protected Edge Function and sends only context allowed by the user's memory/journal privacy settings.

**Tech Stack:** Flutter, Dart, supabase_flutter, shared_preferences, Supabase Auth/Postgres/RLS/Edge Functions, OpenAI Responses API through server-side secret only.

**Spec:** `docs/superpowers/specs/2026-08-29-malaak-flutter-mobile-design.md`

## Global Constraints
- Android-first Flutter app and Arabic RTL.
- No sidebar/drawer; bottom navigation remains exactly الرئيسية / ملاك / رحلتي / أنا.
- Never embed OpenAI secret keys in the APK.
- All cloud tables must have RLS and only expose a user's own rows.
- Facts, patterns, preferences, and hypotheses remain distinct.
- Journal text is never sent to AI unless `allowJournalAnalysis` is enabled.
- AI failure must degrade gracefully without data loss.

---

### Task 1: Supabase database contract
- [ ] Add a migration for profiles, journals, journeys, memories, messages, indexes, RLS, and transactional state RPCs.
- [ ] Apply the migration to the active `Complete Application Build (Copy)` Supabase project.
- [ ] Verify tables, policies, and RPC functions exist.

### Task 2: Flutter authentication and configuration
- [ ] Add `supabase_flutter` and project configuration.
- [ ] Add email/password sign-in + registration screen and authenticated root gate.
- [ ] Support sign-out and prevent account data leaking between local caches.

### Task 3: Local-first cloud repository
- [ ] Add Supabase-backed app repository with per-user local cache.
- [ ] Load cloud state on sign-in and save snapshots transactionally on mutations.
- [ ] Surface sync state and manual sync in settings.

### Task 4: Authenticated Malaak AI gateway
- [ ] Update gateway to call JWT-protected Supabase Edge Function.
- [ ] Send only allowed context.
- [ ] Keep a safe local fallback when network/AI is unavailable.

### Task 5: Edge Function
- [ ] Deploy `malaak-ai` with JWT verification.
- [ ] Add basic immediate-risk routing before normal AI coaching.
- [ ] Call OpenAI only via `OPENAI_API_KEY` stored server-side; return a clear configuration response if the secret is absent.

### Task 6: Verification and packaging
- [ ] Run V3 structural verifier.
- [ ] Verify Supabase security advisors after DDL changes.
- [ ] Query the live database to verify RLS/RPC contract.
- [ ] Package V3 source and document remaining local machine build steps.
