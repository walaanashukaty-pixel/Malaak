enum HypothesisStatus {
  candidate,
  repeated,
  userValidated,
  rejected,
  dormant,
}

class HypothesisItem {
  const HypothesisItem({
    required this.id,
    required this.domain,
    required this.patternKey,
    required this.statementAr,
    required this.status,
    required this.confidenceLabel,
    required this.supportCount,
    required this.distinctDays,
    required this.distinctContexts,
    required this.lastSeenAt,
    this.userFeedback,
  });

  final String id;
  final String domain;
  final String patternKey;
  final String statementAr;
  final HypothesisStatus status;
  final String confidenceLabel;
  final int supportCount;
  final int distinctDays;
  final int distinctContexts;
  final DateTime? lastSeenAt;
  final String? userFeedback;

  factory HypothesisItem.fromJson(Map<String, dynamic> json) {
    dynamic value(String camel, String snake) => json[camel] ?? json[snake];
    return HypothesisItem(
      id: value('id', 'id') as String? ?? '',
      domain: value('domain', 'domain') as String? ?? 'self',
      patternKey: value('patternKey', 'pattern_key') as String? ?? 'unknown',
      statementAr: value('statementAr', 'statement_ar') as String? ?? '',
      status: _parseStatus(value('status', 'status') as String?),
      confidenceLabel: value('confidenceLabel', 'confidence_label') as String? ?? 'low',
      supportCount: _asInt(value('supportCount', 'support_count')),
      distinctDays: _asInt(value('distinctDays', 'distinct_days')),
      distinctContexts: _asInt(value('distinctContexts', 'distinct_contexts')),
      lastSeenAt: DateTime.tryParse(value('lastSeenAt', 'last_seen_at') as String? ?? ''),
      userFeedback: value('userFeedback', 'user_feedback') as String?,
    );
  }

  static int _asInt(dynamic value) => value is int ? value : int.tryParse('$value') ?? 0;

  static HypothesisStatus _parseStatus(String? value) => switch (value) {
        'repeated' => HypothesisStatus.repeated,
        'user_validated' => HypothesisStatus.userValidated,
        'user_rejected' => HypothesisStatus.rejected,
        'dormant' => HypothesisStatus.dormant,
        _ => HypothesisStatus.candidate,
      };

  String get statusLabel => switch (status) {
        HypothesisStatus.candidate => 'إشارة أولية',
        HypothesisStatus.repeated => 'نمط متكرر',
        HypothesisStatus.userValidated => 'أكدتِ إنه بيمثلك',
        HypothesisStatus.rejected => 'رفضتيه',
        HypothesisStatus.dormant => 'هادئ حاليًا',
      };

  String get statusDescription => switch (status) {
        HypothesisStatus.candidate => 'ظهر بموقف أو أكثر، بس لسه ما في دليل كافي نعتبره نمط ثابت.',
        HypothesisStatus.repeated => 'تكرر ببياناتك عبر أكثر من موقف، ولسه منعامله كنمط شخصي غير تشخيصي.',
        HypothesisStatus.userValidated => 'ظهر بشكل متكرر وإنتِ أكدتي إنه بيمثّل تجربتك الحالية.',
        HypothesisStatus.rejected => 'إنتِ قلتي إن هالاستنتاج مو صحيح، لذلك ملاك ما بتستخدمه بالتوجيه.',
        HypothesisStatus.dormant => 'كان ظاهر قبل، بس ما عاد متكرر حديثًا وما لازم يقود خطتك الحالية.',
      };

  bool get routingEligible => status == HypothesisStatus.repeated || status == HypothesisStatus.userValidated;
  bool get canReject => status != HypothesisStatus.rejected;
}
