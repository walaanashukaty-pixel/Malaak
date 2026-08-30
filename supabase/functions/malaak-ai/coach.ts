import type { CatalogIntervention, CoachingPayload, RoutingResult } from './types.ts';
import { analysisPermitted, sanitizeObservation } from './observation.ts';

const followUpTimings = new Set(['later_today', 'tomorrow', 'after_event', 'none']);

function asObject(raw: unknown): Record<string, unknown> | null {
  if (!raw || typeof raw !== 'object' || Array.isArray(raw)) return null;
  return raw as Record<string, unknown>;
}

function cleanString(value: unknown, fallback = ''): string {
  return typeof value === 'string' && value.trim() ? value.trim() : fallback;
}

function activeEligible(cards: CatalogIntervention[]): CatalogIntervention[] {
  return cards.filter((card) => card.status === 'active' && card.evidenceTier !== 'X');
}

function followUpTimingFor(code: string, card?: CatalogIntervention): CoachingPayload['followUp']['timing'] {
  const configured = card?.followUpSpec?.timing;
  if (typeof configured === 'string' && followUpTimings.has(configured)) {
    return configured as CoachingPayload['followUp']['timing'];
  }
  if (code === 'REQUEST_DIRECT_001' || code === 'ANGER_TIMEOUT_001' || code === 'BOUNDARY_001') {
    return 'after_event';
  }
  if (code.startsWith('REG_') || code === 'UNCERTAINTY_001' || code === 'RUMINATION_EXIT_001') {
    return 'later_today';
  }
  return 'tomorrow';
}

export function safetyPayload(route: RoutingResult): CoachingPayload {
  return {
    mode: 'safety',
    state: 'high_activation',
    need: 'safety',
    pattern: route.pattern,
    patternConfidence: route.patternConfidence,
    goal: 'حماية الأمان الآن',
    interventionCode: null,
    interventionVersion: null,
    interventionId: null,
    reply:
      'اللي عم تحكيه ممكن يكون فيه خطر حقيقي، وهون الأولوية مو تحليل الموقف. ابتعدي عن مصدر الخطر قدر الإمكان، وخلي شخص موثوق قريب منك يعرف شو عم يصير. إذا في خطر مباشر عليكِ أو على شخص ثاني، تواصلي فورًا مع الطوارئ المحلية أو دعم بشري مناسب.',
    action: 'ركّزي الآن على مسافة آمنة ودعم بشري مباشر بدل متابعة الخلاف أو التحليل.',
    followUp: {
      timing: 'none',
      prompt: 'هل أنتِ بمكان آمن حاليًا؟',
      journeyDomainId: null,
    },
    observation: null,
  };
}

export function deterministicFallback(
  route: RoutingResult,
  eligible: CatalogIntervention[] = [],
): CoachingPayload {
  if (route.mode === 'safety') return safetyPayload(route);

  const card = activeEligible(eligible)[0];
  if (!card) {
    return {
      mode: 'fallback',
      state: route.state,
      need: route.need,
      pattern: route.pattern,
      patternConfidence: route.patternConfidence,
      goal: 'نفهم خطوة واحدة بدل ما نحل كل شي مرة وحدة',
      interventionCode: null,
      interventionVersion: null,
      interventionId: null,
      reply: 'فهمت عليكِ. خلينا ما نفترض سبب أو تشخيص من موقف واحد؛ رتبيلي شو صار كحقيقة وشو أكتر شي مزعجك فيه.',
      action: 'اكتبي حقيقة واحدة عن الموقف وشيئًا واحدًا تحتاجينه الآن.',
      followUp: { timing: 'none', prompt: '', journeyDomainId: route.journeyDomainId },
      observation: null,
    };
  }

  const configuredPrompt = card.followUpSpec?.prompt;
  return {
    mode: 'fallback',
    state: route.state,
    need: route.need,
    pattern: route.pattern,
    patternConfidence: route.patternConfidence,
    goal: route.state === 'high_activation' ? 'خفض الاستنفار قبل التصرف' : 'اختيار استجابة أوضح للموقف',
    interventionCode: card.code,
    interventionVersion: card.version,
    interventionId: card.id,
    reply: `خلينا ناخدها بخطوة صغيرة. الأنسب هلق هو «${card.titleAr}» بدل ما نحاول نحل كل القصة دفعة واحدة.`,
    action: card.actionTemplate,
    followUp: {
      timing: followUpTimingFor(card.code, card),
      prompt: typeof configuredPrompt === 'string' && configuredPrompt.trim()
        ? configuredPrompt.trim()
        : 'شو صار بعد ما جربتي الخطوة؟ وهل ساعدتك ولو شوي؟',
      journeyDomainId: route.journeyDomainId ?? card.journeyDomains[0] ?? null,
    },
    observation: null,
  };
}

export function validateCoachingTurn(
  raw: unknown,
  route: RoutingResult,
  eligible: CatalogIntervention[] = [],
  context: unknown = {},
): CoachingPayload {
  if (route.mode === 'safety') return safetyPayload(route);
  const cards = activeEligible(eligible);
  const object = asObject(raw);
  if (!object) return deterministicFallback(route, cards);

  const code = cleanString(object.interventionCode);
  const card = cards.find((candidate) => candidate.code === code);
  if (!card) return deterministicFallback(route, cards);

  const fallback = deterministicFallback(route, cards);
  const followRaw = asObject(object.followUp);
  const requestedTiming = cleanString(followRaw?.timing, fallback.followUp.timing);
  const timing = followUpTimings.has(requestedTiming)
    ? requestedTiming as CoachingPayload['followUp']['timing']
    : fallback.followUp.timing;

  return {
    mode: 'coach',
    state: route.state,
    need: route.need,
    pattern: route.pattern,
    patternConfidence: route.patternConfidence,
    goal: cleanString(object.goal, fallback.goal),
    interventionCode: card.code,
    interventionVersion: card.version,
    interventionId: card.id,
    reply: cleanString(object.reply, fallback.reply),
    action: cleanString(object.action, card.actionTemplate),
    followUp: {
      timing,
      prompt: timing === 'none' ? '' : cleanString(followRaw?.prompt, fallback.followUp.prompt),
      journeyDomainId: route.journeyDomainId ?? card.journeyDomains[0] ?? null,
    },
    observation: sanitizeObservation(object.observation, context),
  };
}

function observationSchema(): Record<string, unknown> {
  const nullableString = { type: ['string','null'] };
  const nullableInt = { type: ['integer','null'] };
  return {
    anyOf: [
      { type: 'null' },
      {
        type: 'object',
        additionalProperties: false,
        required: [
          'sourceType','sourceId','occurredAt','contextDomain','trigger','eventFact','automaticThought','emotion',
          'intensityBefore','bodySignals','urge','need','behavior','outcome','intensityAfter','recoveryMinutes','interventionHelpfulness',
        ],
        properties: {
          sourceType: { type: 'string' },
          sourceId: nullableString,
          occurredAt: nullableString,
          contextDomain: { type: 'string' },
          trigger: nullableString,
          eventFact: nullableString,
          automaticThought: nullableString,
          emotion: nullableString,
          intensityBefore: nullableInt,
          bodySignals: { type: 'array', items: { type: 'string' } },
          urge: nullableString,
          need: nullableString,
          behavior: nullableString,
          outcome: nullableString,
          intensityAfter: nullableInt,
          recoveryMinutes: nullableInt,
          interventionHelpfulness: nullableString,
        },
      },
    ],
  };
}

function responseSchema(route: RoutingResult, eligible: CatalogIntervention[]): Record<string, unknown> {
  const candidateCodes = activeEligible(eligible).map((card) => card.code);
  const domainIds = [
    route.journeyDomainId,
    ...activeEligible(eligible).flatMap((card) => card.journeyDomains),
    null,
  ].filter((value, index, all) => all.indexOf(value) === index);
  return {
    type: 'object',
    additionalProperties: false,
    required: [
      'mode', 'state', 'need', 'pattern', 'patternConfidence', 'goal',
      'interventionCode', 'reply', 'action', 'followUp', 'observation',
    ],
    properties: {
      mode: { type: 'string', enum: ['coach'] },
      state: { type: 'string', enum: [route.state] },
      need: { type: 'string', enum: [route.need] },
      pattern: { type: 'string', enum: [route.pattern] },
      patternConfidence: { type: 'string', enum: [route.patternConfidence] },
      goal: { type: 'string' },
      interventionCode: { type: 'string', enum: candidateCodes },
      reply: { type: 'string' },
      action: { type: 'string' },
      observation: observationSchema(),
      followUp: {
        type: 'object',
        additionalProperties: false,
        required: ['timing', 'prompt', 'journeyDomainId'],
        properties: {
          timing: { type: 'string', enum: ['later_today', 'tomorrow', 'after_event', 'none'] },
          prompt: { type: 'string' },
          journeyDomainId: { enum: domainIds },
        },
      },
    },
  };
}

function extractOutputText(payload: any): string {
  if (typeof payload?.output_text === 'string' && payload.output_text.trim()) return payload.output_text.trim();
  for (const item of payload?.output ?? []) {
    for (const content of item?.content ?? []) {
      if (content?.type === 'output_text' && typeof content?.text === 'string' && content.text.trim()) {
        return content.text.trim();
      }
    }
  }
  return '';
}

export async function requestStructuredCoaching(args: {
  apiKey: string;
  model: string;
  message: string;
  context: unknown;
  route: RoutingResult;
  eligible: CatalogIntervention[];
}): Promise<CoachingPayload> {
  const cards = activeEligible(args.eligible);
  if (!cards.length) return deterministicFallback(args.route, cards);

  const allowedTools = cards.map((card) => ({
    code: card.code,
    version: card.version,
    titleAr: card.titleAr,
    framework: card.framework,
    targetNeeds: card.targetNeeds,
    targetPatterns: card.targetPatterns,
    steps: card.steps,
    actionTemplate: card.actionTemplate,
    exclusions: card.exclusions,
    contraindicationNotesAr: card.contraindicationNotesAr,
  }));
  const contextText = JSON.stringify(args.context ?? {}).slice(0, 14000);
  const canAnalyze = analysisPermitted(args.context);
  const toolsText = JSON.stringify(allowedTools).slice(0, 12000);
  const systemPrompt = `أنتِ "ملاك"، مدربة رقمية عربية للاتزان النفسي والسلوكي والعلاقات. لستِ طبيبة أو معالجة، ولا تشخصين الأمراض.

الراوتر الحتمي حدد هذه الحالة الأولية:
state=${args.route.state}; need=${args.route.need}; pattern=${args.route.pattern}; confidence=${args.route.patternConfidence}.
اعتبري pattern فرضية عمل وليست حقيقة أو تشخيصاً.

مسموح لك اختيار أداة واحدة فقط من القائمة التالية. اختاري code فقط؛ الخادم هو المصدر الوحيد الموثوق للنسخة والمعرّف، وممنوع اختراع تمرين أو تقنية خارجها:
${toolsText}

قواعد الحوار:
- ثبتي الشعور بدون تأكيد استنتاج غير مثبت عن نوايا الآخرين.
- إذا كان الاستنفار مرتفعاً، اجعلي الرد قصيراً وركزي على التنظيم قبل التحليل.
- لا تعطي طمأنة متكررة تغذي التعلق أو الوسواس، ولا تخترعي ذكريات أو أسباب طفولة.
- لا تفرضي الطلاق أو الرجوع أو التسامح أو قراراً مصيرياً.
- اجعلي action خطوة واقعية واحدة أو اثنتين كحد أقصى.
- followUp لازم يقيس ماذا حدث بعد الخطوة، وليس مجرد سؤال عام.
- اكتبي عربية دافئة وواضحة قريبة من الشامية بدون تدليل طفولي.
- observation هو تلخيص منظم لما قالته المستخدمة عن حدث/فكر/شعور/سلوك فقط، وليس تشخيصًا أو تفسيرًا سببيًا. إذا ما في حدث واضح أو التحليل غير مسموح، رجعي observation=null.

حالة السماح باستخراج ملاحظة منظمة: ${canAnalyze ? 'مسموح' : 'غير مسموح — observation لازم يكون null'}.
استخدمي فقط السياق الذي سمحت المستخدمة بمشاركته:
${contextText}`;

  const response = await fetch('https://api.openai.com/v1/responses', {
    method: 'POST',
    headers: { Authorization: `Bearer ${args.apiKey}`, 'Content-Type': 'application/json' },
    body: JSON.stringify({
      model: args.model,
      reasoning: { effort: 'low' },
      max_output_tokens: 800,
      input: [
        { role: 'system', content: [{ type: 'input_text', text: systemPrompt }] },
        { role: 'user', content: [{ type: 'input_text', text: args.message }] },
      ],
      text: {
        format: {
          type: 'json_schema',
          name: 'malaak_coaching_turn',
          strict: true,
          schema: responseSchema(args.route, cards),
        },
      },
    }),
  });

  const payload = await response.json();
  if (!response.ok) {
    console.error('OpenAI response error', response.status, payload);
    return deterministicFallback(args.route, cards);
  }
  const text = extractOutputText(payload);
  if (!text) return deterministicFallback(args.route, cards);
  try {
    return validateCoachingTurn(JSON.parse(text), args.route, cards, args.context);
  } catch {
    return deterministicFallback(args.route, cards);
  }
}
