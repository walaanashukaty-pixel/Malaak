import test from 'node:test';
import assert from 'node:assert/strict';
import {
  buildJourneyPlanVersionRequest,
  deriveJourneyPlannerInput,
  isMaterialJourneyPlanChange,
  type StoredJourneyPlan,
} from './journey_repository.ts';
import { buildJourneyPlan } from './journey_planner.ts';

const previous: StoredJourneyPlan = {
  id: 'plan-1', version: 2, primaryDomain: 'attachment', primaryGoal: 'g1',
  supportDomain: 'overthinking', supportGoal: 'g2', monitorDomains: ['relationship'],
  laterDomains: ['childhood'], reasoningSummaryAr: 'old', basedOnFormulationVersion: 3,
  reviewDueAt: '2026-09-10T00:00:00.000Z', status: 'active',
};

test('same planner domains do not version merely because formulation/reasoning changed', () => {
  const next = { ...previous, reasoningSummaryAr: 'new wording', basedOnFormulationVersion: 4 };
  assert.equal(isMaterialJourneyPlanChange(previous, next), false);
});

test('primary/support/status change is material', () => {
  assert.equal(isMaterialJourneyPlanChange(previous, { ...previous, primaryDomain: 'anger' }), true);
  assert.equal(isMaterialJourneyPlanChange(previous, { ...previous, supportDomain: 'needs' }), true);
  assert.equal(isMaterialJourneyPlanChange(previous, { ...previous, status: 'maintenance' }), true);
});

test('version request derives user id and version on server and pauses prior current plan', () => {
  const request = buildJourneyPlanVersionRequest({
    userId: 'user-server', previous,
    next: { ...previous, primaryDomain: 'anger', primaryGoal: 'تنظيم الغضب', basedOnFormulationVersion: 4 },
    now: '2026-08-29T12:00:00.000Z',
  });
  assert.ok(request);
  assert.equal(request?.pauseId, 'plan-1');
  assert.equal(request?.insert.user_id, 'user-server');
  assert.equal(request?.insert.version, 3);
  assert.equal(request?.insert.based_on_formulation_version, 4);
  assert.equal(request?.insert.primary_domain, 'anger');
});

test('planner input excludes rejected/dormant hypotheses and maps repeated current-life evidence', () => {
  const input = deriveJourneyPlannerInput({
    initialMap: {
      primary_concern: 'زواجي والتفكير لما يبعد زوجي', desired_change: 'بدي أكون أهدأ بعلاقتي',
      life_context: 'زوجي', current_impact: 'moderate', immediate_safety: {},
    },
    observations: [],
    hypotheses: [
      { domain: 'attachment', pattern_key: 'reassurance_loop', status: 'repeated', confidence_label: 'high' },
      { domain: 'overthinking', pattern_key: 'rumination', status: 'repeated', confidence_label: 'medium' },
      { domain: 'anger', pattern_key: 'anger_escalation', status: 'user_rejected', confidence_label: 'high' },
      { domain: 'childhood', pattern_key: 'old_belief', status: 'dormant', confidence_label: 'high' },
    ],
    formulationVersion: 4,
  });
  assert.ok(input.currentImpactDomains.includes('attachment'));
  assert.ok(input.currentImpactDomains.includes('overthinking'));
  assert.equal(input.hypotheses.some((h) => h.domain === 'anger'), false);
  assert.equal(input.hypotheses.some((h) => h.domain === 'childhood'), false);
  assert.ok(input.maintainingMechanisms.includes('overthinking'));
});

test('unsafe initial map suspends built plan', () => {
  const input = deriveJourneyPlannerInput({
    initialMap: {
      primary_concern: 'علاقتي', desired_change: 'بدي أعرف شو أعمل', life_context: 'زوجي',
      current_impact: 'high', immediate_safety: { currentRisk: true },
    }, observations: [], hypotheses: [], formulationVersion: 2,
  });
  const plan = buildJourneyPlan(input);
  assert.equal(plan.suspended, true);
  assert.equal(plan.status, 'paused');
});

test('safety pause version clears ordinary growth paths and preserves formulation audit link', async () => {
  const { buildSafetyPausePlan } = await import('./journey_repository.ts');
  const paused = buildSafetyPausePlan(previous, '2026-08-29T12:00:00.000Z');
  assert.equal(paused.status, 'paused');
  assert.equal(paused.primaryDomain, null);
  assert.equal(paused.supportDomain, null);
  assert.deepEqual(paused.monitorDomains, []);
  assert.equal(paused.basedOnFormulationVersion, previous.basedOnFormulationVersion);
  assert.match(paused.reasoningSummaryAr, /الأمان/);
});
