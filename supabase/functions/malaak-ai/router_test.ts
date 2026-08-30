import test from 'node:test';
import assert from 'node:assert/strict';
import { routeMessage } from './router.ts';
import { catalogSeed } from './catalog_seed.ts';

const knownCodes = new Set(catalogSeed.map((card) => card.code));

test('immediate violence risk routes to safety with no candidates', () => {
  const route = routeMessage('رح أضربه وهلأ ما عم سيطر', {});
  assert.equal(route.mode, 'safety');
  assert.deepEqual(route.candidateCodes, []);
});

test('high activation excludes reflective thought work', () => {
  const route = routeMessage('أنا 9 من 10 وعم انفجر', {});
  assert.equal(route.state, 'high_activation');
  assert.equal(route.candidateCodes.includes('THOUGHT_FACTS_001'), false);
  assert.ok(route.candidateCodes.includes('REG_GROUND_001'));
});

test('repeated checking after no reply ranks attachment-specific V5 tools', () => {
  const route = routeMessage('ما رد وعم افتح الواتساب كل دقيقة', {});
  assert.equal(route.pattern, 'reassurance_loop');
  assert.ok(route.candidateCodes.includes('ATT_REASSURE_DELAY_003'));
  assert.ok(route.candidateCodes.includes('UNCERTAINTY_001'));
});

test('anger escalation offers time-out plus regulation', () => {
  const route = routeMessage('أنا معصبة وبدي احكي فوراً قبل ما انفجر', {});
  assert.ok(route.candidateCodes.includes('ANGER_TIMEOUT_001'));
  assert.ok(route.candidateCodes.includes('REG_GROUND_001') || route.candidateCodes.includes('REG_MOVE_002'));
});

test('control overdrive ranks circle-of-control before generic thought work', () => {
  const route = routeMessage('حاسّة إني لازم أسيطر على كل شي وما بثق حدا يعملها', {});
  assert.equal(route.pattern, 'control_overdrive');
  assert.equal(route.candidateCodes[0], 'CONTROL_CIRCLE_001');
  assert.ok(route.candidateCodes.includes('BAL_CONTROL_RESP_002'));
});

test('every routed candidate is a known catalog code without hardcoded intervention lookup dependency', () => {
  const samples = [
    'ما رد وعم فكر إنه رح يتركني',
    'ما بعرف شو بدي من هالموقف',
    'بدي قول لا بس خايفة يزعلوا',
    'عندي مشكلة وبدي أعرف أول خطوة',
    'حاسّة إني لازم أسيطر على كل شي',
  ];
  for (const sample of samples) {
    const route = routeMessage(sample, {});
    for (const code of route.candidateCodes) {
      assert.ok(knownCodes.has(code), `${code} must exist in V5 catalog seed`);
    }
  }
});
