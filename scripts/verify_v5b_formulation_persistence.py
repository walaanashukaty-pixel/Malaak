from pathlib import Path
import sys
m=Path('supabase/migrations/20260829_malaak_formulation_v5.sql').read_text(encoding='utf-8').lower()
r=Path('supabase/functions/malaak-ai/formulation_repository.ts').read_text(encoding='utf-8')
compact=''.join(m.split())
checks={
  'store formulation rpc':'create or replace function public.malaak_store_formulation_snapshot' in m,
  'transaction user lock':'pg_advisory_xact_lock' in m,
  'archives active row':"setstatus='archived'" in compact and "wherestatus='active'" in compact,
  'service-role-only execute':'grant execute on function public.malaak_store_formulation_snapshot(uuid,jsonb) to service_role' in m,
  'authenticated cannot execute':'revoke all on function public.malaak_store_formulation_snapshot(uuid,jsonb) from public, anon, authenticated' in m,
  'repository builds snapshots':'buildFormulationSnapshot' in r and 'buildFormulationVersionRequest' in r,
  'repository refresh function':'persistFormulationIfChanged' in r,
  'coaching persistence refreshes formulation':'await persistFormulationIfChanged' in r,
}
failed=[name for name,ok in checks.items() if not ok]
if failed:
  print('FAIL:',', '.join(failed)); sys.exit(1)
print('PASS: V5B append-only formulation persistence integration')
