export interface FormulationObservationRow {
  id: string;
  occurred_at?: string;
  context_domain?: string;
  emotion?: string | null;
  need?: string | null;
  trigger?: string | null;
  outcome?: string | null;
  extraction_origin?: string;
  confirmed_by_user?: boolean;
}

export interface FormulationHypothesisRow {
  id: string;
  domain: string;
  pattern_key: string;
  statement_ar: string;
  status: string;
  confidence_label: string;
  user_validation?: string | null;
}

export interface EvidencePatternEntry {
  domain: string;
  patternKey: string;
  statementAr: string;
  evidenceStatus: 'repeated' | 'user_validated';
  confidenceLabel: string;
}

export interface UnknownEntry {
  kind: 'candidate_hypothesis' | 'rejected_hypothesis' | 'dormant_hypothesis' | 'not_yet_known';
  patternKey?: string;
  statementAr: string;
}

export interface FormulationSnapshot {
  primary_context: string | null;
  current_state_summary: string;
  vulnerability_factors: unknown[];
  trigger_patterns: EvidencePatternEntry[];
  interpretation_patterns: EvidencePatternEntry[];
  emotion_patterns: EvidencePatternEntry[];
  need_patterns: EvidencePatternEntry[];
  behavior_patterns: EvidencePatternEntry[];
  short_term_consequences: unknown[];
  long_term_consequences: unknown[];
  protective_factors: unknown[];
  current_goals: string[];
  validated_insights: EvidencePatternEntry[];
  unknowns: UnknownEntry[];
}

export interface ActiveFormulationRecord {
  id: string;
  version: number;
  snapshot: FormulationSnapshot;
}

export interface FormulationVersionRequest {
  archiveId: string | null;
  insert: Record<string, unknown>;
}

const TRIGGER_PATTERNS = new Set(['attachment_alarm', 'practical_problem']);
const INTERPRETATION_PATTERNS = new Set(['thought_fusion']);
const EMOTION_PATTERNS = new Set(['anger_escalation']);
const NEED_PATTERNS = new Set(['unmet_need']);
const BEHAVIOR_PATTERNS = new Set(['reassurance_loop', 'rumination', 'people_pleasing', 'control_overdrive', 'conflict_cycle']);

function cleanText(value: unknown): string | null {
  if (typeof value !== 'string') return null;
  const result = value.replace(/\s+/g, ' ').trim();
  return result || null;
}

function uniqueStrings(values: unknown[]): string[] {
  const result: string[] = [];
  for (const value of values) {
    const cleaned = cleanText(value);
    if (cleaned && !result.includes(cleaned)) result.push(cleaned);
  }
  return result;
}

function primaryContext(observations: FormulationObservationRow[]): string | null {
  const counts = new Map<string, number>();
  for (const observation of observations) {
    const context = cleanText(observation.context_domain);
    if (!context) continue;
    counts.set(context, (counts.get(context) ?? 0) + 1);
  }
  return [...counts.entries()]
    .sort((a, b) => b[1] - a[1] || a[0].localeCompare(b[0]))[0]?.[0] ?? null;
}

function activeEvidenceEntry(hypothesis: FormulationHypothesisRow): EvidencePatternEntry | null {
  if (hypothesis.status !== 'repeated' && hypothesis.status !== 'user_validated') return null;
  const statementAr = cleanText(hypothesis.statement_ar);
  if (!statementAr) return null;
  return {
    domain: cleanText(hypothesis.domain) ?? 'self',
    patternKey: cleanText(hypothesis.pattern_key) ?? 'unknown',
    statementAr,
    evidenceStatus: hypothesis.status,
    confidenceLabel: cleanText(hypothesis.confidence_label) ?? 'low',
  };
}

function sortedEntries(entries: EvidencePatternEntry[]): EvidencePatternEntry[] {
  return [...entries].sort((a, b) =>
    a.domain.localeCompare(b.domain) || a.patternKey.localeCompare(b.patternKey) || a.statementAr.localeCompare(b.statementAr)
  );
}

function unknownEntries(hypotheses: FormulationHypothesisRow[]): UnknownEntry[] {
  const result: UnknownEntry[] = [];
  for (const hypothesis of hypotheses) {
    if (hypothesis.status === 'repeated' || hypothesis.status === 'user_validated') continue;
    const statementAr = cleanText(hypothesis.statement_ar);
    const patternKey = cleanText(hypothesis.pattern_key) ?? undefined;
    if (!statementAr) continue;
    if (hypothesis.status === 'user_rejected') {
      result.push({ kind: 'rejected_hypothesis', patternKey, statementAr });
    } else if (hypothesis.status === 'dormant') {
      result.push({ kind: 'dormant_hypothesis', patternKey, statementAr });
    } else {
      result.push({ kind: 'candidate_hypothesis', patternKey, statementAr });
    }
  }
  if (!result.length) {
    result.push({
      kind: 'not_yet_known',
      statementAr: 'ما زالت بعض العلاقات بين المحفزات والاحتياجات والسلوك غير محسومة من البيانات الحالية.',
    });
  }
  return result.sort((a, b) => (a.patternKey ?? '').localeCompare(b.patternKey ?? '') || a.statementAr.localeCompare(b.statementAr));
}

export function buildFormulationSnapshot(args: {
  observations: FormulationObservationRow[];
  hypotheses: FormulationHypothesisRow[];
  goals: string[];
}): FormulationSnapshot {
  const evidence = args.hypotheses.map(activeEvidenceEntry).filter((entry): entry is EvidencePatternEntry => Boolean(entry));
  const byPattern = (patterns: Set<string>) => sortedEntries(evidence.filter((entry) => patterns.has(entry.patternKey)));
  const validated = sortedEntries(evidence.filter((entry) => entry.evidenceStatus === 'user_validated'));
  return {
    primary_context: primaryContext(args.observations),
    current_state_summary: 'هذه صياغة عمل مؤقتة مبنية على البيانات التي سمحتِ باستخدامها؛ تساعد ملاك على ترتيب الأولويات وليست تشخيصًا أو حقيقة نهائية عنك.',
    vulnerability_factors: [],
    trigger_patterns: byPattern(TRIGGER_PATTERNS),
    interpretation_patterns: byPattern(INTERPRETATION_PATTERNS),
    emotion_patterns: byPattern(EMOTION_PATTERNS),
    need_patterns: byPattern(NEED_PATTERNS),
    behavior_patterns: byPattern(BEHAVIOR_PATTERNS),
    short_term_consequences: [],
    long_term_consequences: [],
    protective_factors: [],
    current_goals: uniqueStrings(args.goals),
    validated_insights: validated,
    unknowns: unknownEntries(args.hypotheses),
  };
}

function canonical(value: unknown): string {
  if (Array.isArray(value)) return `[${value.map(canonical).sort().join(',')}]`;
  if (value && typeof value === 'object') {
    const object = value as Record<string, unknown>;
    return `{${Object.keys(object).sort().map((key) => `${JSON.stringify(key)}:${canonical(object[key])}`).join(',')}}`;
  }
  return JSON.stringify(value);
}

const MATERIAL_KEYS: Array<keyof FormulationSnapshot> = [
  'primary_context',
  'vulnerability_factors',
  'trigger_patterns',
  'interpretation_patterns',
  'emotion_patterns',
  'need_patterns',
  'behavior_patterns',
  'short_term_consequences',
  'long_term_consequences',
  'protective_factors',
  'current_goals',
  'validated_insights',
];

export function isMaterialFormulationChange(previous: FormulationSnapshot, next: FormulationSnapshot): boolean {
  return MATERIAL_KEYS.some((key) => canonical(previous[key]) !== canonical(next[key]));
}

export function buildFormulationVersionRequest(args: {
  userId: string;
  previous: ActiveFormulationRecord | null;
  next: FormulationSnapshot;
}): FormulationVersionRequest | null {
  if (args.previous && !isMaterialFormulationChange(args.previous.snapshot, args.next)) return null;
  const version = (args.previous?.version ?? 0) + 1;
  return {
    archiveId: args.previous?.id ?? null,
    insert: {
      user_id: args.userId,
      version,
      status: 'active',
      ...args.next,
    },
  };
}
