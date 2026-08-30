class InitialMap {
  const InitialMap({
    required this.primaryConcern,
    required this.lifeContext,
    required this.currentImpact,
    required this.immediateSafety,
    required this.desiredChange,
    required this.coachingPreference,
    required this.privacyScope,
  });

  final String primaryConcern;
  final String lifeContext;
  final String currentImpact;
  final Map<String, dynamic> immediateSafety;
  final String desiredChange;
  final String coachingPreference;
  final Map<String, dynamic> privacyScope;

  bool get patternAnalysisEnabled => privacyScope['patternAnalysis'] as bool? ?? true;
  bool get journalAnalysisEnabled => privacyScope['journalAnalysis'] as bool? ?? false;

  Map<String, dynamic> toJson() => {
        'primaryConcern': primaryConcern,
        'lifeContext': lifeContext,
        'currentImpact': currentImpact,
        'immediateSafety': immediateSafety,
        'desiredChange': desiredChange,
        'coachingPreference': coachingPreference,
        'privacyScope': privacyScope,
      };

  factory InitialMap.fromJson(Map<String, dynamic> json) {
    dynamic value(String camel, String snake) => json[camel] ?? json[snake];
    return InitialMap(
      primaryConcern: value('primaryConcern', 'primary_concern') as String? ?? 'unsure',
      lifeContext: value('lifeContext', 'life_context') as String? ?? 'self',
      currentImpact: value('currentImpact', 'current_impact') as String? ?? 'moderate',
      immediateSafety: Map<String, dynamic>.from(
        value('immediateSafety', 'immediate_safety') as Map? ?? const {'level': 'none', 'safeNow': true},
      ),
      desiredChange: value('desiredChange', 'desired_change') as String? ?? '',
      coachingPreference: value('coachingPreference', 'coaching_preference') as String? ?? 'organize',
      privacyScope: Map<String, dynamic>.from(
        value('privacyScope', 'privacy_scope') as Map? ?? const {'patternAnalysis': true, 'journalAnalysis': false},
      ),
    );
  }

  static String concernLabel(String value) => switch (value) {
        'relationship' => 'علاقتي أو زواجي',
        'overthinking' => 'عقلي ما عم يوقف',
        'anger' => 'عصبيتي وردود فعلي',
        'emotional_pain' => 'تجربة عاطفية موجعتني',
        'needs' => 'ما بعرف شو بدي أو شو بحتاج',
        'inner_chaos' => 'حاسّة داخلي فوضى',
        'attachment' => 'بتعلّق وبخاف من البعد',
        'childhood' => 'حاسّة الماضي مأثر عليّ',
        'war_mode' => 'حاسّة حالي طول الوقت بوضع حرب',
        _ => 'مو واضحة عندي المشكلة بعد',
      };

  static String contextLabel(String value) => switch (value) {
        'marriage' => 'الزواج أو العلاقة',
        'family' => 'العائلة',
        'work' => 'العمل أو الدراسة',
        'self' => 'علاقتي مع حالي',
        _ => 'أكثر من جانب بحياتي',
      };

  static String impactLabel(String value) => switch (value) {
        'low' => 'موجود بس ما عم يعطل حياتي',
        'high' => 'مأثر بقوة على يومي أو علاقتي أو نومي',
        _ => 'مأثر عليّ بشكل واضح بس لسه عم بقدر أكمل يومي',
      };

  static String preferenceLabel(String value) => switch (value) {
        'listen' => 'اسمعيني أول شي',
        'challenge_thoughts' => 'ساعديني أتحدى أفكاري',
        'act' => 'ساعديني أتصرف بخطوة واضحة',
        'calm' => 'هدّيني قبل أي تحليل',
        _ => 'رتّبيلي الموضوع',
      };

  String get startingFocus => switch (primaryConcern) {
        'relationship' => 'نفهم الدائرة اللي عم تتكرر بالعلاقة قبل ما نختار المهارة الأنسب.',
        'overthinking' => 'نفرّق بين مشكلة تحتاج فعل وبين حلقة تفكير عم تعيد نفسها.',
        'anger' => 'نلتقط ارتفاع الغضب أبكر ونخلق مساحة قبل التصرف.',
        'emotional_pain' => 'نثبّت يومك ونفصل اللي صار عن قيمتك قبل أي استكشاف أعمق.',
        'needs' => 'نبدأ نسمّي الحاجة ونفرّق بينها وبين الطريقة اللي عم نطلبها فيها.',
        'inner_chaos' => 'نخفف الاستنفار ونرتّب الحمل بدل ما نفتّح عدة مواضيع مع بعض.',
        'attachment' => 'نلاحظ إنذار القرب والبعد وننظم الخوف قبل طلب الطمأنة.',
        'childhood' => 'نبدأ من أثر الحاضر، والماضي نرجعله فقط إذا صار مفيد وآمن.',
        'war_mode' => 'نميّز بين المسؤولية والسيطرة ونبني مرونة بدون فقدان القوة.',
        _ => 'نستخدم مواقفك الحقيقية خلال الأيام الجاية حتى تتوضح أفضل نقطة بداية.',
      };
}

bool needsInitialMap(InitialMap? map) => map == null;
