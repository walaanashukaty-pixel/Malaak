# Feminine Intelligence Conversational Training Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Upgrade V6.6 feminine intelligence assessment and training into a conversational, user-selectable, practice-and-follow-up journey.

**Architecture:** Store Malaak's recommendation separately from the user's chosen route. Add domain-agnostic lesson progress to `LearningJourneyState`, route all four educational models to working journeys, and turn assessment/lesson screens into chat-style steppers with explicit navigation and real-life follow-up.

**Tech Stack:** Flutter/Dart source, existing AppController/AppRepository state persistence, Supabase JSON state, Python source-contract verification, existing Node Edge tests.

**Spec:** `docs/superpowers/specs/2026-09-02-feminine-intelligence-conversational-training-design.md`

## Global Constraints
- Preserve all existing Malaak domains and premium visual design.
- Keep Supabase project binding unchanged.
- Do not add diagnosis or identity claims.
- Use `malaak_learning_states` JSON state for new progress fields.
- Preserve backward compatibility for V6.6 saved state.

---

### Task 1: V7 regression contract and learning progress model
**Files:**
- Create: `scripts/verify_feminine_intelligence_v7.py`
- Modify: `lib/models/learning_journey_state.dart`

**Interfaces:**
- Produces: `recommendedRouteId`, `lessonProgress`, `LearningLessonProgress` serialization.

- [ ] Write a source-contract verifier that fails against V6.6 and checks all V7 acceptance points visible in source.
- [ ] Run the verifier and confirm RED.
- [ ] Add recommendation and lesson-progress serialization with backward-compatible defaults.
- [ ] Run the verifier/model integrity checks as applicable.

### Task 2: Four-model recommendation and route catalog
**Files:**
- Modify: `lib/features/feminine_intelligence/models/fi_models.dart`
- Modify: `lib/features/feminine_intelligence/data/fi_catalog.dart`
- Modify: `lib/features/feminine_intelligence/logic/fi_scorer.dart`

**Interfaces:**
- Produces: four route IDs, four model descriptors, recommendation ranking, scenario content for interactive sessions.

- [ ] Add four educational model descriptors and coach feedback structures.
- [ ] Add functional masculine-intelligence and feminine-intelligence routes.
- [ ] Replace `advanced` routing with strongest-dimension recommendation and top-two ranking support.
- [ ] Run the V7 verifier and confirm the routing portion turns GREEN.

### Task 3: Conversational assessment and route selection
**Files:**
- Modify: `lib/features/feminine_intelligence/screens/fi_assessment_screen.dart`
- Create: `lib/features/feminine_intelligence/screens/fi_assessment_result_screen.dart`
- Modify: `lib/features/feminine_intelligence/screens/feminine_intelligence_screen.dart`

**Interfaces:**
- Consumes: `FiScorer.recommendRoute`, model descriptors.
- Produces: saved `recommendedRouteId`, user-selected `routeId`.

- [ ] Render assessment as Malaak/user chat bubbles.
- [ ] Make option selection local-only; no auto-advance.
- [ ] Add explicit previous/next controls and soft percent progress.
- [ ] Submit only on final next, save recommendation, and open four-model selection.
- [ ] Allow any model to be selected and persist chosen route.
- [ ] Remove the V6.6 no-problem/`advanced` result branch.

### Task 4: Deep interactive training sessions and real-life follow-up
**Files:**
- Modify: `lib/features/feminine_intelligence/screens/fi_lesson_screen.dart`
- Modify: `lib/features/feminine_intelligence/screens/fi_route_screen.dart`

**Interfaces:**
- Consumes: lesson scenario/feedback content and `LearningLessonProgress`.
- Produces: practice step state, mission pending state, application count, follow-up result.

- [ ] Implement a multi-step chat session: intro, discovery, coach reflection, scenario, scenario feedback, personal response, mission commitment.
- [ ] Prevent a lesson from being marked applied immediately after in-app practice.
- [ ] On re-entry to a mission-pending lesson, show follow-up options and update application evidence.
- [ ] Show route-level practice/application metrics and lesson status labels.
- [ ] Keep situation lab available as ongoing practice.

### Task 5: Verification, release metadata, and package
**Files:**
- Modify: `pubspec.yaml`
- Modify: `README.md`
- Create: `V6.7_CONVERSATIONAL_TRAINING.txt`
- Modify: `scripts/verify_android_release_readiness.py` only if needed to include V7 verifier.

**Interfaces:**
- Produces: V6.7 source package ready for GitHub Actions APK build.

- [ ] Run V7 verifier.
- [ ] Run Dart source-integrity verifier.
- [ ] Run Auth/Supabase binding verifier.
- [ ] Run full Android release-readiness verifier and 68 Edge tests.
- [ ] Package source as `Malaak-Flutter-Android-V6.7-Conversational-Training.zip`.
