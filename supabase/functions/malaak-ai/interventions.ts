import type { InterventionCard, RoutingResult } from './types.ts';

export const interventions: InterventionCard[] = [
  {
    code: 'REG_GROUND_001',
    titleAr: 'تثبيت الحاضر',
    framework: 'grounding / distress tolerance',
    evidenceTier: 'B',
    targets: ['regulation', 'safety'],
    eligibleStates: ['high_activation', 'moderate_activation', 'unknown'],
    patterns: ['anger_escalation', 'attachment_alarm', 'reassurance_loop', 'rumination', 'unknown'],
    exclusions: ['do not present as trauma processing'],
    durationMinutes: 2,
    steps: [
      'توقفي عن اتخاذ قرار أو إرسال رسالة للحظة.',
      'سمّي 3 أشياء ترينها وشيئين تلمسينهما وشيئاً تسمعينه.',
      'لاحظي إن كانت الشدة انخفضت ولو درجة واحدة.',
    ],
    actionTemplate: 'خذي دقيقتين تثبيت قبل أي تصرف جديد.',
    fallbackCode: null,
    journeyDomainId: 'emotional-state',
  },
  {
    code: 'REG_MOVE_002',
    titleAr: 'حركة قصيرة للتنظيم',
    framework: 'behavioral regulation',
    evidenceTier: 'B',
    targets: ['regulation', 'rest'],
    eligibleStates: ['high_activation', 'moderate_activation'],
    patterns: ['anger_escalation', 'rumination', 'control_overdrive', 'unknown'],
    exclusions: ['modify when movement is medically inappropriate'],
    durationMinutes: 5,
    steps: [
      'ابتعدي عن شاشة أو حوار ساخن لدقائق.',
      'امشي أو حرّكي جسمك بهدوء بدون تفريغ عدواني.',
      'ارجعي قيّمي الشدة قبل القرار التالي.',
    ],
    actionTemplate: 'اعملي حركة هادئة 5 دقائق ثم قيّمي شدتك من جديد.',
    fallbackCode: 'REG_GROUND_001',
    journeyDomainId: 'inner-peace',
  },
  {
    code: 'ANGER_TIMEOUT_001',
    titleAr: 'توقف آمن مع موعد رجوع',
    framework: 'anger management / interpersonal effectiveness',
    evidenceTier: 'B',
    targets: ['regulation', 'respect'],
    eligibleStates: ['high_activation', 'moderate_activation'],
    patterns: ['anger_escalation', 'conflict_cycle'],
    exclusions: ['not a silent-treatment punishment', 'not for immediate violence risk; use safety mode'],
    durationMinutes: 20,
    steps: [
      'قولي باختصار إنك تحتاجين توقفاً لأن الشدة عالية.',
      'حددي وقتاً واضحاً للرجوع للحوار إذا كان الوضع آمناً.',
      'استخدمي فترة التوقف للتنظيم لا لجمع حجج جديدة.',
    ],
    actionTemplate: 'أوقفي الحوار مؤقتاً وحددي موعداً واضحاً للرجوع بعد ما تنخفض الشدة.',
    fallbackCode: 'REG_GROUND_001',
    journeyDomainId: 'anger',
  },
  {
    code: 'THOUGHT_FACTS_001',
    titleAr: 'الحدث أم التفسير؟',
    framework: 'CBT cognitive restructuring',
    evidenceTier: 'A',
    targets: ['understanding', 'clarity'],
    eligibleStates: ['moderate_activation', 'reflective', 'unknown'],
    patterns: ['thought_fusion', 'attachment_alarm', 'conflict_cycle', 'unknown'],
    exclusions: ['avoid repetitive debate when reassurance/obsessional loop is primary'],
    durationMinutes: 6,
    steps: [
      'اكتبي حقيقة يمكن للكاميرا تسجيلها.',
      'اكتبي التفسير الذي أضافه عقلك.',
      'اكتبي معلومة واحدة لا تعرفينها بعد.',
      'اختاري تفسيراً متوازناً لا يتطلب يقيناً مزيفاً.',
    ],
    actionTemplate: 'افصلي الآن بين حقيقة واحدة وتفسير واحد ومعلومة ما زالت مجهولة.',
    fallbackCode: 'RUMINATION_EXIT_001',
    journeyDomainId: 'overthinking',
  },
  {
    code: 'RUMINATION_EXIT_001',
    titleAr: 'الخروج من الحلقة',
    framework: 'CBT / metacognitive disengagement',
    evidenceTier: 'B',
    targets: ['regulation', 'clarity'],
    eligibleStates: ['moderate_activation', 'reflective', 'unknown'],
    patterns: ['rumination', 'reassurance_loop'],
    exclusions: ['do not use to suppress actionable safety information'],
    durationMinutes: 4,
    steps: [
      'اسألي: هل ظهرت معلومة جديدة أم نعيد نفس السؤال؟',
      'إذا لا توجد معلومة جديدة، أوقفي جولة التحليل الحالية.',
      'اختاري نشاطاً واقعياً قصيراً تعودين له الآن.',
    ],
    actionTemplate: 'أوقفي جولة التحليل الحالية وارجعي لنشاط محدد لمدة 10 دقائق.',
    fallbackCode: 'REG_GROUND_001',
    journeyDomainId: 'overthinking',
  },
  {
    code: 'UNCERTAINTY_001',
    titleAr: 'تحمّل جزء من عدم اليقين',
    framework: 'CBT / ACT-informed uncertainty tolerance',
    evidenceTier: 'B',
    targets: ['connection', 'clarity', 'regulation'],
    eligibleStates: ['moderate_activation', 'reflective', 'unknown'],
    patterns: ['attachment_alarm', 'reassurance_loop', 'rumination'],
    exclusions: ['not when credible immediate danger requires fact-finding or safety action'],
    durationMinutes: 10,
    steps: [
      'سمّي الشيء الذي لا تعرفينه الآن.',
      'اختاري فترة قصيرة لا تعيدي خلالها الفحص أو طلب الطمأنة.',
      'خلالها ارجعي لشيء مهم بحياتك.',
      'بعد الفترة قرري إذا في تواصل مباشر واحد فعلاً مطلوب.',
    ],
    actionTemplate: 'اختاري 10–15 دقيقة بدون فحص متكرر، وبعدها قرري إذا في خطوة تواصل واحدة مطلوبة.',
    fallbackCode: 'RUMINATION_EXIT_001',
    journeyDomainId: 'attachment',
  },
  {
    code: 'NEED_NAME_001',
    titleAr: 'سمّي الحاجة',
    framework: 'emotion-focused needs clarification / self-determination-informed',
    evidenceTier: 'B',
    targets: ['understanding', 'connection', 'rest', 'respect', 'autonomy', 'support', 'unknown'],
    eligibleStates: ['moderate_activation', 'reflective', 'unknown'],
    patterns: ['unmet_need', 'people_pleasing', 'conflict_cycle', 'unknown'],
    exclusions: ['a need does not create entitlement to control another person'],
    durationMinutes: 5,
    steps: [
      'سمّي الشعور الأقرب.',
      'اسألي ماذا كان ناقصاً في هذا الموقف.',
      'فرّقي بين الحاجة والحل الذي تتمنينه من شخص آخر.',
    ],
    actionTemplate: 'سمّي حاجتك بكلمة واضحة قبل ما تختاري كيف تطلبيها أو تلبي جزءاً منها.',
    fallbackCode: 'THOUGHT_FACTS_001',
    journeyDomainId: 'needs',
  },
  {
    code: 'REQUEST_DIRECT_001',
    titleAr: 'طلب مباشر بدون لوم',
    framework: 'assertiveness / interpersonal effectiveness',
    evidenceTier: 'B',
    targets: ['connection', 'respect', 'support'],
    eligibleStates: ['moderate_activation', 'reflective'],
    patterns: ['unmet_need', 'conflict_cycle', 'people_pleasing'],
    exclusions: ['do not use direct confrontation when it may increase interpersonal danger'],
    durationMinutes: 5,
    steps: [
      'اذكري الحدث بدون حكم.',
      'اذكري تجربتك أو شعورك باختصار.',
      'سمّي الحاجة.',
      'اطلبي سلوكاً محدداً وقابلاً للقبول أو الرفض.',
    ],
    actionTemplate: 'حوّلي حاجتك إلى طلب واحد محدد بدون اتهام أو قراءة نوايا.',
    fallbackCode: 'NEED_NAME_001',
    journeyDomainId: 'relationship',
  },
  {
    code: 'BOUNDARY_001',
    titleAr: 'حد واضح وقصير',
    framework: 'assertiveness / boundaries',
    evidenceTier: 'B',
    targets: ['boundary', 'autonomy', 'respect'],
    eligibleStates: ['moderate_activation', 'reflective', 'unknown'],
    patterns: ['people_pleasing', 'control_overdrive', 'conflict_cycle'],
    exclusions: ['adapt to safety risk; boundaries are not a substitute for protection planning'],
    durationMinutes: 5,
    steps: [
      'حددي ما هو مقبول وغير مقبول بالنسبة لك.',
      'قولي الحد بجملة قصيرة بلا تبرير طويل.',
      'اسمحي بوجود انزعاج أو عدم رضا بدون سحب الحد فوراً.',
    ],
    actionTemplate: 'اكتبي جملة حد قصيرة تقدري تقوليها بدون تبرير طويل.',
    fallbackCode: 'NEED_NAME_001',
    journeyDomainId: 'needs',
  },
  {
    code: 'PROBLEM_SOLVE_001',
    titleAr: 'مشكلة واحدة وخطوة واحدة',
    framework: 'CBT problem solving',
    evidenceTier: 'A',
    targets: ['decision', 'clarity', 'autonomy'],
    eligibleStates: ['moderate_activation', 'reflective', 'unknown'],
    patterns: ['practical_problem', 'control_overdrive', 'unknown'],
    exclusions: ['not for immediate danger requiring safety action'],
    durationMinutes: 8,
    steps: [
      'عرّفي المشكلة بجملة قابلة للحل.',
      'افصلي ما هو تحت سيطرتك عما ليس تحتها.',
      'اختاري أصغر خطوة عملية قابلة للتنفيذ.',
    ],
    actionTemplate: 'حددي مشكلة واحدة تحت سيطرتك ونفذي أصغر خطوة عملية إلها.',
    fallbackCode: 'THOUGHT_FACTS_001',
    journeyDomainId: 'inner-peace',
  },
];

const byCode = new Map(interventions.map((item) => [item.code, item]));

export function getIntervention(code: string): InterventionCard | undefined {
  return byCode.get(code);
}

export function eligibleInterventions(route: RoutingResult): InterventionCard[] {
  if (route.mode === 'safety') return [];
  const patternMatches = interventions.filter((card) =>
    card.eligibleStates.includes(route.state) &&
    (card.patterns.includes(route.pattern) || card.patterns.includes('unknown')),
  );
  const needMatches = interventions.filter((card) =>
    card.eligibleStates.includes(route.state) && card.targets.includes(route.need),
  );

  const orderedCodes = [...route.candidateCodes, ...patternMatches.map((x) => x.code), ...needMatches.map((x) => x.code)];
  const seen = new Set<string>();
  const ordered: InterventionCard[] = [];
  for (const code of orderedCodes) {
    if (seen.has(code)) continue;
    const card = getIntervention(code);
    if (!card || !card.eligibleStates.includes(route.state)) continue;
    seen.add(code);
    ordered.push(card);
    if (ordered.length === 4) break;
  }
  return ordered;
}
