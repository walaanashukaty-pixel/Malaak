from pathlib import Path
import sys
p=Path('supabase/migrations/20260829_malaak_formulation_v5.sql')
if not p.exists():
    print('FAIL: missing V5B formulation migration'); sys.exit(1)
t=p.read_text(encoding='utf-8').lower(); compact=''.join(t.split())
required_tables=['malaak_initial_maps','malaak_observations','malaak_hypotheses','malaak_formulations']
failed=[]
for table in required_tables:
    if f'create table if not exists public.{table}' not in t: failed.append(f'missing {table}')
fields={
'malaak_initial_maps':['primary_concern','life_context','current_impact','immediate_safety','desired_change','coaching_preference','privacy_scope'],
'malaak_observations':['source_type','source_id','occurred_at','context_domain','trigger','event_fact','automatic_thought','emotion','intensity_before','body_signals','urge','need','behavior','outcome','intensity_after','recovery_minutes','intervention_code','intervention_version','intervention_helpfulness','extraction_origin','confirmed_by_user'],
'malaak_hypotheses':['domain','pattern_key','statement_ar','status','confidence_label','supporting_observation_ids','contradicting_observation_ids','support_count','distinct_days','distinct_contexts','first_seen_at','last_seen_at','user_validation','rejected_at'],
'malaak_formulations':['version','status','primary_context','current_state_summary','vulnerability_factors','trigger_patterns','interpretation_patterns','emotion_patterns','need_patterns','behavior_patterns','short_term_consequences','long_term_consequences','protective_factors','current_goals','validated_insights','unknowns']}
for table,names in fields.items():
    for name in names:
        if name not in t: failed.append(f'{table}.{name}')
for table in required_tables:
    if f'alter table public.{table} enable row level security' not in t: failed.append(f'RLS {table}')
    if f'revoke all privileges on table public.{table} from anon, authenticated' not in t: failed.append(f'revoke {table}')
    if f'grant select on table public.{table} to authenticated' not in t: failed.append(f'select grant {table}')
checks={
'impact constraint': "current_impactin('low','moderate','high')" in compact,
'observation origin constraint': "extraction_originin('user_structured','user_confirmed','model_extracted')" in compact,
'hypothesis status constraint': "statusin('candidate','repeated','user_validated','user_rejected','dormant')" in compact,
'confidence constraint': "confidence_labelin('low','medium','high')" in compact,
'user validation constraint': "user_validationisnulloruser_validationin('yes','partly','no')" in compact,
'formulation status constraint': "statusin('active','archived')" in compact,
'one active formulation': 'malaak_formulations_one_active_idx' in t and "where status = 'active'" in t,
'formulation version unique': 'unique (user_id, version)' in t or 'unique(user_id,version)' in compact,
'reject rpc': 'create or replace function public.malaak_reject_hypothesis' in t and 'auth.uid()' in t,
'observation rpc': 'create or replace function public.malaak_submit_observation' in t and 'auth.uid()' in t,
'initial map rpc': 'create or replace function public.malaak_save_initial_map' in t and 'auth.uid()' in t,
'no anon execute': 'revoke all on function public.malaak_reject_hypothesis' in t and 'revoke all on function public.malaak_submit_observation' in t,
}
failed.extend(name for name,ok in checks.items() if not ok)
if failed:
    print('FAIL:', ', '.join(failed)); sys.exit(1)
print('PASS: V5B formulation schema structure')
