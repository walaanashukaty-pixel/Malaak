import test from 'node:test';
import assert from 'node:assert/strict';
import fs from 'node:fs';
import path from 'node:path';
import { fileURLToPath } from 'node:url';

const here = path.dirname(fileURLToPath(import.meta.url));
const source = fs.readFileSync(path.join(here, 'index.ts'), 'utf8');

test('edge function refreshes journey plan after evidence/formulation persistence', () => {
  assert.match(source, /import\s+\{[^}]*refreshJourneyPlanForUser[^}]*\}\s+from\s+'\.\/journey_repository\.ts'/s);
  const evidenceIndex = source.indexOf('persistCoachingEvidence');
  const refreshIndex = source.lastIndexOf('refreshJourneyPlanForUser');
  assert.ok(evidenceIndex >= 0);
  assert.ok(refreshIndex > evidenceIndex);
  assert.match(source, /refreshJourneyPlanForUser\(jwtPayload\.sub\)/);
});


test('safety route suspends stored journey plan before returning safety response', () => {
  assert.match(source, /suspendJourneyPlanForSafety/);
  const safetyBranch = source.slice(source.indexOf("if (route.mode === 'safety')"), source.indexOf("const apiKey"));
  assert.match(safetyBranch, /suspendJourneyPlanForSafety\(jwtPayload\.sub\)/);
});
