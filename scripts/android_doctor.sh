#!/usr/bin/env bash
set -euo pipefail

EXPECTED_FLUTTER='3.47.1'

if ! command -v flutter >/dev/null 2>&1; then
  echo 'ERROR: Flutter SDK not found in PATH.' >&2
  exit 1
fi
if ! command -v java >/dev/null 2>&1; then
  echo 'ERROR: Java not found in PATH. Android builds require a JDK.' >&2
  exit 2
fi

echo '== Flutter =='
flutter --version
FIRST_LINE="$(flutter --version 2>/dev/null | head -n 1 || true)"
if [[ "$FIRST_LINE" != *"Flutter $EXPECTED_FLUTTER"* ]]; then
  echo "WARNING: Project CI is pinned to Flutter $EXPECTED_FLUTTER; local SDK differs." >&2
fi

echo
echo '== Java =='
java -version 2>&1 | head -n 3

echo
echo '== Flutter doctor =='
DOCTOR="$(flutter doctor -v 2>&1 || true)"
printf '%s\n' "$DOCTOR"
if printf '%s\n' "$DOCTOR" | grep -q '^\[✗\] Android toolchain'; then
  echo 'ERROR: Flutter reports an invalid Android toolchain.' >&2
  exit 3
fi

echo
echo '== Devices (optional for APK/AAB build) =='
flutter devices || true

if [ ! -f android/app/src/main/AndroidManifest.xml ]; then
  echo
echo 'Android scaffold is not generated yet.'
  echo 'Run: bash scripts/bootstrap_android.sh'
else
  echo
echo 'Android scaffold: present'
fi

echo
echo "Doctor complete. CI toolchain target: Flutter $EXPECTED_FLUTTER"
