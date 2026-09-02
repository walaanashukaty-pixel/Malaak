class LearningLessonProgress {
  const LearningLessonProgress({
    this.stage = 'notStarted',
    this.sessionStep = 0,
    this.attempts = 0,
    this.realLifeApplications = 0,
    this.selectedChoice,
    this.scenarioChoice,
    this.reflection,
    this.mission,
    this.lastOutcome,
    this.updatedAt,
  });

  final String stage;
  final int sessionStep;
  final int attempts;
  final int realLifeApplications;
  final String? selectedChoice;
  final String? scenarioChoice;
  final String? reflection;
  final String? mission;
  final String? lastOutcome;
  final DateTime? updatedAt;

  bool get hasStarted => stage != 'notStarted';
  bool get missionPending => stage == 'missionPending';
  bool get applied => stage == 'applied' || realLifeApplications > 0;

  LearningLessonProgress copyWith({
    String? stage,
    int? sessionStep,
    int? attempts,
    int? realLifeApplications,
    String? selectedChoice,
    String? scenarioChoice,
    String? reflection,
    String? mission,
    String? lastOutcome,
    DateTime? updatedAt,
  }) {
    return LearningLessonProgress(
      stage: stage ?? this.stage,
      sessionStep: sessionStep ?? this.sessionStep,
      attempts: attempts ?? this.attempts,
      realLifeApplications: realLifeApplications ?? this.realLifeApplications,
      selectedChoice: selectedChoice ?? this.selectedChoice,
      scenarioChoice: scenarioChoice ?? this.scenarioChoice,
      reflection: reflection ?? this.reflection,
      mission: mission ?? this.mission,
      lastOutcome: lastOutcome ?? this.lastOutcome,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  Map<String, dynamic> toJson() => {
        'stage': stage,
        'sessionStep': sessionStep,
        'attempts': attempts,
        'realLifeApplications': realLifeApplications,
        'selectedChoice': selectedChoice,
        'scenarioChoice': scenarioChoice,
        'reflection': reflection,
        'mission': mission,
        'lastOutcome': lastOutcome,
        'updatedAt': updatedAt?.toIso8601String(),
      };

  factory LearningLessonProgress.fromJson(Map<String, dynamic> json) {
    return LearningLessonProgress(
      stage: (json['stage'] as String?)?.trim().isNotEmpty == true
          ? (json['stage'] as String).trim()
          : 'notStarted',
      sessionStep: (json['sessionStep'] as num?)?.toInt() ?? 0,
      attempts: (json['attempts'] as num?)?.toInt() ?? 0,
      realLifeApplications: (json['realLifeApplications'] as num?)?.toInt() ?? 0,
      selectedChoice: _cleanNullable(json['selectedChoice']),
      scenarioChoice: _cleanNullable(json['scenarioChoice']),
      reflection: _cleanNullable(json['reflection']),
      mission: _cleanNullable(json['mission']),
      lastOutcome: _cleanNullable(json['lastOutcome']),
      updatedAt: json['updatedAt'] == null ? null : DateTime.tryParse(json['updatedAt'].toString()),
    );
  }

  static String? _cleanNullable(dynamic value) {
    final text = value?.toString().trim() ?? '';
    return text.isEmpty ? null : text;
  }
}

class LearningJourneyState {
  const LearningJourneyState({
    required this.domainId,
    this.routeId,
    this.recommendedRouteId,
    this.assessmentCompleted = false,
    this.scores = const <String, int>{},
    this.answers = const <String, String>{},
    this.completedLessonIds = const <String>[],
    this.notes = const <String, String>{},
    this.lessonProgress = const <String, LearningLessonProgress>{},
    this.updatedAt,
  });

  final String domainId;
  final String? routeId;
  final String? recommendedRouteId;
  final bool assessmentCompleted;
  final Map<String, int> scores;
  final Map<String, String> answers;
  final List<String> completedLessonIds;
  final Map<String, String> notes;
  final Map<String, LearningLessonProgress> lessonProgress;
  final DateTime? updatedAt;

  LearningJourneyState copyWith({
    String? routeId,
    String? recommendedRouteId,
    bool? assessmentCompleted,
    Map<String, int>? scores,
    Map<String, String>? answers,
    List<String>? completedLessonIds,
    Map<String, String>? notes,
    Map<String, LearningLessonProgress>? lessonProgress,
    DateTime? updatedAt,
  }) {
    return LearningJourneyState(
      domainId: domainId,
      routeId: routeId ?? this.routeId,
      recommendedRouteId: recommendedRouteId ?? this.recommendedRouteId,
      assessmentCompleted: assessmentCompleted ?? this.assessmentCompleted,
      scores: scores ?? this.scores,
      answers: answers ?? this.answers,
      completedLessonIds: completedLessonIds ?? this.completedLessonIds,
      notes: notes ?? this.notes,
      lessonProgress: lessonProgress ?? this.lessonProgress,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  Map<String, dynamic> toJson() => {
        'domainId': domainId,
        'routeId': routeId,
        'recommendedRouteId': recommendedRouteId,
        'assessmentCompleted': assessmentCompleted,
        'scores': scores,
        'answers': answers,
        'completedLessonIds': completedLessonIds,
        'notes': notes,
        'lessonProgress': lessonProgress.map((key, value) => MapEntry(key, value.toJson())),
        'updatedAt': updatedAt?.toIso8601String(),
      };

  factory LearningJourneyState.fromJson(Map<String, dynamic> json) {
    final rawScores = Map<String, dynamic>.from(json['scores'] as Map? ?? const {});
    final rawAnswers = Map<String, dynamic>.from(json['answers'] as Map? ?? const {});
    final rawNotes = Map<String, dynamic>.from(json['notes'] as Map? ?? const {});
    final rawProgress = Map<String, dynamic>.from(json['lessonProgress'] as Map? ?? const {});
    final rawRouteId = (json['routeId'] as String?)?.trim();
    final rawRecommendedRouteId = (json['recommendedRouteId'] as String?)?.trim();
    return LearningJourneyState(
      domainId: (json['domainId'] as String?)?.trim() ?? '',
      routeId: rawRouteId == null || rawRouteId.isEmpty ? null : rawRouteId,
      recommendedRouteId: rawRecommendedRouteId == null || rawRecommendedRouteId.isEmpty
          ? null
          : rawRecommendedRouteId,
      assessmentCompleted: json['assessmentCompleted'] as bool? ?? false,
      scores: rawScores.map((key, value) => MapEntry(key, (value as num?)?.toInt() ?? 0)),
      answers: rawAnswers.map((key, value) => MapEntry(key, value?.toString() ?? '')),
      completedLessonIds: (json['completedLessonIds'] as List? ?? const [])
          .map((value) => value.toString())
          .where((value) => value.isNotEmpty)
          .toList(growable: false),
      notes: rawNotes.map((key, value) => MapEntry(key, value?.toString() ?? '')),
      lessonProgress: rawProgress.map((key, value) {
        if (value is! Map) return MapEntry(key, const LearningLessonProgress());
        return MapEntry(key, LearningLessonProgress.fromJson(Map<String, dynamic>.from(value)));
      }),
      updatedAt: json['updatedAt'] == null ? null : DateTime.tryParse(json['updatedAt'].toString()),
    );
  }
}
