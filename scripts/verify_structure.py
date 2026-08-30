from pathlib import Path
import re
import sys

root = Path(__file__).resolve().parents[1]
required = [
    'pubspec.yaml',
    'analysis_options.yaml',
    'lib/main.dart',
    'lib/core/theme/app_colors.dart',
    'lib/core/theme/app_theme.dart',
    'lib/data/app_catalog.dart',
    'lib/navigation/app_shell.dart',
    'lib/widgets/app_bottom_nav.dart',
    'lib/screens/home/home_screen.dart',
    'lib/screens/malaak/malaak_screen.dart',
    'lib/screens/journey/journey_screen.dart',
    'lib/screens/journey/domain_detail_screen.dart',
    'lib/screens/profile/profile_screen.dart',
    'lib/screens/journal/journal_screen.dart',
    'lib/screens/reports/reports_screen.dart',
    'lib/screens/tools/tools_screen.dart',
    'lib/screens/tools/tool_detail_screen.dart',
    'lib/services/demo_malaak_service.dart',
    'test/catalog_test.dart',
    'test/app_shell_test.dart',
    'test/demo_malaak_service_test.dart',
]

errors = []
missing = [p for p in required if not (root / p).exists()]
if missing:
    errors.extend(f'missing {p}' for p in missing)

lib_text = '\n'.join(p.read_text(encoding='utf-8') for p in (root / 'lib').rglob('*.dart')) if (root / 'lib').exists() else ''

for forbidden in ['Drawer(', 'Scaffold.drawer', 'Sidebar', 'sidebar']:
    if forbidden in lib_text:
        errors.append(f'forbidden navigation token present: {forbidden}')

nav = (root / 'lib/widgets/app_bottom_nav.dart').read_text(encoding='utf-8') if (root / 'lib/widgets/app_bottom_nav.dart').exists() else ''
for label in ['الرئيسية', 'ملاك', 'رحلتي', 'أنا']:
    if label not in nav:
        errors.append(f'bottom navigation missing label {label}')
if nav.count("Icons.") < 4:
    errors.append('bottom navigation appears to have fewer than four icons')

catalog = (root / 'lib/data/app_catalog.dart').read_text(encoding='utf-8') if (root / 'lib/data/app_catalog.dart').exists() else ''
journey_count = catalog.count('JourneyDomain(')
quick_count = catalog.count('QuickTool(')
if journey_count != 11:
    errors.append(f'expected 11 journeys, found {journey_count}')
if quick_count != 9:
    errors.append(f'expected 9 quick tools, found {quick_count}')

for hex_color in ['FFFDF8', '3D2B4A', 'B8A8FF', 'F6B5C8', 'BFD8C1', 'D4AF37']:
    if hex_color not in lib_text:
        errors.append(f'approved Figma color missing: {hex_color}')

home = (root / 'lib/screens/home/home_screen.dart').read_text(encoding='utf-8') if (root / 'lib/screens/home/home_screen.dart').exists() else ''
for module in ['كيف حالك من الداخل اليوم؟', 'أحتاج ملاك الآن', 'رحلتك الحالية', 'تركيزي الحالي', 'متابعة مفتوحة', 'ملاحظة من ملاك', 'أدوات سريعة']:
    if module not in home:
        errors.append(f'home control-center module missing: {module}')

service = (root / 'lib/services/demo_malaak_service.dart').read_text(encoding='utf-8') if (root / 'lib/services/demo_malaak_service.dart').exists() else ''
for phrase in ['الأمان', 'الشدة', 'ما بقدر أعرف', 'الحقائق']:
    if phrase not in service:
        errors.append(f'demo Malaak safety/uncertainty phrase missing: {phrase}')

# Gross Dart delimiter check after removing comments and quoted strings.
def scrub(text: str) -> str:
    text = re.sub(r'/\*.*?\*/', '', text, flags=re.S)
    text = re.sub(r'//.*', '', text)
    text = re.sub(r"'''(?:.|\n)*?'''", "", text)
    text = re.sub(r'"""(?:.|\n)*?"""', '', text)
    text = re.sub(r"'(?:\\.|[^'\\])*'", "''", text)
    text = re.sub(r'"(?:\\.|[^"\\])*"', '""', text)
    return text

pairs = {')': '(', ']': '[', '}': '{'}
for path in (root / 'lib').rglob('*.dart'):
    stack = []
    for ch in scrub(path.read_text(encoding='utf-8')):
        if ch in '([{':
            stack.append(ch)
        elif ch in pairs:
            if not stack or stack.pop() != pairs[ch]:
                errors.append(f'unbalanced delimiter in {path.relative_to(root)}')
                break
    else:
        if stack:
            errors.append(f'unclosed delimiter in {path.relative_to(root)}')

if errors:
    print('FAIL')
    for error in errors:
        print(' -', error)
    sys.exit(1)

print('PASS Malaak Flutter V1 structural verification')
print(f' - {journey_count} journey domains')
print(f' - {quick_count} quick tools')
print(' - 4-item mobile bottom navigation')
print(' - no Drawer/Sidebar tokens')
print(' - approved Figma palette present')
print(' - required Home control-center modules present')
print(' - Dart delimiters structurally balanced')
