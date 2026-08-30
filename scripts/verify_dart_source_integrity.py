#!/usr/bin/env python3
from pathlib import Path
import re, sys

root = Path(__file__).resolve().parents[1]
files = sorted((root/'lib').rglob('*.dart')) + sorted((root/'test').rglob('*.dart'))


def fail(msg: str) -> None:
    print(f'FAIL: {msg}')
    sys.exit(1)

if not files:
    fail('no Dart source files found')

for path in files:
    rel = path.relative_to(root)
    try:
        text = path.read_text(encoding='utf-8')
    except UnicodeDecodeError:
        fail(f'non-UTF8 Dart source: {rel}')

    for marker in ('<<<<<<<', '=======', '>>>>>>>'):
        if marker in text:
            fail(f'merge-conflict marker {marker} in {rel}')

    if 'package:malaak_flutter/' in text:
        fail(f'legacy package import in {rel}; expected package:malaak_balance/')

    for uri in re.findall(r"(?:import|export|part)\s+'([^']+)'", text):
        if uri.startswith('package:malaak_balance/'):
            target = root/'lib'/uri.removeprefix('package:malaak_balance/')
            if not target.exists():
                fail(f'missing package import target in {rel}: {uri}')
        elif uri.startswith('.'):
            target = (path.parent/uri).resolve()
            if not target.exists():
                fail(f'missing relative import target in {rel}: {uri}')

print(f'PASS Dart source integrity ({len(files)} files)')
