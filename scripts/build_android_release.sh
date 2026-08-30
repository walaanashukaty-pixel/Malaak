#!/usr/bin/env bash
set -euo pipefail

if ! command -v flutter >/dev/null 2>&1; then
  echo 'Flutter SDK not found. Install Flutter stable and add it to PATH first.' >&2
  exit 1
fi

if [ ! -f android/app/src/main/AndroidManifest.xml ]; then
  bash scripts/bootstrap_android.sh
fi

flutter pub get
flutter analyze --no-fatal-infos
flutter test
flutter build apk --release
flutter build appbundle --release

printf '\nAPK: build/app/outputs/flutter-apk/app-release.apk\n'
printf 'AAB: build/app/outputs/bundle/release/app-release.aab\n'
