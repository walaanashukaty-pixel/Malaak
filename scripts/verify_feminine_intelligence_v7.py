from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]

def text(path):
    return (ROOT / path).read_text(encoding='utf-8')

checks = []

def require(cond, message):
    if not cond:
        raise AssertionError(message)
    checks.append(message)

state = text('lib/models/learning_journey_state.dart')
models = text('lib/features/feminine_intelligence/models/fi_models.dart')
catalog = text('lib/features/feminine_intelligence/data/fi_catalog.dart')
scorer = text('lib/features/feminine_intelligence/logic/fi_scorer.dart')
assessment = text('lib/features/feminine_intelligence/screens/fi_assessment_screen.dart')
main = text('lib/features/feminine_intelligence/screens/feminine_intelligence_screen.dart')
lesson = text('lib/features/feminine_intelligence/screens/fi_lesson_screen.dart')
route = text('lib/features/feminine_intelligence/screens/fi_route_screen.dart')
result_path = ROOT / 'lib/features/feminine_intelligence/screens/fi_assessment_result_screen.dart'
result = result_path.read_text(encoding='utf-8') if result_path.exists() else ''

require('recommendedRouteId' in state, 'learning state stores Malaak recommendation separately')
require('LearningLessonProgress' in state and 'lessonProgress' in state, 'learning state persists per-lesson practice/application progress')
require("'masculine-intelligence'" in catalog and "'feminine-intelligence-advanced'" in catalog, 'catalog contains working masculine and feminine intelligence routes')
require('FiModelDescriptor' in models and 'coachReply' in models and 'FiScenarioOption' in models, 'models support four model cards and conversational feedback/scenarios')
require('recommendRoute' in scorer and "'advanced'" not in scorer, 'scorer recommends one of four routes and has no terminal advanced state')
require('FiAssessmentResultScreen' in result and 'recommendedRouteId' in result, 'assessment result screen shows recommendation and route choice')
require('_goNext' in assessment and '_goPrevious' in assessment, 'assessment has explicit next and previous controls')
choose_block = assessment.split('void _choose', 1)[1].split('Future<void> _savePartial', 1)[0] if 'void _choose' in assessment else ''
require(bool(choose_block) and '_index += 1' not in choose_block, 'choosing an answer does not auto-advance')
require('Icons.arrow_back_rounded' in assessment or 'السابق' in assessment, 'assessment exposes previous navigation')
require('التالي' in assessment, 'assessment exposes next navigation')
require('ملاك' in assessment and 'chat' in assessment.lower() or '_CoachBubble' in assessment, 'assessment renders as a Malaak conversation')
require('ما بتحتاجي' not in main and "routeId == 'advanced'" not in main, 'main screen no longer says the user needs no route')
require('missionPending' in lesson and 'realLifeApplications' in lesson and 'كيف مشي' in lesson, 'lesson requires real-life mission and follow-up')
require('_sessionStep' in lesson and '_Scenario' in lesson, 'lesson is a multi-step interactive training session')
require('تطبيقات حقيقية' in route and 'جلسات تدريب' in route, 'route progress distinguishes practice from real-life application')
require('أنجزت التدريب' not in lesson, 'lesson has no one-click completion button')

print(f'PASS feminine intelligence V6.7 conversational training contract ({len(checks)} checks)')
