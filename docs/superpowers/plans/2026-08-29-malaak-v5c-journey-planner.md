# Malaak V5C Journey Planner Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Turn the active formulation, user goal, functioning, outcomes, and safety/readiness signals into one simple versioned plan with at most one Primary and one Support path, plus Monitor/Later domains.

**Architecture:** A deterministic planner ranks current-life domains using explicit priority tiers. The model may phrase the reasoning summary but cannot choose tier or domain outside server output. Flutter renders the server plan in the existing Home/Journey style and supports temporary Support Mode rather than demotion.

**Tech Stack:** PostgreSQL/Supabase, TypeScript Edge Functions, Flutter/Dart, Node tests, Python structural verification.

**Spec:** `docs/superpowers/specs/2026-08-29-malaak-scientific-library-formulation-v5-design.md`

## Global Constraints

- Safety suspends ordinary planning.
- Planner emits 0..1 Primary and 0..1 Support.
- High/repeated activation blocks automatic childhood/healing Primary.
- User goal and repeated current-life impact outrank deeper historical themes.
- One maintaining mechanism may become Support.
- Difficult weeks trigger Support Mode, not progress demotion.
- Rejected/dormant hypotheses cannot dominate planner input.

---

### Task 1: Add journey-plan schema and server-managed permissions
**Files:** Create `supabase/migrations/20260829_malaak_journey_planner_v5.sql`; Test `scripts/verify_v5c_schema.py`.
**Produces:** versioned `malaak_journey_plans` table with Spec §16 fields and read-only app access.
- [ ] Write failing schema verifier.
- [ ] Run and expect FAIL.
- [ ] Implement table, RLS, indexes, version uniqueness, active-plan constraint, read-only authenticated access.
- [ ] Run and expect PASS.
- [ ] Commit `feat: add Malaak journey plan schema`.

### Task 2: Implement deterministic planner
**Files:** Create `supabase/functions/malaak-ai/journey_planner.ts`, `journey_planner_test.ts`.
**Produces:** `buildJourneyPlan(input): JourneyPlanDecision`.
- [ ] Write tests for Spec examples A/B/C, one-primary/one-support limit, high activation deep-work block, rejected/dormant evidence exclusion, and no-plan safety mode.
- [ ] Run tests; expect FAIL.
- [ ] Implement tiered rules with deterministic tie-breaking: safety > regulation readiness > explicit user goal/current impact > repeated evidence > maintaining mechanism > historical later.
- [ ] Run tests; expect PASS.
- [ ] Commit `feat: add deterministic Malaak journey planner`.

### Task 3: Add non-response/support-mode logic
**Files:** Create `supabase/functions/malaak-ai/progress_engine.ts`, `progress_engine_test.ts`.
**Produces:** `evaluateJourneyReview` using awareness/assisted/independent/stability evidence and `support_mode` recommendation when outcomes worsen or repeated interventions do not help.
- [ ] Write tests for stable progression, difficult week without demotion, repeated non-response triggering reassessment/step-up.
- [ ] Run tests; expect FAIL.
- [ ] Implement progress/review logic.
- [ ] Run tests; expect PASS.
- [ ] Commit `feat: add journey review and support mode`.

### Task 4: Persist/version plans after material formulation changes
**Files:** Create `supabase/functions/malaak-ai/journey_repository.ts`; Modify `index.ts`; Add tests.
**Produces:** archive previous active plan and insert next version only when material planner output changes.
- [ ] Write failing persistence/version tests.
- [ ] Implement repository logic deriving user from JWT/server context.
- [ ] Run tests; expect PASS.
- [ ] Commit `feat: persist versioned Malaak journey plans`.

### Task 5: Add Flutter JourneyPlan model and cloud state
**Files:** Create `lib/models/journey_plan.dart`; Modify `models/app_state.dart`, storage repositories, `state/app_controller.dart`; Add `test/journey_plan_test.dart`.
**Produces:** backward-compatible local snapshot of active plan.
- [ ] Write failing serialization tests.
- [ ] Implement model and sync mapping.
- [ ] Run V5C structural verifier and later Flutter tests in real SDK.
- [ ] Commit `feat: sync Malaak journey plan state`.

### Task 6: Connect Home and Journey UI to real planner output
**Files:** Modify `lib/screens/home/home_screen.dart`, `lib/screens/journey/journey_screen.dart`; Add `test/journey_planner_ui_test.dart` and structure verifier.
**Produces:** Home shows current Primary focus and support skill; Journey shows Primary/Support/Monitor/Later without percentages; safety/support-mode states override growth prompts.
- [ ] Write failing structure/UI tests for labels and no fake percentages.
- [ ] Implement using existing PremiumCard/Figma tokens; no Sidebar/Drawer.
- [ ] Verify structural tests.
- [ ] Commit `feat: render personalized Malaak journey plan`.

### Task 7: Apply/deploy V5C and full V5 release verification
**Files:** Create `scripts/verify_v5_release.py`; Update `README.md`, `BUILD_STATUS.md`, `pubspec.yaml`.
- [ ] Apply planner migration and deploy Edge Function.
- [ ] Query active plan/catalog RLS and run advisors.
- [ ] Run all Node tests and V5A/V5B/V5C structural verifiers.
- [ ] Set final V5 version marker while preserving `0.5.x` semantic line.
- [ ] Commit `chore: verify complete Malaak V5 engine`.
