import 'package:flutter_test/flutter_test.dart';
import 'package:malaak_balance/models/app_state.dart';
import 'package:malaak_balance/state/app_controller.dart';
import 'package:malaak_balance/models/coaching_follow_up.dart';
import 'package:malaak_balance/models/coaching_turn.dart';
import 'package:malaak_balance/services/malaak_gateway.dart';
import 'package:malaak_balance/storage/app_repository.dart';

class _MemoryRepository implements AppRepository {
  AppStateData data = AppStateData();
  @override
  Future<AppStateData> load() async => data;
  @override
  Future<void> save(AppStateData state) async => data = state;
}

class _FakeResponder implements MalaakResponder {
  @override
  Future<MalaakGatewayResult> reply(String input, {required AppStateData state}) async {
    final follow = CoachingFollowUp(
      id: 'follow-1',
      timing: 'later_today',
      prompt: 'شو صار بعد الخطوة؟',
      journeyDomainId: 'attachment',
      createdAt: DateTime.parse('2026-08-29T12:00:00Z'),
    );
    return MalaakGatewayResult(
      reply: 'خلينا نجرب خطوة واحدة.',
      turn: CoachingTurn(
        id: 'turn-1',
        createdAt: DateTime.parse('2026-08-29T12:00:00Z'),
        mode: 'coach',
        state: 'moderate_activation',
        need: 'connection',
        pattern: 'attachment_alarm',
        patternConfidence: 'medium',
        goal: 'تنظيم الخوف',
        interventionCode: 'UNCERTAINTY_001',
        action: 'انتظري عشر دقايق.',
        followUp: follow,
      ),
    );
  }
}

void main() {
  test('journal entries persist through repository', () async {
    final repository = _MemoryRepository();
    final controller = AppController(repository);
    await controller.load();
    await controller.addJournal('موقف حقيقي');
    expect(repository.data.journals.single.body, 'موقف حقيقي');
  });

  test('structured Malaak response persists action and pending follow-up', () async {
    final repository = _MemoryRepository();
    final controller = AppController(repository, malaakGateway: _FakeResponder());
    await controller.load();
    await controller.sendToMalaak('ما رد');
    expect(repository.data.messages.last.text, contains('خطوة واحدة'));
    expect(repository.data.coachingTurns.single.interventionCode, 'UNCERTAINTY_001');
    expect(repository.data.pendingFollowUps.single.prompt, contains('شو صار'));

    await controller.completeFollowUp('follow-1');
    expect(repository.data.pendingFollowUps, isEmpty);
    expect(repository.data.coachingTurns.single.followUp?.completedAt, isNotNull);
  });

  test('journey practice increments persisted progress', () async {
    final repository = _MemoryRepository();
    final controller = AppController(repository);
    await controller.load();
    await controller.completePractice('attachment');
    expect(repository.data.journeys['attachment']?.completedPractices, 1);
  });
}
