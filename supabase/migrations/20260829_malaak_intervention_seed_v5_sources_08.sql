-- Generated deterministically from supabase/functions/malaak-ai/catalog_seed.ts
-- V5 intervention sources part 8 of 8. Replaces source rows for this card chunk.

delete from public.malaak_intervention_sources where intervention_id in (select id from public.malaak_interventions where code in ('BAL_WAR_MODE_001','BAL_CONTROL_RESP_002','BAL_RECEIVE_REST_003','FI_STATE_COMPASS_001','FI_TIME_DISTANCE_002','FI_EMOTION_INTENTION_003'));

insert into public.malaak_intervention_sources (
  intervention_id, source_type, citation_text, source_url, publication_year, supports, limitations, license_notes, reviewed_at, reviewed_by
) select i.id, 'meta_analysis', 'Galloway R, et al. The efficacy of randomised controlled trials of CBT for perfectionism: a systematic review and meta-analysis. 2021/2022. PMID 34346282.', 'https://pubmed.ncbi.nlm.nih.gov/34346282/', 2021, 'CBT approaches can reduce perfectionism-related processes and support testing rigid rules/standards.', 'Does not validate the feminine-balance taxonomy; evidence belongs to the perfectionism/control component only.', 'General CBT principles summarized.', now(), 'Malaak V5 evidence review'
from public.malaak_interventions i where i.code = 'BAL_CONTROL_RESP_002' and i.version = 1
on conflict (intervention_id, source_url, supports) do nothing;

insert into public.malaak_intervention_sources (
  intervention_id, source_type, citation_text, source_url, publication_year, supports, limitations, license_notes, reviewed_at, reviewed_by
) select i.id, 'meta_analysis', 'Macri JA, Rogge RD. Examining domains of psychological flexibility and inflexibility as treatment mechanisms in ACT: systematic and meta-analytic review. Clin Psychol Rev. 2024;110:102432.', 'https://pubmed.ncbi.nlm.nih.gov/38615492/', 2024, 'ACT-related changes in defusion, acceptance, present-moment awareness and committed action are associated with reduced distress.', 'Mechanism evidence does not validate Malaak or every ACT-derived micro-skill; crisis populations require additional care.', 'General ACT mechanisms summarized; no manual scripts copied.', now(), 'Malaak V5 evidence review'
from public.malaak_interventions i where i.code = 'BAL_CONTROL_RESP_002' and i.version = 1
on conflict (intervention_id, source_url, supports) do nothing;

insert into public.malaak_intervention_sources (
  intervention_id, source_type, citation_text, source_url, publication_year, supports, limitations, license_notes, reviewed_at, reviewed_by
) select i.id, 'meta_analysis', 'Macri JA, Rogge RD. Examining domains of psychological flexibility and inflexibility as treatment mechanisms in ACT: systematic and meta-analytic review. Clin Psychol Rev. 2024;110:102432.', 'https://pubmed.ncbi.nlm.nih.gov/38615492/', 2024, 'ACT-related changes in defusion, acceptance, present-moment awareness and committed action are associated with reduced distress.', 'Mechanism evidence does not validate Malaak or every ACT-derived micro-skill; crisis populations require additional care.', 'General ACT mechanisms summarized; no manual scripts copied.', now(), 'Malaak V5 evidence review'
from public.malaak_interventions i where i.code = 'FI_TIME_DISTANCE_002' and i.version = 1
on conflict (intervention_id, source_url, supports) do nothing;

insert into public.malaak_intervention_sources (
  intervention_id, source_type, citation_text, source_url, publication_year, supports, limitations, license_notes, reviewed_at, reviewed_by
) select i.id, 'systematic_review', 'McRae K, Gross JJ. Emotion regulation. Emotion. 2020;20(1):1-9. PMID 31961170.', 'https://pubmed.ncbi.nlm.nih.gov/31961170/', 2020, 'Process-based emotion regulation: identify need, select/implement a strategy, then monitor success; cognitive reappraisal is a well-studied strategy.', 'Conceptual review; does not validate a particular app exercise or imply one strategy is universally best.', 'Conceptual principles summarized.', now(), 'Malaak V5 evidence review'
from public.malaak_interventions i where i.code = 'FI_EMOTION_INTENTION_003' and i.version = 1
on conflict (intervention_id, source_url, supports) do nothing;

insert into public.malaak_intervention_sources (
  intervention_id, source_type, citation_text, source_url, publication_year, supports, limitations, license_notes, reviewed_at, reviewed_by
) select i.id, 'meta_analysis', 'Macri JA, Rogge RD. Examining domains of psychological flexibility and inflexibility as treatment mechanisms in ACT: systematic and meta-analytic review. Clin Psychol Rev. 2024;110:102432.', 'https://pubmed.ncbi.nlm.nih.gov/38615492/', 2024, 'ACT-related changes in defusion, acceptance, present-moment awareness and committed action are associated with reduced distress.', 'Mechanism evidence does not validate Malaak or every ACT-derived micro-skill; crisis populations require additional care.', 'General ACT mechanisms summarized; no manual scripts copied.', now(), 'Malaak V5 evidence review'
from public.malaak_interventions i where i.code = 'FI_EMOTION_INTENTION_003' and i.version = 1
on conflict (intervention_id, source_url, supports) do nothing;

