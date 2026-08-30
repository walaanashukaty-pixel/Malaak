-- Generated deterministically from supabase/functions/malaak-ai/catalog_seed.ts
-- V5 intervention sources part 3 of 8. Replaces source rows for this card chunk.

delete from public.malaak_intervention_sources where intervention_id in (select id from public.malaak_interventions where code in ('NO_TOLERATE_002','UNCERTAINTY_001','ATT_TRIGGER_001','ATT_REALITY_002','ATT_REASSURE_DELAY_003','ATT_REPAIR_004'));

insert into public.malaak_intervention_sources (
  intervention_id, source_type, citation_text, source_url, publication_year, supports, limitations, license_notes, reviewed_at, reviewed_by
) select i.id, 'meta_analysis', 'Hede JP, Malouff JM, Meynadier J. A Meta-Analysis of Randomised Controlled Trials on the Efficacy of Assertiveness Training for Social Anxiety. 2026.', 'https://link.springer.com/article/10.1007/s41042-026-00297-7', 2026, 'Assertiveness training can improve assertive behavior in studied populations and supports practicing direct, respectful communication.', 'Population/effects are not equivalent to all relationship contexts; does not justify confrontation where danger is possible.', 'Underlying assertiveness principles summarized in original wording.', now(), 'Malaak V5 evidence review'
from public.malaak_interventions i where i.code = 'NO_TOLERATE_002' and i.version = 1
on conflict (intervention_id, source_url, supports) do nothing;

insert into public.malaak_intervention_sources (
  intervention_id, source_type, citation_text, source_url, publication_year, supports, limitations, license_notes, reviewed_at, reviewed_by
) select i.id, 'meta_analysis', 'Macri JA, Rogge RD. Examining domains of psychological flexibility and inflexibility as treatment mechanisms in ACT: systematic and meta-analytic review. Clin Psychol Rev. 2024;110:102432.', 'https://pubmed.ncbi.nlm.nih.gov/38615492/', 2024, 'ACT-related changes in defusion, acceptance, present-moment awareness and committed action are associated with reduced distress.', 'Mechanism evidence does not validate Malaak or every ACT-derived micro-skill; crisis populations require additional care.', 'General ACT mechanisms summarized; no manual scripts copied.', now(), 'Malaak V5 evidence review'
from public.malaak_interventions i where i.code = 'NO_TOLERATE_002' and i.version = 1
on conflict (intervention_id, source_url, supports) do nothing;

insert into public.malaak_intervention_sources (
  intervention_id, source_type, citation_text, source_url, publication_year, supports, limitations, license_notes, reviewed_at, reviewed_by
) select i.id, 'meta_analysis', 'Wilson EJ, Abbott MJ, Norton AR. The impact of psychological treatment on intolerance of uncertainty in generalized anxiety disorder: A systematic review and meta-analysis. J Anxiety Disord. 2023;97:102729.', 'https://pubmed.ncbi.nlm.nih.gov/37271039/', 2023, 'Psychological treatments can reduce intolerance of uncertainty and worry; directly targeting uncertainty may be useful.', 'Evidence concerns GAD treatments; Malaak does not reproduce a full treatment protocol or diagnose GAD.', 'General treatment principle only.', now(), 'Malaak V5 evidence review'
from public.malaak_interventions i where i.code = 'UNCERTAINTY_001' and i.version = 1
on conflict (intervention_id, source_url, supports) do nothing;

insert into public.malaak_intervention_sources (
  intervention_id, source_type, citation_text, source_url, publication_year, supports, limitations, license_notes, reviewed_at, reviewed_by
) select i.id, 'meta_analysis', 'Näsling J, et al. Effect of Psychotherapy on Intolerance of Uncertainty: A Systematic Review and Meta-Analysis. 2024. PMID 39036833.', 'https://pubmed.ncbi.nlm.nih.gov/39036833/', 2024, 'Psychotherapy can change intolerance of uncertainty, while active-control results and heterogeneity counsel modest claims.', 'Substantial heterogeneity; active-control effects were not consistently significant.', 'General principle only.', now(), 'Malaak V5 evidence review'
from public.malaak_interventions i where i.code = 'UNCERTAINTY_001' and i.version = 1
on conflict (intervention_id, source_url, supports) do nothing;

insert into public.malaak_intervention_sources (
  intervention_id, source_type, citation_text, source_url, publication_year, supports, limitations, license_notes, reviewed_at, reviewed_by
) select i.id, 'meta_analysis', 'Gillath O, Karantzas GC, Romano D, Karantzas KM. Attachment Security Priming: A Meta-Analysis. Pers Soc Psychol Rev. 2022;26(3):183-241.', 'https://pubmed.ncbi.nlm.nih.gov/35209765/', 2022, 'Attachment-security priming has measurable affective, cognitive and behavioral effects and attachment processes can be context-sensitive.', 'Priming evidence does not make attachment categories diagnoses or justify fixed identity labels; Malaak does not use subliminal priming.', 'Attachment concepts summarized; no proprietary assessment copied.', now(), 'Malaak V5 evidence review'
from public.malaak_interventions i where i.code = 'ATT_TRIGGER_001' and i.version = 1
on conflict (intervention_id, source_url, supports) do nothing;

insert into public.malaak_intervention_sources (
  intervention_id, source_type, citation_text, source_url, publication_year, supports, limitations, license_notes, reviewed_at, reviewed_by
) select i.id, 'meta_analysis', 'Gillath O, Karantzas GC, Romano D, Karantzas KM. Attachment Security Priming: A Meta-Analysis. Pers Soc Psychol Rev. 2022;26(3):183-241.', 'https://pubmed.ncbi.nlm.nih.gov/35209765/', 2022, 'Attachment-security priming has measurable affective, cognitive and behavioral effects and attachment processes can be context-sensitive.', 'Priming evidence does not make attachment categories diagnoses or justify fixed identity labels; Malaak does not use subliminal priming.', 'Attachment concepts summarized; no proprietary assessment copied.', now(), 'Malaak V5 evidence review'
from public.malaak_interventions i where i.code = 'ATT_REALITY_002' and i.version = 1
on conflict (intervention_id, source_url, supports) do nothing;

insert into public.malaak_intervention_sources (
  intervention_id, source_type, citation_text, source_url, publication_year, supports, limitations, license_notes, reviewed_at, reviewed_by
) select i.id, 'guideline', 'SAMHSA. Trauma-Informed Approaches and Programs.', 'https://www.samhsa.gov/mental-health/trauma-violence/trauma-informed-approaches-programs', 2026, 'Safety, trust/transparency, collaboration, empowerment, voice/choice and avoiding re-traumatization.', 'Trauma-informed principles are not a self-administered trauma-processing protocol.', 'Principles only; no protected clinical protocol copied.', now(), 'Malaak V5 evidence review'
from public.malaak_interventions i where i.code = 'ATT_REALITY_002' and i.version = 1
on conflict (intervention_id, source_url, supports) do nothing;

insert into public.malaak_intervention_sources (
  intervention_id, source_type, citation_text, source_url, publication_year, supports, limitations, license_notes, reviewed_at, reviewed_by
) select i.id, 'meta_analysis', 'Wilson EJ, Abbott MJ, Norton AR. The impact of psychological treatment on intolerance of uncertainty in generalized anxiety disorder: A systematic review and meta-analysis. J Anxiety Disord. 2023;97:102729.', 'https://pubmed.ncbi.nlm.nih.gov/37271039/', 2023, 'Psychological treatments can reduce intolerance of uncertainty and worry; directly targeting uncertainty may be useful.', 'Evidence concerns GAD treatments; Malaak does not reproduce a full treatment protocol or diagnose GAD.', 'General treatment principle only.', now(), 'Malaak V5 evidence review'
from public.malaak_interventions i where i.code = 'ATT_REASSURE_DELAY_003' and i.version = 1
on conflict (intervention_id, source_url, supports) do nothing;

insert into public.malaak_intervention_sources (
  intervention_id, source_type, citation_text, source_url, publication_year, supports, limitations, license_notes, reviewed_at, reviewed_by
) select i.id, 'meta_analysis', 'Stenzel KL, et al. Efficacy of cognitive behavioral therapy in treating repetitive negative thinking, rumination, and worry - a transdiagnostic meta-analysis. Psychol Med. 2025. PMID 39916353.', 'https://pubmed.ncbi.nlm.nih.gov/39916353/', 2025, 'CBT interventions reduce repetitive negative thinking across diagnoses; process-specific approaches can be useful.', 'Does not support endless cognitive debate or reassurance; Malaak uses low-intensity process tools rather than disorder treatment.', 'Principles summarized in original wording.', now(), 'Malaak V5 evidence review'
from public.malaak_interventions i where i.code = 'ATT_REASSURE_DELAY_003' and i.version = 1
on conflict (intervention_id, source_url, supports) do nothing;

insert into public.malaak_intervention_sources (
  intervention_id, source_type, citation_text, source_url, publication_year, supports, limitations, license_notes, reviewed_at, reviewed_by
) select i.id, 'meta_analysis', 'Rathgeber M, et al. The Efficacy of Emotionally Focused Couples Therapy and Behavioral Couples Therapy: A Meta-Analysis. J Marital Fam Ther. 2019;45(3):447-463.', 'https://pubmed.ncbi.nlm.nih.gov/29781200/', 2019, 'Evidence-based couple therapies can improve relationship satisfaction; interaction cycles, behavior change and emotional processes are legitimate intervention targets.', 'Malaak does not deliver full couple therapy and must not use couple communication tools in unsafe/violent relationships.', 'General couple-therapy principles summarized; no manual protocol copied.', now(), 'Malaak V5 evidence review'
from public.malaak_interventions i where i.code = 'ATT_REPAIR_004' and i.version = 1
on conflict (intervention_id, source_url, supports) do nothing;

insert into public.malaak_intervention_sources (
  intervention_id, source_type, citation_text, source_url, publication_year, supports, limitations, license_notes, reviewed_at, reviewed_by
) select i.id, 'meta_analysis', 'Gillath O, Karantzas GC, Romano D, Karantzas KM. Attachment Security Priming: A Meta-Analysis. Pers Soc Psychol Rev. 2022;26(3):183-241.', 'https://pubmed.ncbi.nlm.nih.gov/35209765/', 2022, 'Attachment-security priming has measurable affective, cognitive and behavioral effects and attachment processes can be context-sensitive.', 'Priming evidence does not make attachment categories diagnoses or justify fixed identity labels; Malaak does not use subliminal priming.', 'Attachment concepts summarized; no proprietary assessment copied.', now(), 'Malaak V5 evidence review'
from public.malaak_interventions i where i.code = 'ATT_REPAIR_004' and i.version = 1
on conflict (intervention_id, source_url, supports) do nothing;

