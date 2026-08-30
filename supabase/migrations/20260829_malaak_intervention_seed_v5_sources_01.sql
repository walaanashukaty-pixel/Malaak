-- Generated deterministically from supabase/functions/malaak-ai/catalog_seed.ts
-- V5 intervention sources part 1 of 8. Replaces source rows for this card chunk.

delete from public.malaak_intervention_sources where intervention_id in (select id from public.malaak_interventions where code in ('REG_GROUND_001','REG_MOVE_002','REG_BREATHE_003','EMO_NAME_001','EMO_CHAIN_002','LOAD_SORT_001'));

insert into public.malaak_intervention_sources (
  intervention_id, source_type, citation_text, source_url, publication_year, supports, limitations, license_notes, reviewed_at, reviewed_by
) select i.id, 'guideline', 'World Health Organization. Doing What Matters in Times of Stress: An Illustrated Guide. 2020.', 'https://www.who.int/publications-detail-redirect/9789240003927', 2020, 'Low-intensity principles such as grounding, unhooking from difficult thoughts, making room for emotions, values-guided action and self-kindness.', 'Supports underlying principles, not Malaak-specific scripts or effectiveness claims for this app.', 'Do not copy protected scripts/illustrations; Malaak wording is original.', now(), 'Malaak V5 evidence review'
from public.malaak_interventions i where i.code = 'REG_GROUND_001' and i.version = 1
on conflict (intervention_id, source_url, supports) do nothing;

insert into public.malaak_intervention_sources (
  intervention_id, source_type, citation_text, source_url, publication_year, supports, limitations, license_notes, reviewed_at, reviewed_by
) select i.id, 'systematic_review', 'McRae K, Gross JJ. Emotion regulation. Emotion. 2020;20(1):1-9. PMID 31961170.', 'https://pubmed.ncbi.nlm.nih.gov/31961170/', 2020, 'Process-based emotion regulation: identify need, select/implement a strategy, then monitor success; cognitive reappraisal is a well-studied strategy.', 'Conceptual review; does not validate a particular app exercise or imply one strategy is universally best.', 'Conceptual principles summarized.', now(), 'Malaak V5 evidence review'
from public.malaak_interventions i where i.code = 'REG_GROUND_001' and i.version = 1
on conflict (intervention_id, source_url, supports) do nothing;

insert into public.malaak_intervention_sources (
  intervention_id, source_type, citation_text, source_url, publication_year, supports, limitations, license_notes, reviewed_at, reviewed_by
) select i.id, 'guideline', 'World Health Organization. Psychological self-help interventions: delivering self-help for individuals, featuring Step-by-Step and Doing What Matters in Times of Stress. 2026.', 'https://www.who.int/publications/i/item/9789240120785', 2026, 'Structured low-intensity psychological self-help and guided/unguided delivery with appropriate scope boundaries.', 'Does not validate Malaak wording or authorize copying manual scripts; not a substitute for specialist treatment when impairment/risk is high.', 'WHO 2026 manual uses non-commercial terms by default; Malaak uses original wording and requires separate commercial permission before copying protected material.', now(), 'Malaak V5 evidence review'
from public.malaak_interventions i where i.code = 'REG_MOVE_002' and i.version = 1
on conflict (intervention_id, source_url, supports) do nothing;

insert into public.malaak_intervention_sources (
  intervention_id, source_type, citation_text, source_url, publication_year, supports, limitations, license_notes, reviewed_at, reviewed_by
) select i.id, 'systematic_review', 'McRae K, Gross JJ. Emotion regulation. Emotion. 2020;20(1):1-9. PMID 31961170.', 'https://pubmed.ncbi.nlm.nih.gov/31961170/', 2020, 'Process-based emotion regulation: identify need, select/implement a strategy, then monitor success; cognitive reappraisal is a well-studied strategy.', 'Conceptual review; does not validate a particular app exercise or imply one strategy is universally best.', 'Conceptual principles summarized.', now(), 'Malaak V5 evidence review'
from public.malaak_interventions i where i.code = 'REG_MOVE_002' and i.version = 1
on conflict (intervention_id, source_url, supports) do nothing;

insert into public.malaak_intervention_sources (
  intervention_id, source_type, citation_text, source_url, publication_year, supports, limitations, license_notes, reviewed_at, reviewed_by
) select i.id, 'guideline', 'World Health Organization. Psychological self-help interventions: delivering self-help for individuals, featuring Step-by-Step and Doing What Matters in Times of Stress. 2026.', 'https://www.who.int/publications/i/item/9789240120785', 2026, 'Structured low-intensity psychological self-help and guided/unguided delivery with appropriate scope boundaries.', 'Does not validate Malaak wording or authorize copying manual scripts; not a substitute for specialist treatment when impairment/risk is high.', 'WHO 2026 manual uses non-commercial terms by default; Malaak uses original wording and requires separate commercial permission before copying protected material.', now(), 'Malaak V5 evidence review'
from public.malaak_interventions i where i.code = 'REG_BREATHE_003' and i.version = 1
on conflict (intervention_id, source_url, supports) do nothing;

insert into public.malaak_intervention_sources (
  intervention_id, source_type, citation_text, source_url, publication_year, supports, limitations, license_notes, reviewed_at, reviewed_by
) select i.id, 'systematic_review', 'McRae K, Gross JJ. Emotion regulation. Emotion. 2020;20(1):1-9. PMID 31961170.', 'https://pubmed.ncbi.nlm.nih.gov/31961170/', 2020, 'Process-based emotion regulation: identify need, select/implement a strategy, then monitor success; cognitive reappraisal is a well-studied strategy.', 'Conceptual review; does not validate a particular app exercise or imply one strategy is universally best.', 'Conceptual principles summarized.', now(), 'Malaak V5 evidence review'
from public.malaak_interventions i where i.code = 'EMO_NAME_001' and i.version = 1
on conflict (intervention_id, source_url, supports) do nothing;

insert into public.malaak_intervention_sources (
  intervention_id, source_type, citation_text, source_url, publication_year, supports, limitations, license_notes, reviewed_at, reviewed_by
) select i.id, 'systematic_review', 'McRae K, Gross JJ. Emotion regulation. Emotion. 2020;20(1):1-9. PMID 31961170.', 'https://pubmed.ncbi.nlm.nih.gov/31961170/', 2020, 'Process-based emotion regulation: identify need, select/implement a strategy, then monitor success; cognitive reappraisal is a well-studied strategy.', 'Conceptual review; does not validate a particular app exercise or imply one strategy is universally best.', 'Conceptual principles summarized.', now(), 'Malaak V5 evidence review'
from public.malaak_interventions i where i.code = 'EMO_CHAIN_002' and i.version = 1
on conflict (intervention_id, source_url, supports) do nothing;

insert into public.malaak_intervention_sources (
  intervention_id, source_type, citation_text, source_url, publication_year, supports, limitations, license_notes, reviewed_at, reviewed_by
) select i.id, 'guideline', 'NICE CG113. Generalised anxiety disorder and panic disorder in adults: management. Recommendations.', 'https://www.nice.org.uk/guidance/cg113/chapter/Recommendations', 2020, 'Stepped care, CBT-based low-intensity self-help, routine outcome monitoring, problem-solving/cognitive principles, and stepping up with marked impairment or non-response.', 'Guideline is for diagnosed GAD/panic care; Malaak uses only transdiagnostic low-risk principles and does not diagnose or deliver high-intensity treatment.', 'Principles summarized; no treatment manual text copied.', now(), 'Malaak V5 evidence review'
from public.malaak_interventions i where i.code = 'EMO_CHAIN_002' and i.version = 1
on conflict (intervention_id, source_url, supports) do nothing;

insert into public.malaak_intervention_sources (
  intervention_id, source_type, citation_text, source_url, publication_year, supports, limitations, license_notes, reviewed_at, reviewed_by
) select i.id, 'guideline', 'NICE CG113. Generalised anxiety disorder and panic disorder in adults: management. Recommendations.', 'https://www.nice.org.uk/guidance/cg113/chapter/Recommendations', 2020, 'Stepped care, CBT-based low-intensity self-help, routine outcome monitoring, problem-solving/cognitive principles, and stepping up with marked impairment or non-response.', 'Guideline is for diagnosed GAD/panic care; Malaak uses only transdiagnostic low-risk principles and does not diagnose or deliver high-intensity treatment.', 'Principles summarized; no treatment manual text copied.', now(), 'Malaak V5 evidence review'
from public.malaak_interventions i where i.code = 'LOAD_SORT_001' and i.version = 1
on conflict (intervention_id, source_url, supports) do nothing;

insert into public.malaak_intervention_sources (
  intervention_id, source_type, citation_text, source_url, publication_year, supports, limitations, license_notes, reviewed_at, reviewed_by
) select i.id, 'guideline', 'World Health Organization. Psychological self-help interventions: delivering self-help for individuals, featuring Step-by-Step and Doing What Matters in Times of Stress. 2026.', 'https://www.who.int/publications/i/item/9789240120785', 2026, 'Structured low-intensity psychological self-help and guided/unguided delivery with appropriate scope boundaries.', 'Does not validate Malaak wording or authorize copying manual scripts; not a substitute for specialist treatment when impairment/risk is high.', 'WHO 2026 manual uses non-commercial terms by default; Malaak uses original wording and requires separate commercial permission before copying protected material.', now(), 'Malaak V5 evidence review'
from public.malaak_interventions i where i.code = 'LOAD_SORT_001' and i.version = 1
on conflict (intervention_id, source_url, supports) do nothing;

