# Feminine Intelligence Routing Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Build a testable interactive Start Map and two routed feminine-intelligence learning journeys while preserving Malaak's current premium UI.

**Architecture:** Add an isolated feature under `lib/features/feminine_intelligence/` with content, scorer, state adapter and screens. Persist feature state inside `AppStateData.learningJourneys`; Supabase synchronizes those states through a dedicated `malaak_learning_states` table so existing V5 state RPCs remain untouched.

**Tech Stack:** Flutter/Dart, Material 3, existing `PremiumCard`/theme widgets, SharedPreferences, Supabase Flutter/Postgres JSONB, Python static/release verification in this environment.

**Spec:** `docs/superpowers/specs/2026-09-02-feminine-intelligence-routing-design.md`

## Global Constraints

- Preserve current Malaak visual identity and app shell.
- Do not present route labels as diagnoses or fixed personality identities.
- Implement Start Map, feminine-naivety route, masculine-rigidity route, and advanced Situation Lab.
- Persist locally and to Supabase for authenticated users.
- Existing journeys other than `feminine-intelligence` must behave unchanged.
- No open-ended therapy chat is added in this release.

---

### Task 1: Learning state model and persistence contract

**Files:**
- Create: `lib/models/learning_journey_state.dart`
- Modify: `lib/models/app_state.dart`
- Modify: `lib/state/app_controller.dart`
- Modify: `lib/storage/supabase_app_repository.dart`
- Create: `supabase/migrations/20260902_malaak_learning_states_v6.sql`
- Test: `scripts/verify_feminine_intelligence_v6.py`

**Interfaces:**
- Produces `LearningJourneyState` with `domainId`, `routeId`, `assessmentCompleted`, `scores`, `answers`, `completedLessonIds`, `notes`, `updatedAt`.
- Produces `AppController.saveLearningJourneyState(LearningJourneyState value)`.
- Supabase table `malaak_learning_states(user_id, domain_id, state, updated_at)`.

- [ ] Write source-contract and migration tests first; verify RED.
- [ ] Implement model serialization and `AppStateData.learningJourneys`.
- [ ] Add controller save method.
- [ ] Add cloud load/upsert without modifying existing V5 RPC bodies.
- [ ] Add migration with RLS and authenticated grants.
- [ ] Re-run feature verification; verify GREEN.

### Task 2: Start Map content and deterministic scorer

**Files:**
- Create: `lib/features/feminine_intelligence/models/fi_models.dart`
- Create: `lib/features/feminine_intelligence/data/fi_catalog.dart`
- Create: `lib/features/feminine_intelligence/logic/fi_scorer.dart`
- Test: `scripts/verify_feminine_intelligence_v6.py`

**Interfaces:**
- `FiCatalog.assessmentQuestions` provides 12+ scenario questions with four weighted options each.
- `FiScorer.score(Map<String,String>)` returns dimension scores.
- `FiScorer.route(scores)` returns `feminine-naivety`, `masculine-rigidity`, or `advanced`.

- [ ] Add failing verification for question count, weight dimensions and route IDs.
- [ ] Implement content model/catalog and scorer.
- [ ] Verify GREEN with deterministic representative answer sets.

### Task 3: Start Map screens and result routing

**Files:**
- Create: `lib/features/feminine_intelligence/screens/feminine_intelligence_screen.dart`
- Create: `lib/features/feminine_intelligence/screens/fi_assessment_screen.dart`
- Modify: `lib/screens/journey/domain_detail_screen.dart`
- Test: `scripts/verify_feminine_intelligence_v6.py`

**Interfaces:**
- `FeminineIntelligenceScreen` reads saved `LearningJourneyState` and offers Start/Resume.
- `FiAssessmentScreen` saves each answer, computes route, persists state and returns to feature home.
- `DomainDetailScreen` delegates only `feminine-intelligence` to the new feature.

- [ ] Add failing UI/source contract checks.
- [ ] Implement premium Start Map UI with progress indicator and scenario cards.
- [ ] Implement non-diagnostic route result card.
- [ ] Verify GREEN.

### Task 4: Two learning routes and progress

**Files:**
- Extend: `lib/features/feminine_intelligence/data/fi_catalog.dart`
- Create: `lib/features/feminine_intelligence/screens/fi_route_screen.dart`
- Create: `lib/features/feminine_intelligence/screens/fi_lesson_screen.dart`
- Test: `scripts/verify_feminine_intelligence_v6.py`

**Interfaces:**
- `FiCatalog.routeById()` returns route metadata and lesson list.
- `FiRouteScreen` displays route goal and lesson cards.
- `FiLessonScreen` captures one reflection/choice, stores optional note, and marks lesson complete.

- [ ] Add failing checks for 7 feminine-naivety modules and 9 masculine-rigidity modules.
- [ ] Implement route content from approved design.
- [ ] Implement lesson UI and completion persistence.
- [ ] Verify GREEN.

### Task 5: Advanced Situation Lab and resume UX

**Files:**
- Create: `lib/features/feminine_intelligence/screens/fi_situation_lab_screen.dart`
- Modify: `lib/features/feminine_intelligence/screens/feminine_intelligence_screen.dart`
- Test: `scripts/verify_feminine_intelligence_v6.py`

**Interfaces:**
- Advanced users can open a six-step structured situation lab.
- Implemented-route users unlock the lab after at least one completed bridge/final lesson; trial may also expose it from result as preview.

- [ ] Add failing contract checks for six lab prompts and no open-ended AI dependency.
- [ ] Implement structured lab with locally persisted reflection note.
- [ ] Verify GREEN.

### Task 6: Full release verification and package

**Files:**
- Modify: `START_HERE.txt`
- Create: `V6.6_FEMININE_INTELLIGENCE_TRIAL.txt`
- Package output: `/mnt/data/Malaak-Flutter-Android-V6.6-Feminine-Intelligence-Trial.zip`

**Interfaces:**
- Existing one-click GitHub uploader remains usable.

- [ ] Run `python scripts/verify_feminine_intelligence_v6.py`.
- [ ] Run `python scripts/verify_auth_binding_hotfix.py`.
- [ ] Run `python scripts/verify_github_one_click_upload.py`.
- [ ] Run `python scripts/verify_android_release_readiness.py`.
- [ ] Run archive integrity test.
- [ ] Package source and report that Flutter compile occurs via GitHub Actions because Flutter SDK is not installed locally.
