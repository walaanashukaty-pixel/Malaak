import 'package:supabase_flutter/supabase_flutter.dart';

import '../models/app_state.dart';
import '../models/coaching_turn.dart';
import '../models/memory_item.dart';
import 'demo_malaak_service.dart';

class MalaakGatewayResult {
  const MalaakGatewayResult({required this.reply, this.turn});

  final String reply;
  final CoachingTurn? turn;

  factory MalaakGatewayResult.fromResponseData(dynamic data) {
    if (data is! Map) {
      return const MalaakGatewayResult(reply: '');
    }
    final map = Map<String, dynamic>.from(data);
    final reply = (map['reply'] as String?)?.trim() ?? '';
    final rawTurn = map['turn'];
    CoachingTurn? turn;
    if (rawTurn is Map) {
      try {
        turn = CoachingTurn.fromJson(Map<String, dynamic>.from(rawTurn));
      } catch (_) {
        turn = null;
      }
    }
    return MalaakGatewayResult(reply: reply, turn: turn);
  }
}

abstract class MalaakResponder {
  Future<MalaakGatewayResult> reply(String input, {required AppStateData state});
}

class MalaakGateway implements MalaakResponder {
  MalaakGateway(this.client);

  final SupabaseClient client;

  @override
  Future<MalaakGatewayResult> reply(String input, {required AppStateData state}) async {
    if (client.auth.currentUser == null) {
      return MalaakGatewayResult(reply: DemoMalaakService.reply(input));
    }

    try {
      final response = await client.functions.invoke(
        'malaak-ai',
        body: {
          'message': input,
          'context': _buildAllowedContext(state),
        },
      );
      final parsed = MalaakGatewayResult.fromResponseData(response.data);
      if (parsed.reply.isNotEmpty) return parsed;
      return MalaakGatewayResult(reply: DemoMalaakService.reply(input));
    } catch (_) {
      return MalaakGatewayResult(reply: DemoMalaakService.reply(input));
    }
  }

  Map<String, dynamic> _buildAllowedContext(AppStateData state) {
    final preferences = state.preferences;
    final memories = state.memories.where((item) {
      if (preferences.allowPatterns) return true;
      return item.type != MemoryType.pattern && item.type != MemoryType.hypothesis;
    }).take(20);

    final context = <String, dynamic>{
      'displayName': preferences.displayName,
      'journeys': state.journeys.map(
        (key, value) => MapEntry(key, {
          'status': value.status,
          'completedPractices': value.completedPractices,
        }),
      ),
      'memories': memories
          .map((item) => {
                'type': item.type.name,
                'value': item.value,
                'confidence': item.confidence,
              })
          .toList(),
      'recentMessages': state.messages
          .skip(state.messages.length > 8 ? state.messages.length - 8 : 0)
          .map((message) => {
                'role': message.isUser ? 'user' : 'assistant',
                'text': message.text,
              })
          .toList(),
      'recentCoaching': state.coachingTurns
          .skip(state.coachingTurns.length > 4 ? state.coachingTurns.length - 4 : 0)
          .map((turn) => {
                'state': turn.state,
                'need': turn.need,
                'pattern': turn.pattern,
                'patternConfidence': turn.patternConfidence,
                'interventionCode': turn.interventionCode,
                'interventionVersion': turn.interventionVersion,
                'interventionId': turn.interventionId,
                'action': turn.action,
              })
          .toList(),
    };

    if (preferences.allowJournalAnalysis) {
      context['journals'] = state.journals
          .where((entry) => entry.includeInReports)
          .take(3)
          .map((entry) => {
                'createdAt': entry.createdAt.toIso8601String(),
                'text': entry.body.length > 600 ? entry.body.substring(0, 600) : entry.body,
              })
          .toList();
    }

    return context;
  }
}
