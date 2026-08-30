export type JourneyDomain =
  | 'emotional-state' | 'inner-peace' | 'needs' | 'childhood' | 'attachment'
  | 'relationship' | 'overthinking' | 'anger' | 'feminine-balance'
  | 'feminine-intelligence' | 'healing';

export type PlannerHypothesisStatus = 'candidate' | 'repeated' | 'user_validated' | 'user_rejected' | 'dormant';
export type PlannerConfidence = 'low' | 'medium' | 'high';

export interface PlannerHypothesis {
  domain: JourneyDomain;
  patternKey: string;
  status: PlannerHypothesisStatus;
  confidenceLabel: PlannerConfidence;
}

export interface JourneyPlannerInput {
  safetyRisk: boolean;
  highActivation: boolean;
  highImpact: boolean;
  regulationAdequate: boolean;
  explicitGoalDomains: JourneyDomain[];
  currentImpactDomains: JourneyDomain[];
  hypotheses: PlannerHypothesis[];
  maintainingMechanisms: JourneyDomain[];
  explicitlyRequestedDeepDomains: JourneyDomain[];
  formulationVersion: number;
}

export interface JourneyPlanDecision {
  suspended: boolean;
  primaryDomain: JourneyDomain | null;
  primaryGoal: string | null;
  supportDomain: JourneyDomain | null;
  supportGoal: string | null;
  monitorDomains: JourneyDomain[];
  laterDomains: JourneyDomain[];
  reasoningSummaryAr: string;
  basedOnFormulationVersion: number;
  status: 'active' | 'maintenance' | 'paused';
}

const DEEP = new Set<JourneyDomain>(['childhood', 'healing']);
const DOMAIN_ORDER: JourneyDomain[] = [
  'emotional-state', 'inner-peace', 'needs', 'attachment', 'relationship',
  'overthinking', 'anger', 'feminine-balance', 'feminine-intelligence', 'childhood', 'healing',
];
const LABELS: Record<JourneyDomain, string> = {
  'emotional-state': 'تنظيم الحالة والمشاعر',
  'inner-peace': 'خفض الحمل واستعادة الاتزان',
  needs: 'فهم الحاجة والتعبير عنها',
  childhood: 'فهم أثر الماضي بأمان من الحاضر',
  attachment: 'بناء أمان أكبر في التعلق',
  relationship: 'بناء علاقة وتواصل أكثر أمانًا',
  overthinking: 'تقليل حلقات التفكير والعودة للفعل',
  anger: 'التقاط الغضب وتنظيمه قبل التصرف',
  'feminine-balance': 'تقليل وضع الحرب والسيطرة المستمرة',
  'feminine-intelligence': 'استخدام الوقت والمسافة والمشاعر والنية بمرونة',
  healing: 'التشافي العاطفي مع الحفاظ على الأمان والحاضر',
};

function uniqueDomains(values: JourneyDomain[]): JourneyDomain[] {
  return values.filter((value, index, all) => all.indexOf(value) === index);
}

function confidenceWeight(value: PlannerConfidence): number {
  return value === 'high' ? 20 : value === 'medium' ? 10 : 0;
}

function activeEvidence(h: PlannerHypothesis): boolean {
  return h.status === 'repeated' || h.status === 'user_validated';
}

function deepEligible(domain: JourneyDomain, input: JourneyPlannerInput): boolean {
  if (!DEEP.has(domain)) return true;
  return !input.safetyRisk
    && !input.highActivation
    && !input.highImpact
    && input.regulationAdequate
    && input.explicitlyRequestedDeepDomains.includes(domain);
}

function scoreDomains(input: JourneyPlannerInput): Map<JourneyDomain, number> {
  const scores = new Map<JourneyDomain, number>();
  const add = (domain: JourneyDomain, score: number) => scores.set(domain, (scores.get(domain) ?? 0) + score);
  for (const domain of uniqueDomains(input.explicitGoalDomains)) add(domain, 40);
  for (const domain of uniqueDomains(input.currentImpactDomains)) add(domain, 50);
  for (const hypothesis of input.hypotheses) {
    if (!activeEvidence(hypothesis)) continue;
    add(hypothesis.domain, (hypothesis.status === 'user_validated' ? 70 : 60) + confidenceWeight(hypothesis.confidenceLabel));
  }
  return scores;
}

function orderedByScore(scores: Map<JourneyDomain, number>): JourneyDomain[] {
  return [...scores.entries()]
    .filter(([, score]) => score > 0)
    .sort((a, b) => b[1] - a[1] || DOMAIN_ORDER.indexOf(a[0]) - DOMAIN_ORDER.indexOf(b[0]))
    .map(([domain]) => domain);
}

function historicalLater(input: JourneyPlannerInput, primary: JourneyDomain | null, support: JourneyDomain | null): JourneyDomain[] {
  const candidates: JourneyDomain[] = [];
  for (const domain of [...input.explicitGoalDomains, ...input.currentImpactDomains, ...input.explicitlyRequestedDeepDomains]) {
    if (DEEP.has(domain) && !deepEligible(domain, input)) candidates.push(domain);
  }
  for (const hypothesis of input.hypotheses) {
    if (!DEEP.has(hypothesis.domain)) continue;
    if (hypothesis.status === 'user_rejected') continue;
    if (!deepEligible(hypothesis.domain, input) || hypothesis.status === 'candidate' || hypothesis.status === 'dormant') {
      candidates.push(hypothesis.domain);
    }
  }
  return uniqueDomains(candidates).filter((domain) => domain !== primary && domain !== support);
}

function goalFor(domain: JourneyDomain | null): string | null {
  return domain ? LABELS[domain] : null;
}

export function buildJourneyPlan(input: JourneyPlannerInput): JourneyPlanDecision {
  if (input.safetyRisk) {
    return {
      suspended: true,
      primaryDomain: null,
      primaryGoal: null,
      supportDomain: null,
      supportGoal: null,
      monitorDomains: [],
      laterDomains: [],
      reasoningSummaryAr: 'أوقفنا التخطيط العادي مؤقتًا لأن الأمان أهم من أي مسار تطوير أو تدريب الآن.',
      basedOnFormulationVersion: input.formulationVersion,
      status: 'paused',
    };
  }

  if (input.highActivation || input.highImpact || !input.regulationAdequate) {
    const primary: JourneyDomain = input.highImpact && !input.highActivation ? 'inner-peace' : 'emotional-state';
    return {
      suspended: false,
      primaryDomain: primary,
      primaryGoal: goalFor(primary),
      supportDomain: null,
      supportGoal: null,
      monitorDomains: uniqueDomains(input.currentImpactDomains.filter((domain) => !DEEP.has(domain) && domain !== primary)).slice(0, 2),
      laterDomains: historicalLater(input, primary, null),
      reasoningSummaryAr: 'الأولوية الحالية هي التثبيت والتنظيم قبل فتح مسار أعمق؛ نرجع لبقية المواضيع بعد ما تصير القدرة على التنظيم أفضل.',
      basedOnFormulationVersion: input.formulationVersion,
      status: 'active',
    };
  }

  const scores = scoreDomains(input);
  const ranked = orderedByScore(scores);
  const maintaining = uniqueDomains(input.maintainingMechanisms)
    .filter((domain) => !DEEP.has(domain) && (scores.get(domain) ?? 0) > 0);

  const primary = ranked.find((domain) => !maintaining.includes(domain) && deepEligible(domain, input))
    ?? ranked.find((domain) => deepEligible(domain, input))
    ?? null;

  const support = maintaining.find((domain) => domain !== primary)
    ?? ranked.find((domain) => domain !== primary && !DEEP.has(domain) && input.maintainingMechanisms.includes(domain))
    ?? null;

  const monitorPool = uniqueDomains([
    ...input.explicitGoalDomains,
    ...input.currentImpactDomains,
    ...ranked,
  ]).filter((domain) => domain !== primary && domain !== support && !DEEP.has(domain));

  const later = historicalLater(input, primary, support);
  const status: JourneyPlanDecision['status'] = primary ? 'active' : 'maintenance';
  const reasoning = primary
    ? `اخترنا «${LABELS[primary]}» كتركيز واحد حاليًا${support ? `، ومعه «${LABELS[support]}» كمسار مساند لأنه قد يحافظ على الصعوبة الحالية` : ''}. بقية المجالات تبقى للمراقبة أو لوقت أنسب بدل فتح عدة مسارات معًا.`
    : 'ما في دليل كافٍ حاليًا لفتح مسار تطوير جديد؛ الأفضل المحافظة والمراقبة إلى أن يظهر هدف أو نمط متكرر يستحق التركيز.';

  return {
    suspended: false,
    primaryDomain: primary,
    primaryGoal: goalFor(primary),
    supportDomain: support,
    supportGoal: goalFor(support),
    monitorDomains: monitorPool.slice(0, 2),
    laterDomains: later,
    reasoningSummaryAr: reasoning,
    basedOnFormulationVersion: input.formulationVersion,
    status,
  };
}
