import { embeddedFallbackInterventions } from './fallback_interventions.ts';
import type { CatalogContextFlags, CatalogIntervention, RoutingResult } from './types.ts';

const DIRECT_CONFRONTATION_CODES = new Set([
  'REQUEST_DIRECT_001','BOUNDARY_001','ATT_REPAIR_004','REL_CYCLE_001','REL_SOFT_START_002',
  'REL_REPAIR_003','REL_TRUST_STEP_004','ANGER_ASSERT_004','HEAL_TRUST_GRADUAL_005',
]);
const DEEP_DOMAINS = new Set(['childhood','healing']);
let catalogCache: { expiresAt: number; rows: CatalogIntervention[] } | null = null;

function contextNumber(context: unknown, keys: string[]): number | null {
  if (!context || typeof context !== 'object' || Array.isArray(context)) return null;
  const object = context as Record<string, unknown>;
  for (const key of keys) {
    const value = object[key];
    if (typeof value === 'number' && Number.isFinite(value)) return value;
    if (typeof value === 'string' && value.trim() && Number.isFinite(Number(value))) return Number(value);
  }
  return null;
}

export function deriveCatalogContextFlags(message: string, context: unknown): CatalogContextFlags {
  const text = message.trim();
  const interpersonalDanger = /بخاف.*(?:أعترض|احكي|أحكي|ارفض|أرفض)|يمنعني\s*(?:ا|أ)طلع|يعاقبني|يهددني|تهديد|إكراه|اكراه|يجبرني|حبس|يضربني|ضربني|يطاردني|لاحقني/i.test(text);
  const intensity = contextNumber(context, ['currentIntensity', 'intensity', 'stateIntensity', 'distressIntensity']);
  const highImpactFromContext = Boolean(
    context && typeof context === 'object' && !Array.isArray(context) && (
      (context as Record<string, unknown>).majorFunctionalImpairment === true ||
      (context as Record<string, unknown>).severeSleepDisruption === true ||
      (context as Record<string, unknown>).highImpact === true
    )
  );
  const highImpactFromText = /مو\s*قادرة\s*(?:روح|أروح)\s*(?:عالشغل|للشغل)|ما\s*عم\s*نام\s*(?:من|صارلي)\s*(?:يومين|ثلاث|3)|ما\s*عم\s*اقدر\s*(?:آكل|اكل)|حياتي\s*واقفة/i.test(text);
  return {
    interpersonalDanger,
    highImpact: (intensity !== null && intensity >= 8) || highImpactFromContext || highImpactFromText,
  };
}


function normalizeRow(raw: Record<string, unknown>): CatalogIntervention {
  return {
    id: String(raw.id ?? ''),
    code: String(raw.code ?? ''),
    version: Number(raw.version ?? 1),
    status: String(raw.status ?? 'draft') as CatalogIntervention['status'],
    titleAr: String(raw.title_ar ?? ''),
    shortDescriptionAr: String(raw.short_description_ar ?? ''),
    framework: String(raw.framework ?? ''),
    evidenceTier: String(raw.evidence_tier ?? 'X') as CatalogIntervention['evidenceTier'],
    targetNeeds: Array.isArray(raw.target_needs) ? raw.target_needs.map(String) : [],
    targetPatterns: Array.isArray(raw.target_patterns) ? raw.target_patterns.map(String) : [],
    eligibleStates: Array.isArray(raw.eligible_states) ? raw.eligible_states.map(String) as CatalogIntervention['eligibleStates'] : [],
    journeyDomains: Array.isArray(raw.journey_domains) ? raw.journey_domains.map(String) : [],
    exclusions: Array.isArray(raw.exclusions) ? raw.exclusions.map(String) : [],
    contraindicationNotesAr: String(raw.contraindication_notes_ar ?? ''),
    durationMinutes: Number(raw.duration_min ?? 5),
    steps: Array.isArray(raw.steps_ar) ? raw.steps_ar.map(String) : [],
    actionTemplate: String(raw.action_template_ar ?? ''),
    measurementSpec: raw.measurement_spec && typeof raw.measurement_spec === 'object' ? raw.measurement_spec as Record<string, unknown> : {},
    followUpSpec: raw.follow_up_spec && typeof raw.follow_up_spec === 'object' ? raw.follow_up_spec as Record<string, unknown> : {},
    fallbackCode: raw.fallback_code ? String(raw.fallback_code) : null,
    requiresUserConfirmation: Boolean(raw.requires_user_confirmation),
    requiresHumanSupport: Boolean(raw.requires_human_support),
  };
}

export function filterEligibleCatalogRows(
  rows: CatalogIntervention[],
  route: RoutingResult,
  flags: CatalogContextFlags,
): CatalogIntervention[] {
  if (route.mode === 'safety') return [];
  const scored: Array<{card: CatalogIntervention; score: number}> = [];
  for (const card of rows) {
    if (card.status !== 'active' || card.evidenceTier === 'X') continue;
    if (!card.eligibleStates.includes(route.state)) continue;
    if (flags.interpersonalDanger && DIRECT_CONFRONTATION_CODES.has(card.code)) continue;
    if (flags.highImpact && card.journeyDomains.some((d) => DEEP_DOMAINS.has(d))) continue;

    let score = 0;
    if (route.candidateCodes.includes(card.code)) score += 100;
    if (card.targetPatterns.includes(route.pattern)) score += 40;
    if (card.targetPatterns.includes('unknown')) score += 5;
    if (card.targetNeeds.includes(route.need)) score += 25;
    if (route.journeyDomainId && card.journeyDomains.includes(route.journeyDomainId)) score += 15;
    if (score <= 0) continue;
    scored.push({card, score});
  }
  scored.sort((a,b) => b.score - a.score || a.card.code.localeCompare(b.card.code) || b.card.version - a.card.version);
  const seen = new Set<string>();
  const result: CatalogIntervention[] = [];
  for (const item of scored) {
    if (seen.has(item.card.code)) continue;
    seen.add(item.card.code);
    result.push(item.card);
    if (result.length === 6) break;
  }
  return result;
}

export function embeddedFallbackForRoute(route: RoutingResult): CatalogIntervention[] {
  return filterEligibleCatalogRows(embeddedFallbackInterventions, route, {catalogUnavailable:true});
}

async function fetchActiveCatalog(): Promise<CatalogIntervention[]> {
  const now = Date.now();
  if (catalogCache && catalogCache.expiresAt > now) return catalogCache.rows;
  const env = (globalThis as any).Deno?.env;
  const url = env?.get?.('SUPABASE_URL') ?? '';
  const serviceRole = env?.get?.('SUPABASE_SERVICE_ROLE_KEY') ?? '';
  if (!url || !serviceRole) throw new Error('catalog_configuration_missing');
  const endpoint = `${url}/rest/v1/malaak_interventions?status=eq.active&select=id,code,version,status,title_ar,short_description_ar,framework,evidence_tier,target_needs,target_patterns,eligible_states,journey_domains,exclusions,contraindication_notes_ar,duration_min,steps_ar,action_template_ar,measurement_spec,follow_up_spec,fallback_code,requires_user_confirmation,requires_human_support`;
  const response = await fetch(endpoint, {
    headers: { apikey: serviceRole, Authorization: `Bearer ${serviceRole}` },
  });
  if (!response.ok) throw new Error(`catalog_fetch_failed:${response.status}`);
  const raw = await response.json();
  if (!Array.isArray(raw)) throw new Error('catalog_invalid_payload');
  const rows = raw.map((x) => normalizeRow(x as Record<string, unknown>));
  catalogCache = { rows, expiresAt: now + 300_000 };
  return rows;
}

export async function loadEligibleInterventions(
  route: RoutingResult,
  flags: CatalogContextFlags = {},
): Promise<CatalogIntervention[]> {
  try {
    const rows = await fetchActiveCatalog();
    const eligible = filterEligibleCatalogRows(rows, route, flags);
    return eligible.length ? eligible : embeddedFallbackForRoute(route);
  } catch (error) {
    console.error('Malaak catalog unavailable', error);
    return embeddedFallbackForRoute(route);
  }
}

export function resetCatalogCacheForTests(): void {
  catalogCache = null;
}
