# Malaak Flutter V1 Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Build the first Flutter Android source for Malaak with the approved Figma identity and phone-first information architecture.

**Architecture:** Use a dependency-light Flutter Material app with reusable theme/widgets, a custom four-item bottom navigation shell, local catalog data, generic journey details, and local demo coaching state. Android platform scaffolding is generated on a machine with Flutter SDK using the included bootstrap scripts.

**Tech Stack:** Flutter, Dart, Material 3, no third-party runtime packages in V1.

**Spec:** `docs/superpowers/specs/2026-08-29-malaak-flutter-mobile-design.md`

## Global Constraints
- Arabic RTL first.
- No Sidebar/Drawer.
- Four bottom destinations only: الرئيسية / ملاك / رحلتي / أنا.
- Preserve approved Figma palette and premium rounded-card style.
- No diagnosis or fake psychological percentages.
- Local demo behavior only; production AI/backend deferred.

---

### Task 1: Project contract and catalog
**Files:** `pubspec.yaml`, `lib/core/theme/*`, `lib/models/*`, `lib/data/app_catalog.dart`, `test/catalog_test.dart`
- [ ] Add failing catalog/theme tests.
- [ ] Verify test runner limitation if Flutter SDK is absent.
- [ ] Implement palette, models, domains, and quick tools.
- [ ] Add static verification fallback for this environment.

### Task 2: Mobile shell
**Files:** `lib/main.dart`, `lib/navigation/app_shell.dart`, `lib/widgets/app_bottom_nav.dart`, `test/app_shell_test.dart`
- [ ] Specify four-tab/no-drawer behavior in tests.
- [ ] Implement RTL app shell and bottom navigation.

### Task 3: Home control center
**Files:** `lib/screens/home/home_screen.dart`, `lib/widgets/premium_card.dart`, `lib/widgets/section_header.dart`
- [ ] Specify required home modules in tests/static checks.
- [ ] Implement adaptive mobile home with approved visual language.

### Task 4: Malaak demo coaching
**Files:** `lib/screens/malaak/malaak_screen.dart`, `lib/services/demo_malaak_service.dart`, `test/demo_malaak_service_test.dart`
- [ ] Specify deterministic local response routing.
- [ ] Implement chat UI and local demo service.

### Task 5: Journey system
**Files:** `lib/screens/journey/journey_screen.dart`, `lib/screens/journey/domain_detail_screen.dart`
- [ ] Verify every approved domain is reachable.
- [ ] Implement primary/support/maintenance and generic domain detail flow.

### Task 6: Profile, journal, reports, tools
**Files:** `lib/screens/profile/*`, `lib/screens/journal/*`, `lib/screens/reports/*`, `lib/screens/tools/*`
- [ ] Specify reachable profile destinations.
- [ ] Implement local journal, reports, personal manual, memory/privacy, settings, and tool flows.

### Task 7: Android bootstrap and verification
**Files:** `README.md`, `BUILD_STATUS.md`, `scripts/bootstrap_android.*`, `scripts/verify_structure.py`, `analysis_options.yaml`
- [ ] Add bootstrap scripts.
- [ ] Run structural verifier.
- [ ] Search source to prove no Drawer/Sidebar.
- [ ] Package ZIP excluding git metadata.
