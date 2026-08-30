from pathlib import Path
import sys

p = Path('supabase/migrations/20260829_malaak_intervention_catalog_v5.sql')
if not p.exists():
    print('FAIL: missing catalog migration')
    sys.exit(1)
text = p.read_text(encoding='utf-8').lower()
checks = {
    'interventions table': 'create table if not exists public.malaak_interventions' in text,
    'sources table': 'create table if not exists public.malaak_intervention_sources' in text,
    'code/version uniqueness': 'unique (code, version)' in text or 'unique(code, version)' in text,
    'single active version index': 'where status = \'active\'' in text and 'unique index' in text,
    'status constraint': "statusin('draft','active','paused','retired','prohibited')" in text.replace(' ', ''),
    'evidence tier constraint': "evidence_tierin('a','b','c','d','x')" in text.replace(' ', ''),
    'licensing constraint': 'licensing_status' in text and 'cleared_original' in text and 'restricted' in text,
    'scientific review constraint': 'scientific_review_status' in text and 'reviewed' in text,
    'boundary review constraint': 'clinical_boundary_review_status' in text,
    'coaching version column': 'add column if not exists intervention_version integer' in text,
    'coaching catalog id column': 'add column if not exists intervention_id uuid' in text,
    'coaching intervention fk index': 'malaak_coaching_turns_intervention_idx' in text and 'on public.malaak_coaching_turns(intervention_id)' in text,
    'rls interventions': 'alter table public.malaak_interventions enable row level security' in text,
    'rls sources': 'alter table public.malaak_intervention_sources enable row level security' in text,
    'revoke writes': 'revoke all privileges on table public.malaak_interventions from anon, authenticated' in text,
    'authenticated read': 'grant select on table public.malaak_interventions to authenticated' in text,
}
failed=[name for name,ok in checks.items() if not ok]
if failed:
    print('FAIL:', ', '.join(failed))
    sys.exit(1)
print('PASS: V5A catalog schema structure')
