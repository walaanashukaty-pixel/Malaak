class JourneyPlan {
  const JourneyPlan({
    required this.id,
    required this.version,
    required this.primaryDomain,
    required this.primaryGoal,
    required this.supportDomain,
    required this.supportGoal,
    required this.monitorDomains,
    required this.laterDomains,
    required this.reasoningSummaryAr,
    required this.basedOnFormulationVersion,
    required this.reviewDueAt,
    required this.status,
  });

  final String id;
  final int version;
  final String? primaryDomain;
  final String? primaryGoal;
  final String? supportDomain;
  final String? supportGoal;
  final List<String> monitorDomains;
  final List<String> laterDomains;
  final String reasoningSummaryAr;
  final int basedOnFormulationVersion;
  final DateTime? reviewDueAt;
  final String status;

  bool get isPaused => status == 'paused';
  bool get isMaintenance => status == 'maintenance';
  bool get hasPrimary => primaryDomain != null && primaryDomain!.trim().isNotEmpty;
  bool get hasSupport => supportDomain != null && supportDomain!.trim().isNotEmpty;

  Map<String, dynamic> toJson() => {
        'id': id,
        'version': version,
        'primaryDomain': primaryDomain,
        'primaryGoal': primaryGoal,
        'supportDomain': supportDomain,
        'supportGoal': supportGoal,
        'monitorDomains': monitorDomains,
        'laterDomains': laterDomains,
        'reasoningSummaryAr': reasoningSummaryAr,
        'basedOnFormulationVersion': basedOnFormulationVersion,
        'reviewDueAt': reviewDueAt?.toIso8601String(),
        'status': status,
      };

  factory JourneyPlan.fromJson(Map<String, dynamic> json) {
    dynamic value(String camel, String snake) => json[camel] ?? json[snake];
    List<String> strings(String camel, String snake) =>
        (value(camel, snake) as List? ?? const []).whereType<String>().toList(growable: false);
    DateTime? dateValue(String camel, String snake) {
      final raw = value(camel, snake);
      if (raw is! String || raw.trim().isEmpty) return null;
      return DateTime.tryParse(raw);
    }

    return JourneyPlan(
      id: value('id', 'id') as String? ?? '',
      version: (value('version', 'version') as num?)?.toInt() ?? 0,
      primaryDomain: value('primaryDomain', 'primary_domain') as String?,
      primaryGoal: value('primaryGoal', 'primary_goal') as String?,
      supportDomain: value('supportDomain', 'support_domain') as String?,
      supportGoal: value('supportGoal', 'support_goal') as String?,
      monitorDomains: strings('monitorDomains', 'monitor_domains'),
      laterDomains: strings('laterDomains', 'later_domains'),
      reasoningSummaryAr: value('reasoningSummaryAr', 'reasoning_summary_ar') as String? ?? '',
      basedOnFormulationVersion:
          (value('basedOnFormulationVersion', 'based_on_formulation_version') as num?)?.toInt() ?? 0,
      reviewDueAt: dateValue('reviewDueAt', 'review_due_at'),
      status: value('status', 'status') as String? ?? 'active',
    );
  }

  static JourneyPlan? tryFromJson(dynamic raw) {
    if (raw is! Map) return null;
    try {
      final plan = JourneyPlan.fromJson(Map<String, dynamic>.from(raw));
      return plan.id.isEmpty && plan.version == 0 ? null : plan;
    } catch (_) {
      return null;
    }
  }
}
