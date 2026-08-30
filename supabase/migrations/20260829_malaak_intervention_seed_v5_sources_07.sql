-- Generated deterministically from supabase/functions/malaak-ai/catalog_seed.ts
-- V5 intervention sources part 7 of 8. Replaces source rows for this card chunk.

delete from public.malaak_intervention_sources where intervention_id in (select id from public.malaak_interventions where code in ('CHILD_PATTERN_EXPERIMENT_004','HEAL_STABILIZE_001','HEAL_FACTS_STORY_002','HEAL_GRIEF_003','HEAL_SELF_WORTH_004','HEAL_TRUST_GRADUAL_005'));

insert into public.malaak_intervention_sources (
  intervention_id, source_type, citation_text, source_url, publication_year, supports, limitations, license_notes, reviewed_at, reviewed_by
) select i.id, 'guideline', 'NICE CG113. Generalised anxiety disorder and panic disorder in adults: management. Recommendations.', 'https://www.nice.org.uk/guidance/cg113/chapter/Recommendations', 2020, 'Stepped care, CBT-based low-intensity self-help, routine outcome monitoring, problem-solving/cognitive principles, and stepping up with marked impairment or non-response.', 'Guideline is for diagnosed GAD/panic care; Malaak uses only transdiagnostic low-risk principles and does not diagnose or deliver high-intensity treatment.', 'Principles summarized; no treatment manual text copied.', now(), 'Malaak V5 evidence review'
from public.malaak_interventions i where i.code = 'CHILD_PATTERN_EXPERIMENT_004' and i.version = 1
on conflict (intervention_id, source_url, supports) do nothing;

insert into public.malaak_intervention_sources (
  intervention_id, source_type, citation_text, source_url, publication_year, supports, limitations, license_notes, reviewed_at, reviewed_by
) select i.id, 'guideline', 'SAMHSA. Trauma-Informed Approaches and Programs.', 'https://www.samhsa.gov/mental-health/trauma-violence/trauma-informed-approaches-programs', 2026, 'Safety, trust/transparency, collaboration, empowerment, voice/choice and avoiding re-traumatization.', 'Trauma-informed principles are not a self-administered trauma-processing protocol.', 'Principles only; no protected clinical protocol copied.', now(), 'Malaak V5 evidence review'
from public.malaak_interventions i where i.code = 'CHILD_PATTERN_EXPERIMENT_004' and i.version = 1
on conflict (intervention_id, source_url, supports) do nothing;

insert into public.malaak_intervention_sources (
  intervention_id, source_type, citation_text, source_url, publication_year, supports, limitations, license_notes, reviewed_at, reviewed_by
) select i.id, 'guideline', 'SAMHSA. Trauma-Informed Approaches and Programs.', 'https://www.samhsa.gov/mental-health/trauma-violence/trauma-informed-approaches-programs', 2026, 'Safety, trust/transparency, collaboration, empowerment, voice/choice and avoiding re-traumatization.', 'Trauma-informed principles are not a self-administered trauma-processing protocol.', 'Principles only; no protected clinical protocol copied.', now(), 'Malaak V5 evidence review'
from public.malaak_interventions i where i.code = 'HEAL_STABILIZE_001' and i.version = 1
on conflict (intervention_id, source_url, supports) do nothing;

insert into public.malaak_intervention_sources (
  intervention_id, source_type, citation_text, source_url, publication_year, supports, limitations, license_notes, reviewed_at, reviewed_by
) select i.id, 'guideline', 'World Health Organization. Psychological self-help interventions: delivering self-help for individuals, featuring Step-by-Step and Doing What Matters in Times of Stress. 2026.', 'https://www.who.int/publications/i/item/9789240120785', 2026, 'Structured low-intensity psychological self-help and guided/unguided delivery with appropriate scope boundaries.', 'Does not validate Malaak wording or authorize copying manual scripts; not a substitute for specialist treatment when impairment/risk is high.', 'WHO 2026 manual uses non-commercial terms by default; Malaak uses original wording and requires separate commercial permission before copying protected material.', now(), 'Malaak V5 evidence review'
from public.malaak_interventions i where i.code = 'HEAL_STABILIZE_001' and i.version = 1
on conflict (intervention_id, source_url, supports) do nothing;

insert into public.malaak_intervention_sources (
  intervention_id, source_type, citation_text, source_url, publication_year, supports, limitations, license_notes, reviewed_at, reviewed_by
) select i.id, 'guideline', 'NICE CG113. Generalised anxiety disorder and panic disorder in adults: management. Recommendations.', 'https://www.nice.org.uk/guidance/cg113/chapter/Recommendations', 2020, 'Stepped care, CBT-based low-intensity self-help, routine outcome monitoring, problem-solving/cognitive principles, and stepping up with marked impairment or non-response.', 'Guideline is for diagnosed GAD/panic care; Malaak uses only transdiagnostic low-risk principles and does not diagnose or deliver high-intensity treatment.', 'Principles summarized; no treatment manual text copied.', now(), 'Malaak V5 evidence review'
from public.malaak_interventions i where i.code = 'HEAL_FACTS_STORY_002' and i.version = 1
on conflict (intervention_id, source_url, supports) do nothing;

insert into public.malaak_intervention_sources (
  intervention_id, source_type, citation_text, source_url, publication_year, supports, limitations, license_notes, reviewed_at, reviewed_by
) select i.id, 'guideline', 'SAMHSA. Trauma-Informed Approaches and Programs.', 'https://www.samhsa.gov/mental-health/trauma-violence/trauma-informed-approaches-programs', 2026, 'Safety, trust/transparency, collaboration, empowerment, voice/choice and avoiding re-traumatization.', 'Trauma-informed principles are not a self-administered trauma-processing protocol.', 'Principles only; no protected clinical protocol copied.', now(), 'Malaak V5 evidence review'
from public.malaak_interventions i where i.code = 'HEAL_FACTS_STORY_002' and i.version = 1
on conflict (intervention_id, source_url, supports) do nothing;

insert into public.malaak_intervention_sources (
  intervention_id, source_type, citation_text, source_url, publication_year, supports, limitations, license_notes, reviewed_at, reviewed_by
) select i.id, 'meta_analysis', 'Komischke-Konnerup KB, et al. Grief-focused cognitive behavioral therapies for prolonged grief symptoms: A systematic review and meta-analysis. J Consult Clin Psychol. 2024;92(4):236-248.', 'https://pubmed.ncbi.nlm.nih.gov/38573714/', 2024, 'CBT-informed approaches can help prolonged grief symptoms; grief-related thoughts/behavior and adaptation are legitimate targets.', 'Malaak does not diagnose or treat prolonged grief disorder and does not use exposure-style grief treatment protocols.', 'General principles only.', now(), 'Malaak V5 evidence review'
from public.malaak_interventions i where i.code = 'HEAL_GRIEF_003' and i.version = 1
on conflict (intervention_id, source_url, supports) do nothing;

insert into public.malaak_intervention_sources (
  intervention_id, source_type, citation_text, source_url, publication_year, supports, limitations, license_notes, reviewed_at, reviewed_by
) select i.id, 'meta_analysis', 'Han A, Kim TH. Effects of Self-Compassion Interventions on Reducing Depressive Symptoms, Anxiety, and Stress: A Meta-Analysis. 2023. PMID 37362192.', 'https://pubmed.ncbi.nlm.nih.gov/37362192/', 2023, 'Self-compassion interventions show small-to-medium benefits for distress-related outcomes and support compassionate self-responding as an adjunctive skill.', 'Risk of bias was high across included RCTs; not a stand-alone treatment claim or permission to avoid responsibility.', 'General self-compassion principles summarized.', now(), 'Malaak V5 evidence review'
from public.malaak_interventions i where i.code = 'HEAL_SELF_WORTH_004' and i.version = 1
on conflict (intervention_id, source_url, supports) do nothing;

insert into public.malaak_intervention_sources (
  intervention_id, source_type, citation_text, source_url, publication_year, supports, limitations, license_notes, reviewed_at, reviewed_by
) select i.id, 'guideline', 'NICE CG113. Generalised anxiety disorder and panic disorder in adults: management. Recommendations.', 'https://www.nice.org.uk/guidance/cg113/chapter/Recommendations', 2020, 'Stepped care, CBT-based low-intensity self-help, routine outcome monitoring, problem-solving/cognitive principles, and stepping up with marked impairment or non-response.', 'Guideline is for diagnosed GAD/panic care; Malaak uses only transdiagnostic low-risk principles and does not diagnose or deliver high-intensity treatment.', 'Principles summarized; no treatment manual text copied.', now(), 'Malaak V5 evidence review'
from public.malaak_interventions i where i.code = 'HEAL_SELF_WORTH_004' and i.version = 1
on conflict (intervention_id, source_url, supports) do nothing;

insert into public.malaak_intervention_sources (
  intervention_id, source_type, citation_text, source_url, publication_year, supports, limitations, license_notes, reviewed_at, reviewed_by
) select i.id, 'meta_analysis', 'Rathgeber M, et al. The Efficacy of Emotionally Focused Couples Therapy and Behavioral Couples Therapy: A Meta-Analysis. J Marital Fam Ther. 2019;45(3):447-463.', 'https://pubmed.ncbi.nlm.nih.gov/29781200/', 2019, 'Evidence-based couple therapies can improve relationship satisfaction; interaction cycles, behavior change and emotional processes are legitimate intervention targets.', 'Malaak does not deliver full couple therapy and must not use couple communication tools in unsafe/violent relationships.', 'General couple-therapy principles summarized; no manual protocol copied.', now(), 'Malaak V5 evidence review'
from public.malaak_interventions i where i.code = 'HEAL_TRUST_GRADUAL_005' and i.version = 1
on conflict (intervention_id, source_url, supports) do nothing;

insert into public.malaak_intervention_sources (
  intervention_id, source_type, citation_text, source_url, publication_year, supports, limitations, license_notes, reviewed_at, reviewed_by
) select i.id, 'guideline', 'SAMHSA. Trauma-Informed Approaches and Programs.', 'https://www.samhsa.gov/mental-health/trauma-violence/trauma-informed-approaches-programs', 2026, 'Safety, trust/transparency, collaboration, empowerment, voice/choice and avoiding re-traumatization.', 'Trauma-informed principles are not a self-administered trauma-processing protocol.', 'Principles only; no protected clinical protocol copied.', now(), 'Malaak V5 evidence review'
from public.malaak_interventions i where i.code = 'HEAL_TRUST_GRADUAL_005' and i.version = 1
on conflict (intervention_id, source_url, supports) do nothing;

