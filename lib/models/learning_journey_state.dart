class LearningJourneyState {
  const LearningJourneyState({
    required this.domainId,
    this.routeId,
    this.assessmentCompleted = false,
    this.scores = const <String, int>{},
    this.answers = const <String, String>{},
    this.completedLessonIds = const <String>[],
    this.notes = const <String, String>{},
    this.updatedAt,
  });

  final String domainId;
  final String? routeId;
  final bool assessmentCompleted;
  final Map<String, int> scores;
  final Map<String, String> answers;
  final List<String> completedLessonIds;
  final Map<String, String> notes;
  final DateTime? updatedAt;

  LearningJourneyState copyWith({
    String? routeId,
    bool? assessmentCompleted,
    Map<String, int>? scores,
    Map<String, String>? answers,
    List<String>? completedLessonIds,
    Map<String, String>? notes,
    DateTime? updatedAt,
  }) {
    return LearningJourneyState(
      domainId: domainId,
      routeId: routeId ?? this.routeId,
      assessmentCompleted: assessmentCompleted ?? this.assessmentCompleted,
      scores: scores ?? this.scores,
      answers: answers ?? this.answers,
      completedLessonIds: completedLessonIds ?? this.completedLessonIds,
      notes: notes ?? this.notes,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  Map<String, dynamic> toJson() => {
        'domainId': domainId,
        'routeId': routeId,
        'assessmentCompleted': assessmentCompleted,
        'scores': scores,
        'answers': answers,
        'completedLessonIds': completedLessonIds,
        'notes': notes,
        'updatedAt': updatedAt?.toIso8601String(),
      };

  factory LearningJourneyState.fromJson(Map<String, dynamic> json) {
    final rawScores = Map<String, dynamic>.from(json['scores'] as Map? ?? const {});
    final rawAnswers = Map<String, dynamic>.from(json['answers'] as Map? ?? const {});
    final rawNotes = Map<String, dynamic>.from(json['notes'] as Map? ?? const {});
    final rawRouteId = (json['routeId'] as String?)?.trim();
    return LearningJourneyState(
      domainId: (json['domainId'] as String?)?.trim() ?? '',
      routeId: rawRouteId == null || rawRouteId.isEmpty ? null : rawRouteId,
      assessmentCompleted: json['assessmentCompleted'] as bool? ?? false,
      scores: rawScores.map((key, value) => MapEntry(key, (value as num?)?.toInt() ?? 0)),
      answers: rawAnswers.map((key, value) => MapEntry(key, value?.toString() ?? '')),
      completedLessonIds: (json['completedLessonIds'] as List? ?? const [])
          .map((value) => value.toString())
          .where((value) => value.isNotEmpty)
          .toList(growable: false),
      notes: rawNotes.map((key, value) => MapEntry(key, value?.toString() ?? '')),
      updatedAt: json['updatedAt'] == null ? null : DateTime.tryParse(json['updatedAt'].toString()),
    );
  }
}
