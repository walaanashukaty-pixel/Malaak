from pathlib import Path
root=Path(__file__).resolve().parents[1]
path=root/'supabase/migrations/20260829_malaak_journey_planner_v5.sql'
assert path.exists(), 'missing V5C journey planner migration'
s=path.read_text(encoding='utf-8').lower()
for token in [
    'create table if not exists public.malaak_journey_plans',
    'primary_domain text', 'primary_goal text', 'support_domain text', 'support_goal text',
    'monitor_domains text[]', 'later_domains text[]', 'reasoning_summary_ar text',
    'based_on_formulation_version integer', 'review_due_at timestamptz',
    "status text not null default 'active'", "check (status in ('active','maintenance','paused'))",
    'unique (user_id, version)', 'enable row level security',
    'grant select on table public.malaak_journey_plans to authenticated',
]:
    assert token in s, f'missing V5C schema token: {token}'
assert 'grant insert on table public.malaak_journey_plans to authenticated' not in s
assert 'grant update on table public.malaak_journey_plans to authenticated' not in s
assert 'grant delete on table public.malaak_journey_plans to authenticated' not in s
assert 'malaak_journey_plans_one_active_idx' in s
print('PASS: V5C journey planner schema structure')
