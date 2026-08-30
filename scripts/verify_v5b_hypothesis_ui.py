from pathlib import Path
import sys

files = {
    'model': Path('lib/models/hypothesis_item.dart'),
    'screen': Path('lib/screens/profile/hypotheses_screen.dart'),
    'privacy': Path('lib/screens/profile/memory_privacy_screen.dart'),
    'controller': Path('lib/state/app_controller.dart'),
    'repo': Path('lib/storage/supabase_app_repository.dart'),
}
failed = []
for name, path in files.items():
    if not path.exists():
        failed.append(f'missing {name}')
if failed:
    print('FAIL:', ', '.join(failed))
    sys.exit(1)

text = {k: p.read_text(encoding='utf-8') for k, p in files.items()}
checks = {
    'explicit correction action': 'هذا مو صحيح' in text['screen'],
    'no evidence mutation ui': 'support_count' not in text['screen'] and 'confidence_label =' not in text['screen'],
    'four user groups': all(label in text['screen'] for label in ['إشارة أولية', 'نمط متكرر', 'أكدتِ إنه بيمثلك', 'رفضتيه']),
    'dedicated reject rpc': "malaak_reject_hypothesis" in text['repo'],
    'controller reject method': 'rejectHypothesis' in text['controller'],
    'privacy links review': 'مراجعة استنتاجات ملاك' in text['privacy'] and 'HypothesesScreen' in text['privacy'],
    'client cannot promote': 'promoteHypothesis' not in text['controller'] and 'updateHypothesisEvidence' not in text['controller'],
}
failed += [name for name, ok in checks.items() if not ok]
if failed:
    print('FAIL:', ', '.join(failed))
    sys.exit(1)
print('PASS: V5B hypothesis review/correction UI structure')
