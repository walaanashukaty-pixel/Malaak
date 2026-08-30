import test from 'node:test';
import assert from 'node:assert/strict';
import { filterEligibleCatalogRows, embeddedFallbackForRoute } from './catalog.ts';
import type { CatalogIntervention, RoutingResult } from './types.ts';

const route: RoutingResult = {
  mode: 'coach', state: 'moderate_activation', need: 'connection', pattern: 'attachment_alarm',
  patternConfidence: 'medium', candidateCodes: ['UNCERTAINTY_001','THOUGHT_FACTS_001'], journeyDomainId: 'attachment',
};

const row = (patch: Partial<CatalogIntervention> = {}): CatalogIntervention => ({
  id: '00000000-0000-0000-0000-000000000001', code: 'UNCERTAINTY_001', version: 1,
  status: 'active', titleAr: 'تحمل عدم اليقين', shortDescriptionAr: '', framework: 'CBT', evidenceTier: 'B',
  targetNeeds: ['connection'], targetPatterns: ['attachment_alarm'], eligibleStates: ['moderate_activation','reflective'],
  journeyDomains: ['attachment'], exclusions: [], contraindicationNotesAr: '', durationMinutes: 10,
  steps: ['step'], actionTemplate: 'action', measurementSpec: {}, followUpSpec: {}, fallbackCode: null,
  requiresUserConfirmation: false, requiresHumanSupport: false,
  ...patch,
});

test('paused retired and prohibited rows are never eligible', () => {
  const result = filterEligibleCatalogRows([
    row({status:'paused'}), row({status:'retired', id:'2'}), row({status:'prohibited', id:'3'}), row({id:'4'}),
  ], route, {});
  assert.deepEqual(result.map((x) => x.id), ['4']);
});

test('high activation excludes cards without high_activation eligibility', () => {
  const highRoute = {...route, state:'high_activation' as const};
  const result = filterEligibleCatalogRows([row()], highRoute, {});
  assert.equal(result.length, 0);
});

test('interpersonal danger excludes direct-confrontation cards', () => {
  const direct = row({code:'REQUEST_DIRECT_001', id:'5', targetPatterns:['conflict_cycle'], targetNeeds:['connection']});
  const result = filterEligibleCatalogRows([direct, row({id:'6'})], route, {interpersonalDanger:true});
  assert.deepEqual(result.map((x) => x.id), ['6']);
});

test('exact active revision id and version are preserved', () => {
  const result = filterEligibleCatalogRows([row({id:'abc', version:7})], route, {});
  assert.equal(result[0].id, 'abc');
  assert.equal(result[0].version, 7);
});

test('catalog failure fallback uses only embedded low-risk cards', () => {
  const fallback = embeddedFallbackForRoute(route);
  const allowed = new Set(['REG_GROUND_001','REG_MOVE_002','NEED_NAME_001','THOUGHT_FACTS_001','PROBLEM_SOLVE_001']);
  assert.ok(fallback.length > 0);
  for (const card of fallback) assert.ok(allowed.has(card.code), card.code);
});

test('catalog context flags detect interpersonal danger without turning it into diagnosis', async () => {
  const module = await import('./catalog.ts');
  assert.equal(typeof module.deriveCatalogContextFlags, 'function');
  const flags = module.deriveCatalogContextFlags(
    'بخاف أعترض لأنه ممكن يمنعني أطلع من البيت',
    { currentIntensity: 6 },
  );
  assert.equal(flags.interpersonalDanger, true);
});

test('catalog context flags mark very high current impact for conservative eligibility', async () => {
  const module = await import('./catalog.ts');
  assert.equal(typeof module.deriveCatalogContextFlags, 'function');
  const flags = module.deriveCatalogContextFlags('أنا مضغوطة', { currentIntensity: 9 });
  assert.equal(flags.highImpact, true);
});
