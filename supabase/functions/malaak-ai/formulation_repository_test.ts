import test from 'node:test';
import assert from 'node:assert/strict';
import {
  buildModelObservationRow,
  buildHypothesisMutation,
  mergeObservationIds,
  patternDescriptorForRoute,
} from './formulation_repository.ts';
import type { CandidateObservation, CoachingPayload, RoutingResult } from './types.ts';

const observation: CandidateObservation = {
  sourceType:'client_injected', sourceId:'client-source', occurredAt:'2020-01-01T00:00:00Z',
  contextDomain:'relationship', trigger:'تأخر الرد', eventFact:'ما رد ساعتين', automaticThought:'يمكن يتركني',
  emotion:'خوف', intensityBefore:8, bodySignals:['شد'], urge:'أفتح واتساب', need:'اتصال', behavior:'فتحت مرة',
  outcome:'توتر', intensityAfter:null, recoveryMinutes:null, interventionHelpfulness:null,
};

const turn: CoachingPayload = {
  mode:'coach', state:'moderate_activation', need:'connection', pattern:'attachment_alarm', patternConfidence:'medium',
  goal:'تنظيم الخوف', interventionCode:'ATT_TRIGGER_001', interventionVersion:1, interventionId:'card-1',
  reply:'رد', action:'خطوة', followUp:{timing:'later_today',prompt:'شو صار؟',journeyDomainId:'attachment'}, observation,
};

const route: RoutingResult = {
  mode:'coach', state:'moderate_activation', need:'connection', pattern:'attachment_alarm', patternConfidence:'medium',
  candidateCodes:['ATT_TRIGGER_001'], journeyDomainId:'attachment',
};

test('model observation row derives identity and audit fields from server arguments only',()=>{
  const injected={...observation,user_id:'evil-user',userId:'evil-user'} as CandidateObservation & Record<string,unknown>;
  const row=buildModelObservationRow({userId:'auth-user',observation:injected,turn,now:'2026-08-29T10:00:00Z'});
  assert.equal(row.user_id,'auth-user');
  assert.equal(row.source_type,'malaak_message');
  assert.equal(row.source_id,null);
  assert.equal(row.occurred_at,'2026-08-29T10:00:00.000Z');
  assert.equal(row.intervention_code,'ATT_TRIGGER_001');
  assert.equal(row.intervention_version,1);
  assert.equal(row.extraction_origin,'model_extracted');
  assert.equal(row.confirmed_by_user,false);
  assert.equal('userId' in row,false);
});

test('observation id merge is immutable and de-duplicates ids',()=>{
  const original=['a','b'];
  const merged=mergeObservationIds(original,'b');
  assert.deepEqual(merged,['a','b']);
  assert.deepEqual(original,['a','b']);
  assert.notEqual(merged,original);
  assert.deepEqual(mergeObservationIds(original,'c'),['a','b','c']);
});

test('route pattern descriptors are bounded and unknown patterns create no hypothesis',()=>{
  assert.deepEqual(patternDescriptorForRoute(route),{
    domain:'attachment', patternKey:'attachment_alarm',
    statementAr:'المسافة أو تأخر التواصل قد يفعّل إنذارًا عاطفيًا أو خوفًا في بعض المواقف.',
  });
  assert.equal(patternDescriptorForRoute({...route,pattern:'unknown',journeyDomainId:null}),null);
});

test('hypothesis mutation honors rejection timestamp and uses only fresh evidence for current counts',()=>{
  const existing={
    id:'h1', status:'user_rejected', confidence_label:'low', user_validation:'no', rejected_at:'2026-08-04T00:00:00Z',
    supporting_observation_ids:['old1','old2','old3'], contradicting_observation_ids:[],
  };
  const mutation=buildHypothesisMutation({
    userId:'auth-user', route, existing,
    supporting:[
      {id:'old1',occurredAt:'2026-08-01T10:00:00Z',contextDomain:'relationship'},
      {id:'old2',occurredAt:'2026-08-02T10:00:00Z',contextDomain:'relationship'},
      {id:'old3',occurredAt:'2026-08-03T10:00:00Z',contextDomain:'relationship'},
      {id:'fresh1',occurredAt:'2026-08-06T10:00:00Z',contextDomain:'relationship'},
    ],
    contradicting:[], now:'2026-08-07T00:00:00Z', activeJourneyLinked:false,
  });
  assert.ok(mutation);
  assert.equal(mutation.row.user_id,'auth-user');
  assert.equal(mutation.row.status,'candidate');
  assert.equal(mutation.row.confidence_label,'low');
  assert.equal(mutation.row.support_count,1);
  assert.deepEqual(mutation.row.supporting_observation_ids,['fresh1']);
  assert.equal(mutation.decision.eligibleForRouting,false);
});
