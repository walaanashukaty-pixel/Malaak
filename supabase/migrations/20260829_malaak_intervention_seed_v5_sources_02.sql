-- Generated deterministically from supabase/functions/malaak-ai/catalog_seed.ts
-- V5 intervention sources part 2 of 8. Replaces source rows for this card chunk.

delete from public.malaak_intervention_sources where intervention_id in (select id from public.malaak_interventions where code in ('CONTROL_CIRCLE_001','REST_RECOVERY_001','NEED_NAME_001','NEED_STRATEGY_002','REQUEST_DIRECT_001','BOUNDARY_001'));

insert into public.malaak_intervention_sources (
  intervention_id, source_type, citation_text, source_url, publication_year, supports, limitations, license_notes, reviewed_at, reviewed_by
) select i.id, 'meta_analysis', 'Macri JA, Rogge RD. Examining domains of psychological flexibility and inflexibility as treatment mechanisms in ACT: systematic and meta-analytic review. Clin Psychol Rev. 2024;110:102432.', 'https://pubmed.ncbi.nlm.nih.gov/38615492/', 2024, 'ACT-related changes in defusion, acceptance, present-moment awareness and committed action are associated with reduced distress.', 'Mechanism evidence does not validate Malaak or every ACT-derived micro-skill; crisis populations require additional care.', 'General ACT mechanisms summarized; no manual scripts copied.', now(), 'Malaak V5 evidence review'
from public.malaak_interventions i where i.code = 'CONTROL_CIRCLE_001' and i.version = 1
on conflict (intervention_id, source_url, supports) do nothing;

insert into public.malaak_intervention_sources (
  intervention_id, source_type, citation_text, source_url, publication_year, supports, limitations, license_notes, reviewed_at, reviewed_by
) select i.id, 'guideline', 'NICE CG113. Generalised anxiety disorder and panic disorder in adults: management. Recommendations.', 'https://www.nice.org.uk/guidance/cg113/chapter/Recommendations', 2020, 'Stepped care, CBT-based low-intensity self-help, routine outcome monitoring, problem-solving/cognitive principles, and stepping up with marked impairment or non-response.', 'Guideline is for diagnosed GAD/panic care; Malaak uses only transdiagnostic low-risk principles and does not diagnose or deliver high-intensity treatment.', 'Principles summarized; no treatment manual text copied.', now(), 'Malaak V5 evidence review'
from public.malaak_interventions i where i.code = 'CONTROL_CIRCLE_001' and i.version = 1
on conflict (intervention_id, source_url, supports) do nothing;

insert into public.malaak_intervention_sources (
  intervention_id, source_type, citation_text, source_url, publication_year, supports, limitations, license_notes, reviewed_at, reviewed_by
) select i.id, 'guideline', 'World Health Organization. Psychological self-help interventions: delivering self-help for individuals, featuring Step-by-Step and Doing What Matters in Times of Stress. 2026.', 'https://www.who.int/publications/i/item/9789240120785', 2026, 'Structured low-intensity psychological self-help and guided/unguided delivery with appropriate scope boundaries.', 'Does not validate Malaak wording or authorize copying manual scripts; not a substitute for specialist treatment when impairment/risk is high.', 'WHO 2026 manual uses non-commercial terms by default; Malaak uses original wording and requires separate commercial permission before copying protected material.', now(), 'Malaak V5 evidence review'
from public.malaak_interventions i where i.code = 'REST_RECOVERY_001' and i.version = 1
on conflict (intervention_id, source_url, supports) do nothing;

insert into public.malaak_intervention_sources (
  intervention_id, source_type, citation_text, source_url, publication_year, supports, limitations, license_notes, reviewed_at, reviewed_by
) select i.id, 'guideline', 'World Health Organization. Psychological self-help interventions: delivering self-help for individuals, featuring Step-by-Step and Doing What Matters in Times of Stress. 2026.', 'https://www.who.int/publications/i/item/9789240120785', 2026, 'Structured low-intensity psychological self-help and guided/unguided delivery with appropriate scope boundaries.', 'Does not validate Malaak wording or authorize copying manual scripts; not a substitute for specialist treatment when impairment/risk is high.', 'WHO 2026 manual uses non-commercial terms by default; Malaak uses original wording and requires separate commercial permission before copying protected material.', now(), 'Malaak V5 evidence review'
from public.malaak_interventions i where i.code = 'NEED_NAME_001' and i.version = 1
on conflict (intervention_id, source_url, supports) do nothing;

insert into public.malaak_intervention_sources (
  intervention_id, source_type, citation_text, source_url, publication_year, supports, limitations, license_notes, reviewed_at, reviewed_by
) select i.id, 'guideline', 'World Health Organization. Psychological self-help interventions: delivering self-help for individuals, featuring Step-by-Step and Doing What Matters in Times of Stress. 2026.', 'https://www.who.int/publications/i/item/9789240120785', 2026, 'Structured low-intensity psychological self-help and guided/unguided delivery with appropriate scope boundaries.', 'Does not validate Malaak wording or authorize copying manual scripts; not a substitute for specialist treatment when impairment/risk is high.', 'WHO 2026 manual uses non-commercial terms by default; Malaak uses original wording and requires separate commercial permission before copying protected material.', now(), 'Malaak V5 evidence review'
from public.malaak_interventions i where i.code = 'NEED_STRATEGY_002' and i.version = 1
on conflict (intervention_id, source_url, supports) do nothing;

insert into public.malaak_intervention_sources (
  intervention_id, source_type, citation_text, source_url, publication_year, supports, limitations, license_notes, reviewed_at, reviewed_by
) select i.id, 'meta_analysis', 'Macri JA, Rogge RD. Examining domains of psychological flexibility and inflexibility as treatment mechanisms in ACT: systematic and meta-analytic review. Clin Psychol Rev. 2024;110:102432.', 'https://pubmed.ncbi.nlm.nih.gov/38615492/', 2024, 'ACT-related changes in defusion, acceptance, present-moment awareness and committed action are associated with reduced distress.', 'Mechanism evidence does not validate Malaak or every ACT-derived micro-skill; crisis populations require additional care.', 'General ACT mechanisms summarized; no manual scripts copied.', now(), 'Malaak V5 evidence review'
from public.malaak_interventions i where i.code = 'NEED_STRATEGY_002' and i.version = 1
on conflict (intervention_id, source_url, supports) do nothing;

insert into public.malaak_intervention_sources (
  intervention_id, source_type, citation_text, source_url, publication_year, supports, limitations, license_notes, reviewed_at, reviewed_by
) select i.id, 'meta_analysis', 'Hede JP, Malouff JM, Meynadier J. A Meta-Analysis of Randomised Controlled Trials on the Efficacy of Assertiveness Training for Social Anxiety. 2026.', 'https://link.springer.com/article/10.1007/s41042-026-00297-7', 2026, 'Assertiveness training can improve assertive behavior in studied populations and supports practicing direct, respectful communication.', 'Population/effects are not equivalent to all relationship contexts; does not justify confrontation where danger is possible.', 'Underlying assertiveness principles summarized in original wording.', now(), 'Malaak V5 evidence review'
from public.malaak_interventions i where i.code = 'REQUEST_DIRECT_001' and i.version = 1
on conflict (intervention_id, source_url, supports) do nothing;

insert into public.malaak_intervention_sources (
  intervention_id, source_type, citation_text, source_url, publication_year, supports, limitations, license_notes, reviewed_at, reviewed_by
) select i.id, 'meta_analysis', 'Rathgeber M, et al. The Efficacy of Emotionally Focused Couples Therapy and Behavioral Couples Therapy: A Meta-Analysis. J Marital Fam Ther. 2019;45(3):447-463.', 'https://pubmed.ncbi.nlm.nih.gov/29781200/', 2019, 'Evidence-based couple therapies can improve relationship satisfaction; interaction cycles, behavior change and emotional processes are legitimate intervention targets.', 'Malaak does not deliver full couple therapy and must not use couple communication tools in unsafe/violent relationships.', 'General couple-therapy principles summarized; no manual protocol copied.', now(), 'Malaak V5 evidence review'
from public.malaak_interventions i where i.code = 'REQUEST_DIRECT_001' and i.version = 1
on conflict (intervention_id, source_url, supports) do nothing;

insert into public.malaak_intervention_sources (
  intervention_id, source_type, citation_text, source_url, publication_year, supports, limitations, license_notes, reviewed_at, reviewed_by
) select i.id, 'meta_analysis', 'Hede JP, Malouff JM, Meynadier J. A Meta-Analysis of Randomised Controlled Trials on the Efficacy of Assertiveness Training for Social Anxiety. 2026.', 'https://link.springer.com/article/10.1007/s41042-026-00297-7', 2026, 'Assertiveness training can improve assertive behavior in studied populations and supports practicing direct, respectful communication.', 'Population/effects are not equivalent to all relationship contexts; does not justify confrontation where danger is possible.', 'Underlying assertiveness principles summarized in original wording.', now(), 'Malaak V5 evidence review'
from public.malaak_interventions i where i.code = 'BOUNDARY_001' and i.version = 1
on conflict (intervention_id, source_url, supports) do nothing;

