import 'coaching_follow_up.dart';

class CoachingTurn {
  CoachingTurn({
    required this.id,
    required this.createdAt,
    required this.mode,
    required this.state,
    required this.need,
    required this.pattern,
    required this.patternConfidence,
    required this.goal,
    required this.action,
    this.interventionCode,
    this.interventionVersion,
    this.interventionId,
    this.followUp,
  });

  final String id;
  final DateTime createdAt;
  final String mode;
  final String state;
  final String need;
  final String pattern;
  final String patternConfidence;
  final String goal;
  final String? interventionCode;
  final int? interventionVersion;
  final String? interventionId;
  final String action;
  final CoachingFollowUp? followUp;

  CoachingTurn copyWith({
    String? id,
    DateTime? createdAt,
    String? mode,
    String? state,
    String? need,
    String? pattern,
    String? patternConfidence,
    String? goal,
    String? interventionCode,
    bool clearInterventionCode = false,
    int? interventionVersion,
    bool clearInterventionVersion = false,
    String? interventionId,
    bool clearInterventionId = false,
    String? action,
    CoachingFollowUp? followUp,
    bool clearFollowUp = false,
  }) {
    return CoachingTurn(
      id: id ?? this.id,
      createdAt: createdAt ?? this.createdAt,
      mode: mode ?? this.mode,
      state: state ?? this.state,
      need: need ?? this.need,
      pattern: pattern ?? this.pattern,
      patternConfidence: patternConfidence ?? this.patternConfidence,
      goal: goal ?? this.goal,
      interventionCode: clearInterventionCode ? null : (interventionCode ?? this.interventionCode),
      interventionVersion: clearInterventionVersion
          ? null
          : (interventionVersion ?? this.interventionVersion),
      interventionId: clearInterventionId ? null : (interventionId ?? this.interventionId),
      action: action ?? this.action,
      followUp: clearFollowUp ? null : (followUp ?? this.followUp),
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'createdAt': createdAt.toIso8601String(),
        'mode': mode,
        'state': state,
        'need': need,
        'pattern': pattern,
        'patternConfidence': patternConfidence,
        'goal': goal,
        'interventionCode': interventionCode,
        'interventionVersion': interventionVersion,
        'interventionId': interventionId,
        'action': action,
        'followUp': followUp?.toJson(),
      };

  factory CoachingTurn.fromJson(Map<String, dynamic> json) {
    final now = DateTime.now();
    final followRaw = json['followUp'];
    final versionRaw = json['interventionVersion'];
    int? interventionVersion;
    if (versionRaw is int) {
      interventionVersion = versionRaw;
    } else if (versionRaw is num) {
      interventionVersion = versionRaw.toInt();
    } else if (versionRaw is String) {
      interventionVersion = int.tryParse(versionRaw);
    }

    return CoachingTurn(
      id: (json['id'] as String?)?.trim().isNotEmpty == true
          ? (json['id'] as String).trim()
          : 't${now.microsecondsSinceEpoch}',
      createdAt: DateTime.tryParse(json['createdAt'] as String? ?? '') ?? now,
      mode: (json['mode'] as String?)?.trim().isNotEmpty == true
          ? (json['mode'] as String).trim()
          : 'fallback',
      state: (json['state'] as String?)?.trim().isNotEmpty == true
          ? (json['state'] as String).trim()
          : 'unknown',
      need: (json['need'] as String?)?.trim().isNotEmpty == true
          ? (json['need'] as String).trim()
          : 'unknown',
      pattern: (json['pattern'] as String?)?.trim().isNotEmpty == true
          ? (json['pattern'] as String).trim()
          : 'unknown',
      patternConfidence: (json['patternConfidence'] as String?)?.trim().isNotEmpty == true
          ? (json['patternConfidence'] as String).trim()
          : 'low',
      goal: (json['goal'] as String?)?.trim() ?? '',
      interventionCode: (json['interventionCode'] as String?)?.trim().isNotEmpty == true
          ? (json['interventionCode'] as String).trim()
          : null,
      interventionVersion: interventionVersion,
      interventionId: (json['interventionId'] as String?)?.trim().isNotEmpty == true
          ? (json['interventionId'] as String).trim()
          : null,
      action: (json['action'] as String?)?.trim() ?? '',
      followUp: followRaw is Map
          ? CoachingFollowUp.fromJson(Map<String, dynamic>.from(followRaw))
          : null,
    );
  }
}
