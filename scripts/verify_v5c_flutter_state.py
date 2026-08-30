from pathlib import Path
root=Path(__file__).resolve().parents[1]
model=root/'lib/models/journey_plan.dart'
assert model.exists(), 'missing JourneyPlan model'
s=model.read_text(encoding='utf-8')
for token in ['class JourneyPlan','primaryDomain','supportDomain','monitorDomains','laterDomains','basedOnFormulationVersion','reviewDueAt','tryFromJson']:
    assert token in s, f'missing JourneyPlan token {token}'
state=(root/'lib/models/app_state.dart').read_text(encoding='utf-8')
assert "import 'journey_plan.dart';" in state
assert 'final JourneyPlan? journeyPlan;' in state
assert "'journeyPlan': journeyPlan?.toJson()" in state
repo=(root/'lib/storage/supabase_app_repository.dart').read_text(encoding='utf-8')
assert '_loadJourneyPlanFromCloud' in repo
assert "from('malaak_journey_plans')" in repo
assert "remove('journeyPlan')" in repo, 'server-managed plan must not be uploaded as client state'
controller=(root/'lib/state/app_controller.dart').read_text(encoding='utf-8')
assert 'state.journeyPlan' in controller or 'journeyPlan' in controller
print('PASS V5C Flutter journey plan state structure')
