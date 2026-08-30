from pathlib import Path

root = Path(__file__).resolve().parents[1]
model = (root/'lib/models/coaching_turn.dart').read_text()
gateway = (root/'lib/services/malaak_gateway.dart').read_text()
migration = (root/'supabase/migrations/20260829_malaak_intervention_catalog_v5.sql').read_text()
tests = (root/'test/coaching_models_test.dart').read_text() + (root/'test/malaak_gateway_payload_test.dart').read_text()

checks = {
    'model field interventionVersion': 'interventionVersion' in model,
    'model field interventionId': 'interventionId' in model,
    'model json version': "'interventionVersion'" in model,
    'model json id': "'interventionId'" in model,
    'gateway context keeps revision': "'interventionVersion': turn.interventionVersion" in gateway and "'interventionId': turn.interventionId" in gateway,
    'cloud get exposes version': "'interventionVersion', ct.intervention_version" in migration,
    'cloud get exposes id': "'interventionId', ct.intervention_id" in migration,
    'cloud sync accepts version': "nullif(e->>'interventionVersion', '')::integer" in migration,
    'cloud sync accepts id': "nullif(e->>'interventionId', '')::uuid" in migration,
    'tests cover V4 legacy': 'legacy V4 coaching turn' in tests,
}
failed=[name for name, ok in checks.items() if not ok]
if failed:
    print('FAIL V5A Flutter audit persistence:')
    for name in failed: print('-', name)
    raise SystemExit(1)
print('PASS V5A Flutter audit persistence')
