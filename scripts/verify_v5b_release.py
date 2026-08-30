from pathlib import Path
import subprocess, sys, re

root = Path(__file__).resolve().parents[1]

checks = [
    'verify_v5a_release.py',
    'verify_v5b_schema.py',
    'verify_v5b_repository_integration.py',
    'verify_v5b_formulation_persistence.py',
    'verify_v5b_onboarding.py',
    'verify_v5b_hypothesis_ui.py',
]
for script in checks:
    result = subprocess.run(
        [sys.executable, str(root / 'scripts' / script)],
        cwd=root,
        text=True,
        capture_output=True,
    )
    if result.stdout:
        print(result.stdout.strip())
    if result.returncode:
        if result.stderr:
            print(result.stderr, file=sys.stderr)
        raise SystemExit(f'FAIL {script}')

edge = root / 'supabase' / 'functions' / 'malaak-ai'
result = subprocess.run(
    ['node', '--experimental-strip-types', '--test', *map(str, sorted(edge.glob('*_test.ts')))],
    cwd=root,
    text=True,
    capture_output=True,
)
if result.stdout:
    print(result.stdout.strip())
if result.returncode:
    if result.stderr:
        print(result.stderr, file=sys.stderr)
    raise SystemExit('FAIL V5B server tests')

pubspec = (root / 'pubspec.yaml').read_text(encoding='utf-8')
m = re.search(r'^version:\s*(\d+)\.(\d+)\.(\d+)\+(\d+)\s*$', pubspec, re.M)
assert m, 'pubspec version not parseable'
assert tuple(map(int, m.groups())) >= (0,5,1,6), f'pubspec version regressed below V5B floor: {m.group(0)}'

migration = (root / 'supabase' / 'migrations' / '20260829_malaak_formulation_v5.sql').read_text(encoding='utf-8')
for table in ['malaak_initial_maps', 'malaak_observations', 'malaak_hypotheses', 'malaak_formulations']:
    assert table in migration, f'missing V5B table {table}'
for rpc in ['malaak_save_initial_map', 'malaak_submit_observation', 'malaak_reject_hypothesis', 'malaak_store_formulation_snapshot']:
    assert rpc in migration, f'missing V5B RPC {rpc}'
assert "grant execute on function public.malaak_store_formulation_snapshot(uuid,jsonb) to service_role" in migration.lower(), 'formulation snapshot RPC must be service-role-only'
assert "grant execute on function public.malaak_store_formulation_snapshot(uuid,jsonb) to authenticated" not in migration.lower(), 'authenticated must not execute formulation snapshot RPC'

index_ts = (edge / 'index.ts').read_text(encoding='utf-8')
for token in ['persistCoachingEvidence', 'jwtPayload.sub']:
    assert token in index_ts, f'missing server-owned V5B evidence flow token: {token}'

flutter = '\n'.join(p.read_text(encoding='utf-8', errors='ignore') for p in (root / 'lib').rglob('*.dart'))
for forbidden in ['OPENAI_API_KEY=', 'SUPABASE_SERVICE_ROLE_KEY', 'Drawer(', 'NavigationDrawer(']:
    assert forbidden not in flutter, f'forbidden Flutter token found: {forbidden}'
for forbidden_mutator in ['setHypothesisConfidence(', 'setHypothesisSupportCount(', 'promoteHypothesis(']:
    assert forbidden_mutator not in flutter, f'client hypothesis mutation API detected: {forbidden_mutator}'

readme = (root / 'README.md').read_text(encoding='utf-8')
build_status = (root / 'BUILD_STATUS.md').read_text(encoding='utf-8')
assert 'V5B' in readme, 'README missing V5B documentation'
assert 'V5B' in build_status, 'BUILD_STATUS missing V5B release marker'
assert 'SECURITY DEFINER' in build_status and 'controlled exception' in build_status.lower(), 'controlled SECURITY DEFINER exception is not documented'

print('PASS Malaak Flutter Android V5B release verification')
