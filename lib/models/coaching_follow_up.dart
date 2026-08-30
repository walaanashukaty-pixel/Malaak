class CoachingFollowUp {
  CoachingFollowUp({
    required this.id,
    required this.timing,
    required this.prompt,
    required this.createdAt,
    this.journeyDomainId,
    this.completedAt,
  });

  final String id;
  final String timing;
  final String prompt;
  final String? journeyDomainId;
  final DateTime createdAt;
  final DateTime? completedAt;

  CoachingFollowUp copyWith({
    String? id,
    String? timing,
    String? prompt,
    String? journeyDomainId,
    DateTime? createdAt,
    DateTime? completedAt,
    bool clearCompletedAt = false,
  }) {
    return CoachingFollowUp(
      id: id ?? this.id,
      timing: timing ?? this.timing,
      prompt: prompt ?? this.prompt,
      journeyDomainId: journeyDomainId ?? this.journeyDomainId,
      createdAt: createdAt ?? this.createdAt,
      completedAt: clearCompletedAt ? null : (completedAt ?? this.completedAt),
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'timing': timing,
        'prompt': prompt,
        'journeyDomainId': journeyDomainId,
        'createdAt': createdAt.toIso8601String(),
        'completedAt': completedAt?.toIso8601String(),
      };

  factory CoachingFollowUp.fromJson(Map<String, dynamic> json) {
    final now = DateTime.now();
    return CoachingFollowUp(
      id: (json['id'] as String?)?.trim().isNotEmpty == true
          ? (json['id'] as String).trim()
          : 'f${now.microsecondsSinceEpoch}',
      timing: (json['timing'] as String?)?.trim().isNotEmpty == true
          ? (json['timing'] as String).trim()
          : 'none',
      prompt: (json['prompt'] as String?)?.trim() ?? '',
      journeyDomainId: (json['journeyDomainId'] as String?)?.trim().isNotEmpty == true
          ? (json['journeyDomainId'] as String).trim()
          : null,
      createdAt: DateTime.tryParse(json['createdAt'] as String? ?? '') ?? now,
      completedAt: DateTime.tryParse(json['completedAt'] as String? ?? ''),
    );
  }
}
