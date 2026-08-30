from pathlib import Path
root=Path(__file__).resolve().parents[1]
gateway=(root/'lib/services/malaak_gateway.dart').read_text(encoding='utf-8')
for token in ['MalaakGatewayResult', 'CoachingTurn', 'fromResponseData']:
    assert token in gateway, f'gateway missing {token}'
controller=(root/'lib/state/app_controller.dart').read_text(encoding='utf-8')
for token in ['pendingFollowUps', 'coachingTurns', 'completeFollowUp']:
    assert token in controller, f'controller missing {token}'
home=(root/'lib/screens/home/home_screen.dart').read_text(encoding='utf-8')
assert 'pendingFollowUps' in home, 'home still uses mock follow-up'
malaak=(root/'lib/screens/malaak/malaak_screen.dart').read_text(encoding='utf-8')
for token in ['خطوتك الآن', 'interventionCode']:
    assert token in malaak, f'Malaak screen missing {token}'
print('PASS V4 Flutter flow structure')
