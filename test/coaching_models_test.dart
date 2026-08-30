import 'package:flutter_test/flutter_test.dart';
import 'package:malaak_balance/models/app_state.dart';
import 'package:malaak_balance/models/coaching_follow_up.dart';
import 'package:malaak_balance/models/coaching_turn.dart';

void main() {
  test('V5 coaching turn preserves exact intervention revision through AppStateData round trip', () {
    final followUp = CoachingFollowUp(
      id: 'f1',
      timing: 'later_today',
      prompt: 'شو صار بعد ما جربتي؟',
      journeyDomainId: 'attachment',
      createdAt: DateTime.parse('2026-08-29T12:00:00Z'),
    );
    final turn = CoachingTurn(
      id: 't1',
      createdAt: DateTime.parse('2026-08-29T12:00:00Z'),
      mode: 'coach',
      state: 'moderate_activation',
      need: 'connection',
      pattern: 'attachment_alarm',
      patternConfidence: 'medium',
      goal: 'خفض الخوف قبل طلب الطمأنة',
      interventionCode: 'UNCERTAINTY_001',
      interventionVersion: 7,
      interventionId: '18b4492a-fdf6-4b64-a2de-5b955bb3b4e9',
      action: 'انتظري 15 دقيقة بدون فحص متكرر.',
      followUp: followUp,
    );
    final state = AppStateData(coachingTurns: [turn], pendingFollowUps: [followUp]);

    final decoded = AppStateData.fromJson(state.toJson());
    expect(decoded.coachingTurns.single.interventionCode, 'UNCERTAINTY_001');
    expect(decoded.coachingTurns.single.interventionVersion, 7);
    expect(decoded.coachingTurns.single.interventionId, '18b4492a-fdf6-4b64-a2de-5b955bb3b4e9');
    expect(decoded.coachingTurns.single.action, contains('15 دقيقة'));
    expect(decoded.pendingFollowUps.single.timing, 'later_today');
  });

  test('legacy V4 coaching turn without revision fields remains compatible', () {
    final turn = CoachingTurn.fromJson({
      'id': 'legacy',
      'createdAt': '2026-08-29T12:00:00Z',
      'mode': 'coach',
      'state': 'moderate_activation',
      'need': 'connection',
      'pattern': 'attachment_alarm',
      'patternConfidence': 'medium',
      'goal': 'هدف قديم',
      'interventionCode': 'UNCERTAINTY_001',
      'action': 'خطوة قديمة',
    });
    expect(turn.interventionCode, 'UNCERTAINTY_001');
    expect(turn.interventionVersion, isNull);
    expect(turn.interventionId, isNull);
  });
}
