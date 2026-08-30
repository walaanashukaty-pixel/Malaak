from pathlib import Path

root = Path(__file__).resolve().parents[1]
index = (root / 'supabase/functions/malaak-ai/index.ts').read_text()
coach = (root / 'supabase/functions/malaak-ai/coach.ts').read_text()
router = (root / 'supabase/functions/malaak-ai/router.ts').read_text()
types = (root / 'supabase/functions/malaak-ai/types.ts').read_text()

checks = {
    'index loads catalog': 'loadEligibleInterventions' in index,
    'index derives flags': 'deriveCatalogContextFlags' in index,
    'index passes eligible to coach': 'eligible,' in index or 'eligible: eligible' in index,
    'coach no old hardcoded library import': "from './interventions.ts'" not in coach,
    'router no old hardcoded library import': "from './interventions.ts'" not in router,
    'payload has intervention version': 'interventionVersion: number | null' in types,
    'payload has intervention id': 'interventionId: string | null' in types,
}
failed = [name for name, ok in checks.items() if not ok]
if failed:
    print('FAIL V5A coaching integration:')
    for name in failed:
        print(f'- {name}')
    raise SystemExit(1)
print('PASS V5A coaching integration')
