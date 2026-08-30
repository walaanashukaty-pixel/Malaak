# Malaak V5B Progressive Assessment & Formulation Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Add progressive onboarding, structured observations, deterministic hypothesis evidence rules, user correction/rejection, and append-only working formulation versions without diagnosis.

**Architecture:** Flutter collects a short initial map and user-permitted event data. Edge/server code extracts only strict observation fields, then deterministic PostgreSQL/TypeScript logic owns hypothesis status/confidence and formulation version updates. Private journals are excluded before any model extraction.

**Tech Stack:** Flutter/Dart, PostgreSQL/Supabase RLS/RPC, Supabase Edge Function TypeScript, Node test runner, Python structural verification.

**Spec:** `docs/superpowers/specs/2026-08-29-malaak-scientific-library-formulation-v5-design.md`

## Global Constraints

- Initial onboarding is 3–5 minutes and produces `initial_map`, never a diagnostic profile.
- Private journals never create observations or formulation evidence.
- One event can create only candidate/low evidence.
- Only deterministic evidence rules may promote candidate → repeated/user_validated.
- User rejection immediately disables the hypothesis for routing.
- Patterns dormant after 90 days cannot dominate current routing.
- Formulation always stores `unknowns`.
- High impact prompts step-up/professional support; it is not a diagnosis.

---

### Task 1: Add V5B database schema and narrow RPC boundaries
**Files:** Create `supabase/migrations/20260829_malaak_formulation_v5.sql`; Test `scripts/verify_v5b_schema.py`.
**Produces:** `malaak_initial_maps`, `malaak_observations`, `malaak_hypotheses`, `malaak_formulations`; RLS; server-managed mutation boundaries; user-feedback RPC.
- [ ] Write failing schema verifier for all Spec §8–§13 fields and permissions.
- [ ] Run verifier; expect FAIL.
- [ ] Implement tables, constraints, indexes, RLS, grants, `malaak_reject_hypothesis(p_hypothesis_id uuid, p_feedback text)`, and observation submission RPC deriving `user_id` from `auth.uid()`.
- [ ] Run verifier; expect PASS.
- [ ] Commit `feat: add Malaak V5 formulation schema`.

### Task 2: Add observation extraction contract
**Files:** Create `supabase/functions/malaak-ai/observation.ts`, `observation_test.ts`; Modify `types.ts`, `index.ts`.
**Produces:** strict `CandidateObservation` schema and `sanitizeObservation` that strips diagnosis/causal claims.
- [ ] Write tests for permitted fields, unsupported extra fields, private-journal bypass, and no fabricated observation on parse failure.
- [ ] Run tests; expect FAIL.
- [ ] Implement extraction/sanitization and an optional `observation` field in coaching response only when analysis is permitted.
- [ ] Run tests; expect PASS.
- [ ] Commit `feat: extract bounded Malaak observations`.

### Task 3: Implement deterministic hypothesis evidence engine
**Files:** Create `supabase/functions/malaak-ai/hypothesis_engine.ts`, `hypothesis_engine_test.ts`.
**Produces:** pure `evaluateHypothesisEvidence(input): HypothesisDecision` implementing Spec §12 exactly.
- [ ] Write tests for 1 observation→candidate/low, 3 across 2 days→repeated/medium, high evidence rules, rejection lockout, contradiction handling, and 90-day dormancy.
- [ ] Run tests; expect FAIL.
- [ ] Implement deterministic engine with no model-controlled status transition.
- [ ] Run tests; expect PASS.
- [ ] Commit `feat: add deterministic pattern evidence engine`.

### Task 4: Persist observations and update hypotheses server-side
**Files:** Create `supabase/functions/malaak-ai/formulation_repository.ts`, `formulation_repository_test.ts`; Modify `index.ts`.
**Produces:** authenticated server functions that insert observations, compute/update hypotheses, and never trust client user IDs.
- [ ] Write repository tests using pure SQL payload builders/mocks for rejection lockout and immutable observation IDs.
- [ ] Run tests; expect FAIL.
- [ ] Implement server-managed persistence path after coaching response.
- [ ] Run all Edge tests; expect PASS.
- [ ] Commit `feat: persist Malaak observations and hypotheses`.

### Task 5: Build append-only formulation versioning
**Files:** Create `supabase/functions/malaak-ai/formulation.ts`, `formulation_test.ts`.
**Produces:** `buildFormulationSnapshot(observations,hypotheses,goals)` and material-change comparison; archive previous active formulation before new version.
- [ ] Write tests that formulation includes unknowns, never turns hypotheses into facts, and creates a new version only for material changes.
- [ ] Run tests; expect FAIL.
- [ ] Implement formulation builder/versioning request logic.
- [ ] Run tests; expect PASS.
- [ ] Commit `feat: version Malaak working formulations`.

### Task 6: Add Flutter progressive onboarding and initial map
**Files:** Create `lib/models/initial_map.dart`, `lib/screens/onboarding/initial_map_flow.dart`, `lib/screens/onboarding/initial_map_result_screen.dart`; Modify `auth/auth_gate.dart`, `models/app_state.dart`, `state/app_controller.dart`, storage repositories; Add tests `test/initial_map_test.dart` and `test/onboarding_gate_test.dart`.
**Produces:** onboarding shown only when no initial map, 6 approved steps, uncertainty wording, no percentages.
- [ ] Write failing Dart tests and V5B structural verifier for screen text/absence of `%`.
- [ ] Run available verifier; expect FAIL.
- [ ] Implement flow using existing Figma tokens/cards and existing navigation style.
- [ ] Run structural verifier; Flutter tests deferred to real SDK environment.
- [ ] Commit `feat: add progressive Malaak onboarding`.

### Task 7: Add hypothesis review/correction UI
**Files:** Create `lib/models/hypothesis_item.dart`, `lib/screens/profile/hypotheses_screen.dart`; Modify `memory_privacy_screen.dart`, `app_controller.dart`, `supabase_app_repository.dart`.
**Produces:** list grouped as initial/repeated/validated/rejected and explicit `هذا مو صحيح` action invoking the dedicated RPC.
- [ ] Write failing model/structure tests.
- [ ] Implement read model and rejection call; do not expose support-count mutation.
- [ ] Verify structural tests.
- [ ] Commit `feat: let users review Malaak hypotheses`.

### Task 8: Apply/deploy V5B and verify privacy/evidence rules
**Files:** Create `scripts/verify_v5b_release.py`; update `README.md`, `BUILD_STATUS.md`.
- [ ] Apply V5B migration.
- [ ] Deploy updated Edge Function with JWT verification.
- [ ] Query RLS/policies and run advisors.
- [ ] Run all Node tests + V5A/V5B verifiers.
- [ ] Commit `chore: verify Malaak V5B release`.
