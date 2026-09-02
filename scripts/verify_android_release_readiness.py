#!/usr/bin/env python3
from pathlib import Path
import subprocess, sys, re

root = Path(__file__).resolve().parents[1]

def fail(msg):
    print(f'FAIL: {msg}')
    sys.exit(1)

def run(cmd):
    print('+', ' '.join(map(str, cmd)))
    result = subprocess.run(cmd, cwd=root, text=True)
    if result.returncode != 0:
        fail(f'command failed ({result.returncode}): {cmd}')

pubspec = (root/'pubspec.yaml').read_text(encoding='utf-8')
if 'version: 0.6.6+10' not in pubspec:
    fail('pubspec must be Android readiness version 0.6.6+10')

checklist = root/'ANDROID_RELEASE_CHECKLIST.md'
if not checklist.exists(): fail('ANDROID_RELEASE_CHECKLIST.md missing')
check = checklist.read_text(encoding='utf-8')
for marker in [
    'com.malaak.malaak_balance', 'ملاك', 'flutter analyze', 'flutter test',
    'flutter build apk --release', 'flutter build appbundle --release',
    'RTL', 'keyboard', 'APK', 'AAB',
]:
    if marker not in check: fail(f'Android checklist missing {marker}')

readme=(root/'README.md').read_text(encoding='utf-8')
build=(root/'BUILD_STATUS.md').read_text(encoding='utf-8')
for marker in ['Android Release Readiness', '0.6.6+10', 'GitHub Actions', 'Flutter 3.47.1', 'Android Doctor', 'APK', 'AAB']:
    if marker not in readme: fail(f'README missing {marker}')
for marker in ['Malaak Flutter Android V6.1 Source', '0.6.6+10', 'Android Release Readiness', 'Flutter 3.47.1', 'Android Doctor', '68/68']:
    if marker not in build: fail(f'BUILD_STATUS missing {marker}')

for path in [
    '.github/workflows/android-release.yml',
    'scripts/bootstrap_android.sh', 'scripts/bootstrap_android.ps1',
    'scripts/build_android_release.sh', 'scripts/build_android_release.ps1',
    'scripts/verify_android_mobile_layout.py', 'scripts/verify_android_build_pipeline.py',
    'scripts/verify_android_ui_regressions.py',
    'scripts/verify_dart_source_integrity.py', 'scripts/android_doctor.sh', 'scripts/android_doctor.ps1',
]:
    if not (root/path).exists(): fail(f'missing release file {path}')

run(['python3', 'scripts/verify_android_mobile_layout.py'])
run(['python3', 'scripts/verify_android_build_pipeline.py'])
run(['python3', 'scripts/verify_android_ui_regressions.py'])
run(['python3', 'scripts/verify_v5_release.py'])
run(['python3', 'scripts/verify_feminine_intelligence_v6.py'])

lib_text='\n'.join(p.read_text(encoding='utf-8', errors='ignore') for p in (root/'lib').rglob('*.dart'))
for forbidden in ['SUPABASE_SERVICE_ROLE_KEY', 'OPENAI_API_KEY', 'sk-']:
    if forbidden in lib_text: fail(f'Flutter source contains forbidden marker {forbidden}')
if re.search(r'\b(?:Drawer|NavigationDrawer|NavigationRail)\s*\(', lib_text):
    fail('non-mobile navigation regression detected')

print('PASS Malaak Android release readiness verification')
