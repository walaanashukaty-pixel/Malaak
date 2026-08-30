import { catalogSeed } from '../supabase/functions/malaak-ai/catalog_seed.ts';
import { writeFileSync, readdirSync, unlinkSync } from 'node:fs';

const q = (value) => value === null || value === undefined ? 'null' : `'${String(value).replaceAll("'", "''")}'`;
const b = (value) => value ? 'true' : 'false';
const arr = (values) => values.length ? `array[${values.map(q).join(',')}]::text[]` : `array[]::text[]`;
const j = (value) => `${q(JSON.stringify(value))}::jsonb`;
const chunkSize = 6;
const dir = 'supabase/migrations';
for (const file of readdirSync(dir)) {
  if (file.startsWith('20260829_malaak_intervention_seed_v5_')) unlinkSync(`${dir}/${file}`);
}

const total = Math.ceil(catalogSeed.length / chunkSize);
for (let part = 0; part < total; part++) {
  const cards = catalogSeed.slice(part * chunkSize, (part + 1) * chunkSize);
  const cardLines = [
    '-- Generated deterministically from supabase/functions/malaak-ai/catalog_seed.ts',
    `-- V5 intervention cards part ${part + 1} of ${total}. Do not hand-edit.`, '',
  ];
  const sourceLines = [
    '-- Generated deterministically from supabase/functions/malaak-ai/catalog_seed.ts',
    `-- V5 intervention sources part ${part + 1} of ${total}. Replaces source rows for this card chunk.`, '',
    `delete from public.malaak_intervention_sources where intervention_id in (select id from public.malaak_interventions where code in (${cards.map(c=>q(c.code)).join(',')}));`, '',
  ];
  for (const card of cards) {
    cardLines.push(`insert into public.malaak_interventions (`);
    cardLines.push(`  code, version, status, title_ar, short_description_ar, framework, evidence_tier, content_origin, licensing_status,`);
    cardLines.push(`  target_needs, target_patterns, eligible_states, journey_domains, exclusions, contraindication_notes_ar, duration_min,`);
    cardLines.push(`  steps_ar, action_template_ar, measurement_spec, follow_up_spec, fallback_code, requires_user_confirmation, activated_at,`);
    cardLines.push(`  scientific_review_status, clinical_boundary_review_status, requires_human_support`);
    cardLines.push(`) values (`);
    cardLines.push(`  ${q(card.code)}, ${card.version}, ${q(card.status)}, ${q(card.titleAr)}, ${q(card.shortDescriptionAr)}, ${q(card.framework)}, ${q(card.evidenceTier)}, ${q(card.contentOrigin)}, ${q(card.licensingStatus)},`);
    cardLines.push(`  ${arr(card.targetNeeds)}, ${arr(card.targetPatterns)}, ${arr(card.eligibleStates)}, ${arr(card.journeyDomains)}, ${j(card.exclusions)}, ${q(card.contraindicationNotesAr)}, ${card.durationMin},`);
    cardLines.push(`  ${j(card.stepsAr)}, ${q(card.actionTemplateAr)}, ${j(card.measurementSpec)}, ${j(card.followUpSpec)}, ${q(card.fallbackCode)}, ${b(card.requiresUserConfirmation)}, ${card.status === 'active' ? 'now()' : 'null'},`);
    cardLines.push(`  ${q(card.scientificReviewStatus)}, ${q(card.clinicalBoundaryReviewStatus)}, ${b(card.requiresHumanSupport)}`);
    cardLines.push(`) on conflict (code, version) do nothing;`, '');

    for (const source of card.sources) {
      sourceLines.push(`insert into public.malaak_intervention_sources (`);
      sourceLines.push(`  intervention_id, source_type, citation_text, source_url, publication_year, supports, limitations, license_notes, reviewed_at, reviewed_by`);
      sourceLines.push(`) select i.id, ${q(source.sourceType)}, ${q(source.citationText)}, ${q(source.sourceUrl)}, ${source.publicationYear}, ${q(source.supports)}, ${q(source.limitations)}, ${q(source.licenseNotes)}, ${source.reviewed ? 'now()' : 'null'}, ${q(source.reviewedBy)}`);
      sourceLines.push(`from public.malaak_interventions i where i.code = ${q(card.code)} and i.version = ${card.version}`);
      sourceLines.push(`on conflict (intervention_id, source_url, supports) do nothing;`, '');
    }
  }
  const suffix=String(part+1).padStart(2,'0');
  writeFileSync(`${dir}/20260829_malaak_intervention_seed_v5_cards_${suffix}.sql`, cardLines.join('\n')+'\n');
  writeFileSync(`${dir}/20260829_malaak_intervention_seed_v5_sources_${suffix}.sql`, sourceLines.join('\n')+'\n');
}
console.log(`generated ${catalogSeed.length} revisions as ${total} card parts + ${total} source parts`);
