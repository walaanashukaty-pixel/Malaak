# Malaak V5A Scientific Intervention Catalog Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Replace the V4 hardcoded 10-card intervention library with a versioned, auditable Supabase catalog containing 48 reviewed candidate cards, while preserving deterministic safety/routing and an embedded low-risk offline fallback set.

**Architecture:** Supabase owns intervention revisions and source metadata. The Edge Function keeps deterministic route rules, fetches only active catalog revisions, validates eligibility/exclusions, caches them briefly, and falls back to a tiny embedded safe set when the catalog is unavailable. Flutter receives the exact catalog revision identifiers used for each coaching turn and never decides eligibility.

**Tech Stack:** PostgreSQL/Supabase RLS, Supabase Edge Functions (TypeScript/Deno-compatible), Node test runner, Flutter/Dart models, Python structural verification scripts.

**Spec:** `docs/superpowers/specs/2026-08-29-malaak-scientific-library-formulation-v5-design.md`

## Global Constraints

- Preserve V4 safety behavior; safety always overrides catalog routing.
- Preserve all existing V4 intervention codes for backward compatibility.
- Seed exactly 48 unique candidate codes from Spec §6.
- Intervention revisions are append-only; `(code, version)` is immutable scientific content after activation.
- Only one active revision per code.
- No normal app client may write catalog/source rows.
- Active A/B/C cards require reviewed source records; D cards must be explicitly coaching-only.
- Flutter must never contain OpenAI/service-role secrets.
- No healing percentages or diagnostic claims.

---

### Task 1: Add catalog schema, revision constraints, and coaching-turn audit columns

**Files:**
- Create: `supabase/migrations/20260829_malaak_intervention_catalog_v5.sql`
- Modify: `supabase/migrations/20260829_malaak_intervention_catalog_v5.sql`
- Test: `scripts/verify_v5a_schema.py`

**Interfaces:**
- Produces tables `malaak_interventions`, `malaak_intervention_sources`.
- Produces columns `intervention_version integer`, `intervention_id uuid` on `malaak_coaching_turns`.
- Produces read-only catalog grants and no authenticated writes.

- [ ] **Step 1: Write the failing structural test**

Create `scripts/verify_v5a_schema.py` to assert the migration contains both tables, unique `(code, version)`, a partial unique active-version index, status/evidence/licensing/review checks, the two coaching-turn audit columns, RLS, and revoked client write privileges.

- [ ] **Step 2: Run test to verify it fails**

Run: `python3 scripts/verify_v5a_schema.py`
Expected: FAIL because `20260829_malaak_intervention_catalog_v5.sql` does not exist.

- [ ] **Step 3: Implement the migration**

Create catalog/source tables with exact Spec §5 fields and check constraints. Add `intervention_version` and `intervention_id` to `malaak_coaching_turns`. Enable RLS. Grant catalog `SELECT` to `authenticated` only, revoke all catalog mutations from `anon, authenticated`, and add no permissive write policy. Add indexes for active code lookup and source lookup.

- [ ] **Step 4: Run structural test**

Run: `python3 scripts/verify_v5a_schema.py`
Expected: PASS.

- [ ] **Step 5: Commit**

Run:
`git add supabase/migrations/20260829_malaak_intervention_catalog_v5.sql scripts/verify_v5a_schema.py && git commit -m "feat: add Malaak V5 intervention catalog schema"`

---

### Task 2: Define the 48-card reviewed seed registry

**Files:**
- Create: `supabase/functions/malaak-ai/catalog_seed.ts`
- Create: `supabase/functions/malaak-ai/catalog_seed_test.ts`
- Create: `docs/science/malaak-intervention-source-registry-v5.md`

**Interfaces:**
- Produces `catalogSeed: CatalogSeedCard[]` with exactly 48 codes from Spec §6.
- Each card includes version, status, framework, evidence tier, licensing status, target needs/patterns/states/domains, exclusions, steps, action, measurement, follow-up, fallback, and review metadata.
- Each A/B/C card has at least one reviewed source entry; every D card has `framework=coaching_model` or equivalent and `contentOrigin=coaching_only`.

- [ ] **Step 1: Write failing seed-registry tests**

Tests must assert: 48 unique codes; every existing V4 code exists; no active card has `review_required`/`restricted`; A/B/C active cards have sources; D cards are coaching-only; X codes are absent from selectable seed; childhood/healing cards include explicit trauma-processing exclusions.

- [ ] **Step 2: Run tests to verify failure**

Run: `node --experimental-strip-types --test supabase/functions/malaak-ai/catalog_seed_test.ts`
Expected: FAIL because seed module does not exist.

- [ ] **Step 3: Implement all 48 cards and source registry**

Use original Arabic Malaak wording. Reuse authoritative guideline/source records where they genuinely support underlying processes, and record limitations so evidence for an underlying skill is not misrepresented as validation of Malaak wording or the feminine-intelligence taxonomy. Keep `FI_*` and `BAL_*` taxonomy-level cards at D unless their card is strictly an underlying evidence-supported skill.

- [ ] **Step 4: Run seed tests**

Run: `node --experimental-strip-types --test supabase/functions/malaak-ai/catalog_seed_test.ts`
Expected: PASS with 48 unique codes.

- [ ] **Step 5: Commit**

Run:
`git add supabase/functions/malaak-ai/catalog_seed.ts supabase/functions/malaak-ai/catalog_seed_test.ts docs/science/malaak-intervention-source-registry-v5.md && git commit -m "feat: define Malaak V5 scientific intervention registry"`

---

### Task 3: Seed the catalog into PostgreSQL reproducibly

**Files:**
- Create: `scripts/generate_v5_catalog_sql.mjs`
- Create: `supabase/migrations/20260829_malaak_intervention_seed_v5.sql`
- Test: `scripts/verify_v5a_seed.py`

**Interfaces:**
- Consumes `catalog_seed.ts` exported JSON-compatible data.
- Produces deterministic INSERT/UPSERT SQL for 48 intervention revisions and their source rows.

- [ ] **Step 1: Write failing SQL-seed verifier**

Assert generated migration has 48 distinct code/version insert blocks, source inserts for all active A/B/C codes, and no `restricted` active card.

- [ ] **Step 2: Run verifier and confirm failure**

Run: `python3 scripts/verify_v5a_seed.py`
Expected: FAIL because seed migration is absent.

- [ ] **Step 3: Implement generator and generated migration**

Generator must serialize arrays/json safely and be deterministic. The migration inserts version `1` rows and source rows keyed by the inserted intervention IDs through deterministic code/version joins. It must never update an already-active scientific revision in place; conflict handling is `do nothing` for `(code,version)` and source duplicate identity.

- [ ] **Step 4: Regenerate and verify**

Run: `node --experimental-strip-types scripts/generate_v5_catalog_sql.mjs && python3 scripts/verify_v5a_seed.py`
Expected: PASS.

- [ ] **Step 5: Commit**

Run:
`git add scripts/generate_v5_catalog_sql.mjs scripts/verify_v5a_seed.py supabase/migrations/20260829_malaak_intervention_seed_v5.sql && git commit -m "feat: seed Malaak V5 intervention catalog"`

---

### Task 4: Replace hardcoded normal catalog with server catalog loader and safe embedded fallback

**Files:**
- Create: `supabase/functions/malaak-ai/catalog.ts`
- Create: `supabase/functions/malaak-ai/fallback_interventions.ts`
- Create: `supabase/functions/malaak-ai/catalog_test.ts`
- Modify: `supabase/functions/malaak-ai/types.ts`
- Modify: `supabase/functions/malaak-ai/interventions.ts`

**Interfaces:**
- Produces `loadEligibleInterventions(route, flags, authorization): Promise<CatalogIntervention[]>`.
- Produces `filterEligibleCatalogRows(rows, route, flags)` as a pure testable function.
- Embedded fallback contains only `REG_GROUND_001`, `REG_MOVE_002`, `NEED_NAME_001`, `THOUGHT_FACTS_001`, `PROBLEM_SOLVE_001` revisions.
- Context flags include `interpersonalDanger`, `highImpact`, and `catalogUnavailable`.

- [ ] **Step 1: Write failing catalog filtering tests**

Test paused/retired/prohibited exclusion, high-activation exclusion of reflective cards, interpersonal-danger exclusion of direct-confrontation cards, exact active revision preservation, and fallback-only behavior on catalog failure.

- [ ] **Step 2: Run tests and confirm failure**

Run: `node --experimental-strip-types --test supabase/functions/malaak-ai/catalog_test.ts`
Expected: FAIL.

- [ ] **Step 3: Implement loader/filter/cache**

Fetch active catalog rows through Supabase REST using server-side `SUPABASE_URL` + `SUPABASE_SERVICE_ROLE_KEY`; cache the compact active snapshot for 300 seconds per function instance. Apply deterministic state/pattern/need/domain/exclusion rules after fetch. Never use stale `paused/retired/prohibited` rows after a successful refresh.

- [ ] **Step 4: Run tests**

Run: `node --experimental-strip-types --test supabase/functions/malaak-ai/catalog_test.ts`
Expected: PASS.

- [ ] **Step 5: Commit**

Run:
`git add supabase/functions/malaak-ai/catalog.ts supabase/functions/malaak-ai/fallback_interventions.ts supabase/functions/malaak-ai/catalog_test.ts supabase/functions/malaak-ai/types.ts supabase/functions/malaak-ai/interventions.ts && git commit -m "feat: load eligible Malaak interventions from catalog"`

---

### Task 5: Make structured coaching output revision-aware and catalog-bound

**Files:**
- Modify: `supabase/functions/malaak-ai/coach.ts`
- Modify: `supabase/functions/malaak-ai/coach_test.ts`
- Modify: `supabase/functions/malaak-ai/index.ts`

**Interfaces:**
- `requestStructuredCoaching` receives eligible catalog revisions instead of deriving them from the hardcoded module.
- `CoachingPayload` returns `interventionCode`, `interventionVersion`, `interventionId`.
- Validator rejects codes/versions/ids not in the eligible revision set.

- [ ] **Step 1: Add failing validator tests**

Add tests that reject: valid code with wrong version; valid code/version with wrong catalog ID; paused card injected by model; and a code not in eligible candidates. Add a passing test for an exact eligible revision.

- [ ] **Step 2: Run tests and confirm failure**

Run: `node --experimental-strip-types --test supabase/functions/malaak-ai/coach_test.ts`
Expected: FAIL until revision-aware validation exists.

- [ ] **Step 3: Implement revision-aware schema and prompt**

The JSON Schema enum must restrict the model to exact eligible codes, while server validation maps the selected code to the server-owned eligible revision and overwrites/returns its version/id. The model never supplies authoritative version/id.

- [ ] **Step 4: Run server suite**

Run: `node --experimental-strip-types --test supabase/functions/malaak-ai/*_test.ts`
Expected: all tests PASS.

- [ ] **Step 5: Commit**

Run:
`git add supabase/functions/malaak-ai/coach.ts supabase/functions/malaak-ai/coach_test.ts supabase/functions/malaak-ai/index.ts && git commit -m "feat: bind coaching turns to catalog revisions"`

---

### Task 6: Persist catalog revision identifiers in Flutter and cloud sync

**Files:**
- Modify: `lib/models/coaching_turn.dart`
- Modify: `lib/services/malaak_gateway.dart`
- Modify: `lib/storage/supabase_app_repository.dart`
- Modify: `supabase/migrations/20260829_malaak_intervention_catalog_v5.sql`
- Modify: `test/coaching_models_test.dart`
- Modify: `test/malaak_gateway_payload_test.dart`

**Interfaces:**
- Dart `CoachingTurn` gains nullable `interventionVersion` and `interventionId`.
- JSON serialization/deserialization remains backward compatible with V4 local state.
- Cloud state RPC exposes and accepts the two fields.

- [ ] **Step 1: Add failing Dart tests**

Tests serialize/deserialize a V5 coaching turn and a V4 legacy turn missing new fields.

- [ ] **Step 2: Record environment limitation and run available structure check**

Run: `python3 scripts/verify_v4_models.py`
Expected: existing verifier does not yet guarantee V5 fields; add V5-specific verifier if Flutter SDK remains unavailable.

- [ ] **Step 3: Implement model/gateway/RPC changes**

Do not expose catalog mutation APIs in Flutter.

- [ ] **Step 4: Run structural and server tests**

Run: `python3 scripts/verify_v5a_schema.py && python3 scripts/verify_v5a_seed.py && node --experimental-strip-types --test supabase/functions/malaak-ai/*_test.ts`
Expected: PASS. Run `flutter test` later in a real Flutter environment per release gate.

- [ ] **Step 5: Commit**

Run:
`git add lib/models/coaching_turn.dart lib/services/malaak_gateway.dart lib/storage/supabase_app_repository.dart supabase/migrations/20260829_malaak_intervention_catalog_v5.sql test/coaching_models_test.dart test/malaak_gateway_payload_test.dart && git commit -m "feat: persist intervention revision audit data"`

---

### Task 7: Apply V5A migrations and deploy catalog-backed Edge Function

**Files:**
- Deployment action only; no new source file required.
- Update: `BUILD_STATUS.md`
- Update: `README.md`

**Interfaces:**
- Production Supabase contains catalog/source tables and 48 seed revisions.
- `malaak-ai` deployed with JWT verification enabled.

- [ ] **Step 1: Apply schema migration through Supabase migration API**
- [ ] **Step 2: Apply seed migration through Supabase migration API**
- [ ] **Step 3: Deploy `malaak-ai` with all relative source files and `verify_jwt=true`**
- [ ] **Step 4: Query catalog counts/statuses and run Supabase security/performance advisors**
- [ ] **Step 5: Update docs with exact deployed version/status and commit**

Commit message: `docs: record Malaak V5A deployment status`.

---

### Task 8: V5A release verification

**Files:**
- Create: `scripts/verify_v5a_release.py`
- Modify: `pubspec.yaml`
- Modify: `BUILD_STATUS.md`

**Interfaces:**
- Release verifier proves 48 seed codes, server tests, required files, no secret literals, and no Sidebar/Drawer regression.

- [ ] **Step 1: Write verifier and make it fail on current version marker**
- [ ] **Step 2: Set app version to `0.5.0+5`**
- [ ] **Step 3: Run:** `python3 scripts/verify_v5a_release.py`
Expected: PASS.
- [ ] **Step 4: Run:** `git status --short`
Expected: only intended documentation/version changes before commit.
- [ ] **Step 5: Commit:** `git commit -am "chore: verify Malaak V5A release"`
