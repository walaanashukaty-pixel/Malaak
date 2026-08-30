from pathlib import Path
import subprocess
import sys
import re

root = Path(__file__).resolve().parents[1]

python_checks = [
    'verify_structure.py',
    'verify_v2_structure.py',
    'verify_v3_structure.py',
    'verify_v4_models.py',
    'verify_v4_flutter_flow.py',
    'verify_v4_cloud.py',
]

for script in python_checks:
    result = subprocess.run(
        [sys.executable, str(root / 'scripts' / script)],
        cwd=root,
        text=True,
        capture_output=True,
    )
    if result.stdout:
        print(result.stdout.strip())
    if result.returncode != 0:
        if result.stderr:
            print(result.stderr, file=sys.stderr)
        raise SystemExit(f'FAIL {script}')

interventions = (root / 'supabase/functions/malaak-ai/interventions.ts').read_text(encoding='utf-8')
required_codes = [
    'REG_GROUND_001',
    'REG_MOVE_002',
    'ANGER_TIMEOUT_001',
    'THOUGHT_FACTS_001',
    'RUMINATION_EXIT_001',
    'UNCERTAINTY_001',
    'NEED_NAME_001',
    'REQUEST_DIRECT_001',
    'BOUNDARY_001',
    'PROBLEM_SOLVE_001',
]
for code in required_codes:
    matches = re.findall(rf"\bcode\s*:\s*['\"]{re.escape(code)}['\"]", interventions)
    assert len(matches) == 1, f'intervention {code} missing or duplicated'

edge_dir = root / 'supabase/functions/malaak-ai'
node = subprocess.run(
    [
        'node',
        '--experimental-strip-types',
        '--test',
        str(edge_dir / 'router_test.ts'),
        str(edge_dir / 'coach_test.ts'),
    ],
    cwd=root,
    text=True,
    capture_output=True,
)
if node.stdout:
    print(node.stdout.strip())
if node.returncode != 0:
    if node.stderr:
        print(node.stderr, file=sys.stderr)
    raise SystemExit('FAIL V4 server tests')

pubspec = (root / 'pubspec.yaml').read_text(encoding='utf-8')
assert 'version: 0.4.0+4' in pubspec, 'pubspec version is not 0.4.0+4'

source = '\n'.join(p.read_text(encoding='utf-8', errors='ignore') for p in (root / 'lib').rglob('*.dart'))
for forbidden in ['OPENAI_API_KEY=', 'SUPABASE_SERVICE_ROLE_KEY']:
    assert forbidden not in source, f'secret-like token found in Flutter source: {forbidden}'

print('PASS Malaak Flutter Android V4 release verification')
