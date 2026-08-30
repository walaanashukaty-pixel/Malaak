from pathlib import Path
import re, sys
cards=sorted(Path('supabase/migrations').glob('20260829_malaak_intervention_seed_v5_cards_*.sql'))
sources=sorted(Path('supabase/migrations').glob('20260829_malaak_intervention_seed_v5_sources_*.sql'))
if len(cards)!=8 or len(sources)!=8:
    print(f'FAIL: expected 8 card + 8 source parts, got {len(cards)} + {len(sources)}'); sys.exit(1)
card_text='\n'.join(p.read_text(encoding='utf-8') for p in cards)
source_text='\n'.join(p.read_text(encoding='utf-8') for p in sources)
codes=set(re.findall(r"'([A-Z]+(?:_[A-Z]+)*_[0-9]{3})'", card_text))
expected={
'REG_GROUND_001','REG_MOVE_002','REG_BREATHE_003','EMO_NAME_001','EMO_CHAIN_002','LOAD_SORT_001','CONTROL_CIRCLE_001','REST_RECOVERY_001','NEED_NAME_001','NEED_STRATEGY_002','REQUEST_DIRECT_001','BOUNDARY_001','NO_TOLERATE_002','UNCERTAINTY_001','ATT_TRIGGER_001','ATT_REALITY_002','ATT_REASSURE_DELAY_003','ATT_REPAIR_004','REL_CYCLE_001','ANGER_TIMEOUT_001','REL_SOFT_START_002','REL_REPAIR_003','REL_TRUST_STEP_004','THOUGHT_FACTS_001','RUMINATION_EXIT_001','PROBLEM_SOLVE_001','WORRY_POSTPONE_002','DEFUSION_003','REASSURANCE_BREAK_004','ANGER_THERMOMETER_002','ANGER_CHAIN_003','ANGER_ASSERT_004','ANGER_REPAIR_005','CHILD_PRESENT_PAST_001','CHILD_OLD_BELIEF_002','CHILD_SELF_COMPASSION_003','CHILD_PATTERN_EXPERIMENT_004','HEAL_STABILIZE_001','HEAL_FACTS_STORY_002','HEAL_GRIEF_003','HEAL_SELF_WORTH_004','HEAL_TRUST_GRADUAL_005','BAL_WAR_MODE_001','BAL_CONTROL_RESP_002','BAL_RECEIVE_REST_003','FI_STATE_COMPASS_001','FI_TIME_DISTANCE_002','FI_EMOTION_INTENTION_003'}
failed=[]
if codes != expected: failed.append(f'code mismatch missing={sorted(expected-codes)} extra={sorted(codes-expected)}')
if sum(p.read_text().count('insert into public.malaak_interventions') for p in cards)!=48: failed.append('expected exactly 48 intervention inserts')
if 'insert into public.malaak_intervention_sources' not in source_text: failed.append('missing source inserts')
if 'delete from public.malaak_intervention_sources' not in source_text: failed.append('sources must replace noncanonical rows per chunk')
if failed: print('FAIL:', '; '.join(failed)); sys.exit(1)
print('PASS: V5A seed migrations include 48 candidate cards plus canonical source replacements')
