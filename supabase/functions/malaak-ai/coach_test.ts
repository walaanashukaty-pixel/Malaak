import test from 'node:test';
import assert from 'node:assert/strict';
import { deterministicFallback, validateCoachingTurn } from './coach.ts';
import { routeMessage } from './router.ts';
import type { CatalogIntervention } from './types.ts';

function card(patch: Partial<CatalogIntervention> = {}): CatalogIntervention {
  return {
    id: 'catalog-uncertainty-v7',
    code: 'UNCERTAINTY_001',
    version: 7,
    status: 'active',
    titleAr: 'تحمّل جزء من عدم اليقين',
    shortDescriptionAr: '',
    framework: 'CBT',
    evidenceTier: 'B',
    targetNeeds: ['connection'],
    targetPatterns: ['attachment_alarm', 'reassurance_loop'],
    eligibleStates: ['moderate_activation', 'reflective', 'unknown'],
    journeyDomains: ['attachment'],
    exclusions: [],
    contraindicationNotesAr: '',
    durationMinutes: 10,
    steps: ['سمّي الشيء المجهول.', 'خففي الفحص لفترة قصيرة.'],
    actionTemplate: 'اختاري فترة قصيرة بدون فحص متكرر.',
    measurementSpec: {},
    followUpSpec: {},
    fallbackCode: null,
    requiresUserConfirmation: false,
    requiresHumanSupport: false,
    ...patch,
  };
}

function modelPayload(route: ReturnType<typeof routeMessage>, code = 'UNCERTAINTY_001') {
  return {
    mode: 'coach',
    state: route.state,
    need: route.need,
    pattern: route.pattern,
    patternConfidence: route.patternConfidence,
    goal: 'أخفف الفحص المتكرر',
    interventionCode: code,
    interventionVersion: 999,
    interventionId: 'model-invented-id',
    reply: 'خلينا نقلل الفحص خطوة صغيرة.',
    action: 'انتظري عشر دقايق.',
    followUp: { timing: 'later_today', prompt: 'كيف مشي الانتظار؟', journeyDomainId: 'attachment' },
  };
}

test('unknown intervention code from model is rejected in favor of exact eligible revision', () => {
  const route = routeMessage('ما رد وعم افتح الواتساب كل دقيقة', {});
  const eligible = [card()];
  const payload = validateCoachingTurn(modelPayload(route, 'NOT_APPROVED'), route, eligible);
  assert.equal(payload.interventionCode, 'UNCERTAINTY_001');
  assert.equal(payload.interventionVersion, 7);
  assert.equal(payload.interventionId, 'catalog-uncertainty-v7');
});

test('server catalog revision overrides model supplied version and id', () => {
  const route = routeMessage('ما رد وعم افتح الواتساب كل دقيقة', {});
  const eligible = [card()];
  const payload = validateCoachingTurn(modelPayload(route), route, eligible);
  assert.equal(payload.interventionCode, 'UNCERTAINTY_001');
  assert.equal(payload.interventionVersion, 7);
  assert.equal(payload.interventionId, 'catalog-uncertainty-v7');
});

test('paused card cannot be selected even if injected into eligible list', () => {
  const route = routeMessage('ما رد وعم افتح الواتساب كل دقيقة', {});
  const eligible = [
    card({ id: 'paused', status: 'paused', version: 9 }),
    card({ id: 'ground-active', code: 'REG_GROUND_001', version: 3, titleAr: 'تثبيت الحاضر' }),
  ];
  const payload = validateCoachingTurn(modelPayload(route), route, eligible);
  assert.equal(payload.interventionCode, 'REG_GROUND_001');
  assert.equal(payload.interventionVersion, 3);
  assert.equal(payload.interventionId, 'ground-active');
});

test('invalid payload gets deterministic catalog fallback with audit revision', () => {
  const route = routeMessage('بدي قول لا بس خايفة يزعلوا', {});
  const eligible = [card({ id: 'need-v2', code: 'NEED_NAME_001', version: 2, titleAr: 'سمّي الحاجة' })];
  const payload = validateCoachingTurn(null, route, eligible);
  assert.deepEqual(payload, deterministicFallback(route, eligible));
  assert.equal(payload.interventionVersion, 2);
  assert.equal(payload.interventionId, 'need-v2');
});

test('safety route never receives an intervention revision', () => {
  const route = routeMessage('رح أضربه وهلأ ما عم سيطر', {});
  const payload = validateCoachingTurn({ interventionCode: 'REG_GROUND_001' }, route, [card()]);
  assert.equal(payload.mode, 'safety');
  assert.equal(payload.interventionCode, null);
  assert.equal(payload.interventionVersion, null);
  assert.equal(payload.interventionId, null);
  assert.equal(payload.followUp.timing, 'none');
});

test('allowed structured observation is sanitized into coaching payload', () => {
  const route = routeMessage('ما رد وعم افتح الواتساب كل دقيقة', {});
  const eligible=[card()];
  const raw=modelPayload(route) as any;
  raw.observation={sourceType:'malaak_message',contextDomain:'relationship',eventFact:'ما رد ساعتين',emotion:'خوف',intensityBefore:8,diagnosis:'attachment disorder'};
  const payload=validateCoachingTurn(raw,route,eligible,{analysisAllowed:true} as any);
  assert.equal(payload.observation?.eventFact,'ما رد ساعتين');
  assert.equal((payload.observation as any)?.diagnosis,undefined);
});

test('private journal context strips model observation', () => {
  const route=routeMessage('مضايقة من موقف',{});
  const eligible=[card()];
  const raw=modelPayload(route) as any;
  raw.observation={sourceType:'journal',contextDomain:'self',eventFact:'سر خاص'};
  const payload=validateCoachingTurn(raw,route,eligible,{sourceType:'journal',journalMode:'private'} as any);
  assert.equal(payload.observation,null);
});
