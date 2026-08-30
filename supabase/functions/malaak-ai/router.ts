import type { CoachingNeed, CoachingPattern, CoachingState, Confidence, RoutingResult } from './types.ts';

const immediateRiskPatterns = [
  /انتحر|انتحار|أقتل نفسي|اقتل نفسي|أؤذي نفسي|اؤذي نفسي|ما بدي عيش|ما عاد بدي عيش/i,
  /(?:رح|بدي)\s*(?:أ|ا)?ضرب(?:ه|ها|هم)?|(?:رح|بدي)\s*(?:أ|ا)?قتل(?:ه|ها|هم)?|بدي اكسر راس|بدي أكسر راس/i,
  /حبسني|قفل الباب علي|هددني|يهددني|لاحقني|يطاردني|ضربني|يضربني/i,
  /suicid|kill myself|self harm|hurt myself|kill him|kill her/i,
];

const highActivationPatterns = [
  /(?:8|9|10)\s*(?:\/\s*10|من\s*10)/i,
  /عم\s*انفجر|رح\s*انفجر|مو\s*قادرة\s*(?:ا|أ)سيطر|مش\s*قادرة\s*(?:ا|أ)سيطر|فقدت\s*السيطرة/i,
  /مخنوقة\s*كتير|مرعوبة|هلع/i,
];

function contains(text: string, patterns: RegExp[]): boolean {
  return patterns.some((pattern) => pattern.test(text));
}

function inferState(message: string): CoachingState {
  if (contains(message, highActivationPatterns)) return 'high_activation';
  if (/معصبة|زعلانة|خايفة|متوترة|قلقانة|مقهورة|عم\s*فكر|مضايقة|اشتقت/i.test(message)) {
    return 'moderate_activation';
  }
  if (/بدي\s*افهم|بدي\s*أفهم|ساعديني\s*قرر|حلل|حللي|شو\s*تعلمت|شو\s*الافضل|شو\s*الأفضل/i.test(message)) {
    return 'reflective';
  }
  return 'unknown';
}

function inferNeed(message: string, state: CoachingState): CoachingNeed {
  if (state === 'high_activation') return 'regulation';
  if (/تعبانة|منهكة|ما\s*نمت|بدي\s*ارتاح|بدي\s*أرتاح/i.test(message)) return 'rest';
  if (/ما\s*رد|تركني|رح\s*يتركني|اشتقت|قرب|بعد|اهتمام|اهتم/i.test(message)) return 'connection';
  if (/احترام|بيحترمني|ما\s*احترمني|إهانة|اهانة/i.test(message)) return 'respect';
  if (/قول\s*لا|احط\s*حد|أحط\s*حد|حدود|ما\s*بدي\s*وافق/i.test(message)) return 'boundary';
  if (/قرار|اختار|أختار|اترك|أترك|ارجع|أرجع/i.test(message)) return 'decision';
  if (/مساعدة|ساعدني|دعم|ما\s*عندي\s*حدا/i.test(message)) return 'support';
  if (/شو\s*بدي|شو\s*حاجتي|احتياج|حاجتي/i.test(message)) return 'understanding';
  if (/شو\s*صار|افهم|أفهم|ليش/i.test(message)) return 'clarity';
  return state === 'reflective' ? 'understanding' : 'unknown';
}

function inferPattern(message: string): { pattern: CoachingPattern; confidence: Confidence } {
  if (/ما\s*رد|واتساب|آخر\s*ظهور|اخر\s*ظهور|افتح.*كل\s*(?:دقيقة|شوي)|أفتح.*كل\s*(?:دقيقة|شوي)|طمأنة|طمني|طمنيني/i.test(message)) {
    if (/كل\s*(?:دقيقة|شوي)|طمأنة|طمني|طمنيني|افتح|أفتح/i.test(message)) {
      return { pattern: 'reassurance_loop', confidence: 'high' };
    }
    return { pattern: 'attachment_alarm', confidence: 'medium' };
  }
  if (/رح\s*يتركني|ما\s*بيحبني|ما\s*عاد\s*يحبني|هجر/i.test(message)) return { pattern: 'attachment_alarm', confidence: 'medium' };
  if (/عم\s*فكر|راسي\s*ما\s*بيسكت|نفس\s*السؤال|ليش.*ليش|عم\s*اعيد|عم\s*أعيد/i.test(message)) return { pattern: 'rumination', confidence: 'medium' };
  if (/معصبة|انفجر|صرخت|عصب|اكسر|أكسر/i.test(message)) return { pattern: 'anger_escalation', confidence: 'medium' };
  if (/خايفة\s*يزعل|ما\s*بقدر\s*قول\s*لا|ارضي\s*الناس|أرضي\s*الناس|بوافق\s*غصب/i.test(message)) return { pattern: 'people_pleasing', confidence: 'medium' };
  if (/لازم\s*اعمل\s*كل\s*شي|لازم\s*أعمل\s*كل\s*شي|اسيطر|أسيطر|ما\s*بثق\s*حدا\s*يعملها/i.test(message)) return { pattern: 'control_overdrive', confidence: 'medium' };
  if (/أكيد|اكيد|معناته|يعني\s*أكيد|يعني\s*اكيد/i.test(message)) return { pattern: 'thought_fusion', confidence: 'low' };
  if (/تخانق|خلاف|انسحب|نقد|انتقد/i.test(message)) return { pattern: 'conflict_cycle', confidence: 'low' };
  if (/مشكلة\s*(?:عملية|بالشغل|بالبيت)|اول\s*خطوة|أول\s*خطوة|كيف\s*احل|كيف\s*أحل/i.test(message)) return { pattern: 'practical_problem', confidence: 'medium' };
  if (/شو\s*بدي|احتياج|حاجتي/i.test(message)) return { pattern: 'unmet_need', confidence: 'low' };
  return { pattern: 'unknown', confidence: 'low' };
}

function journeyForPattern(pattern: CoachingPattern): string | null {
  switch (pattern) {
    case 'attachment_alarm':
    case 'reassurance_loop': return 'attachment';
    case 'rumination':
    case 'thought_fusion': return 'overthinking';
    case 'anger_escalation': return 'anger';
    case 'people_pleasing':
    case 'unmet_need': return 'needs';
    case 'conflict_cycle': return 'relationship';
    case 'control_overdrive': return 'feminine-balance';
    case 'practical_problem': return 'inner-peace';
    default: return null;
  }
}

function candidateCodes(state: CoachingState, need: CoachingNeed, pattern: CoachingPattern): string[] {
  if (state === 'high_activation') {
    return pattern === 'anger_escalation'
      ? ['ANGER_TIMEOUT_001', 'REG_GROUND_001', 'REG_MOVE_002']
      : ['REG_GROUND_001', 'REG_BREATHE_003', 'REG_MOVE_002'];
  }

  const byPattern: Partial<Record<CoachingPattern, string[]>> = {
    attachment_alarm: ['ATT_TRIGGER_001', 'ATT_REALITY_002', 'UNCERTAINTY_001', 'THOUGHT_FACTS_001', 'REG_GROUND_001'],
    reassurance_loop: ['ATT_REASSURE_DELAY_003', 'UNCERTAINTY_001', 'REASSURANCE_BREAK_004', 'RUMINATION_EXIT_001', 'REG_GROUND_001'],
    rumination: ['RUMINATION_EXIT_001', 'WORRY_POSTPONE_002', 'DEFUSION_003', 'THOUGHT_FACTS_001', 'REG_GROUND_001'],
    anger_escalation: ['ANGER_TIMEOUT_001', 'ANGER_THERMOMETER_002', 'ANGER_CHAIN_003', 'REG_GROUND_001', 'NEED_NAME_001'],
    people_pleasing: ['BOUNDARY_001', 'NO_TOLERATE_002', 'NEED_NAME_001', 'REQUEST_DIRECT_001'],
    control_overdrive: ['CONTROL_CIRCLE_001', 'BAL_CONTROL_RESP_002', 'LOAD_SORT_001', 'PROBLEM_SOLVE_001', 'REG_MOVE_002'],
    thought_fusion: ['THOUGHT_FACTS_001', 'DEFUSION_003', 'RUMINATION_EXIT_001'],
    unmet_need: ['NEED_NAME_001', 'NEED_STRATEGY_002', 'REQUEST_DIRECT_001'],
    conflict_cycle: ['EMO_CHAIN_002', 'REQUEST_DIRECT_001', 'NEED_NAME_001', 'ANGER_TIMEOUT_001'],
    practical_problem: ['PROBLEM_SOLVE_001', 'CONTROL_CIRCLE_001', 'LOAD_SORT_001', 'THOUGHT_FACTS_001'],
    unknown: [],
  };

  const byNeed: Partial<Record<CoachingNeed, string[]>> = {
    regulation: ['REG_GROUND_001', 'REG_BREATHE_003', 'REG_MOVE_002'],
    connection: ['NEED_NAME_001', 'ATT_TRIGGER_001', 'REQUEST_DIRECT_001'],
    rest: ['REST_RECOVERY_001', 'LOAD_SORT_001', 'REG_MOVE_002'],
    respect: ['BOUNDARY_001', 'REQUEST_DIRECT_001'],
    boundary: ['BOUNDARY_001', 'NO_TOLERATE_002', 'NEED_NAME_001'],
    decision: ['PROBLEM_SOLVE_001', 'CONTROL_CIRCLE_001', 'FI_TIME_DISTANCE_002'],
    clarity: ['THOUGHT_FACTS_001', 'EMO_CHAIN_002', 'PROBLEM_SOLVE_001'],
    understanding: ['EMO_NAME_001', 'NEED_NAME_001', 'THOUGHT_FACTS_001'],
    support: ['NEED_NAME_001', 'REQUEST_DIRECT_001'],
    autonomy: ['BOUNDARY_001', 'CONTROL_CIRCLE_001', 'PROBLEM_SOLVE_001'],
    unknown: ['EMO_NAME_001', 'NEED_NAME_001', 'THOUGHT_FACTS_001'],
  };

  const result: string[] = [];
  for (const code of [...(byPattern[pattern] ?? []), ...(byNeed[need] ?? [])]) {
    if (!result.includes(code)) result.push(code);
    if (result.length === 6) break;
  }
  return result;
}

export function routeMessage(message: string, _context: unknown): RoutingResult {
  const text = message.trim();
  if (contains(text, immediateRiskPatterns)) {
    return {
      mode: 'safety',
      state: 'high_activation',
      need: 'safety',
      pattern: 'unknown',
      patternConfidence: 'low',
      candidateCodes: [],
      journeyDomainId: null,
    };
  }

  const state = inferState(text);
  const need = inferNeed(text, state);
  const { pattern, confidence } = inferPattern(text);
  return {
    mode: 'coach',
    state,
    need,
    pattern,
    patternConfidence: confidence,
    candidateCodes: candidateCodes(state, need, pattern),
    journeyDomainId: journeyForPattern(pattern),
  };
}
