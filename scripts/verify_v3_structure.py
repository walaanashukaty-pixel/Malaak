from pathlib import Path

root = Path(__file__).resolve().parents[1]
required = [
    'lib/config/supabase_config.dart',
    'lib/auth/auth_gate.dart',
    'lib/auth/auth_screen.dart',
    'lib/storage/supabase_app_repository.dart',
    'supabase/migrations/20260829_malaak_cloud_v3.sql',
    'supabase/functions/malaak-ai/index.ts',
]
for rel in required:
    assert (root / rel).exists(), f'missing {rel}'

pubspec = (root / 'pubspec.yaml').read_text(encoding='utf-8')
assert 'supabase_flutter:' in pubspec, 'supabase_flutter dependency missing'
main = (root / 'lib/main.dart').read_text(encoding='utf-8')
assert 'Supabase.initialize' in main, 'Supabase not initialized'
auth_gate = (root / 'lib/auth/auth_gate.dart').read_text(encoding='utf-8')
assert 'onAuthStateChange' in auth_gate, 'auth state listener missing'
repo = (root / 'lib/storage/supabase_app_repository.dart').read_text(encoding='utf-8')
for token in ['malaak_get_state', 'malaak_sync_state', 'currentUser']:
    assert token in repo, f'repository missing {token}'
gateway = (root / 'lib/services/malaak_gateway.dart').read_text(encoding='utf-8')
assert "'malaak-ai'" in gateway and 'functions.invoke' in gateway, 'Malaak Edge Function invocation missing'
for path in (root / 'lib').rglob('*.dart'):
    text = path.read_text(encoding='utf-8').lower()
    assert 'drawer:' not in text and 'sidebar' not in text, f'forbidden navigation in {path}'
print('V3 structure verified')
