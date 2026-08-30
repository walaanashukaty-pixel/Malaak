import test from 'node:test';
import assert from 'node:assert/strict';
import {
  buildFormulationSnapshot,
  isMaterialFormulationChange,
  buildFormulationVersionRequest,
} from './formulation.ts';

const obs=(id:string, context='relationship', emotion='خوف', need='اتصال')=>({
  id, occurred_at:'2026-08-29T10:00:00Z', context_domain:context, emotion, need,
  trigger:'تأخر الرد', outcome:'توتر', extraction_origin:'model_extracted', confirmed_by_user:false,
});
const hyp=(pattern_key:string,status='candidate',confidence_label='low',statement_ar='فرضية أولية')=>({
  id:`h-${pattern_key}`,domain:'attachment',pattern_key,statement_ar,status,confidence_label,user_validation:null,
});

test('formulation keeps candidate hypotheses in unknowns and never presents them as validated facts',()=>{
  const snapshot=buildFormulationSnapshot({
    observations:[obs('o1')],
    hypotheses:[hyp('attachment_alarm')],
    goals:['أكون أهدأ بالعلاقة'],
  });
  assert.ok(snapshot.unknowns.length>0);
  assert.equal(snapshot.validated_insights.length,0);
  assert.equal(JSON.stringify(snapshot.trigger_patterns).includes('فرضية أولية'),false);
  assert.match(snapshot.current_state_summary,/ليست تشخيصًا/);
});

test('repeated and user-validated hypotheses are represented with evidence labels rather than facts',()=>{
  const snapshot=buildFormulationSnapshot({
    observations:[obs('o1'),obs('o2')],
    hypotheses:[
      {...hyp('attachment_alarm','repeated','medium'),statement_ar:'المسافة تفعّل إنذارًا عاطفيًا'},
      {...hyp('reassurance_loop','user_validated','high'),statement_ar:'الفحص المتكرر يعطيني راحة قصيرة',user_validation:'yes'},
    ],
    goals:['تنظيم الخوف'],
  });
  const all=JSON.stringify(snapshot);
  assert.match(all,/evidenceStatus/);
  assert.match(all,/repeated/);
  assert.match(all,/user_validated/);
  assert.equal(snapshot.validated_insights.length,1);
  assert.equal(snapshot.validated_insights[0].statementAr,'الفحص المتكرر يعطيني راحة قصيرة');
});

test('candidate-only changes do not create formulation version churn',()=>{
  const previous=buildFormulationSnapshot({observations:[obs('o1')],hypotheses:[],goals:['هدوء']});
  const next=buildFormulationSnapshot({observations:[obs('o1')],hypotheses:[hyp('new_candidate')],goals:['هدوء']});
  assert.equal(isMaterialFormulationChange(previous,next),false);
});

test('validated pattern or goal change is material',()=>{
  const base=buildFormulationSnapshot({observations:[obs('o1')],hypotheses:[],goals:['هدوء']});
  const pattern=buildFormulationSnapshot({
    observations:[obs('o1')],
    hypotheses:[{...hyp('attachment_alarm','repeated','medium'),statement_ar:'المسافة تفعّل خوفًا'}],
    goals:['هدوء'],
  });
  const goal=buildFormulationSnapshot({observations:[obs('o1')],hypotheses:[],goals:['حدود أوضح']});
  assert.equal(isMaterialFormulationChange(base,pattern),true);
  assert.equal(isMaterialFormulationChange(base,goal),true);
});

test('version request archives previous active row and increments version only on material change',()=>{
  const previousSnapshot=buildFormulationSnapshot({observations:[obs('o1')],hypotheses:[],goals:['هدوء']});
  const nextSnapshot=buildFormulationSnapshot({
    observations:[obs('o1')],
    hypotheses:[{...hyp('attachment_alarm','repeated','medium'),statement_ar:'المسافة تفعّل خوفًا'}],goals:['هدوء'],
  });
  const request=buildFormulationVersionRequest({userId:'u1',previous:{id:'f1',version:3,snapshot:previousSnapshot},next:nextSnapshot});
  assert.ok(request);
  assert.equal(request.archiveId,'f1');
  assert.equal(request.insert.user_id,'u1');
  assert.equal(request.insert.version,4);
  assert.equal(request.insert.status,'active');
  const noChange=buildFormulationVersionRequest({userId:'u1',previous:{id:'f1',version:3,snapshot:previousSnapshot},next:previousSnapshot});
  assert.equal(noChange,null);
});

test('dominant life context change is material without turning it into a diagnosis',()=>{
  const relationship=buildFormulationSnapshot({observations:[obs('o1','relationship'),obs('o2','relationship')],hypotheses:[],goals:['هدوء']});
  const work=buildFormulationSnapshot({observations:[obs('o1','work'),obs('o2','work')],hypotheses:[],goals:['هدوء']});
  assert.equal(isMaterialFormulationChange(relationship,work),true);
});
