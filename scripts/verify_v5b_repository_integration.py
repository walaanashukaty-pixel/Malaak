from pathlib import Path
import sys
root=Path('.')
idx=(root/'supabase/functions/malaak-ai/index.ts').read_text(encoding='utf-8')
repo=(root/'supabase/functions/malaak-ai/formulation_repository.ts').read_text(encoding='utf-8')
migration=(root/'supabase/migrations/20260829_malaak_formulation_v5.sql').read_text(encoding='utf-8').lower()
failed=[]
checks={
    'index imports persistence':'persistCoachingEvidence' in idx,
    'index passes authenticated subject':'userId: jwtPayload.sub' in idx,
    'index does not take request user id':'body.userId' not in idx and 'body.user_id' not in idx,
    'persistence failure isolated':'catch' in idx and 'Malaak evidence persistence failed' in idx,
    'model extraction origin fixed':"extraction_origin: 'model_extracted'" in repo,
    'server user id fixed':'user_id: userId' in repo,
    'rejected timestamp schema':'rejected_at timestamptz null' in migration,
    'reject rpc timestamps rejection':"rejected_at=now()" in ''.join(migration.split()),
}
for name,ok in checks.items():
    if not ok: failed.append(name)
if failed:
    print('FAIL:', ', '.join(failed)); sys.exit(1)
print('PASS: V5B server-owned observation/hypothesis integration')
