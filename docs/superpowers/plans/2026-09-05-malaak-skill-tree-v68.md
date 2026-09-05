# Malaak Skill Tree V6.8 Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Turn the feminine-intelligence journey into a locked skill tree where main nodes unlock only after real-life practice and timed follow-up, while always leaving an optional activity available.

**Architecture:** Extend `LearningLessonProgress` with explicit timing/mastery evidence and centralize unlock decisions in a pure progression policy. Keep authored curriculum in `FiCatalog`, render route nodes from policy-derived states, and let `FiLessonScreen` handle session → mission wait → follow-up → retry/substitute simulation. Persist the enriched state through the existing `LearningJourneyState` JSON and Supabase `malaak_learning_states` row.

**Tech Stack:** Flutter/Dart source, Supabase JSONB persistence, Python source-contract verification (Flutter SDK unavailable in this execution environment).

**Spec:** `docs/superpowers/specs/2026-09-05-malaak-skill-tree-retention-design.md`

## Global Constraints

- Preserve the current Malaak premium soft visual identity and RTL behavior.
- The four feminine-intelligence models remain educational routes, not diagnoses.
- Selecting/reading a lesson alone never unlocks the next main node.
- Default follow-up delay is configurable and approximately 12–24 hours; V6.8 default is 18 hours.
- A successful follow-up or successful substitute simulation is required for mastery.
- `oldPattern`, `forgot`, and `difficult` outcomes require retry and do not unlock the next main node.
- `noChance` opens substitute simulation; it does not punish/reset progress.
- Supabase remains the durable signed-in store through `malaak_learning_states`; local persistence remains cache/resilience.
- Do not copy feminine-intelligence content into other domains.

---

### Task 1: Progression state and unlock policy

**Files:**
- Modify: `lib/models/learning_journey_state.dart`
- Create: `lib/features/feminine_intelligence/logic/fi_progression.dart`
- Create: `scripts/verify_feminine_intelligence_v8.py`

**Interfaces:**
- Produces `FiNodeStatus` enum and `FiProgression.nodeStatus(...)`, `FiProgression.isNodeActionable(...)`, `FiProgression.followUpDelay`, `FiProgression.nextUnlockReason(...)`.
- `LearningLessonProgress` gains `missionAssignedAt`, `followUpAvailableAt`, `followUpCompletedAt`, `masteryEvidence`, and helper getters for ready/mastered state.

- [ ] **Step 1: Write failing V6.8 contract checks** for explicit node states, follow-up timestamps, policy class, locked route UI markers, substitute simulation, and version bump.
- [ ] **Step 2: Run `python3 scripts/verify_feminine_intelligence_v8.py` and confirm failure** because the V6.8 progression API does not exist.
- [ ] **Step 3: Implement minimal state fields and pure progression policy** with 18-hour default delay and first-node-only initial availability.
- [ ] **Step 4: Re-run the V6.8 contract and confirm the model/policy checks pass while UI checks still fail.**

### Task 2: Locked skill-tree route UI

**Files:**
- Modify: `lib/features/feminine_intelligence/screens/fi_route_screen.dart`
- Modify: `lib/features/feminine_intelligence/screens/feminine_intelligence_screen.dart`

**Interfaces:**
- Consumes `FiProgression.nodeStatus`.
- Produces visible locked/current/mission/follow-up/mastered node cards and a next-unlock requirement card.

- [ ] **Step 1: Keep V6.8 contract failing on route UI assertions.**
- [ ] **Step 2: Render every future node but disable taps for `locked`.**
- [ ] **Step 3: Highlight current actionable node and show lock/follow-up/mastery iconography and status copy.**
- [ ] **Step 4: Add route summary metrics for mastered skills, real-life applications, ready follow-ups, and explicit next unlock requirement.**
- [ ] **Step 5: Run V6.8 contract and confirm route UI checks pass.**

### Task 3: Hybrid session/mission/follow-up flow

**Files:**
- Modify: `lib/features/feminine_intelligence/screens/fi_lesson_screen.dart`
- Modify: `lib/features/feminine_intelligence/models/fi_models.dart`
- Modify: `lib/features/feminine_intelligence/data/fi_catalog.dart`

**Interfaces:**
- Session completion stores `missionPending`, `missionAssignedAt`, and `followUpAvailableAt = assignedAt + 18h`.
- Before readiness, screen shows countdown/ready copy plus optional mini-practice.
- `success` masters the node; `difficult`, `oldPattern`, `forgot` switch to retry; `noChance` switches to substitute simulation; successful substitute simulation masters the node.

- [ ] **Step 1: Verify V6.8 contract fails on timing/substitute/retry behavior.**
- [ ] **Step 2: Save mission timestamps and stop treating every attempted outcome as applied/mastered.**
- [ ] **Step 3: Add waiting state that blocks main follow-up until ready but exposes one optional simulation/reflection immediately.**
- [ ] **Step 4: Add substitute simulation path for `noChance` with explicit success requirement.**
- [ ] **Step 5: Add repair/retry path for difficult/old-pattern/forgot outcomes and keep the next node locked.**
- [ ] **Step 6: Re-run V6.8 contract.**

### Task 4: Active journey and wider locked life map

**Files:**
- Modify: `lib/screens/home/home_screen.dart`
- Modify: `lib/screens/journey/journey_screen.dart`

**Interfaces:**
- Home prioritizes the active feminine-intelligence journey when selected.
- Wider domains remain visible but show locked/value-preview treatment until authored with the new progression engine; current active journey remains actionable.

- [ ] **Step 1: Add V6.8 checks for active-journey-first copy and visible lock preview.**
- [ ] **Step 2: Show active learning journey progress on Home instead of implying all domain cards are equally actionable.**
- [ ] **Step 3: In Journey screen, keep domains visible but route unfinished new-methodology domains to a lock explanation rather than the old one-click completion experience.**
- [ ] **Step 4: Re-run V6.8 contract.**

### Task 5: Versioning, release notes, and full verification

**Files:**
- Modify: `pubspec.yaml`
- Create: `V6.8_SKILL_TREE_RETENTION.txt`
- Modify: `README.md`

**Interfaces:**
- Version becomes `0.6.8+12`.

- [ ] **Step 1: Bump version and add release notes describing skill-tree locks, 18-hour follow-up window, optional practice, retry/substitute behavior, and active-journey life map.**
- [ ] **Step 2: Run `python3 scripts/verify_feminine_intelligence_v8.py`.**
- [ ] **Step 3: Run existing V6.7, V6.6, auth binding, Dart source integrity, Android pipeline/readiness/UI checks and confirm no regressions.**
- [ ] **Step 4: Package only verified source as `Malaak-Flutter-Android-V6.8-Skill-Tree-Retention.zip`.**

## Self-review

- Spec coverage: locking, timed follow-up, optional activity, no-chance substitute, retry, active route metrics, persistence, and wider visible locked map are each assigned to a task.
- No placeholder implementation steps remain.
- State names are consistent across model, policy, route UI, and lesson flow.
