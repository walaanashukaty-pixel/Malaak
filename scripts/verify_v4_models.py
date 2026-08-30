from pathlib import Path
root = Path(__file__).resolve().parents[1]
follow = root/'lib/models/coaching_follow_up.dart'
turn = root/'lib/models/coaching_turn.dart'
state = root/'lib/models/app_state.dart'
assert follow.exists(), 'coaching_follow_up.dart missing'
assert turn.exists(), 'coaching_turn.dart missing'
text = state.read_text(encoding='utf-8')
for token in ['coachingTurns', 'pendingFollowUps', "'coachingTurns'", "'pendingFollowUps'"]:
    assert token in text, f'app_state missing {token}'
ftext = follow.read_text(encoding='utf-8')
for token in ['journeyDomainId', 'completedAt', 'toJson', 'fromJson']:
    assert token in ftext, f'follow-up model missing {token}'
ttext = turn.read_text(encoding='utf-8')
for token in ['interventionCode', 'patternConfidence', 'followUp', 'toJson', 'fromJson']:
    assert token in ttext, f'coaching turn model missing {token}'
print('PASS V4 coaching model structure')
