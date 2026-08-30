-- Generated deterministically from supabase/functions/malaak-ai/catalog_seed.ts
-- V5 intervention sources part 5 of 8. Replaces source rows for this card chunk.

delete from public.malaak_intervention_sources where intervention_id in (select id from public.malaak_interventions where code in ('RUMINATION_EXIT_001','PROBLEM_SOLVE_001','WORRY_POSTPONE_002','DEFUSION_003','REASSURANCE_BREAK_004','ANGER_THERMOMETER_002'));

insert into public.malaak_intervention_sources (
  intervention_id, source_type, citation_text, source_url, publication_year, supports, limitations, license_notes, reviewed_at, reviewed_by
) select i.id, 'meta_analysis', 'Stenzel KL, et al. Efficacy of cognitive behavioral therapy in treating repetitive negative thinking, rumination, and worry - a transdiagnostic meta-analysis. Psychol Med. 2025. PMID 39916353.', 'https://pubmed.ncbi.nlm.nih.gov/39916353/', 2025, 'CBT interventions reduce repetitive negative thinking across diagnoses; process-specific approaches can be useful.', 'Does not support endless cognitive debate or reassurance; Malaak uses low-intensity process tools rather than disorder treatment.', 'Principles summarized in original wording.', now(), 'Malaak V5 evidence review'
from public.malaak_interventions i where i.code = 'RUMINATION_EXIT_001' and i.version = 1
on conflict (intervention_id, source_url, supports) do nothing;

insert into public.malaak_intervention_sources (
  intervention_id, source_type, citation_text, source_url, publication_year, supports, limitations, license_notes, reviewed_at, reviewed_by
) select i.id, 'guideline', 'NICE CG113. Generalised anxiety disorder and panic disorder in adults: management. Recommendations.', 'https://www.nice.org.uk/guidance/cg113/chapter/Recommendations', 2020, 'Stepped care, CBT-based low-intensity self-help, routine outcome monitoring, problem-solving/cognitive principles, and stepping up with marked impairment or non-response.', 'Guideline is for diagnosed GAD/panic care; Malaak uses only transdiagnostic low-risk principles and does not diagnose or deliver high-intensity treatment.', 'Principles summarized; no treatment manual text copied.', now(), 'Malaak V5 evidence review'
from public.malaak_interventions i where i.code = 'PROBLEM_SOLVE_001' and i.version = 1
on conflict (intervention_id, source_url, supports) do nothing;

insert into public.malaak_intervention_sources (
  intervention_id, source_type, citation_text, source_url, publication_year, supports, limitations, license_notes, reviewed_at, reviewed_by
) select i.id, 'meta_analysis', 'Stenzel KL, et al. Efficacy of cognitive behavioral therapy in treating repetitive negative thinking, rumination, and worry - a transdiagnostic meta-analysis. Psychol Med. 2025. PMID 39916353.', 'https://pubmed.ncbi.nlm.nih.gov/39916353/', 2025, 'CBT interventions reduce repetitive negative thinking across diagnoses; process-specific approaches can be useful.', 'Does not support endless cognitive debate or reassurance; Malaak uses low-intensity process tools rather than disorder treatment.', 'Principles summarized in original wording.', now(), 'Malaak V5 evidence review'
from public.malaak_interventions i where i.code = 'WORRY_POSTPONE_002' and i.version = 1
on conflict (intervention_id, source_url, supports) do nothing;

insert into public.malaak_intervention_sources (
  intervention_id, source_type, citation_text, source_url, publication_year, supports, limitations, license_notes, reviewed_at, reviewed_by
) select i.id, 'guideline', 'NICE CG113. Generalised anxiety disorder and panic disorder in adults: management. Recommendations.', 'https://www.nice.org.uk/guidance/cg113/chapter/Recommendations', 2020, 'Stepped care, CBT-based low-intensity self-help, routine outcome monitoring, problem-solving/cognitive principles, and stepping up with marked impairment or non-response.', 'Guideline is for diagnosed GAD/panic care; Malaak uses only transdiagnostic low-risk principles and does not diagnose or deliver high-intensity treatment.', 'Principles summarized; no treatment manual text copied.', now(), 'Malaak V5 evidence review'
from public.malaak_interventions i where i.code = 'WORRY_POSTPONE_002' and i.version = 1
on conflict (intervention_id, source_url, supports) do nothing;

insert into public.malaak_intervention_sources (
  intervention_id, source_type, citation_text, source_url, publication_year, supports, limitations, license_notes, reviewed_at, reviewed_by
) select i.id, 'meta_analysis', 'Macri JA, Rogge RD. Examining domains of psychological flexibility and inflexibility as treatment mechanisms in ACT: systematic and meta-analytic review. Clin Psychol Rev. 2024;110:102432.', 'https://pubmed.ncbi.nlm.nih.gov/38615492/', 2024, 'ACT-related changes in defusion, acceptance, present-moment awareness and committed action are associated with reduced distress.', 'Mechanism evidence does not validate Malaak or every ACT-derived micro-skill; crisis populations require additional care.', 'General ACT mechanisms summarized; no manual scripts copied.', now(), 'Malaak V5 evidence review'
from public.malaak_interventions i where i.code = 'DEFUSION_003' and i.version = 1
on conflict (intervention_id, source_url, supports) do nothing;

insert into public.malaak_intervention_sources (
  intervention_id, source_type, citation_text, source_url, publication_year, supports, limitations, license_notes, reviewed_at, reviewed_by
) select i.id, 'guideline', 'World Health Organization. Doing What Matters in Times of Stress: An Illustrated Guide. 2020.', 'https://www.who.int/publications-detail-redirect/9789240003927', 2020, 'Low-intensity principles such as grounding, unhooking from difficult thoughts, making room for emotions, values-guided action and self-kindness.', 'Supports underlying principles, not Malaak-specific scripts or effectiveness claims for this app.', 'Do not copy protected scripts/illustrations; Malaak wording is original.', now(), 'Malaak V5 evidence review'
from public.malaak_interventions i where i.code = 'DEFUSION_003' and i.version = 1
on conflict (intervention_id, source_url, supports) do nothing;

insert into public.malaak_intervention_sources (
  intervention_id, source_type, citation_text, source_url, publication_year, supports, limitations, license_notes, reviewed_at, reviewed_by
) select i.id, 'meta_analysis', 'Stenzel KL, et al. Efficacy of cognitive behavioral therapy in treating repetitive negative thinking, rumination, and worry - a transdiagnostic meta-analysis. Psychol Med. 2025. PMID 39916353.', 'https://pubmed.ncbi.nlm.nih.gov/39916353/', 2025, 'CBT interventions reduce repetitive negative thinking across diagnoses; process-specific approaches can be useful.', 'Does not support endless cognitive debate or reassurance; Malaak uses low-intensity process tools rather than disorder treatment.', 'Principles summarized in original wording.', now(), 'Malaak V5 evidence review'
from public.malaak_interventions i where i.code = 'REASSURANCE_BREAK_004' and i.version = 1
on conflict (intervention_id, source_url, supports) do nothing;

insert into public.malaak_intervention_sources (
  intervention_id, source_type, citation_text, source_url, publication_year, supports, limitations, license_notes, reviewed_at, reviewed_by
) select i.id, 'meta_analysis', 'Wilson EJ, Abbott MJ, Norton AR. The impact of psychological treatment on intolerance of uncertainty in generalized anxiety disorder: A systematic review and meta-analysis. J Anxiety Disord. 2023;97:102729.', 'https://pubmed.ncbi.nlm.nih.gov/37271039/', 2023, 'Psychological treatments can reduce intolerance of uncertainty and worry; directly targeting uncertainty may be useful.', 'Evidence concerns GAD treatments; Malaak does not reproduce a full treatment protocol or diagnose GAD.', 'General treatment principle only.', now(), 'Malaak V5 evidence review'
from public.malaak_interventions i where i.code = 'REASSURANCE_BREAK_004' and i.version = 1
on conflict (intervention_id, source_url, supports) do nothing;

insert into public.malaak_intervention_sources (
  intervention_id, source_type, citation_text, source_url, publication_year, supports, limitations, license_notes, reviewed_at, reviewed_by
) select i.id, 'meta_analysis', 'DiGiuseppe R, Tafrate RC. Effectiveness of anger treatments for specific anger problems: a meta-analytic review. Clin Psychol Rev. 2003/2004. PMID 14992805.', 'https://pubmed.ncbi.nlm.nih.gov/14992805/', 2004, 'Cognitive and behavioral anger treatments show meaningful effects across anger presentations; appraisal and response skills are relevant targets.', 'Older heterogeneous literature; safety risk overrides self-help anger coaching.', 'General anger-management principles summarized.', now(), 'Malaak V5 evidence review'
from public.malaak_interventions i where i.code = 'ANGER_THERMOMETER_002' and i.version = 1
on conflict (intervention_id, source_url, supports) do nothing;

insert into public.malaak_intervention_sources (
  intervention_id, source_type, citation_text, source_url, publication_year, supports, limitations, license_notes, reviewed_at, reviewed_by
) select i.id, 'systematic_review', 'McRae K, Gross JJ. Emotion regulation. Emotion. 2020;20(1):1-9. PMID 31961170.', 'https://pubmed.ncbi.nlm.nih.gov/31961170/', 2020, 'Process-based emotion regulation: identify need, select/implement a strategy, then monitor success; cognitive reappraisal is a well-studied strategy.', 'Conceptual review; does not validate a particular app exercise or imply one strategy is universally best.', 'Conceptual principles summarized.', now(), 'Malaak V5 evidence review'
from public.malaak_interventions i where i.code = 'ANGER_THERMOMETER_002' and i.version = 1
on conflict (intervention_id, source_url, supports) do nothing;

