from pathlib import Path
import subprocess, sys, re
root=Path(__file__).resolve().parents[1]
checks=['verify_structure.py','verify_v2_structure.py','verify_v3_structure.py','verify_v4_models.py','verify_v4_flutter_flow.py','verify_v4_cloud.py','verify_v5a_schema.py','verify_v5a_seed.py','verify_v5a_coach_integration.py','verify_v5a_flutter_audit.py']
for script in checks:
    r=subprocess.run([sys.executable,str(root/'scripts'/script)],cwd=root,text=True,capture_output=True)
    if r.stdout: print(r.stdout.strip())
    if r.returncode:
        if r.stderr: print(r.stderr,file=sys.stderr)
        raise SystemExit(f'FAIL {script}')
edge=root/'supabase/functions/malaak-ai'
r=subprocess.run(['node','--experimental-strip-types','--test',*map(str,sorted(edge.glob('*_test.ts')))],cwd=root,text=True,capture_output=True)
if r.stdout: print(r.stdout.strip())
if r.returncode:
    if r.stderr: print(r.stderr,file=sys.stderr)
    raise SystemExit('FAIL V5A server tests')
seed=(edge/'catalog_seed.ts').read_text(encoding='utf-8')
codes=set(re.findall(r"code\s*:\s*['\"]([A-Z]+(?:_[A-Z]+)*_[0-9]{3})['\"]",seed))
assert len(codes)==48, f'expected 48 catalog codes, got {len(codes)}'
version_text=(root/'pubspec.yaml').read_text(encoding='utf-8')
m=re.search(r'^version:\s*(\d+)\.(\d+)\.(\d+)\+(\d+)\s*$',version_text,re.M)
assert m, 'pubspec version not parseable'
assert tuple(map(int,m.groups())) >= (0,5,0,5), f'pubspec version regressed below V5A floor: {m.group(0)}'
all_flutter='\n'.join(p.read_text(encoding='utf-8',errors='ignore') for p in (root/'lib').rglob('*.dart'))
for forbidden in ['OPENAI_API_KEY=', 'SUPABASE_SERVICE_ROLE_KEY']:
    assert forbidden not in all_flutter, f'secret-like token found in Flutter source: {forbidden}'
assert 'Drawer(' not in all_flutter and 'NavigationDrawer(' not in all_flutter, 'Drawer/Sidebar regression detected'
for path in [edge/'catalog.ts',edge/'fallback_interventions.ts',edge/'coach.ts']:
    assert path.exists(), f'missing {path.name}'
print('PASS Malaak Flutter Android V5A release verification')
