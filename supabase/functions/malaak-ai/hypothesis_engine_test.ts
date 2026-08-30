import test from 'node:test';
import assert from 'node:assert/strict';
import { evaluateHypothesisEvidence } from './hypothesis_engine.ts';

const obs=(id:string,date:string,context='relationship')=>({id,occurredAt:date,contextDomain:context});

test('one supporting observation creates candidate low only',()=>{
  const d=evaluateHypothesisEvidence({supporting:[obs('1','2026-08-01T10:00:00Z')],contradicting:[],now:'2026-08-02T00:00:00Z'});
  assert.equal(d.status,'candidate'); assert.equal(d.confidenceLabel,'low'); assert.equal(d.supportCount,1);
});

test('three supporting observations across two distinct days become repeated medium',()=>{
  const d=evaluateHypothesisEvidence({supporting:[obs('1','2026-08-01T10:00:00Z'),obs('2','2026-08-01T20:00:00Z'),obs('3','2026-08-02T08:00:00Z')],contradicting:[],now:'2026-08-03T00:00:00Z'});
  assert.equal(d.status,'repeated'); assert.equal(d.confidenceLabel,'medium'); assert.equal(d.distinctDays,2);
});

test('five supports across three days plus explicit yes validation become user_validated high',()=>{
  const d=evaluateHypothesisEvidence({supporting:[obs('1','2026-08-01T10:00:00Z'),obs('2','2026-08-01T20:00:00Z'),obs('3','2026-08-02T08:00:00Z'),obs('4','2026-08-03T08:00:00Z'),obs('5','2026-08-03T18:00:00Z')],contradicting:[],userValidation:'yes',now:'2026-08-04T00:00:00Z'});
  assert.equal(d.status,'user_validated'); assert.equal(d.confidenceLabel,'high');
});

test('six supports across two contexts can be repeated high without user validation',()=>{
  const d=evaluateHypothesisEvidence({supporting:[obs('1','2026-08-01T10:00:00Z','relationship'),obs('2','2026-08-01T20:00:00Z','relationship'),obs('3','2026-08-02T08:00:00Z','family'),obs('4','2026-08-02T18:00:00Z','family'),obs('5','2026-08-03T08:00:00Z','relationship'),obs('6','2026-08-03T18:00:00Z','family')],contradicting:[],now:'2026-08-04T00:00:00Z'});
  assert.equal(d.status,'repeated'); assert.equal(d.confidenceLabel,'high'); assert.equal(d.distinctContexts,2);
});

test('user rejection locks hypothesis until independent evidence after rejection',()=>{
  const old=[obs('1','2026-08-01T10:00:00Z'),obs('2','2026-08-02T10:00:00Z'),obs('3','2026-08-03T10:00:00Z')];
  const locked=evaluateHypothesisEvidence({supporting:old,contradicting:[],userValidation:'no',rejectedAt:'2026-08-04T00:00:00Z',now:'2026-08-05T00:00:00Z'});
  assert.equal(locked.status,'user_rejected'); assert.equal(locked.eligibleForRouting,false);
  const fresh=evaluateHypothesisEvidence({supporting:[...old,obs('4','2026-08-06T10:00:00Z')],contradicting:[],userValidation:'no',rejectedAt:'2026-08-04T00:00:00Z',now:'2026-08-07T00:00:00Z'});
  assert.equal(fresh.status,'candidate'); assert.equal(fresh.supportCount,1); assert.equal(fresh.eligibleForRouting,false);
});

test('strong contradictions prevent promotion even with three supports',()=>{
  const d=evaluateHypothesisEvidence({supporting:[obs('1','2026-08-01T10:00:00Z'),obs('2','2026-08-02T10:00:00Z'),obs('3','2026-08-03T10:00:00Z')],contradicting:[obs('c1','2026-08-02T12:00:00Z'),obs('c2','2026-08-03T12:00:00Z'),obs('c3','2026-08-03T14:00:00Z')],strongContradiction:true,now:'2026-08-04T00:00:00Z'});
  assert.equal(d.status,'candidate'); assert.equal(d.confidenceLabel,'low');
});

test('pattern becomes dormant after 90 days unless linked to active journey',()=>{
  const base={supporting:[obs('1','2026-01-01T10:00:00Z'),obs('2','2026-01-02T10:00:00Z'),obs('3','2026-01-03T10:00:00Z')],contradicting:[],now:'2026-05-01T00:00:00Z'};
  assert.equal(evaluateHypothesisEvidence(base).status,'dormant');
  assert.equal(evaluateHypothesisEvidence({...base,activeJourneyLinked:true}).status,'repeated');
});

test('prior user rejection keeps fresh evidence out of routing until user reviews it again',()=>{
  const fresh=[
    obs('n1','2026-08-05T10:00:00Z','relationship'),
    obs('n2','2026-08-06T10:00:00Z','family'),
    obs('n3','2026-08-07T10:00:00Z','relationship'),
    obs('n4','2026-08-08T10:00:00Z','family'),
    obs('n5','2026-08-09T10:00:00Z','relationship'),
    obs('n6','2026-08-10T10:00:00Z','family'),
  ];
  const d=evaluateHypothesisEvidence({
    supporting:[obs('old','2026-08-01T10:00:00Z'),...fresh],
    contradicting:[],
    userValidation:'no',
    rejectedAt:'2026-08-04T00:00:00Z',
    now:'2026-08-11T00:00:00Z',
  });
  assert.equal(d.status,'candidate');
  assert.equal(d.eligibleForRouting,false);
  assert.equal(d.supportCount,6);
});
