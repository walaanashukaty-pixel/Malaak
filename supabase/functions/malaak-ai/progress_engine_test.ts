import test from 'node:test';
import assert from 'node:assert/strict';
import { evaluateJourneyReview } from './progress_engine.ts';

test('stable evidence progresses from assisted use to independent application', () => {
  const result = evaluateJourneyReview({
    previousStage: 'أتمرن عليها',
    awarenessEvidence: 4,
    assistedUses: 5,
    independentUses: 3,
    stableUnderPressureUses: 1,
    difficultWeek: false,
    interventionAttempts: 4,
    helpfulAttempts: 3,
    currentImpactHigh: false,
    outcomesWorsening: false,
  });
  assert.equal(result.stage, 'أطبقها');
  assert.equal(result.supportMode, false);
  assert.equal(result.action, 'continue');
  assert.equal(result.demoted, false);
});

test('difficult week triggers support mode without demotion', () => {
  const result = evaluateJourneyReview({
    previousStage: 'أثبتها تحت الضغط',
    awarenessEvidence: 4,
    assistedUses: 5,
    independentUses: 4,
    stableUnderPressureUses: 1,
    difficultWeek: true,
    interventionAttempts: 2,
    helpfulAttempts: 1,
    currentImpactHigh: false,
    outcomesWorsening: false,
  });
  assert.equal(result.stage, 'أثبتها تحت الضغط');
  assert.equal(result.supportMode, true);
  assert.equal(result.demoted, false);
  assert.equal(result.action, 'stabilize');
});

test('repeated non-response triggers reassessment instead of repeating same intervention', () => {
  const result = evaluateJourneyReview({
    previousStage: 'أتمرن عليها',
    awarenessEvidence: 4,
    assistedUses: 4,
    independentUses: 0,
    stableUnderPressureUses: 0,
    difficultWeek: false,
    interventionAttempts: 5,
    helpfulAttempts: 0,
    currentImpactHigh: false,
    outcomesWorsening: false,
  });
  assert.equal(result.action, 'reassess');
  assert.equal(result.repeatSameIntervention, false);
  assert.equal(result.supportMode, true);
});

test('non-response with high impact or worsening recommends human step-up', () => {
  const result = evaluateJourneyReview({
    previousStage: 'أفهمها',
    awarenessEvidence: 3,
    assistedUses: 2,
    independentUses: 0,
    stableUnderPressureUses: 0,
    difficultWeek: false,
    interventionAttempts: 5,
    helpfulAttempts: 1,
    currentImpactHigh: true,
    outcomesWorsening: true,
  });
  assert.equal(result.action, 'step_up');
  assert.equal(result.humanSupportRecommended, true);
  assert.equal(result.repeatSameIntervention, false);
});
