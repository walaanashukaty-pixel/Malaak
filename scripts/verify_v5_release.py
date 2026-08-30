#!/usr/bin/env python3
from pathlib import Path
import subprocess, sys, re

root = Path(__file__).resolve().parents[1]
edge = root / 'supabase/functions/malaak-ai'


def fail(msg: str):
    print(f'FAIL: {msg}')
    sys.exit(1)


def run(cmd):
    print('+', ' '.join(map(str, cmd)))
    result = subprocess.run(cmd, cwd=root, text=True)
    if result.returncode != 0:
        fail(f'command failed ({result.returncode}): {cmd}')

pubspec = (root / 'pubspec.yaml').read_text(encoding='utf-8')
version_match = re.search(r'^version:\s*(\d+)\.(\d+)\.(\d+)\+(\d+)\s*$', pubspec, re.MULTILINE)
if not version_match:
    fail('pubspec version missing or invalid')
version_tuple = tuple(map(int, version_match.groups()))
if version_tuple < (0, 5, 2, 7):
    fail('pubspec must be V5 final or newer')

readme = (root / 'README.md').read_text(encoding='utf-8')
build = (root / 'BUILD_STATUS.md').read_text(encoding='utf-8')
for marker in ['Malaak V5C', 'Primary', 'Support', 'Monitor', 'Later', '68/68']:
    if marker not in readme:
        fail(f'README missing V5C marker: {marker}')
for marker in ['68/68', 'malaak_journey_plans']:
    if marker not in build:
        fail(f'BUILD_STATUS missing retained V5 marker: {marker}')
if not re.search(r'Malaak Flutter Android V(?:5|[6-9](?:\.\d+)?)\s+Source|Malaak Flutter Android V5', build):
    fail('BUILD_STATUS must identify V5 final or newer Android source')

# Run every structural gate once; the full Node suite is executed once below.
for script in [
    'verify_structure.py',
    'verify_v2_structure.py',
    'verify_v3_structure.py',
    'verify_v4_models.py',
    'verify_v4_flutter_flow.py',
    'verify_v4_cloud.py',
    'verify_v5a_schema.py',
    'verify_v5a_seed.py',
    'verify_v5a_coach_integration.py',
    'verify_v5a_flutter_audit.py',
    'verify_v5b_schema.py',
    'verify_v5b_repository_integration.py',
    'verify_v5b_formulation_persistence.py',
    'verify_v5b_onboarding.py',
    'verify_v5b_hypothesis_ui.py',
    'verify_v5c_schema.py',
    'verify_v5c_flutter_state.py',
    'verify_v5c_ui.py',
    'verify_android_mobile_layout.py',
    'verify_android_build_pipeline.py',
    'verify_android_ui_regressions.py',
    'verify_dart_source_integrity.py',
]:
    run(['python3', f'scripts/{script}'])
run(['node', '--experimental-strip-types', '--test', *map(str, sorted(edge.glob('*_test.ts')))])
run(['node', 'scripts/build_malaak_edge_deploy_bundle.mjs'])

# Smoke the generated deployment loader with a Deno.serve stub.
smoke = root / 'build/malaak-edge-deploy/index.ts'
smoke_mjs = root / 'build/malaak-edge-deploy/index.mjs'
smoke_mjs.write_text(smoke.read_text(encoding='utf-8'), encoding='utf-8')
run(['node', '-e', "globalThis.Deno={env:{get:()=>''},serve:(fn)=>{globalThis.h=fn}}; import('./build/malaak-edge-deploy/index.mjs').then(()=>{if(typeof globalThis.h!=='function')process.exit(2);console.log('edge deployment loader smoke PASS')})"])

# Release hygiene: no server secret or direct OpenAI key literal in Flutter source.
lib_text = '\n'.join(p.read_text(encoding='utf-8', errors='ignore') for p in (root/'lib').rglob('*.dart'))
for secret_marker in ['SUPABASE_SERVICE_ROLE_KEY', 'OPENAI_API_KEY', 'sk-']:
    if secret_marker in lib_text:
        fail(f'Flutter source contains forbidden secret marker: {secret_marker}')
if re.search(r'\bDrawer\s*\(|\bNavigationDrawer\s*\(', lib_text):
    fail('Sidebar/Drawer regression detected in Flutter source')

print('PASS Malaak complete V5 release verification')
