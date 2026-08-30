import type { CatalogIntervention } from './types.ts';

const base = (card: Partial<CatalogIntervention> & Pick<CatalogIntervention,'code'|'titleAr'|'framework'|'evidenceTier'|'targetNeeds'|'targetPatterns'|'eligibleStates'|'journeyDomains'|'exclusions'|'durationMinutes'|'steps'|'actionTemplate'>): CatalogIntervention => ({
  id: `embedded:${card.code}:1`,
  version: 1,
  status: 'active',
  shortDescriptionAr: '',
  contraindicationNotesAr: '',
  measurementSpec: { before: ['intensity_before'], after: ['intensity_after'], outcome: ['user_helpfulness'] },
  followUpSpec: { timing: 'later_today', prompt: 'شو صار بعد ما جربتي الخطوة؟' },
  fallbackCode: null,
  requiresUserConfirmation: false,
  requiresHumanSupport: false,
  ...card,
});

export const embeddedFallbackInterventions: CatalogIntervention[] = [
  base({code:'REG_GROUND_001',titleAr:'تثبيت الحاضر',framework:'grounding / distress tolerance',evidenceTier:'B',targetNeeds:['regulation','safety'],targetPatterns:['anger_escalation','attachment_alarm','reassurance_loop','rumination','unknown'],eligibleStates:['high_activation','moderate_activation','unknown'],journeyDomains:['emotional-state','inner-peace'],exclusions:['Not trauma processing.'],durationMinutes:2,steps:['وقفي القرار للحظة.','سمّي 3 أشياء شايفتيها وشيئين عم تلمسيهم وشي عم تسمعيه.','قيّمي إذا الشدة نزلت.'],actionTemplate:'خدي دقيقتين تثبيت قبل أي تصرف جديد.'}),
  base({code:'REG_MOVE_002',titleAr:'حركة قصيرة للتنظيم',framework:'behavioral regulation',evidenceTier:'B',targetNeeds:['regulation','rest'],targetPatterns:['anger_escalation','rumination','control_overdrive','unknown'],eligibleStates:['high_activation','moderate_activation'],journeyDomains:['inner-peace','anger'],exclusions:['Modify when movement is medically inappropriate.'],durationMinutes:5,steps:['ابتعدي عن الحوار الساخن.','اعملي حركة هادئة قصيرة.','ارجعي قيّمي شدتك.'],actionTemplate:'اعملي حركة هادئة 5 دقائق ثم قيّمي شدتك.'}),
  base({code:'NEED_NAME_001',titleAr:'سمّي الحاجة',framework:'needs clarification',evidenceTier:'B',targetNeeds:['understanding','connection','rest','respect','autonomy','support','unknown'],targetPatterns:['unmet_need','people_pleasing','conflict_cycle','unknown'],eligibleStates:['moderate_activation','reflective','unknown'],journeyDomains:['needs'],exclusions:['A need does not create entitlement to control another person.'],durationMinutes:5,steps:['سمّي الشعور الأقرب.','اسألي شو كان ناقص.','سمّي الحاجة بكلمة واضحة.'],actionTemplate:'سمّي حاجتك قبل ما تختاري الحل.'}),
  base({code:'THOUGHT_FACTS_001',titleAr:'الحدث أم التفسير؟',framework:'CBT cognitive restructuring',evidenceTier:'A',targetNeeds:['understanding','clarity'],targetPatterns:['thought_fusion','attachment_alarm','conflict_cycle','unknown'],eligibleStates:['moderate_activation','reflective','unknown'],journeyDomains:['overthinking'],exclusions:['Avoid repetitive debate when reassurance loop is primary.'],durationMinutes:6,steps:['اكتبي حقيقة.','اكتبي تفسير.','اكتبي شي مجهول.'],actionTemplate:'افصلي بين حقيقة واحدة وتفسير واحد وشي مجهول.'}),
  base({code:'PROBLEM_SOLVE_001',titleAr:'مشكلة واحدة وخطوة واحدة',framework:'CBT problem solving',evidenceTier:'A',targetNeeds:['decision','clarity','autonomy'],targetPatterns:['practical_problem','control_overdrive','unknown'],eligibleStates:['moderate_activation','reflective','unknown'],journeyDomains:['inner-peace','overthinking'],exclusions:['Not for immediate danger.'],durationMinutes:8,steps:['عرّفي المشكلة.','افصلي شو بإيدك.','اختاري أصغر خطوة.'],actionTemplate:'اختاري مشكلة وحدة تحت سيطرتك ونفذي أصغر خطوة.'}),
];
