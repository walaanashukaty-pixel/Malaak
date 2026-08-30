from pathlib import Path
root = Path(__file__).resolve().parents[1]
expected = [
    'lib/state/app_controller.dart',
    'lib/state/app_scope.dart',
    'lib/storage/app_repository.dart',
    'lib/storage/shared_preferences_app_repository.dart',
    'lib/models/app_state.dart',
    'lib/models/journal_entry.dart',
    'lib/models/journey_progress.dart',
    'lib/models/memory_item.dart',
    'lib/models/user_preferences.dart',
    'lib/models/malaak_message.dart',
    'lib/services/malaak_gateway.dart',
]
missing = [p for p in expected if not (root / p).exists()]
assert not missing, f'Missing V2 files: {missing}'
pubspec = (root / 'pubspec.yaml').read_text()
assert 'shared_preferences:' in pubspec, 'shared_preferences dependency missing'
all_dart = '\n'.join(p.read_text(errors='ignore') for p in (root/'lib').rglob('*.dart'))
assert 'Drawer(' not in all_dart and 'Sidebar' not in all_dart, 'Sidebar/Drawer regression detected'
assert 'AppScope' in all_dart and 'AppController' in all_dart, 'state layer not wired'
print('V2 structure verified')

gateway=(root/'lib/services/malaak_gateway.dart').read_text()
assert (('MALAAK_AI_ENDPOINT' in gateway and 'HttpClient' in gateway) or ('functions.invoke' in gateway and "'malaak-ai'" in gateway)), 'AI gateway contract missing'
