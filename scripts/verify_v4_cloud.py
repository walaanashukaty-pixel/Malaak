from pathlib import Path
root=Path(__file__).resolve().parents[1]
migration=root/'supabase/migrations/20260829_malaak_coaching_v4.sql'
assert migration.exists(), 'V4 coaching migration missing'
sql=migration.read_text(encoding='utf-8')
for token in [
    'malaak_coaching_turns', 'malaak_followups', 'enable row level security',
    "'coachingTurns'", "'pendingFollowUps'", 'malaak_get_state', 'malaak_sync_state',
    '(select auth.uid())',
]:
    assert token in sql, f'migration missing {token}'
repo=(root/'lib/storage/supabase_app_repository.dart').read_text(encoding='utf-8')
assert 'state.coachingTurns.isNotEmpty' in repo, 'cloud repository meaningful-data check missing coaching turns'
assert 'state.pendingFollowUps.isNotEmpty' in repo, 'cloud repository meaningful-data check missing follow-ups'
print('PASS V4 cloud structure')
