from pathlib import Path
import sys
files={
 'model':Path('lib/models/initial_map.dart'),
 'flow':Path('lib/screens/onboarding/initial_map_flow.dart'),
 'result':Path('lib/screens/onboarding/initial_map_result_screen.dart'),
 'gate':Path('lib/auth/auth_gate.dart'),
 'state':Path('lib/models/app_state.dart'),
 'controller':Path('lib/state/app_controller.dart'),
 'cloud':Path('lib/storage/supabase_app_repository.dart'),
}
failed=[]
for name,path in files.items():
    if not path.exists(): failed.append(f'missing {name}')
if failed:
    print('FAIL:',', '.join(failed)); sys.exit(1)
text={k:p.read_text(encoding='utf-8') for k,p in files.items()}
checks={
 'six-step flow': 'static const int totalSteps = 6' in text['flow'],
 'initial-map wording':'خريطتك الأولية' in text['result'],
 'uncertainty wording':'مو تشخيص' in text['result'] or 'ليست تشخيص' in text['result'],
 'no fake percentages':'%' not in text['flow'] and '%' not in text['result'],
 'gate uses initial map':'initialMap' in text['gate'] and 'InitialMapFlow' in text['gate'],
 'state persists initial map':"'initialMap'" in text['state'] and 'InitialMap?' in text['state'],
 'controller saves map':'saveInitialMap' in text['controller'],
 'cloud uses dedicated rpc':"malaak_save_initial_map" in text['cloud'],
 'cloud loads map':'malaak_initial_maps' in text['cloud'],
 'privacy choice':'patternAnalysis' in text['flow'],
 'safety question':'الأمان' in text['flow'],
 'high-impact step-up':'دعم بشري' in text['result'] and "currentImpact == 'high'" in text['result'],
}
failed += [name for name,ok in checks.items() if not ok]
if failed:
    print('FAIL:',', '.join(failed)); sys.exit(1)
print('PASS: V5B progressive onboarding structure')
