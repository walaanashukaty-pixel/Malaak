#!/usr/bin/env python3
from pathlib import Path
import re, sys

root = Path(__file__).resolve().parents[1]

def fail(msg):
    print(f'FAIL: {msg}')
    sys.exit(1)

lib = '\n'.join(p.read_text(encoding='utf-8', errors='ignore') for p in (root/'lib').rglob('*.dart'))
for pattern, label in [(r'\bDrawer\s*\(', 'Drawer'), (r'\bNavigationDrawer\s*\(', 'NavigationDrawer'), (r'\bNavigationRail\s*\(', 'NavigationRail')]:
    if re.search(pattern, lib): fail(f'{label} regression detected')

for rel in [
    'lib/screens/home/home_screen.dart',
    'lib/screens/journey/journey_screen.dart',
    'lib/screens/malaak/malaak_screen.dart',
    'lib/screens/profile/profile_screen.dart',
]:
    text=(root/rel).read_text(encoding='utf-8')
    if 'SafeArea(' not in text: fail(f'root mobile screen missing SafeArea: {rel}')

shell=(root/'lib/navigation/app_shell.dart').read_text(encoding='utf-8')
if 'MobileInsets.keyboardOpen(context)' not in shell: fail('shell must remain IME-aware')
if 'keyboardOpen ? null : AppBottomNav' not in shell.replace('\n',' '): fail('bottom nav must remain hidden with IME')

wrong=[]
for p in (root/'test').rglob('*.dart'):
    if 'package:malaak_flutter/' in p.read_text(encoding='utf-8', errors='ignore'):
        wrong.append(str(p.relative_to(root)))
if wrong: fail('wrong Dart package imports: ' + ', '.join(wrong))

release = (root/'scripts/verify_v5_release.py').read_text(encoding='utf-8')
for marker in ['verify_android_mobile_layout.py', 'verify_android_build_pipeline.py', 'verify_android_ui_regressions.py']:
    if marker not in release: fail(f'V5 release gate missing Android verifier {marker}')

test = root/'test/android_mobile_shell_test.dart'
if not test.exists(): fail('android_mobile_shell_test.dart missing')
t=test.read_text(encoding='utf-8')
for marker in ['viewInsets', "find.text('الرئيسية')", 'findsNothing', 'AppShell']:
    if marker not in t: fail(f'Android shell widget test missing {marker}')
print('PASS Android UI regression structure')
