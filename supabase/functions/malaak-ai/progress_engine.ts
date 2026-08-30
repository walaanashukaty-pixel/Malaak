export type JourneySkillStage = 'أفهمها' | 'أتمرن عليها' | 'أطبقها' | 'أثبتها تحت الضغط' | 'صارت أقرب لطبيعتي';
export type JourneyReviewAction = 'continue' | 'stabilize' | 'reassess' | 'step_up';

export interface JourneyReviewInput {
  previousStage: JourneySkillStage;
  awarenessEvidence: number;
  assistedUses: number;
  independentUses: number;
  stableUnderPressureUses: number;
  difficultWeek: boolean;
  interventionAttempts: number;
  helpfulAttempts: number;
  currentImpactHigh: boolean;
  outcomesWorsening: boolean;
}

export interface JourneyReviewDecision {
  stage: JourneySkillStage;
  supportMode: boolean;
  demoted: false;
  action: JourneyReviewAction;
  repeatSameIntervention: boolean;
  humanSupportRecommended: boolean;
  summaryAr: string;
}

const STAGES: JourneySkillStage[] = ['أفهمها', 'أتمرن عليها', 'أطبقها', 'أثبتها تحت الضغط', 'صارت أقرب لطبيعتي'];

function derivedStage(input: JourneyReviewInput): JourneySkillStage {
  if (input.stableUnderPressureUses >= 6 && input.independentUses >= 6) return 'صارت أقرب لطبيعتي';
  if (input.stableUnderPressureUses >= 3) return 'أثبتها تحت الضغط';
  if (input.independentUses >= 3) return 'أطبقها';
  if (input.assistedUses >= 2) return 'أتمرن عليها';
  return 'أفهمها';
}

function noDemotionStage(previous: JourneySkillStage, current: JourneySkillStage): JourneySkillStage {
  return STAGES[Math.max(STAGES.indexOf(previous), STAGES.indexOf(current))] ?? previous;
}

function repeatedNonResponse(input: JourneyReviewInput): boolean {
  if (input.interventionAttempts < 4) return false;
  return input.helpfulAttempts / Math.max(input.interventionAttempts, 1) <= 0.25;
}

export function evaluateJourneyReview(input: JourneyReviewInput): JourneyReviewDecision {
  const stage = noDemotionStage(input.previousStage, derivedStage(input));
  const nonResponse = repeatedNonResponse(input);

  if (nonResponse && (input.currentImpactHigh || input.outcomesWorsening)) {
    return {
      stage,
      supportMode: true,
      demoted: false,
      action: 'step_up',
      repeatSameIntervention: false,
      humanSupportRecommended: true,
      summaryAr: 'الخطة الحالية ما عم تعطينا النتيجة المطلوبة مع أثر مرتفع أو تدهور، لذلك ما رح نكرر نفس التدخل؛ الأولوية إعادة التقييم وتشجيع دعم بشري/مهني مناسب.',
    };
  }

  if (nonResponse) {
    return {
      stage,
      supportMode: true,
      demoted: false,
      action: 'reassess',
      repeatSameIntervention: false,
      humanSupportRecommended: false,
      summaryAr: 'كررنا المحاولة بدون فائدة واضحة كفاية؛ بدل الإصرار على نفس الأداة، نعيد تقييم الملاءمة والسياق ونختار بديلًا مناسبًا.',
    };
  }

  if (input.difficultWeek) {
    return {
      stage,
      supportMode: true,
      demoted: false,
      action: 'stabilize',
      repeatSameIntervention: true,
      humanSupportRecommended: false,
      summaryAr: 'هذا أسبوع ضغط، مو رجوع للصفر. نحافظ على المرحلة اللي بنيتيها ونخفف التحديات مؤقتًا لحد ما يرجع الاستقرار.',
    };
  }

  return {
    stage,
    supportMode: false,
    demoted: false,
    action: 'continue',
    repeatSameIntervention: true,
    humanSupportRecommended: false,
    summaryAr: 'النتائج الحالية تسمح نكمل التدريب على نفس المهارة بدون فتح مسارات إضافية.',
  };
}
