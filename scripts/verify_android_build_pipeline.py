#!/usr/bin/env python3
from pathlib import Path
import sys

root = Path(__file__).resolve().parents[1]

def fail(msg):
    print(f'FAIL: {msg}')
    sys.exit(1)

def read(path):
    p = root/path
    if not p.exists(): fail(f'missing {path}')
    return p.read_text(encoding='utf-8')

sh = read(Path('scripts/bootstrap_android.sh'))
ps = read(Path('scripts/bootstrap_android.ps1'))
for name, text in [('sh', sh), ('ps1', ps)]:
    for marker in ['--org com.malaak', '--project-name malaak_balance', 'ملاك']:
        if marker not in text: fail(f'{name} bootstrap missing {marker}')
    if 'com.malaak.malaak_balance' not in text:
        fail(f'{name} bootstrap must verify package id com.malaak.malaak_balance')

release_sh = read(Path('scripts/build_android_release.sh'))
release_ps = read(Path('scripts/build_android_release.ps1'))
for name, text in [('release sh', release_sh), ('release ps1', release_ps)]:
    for marker in ['flutter pub get', 'flutter analyze', 'flutter test', 'flutter build apk --release', 'flutter build appbundle --release']:
        if marker not in text: fail(f'{name} missing {marker}')

workflow = read(Path('.github/workflows/android-release.yml'))
for marker in ['subosito/flutter-action', "flutter-version: '3.47.1'", 'channel: stable', 'scripts/build_android_release.sh', 'app-release.apk', 'app-release.aab', 'actions/upload-artifact']:
    if marker not in workflow: fail(f'workflow missing {marker}')

for required in ['scripts/android_doctor.ps1', 'scripts/android_doctor.sh', 'scripts/verify_dart_source_integrity.py']:
    if not (root/required).exists(): fail(f'missing {required}')
doctor_ps = read(Path('scripts/android_doctor.ps1'))
doctor_sh = read(Path('scripts/android_doctor.sh'))
for name, text in [('doctor ps1', doctor_ps), ('doctor sh', doctor_sh)]:
    for marker in ['flutter --version', 'flutter doctor -v', 'flutter devices', '3.47.1']:
        if marker not in text: fail(f'{name} missing {marker}')

for forbidden in ['OPENAI_API_KEY:', 'SUPABASE_SERVICE_ROLE_KEY:', 'sk-']:
    if forbidden in workflow: fail(f'workflow contains forbidden secret marker {forbidden}')
print('PASS Android build pipeline structure')
