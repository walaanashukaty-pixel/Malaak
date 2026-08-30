-- Generated deterministically from supabase/functions/malaak-ai/catalog_seed.ts
-- V5 intervention sources part 6 of 8. Replaces source rows for this card chunk.

delete from public.malaak_intervention_sources where intervention_id in (select id from public.malaak_interventions where code in ('ANGER_CHAIN_003','ANGER_ASSERT_004','ANGER_REPAIR_005','CHILD_PRESENT_PAST_001','CHILD_OLD_BELIEF_002','CHILD_SELF_COMPASSION_003'));

insert into public.malaak_intervention_sources (
  intervention_id, source_type, citation_text, source_url, publication_year, supports, limitations, license_notes, reviewed_at, reviewed_by
) select i.id, 'meta_analysis', 'DiGiuseppe R, Tafrate RC. Effectiveness of anger treatments for specific anger problems: a meta-analytic review. Clin Psychol Rev. 2003/2004. PMID 14992805.', 'https://pubmed.ncbi.nlm.nih.gov/14992805/', 2004, 'Cognitive and behavioral anger treatments show meaningful effects across anger presentations; appraisal and response skills are relevant targets.', 'Older heterogeneous literature; safety risk overrides self-help anger coaching.', 'General anger-management principles summarized.', now(), 'Malaak V5 evidence review'
from public.malaak_interventions i where i.code = 'ANGER_CHAIN_003' and i.version = 1
on conflict (intervention_id, source_url, supports) do nothing;

insert into public.malaak_intervention_sources (
  intervention_id, source_type, citation_text, source_url, publication_year, supports, limitations, license_notes, reviewed_at, reviewed_by
) select i.id, 'systematic_review', 'McRae K, Gross JJ. Emotion regulation. Emotion. 2020;20(1):1-9. PMID 31961170.', 'https://pubmed.ncbi.nlm.nih.gov/31961170/', 2020, 'Process-based emotion regulation: identify need, select/implement a strategy, then monitor success; cognitive reappraisal is a well-studied strategy.', 'Conceptual review; does not validate a particular app exercise or imply one strategy is universally best.', 'Conceptual principles summarized.', now(), 'Malaak V5 evidence review'
from public.malaak_interventions i where i.code = 'ANGER_CHAIN_003' and i.version = 1
on conflict (intervention_id, source_url, supports) do nothing;

insert into public.malaak_intervention_sources (
  intervention_id, source_type, citation_text, source_url, publication_year, supports, limitations, license_notes, reviewed_at, reviewed_by
) select i.id, 'meta_analysis', 'DiGiuseppe R, Tafrate RC. Effectiveness of anger treatments for specific anger problems: a meta-analytic review. Clin Psychol Rev. 2003/2004. PMID 14992805.', 'https://pubmed.ncbi.nlm.nih.gov/14992805/', 2004, 'Cognitive and behavioral anger treatments show meaningful effects across anger presentations; appraisal and response skills are relevant targets.', 'Older heterogeneous literature; safety risk overrides self-help anger coaching.', 'General anger-management principles summarized.', now(), 'Malaak V5 evidence review'
from public.malaak_interventions i where i.code = 'ANGER_ASSERT_004' and i.version = 1
on conflict (intervention_id, source_url, supports) do nothing;

insert into public.malaak_intervention_sources (
  intervention_id, source_type, citation_text, source_url, publication_year, supports, limitations, license_notes, reviewed_at, reviewed_by
) select i.id, 'meta_analysis', 'Hede JP, Malouff JM, Meynadier J. A Meta-Analysis of Randomised Controlled Trials on the Efficacy of Assertiveness Training for Social Anxiety. 2026.', 'https://link.springer.com/article/10.1007/s41042-026-00297-7', 2026, 'Assertiveness training can improve assertive behavior in studied populations and supports practicing direct, respectful communication.', 'Population/effects are not equivalent to all relationship contexts; does not justify confrontation where danger is possible.', 'Underlying assertiveness principles summarized in original wording.', now(), 'Malaak V5 evidence review'
from public.malaak_interventions i where i.code = 'ANGER_ASSERT_004' and i.version = 1
on conflict (intervention_id, source_url, supports) do nothing;

insert into public.malaak_intervention_sources (
  intervention_id, source_type, citation_text, source_url, publication_year, supports, limitations, license_notes, reviewed_at, reviewed_by
) select i.id, 'meta_analysis', 'DiGiuseppe R, Tafrate RC. Effectiveness of anger treatments for specific anger problems: a meta-analytic review. Clin Psychol Rev. 2003/2004. PMID 14992805.', 'https://pubmed.ncbi.nlm.nih.gov/14992805/', 2004, 'Cognitive and behavioral anger treatments show meaningful effects across anger presentations; appraisal and response skills are relevant targets.', 'Older heterogeneous literature; safety risk overrides self-help anger coaching.', 'General anger-management principles summarized.', now(), 'Malaak V5 evidence review'
from public.malaak_interventions i where i.code = 'ANGER_REPAIR_005' and i.version = 1
on conflict (intervention_id, source_url, supports) do nothing;

insert into public.malaak_intervention_sources (
  intervention_id, source_type, citation_text, source_url, publication_year, supports, limitations, license_notes, reviewed_at, reviewed_by
) select i.id, 'guideline', 'SAMHSA. Trauma-Informed Approaches and Programs.', 'https://www.samhsa.gov/mental-health/trauma-violence/trauma-informed-approaches-programs', 2026, 'Safety, trust/transparency, collaboration, empowerment, voice/choice and avoiding re-traumatization.', 'Trauma-informed principles are not a self-administered trauma-processing protocol.', 'Principles only; no protected clinical protocol copied.', now(), 'Malaak V5 evidence review'
from public.malaak_interventions i where i.code = 'ANGER_REPAIR_005' and i.version = 1
on conflict (intervention_id, source_url, supports) do nothing;

insert into public.malaak_intervention_sources (
  intervention_id, source_type, citation_text, source_url, publication_year, supports, limitations, license_notes, reviewed_at, reviewed_by
) select i.id, 'guideline', 'SAMHSA. Trauma-Informed Approaches and Programs.', 'https://www.samhsa.gov/mental-health/trauma-violence/trauma-informed-approaches-programs', 2026, 'Safety, trust/transparency, collaboration, empowerment, voice/choice and avoiding re-traumatization.', 'Trauma-informed principles are not a self-administered trauma-processing protocol.', 'Principles only; no protected clinical protocol copied.', now(), 'Malaak V5 evidence review'
from public.malaak_interventions i where i.code = 'CHILD_PRESENT_PAST_001' and i.version = 1
on conflict (intervention_id, source_url, supports) do nothing;

insert into public.malaak_intervention_sources (
  intervention_id, source_type, citation_text, source_url, publication_year, supports, limitations, license_notes, reviewed_at, reviewed_by
) select i.id, 'meta_analysis', 'Zhang H, et al. Effects of Childhood Maltreatment on Self-Compassion: A Systematic Review and Meta-Analysis. 2021. PMID 34510982.', 'https://pubmed.ncbi.nlm.nih.gov/34510982/', 2021, 'Childhood maltreatment experiences are associated with lower self-compassion, supporting cautious attention to self-criticism/self-compassion in developmental-history work.', 'Association does not establish a single causal pathway or justify reconstructing hidden memories.', 'Research association summarized.', now(), 'Malaak V5 evidence review'
from public.malaak_interventions i where i.code = 'CHILD_PRESENT_PAST_001' and i.version = 1
on conflict (intervention_id, source_url, supports) do nothing;

insert into public.malaak_intervention_sources (
  intervention_id, source_type, citation_text, source_url, publication_year, supports, limitations, license_notes, reviewed_at, reviewed_by
) select i.id, 'guideline', 'SAMHSA. Trauma-Informed Approaches and Programs.', 'https://www.samhsa.gov/mental-health/trauma-violence/trauma-informed-approaches-programs', 2026, 'Safety, trust/transparency, collaboration, empowerment, voice/choice and avoiding re-traumatization.', 'Trauma-informed principles are not a self-administered trauma-processing protocol.', 'Principles only; no protected clinical protocol copied.', now(), 'Malaak V5 evidence review'
from public.malaak_interventions i where i.code = 'CHILD_OLD_BELIEF_002' and i.version = 1
on conflict (intervention_id, source_url, supports) do nothing;

insert into public.malaak_intervention_sources (
  intervention_id, source_type, citation_text, source_url, publication_year, supports, limitations, license_notes, reviewed_at, reviewed_by
) select i.id, 'meta_analysis', 'Zhang H, et al. Effects of Childhood Maltreatment on Self-Compassion: A Systematic Review and Meta-Analysis. 2021. PMID 34510982.', 'https://pubmed.ncbi.nlm.nih.gov/34510982/', 2021, 'Childhood maltreatment experiences are associated with lower self-compassion, supporting cautious attention to self-criticism/self-compassion in developmental-history work.', 'Association does not establish a single causal pathway or justify reconstructing hidden memories.', 'Research association summarized.', now(), 'Malaak V5 evidence review'
from public.malaak_interventions i where i.code = 'CHILD_OLD_BELIEF_002' and i.version = 1
on conflict (intervention_id, source_url, supports) do nothing;

insert into public.malaak_intervention_sources (
  intervention_id, source_type, citation_text, source_url, publication_year, supports, limitations, license_notes, reviewed_at, reviewed_by
) select i.id, 'meta_analysis', 'Han A, Kim TH. Effects of Self-Compassion Interventions on Reducing Depressive Symptoms, Anxiety, and Stress: A Meta-Analysis. 2023. PMID 37362192.', 'https://pubmed.ncbi.nlm.nih.gov/37362192/', 2023, 'Self-compassion interventions show small-to-medium benefits for distress-related outcomes and support compassionate self-responding as an adjunctive skill.', 'Risk of bias was high across included RCTs; not a stand-alone treatment claim or permission to avoid responsibility.', 'General self-compassion principles summarized.', now(), 'Malaak V5 evidence review'
from public.malaak_interventions i where i.code = 'CHILD_SELF_COMPASSION_003' and i.version = 1
on conflict (intervention_id, source_url, supports) do nothing;

insert into public.malaak_intervention_sources (
  intervention_id, source_type, citation_text, source_url, publication_year, supports, limitations, license_notes, reviewed_at, reviewed_by
) select i.id, 'meta_analysis', 'Zhang H, et al. Effects of Childhood Maltreatment on Self-Compassion: A Systematic Review and Meta-Analysis. 2021. PMID 34510982.', 'https://pubmed.ncbi.nlm.nih.gov/34510982/', 2021, 'Childhood maltreatment experiences are associated with lower self-compassion, supporting cautious attention to self-criticism/self-compassion in developmental-history work.', 'Association does not establish a single causal pathway or justify reconstructing hidden memories.', 'Research association summarized.', now(), 'Malaak V5 evidence review'
from public.malaak_interventions i where i.code = 'CHILD_SELF_COMPASSION_003' and i.version = 1
on conflict (intervention_id, source_url, supports) do nothing;

insert into public.malaak_intervention_sources (
  intervention_id, source_type, citation_text, source_url, publication_year, supports, limitations, license_notes, reviewed_at, reviewed_by
) select i.id, 'guideline', 'SAMHSA. Trauma-Informed Approaches and Programs.', 'https://www.samhsa.gov/mental-health/trauma-violence/trauma-informed-approaches-programs', 2026, 'Safety, trust/transparency, collaboration, empowerment, voice/choice and avoiding re-traumatization.', 'Trauma-informed principles are not a self-administered trauma-processing protocol.', 'Principles only; no protected clinical protocol copied.', now(), 'Malaak V5 evidence review'
from public.malaak_interventions i where i.code = 'CHILD_SELF_COMPASSION_003' and i.version = 1
on conflict (intervention_id, source_url, supports) do nothing;

