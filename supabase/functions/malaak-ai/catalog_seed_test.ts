import test from 'node:test';
import assert from 'node:assert/strict';
import { catalogSeed } from './catalog_seed.ts';

const v4Codes = [
  'REG_GROUND_001','REG_MOVE_002','ANGER_TIMEOUT_001','THOUGHT_FACTS_001',
  'RUMINATION_EXIT_001','UNCERTAINTY_001','NEED_NAME_001','REQUEST_DIRECT_001',
  'BOUNDARY_001','PROBLEM_SOLVE_001',
];

test('catalog seed contains exactly 48 unique intervention codes', () => {
  assert.equal(catalogSeed.length, 48);
  assert.equal(new Set(catalogSeed.map((x) => x.code)).size, 48);
});

test('all V4 codes remain present for backward compatibility', () => {
  for (const code of v4Codes) assert.ok(catalogSeed.some((x) => x.code === code), code);
});

test('active cards are cleared and reviewed', () => {
  for (const card of catalogSeed.filter((x) => x.status === 'active')) {
    assert.ok(['cleared_original','licensed'].includes(card.licensingStatus), card.code);
    assert.equal(card.scientificReviewStatus, 'reviewed', card.code);
    assert.equal(card.clinicalBoundaryReviewStatus, 'reviewed', card.code);
    assert.notEqual(card.evidenceTier, 'X', card.code);
  }
});

test('active A B C cards have at least one reviewed scientific source', () => {
  for (const card of catalogSeed.filter((x) => x.status === 'active' && ['A','B','C'].includes(x.evidenceTier))) {
    assert.ok(card.sources.length > 0, `${card.code} missing sources`);
    assert.ok(card.sources.some((s) => s.reviewed && s.sourceType !== 'coaching_reference'), `${card.code} missing reviewed scientific source`);
  }
});

test('D cards are explicitly coaching-only', () => {
  for (const card of catalogSeed.filter((x) => x.evidenceTier === 'D')) {
    assert.match(card.framework, /coaching/i, card.code);
    assert.match(card.contentOrigin, /coaching/i, card.code);
  }
});

test('childhood and healing cards explicitly exclude memory recovery or deep trauma processing', () => {
  for (const card of catalogSeed.filter((x) => x.code.startsWith('CHILD_') || x.code.startsWith('HEAL_'))) {
    const text = `${card.exclusions.join(' ')} ${card.contraindicationNotesAr}`.toLowerCase();
    assert.ok(text.includes('trauma') || text.includes('صدمة') || text.includes('memory') || text.includes('ذاكرة'), card.code);
  }
});
