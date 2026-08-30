import { evaluateHypothesisEvidence, type EvidenceObservation, type HypothesisDecision } from './hypothesis_engine.ts';
import { buildFormulationSnapshot, buildFormulationVersionRequest, type FormulationSnapshot } from './formulation.ts';
import type { CandidateObservation, CoachingPayload, RoutingResult } from './types.ts';

export interface ExistingHypothesisRow {
  id?: string;
  status?: string;
  confidence_label?: string;
  user_validation?: 'yes' | 'partly' | 'no' | null;
  rejected_at?: string | null;
  supporting_observation_ids?: string[];
  contradicting_observation_ids?: string[];
}

export interface HypothesisDescriptor {
  domain: string;
  patternKey: string;
  statementAr: string;
}

export interface HypothesisMutation {
  row: Record<string, unknown>;
  decision: HypothesisDecision;
}

export interface PersistenceResult {
  observationId: string | null;
  hypothesisId: string | null;
  hypothesisStatus: string | null;
}

const DESCRIPTORS: Record<string, HypothesisDescriptor> = {
  attachment_alarm: {
    domain: 'attachment', patternKey: 'attachment_alarm',
    statementAr: 'المسافة أو تأخر التواصل قد يفعّل إنذارًا عاطفيًا أو خوفًا في بعض المواقف.',
  },
  reassurance_loop: {
    domain: 'attachment', patternKey: 'reassurance_loop',
    statementAr: 'عند عدم اليقين قد يظهر فحص أو طلب طمأنة متكرر يعطي راحة قصيرة ثم يعيد القلق.',
  },
  rumination: {
    domain: 'overthinking', patternKey: 'rumination',
    statementAr: 'عند الضغط قد يدخل التفكير في حلقة متكررة بدون معلومة جديدة أو خطوة عملية.',
  },
  anger_escalation: {
    domain: 'anger', patternKey: 'anger_escalation',
    statementAr: 'الغضب قد يتصاعد بسرعة في بعض المواقف قبل أن تتاح مساحة كافية للاختيار.',
  },
  people_pleasing: {
    domain: 'needs', patternKey: 'people_pleasing',
    statementAr: 'الخوف من عدم رضا الآخرين قد يجعل قول لا أو وضع الحدود أصعب في بعض السياقات.',
  },
  control_overdrive: {
    domain: 'feminine-balance', patternKey: 'control_overdrive',
    statementAr: 'عند الضغط قد تزيد محاولة التحكم أو حمل المسؤولية كلها بدل توزيعها بمرونة.',
  },
  thought_fusion: {
    domain: 'overthinking', patternKey: 'thought_fusion',
    statementAr: 'في بعض المواقف قد يندمج تفسير العقل مع الحدث وكأنه حقيقة مؤكدة.',
  },
  unmet_need: {
    domain: 'needs', patternKey: 'unmet_need',
    statementAr: 'قد يصعب أحيانًا تسمية الحاجة قبل أن تتحول إلى توتر أو سلوك غير مباشر.',
  },
  conflict_cycle: {
    domain: 'relationship', patternKey: 'conflict_cycle',
    statementAr: 'بعض الخلافات قد تتحول إلى دائرة متكررة من ردود الأفعال بدل حل المشكلة نفسها.',
  },
  practical_problem: {
    domain: 'inner-peace', patternKey: 'practical_problem',
    statementAr: 'تراكم المشاكل العملية المفتوحة قد يرفع الحمل الذهني ويزيد الإحساس بالفوضى.',
  },
};

function isoOrNow(value: string): string {
  const ms = Date.parse(value);
  return Number.isFinite(ms) ? new Date(ms).toISOString() : new Date().toISOString();
}

function nonEmpty(value: string | null): string | null {
  return typeof value === 'string' && value.trim() ? value.trim() : null;
}

export function mergeObservationIds(existing: readonly string[] | null | undefined, nextId: string): string[] {
  const result = [...(existing ?? [])].filter((value, index, all) => typeof value === 'string' && value && all.indexOf(value) === index);
  if (nextId && !result.includes(nextId)) result.push(nextId);
  return result;
}

export function patternDescriptorForRoute(route: RoutingResult): HypothesisDescriptor | null {
  if (route.mode !== 'coach' || route.pattern === 'unknown') return null;
  return DESCRIPTORS[route.pattern] ?? null;
}

export function buildModelObservationRow(args: {
  userId: string;
  observation: CandidateObservation;
  turn: CoachingPayload;
  now: string;
}): Record<string, unknown> {
  const { userId, observation, turn } = args;
  return {
    user_id: userId,
    source_type: 'malaak_message',
    source_id: null,
    occurred_at: isoOrNow(args.now),
    context_domain: nonEmpty(observation.contextDomain) ?? 'self',
    trigger: nonEmpty(observation.trigger),
    event_fact: nonEmpty(observation.eventFact),
    automatic_thought: nonEmpty(observation.automaticThought),
    emotion: nonEmpty(observation.emotion),
    intensity_before: observation.intensityBefore,
    body_signals: [...observation.bodySignals],
    urge: nonEmpty(observation.urge),
    need: nonEmpty(observation.need),
    behavior: nonEmpty(observation.behavior),
    outcome: nonEmpty(observation.outcome),
    intensity_after: observation.intensityAfter,
    recovery_minutes: observation.recoveryMinutes,
    intervention_code: turn.interventionCode,
    intervention_version: turn.interventionVersion,
    intervention_helpfulness: nonEmpty(observation.interventionHelpfulness),
    extraction_origin: 'model_extracted',
    confirmed_by_user: false,
  };
}

export function buildHypothesisMutation(args: {
  userId: string;
  route: RoutingResult;
  existing: ExistingHypothesisRow | null;
  supporting: EvidenceObservation[];
  contradicting: EvidenceObservation[];
  now: string;
  activeJourneyLinked: boolean;
  strongContradiction?: boolean;
}): HypothesisMutation | null {
  const descriptor = patternDescriptorForRoute(args.route);
  if (!descriptor) return null;
  const existing = args.existing;
  const decision = evaluateHypothesisEvidence({
    supporting: args.supporting,
    contradicting: args.contradicting,
    userValidation: existing?.user_validation ?? null,
    rejectedAt: existing?.rejected_at ?? null,
    strongContradiction: args.strongContradiction === true,
    activeJourneyLinked: args.activeJourneyLinked,
    now: args.now,
  });
  return {
    decision,
    row: {
      user_id: args.userId,
      domain: descriptor.domain,
      pattern_key: descriptor.patternKey,
      statement_ar: descriptor.statementAr,
      status: decision.status,
      confidence_label: decision.confidenceLabel,
      supporting_observation_ids: [...decision.supportingObservationIds],
      contradicting_observation_ids: [...decision.contradictingObservationIds],
      support_count: decision.supportCount,
      distinct_days: decision.distinctDays,
      distinct_contexts: decision.distinctContexts,
      first_seen_at: decision.firstSeenAt ?? isoOrNow(args.now),
      last_seen_at: decision.lastSeenAt ?? isoOrNow(args.now),
      user_validation: existing?.user_validation ?? null,
      rejected_at: existing?.rejected_at ?? null,
      updated_at: isoOrNow(args.now),
    },
  };
}

function envValue(name: string): string {
  const env = (globalThis as any).Deno?.env;
  return env?.get?.(name) ?? '';
}

function restHeaders(prefer?: string): Record<string, string> {
  const serviceRole = envValue('SUPABASE_SERVICE_ROLE_KEY');
  const headers: Record<string, string> = {
    apikey: serviceRole,
    Authorization: `Bearer ${serviceRole}`,
    'Content-Type': 'application/json',
  };
  if (prefer) headers.Prefer = prefer;
  return headers;
}

async function restJson(path: string, init: RequestInit): Promise<unknown> {
  const baseUrl = envValue('SUPABASE_URL');
  const serviceRole = envValue('SUPABASE_SERVICE_ROLE_KEY');
  if (!baseUrl || !serviceRole) throw new Error('formulation_repository_configuration_missing');
  const response = await fetch(`${baseUrl}/rest/v1/${path}`, init);
  const payload = await response.json().catch(() => null);
  if (!response.ok) throw new Error(`formulation_repository_failed:${response.status}:${JSON.stringify(payload)}`);
  return payload;
}

function rowArray(payload: unknown): Record<string, unknown>[] {
  return Array.isArray(payload) ? payload.filter((item): item is Record<string, unknown> => Boolean(item) && typeof item === 'object' && !Array.isArray(item)) : [];
}

function stringIds(value: unknown): string[] {
  if (!Array.isArray(value)) return [];
  return value.filter((item): item is string => typeof item === 'string' && item.length > 0);
}

function existingHypothesisFromRow(row: Record<string, unknown> | undefined): ExistingHypothesisRow | null {
  if (!row) return null;
  return {
    id: typeof row.id === 'string' ? row.id : undefined,
    status: typeof row.status === 'string' ? row.status : undefined,
    confidence_label: typeof row.confidence_label === 'string' ? row.confidence_label : undefined,
    user_validation: row.user_validation === 'yes' || row.user_validation === 'partly' || row.user_validation === 'no' ? row.user_validation : null,
    rejected_at: typeof row.rejected_at === 'string' ? row.rejected_at : null,
    supporting_observation_ids: stringIds(row.supporting_observation_ids),
    contradicting_observation_ids: stringIds(row.contradicting_observation_ids),
  };
}

function evidenceFromRows(rows: Record<string, unknown>[], wanted: Set<string>): EvidenceObservation[] {
  return rows.flatMap((row) => {
    const id = typeof row.id === 'string' ? row.id : '';
    const occurredAt = typeof row.occurred_at === 'string' ? row.occurred_at : '';
    if (!id || !wanted.has(id) || !occurredAt) return [];
    return [{
      id,
      occurredAt,
      contextDomain: typeof row.context_domain === 'string' ? row.context_domain : 'self',
    }];
  });
}


function formulationSnapshotFromRow(row: Record<string, unknown>): FormulationSnapshot {
  const array = (key: string): unknown[] => Array.isArray(row[key]) ? [...row[key] as unknown[]] : [];
  return {
    primary_context: typeof row.primary_context === 'string' ? row.primary_context : null,
    current_state_summary: typeof row.current_state_summary === 'string' ? row.current_state_summary : '',
    vulnerability_factors: array('vulnerability_factors'),
    trigger_patterns: array('trigger_patterns') as FormulationSnapshot['trigger_patterns'],
    interpretation_patterns: array('interpretation_patterns') as FormulationSnapshot['interpretation_patterns'],
    emotion_patterns: array('emotion_patterns') as FormulationSnapshot['emotion_patterns'],
    need_patterns: array('need_patterns') as FormulationSnapshot['need_patterns'],
    behavior_patterns: array('behavior_patterns') as FormulationSnapshot['behavior_patterns'],
    short_term_consequences: array('short_term_consequences'),
    long_term_consequences: array('long_term_consequences'),
    protective_factors: array('protective_factors'),
    current_goals: array('current_goals').filter((x): x is string => typeof x === 'string'),
    validated_insights: array('validated_insights') as FormulationSnapshot['validated_insights'],
    unknowns: array('unknowns') as FormulationSnapshot['unknowns'],
  };
}

export async function persistFormulationIfChanged(userId: string): Promise<{ id: string; version: number } | null> {
  const observationsPayload = await restJson(
    `malaak_observations?${new URLSearchParams({
      user_id:`eq.${userId}`,
      select:'id,occurred_at,context_domain,emotion,need,trigger,outcome,extraction_origin,confirmed_by_user',
      order:'occurred_at.desc',
      limit:'200',
    }).toString()}`,
    { method:'GET', headers:restHeaders() },
  );
  const hypothesesPayload = await restJson(
    `malaak_hypotheses?${new URLSearchParams({
      user_id:`eq.${userId}`,
      select:'id,domain,pattern_key,statement_ar,status,confidence_label,user_validation',
      order:'updated_at.desc',
    }).toString()}`,
    { method:'GET', headers:restHeaders() },
  );
  const initialMapPayload = await restJson(
    `malaak_initial_maps?${new URLSearchParams({user_id:`eq.${userId}`,select:'desired_change',limit:'1'}).toString()}`,
    { method:'GET', headers:restHeaders() },
  );
  const activePayload = await restJson(
    `malaak_formulations?${new URLSearchParams({
      user_id:`eq.${userId}`,status:'eq.active',select:'*',limit:'1',
    }).toString()}`,
    { method:'GET', headers:restHeaders() },
  );

  const observations = rowArray(observationsPayload);
  const hypotheses = rowArray(hypothesesPayload);
  const initialMap = rowArray(initialMapPayload)[0];
  const goals = typeof initialMap?.desired_change === 'string' && initialMap.desired_change.trim()
    ? [initialMap.desired_change.trim()] : [];
  const next = buildFormulationSnapshot({
    observations: observations as any,
    hypotheses: hypotheses as any,
    goals,
  });
  const active = rowArray(activePayload)[0];
  const previous = active && typeof active.id === 'string'
    ? {
        id: active.id,
        version: typeof active.version === 'number' ? active.version : Number(active.version ?? 0),
        snapshot: formulationSnapshotFromRow(active),
      }
    : null;
  const request = buildFormulationVersionRequest({ userId, previous, next });
  if (!request) {
    return previous ? { id: previous.id, version: previous.version } : null;
  }

  const storedPayload = await restJson('rpc/malaak_store_formulation_snapshot', {
    method:'POST',
    headers:restHeaders(),
    body:JSON.stringify({p_user_id:userId,p_snapshot:next}),
  });
  const stored = storedPayload && typeof storedPayload === 'object' && !Array.isArray(storedPayload)
    ? storedPayload as Record<string, unknown>
    : rowArray(storedPayload)[0];
  if (!stored || typeof stored.id !== 'string') throw new Error('formulation_store_missing_id');
  return { id: stored.id, version: typeof stored.version === 'number' ? stored.version : Number(stored.version ?? 0) };
}

export async function persistCoachingEvidence(args: {
  userId: string;
  route: RoutingResult;
  turn: CoachingPayload;
  now?: string;
  activeJourneyLinked?: boolean;
}): Promise<PersistenceResult> {
  if (!args.turn.observation) return { observationId: null, hypothesisId: null, hypothesisStatus: null };
  const now = isoOrNow(args.now ?? new Date().toISOString());
  const observationRow = buildModelObservationRow({ userId: args.userId, observation: args.turn.observation, turn: args.turn, now });
  const insertedPayload = await restJson('malaak_observations?select=id,occurred_at,context_domain', {
    method: 'POST', headers: restHeaders('return=representation'), body: JSON.stringify(observationRow),
  });
  const inserted = rowArray(insertedPayload)[0];
  const observationId = typeof inserted?.id === 'string' ? inserted.id : null;
  if (!observationId) throw new Error('observation_insert_missing_id');

  const descriptor = patternDescriptorForRoute(args.route);
  if (!descriptor) return { observationId, hypothesisId: null, hypothesisStatus: null };

  const hypothesisQuery = new URLSearchParams({
    user_id: `eq.${args.userId}`,
    domain: `eq.${descriptor.domain}`,
    pattern_key: `eq.${descriptor.patternKey}`,
    select: 'id,status,confidence_label,user_validation,rejected_at,supporting_observation_ids,contradicting_observation_ids',
    limit: '1',
  });
  const existingPayload = await restJson(`malaak_hypotheses?${hypothesisQuery.toString()}`, {
    method: 'GET', headers: restHeaders(),
  });
  const existing = existingHypothesisFromRow(rowArray(existingPayload)[0]);
  const supportIds = mergeObservationIds(existing?.supporting_observation_ids, observationId);
  const contradictionIds = [...(existing?.contradicting_observation_ids ?? [])];
  const allIds = [...new Set([...supportIds, ...contradictionIds])];

  let evidenceRows: Record<string, unknown>[] = [];
  if (allIds.length) {
    const idsFilter = `in.(${allIds.join(',')})`;
    const evidenceQuery = new URLSearchParams({
      user_id: `eq.${args.userId}`,
      id: idsFilter,
      select: 'id,occurred_at,context_domain',
    });
    const evidencePayload = await restJson(`malaak_observations?${evidenceQuery.toString()}`, {
      method: 'GET', headers: restHeaders(),
    });
    evidenceRows = rowArray(evidencePayload);
  }

  const mutation = buildHypothesisMutation({
    userId: args.userId,
    route: args.route,
    existing,
    supporting: evidenceFromRows(evidenceRows, new Set(supportIds)),
    contradicting: evidenceFromRows(evidenceRows, new Set(contradictionIds)),
    now,
    activeJourneyLinked: args.activeJourneyLinked === true,
  });
  if (!mutation) return { observationId, hypothesisId: null, hypothesisStatus: null };

  const hypothesisPayload = await restJson('malaak_hypotheses?on_conflict=user_id,domain,pattern_key&select=id,status', {
    method: 'POST',
    headers: restHeaders('resolution=merge-duplicates,return=representation'),
    body: JSON.stringify(mutation.row),
  });
  const hypothesis = rowArray(hypothesisPayload)[0];
  await persistFormulationIfChanged(args.userId);
  return {
    observationId,
    hypothesisId: typeof hypothesis?.id === 'string' ? hypothesis.id : existing?.id ?? null,
    hypothesisStatus: typeof hypothesis?.status === 'string' ? hypothesis.status : mutation.decision.status,
  };
}
