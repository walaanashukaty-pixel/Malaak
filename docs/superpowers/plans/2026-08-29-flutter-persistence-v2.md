# Malaak Flutter Persistence V2 Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Turn the Flutter V1 mock UI into a stateful Android app that persistently stores profile, journals, journey progress, memory preferences, and derives reports from saved data.

**Architecture:** Use a repository abstraction backed by SharedPreferences JSON, an AppController ChangeNotifier as the single state coordinator, and an AppScope InheritedNotifier for dependency access without adding a state-management package. Screens read/write through AppController. AI remains behind a service boundary so a server endpoint can replace the local demo safely later.

**Tech Stack:** Flutter, Dart, shared_preferences, ChangeNotifier, Material 3.

**Spec:** Conversation-approved Malaak mobile architecture.

## Global Constraints
- Android-first Flutter app.
- Arabic RTL.
- No sidebar/drawer.
- Home remains the orchestration hub.
- Bottom navigation remains: الرئيسية / ملاك / رحلتي / أنا.
- No fake diagnostic percentages.
- Memory distinguishes facts, patterns, preferences, hypotheses.
- User can control journal analysis and report inclusion.

---

### Task 1: Persistent application state
- [ ] Add serializable models for profile, journal entry, journey progress, memory item, preferences, and app state.
- [ ] Add repository interface and SharedPreferences implementation.
- [ ] Add AppController and AppScope.
- [ ] Bootstrap state in main.dart.

### Task 2: Journal and journey persistence
- [ ] Replace in-session journal list with AppController data.
- [ ] Persist journey status and completed practices.
- [ ] Add meaningful empty states.

### Task 3: Memory and privacy controls
- [ ] Persist memory permissions.
- [ ] Display stored memory items by type.
- [ ] Support deleting memory items.

### Task 4: Data-derived reports
- [ ] Derive weekly report metrics from saved journals and progress.
- [ ] Replace static report copy with live summary and insufficient-data handling.

### Task 5: Malaak conversation history
- [ ] Persist user and Malaak messages locally.
- [ ] Keep demo safety-aware responder behind MalaakService interface.
- [ ] Add clear future backend endpoint boundary.

### Task 6: Verification and packaging
- [ ] Run structural verification.
- [ ] Check source for Drawer/Sidebar regressions.
- [ ] Package V2 ZIP and update README/BUILD_STATUS.
