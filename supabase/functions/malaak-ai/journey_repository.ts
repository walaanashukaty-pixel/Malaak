import {
  buildJourneyPlan,
  type JourneyDomain,
  type JourneyPlannerInput,
  type PlannerHypothesis,
} from './journey_planner.ts';

export interface InitialMapRow {
  primary_concern?: string;
  desired_change?: string;
  life_context?: string;
  current_impact?: string;
  immediate_safety?: Record<string, unknown>;
}
export interface JourneyObservationRow {
  occurred_at?: string;
  context_domain?: string;
  intensity_before?: number | null;
}
export interface JourneyHypothesisRow {
  domain?: string;
  pattern_key?: string;
  status?: string;
  confidence_label?: string;
}
export interface StoredJourneyPlan {
  id: string;
  version: number;
  primaryDomain: JourneyDomain | null;
  primaryGoal: string | null;
  supportDomain: JourneyDomain | null;
  supportGoal: string | null;
  monitorDomains: JourneyDomain[];
  laterDomains: JourneyDomain[];
  reasoningSummaryAr: string;
  basedOnFormulationVersion: number;
  reviewDueAt: string;
  status: 'active' | 'maintenance' | 'paused';
}
export interface JourneyPlanVersionRequest {
  pauseId: string | null;
  insert: Record<string, unknown>;
}

const VALID_DOMAINS = new Set<JourneyDomain>([
  'emotional-state','inner-peace','needs','childhood','attachment','relationship',
  'overthinking','anger','feminine-balance','feminine-intelligence','healing',
]);

function unique<T>(values: T[]): T[] {
  return values.filter((value, index, all) => all.indexOf(value) === index);
}

function domainsFromText(value: string): JourneyDomain[] {
  const text = (value ?? '').toLowerCase();
  const result: JourneyDomain[] = [];
  const add = (condition: boolean, domain: JourneyDomain) => { if (condition) result.push(domain); };
  add(/مشاعر|شو فيني|شو مالي|حالتي|خوف|حزن/.test(text), 'emotional-state');
  add(/فوضى|ضغط|استنزاف|منهك|راحة|نوم|حمل/.test(text), 'inner-peace');
  add(/احتياج|حاجتي|حدود|قول لا|أقول لا|ارضي الناس|أرضي الناس/.test(text), 'needs');
  add(/طفول|الماضي|جرح قديم|أهلي|اهلي/.test(text), 'childhood');
  add(/تعلق|هجر|يتركني|يتركني|ما رد|ما بيرد|يبعد|ابتعاد|مسافة/.test(text), 'attachment');
  add(/زواج|زوج|علاقتي|العلاقة|خلاف|تخانق/.test(text), 'relationship');
  add(/تفكير|راسي|اجترار|قلق|وسواس/.test(text), 'overthinking');
  add(/غضب|عصب|عصبي|انفجر|صرخ/.test(text), 'anger');
  add(/أنوث|انوث|سيطرة|وضع حرب|تحكم/.test(text), 'feminine-balance');
  add(/ذكاء أنثوي|ذكاء انثوي|الوقت والمسافة|النية/.test(text), 'feminine-intelligence');
  add(/خيانة|انفصال|كسر ثقة|جرح عاطفي|تشافي/.test(text), 'healing');
  return unique(result);
}

function activeForPlanner(status: string): boolean {
  return status === 'repeated' || status === 'user_validated' || status === 'candidate';
}
function evidenceActive(status: string): boolean {
  return status === 'repeated' || status === 'user_validated';
}
function asDomain(value: string | undefined): JourneyDomain | null {
  return value && VALID_DOMAINS.has(value as JourneyDomain) ? value as JourneyDomain : null;
}
function safetyRisk(value: Record<string, unknown> | undefined): boolean {
  if (!value) return false;
  const keys = ['currentRisk','violence','selfHarm','harmOthers','coercion','stalking','notSafe','immediateRisk'];
  return keys.some((key) => value[key] === true);
}
function recentHighActivation(observations: JourneyObservationRow[]): boolean {
  const recent = observations.filter((row) => {
    const ms = Date.parse(row.occurred_at ?? '');
    return Number.isFinite(ms) && Date.now() - ms <= 14 * 24 * 60 * 60 * 1000;
  });
  return recent.filter((row) => typeof row.intensity_before === 'number' && row.intensity_before >= 8).length >= 2;
}

export function deriveJourneyPlannerInput(args: {
  initialMap: InitialMapRow;
  observations: JourneyObservationRow[];
  hypotheses: JourneyHypothesisRow[];
  formulationVersion: number;
}): JourneyPlannerInput {
  const goalText = args.initialMap.desired_change?.trim() || args.initialMap.primary_concern?.trim() || '';
  const currentText = [args.initialMap.primary_concern, args.initialMap.life_context].filter(Boolean).join(' ');
  const explicitGoalDomains = domainsFromText(goalText);
  const textImpactDomains = domainsFromText(currentText);

  const hypotheses: PlannerHypothesis[] = args.hypotheses.flatMap((row) => {
    const domain = asDomain(row.domain);
    const status = row.status ?? 'candidate';
    if (!domain || !activeForPlanner(status) || status === 'user_rejected' || status === 'dormant') return [];
    return [{
      domain,
      patternKey: row.pattern_key ?? 'unknown',
      status: status as PlannerHypothesis['status'],
      confidenceLabel: (row.confidence_label === 'high' || row.confidence_label === 'medium' ? row.confidence_label : 'low') as PlannerHypothesis['confidenceLabel'],
    }];
  });

  const evidenceDomains = hypotheses.filter((h) => evidenceActive(h.status)).map((h) => h.domain);
  const currentImpactDomains = unique([...textImpactDomains, ...evidenceDomains]);
  const maintainingCandidates = new Set<JourneyDomain>(['overthinking','needs','inner-peace']);
  const maintainingMechanisms = unique(hypotheses
    .filter((h) => evidenceActive(h.status) && maintainingCandidates.has(h.domain) && !explicitGoalDomains.includes(h.domain))
    .map((h) => h.domain));
  const deepRequested = domainsFromText(goalText).filter((domain) => domain === 'childhood' || domain === 'healing');
  const highImpact = args.initialMap.current_impact === 'high';
  const highActivation = recentHighActivation(args.observations);

  return {
    safetyRisk: safetyRisk(args.initialMap.immediate_safety),
    highActivation,
    highImpact,
    regulationAdequate: !highActivation && !highImpact,
    explicitGoalDomains,
    currentImpactDomains,
    hypotheses,
    maintainingMechanisms,
    explicitlyRequestedDeepDomains: deepRequested,
    formulationVersion: Math.max(1, args.formulationVersion),
  };
}

function canonicalArray(values: JourneyDomain[]): string {
  return JSON.stringify([...values].sort());
}
export function isMaterialJourneyPlanChange(previous: StoredJourneyPlan, next: StoredJourneyPlan): boolean {
  return previous.primaryDomain !== next.primaryDomain
    || previous.primaryGoal !== next.primaryGoal
    || previous.supportDomain !== next.supportDomain
    || previous.supportGoal !== next.supportGoal
    || canonicalArray(previous.monitorDomains) !== canonicalArray(next.monitorDomains)
    || canonicalArray(previous.laterDomains) !== canonicalArray(next.laterDomains)
    || previous.status !== next.status;
}

export function buildJourneyPlanVersionRequest(args: {
  userId: string;
  previous: StoredJourneyPlan | null;
  next: StoredJourneyPlan;
  now: string;
}): JourneyPlanVersionRequest | null {
  if (args.previous && !isMaterialJourneyPlanChange(args.previous, args.next)) return null;
  return {
    pauseId: args.previous && (args.previous.status === 'active' || args.previous.status === 'maintenance') ? args.previous.id : null,
    insert: {
      user_id: args.userId,
      version: (args.previous?.version ?? 0) + 1,
      primary_domain: args.next.primaryDomain,
      primary_goal: args.next.primaryGoal,
      support_domain: args.next.supportDomain,
      support_goal: args.next.supportGoal,
      monitor_domains: [...args.next.monitorDomains],
      later_domains: [...args.next.laterDomains],
      reasoning_summary_ar: args.next.reasoningSummaryAr,
      based_on_formulation_version: args.next.basedOnFormulationVersion,
      review_due_at: args.next.reviewDueAt,
      status: args.next.status,
      updated_at: args.now,
    },
  };
}

function envValue(name: string): string {
  const env = (globalThis as any).Deno?.env;
  return env?.get?.(name) ?? '';
}
function restHeaders(prefer?: string): Record<string,string> {
  const key = envValue('SUPABASE_SERVICE_ROLE_KEY');
  const headers: Record<string,string> = { apikey: key, Authorization: `Bearer ${key}`, 'Content-Type': 'application/json' };
  if (prefer) headers.Prefer = prefer;
  return headers;
}
async function restJson(path: string, init: RequestInit): Promise<unknown> {
  const url = envValue('SUPABASE_URL');
  if (!url || !envValue('SUPABASE_SERVICE_ROLE_KEY')) throw new Error('journey_repository_configuration_missing');
  const response = await fetch(`${url}/rest/v1/${path}`, init);
  const payload = await response.json().catch(() => null);
  if (!response.ok) throw new Error(`journey_repository_failed:${response.status}:${JSON.stringify(payload)}`);
  return payload;
}
function rows(payload: unknown): Record<string,unknown>[] {
  return Array.isArray(payload) ? payload.filter((row): row is Record<string,unknown> => Boolean(row) && typeof row === 'object' && !Array.isArray(row)) : [];
}
function storedFromRow(row: Record<string,unknown>): StoredJourneyPlan | null {
  if (typeof row.id !== 'string') return null;
  const domain = (value: unknown): JourneyDomain | null => typeof value === 'string' && VALID_DOMAINS.has(value as JourneyDomain) ? value as JourneyDomain : null;
  const domainArray = (value: unknown): JourneyDomain[] => Array.isArray(value) ? value.filter((x): x is JourneyDomain => typeof x === 'string' && VALID_DOMAINS.has(x as JourneyDomain)) : [];
  return {
    id: row.id,
    version: Number(row.version ?? 0),
    primaryDomain: domain(row.primary_domain),
    primaryGoal: typeof row.primary_goal === 'string' ? row.primary_goal : null,
    supportDomain: domain(row.support_domain),
    supportGoal: typeof row.support_goal === 'string' ? row.support_goal : null,
    monitorDomains: domainArray(row.monitor_domains),
    laterDomains: domainArray(row.later_domains),
    reasoningSummaryAr: typeof row.reasoning_summary_ar === 'string' ? row.reasoning_summary_ar : '',
    basedOnFormulationVersion: Number(row.based_on_formulation_version ?? 1),
    reviewDueAt: typeof row.review_due_at === 'string' ? row.review_due_at : new Date().toISOString(),
    status: row.status === 'maintenance' || row.status === 'paused' ? row.status : 'active',
  };
}
function dueAt(status: StoredJourneyPlan['status'], now: string): string {
  const ms = Date.parse(now);
  const days = status === 'paused' ? 1 : status === 'maintenance' ? 30 : 14;
  return new Date(ms + days * 24 * 60 * 60 * 1000).toISOString();
}


export function buildSafetyPausePlan(previous: StoredJourneyPlan, now: string): StoredJourneyPlan {
  return {
    id: '',
    version: previous.version,
    primaryDomain: null,
    primaryGoal: null,
    supportDomain: null,
    supportGoal: null,
    monitorDomains: [],
    laterDomains: [],
    reasoningSummaryAr: 'أوقفنا التخطيط العادي مؤقتًا لأن الأمان أهم من أي مسار تطوير أو تدريب الآن.',
    basedOnFormulationVersion: previous.basedOnFormulationVersion,
    reviewDueAt: dueAt('paused', now),
    status: 'paused',
  };
}

export async function suspendJourneyPlanForSafety(userId: string, now = new Date().toISOString()): Promise<StoredJourneyPlan | null> {
  const params = new URLSearchParams({
    user_id: `eq.${userId}`,
    select: '*',
    order: 'version.desc',
    limit: '1',
  }).toString();
  const previousRow = rows(await restJson(`malaak_journey_plans?${params}`, { method: 'GET', headers: restHeaders() }))[0];
  const previous = previousRow ? storedFromRow(previousRow) : null;
  if (!previous) return null;
  const next = buildSafetyPausePlan(previous, now);
  const request = buildJourneyPlanVersionRequest({ userId, previous, next, now });
  if (!request) return previous;
  if (request.pauseId) {
    await restJson(`malaak_journey_plans?id=eq.${encodeURIComponent(request.pauseId)}`, {
      method: 'PATCH',
      headers: restHeaders('return=minimal'),
      body: JSON.stringify({ status: 'paused', updated_at: now }),
    });
  }
  const inserted = rows(await restJson('malaak_journey_plans?select=*', {
    method: 'POST',
    headers: restHeaders('return=representation'),
    body: JSON.stringify(request.insert),
  }))[0];
  return inserted ? storedFromRow(inserted) : previous;
}

export async function refreshJourneyPlanForUser(userId: string, now = new Date().toISOString()): Promise<StoredJourneyPlan | null> {
  const query = (params: Record<string,string>) => new URLSearchParams(params).toString();
  const initial = rows(await restJson(`malaak_initial_maps?${query({user_id:`eq.${userId}`,select:'primary_concern,desired_change,life_context,current_impact,immediate_safety',limit:'1'})}`, {method:'GET',headers:restHeaders()}))[0];
  const formulation = rows(await restJson(`malaak_formulations?${query({user_id:`eq.${userId}`,status:'eq.active',select:'version',limit:'1'})}`, {method:'GET',headers:restHeaders()}))[0];
  if (!initial || !formulation) return null;
  const observations = rows(await restJson(`malaak_observations?${query({user_id:`eq.${userId}`,select:'occurred_at,context_domain,intensity_before',order:'occurred_at.desc',limit:'100'})}`, {method:'GET',headers:restHeaders()}));
  const hypotheses = rows(await restJson(`malaak_hypotheses?${query({user_id:`eq.${userId}`,select:'domain,pattern_key,status,confidence_label',order:'updated_at.desc'})}`, {method:'GET',headers:restHeaders()}));
  const previousRow = rows(await restJson(`malaak_journey_plans?${query({user_id:`eq.${userId}`,select:'*',order:'version.desc',limit:'1'})}`, {method:'GET',headers:restHeaders()}))[0];
  const previous = previousRow ? storedFromRow(previousRow) : null;
  const input = deriveJourneyPlannerInput({
    initialMap: initial as InitialMapRow,
    observations: observations as JourneyObservationRow[],
    hypotheses: hypotheses as JourneyHypothesisRow[],
    formulationVersion: Number(formulation.version ?? 1),
  });
  const decision = buildJourneyPlan(input);
  const next: StoredJourneyPlan = {
    id: '', version: previous?.version ?? 0,
    primaryDomain: decision.primaryDomain, primaryGoal: decision.primaryGoal,
    supportDomain: decision.supportDomain, supportGoal: decision.supportGoal,
    monitorDomains: decision.monitorDomains, laterDomains: decision.laterDomains,
    reasoningSummaryAr: decision.reasoningSummaryAr,
    basedOnFormulationVersion: decision.basedOnFormulationVersion,
    reviewDueAt: dueAt(decision.status, now), status: decision.status,
  };
  const request = buildJourneyPlanVersionRequest({userId, previous, next, now});
  if (!request) return previous;
  if (request.pauseId) {
    await restJson(`malaak_journey_plans?id=eq.${encodeURIComponent(request.pauseId)}`, {
      method:'PATCH', headers:restHeaders('return=minimal'), body:JSON.stringify({status:'paused',updated_at:now}),
    });
  }
  const inserted = rows(await restJson('malaak_journey_plans?select=*', {
    method:'POST', headers:restHeaders('return=representation'), body:JSON.stringify(request.insert),
  }))[0];
  return inserted ? storedFromRow(inserted) : null;
}
