# Build Status — Malaak Flutter Android V6.1 Source

Date: 2026-08-29
Version: `0.6.7+11`

## Android Release Readiness

The approved V5A/V5B/V5C behavior engine remains intact. Version `0.6.7+11` keeps the Android hardening and adds a pinned Flutter toolchain, Android Doctor checks, and Dart source-integrity verification without changing the approved Figma-derived mobile style.

Verified source changes:

- Keyboard/IME-aware shell; floating bottom navigation is hidden while the keyboard is open.
- Malaak composer uses safe-area-aware bottom spacing instead of a fixed `+90` offset.
- Root mobile destinations remain Arabic RTL and SafeArea-protected.
- No Sidebar, Drawer, NavigationDrawer, or NavigationRail.
- Android scaffold generator uses package id `com.malaak.malaak_balance` and display name `ملاك`.
- Cross-platform build scripts run `flutter pub get`, `flutter analyze`, `flutter test`, APK build and AAB build.
- GitHub Actions uses pinned **Flutter 3.47.1** and Java 17 and uploads APK/AAB artifacts.
- Android regression checks are included in the existing V5 release gate.

## Existing V5 engine evidence

- V5A scientific intervention catalog retained.
- V5B progressive assessment/formulation retained.
- V5C deterministic Journey Planner retained, including the server-managed `malaak_journey_plans` snapshot.
- Complete Edge/server suite remains **68/68 PASS** in this execution environment.
- Android Doctor scripts validate Flutter/Java/Android toolchain readiness before local builds.
- Dart source-integrity verification checks all local/package imports and merge-conflict markers.
- Supabase Journey Planner migration and `malaak-ai` Edge Function v6 were previously verified live.

## Final source verification

Run:

```bash
python scripts/verify_android_release_readiness.py
```

This runs the Android-specific gates plus the complete V5 release verification.

## Runtime/build limitation

Flutter SDK, Dart SDK and Android SDK are not installed in this execution environment, so this status does **not** claim that an APK was compiled here.

On a Flutter-capable machine or GitHub Actions, run:

```bash
bash scripts/build_android_release.sh
```

Expected outputs after a successful build:

- `build/app/outputs/flutter-apk/app-release.apk`
- `build/app/outputs/bundle/release/app-release.aab`

For Google Play production release, configure protected upload signing / Play App Signing separately. No keystore password, `OPENAI_API_KEY`, or Supabase service-role key belongs in the Android client or repository.


## V6.7 conversational training

- Assessment is chat-style with explicit previous/next navigation; answer taps do not auto-advance.
- All four educational models are displayed after assessment; Malaak recommends, the user chooses.
- `advanced` is no longer a no-problem terminal result; masculine-intelligence and feminine-intelligence have working routes.
- Lessons are multi-step coaching sessions with scenario retry, reflection, real-life mission, and later follow-up.
- Progress distinguishes training sessions, pending missions, and real-life applications.
- Existing `malaak_learning_states` persistence is reused; Auth/Supabase project binding is unchanged.

## V6.6 feminine-intelligence trial

- Start Map: 12 scenario questions.
- Routes: feminine-naivety -> feminine intelligence; masculine-rigidity -> feminine intelligence; advanced Situation Lab.
- New Dart source contract verification: PASS.
- Supabase migration `malaak_learning_states_v6`: applied to `puwomvazbzvjmzzmogoj`, RLS enabled.
- Existing server suite: 68/68 PASS.
