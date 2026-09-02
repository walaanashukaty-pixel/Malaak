#!/usr/bin/env bash
set -euo pipefail

if ! command -v flutter >/dev/null 2>&1; then
  echo 'Flutter SDK not found. Install Flutter stable and add it to PATH first.' >&2
  exit 1
fi

TMP_ROOT="$(mktemp -d)"
TMP_PROJECT="$TMP_ROOT/malaak_flutter_bootstrap"
cleanup() { rm -rf "$TMP_ROOT"; }
trap cleanup EXIT

flutter create \
  --platforms=android \
  --org com.malaak \
  --project-name malaak_balance \
  --no-pub \
  "$TMP_PROJECT"

rm -rf android
cp -R "$TMP_PROJECT/android" ./android

MANIFEST='android/app/src/main/AndroidManifest.xml'
python3 - "$MANIFEST" <<'PY'
from pathlib import Path
import sys
p = Path(sys.argv[1])
s = p.read_text(encoding='utf-8')
s = s.replace('android:label="malaak_balance"', 'android:label="ملاك"')
if 'android.permission.INTERNET' not in s:
    end = s.find('>')
    if end < 0:
        raise SystemExit('Could not locate opening <manifest> tag')
    s = s[:end + 1] + '\n    <uses-permission android:name="android.permission.INTERNET" />' + s[end + 1:]
p.write_text(s, encoding='utf-8')
PY

PACKAGE_ID='com.malaak.malaak_balance'
if ! grep -R -q "$PACKAGE_ID" android/app/build.gradle android/app/build.gradle.kts android/app/src/main 2>/dev/null; then
  echo "Generated Android scaffold does not contain expected package id: $PACKAGE_ID" >&2
  exit 2
fi
if ! grep -q 'android:label="ملاك"' "$MANIFEST"; then
  echo 'Android app label patch failed.' >&2
  exit 3
fi
if ! grep -q 'android.permission.INTERNET' "$MANIFEST"; then
  echo 'Android release INTERNET permission patch failed.' >&2
  exit 4
fi

printf '\nAndroid scaffold ready: %s\n' "$PACKAGE_ID"
printf 'Next: bash scripts/build_android_release.sh\n'
