from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
launcher = ROOT / 'UPLOAD_TO_GITHUB.bat'
workflow = ROOT / '.github' / 'workflows' / 'android-release.yml'

assert launcher.exists(), 'UPLOAD_TO_GITHUB.bat is missing'
text = launcher.read_text(encoding='utf-8')
required = [
    'https://github.com/walaanashukaty-pixel/Malaak.git',
    'git init',
    'git remote',
    'git add -A',
    'git commit',
    'git push -u origin main',
]
for item in required:
    assert item in text, f'missing launcher behavior: {item}'

lower = text.lower()
for forbidden in ['ghp_', 'github_pat_', 'password=', 'token=']:
    assert forbidden not in lower, f'possible embedded credential: {forbidden}'

wf = workflow.read_text(encoding='utf-8')
assert 'branches:' in wf and '- main' in wf, 'workflow must build automatically on pushes to main'
assert 'actions/upload-artifact@v4' in wf, 'workflow must publish build artifacts'
print('PASS: one-click GitHub upload launcher and automatic Android build workflow are configured')
