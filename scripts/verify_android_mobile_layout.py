#!/usr/bin/env python3
from pathlib import Path
import sys

root = Path(__file__).resolve().parents[1]

def fail(msg):
    print(f'FAIL: {msg}')
    sys.exit(1)

layout = root/'lib/core/layout/mobile_insets.dart'
shell = (root/'lib/navigation/app_shell.dart').read_text(encoding='utf-8')
chat = (root/'lib/screens/malaak/malaak_screen.dart').read_text(encoding='utf-8')

if not layout.exists(): fail('mobile_insets.dart missing')
text = layout.read_text(encoding='utf-8')
for marker in ['class MobileInsets', 'MediaQuery.viewInsetsOf', 'MediaQuery.viewPaddingOf', 'composerBottomPadding']:
    if marker not in text: fail(f'mobile inset helper missing {marker}')
if "mobile_insets.dart" not in shell: fail('AppShell must import mobile_insets.dart')
if 'resizeToAvoidBottomInset: true' not in shell: fail('AppShell must explicitly resize for IME')
if 'MobileInsets.keyboardOpen(context)' not in shell: fail('AppShell must detect keyboard state')
if 'keyboardOpen ? null : AppBottomNav' not in shell.replace('\n',' '): fail('bottom nav must hide while keyboard is open')
if "mobile_insets.dart" not in chat: fail('MalaakScreen must import mobile_insets.dart')
if 'MobileInsets.composerBottomPadding(context)' not in chat: fail('chat composer must use keyboard-aware bottom padding')
if 'MediaQuery.paddingOf(context).bottom + 90' in chat: fail('hard-coded chat bottom reserve regression')
print('PASS Android mobile keyboard/safe-area structure')
