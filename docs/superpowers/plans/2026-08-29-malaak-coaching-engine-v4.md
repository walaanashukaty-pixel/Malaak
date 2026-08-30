# Malaak Coaching Engine V4 Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Build the rules-first Malaak coaching engine so every ordinary AI turn is routed through safety/state/need/pattern/tool/action/follow-up and only approved intervention cards can be recommended.

**Architecture:** The Supabase Edge Function owns deterministic safety and eligibility rules, then uses OpenAI Structured Outputs to personalize a typed coaching turn from approved intervention candidates. Flutter stores that structured turn and pending follow-up alongside the existing message transcript, syncs it through Supabase, and surfaces the action/follow-up without changing the approved mobile visual system.

**Tech Stack:** Flutter/Dart 3.9+, Supabase Flutter 2.17+, Supabase Postgres/RLS/RPC, Supabase Edge Functions/Deno TypeScript, OpenAI Responses API with `gpt-5.6-luna` and strict `json_schema` structured outputs.

**Spec:** `docs/superpowers/specs/2026-08-29-malaak-coaching-engine-design.md`

## Global Constraints

- Preserve Arabic RTL, four bottom tabs, 11 journeys, 9 quick tools, and no Sidebar/Drawer.
- Safety routing is deterministic and runs before any OpenAI call.
- The AI may only return an intervention code from the server-provided approved candidate set.
- Patterns/hypotheses are never treated as diagnoses or facts.
- No OpenAI key, Supabase service-role key, or private server secret may appear in Flutter.
- V4 does not implement exposure therapy, EMDR, trauma-memory processing, automatic Android notifications, clinician dashboards, or Couples Mode.

---

### Task 1: Typed Coaching Models and Local Persistence

**Files:**
- Create: `lib/models/coaching_follow_up.dart`
- Create: `lib/models/coaching_turn.dart`
- Modify: `lib/models/app_state.dart`
- Create: `test/coaching_models_test.dart`

**Interfaces:**
- Produces `CoachingFollowUp.fromJson/toJson/copyWith`.
- Produces `CoachingTurn.fromJson/toJson`.
- `AppStateData` gains `List<CoachingTurn> coachingTurns` and `List<CoachingFollowUp> pendingFollowUps`.

- [ ] **Step 1: Write failing model round-trip tests**

Create tests that construct a coaching turn with follow-up, serialize it, deserialize it through `AppStateData`, and assert `interventionCode`, `action`, `timing`, and `journeyDomainId` survive. Add a compatibility test that old JSON without V4 keys produces empty lists.

- [ ] **Step 2: Run the focused test and verify RED**

Run: `flutter test test/coaching_models_test.dart`
Expected: FAIL because `CoachingTurn`, `CoachingFollowUp`, and the new state fields do not exist.

- [ ] **Step 3: Implement the models and AppStateData integration**

`CoachingFollowUp` fields:
`id`, `timing`, `prompt`, `journeyDomainId`, `createdAt`, `completedAt`.

`CoachingTurn` fields:
`id`, `createdAt`, `mode`, `state`, `need`, `pattern`, `patternConfidence`, `goal`, nullable `interventionCode`, `action`, nullable `followUp`.

Use defensive defaults in `fromJson` so partial/fallback responses do not crash the app.

- [ ] **Step 4: Run focused and existing state tests**

Run: `flutter test test/coaching_models_test.dart test/app_controller_test.dart`
Expected: PASS.

- [ ] **Step 5: Commit Task 1**

```bash
git add lib/models/coaching_follow_up.dart lib/models/coaching_turn.dart lib/models/app_state.dart test/coaching_models_test.dart
git commit -m "feat: add structured Malaak coaching models"
```

---

### Task 2: Curated Server Intervention Library and Deterministic Router

**Files:**
- Create: `supabase/functions/malaak-ai/types.ts`
- Create: `supabase/functions/malaak-ai/interventions.ts`
- Create: `supabase/functions/malaak-ai/router.ts`
- Create: `supabase/functions/malaak-ai/router_test.ts`

**Interfaces:**
- Produces `InterventionCard` and `RoutingResult` types.
- Produces `routeMessage(message, context): RoutingResult`.
- Produces `getIntervention(code)` and `eligibleInterventions(route)`.

- [ ] **Step 1: Write failing router tests**

Cover these exact behaviors:
1. `"رح أضربه وهلأ ما عم سيطر"` returns `mode: safety` and zero candidate codes.
2. `"أنا 9 من 10 وعم انفجر"` returns `high_activation` and candidates exclude `THOUGHT_FACTS_001`.
3. `"ما رد وعم افتح الواتساب كل دقيقة"` includes `UNCERTAINTY_001` and/or `RUMINATION_EXIT_001`.
4. `"أنا معصبة وبدي احكي فوراً"` includes `ANGER_TIMEOUT_001` plus a regulation option.
5. Every candidate code resolves to a card in the approved intervention library.

- [ ] **Step 2: Run Deno test and verify RED**

Run: `deno test supabase/functions/malaak-ai/router_test.ts`
Expected: FAIL because router/library modules do not exist.

- [ ] **Step 3: Implement the 10 approved intervention cards**

Each card must define:
`code`, `titleAr`, `framework`, `evidenceTier`, `targets`, `eligibleStates`, `patterns`, `exclusions`, `durationMinutes`, `steps`, `actionTemplate`, `fallbackCode`.

- [ ] **Step 4: Implement deterministic routing/eligibility**

Routing must detect immediate risk first, then broad activation/state, need, and pattern hypotheses. Candidate selection must be rule-based and return at most four cards, ordered from least intensive/most fitting to alternatives.

- [ ] **Step 5: Run router tests**

Run: `deno test supabase/functions/malaak-ai/router_test.ts`
Expected: PASS.

- [ ] **Step 6: Commit Task 2**

```bash
git add supabase/functions/malaak-ai/types.ts supabase/functions/malaak-ai/interventions.ts supabase/functions/malaak-ai/router.ts supabase/functions/malaak-ai/router_test.ts
git commit -m "feat: add curated Malaak intervention router"
```

---

### Task 3: Structured OpenAI Coaching Contract and Server Validation

**Files:**
- Create: `supabase/functions/malaak-ai/coach.ts`
- Modify: `supabase/functions/malaak-ai/index.ts`
- Create: `supabase/functions/malaak-ai/coach_test.ts`

**Interfaces:**
- Produces `validateCoachingTurn(raw, route): CoachingPayload`.
- Produces `deterministicFallback(route): CoachingPayload`.
- Edge Function response always has `mode`, `reply`, and `turn`; safety responses may have `turn.interventionCode = null`.

- [ ] **Step 1: Write failing validation/fallback tests**

Tests must prove:
- model output containing `NOT_APPROVED` cannot survive validation;
- valid candidate code survives;
- missing/invalid payload produces a deterministic fallback using the first eligible approved intervention;
- safety route never gains an intervention code.

- [ ] **Step 2: Run focused Deno tests and verify RED**

Run: `deno test supabase/functions/malaak-ai/coach_test.ts`
Expected: FAIL because `coach.ts` does not exist.

- [ ] **Step 3: Implement strict response schema and OpenAI request**

Use `text.format` with:

```json
{
  "type": "json_schema",
  "name": "malaak_coaching_turn",
  "strict": true,
  "schema": { "type": "object", "additionalProperties": false }
}
```

The complete schema must require `mode`, `state`, `need`, `pattern`, `patternConfidence`, `goal`, `interventionCode`, `reply`, `action`, and nested `followUp` fields with finite enum values matching the spec.

Default model: `gpt-5.6-luna`.

- [ ] **Step 4: Rework index.ts into orchestration**

Flow:
`authenticate -> parse message -> routeMessage -> safety short-circuit -> candidates -> OpenAI structured call -> validate -> deterministic fallback on failure -> response`.

The prompt must contain only eligible intervention summaries, and explicitly forbid inventing techniques outside them.

- [ ] **Step 5: Run all Edge tests**

Run: `deno test supabase/functions/malaak-ai/router_test.ts supabase/functions/malaak-ai/coach_test.ts`
Expected: PASS.

- [ ] **Step 6: Commit Task 3**

```bash
git add supabase/functions/malaak-ai/index.ts supabase/functions/malaak-ai/coach.ts supabase/functions/malaak-ai/coach_test.ts
git commit -m "feat: constrain Malaak AI with structured coaching outputs"
```

---

### Task 4: Flutter Gateway, Controller, Follow-Up, and UX

**Files:**
- Modify: `lib/services/malaak_gateway.dart`
- Modify: `lib/state/app_controller.dart`
- Modify: `lib/screens/malaak/malaak_screen.dart`
- Modify: `lib/screens/home/home_screen.dart`
- Modify: `test/app_controller_test.dart`
- Create: `test/malaak_gateway_payload_test.dart`

**Interfaces:**
- `MalaakGateway.reply(...)` becomes `Future<MalaakGatewayResult>`.
- `MalaakGatewayResult` contains display `reply` plus nullable `CoachingTurn turn`.
- `AppController.completeFollowUp(String id)` persists completion and removes it from the pending list.

- [ ] **Step 1: Write failing gateway parsing test**

Given the exact Edge response shape, assert Flutter creates a typed `CoachingTurn` and `CoachingFollowUp`; configuration/fallback response with no valid turn must remain displayable without crash.

- [ ] **Step 2: Write failing controller test**

Use a fake gateway result containing an action and follow-up. After `sendToMalaak`, assert:
- assistant transcript was stored;
- coaching turn was stored;
- pending follow-up was stored;
- `completeFollowUp` sets `completedAt` and removes it from pending state.

- [ ] **Step 3: Run focused tests and verify RED**

Run: `flutter test test/malaak_gateway_payload_test.dart test/app_controller_test.dart`
Expected: FAIL because structured gateway result/follow-up methods do not exist.

- [ ] **Step 4: Implement gateway/controller behavior**

The gateway must never fabricate a `CoachingTurn` when the server returns only a textual fallback. The controller stores metadata only when present.

- [ ] **Step 5: Add minimal coaching card to Malaak screen**

Below the newest Malaak response, show a premium-style card only when the latest structured turn has non-empty `action`:
- heading `خطوتك الآن`
- action text
- user-friendly intervention title if locally mapped

Never display technical intervention codes.

- [ ] **Step 6: Replace mock Home follow-up with persisted data**

When `pendingFollowUps` is non-empty, show the newest pending item with CTA `أخبر ملاك شو صار`. The CTA opens/selects Malaak screen and pre-fills or sends the follow-up prompt through the existing navigation mechanism without adding a fifth bottom tab.

- [ ] **Step 7: Run focused Flutter tests**

Run: `flutter test test/malaak_gateway_payload_test.dart test/app_controller_test.dart test/app_shell_test.dart test/catalog_test.dart`
Expected: PASS.

- [ ] **Step 8: Commit Task 4**

```bash
git add lib/services/malaak_gateway.dart lib/state/app_controller.dart lib/screens/malaak/malaak_screen.dart lib/screens/home/home_screen.dart test/app_controller_test.dart test/malaak_gateway_payload_test.dart
git commit -m "feat: persist Malaak actions and follow-ups in Flutter"
```

---

### Task 5: Supabase Persistence, Deployment, Security, and Final Verification

**Files:**
- Create: `supabase/migrations/20260829_malaak_coaching_v4.sql`
- Modify: `README.md`
- Modify: `BUILD_STATUS.md`

**Interfaces:**
- Adds `malaak_coaching_turns` and `malaak_followups`.
- Extends `malaak_get_state()` and `malaak_sync_state(jsonb)` with `coachingTurns` and `pendingFollowUps`.
- Existing authenticated RLS model remains the access boundary.

- [ ] **Step 1: Write migration SQL**

Tables must use `(user_id, id)` primary keys, RLS, authenticated-only CRUD grants, and optimized `(select auth.uid())` policies. `malaak_sync_state` deletes/reinserts only the current authenticated user's coaching/follow-up rows.

- [ ] **Step 2: Apply migration to project `himyddwbgyxohalxlzaz`**

Use Supabase migration tooling with migration name `malaak_coaching_v4`.

Expected: migration success.

- [ ] **Step 3: Deploy the updated `malaak-ai` Edge Function with JWT verification enabled**

Deploy `index.ts`, `types.ts`, `interventions.ts`, `router.ts`, `coach.ts`, and `deno.json`.

Expected: function status `ACTIVE`, `verify_jwt = true`.

- [ ] **Step 4: Run full local verification**

Run:

```bash
flutter test
flutter analyze
deno test supabase/functions/malaak-ai/router_test.ts supabase/functions/malaak-ai/coach_test.ts
```

Expected: all commands exit 0.

- [ ] **Step 5: Run Supabase security/performance advisors**

Confirm no new Malaak-table security errors and no new Malaak RLS init-plan warnings. Existing unrelated project advisories are reported separately, not silently modified.

- [ ] **Step 6: Update documentation**

README must explain:
- V4 coaching architecture;
- `OPENAI_API_KEY` remains a Supabase secret;
- `MALAAK_OPENAI_MODEL` defaults to `gpt-5.6-luna`;
- the initial intervention library is curated and server-controlled;
- follow-ups are persisted but Android notifications are not yet scheduled.

BUILD_STATUS must record which verification commands were actually executable in this environment and their exact outcomes.

- [ ] **Step 7: Package V4 ZIP**

Create `/mnt/data/Malaak-Flutter-Android-V4.zip` excluding `.git`, build artifacts, caches, and secrets.

- [ ] **Step 8: Commit Task 5**

```bash
git add supabase/migrations/20260829_malaak_coaching_v4.sql README.md BUILD_STATUS.md
git commit -m "feat: persist and deploy Malaak coaching engine V4"
```

---

## Self-Review

- Spec coverage: all safety, routing, intervention-library, structured-output, Flutter persistence, follow-up, Supabase sync, UX, and verification requirements are mapped to Tasks 1-5.
- Placeholder scan: no implementation placeholder remains; all future/non-goals are explicitly out of scope rather than deferred implementation steps.
- Type consistency: the plan consistently uses `CoachingTurn`, `CoachingFollowUp`, `MalaakGatewayResult`, `coachingTurns`, and `pendingFollowUps` across server, Flutter, and persistence tasks.
