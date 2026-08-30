import type { CandidateObservation } from './types.ts';

function asObject(raw: unknown): Record<string, unknown> | null {
  if (!raw || typeof raw !== 'object' || Array.isArray(raw)) return null;
  return raw as Record<string, unknown>;
}

function boolAt(object: Record<string, unknown>, path: string[]): boolean | undefined {
  let current: unknown = object;
  for (const key of path) {
    if (!current || typeof current !== 'object' || Array.isArray(current)) return undefined;
    current = (current as Record<string, unknown>)[key];
  }
  return typeof current === 'boolean' ? current : undefined;
}

export function analysisPermitted(context: unknown): boolean {
  const object = asObject(context);
  if (!object) return true;
  if (object.analysisAllowed === false) return false;
  if (boolAt(object, ['privacyScope','patternAnalysis']) === false) return false;
  if (boolAt(object, ['privacyScope','analysis']) === false) return false;
  if (object.allowPatterns === false) return false;
  const sourceType = typeof object.sourceType === 'string' ? object.sourceType : '';
  const journalMode = typeof object.journalMode === 'string' ? object.journalMode : '';
  if (sourceType === 'journal' && journalMode === 'private') return false;
  return true;
}

function text(value: unknown, max = 500): string | null {
  if (typeof value !== 'string') return null;
  const cleaned = value.replace(/\s+/g,' ').trim();
  if (!cleaned) return null;
  return cleaned.slice(0,max);
}

function evidenceText(value: unknown, max = 500): string | null {
  const cleaned = text(value,max);
  if (!cleaned) return null;
  if (/^(?:تشخيص|diagnosis)\s*:/i.test(cleaned)) return null;
  if (/^(?:أنتِ|انتي|هي)\s+(?:مصابة|تعانين|تعاني)\s+(?:من\s+)?(?:اضطراب|مرض)/i.test(cleaned)) return null;
  if (/^(?:أكيد|حتماً|حتما)\s+(?:هذا|هاد).*بسبب\s+(?:طفولتك|الماضي)/i.test(cleaned)) return null;
  return cleaned;
}

function intensity(value: unknown): number | null {
  if (typeof value !== 'number' || !Number.isInteger(value) || value < 0 || value > 10) return null;
  return value;
}

function nonNegativeInt(value: unknown): number | null {
  if (typeof value !== 'number' || !Number.isInteger(value) || value < 0) return null;
  return value;
}

function stringArray(value: unknown, maxItems = 8): string[] {
  if (!Array.isArray(value)) return [];
  return value.map((item)=>text(item,120)).filter((item): item is string => Boolean(item)).slice(0,maxItems);
}

export function sanitizeObservation(raw: unknown, context: unknown): CandidateObservation | null {
  if (!analysisPermitted(context)) return null;
  const object = asObject(raw);
  if (!object) return null;

  const sourceType = text(object.sourceType,60) ?? 'malaak_message';
  const result: CandidateObservation = {
    sourceType,
    sourceId: text(object.sourceId,120),
    occurredAt: text(object.occurredAt,80),
    contextDomain: text(object.contextDomain,80) ?? 'self',
    trigger: evidenceText(object.trigger),
    eventFact: evidenceText(object.eventFact),
    automaticThought: text(object.automaticThought),
    emotion: text(object.emotion,120),
    intensityBefore: intensity(object.intensityBefore),
    bodySignals: stringArray(object.bodySignals),
    urge: text(object.urge,300),
    need: text(object.need,160),
    behavior: evidenceText(object.behavior),
    outcome: evidenceText(object.outcome),
    intensityAfter: intensity(object.intensityAfter),
    recoveryMinutes: nonNegativeInt(object.recoveryMinutes),
    interventionHelpfulness: text(object.interventionHelpfulness,120),
  };

  const informative = [result.trigger,result.eventFact,result.automaticThought,result.emotion,result.behavior,result.outcome]
    .some((value)=>Boolean(value));
  return informative ? result : null;
}

export function parseCandidateObservationText(textPayload: string, context: unknown): CandidateObservation | null {
  try {
    return sanitizeObservation(JSON.parse(textPayload), context);
  } catch {
    return null;
  }
}
