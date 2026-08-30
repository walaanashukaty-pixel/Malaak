import test from 'node:test';
import assert from 'node:assert/strict';
import { buildJourneyPlan, type JourneyPlannerInput } from './journey_planner.ts';

const base = (overrides: Partial<JourneyPlannerInput> = {}): JourneyPlannerInput => ({
  safetyRisk: false,
  highActivation: false,
  highImpact: false,
  regulationAdequate: true,
  explicitGoalDomains: [],
  currentImpactDomains: [],
  hypotheses: [],
  maintainingMechanisms: [],
  explicitlyRequestedDeepDomains: [],
  formulationVersion: 1,
  ...overrides,
});

test('example A: relationship-triggered overthinking becomes attachment primary and overthinking support', () => {
  const plan = buildJourneyPlan(base({
    explicitGoalDomains: ['relationship'],
    currentImpactDomains: ['attachment', 'overthinking', 'relationship'],
    hypotheses: [
      { domain: 'attachment', patternKey: 'reassurance_loop', status: 'repeated', confidenceLabel: 'high' },
      { domain: 'overthinking', patternKey: 'rumination', status: 'repeated', confidenceLabel: 'medium' },
      { domain: 'childhood', patternKey: 'old_rejection', status: 'candidate', confidenceLabel: 'low' },
    ],
    maintainingMechanisms: ['overthinking'],
  }));
  assert.equal(plan.suspended, false);
  assert.equal(plan.primaryDomain, 'attachment');
  assert.equal(plan.supportDomain, 'overthinking');
  assert.deepEqual(plan.monitorDomains, ['relationship']);
  assert.ok(plan.laterDomains.includes('childhood'));
});

test('example B: anger with overload keeps anger primary and inner-peace support', () => {
  const plan = buildJourneyPlan(base({
    explicitGoalDomains: ['anger'],
    currentImpactDomains: ['anger', 'inner-peace', 'relationship'],
    hypotheses: [
      { domain: 'anger', patternKey: 'anger_escalation', status: 'user_validated', confidenceLabel: 'high' },
      { domain: 'inner-peace', patternKey: 'overload', status: 'repeated', confidenceLabel: 'medium' },
    ],
    maintainingMechanisms: ['inner-peace'],
  }));
  assert.equal(plan.primaryDomain, 'anger');
  assert.equal(plan.supportDomain, 'inner-peace');
  assert.deepEqual(plan.monitorDomains, ['relationship']);
});

test('example C: safety risk suspends ordinary journey planning', () => {
  const plan = buildJourneyPlan(base({
    safetyRisk: true,
    explicitGoalDomains: ['relationship'],
    currentImpactDomains: ['relationship'],
  }));
  assert.equal(plan.suspended, true);
  assert.equal(plan.status, 'paused');
  assert.equal(plan.primaryDomain, null);
  assert.equal(plan.supportDomain, null);
  assert.deepEqual(plan.monitorDomains, []);
});

test('planner emits at most one primary, one support, and two monitor domains', () => {
  const plan = buildJourneyPlan(base({
    explicitGoalDomains: ['attachment', 'relationship', 'anger'],
    currentImpactDomains: ['attachment', 'relationship', 'anger', 'overthinking', 'needs'],
    hypotheses: [
      { domain: 'attachment', patternKey: 'attachment_alarm', status: 'repeated', confidenceLabel: 'high' },
      { domain: 'anger', patternKey: 'anger_escalation', status: 'repeated', confidenceLabel: 'medium' },
      { domain: 'needs', patternKey: 'unmet_need', status: 'repeated', confidenceLabel: 'medium' },
    ],
    maintainingMechanisms: ['overthinking', 'needs'],
  }));
  assert.ok(plan.primaryDomain === null || typeof plan.primaryDomain === 'string');
  assert.ok(plan.supportDomain === null || typeof plan.supportDomain === 'string');
  assert.ok(plan.monitorDomains.length <= 2);
  assert.notEqual(plan.primaryDomain, plan.supportDomain);
});

test('high activation blocks childhood and healing from automatic primary', () => {
  const plan = buildJourneyPlan(base({
    highActivation: true,
    regulationAdequate: false,
    explicitGoalDomains: ['childhood'],
    currentImpactDomains: ['childhood', 'healing'],
    hypotheses: [
      { domain: 'childhood', patternKey: 'old_belief', status: 'user_validated', confidenceLabel: 'high' },
      { domain: 'healing', patternKey: 'betrayal', status: 'repeated', confidenceLabel: 'high' },
    ],
    explicitlyRequestedDeepDomains: ['childhood'],
  }));
  assert.equal(plan.primaryDomain, 'emotional-state');
  assert.equal(plan.supportDomain, null);
  assert.ok(plan.laterDomains.includes('childhood'));
  assert.ok(plan.laterDomains.includes('healing'));
});

test('deep domain can become primary only with explicit request and adequate readiness', () => {
  const plan = buildJourneyPlan(base({
    explicitGoalDomains: ['childhood'],
    currentImpactDomains: ['childhood'],
    explicitlyRequestedDeepDomains: ['childhood'],
    hypotheses: [
      { domain: 'childhood', patternKey: 'old_belief', status: 'user_validated', confidenceLabel: 'high' },
    ],
  }));
  assert.equal(plan.primaryDomain, 'childhood');
});

test('rejected and dormant hypotheses never increase planner ranking', () => {
  const plan = buildJourneyPlan(base({
    explicitGoalDomains: ['needs'],
    currentImpactDomains: ['needs', 'attachment'],
    hypotheses: [
      { domain: 'attachment', patternKey: 'attachment_alarm', status: 'user_rejected', confidenceLabel: 'high' },
      { domain: 'overthinking', patternKey: 'rumination', status: 'dormant', confidenceLabel: 'high' },
      { domain: 'needs', patternKey: 'unmet_need', status: 'repeated', confidenceLabel: 'medium' },
    ],
  }));
  assert.equal(plan.primaryDomain, 'needs');
  assert.notEqual(plan.primaryDomain, 'attachment');
  assert.notEqual(plan.supportDomain, 'overthinking');
});
