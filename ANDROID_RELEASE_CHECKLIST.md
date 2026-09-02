# Android Release Checklist — Malaak

This checklist is for the real Android build environment. Source version: `0.6.7+11`.

## Identity

- Package/application id: `com.malaak.malaak_balance`
- Android display name: `ملاك`
- UI direction: Arabic **RTL**
- Navigation: four mobile destinations only — الرئيسية / ملاك / رحلتي / أنا
- No Drawer, NavigationDrawer, NavigationRail, or desktop Sidebar.

## 1. Toolchain

CI reference toolchain: **Flutter 3.47.1** + Java 17. Before any local build run:

```powershell
powershell -ExecutionPolicy Bypass -File scripts\android_doctor.ps1
```

The Android Doctor prints `flutter --version`, `flutter doctor -v`, Java details, and `flutter devices`.

Run on a machine with Flutter 3.47.1, Android SDK, Android Studio command-line tools, and Java 17:

```bash
flutter doctor -v
```

Resolve Android toolchain errors before continuing.

## 2. Generate the Android platform scaffold

macOS/Linux:

```bash
bash scripts/bootstrap_android.sh
```

Windows PowerShell:

```powershell
powershell -ExecutionPolicy Bypass -File scripts/bootstrap_android.ps1
```

After generation, verify:

- `android/app/src/main/AndroidManifest.xml` exists.
- App label is `ملاك`.
- Generated Android package id contains `com.malaak.malaak_balance`.

## 3. Source quality gates

```bash
flutter pub get
flutter analyze
flutter test
python scripts/verify_android_release_readiness.py
```

All must pass before building a release artifact.

## 4. Real-device Android QA

Test at minimum on one small phone and one taller phone:

- RTL text and directional icons are correct.
- Home scrolls without clipped cards.
- Bottom navigation does not overlap content.
- Open the **keyboard** in ملاك: bottom navigation must hide and the composer must remain visible above the IME.
- Close the keyboard: bottom navigation returns and the composer remains above the floating navigation.
- Long Arabic messages wrap correctly.
- Auth fields remain reachable when the keyboard is open.
- Initial Map flow scrolls correctly with the keyboard open.
- Android back button closes nested screens before exiting the app.
- Safe areas/navigation gesture area do not cover interactive controls.
- Offline/cloud error messages do not freeze navigation.

## 5. Build APK and AAB

One command path is provided:

```bash
bash scripts/build_android_release.sh
```

Or run the underlying commands explicitly:

```bash
flutter pub get
flutter analyze
flutter test
flutter build apk --release
flutter build appbundle --release
```

Expected outputs:

- APK: `build/app/outputs/flutter-apk/app-release.apk`
- AAB: `build/app/outputs/bundle/release/app-release.aab`

## 6. Signing and Google Play

The CI workflow builds verification artifacts. Before a production Google Play release:

- Configure Play App Signing / upload signing according to the current Flutter/Google Play guidance.
- Never commit keystores, passwords, service-role keys, or `OPENAI_API_KEY`.
- Store signing credentials in the release environment's protected secret store.
- Verify version code/build number is greater than the previous Play release.

## 7. Backend checks before public release

- Confirm Supabase project URL and publishable client key point to the intended environment.
- Confirm `malaak-ai` is ACTIVE and JWT verification is enabled.
- Confirm RLS remains enabled for user-owned data.
- Confirm `OPENAI_API_KEY` exists only as a Supabase/server secret.
- Review current Supabase security advisors.

## 8. GitHub Actions

`.github/workflows/android-release.yml` can be run manually with **workflow_dispatch** or by pushing a `v*` tag. It runs Flutter stable, `flutter analyze`, `flutter test`, then builds and uploads APK and AAB artifacts.

A green CI build proves compilation in that CI environment. It does not replace real-device RTL/keyboard QA or production signing verification.
