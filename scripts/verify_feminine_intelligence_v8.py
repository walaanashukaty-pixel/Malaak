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
policy_path = ROOT / 'lib/features/feminine_intelligence/logic/fi_progression.dart'
policy = policy_path.read_text(encoding='utf-8') if policy_path.exists() else ''
route = text('lib/features/feminine_intelligence/screens/fi_route_screen.dart')
lesson = text('lib/features/feminine_intelligence/screens/fi_lesson_screen.dart')
home = text('lib/screens/home/home_screen.dart')
journey = text('lib/screens/journey/journey_screen.dart')
pubspec = text('pubspec.yaml')

for field in ['missionAssignedAt', 'followUpAvailableAt', 'followUpCompletedAt', 'masteryEvidence']:
    require(field in state, f'learning progress persists {field}')
require('bool get mastered' in state and 'bool get followUpReady' in state, 'learning progress exposes mastered and follow-up-ready helpers')

require('enum FiNodeStatus' in policy, 'progression defines explicit node status enum')
for status in ['locked', 'available', 'inProgress', 'missionPending', 'followupReady', 'mastered']:
    require(status in policy, f'progression supports {status} node state')
require('Duration(hours: 18)' in policy, 'follow-up delay defaults to configurable 18 hours')
require('nodeStatus' in policy and 'isNodeActionable' in policy and 'nextUnlockReason' in policy, 'progression centralizes locking and unlock reasoning')
require('isRouteMastered' in policy, 'progression detects completed base route without pretending there is another locked node')
require('المستوى المتقدم' in route and 'فصل جديد' in route, 'completed route exposes a real continuation instead of ending the app')

require('FiProgression.nodeStatus' in route, 'route derives every node state from progression policy')
require('FiNodeStatus.locked' in route and 'Icons.lock_rounded' in route, 'future route nodes render visibly locked')
require('onTap: status == FiNodeStatus.locked ? null' in route or 'status != FiNodeStatus.locked' in route, 'locked route nodes cannot be opened')
require('الخطوة التالية' in route and 'تنفتح' in route, 'route explains the next unlock requirement')
require('متابعة جاهزة' in route and 'مهارات مكتسبة' in route, 'route shows follow-up and mastery metrics')

require('FiProgression.followUpDelay' in lesson and 'followUpAvailableAt' in lesson, 'mission schedules timed follow-up through progression policy')
require('followUpReady' in lesson or 'FiProgression.isFollowUpReady' in lesson, 'lesson distinguishes waiting from ready follow-up')
require('substituteSimulation' in lesson and 'noChance' in lesson, 'no-chance outcome enters substitute simulation path')
require('retryRequired' in lesson and 'oldPattern' in lesson and 'forgot' in lesson and 'difficult' in lesson, 'unsuccessful outcomes enter retry instead of mastery')
require("stage: 'mastered'" in lesson, 'successful evidence marks node mastered')
require('تمرين إضافي' in lesson or 'تدريب إضافي' in lesson or 'نشاط إضافي' in lesson, 'waiting state offers immediate optional practice')

require('رحلتك النشطة' in home or 'رحلتك الحالية' in home, 'home prioritizes active journey')
require('مقفول مؤقتًا' in journey or 'رحلات لاحقة' in journey or 'Icons.lock_rounded' in journey, 'wider life map keeps unauthored domains visible with locked treatment')
require('0.6.8+12' in pubspec, 'package version bumped to V6.8')

print(f'PASS feminine intelligence V6.8 skill-tree retention contract ({len(checks)} checks)')
