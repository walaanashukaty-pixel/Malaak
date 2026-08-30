-- Generated deterministically from supabase/functions/malaak-ai/catalog_seed.ts
-- V5 intervention sources part 4 of 8. Replaces source rows for this card chunk.

delete from public.malaak_intervention_sources where intervention_id in (select id from public.malaak_interventions where code in ('REL_CYCLE_001','ANGER_TIMEOUT_001','REL_SOFT_START_002','REL_REPAIR_003','REL_TRUST_STEP_004','THOUGHT_FACTS_001'));

insert into public.malaak_intervention_sources (
  intervention_id, source_type, citation_text, source_url, publication_year, supports, limitations, license_notes, reviewed_at, reviewed_by
) select i.id, 'meta_analysis', 'Rathgeber M, et al. The Efficacy of Emotionally Focused Couples Therapy and Behavioral Couples Therapy: A Meta-Analysis. J Marital Fam Ther. 2019;45(3):447-463.', 'https://pubmed.ncbi.nlm.nih.gov/29781200/', 2019, 'Evidence-based couple therapies can improve relationship satisfaction; interaction cycles, behavior change and emotional processes are legitimate intervention targets.', 'Malaak does not deliver full couple therapy and must not use couple communication tools in unsafe/violent relationships.', 'General couple-therapy principles summarized; no manual protocol copied.', now(), 'Malaak V5 evidence review'
from public.malaak_interventions i where i.code = 'REL_CYCLE_001' and i.version = 1
on conflict (intervention_id, source_url, supports) do nothing;

insert into public.malaak_intervention_sources (
  intervention_id, source_type, citation_text, source_url, publication_year, supports, limitations, license_notes, reviewed_at, reviewed_by
) select i.id, 'systematic_review', 'Roddy MK, Nowlan KM, Doss BD, Christensen A. Integrative Behavioral Couple Therapy: Theoretical Background, Empirical Research, and Dissemination. Fam Process. 2016;55(3):408-422.', 'https://pubmed.ncbi.nlm.nih.gov/27226235/', 2016, 'Combining behavior change with acceptance/contextual understanding is evidence-informed in couple work.', 'Not a license to reproduce IBCT protocols or to treat unsafe relationships as ordinary couple discord.', 'General principles summarized.', now(), 'Malaak V5 evidence review'
from public.malaak_interventions i where i.code = 'REL_CYCLE_001' and i.version = 1
on conflict (intervention_id, source_url, supports) do nothing;

insert into public.malaak_intervention_sources (
  intervention_id, source_type, citation_text, source_url, publication_year, supports, limitations, license_notes, reviewed_at, reviewed_by
) select i.id, 'meta_analysis', 'DiGiuseppe R, Tafrate RC. Effectiveness of anger treatments for specific anger problems: a meta-analytic review. Clin Psychol Rev. 2003/2004. PMID 14992805.', 'https://pubmed.ncbi.nlm.nih.gov/14992805/', 2004, 'Cognitive and behavioral anger treatments show meaningful effects across anger presentations; appraisal and response skills are relevant targets.', 'Older heterogeneous literature; safety risk overrides self-help anger coaching.', 'General anger-management principles summarized.', now(), 'Malaak V5 evidence review'
from public.malaak_interventions i where i.code = 'ANGER_TIMEOUT_001' and i.version = 1
on conflict (intervention_id, source_url, supports) do nothing;

insert into public.malaak_intervention_sources (
  intervention_id, source_type, citation_text, source_url, publication_year, supports, limitations, license_notes, reviewed_at, reviewed_by
) select i.id, 'meta_analysis', 'Rathgeber M, et al. The Efficacy of Emotionally Focused Couples Therapy and Behavioral Couples Therapy: A Meta-Analysis. J Marital Fam Ther. 2019;45(3):447-463.', 'https://pubmed.ncbi.nlm.nih.gov/29781200/', 2019, 'Evidence-based couple therapies can improve relationship satisfaction; interaction cycles, behavior change and emotional processes are legitimate intervention targets.', 'Malaak does not deliver full couple therapy and must not use couple communication tools in unsafe/violent relationships.', 'General couple-therapy principles summarized; no manual protocol copied.', now(), 'Malaak V5 evidence review'
from public.malaak_interventions i where i.code = 'ANGER_TIMEOUT_001' and i.version = 1
on conflict (intervention_id, source_url, supports) do nothing;

insert into public.malaak_intervention_sources (
  intervention_id, source_type, citation_text, source_url, publication_year, supports, limitations, license_notes, reviewed_at, reviewed_by
) select i.id, 'meta_analysis', 'Rathgeber M, et al. The Efficacy of Emotionally Focused Couples Therapy and Behavioral Couples Therapy: A Meta-Analysis. J Marital Fam Ther. 2019;45(3):447-463.', 'https://pubmed.ncbi.nlm.nih.gov/29781200/', 2019, 'Evidence-based couple therapies can improve relationship satisfaction; interaction cycles, behavior change and emotional processes are legitimate intervention targets.', 'Malaak does not deliver full couple therapy and must not use couple communication tools in unsafe/violent relationships.', 'General couple-therapy principles summarized; no manual protocol copied.', now(), 'Malaak V5 evidence review'
from public.malaak_interventions i where i.code = 'REL_SOFT_START_002' and i.version = 1
on conflict (intervention_id, source_url, supports) do nothing;

insert into public.malaak_intervention_sources (
  intervention_id, source_type, citation_text, source_url, publication_year, supports, limitations, license_notes, reviewed_at, reviewed_by
) select i.id, 'meta_analysis', 'Hede JP, Malouff JM, Meynadier J. A Meta-Analysis of Randomised Controlled Trials on the Efficacy of Assertiveness Training for Social Anxiety. 2026.', 'https://link.springer.com/article/10.1007/s41042-026-00297-7', 2026, 'Assertiveness training can improve assertive behavior in studied populations and supports practicing direct, respectful communication.', 'Population/effects are not equivalent to all relationship contexts; does not justify confrontation where danger is possible.', 'Underlying assertiveness principles summarized in original wording.', now(), 'Malaak V5 evidence review'
from public.malaak_interventions i where i.code = 'REL_SOFT_START_002' and i.version = 1
on conflict (intervention_id, source_url, supports) do nothing;

insert into public.malaak_intervention_sources (
  intervention_id, source_type, citation_text, source_url, publication_year, supports, limitations, license_notes, reviewed_at, reviewed_by
) select i.id, 'meta_analysis', 'Rathgeber M, et al. The Efficacy of Emotionally Focused Couples Therapy and Behavioral Couples Therapy: A Meta-Analysis. J Marital Fam Ther. 2019;45(3):447-463.', 'https://pubmed.ncbi.nlm.nih.gov/29781200/', 2019, 'Evidence-based couple therapies can improve relationship satisfaction; interaction cycles, behavior change and emotional processes are legitimate intervention targets.', 'Malaak does not deliver full couple therapy and must not use couple communication tools in unsafe/violent relationships.', 'General couple-therapy principles summarized; no manual protocol copied.', now(), 'Malaak V5 evidence review'
from public.malaak_interventions i where i.code = 'REL_REPAIR_003' and i.version = 1
on conflict (intervention_id, source_url, supports) do nothing;

insert into public.malaak_intervention_sources (
  intervention_id, source_type, citation_text, source_url, publication_year, supports, limitations, license_notes, reviewed_at, reviewed_by
) select i.id, 'systematic_review', 'Roddy MK, Nowlan KM, Doss BD, Christensen A. Integrative Behavioral Couple Therapy: Theoretical Background, Empirical Research, and Dissemination. Fam Process. 2016;55(3):408-422.', 'https://pubmed.ncbi.nlm.nih.gov/27226235/', 2016, 'Combining behavior change with acceptance/contextual understanding is evidence-informed in couple work.', 'Not a license to reproduce IBCT protocols or to treat unsafe relationships as ordinary couple discord.', 'General principles summarized.', now(), 'Malaak V5 evidence review'
from public.malaak_interventions i where i.code = 'REL_REPAIR_003' and i.version = 1
on conflict (intervention_id, source_url, supports) do nothing;

insert into public.malaak_intervention_sources (
  intervention_id, source_type, citation_text, source_url, publication_year, supports, limitations, license_notes, reviewed_at, reviewed_by
) select i.id, 'meta_analysis', 'Rathgeber M, et al. The Efficacy of Emotionally Focused Couples Therapy and Behavioral Couples Therapy: A Meta-Analysis. J Marital Fam Ther. 2019;45(3):447-463.', 'https://pubmed.ncbi.nlm.nih.gov/29781200/', 2019, 'Evidence-based couple therapies can improve relationship satisfaction; interaction cycles, behavior change and emotional processes are legitimate intervention targets.', 'Malaak does not deliver full couple therapy and must not use couple communication tools in unsafe/violent relationships.', 'General couple-therapy principles summarized; no manual protocol copied.', now(), 'Malaak V5 evidence review'
from public.malaak_interventions i where i.code = 'REL_TRUST_STEP_004' and i.version = 1
on conflict (intervention_id, source_url, supports) do nothing;

insert into public.malaak_intervention_sources (
  intervention_id, source_type, citation_text, source_url, publication_year, supports, limitations, license_notes, reviewed_at, reviewed_by
) select i.id, 'systematic_review', 'Roddy MK, Nowlan KM, Doss BD, Christensen A. Integrative Behavioral Couple Therapy: Theoretical Background, Empirical Research, and Dissemination. Fam Process. 2016;55(3):408-422.', 'https://pubmed.ncbi.nlm.nih.gov/27226235/', 2016, 'Combining behavior change with acceptance/contextual understanding is evidence-informed in couple work.', 'Not a license to reproduce IBCT protocols or to treat unsafe relationships as ordinary couple discord.', 'General principles summarized.', now(), 'Malaak V5 evidence review'
from public.malaak_interventions i where i.code = 'REL_TRUST_STEP_004' and i.version = 1
on conflict (intervention_id, source_url, supports) do nothing;

insert into public.malaak_intervention_sources (
  intervention_id, source_type, citation_text, source_url, publication_year, supports, limitations, license_notes, reviewed_at, reviewed_by
) select i.id, 'guideline', 'NICE CG113. Generalised anxiety disorder and panic disorder in adults: management. Recommendations.', 'https://www.nice.org.uk/guidance/cg113/chapter/Recommendations', 2020, 'Stepped care, CBT-based low-intensity self-help, routine outcome monitoring, problem-solving/cognitive principles, and stepping up with marked impairment or non-response.', 'Guideline is for diagnosed GAD/panic care; Malaak uses only transdiagnostic low-risk principles and does not diagnose or deliver high-intensity treatment.', 'Principles summarized; no treatment manual text copied.', now(), 'Malaak V5 evidence review'
from public.malaak_interventions i where i.code = 'THOUGHT_FACTS_001' and i.version = 1
on conflict (intervention_id, source_url, supports) do nothing;

insert into public.malaak_intervention_sources (
  intervention_id, source_type, citation_text, source_url, publication_year, supports, limitations, license_notes, reviewed_at, reviewed_by
) select i.id, 'meta_analysis', 'Stenzel KL, et al. Efficacy of cognitive behavioral therapy in treating repetitive negative thinking, rumination, and worry - a transdiagnostic meta-analysis. Psychol Med. 2025. PMID 39916353.', 'https://pubmed.ncbi.nlm.nih.gov/39916353/', 2025, 'CBT interventions reduce repetitive negative thinking across diagnoses; process-specific approaches can be useful.', 'Does not support endless cognitive debate or reassurance; Malaak uses low-intensity process tools rather than disorder treatment.', 'Principles summarized in original wording.', now(), 'Malaak V5 evidence review'
from public.malaak_interventions i where i.code = 'THOUGHT_FACTS_001' and i.version = 1
on conflict (intervention_id, source_url, supports) do nothing;

