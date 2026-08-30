import test from 'node:test';
import assert from 'node:assert/strict';
import { analysisPermitted, parseCandidateObservationText, sanitizeObservation } from './observation.ts';

test('sanitizer keeps only approved observation fields and rejects diagnosis/causal prose', () => {
  const value = sanitizeObservation({
    sourceType:'malaak_message', contextDomain:'relationship', eventFact:'زوجي ما رد ساعتين',
    automaticThought:'أكيد رح يتركني', emotion:'خوف', intensityBefore:8,
    bodySignals:['شد بالصدر'], urge:'أبعت كتير', need:'اتصال', behavior:'فتحت الواتساب 10 مرات',
    diagnosis:'اضطراب تعلق', causalClaim:'هذا بسبب طفولتها حتماً', extra:'ignore me',
  }, {analysisAllowed:true});
  assert.equal(value?.eventFact,'زوجي ما رد ساعتين');
  assert.equal(value?.emotion,'خوف');
  assert.equal((value as any)?.diagnosis, undefined);
  assert.equal((value as any)?.causalClaim, undefined);
  assert.equal((value as any)?.extra, undefined);
});

test('private journal context never permits observation extraction', () => {
  assert.equal(analysisPermitted({sourceType:'journal', journalMode:'private', analysisAllowed:true}), false);
  assert.equal(sanitizeObservation({sourceType:'journal',eventFact:'سر خاص'}, {sourceType:'journal', journalMode:'private'}), null);
});

test('pattern analysis opt-out prevents observation extraction', () => {
  assert.equal(analysisPermitted({privacyScope:{patternAnalysis:false}}), false);
});

test('invalid json never fabricates an observation', () => {
  assert.equal(parseCandidateObservationText('not-json', {analysisAllowed:true}), null);
});

test('out of range intensities are removed rather than invented or clamped', () => {
  const value=sanitizeObservation({sourceType:'malaak_message',eventFact:'صار موقف',intensityBefore:27,intensityAfter:-2}, {analysisAllowed:true});
  assert.equal(value?.intensityBefore,null);
  assert.equal(value?.intensityAfter,null);
});
