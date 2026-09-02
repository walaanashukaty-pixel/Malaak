from pathlib import Path
import re

ROOT = Path(__file__).resolve().parents[1]

def text(rel):
    p = ROOT / rel
    assert p.exists(), f'missing {rel}'
    return p.read_text(encoding='utf-8')

model = text('lib/models/learning_journey_state.dart')
app_state = text('lib/models/app_state.dart')
controller = text('lib/state/app_controller.dart')
repo = text('lib/storage/supabase_app_repository.dart')
migration = text('supabase/migrations/20260902_malaak_learning_states_v6.sql')
models = text('lib/features/feminine_intelligence/models/fi_models.dart')
catalog = text('lib/features/feminine_intelligence/data/fi_catalog.dart')
scorer = text('lib/features/feminine_intelligence/logic/fi_scorer.dart')
home = text('lib/features/feminine_intelligence/screens/feminine_intelligence_screen.dart')
assessment = text('lib/features/feminine_intelligence/screens/fi_assessment_screen.dart')
route = text('lib/features/feminine_intelligence/screens/fi_route_screen.dart')
lesson = text('lib/features/feminine_intelligence/screens/fi_lesson_screen.dart')
lab = text('lib/features/feminine_intelligence/screens/fi_situation_lab_screen.dart')
domain = text('lib/screens/journey/domain_detail_screen.dart')

# State + persistence contract
for token in ['domainId', 'routeId', 'assessmentCompleted', 'scores', 'answers', 'completedLessonIds', 'notes', 'updatedAt']:
    assert token in model, f'learning state missing {token}'
assert 'learningJourneys' in app_state, 'AppStateData does not persist learning journeys'
assert 'saveLearningJourneyState' in controller, 'controller save API missing'
assert 'malaak_learning_states' in repo, 'Supabase repository does not sync learning states'
assert repo.count('remote = remote.copyWith(learningJourneys: learningJourneys)') >= 2, 'cloud load and manual sync must both restore learning journeys'
assert 'create table if not exists public.malaak_learning_states' in migration.lower(), 'learning table migration missing'
assert 'enable row level security' in migration.lower(), 'learning table RLS missing'

# Assessment/scoring contract
for dim in ['peoplePleasing', 'controlRigidity', 'practicalIntelligence', 'relationalWisdom']:
    assert dim in models or dim in catalog or dim in scorer, f'missing assessment dimension {dim}'
assert 'feminine-naivety' in scorer, 'naivety route missing in scorer'
assert 'masculine-rigidity' in scorer, 'rigidity route missing in scorer'
assert ('advanced' in scorer) or ('masculine-intelligence' in scorer and 'feminine-intelligence-advanced' in scorer), 'advanced/four-route recommendation missing in scorer'
question_ids = set(re.findall(r"id:\s*'assessment-[^']+'", catalog))
assert len(question_ids) >= 12, f'need at least 12 assessment scenarios, found {len(question_ids)}'

# Approved route depth
naivety_lessons = set(re.findall(r"id:\s*'naivety-[^']+'", catalog))
rigidity_lessons = set(re.findall(r"id:\s*'rigidity-[^']+'", catalog))
assert len(naivety_lessons) >= 7, f'need 7 naivety lessons, found {len(naivety_lessons)}'
assert len(rigidity_lessons) >= 9, f'need 9 rigidity lessons, found {len(rigidity_lessons)}'

# UI routing + language guardrails
assert "domain.id == 'feminine-intelligence'" in domain, 'journey detail does not delegate feminine-intelligence feature'
assert 'FeminineIntelligenceScreen' in domain, 'feature screen integration missing'
assert 'نقطة بدايتك' in home or 'نقطة البداية' in home or 'خريطتك الحالية' in home, 'non-diagnostic start copy missing'
assert 'اختبار' in assessment or 'خريطة' in assessment or 'جلسة' in assessment, 'assessment UI missing'
assert 'FiRouteScreen' in home or 'FiRouteScreen' in route, 'route screen not wired'
assert 'completedLessonIds' in lesson, 'lesson completion is not persisted'

# Situation lab: six structured prompts; no dependency on MalaakGateway/OpenAI in this trial flow.
for phrase in ['شو صار', 'شو حاسة', 'الوقت', 'الطرف الآخر', 'نيتك', 'التصرف']:
    assert phrase in lab, f'situation lab missing structured prompt: {phrase}'
assert 'MalaakGateway' not in lab and 'OpenAI' not in lab, 'trial situation lab should be deterministic and structured'

print('PASS feminine intelligence V6.6 source, routing, persistence and UX contract')
