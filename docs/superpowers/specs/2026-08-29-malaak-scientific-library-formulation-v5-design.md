# Malaak V5 Scientific Library, Progressive Assessment & Journey Planning Design

Date: 2026-08-29
Status: Proposed for user review after approved architectural direction

## 1. Goal

Build V5 as three coordinated subsystems on top of the existing V4 coaching engine:

1. **V5A — Scientific Intervention Library:** replace the small hardcoded library with a versioned, auditable Supabase catalog of approved self-help/coaching interventions.
2. **V5B — Progressive Assessment & Working Formulation:** learn from onboarding, real-life events, journal entries the user permits, coaching turns, and follow-ups without diagnosing or turning one message into a fixed psychological label.
3. **V5C — Journey Planner:** select one primary journey, one support journey, and optional monitor/later domains based on safety, regulation readiness, the user’s goals, repeated patterns, functional impact, and real-life outcomes.

V5 must preserve the approved mobile/Figma UX. It adds intelligence and data quality under the existing screens rather than turning the app into a clinical dashboard.

## 2. Product Boundary

Malaak remains a **digital coaching and structured self-help system**, not a therapist, doctor, diagnostic instrument, crisis service, or autonomous treatment provider.

V5 may:
- help users identify emotions, thoughts, needs, triggers, urges, behaviors, and outcomes;
- guide low-risk behavioral/self-help skills from the approved catalog;
- personalize based on user-approved data and repeated observations;
- recommend human/professional support when the app’s scope is insufficient;
- create and revise a working formulation using probabilistic language.

V5 must not:
- diagnose PTSD, OCD, depression, GAD, personality disorders, attachment disorders, or any other condition;
- perform trauma exposure, prolonged exposure, EMDR, memory reconsolidation protocols, recovered-memory work, or deep trauma processing;
- run ERP as an OCD treatment pathway without a dedicated clinically governed product and qualified oversight;
- infer abuse is caused by the user’s attachment style, femininity, childhood wounds, or communication style;
- promise healing percentages, femininity percentages, “wound scores,” or clinical recovery rates;
- decide divorce, reconciliation, pregnancy, medication, legal action, or other high-impact decisions for the user;
- use private journal content for AI analysis when the user has marked it private.

## 3. Architectural Choice

Use a **hybrid rules-first, catalog-driven architecture**.

### 3.1 Server-owned responsibilities

Deterministic server code owns:
- immediate safety routing;
- eligibility/exclusion rules;
- current-state gates;
- catalog version and activation status;
- journey priority rules;
- evidence-status rules for hypotheses;
- validation of all model output;
- fallback behavior when OpenAI or the network fails.

### 3.2 Supabase-owned catalog

Supabase becomes the source of truth for approved intervention cards and their evidence/licensing metadata. This allows a card to be corrected, paused, or retired without requiring a new Android APK.

### 3.3 Model-owned responsibilities

The language model may:
- personalize wording;
- summarize user-permitted context;
- extract candidate structured observations from free text;
- choose among server-eligible interventions;
- ask one useful clarifying question when the router lacks enough information;
- propose a single real-life action and a structured follow-up.

The model may not:
- create new intervention codes;
- override an exclusion;
- upgrade a hypothesis to a repeated pattern by itself;
- change a journey priority tier by itself;
- override safety mode;
- treat model inference as a fact.

## 4. Scientific Governance

### 4.1 Evidence tiers

Evidence tier describes the **underlying principle/technique**, not proof that Malaak’s exact wording or implementation has been clinically validated.

- **A — Strong foundation:** supported by a major guideline and/or multiple high-quality systematic reviews/meta-analyses for the target process.
- **B — Good foundation:** supported by multiple controlled studies or systematic reviews, but evidence is narrower, population-specific, or less mature.
- **C — Promising/adjunctive:** limited or emerging evidence; never a core treatment claim and never the only response to substantial impairment.
- **D — Coaching heuristic:** useful organizing language with no claim of clinical efficacy; must be internally marked as coaching-only.
- **X — Prohibited/unsupported:** not available to the model.

### 4.2 Source precedence

For evidence review, prefer in this order:
1. WHO / NICE / APA / SAMHSA and comparable professional guidelines.
2. Systematic reviews and meta-analyses.
3. Randomized controlled trials.
4. Established professional manuals and academic books.
5. Coaching literature only for language, scenarios, and presentation after evidence review.

### 4.3 Licensing rule

Every intervention card has a licensing status:
- `cleared_original` — original Malaak wording derived from general scientific principles;
- `licensed` — explicit permission/license on file;
- `review_required` — may not ship in production until reviewed;
- `restricted` — cannot be used in the commercial product.

No protected questionnaire, therapy manual script, book exercise, or WHO manual content may be copied merely because it is scientifically reputable. WHO’s 2026 self-help manual is available under CC BY-NC-SA 3.0 IGO for non-commercial use; commercial adaptation requires permission. Therefore V5 uses original app wording unless a separate commercial license has been cleared.

### 4.4 Review gate

A card can move from `draft` to `active` only when:
- its intended target and exclusion rules are explicit;
- its evidence tier is justified by card-level sources;
- its app wording is original or commercially licensed;
- its measurement and fallback are defined;
- scientific review status is `reviewed`;
- clinical-boundary review status is `reviewed`;
- it has no unresolved safety or licensing note.

Childhood, adult emotional healing, anger, relationship, and any trauma-adjacent card require an explicit boundary review before activation.

### 4.5 Clinical-boundary registry

The catalog must explicitly mark higher-risk techniques as unavailable. Initial `X` registry includes:
- trauma exposure / prolonged exposure;
- EMDR procedures;
- recovered-memory or “hidden memory” exercises;
- deep imaginal trauma reliving;
- OCD ERP treatment protocols;
- suicide safety planning that pretends to replace local professional/crisis support;
- confrontational couple exercises when interpersonal danger is possible;
- forced forgiveness;
- “feminine energy” or “manifestation” claims presented as scientific mechanisms.

## 5. V5A — Intervention Catalog Data Model

### 5.1 `malaak_interventions`

Intervention revisions are append-only. Updating scientific content creates a new version row so every historical coaching turn can be audited against the exact card that was used.

Fields:
- `id uuid primary key`
- `code text not null`
- `version integer not null`
- unique constraint on `(code, version)`
- partial unique constraint allowing only one `active` version per `code`
- `status text` — `draft | active | paused | retired | prohibited`
- `title_ar text`
- `short_description_ar text`
- `framework text`
- `evidence_tier text` — `A | B | C | D | X`
- `content_origin text`
- `licensing_status text`
- `target_needs text[]`
- `target_patterns text[]`
- `eligible_states text[]`
- `journey_domains text[]`
- `exclusions jsonb`
- `contraindication_notes_ar text`
- `duration_min smallint`
- `steps_ar jsonb`
- `action_template_ar text`
- `measurement_spec jsonb`
- `follow_up_spec jsonb`
- `fallback_code text null`
- `requires_user_confirmation boolean`
- `activated_at timestamptz null`
- `retired_at timestamptz null`
- `scientific_review_status text` — `pending | reviewed | rejected`
- `clinical_boundary_review_status text` — `pending | reviewed | rejected`
- `requires_human_support boolean`
- `created_at timestamptz`
- `updated_at timestamptz`

Catalog rows are server-managed. Normal authenticated app users receive no direct write permission. Once a revision has been active, its scientific content is not edited in place; a corrected card is a new version and the old version remains available for historical audit.

### 5.2 `malaak_intervention_sources`

Fields:
- `id uuid primary key`
- `intervention_id uuid references malaak_interventions(id)`
- `source_type text` — `guideline | meta_analysis | systematic_review | rct | professional_manual | coaching_reference`
- `citation_text text`
- `source_url text`
- `publication_year integer`
- `supports text` — short statement of what this source actually supports
- `limitations text`
- `license_notes text`
- `reviewed_at timestamptz`
- `reviewed_by text`

### 5.3 Catalog fetch behavior

The Edge Function fetches only the current `active` version of cards needed for the route. It caches a compact catalog snapshot in memory per function instance. The Flutter app never decides eligibility from a downloaded catalog. Each coaching turn stores both `intervention_code` and `intervention_version` so later catalog changes cannot rewrite history.

If the database catalog is unavailable, the Edge Function uses a small embedded emergency fallback set containing only low-risk regulation/clarity tools.

## 6. Proposed V5A Catalog — 48 Unique Candidate Codes

The initial release targets **48 unique card codes**. Existing V4 codes remain unchanged for backward compatibility. A code appearing in this list does **not** make it production-approved: every new card starts as `draft` and becomes `active` only after its evidence, clinical-boundary, wording, and licensing checks pass.

### 6.1 Emotional state / regulation — 5

1. `REG_GROUND_001` — تثبيت الحاضر. Existing.
2. `REG_MOVE_002` — حركة قصيرة للتنظيم. Existing.
3. `REG_BREATHE_003` — تنفس بطيء مريح، optional and modified if breath focus increases distress.
4. `EMO_NAME_001` — ملاحظة وتسـمية الشعور without forcing precision.
5. `EMO_CHAIN_002` — event → interpretation → emotion → body → urge → behavior.

### 6.2 Inner peace / overload — 3

6. `LOAD_SORT_001` — الآن / لاحقًا / ليس تحت سيطرتي.
7. `CONTROL_CIRCLE_001` — actionable vs uncontrollable concern.
8. `REST_RECOVERY_001` — minimum viable recovery plan under overload.

### 6.3 Needs / boundaries — 5

9. `NEED_NAME_001` — identify a need. Existing.
10. `NEED_STRATEGY_002` — need ≠ strategy/control of another person.
11. `REQUEST_DIRECT_001` — concrete non-blaming request. Existing.
12. `BOUNDARY_001` — concise boundary. Existing.
13. `NO_TOLERATE_002` — tolerate guilt/disapproval after a reasonable boundary or “no.”

### 6.4 Attachment / reassurance — 5

14. `UNCERTAINTY_001` — tolerate a bounded amount of uncertainty. Existing.
15. `ATT_TRIGGER_001` — map attachment activation without labeling identity.
16. `ATT_REALITY_002` — internal alarm vs external relationship evidence.
17. `ATT_REASSURE_DELAY_003` — delay repetitive reassurance/checking while preserving appropriate communication.
18. `ATT_REPAIR_004` — return after conflict with a direct need/repair action.

### 6.5 Relationship — 5

19. `REL_CYCLE_001` — map the interaction cycle rather than assigning one “bad partner.”
20. `ANGER_TIMEOUT_001` — safe non-punitive time-out with return plan. Existing and shared with anger.
21. `REL_SOFT_START_002` — start a difficult conversation without accusation.
22. `REL_REPAIR_003` — accountability + repair attempt after conflict.
23. `REL_TRUST_STEP_004` — rebuild trust through observable consistency, not forced blind trust.

### 6.6 Overthinking / thought mirror — 6

24. `THOUGHT_FACTS_001` — facts vs interpretation. Existing.
25. `RUMINATION_EXIT_001` — stop circular analysis. Existing.
26. `PROBLEM_SOLVE_001` — one solvable problem + one step. Existing.
27. `WORRY_POSTPONE_002` — postpone non-urgent worry to a bounded later window.
28. `DEFUSION_003` — notice a thought as a mental event rather than literal truth.
29. `REASSURANCE_BREAK_004` — detect when another answer is only producing short-lived reassurance.

### 6.7 Anger — 5, one shared with Relationship

30. `ANGER_THERMOMETER_002` — identify early escalation signs before 10/10.
31. `ANGER_CHAIN_003` — vulnerability → trigger → appraisal → urge → behavior → consequence.
32. `ANGER_ASSERT_004` — convert anger message into calm assertiveness when safe.
33. `ANGER_REPAIR_005` — responsibility and repair after harmful behavior without shame-based avoidance.

Shared fifth anger card: `ANGER_TIMEOUT_001`, already counted as item 20 in Relationship, so the catalog still contains 48 unique codes.

### 6.8 Childhood effects — 4

34. `CHILD_PRESENT_PAST_001` — distinguish present cue from past learning.
35. `CHILD_OLD_BELIEF_002` — identify an old learned belief as a hypothesis, not recovered fact.
36. `CHILD_SELF_COMPASSION_003` — self-compassion with present-day responsibility.
37. `CHILD_PATTERN_EXPERIMENT_004` — low-risk behavioral experiment against an old rule.

No childhood card asks the user to retrieve hidden memories, relive trauma, or infer that a specific event “must have happened.”

### 6.9 Adult emotional healing — 5

38. `HEAL_STABILIZE_001` — stabilize functioning before story analysis.
39. `HEAL_FACTS_STORY_002` — facts / interpretation / responsibility / unknowns after relational injury.
40. `HEAL_GRIEF_003` — identify what was actually lost without forcing fixed grief stages.
41. `HEAL_SELF_WORTH_004` — separate another person’s choice from global self-worth.
42. `HEAL_TRUST_GRADUAL_005` — calibrated, evidence-based rebuilding of trust.

### 6.10 Feminine balance — 3

43. `BAL_WAR_MODE_001` — identify overdrive/defense mode using coaching language.
44. `BAL_CONTROL_RESP_002` — control vs responsibility; choose one controllable action and release micromanagement.
45. `BAL_RECEIVE_REST_003` — practice receiving/resting without framing passivity as femininity.

These cards use a coaching model, not claims that “feminine energy” is a validated biological mechanism. Their default framework classification is coaching-only (`D`) unless a specific underlying component (for example uncertainty tolerance, assertiveness, rest/recovery, or psychological flexibility) has its own separately documented A/B/C evidence; the feminine label itself never inherits that evidence automatically.

### 6.11 Feminine intelligence compass — 3

46. `FI_STATE_COMPASS_001` — contextual coaching-state identification: naïveté / masculine overdrive / masculine intelligence / feminine intelligence.
47. `FI_TIME_DISTANCE_002` — timing + perspective distance before action.
48. `FI_EMOTION_INTENTION_003` — emotion as information + clarify the actual intention/goal.

The four-state taxonomy is explicitly stored as `framework = coaching_model` and evidence tier `D` for the taxonomy itself, not as a clinical psychology taxonomy. Individual skills embedded in the card may point to stronger evidence records, but those records support the skill, not the four-state taxonomy.

## 7. Measurement Contract for Intervention Cards

Every active card must define a minimum measurement contract. The app must not ask all measurements every time; it chooses the smallest meaningful set.

Possible measurements:
- `intensity_before / intensity_after` (0–10, subjective, not a diagnostic score)
- `urge_before / urge_after`
- `clarity_before / clarity_after`
- `behavior_completed boolean`
- `reassurance_count`
- `checking_count`
- `recovery_minutes`
- `action_outcome` — `helped | neutral | worsened | unknown`
- `user_helpfulness` — simple user rating
- `real_world_result` — concise text or structured result

No measure is converted into “healing %.”

Every persisted `malaak_coaching_turn` in V5 stores `intervention_code`, `intervention_version`, and the catalog row ID used for that response. This is required for reproducibility and safety audits.

## 8. V5B — Progressive Assessment

### 8.1 Assessment philosophy

Assessment is progressive and event-based. First-day onboarding should identify a useful starting point, not declare a personality or diagnosis.

### 8.2 Initial onboarding target: 3–5 minutes

Required minimum:
1. `primary_concern` — what brought the user now.
2. `life_context` — relationship/work/family/self/other.
3. `current_impact` — low/moderate/high impact on daily functioning, user-reported.
4. `immediate_safety` — only the minimum safety questions needed for the current context.
5. `desired_change` — what the user wants to be different.
6. `coaching_preference` — listen / organize / challenge thoughts / act / calm.
7. `privacy_scope` — what Malaak may remember/analyze.

The onboarding result is explicitly labeled `initial_map`, not “your psychological profile.”

### 8.3 No diagnostic-test shortcut

V5 does not ship a clinical diagnostic questionnaire merely to make onboarding feel scientific. A standardized scale can be added later only when its purpose, psychometrics for the intended Arabic-speaking population, licensing/permission, scoring interpretation, and escalation consequences are reviewed. Until then the planner uses the user’s goal, functioning, event observations, and non-diagnostic app measures.

### 8.4 Ongoing assessment sources

Only user-permitted sources can create assessment observations:
- Malaak messages;
- structured check-ins;
- coaching turn outcomes;
- follow-up answers;
- journey exercises;
- journal entries with analysis enabled;
- explicit user corrections/confirmations.

Private journal entries never enter the formulation pipeline.

## 9. Observation Model

### 9.1 `malaak_observations`

Fields:
- `id uuid`
- `user_id uuid`
- `source_type text`
- `source_id text null`
- `occurred_at timestamptz`
- `context_domain text`
- `trigger text null`
- `event_fact text null`
- `automatic_thought text null`
- `emotion text null`
- `intensity_before smallint null`
- `body_signals jsonb`
- `urge text null`
- `need text null`
- `behavior text null`
- `outcome text null`
- `intensity_after smallint null`
- `recovery_minutes integer null`
- `intervention_code text null`
- `intervention_version integer null`
- `intervention_helpfulness text null`
- `extraction_origin text` — `user_structured | user_confirmed | model_extracted`
- `confirmed_by_user boolean`
- `created_at timestamptz`

Observation records describe reported events; they do not assert diagnosis or causation.

## 10. Fact / Observation / Hypothesis Separation

V5 stores five epistemic classes and never silently upgrades one to another.

### 10.1 Fact
Direct personal information the user explicitly stated and allowed Malaak to remember.

Example: “عندي طفلين.”

### 10.2 Observation
A reported event or behavior.

Example: “بعد تأخر الرد، أرسلت 8 رسائل.”

### 10.3 Hypothesis
A tentative explanatory pattern.

Example: “المسافة بعد الخلاف قد تفعّل خوف الرفض.”

### 10.4 Repeated Pattern
A hypothesis supported by repeated independent observations according to deterministic evidence rules.

### 10.5 Validated User Insight
The user has explicitly confirmed that the repeated formulation meaningfully represents her experience.

This validation is not clinical validation; it means only that the user recognizes the pattern as personally accurate/useful.

## 11. Hypothesis Data Model

### 11.1 `malaak_hypotheses`

Fields:
- `id uuid`
- `user_id uuid`
- `domain text`
- `pattern_key text`
- `statement_ar text`
- `status text` — `candidate | repeated | user_validated | user_rejected | dormant`
- `confidence_label text` — `low | medium | high`
- `supporting_observation_ids uuid[]`
- `contradicting_observation_ids uuid[]`
- `support_count integer`
- `distinct_days integer`
- `distinct_contexts integer`
- `first_seen_at timestamptz`
- `last_seen_at timestamptz`
- `user_validation text null` — `yes | partly | no`
- `updated_at timestamptz`

No probability percentage is shown or stored as if it represented psychological truth.

## 12. Deterministic Pattern-Evidence Rules

Confidence labels indicate **amount and consistency of observed evidence**, not probability of a diagnosis or causal truth.

### Candidate / Low
- at least 1 supporting observation;
- model language: “في إشارة أولية…” / “ممكن…”

### Repeated / Medium
- at least 3 supporting observations;
- spread across at least 2 distinct days;
- no user rejection;
- no strong contradictory pattern dominating the same context.

Model language: “عم يتكرر عندك…” / “في نمط متكرر خصوصًا في…”

### High evidence for a personal pattern
Requires either:
- at least 5 supporting observations across at least 3 distinct days plus explicit user confirmation; or
- at least 6 supporting observations across at least 2 contexts plus no user rejection.

Model language remains non-diagnostic: “هاد صار نمط قوي ببياناتك المسجلة…”

### User rejection
If the user says the inference is wrong:
- set `user_validation = no`;
- set status to `user_rejected`;
- stop using it for routing until new independent evidence triggers a fresh candidate review.

### Time decay
Patterns are not permanent labels.
- If not observed for 90 days, mark `dormant` unless the user has an active journey explicitly linked to it.
- Dormant patterns may inform history but cannot dominate current routing.
- A renewed event may reactivate the pattern after re-evaluation.

## 13. Formulation Model

### 13.1 `malaak_formulations`

Each user may have one active formulation plus prior versions.

Fields:
- `id uuid`
- `user_id uuid`
- `version integer`
- `status text` — `active | archived`
- `primary_context text null`
- `current_state_summary text`
- `vulnerability_factors jsonb`
- `trigger_patterns jsonb`
- `interpretation_patterns jsonb`
- `emotion_patterns jsonb`
- `need_patterns jsonb`
- `behavior_patterns jsonb`
- `short_term_consequences jsonb`
- `long_term_consequences jsonb`
- `protective_factors jsonb`
- `current_goals jsonb`
- `validated_insights jsonb`
- `unknowns jsonb`
- `created_at timestamptz`
- `updated_at timestamptz`

### 13.2 Formulation structure

Working formulation follows:

`Vulnerability/Context -> Trigger -> Interpretation -> Emotion/Body -> Need/Urge -> Behavior -> Short-term consequence -> Longer-term consequence -> Alternative skill/action`

It must include `unknowns` so the system can explicitly represent uncertainty instead of inventing an explanation.

## 14. Formulation Update Pipeline

1. User generates a permitted event/message.
2. Safety gate runs first.
3. Model may extract a candidate observation into a strict schema.
4. Server validates fields and strips unsupported claims.
5. Observation is stored as `model_extracted` unless user entered structured fields directly.
6. Pattern engine compares the observation to existing hypotheses.
7. Deterministic evidence rules update counts/status.
8. Material formulation changes create a new formulation version.
9. Malaak may ask the user to validate a meaningful repeated pattern at a calm moment.
10. Journey Planner consumes the active formulation plus user goals and recent functioning.

The model cannot write directly to `malaak_hypotheses.status = repeated` or `user_validated`.

## 15. Functional Impact & Stepped-Care Boundary

V5 uses a simple non-diagnostic `current_impact` signal:
- `low` — distress present, daily functioning largely intact;
- `moderate` — meaningful interference in sleep/work/relationships/routine;
- `high` — substantial impairment, repeated loss of control, inability to maintain basic functioning, or symptoms beyond safe self-help.

Rules:
- `high` impact does not equal diagnosis.
- High impact increases recommendation for human/professional assessment and prevents the app from escalating to deeper self-help work merely because more content is available.
- Current safety risk always overrides impact tier.

This mirrors stepped-care principles: use the least intrusive effective support, monitor outcomes, and step up when impairment or non-response warrants it.

## 16. V5C — Journey Planner

### 16.1 Output model

At any time, the plan contains:
- exactly `0..1 Primary Path`;
- exactly `0..1 Support Path`;
- `0..2 Monitor` domains;
- any number of `Later` domains, but only the top few are displayed to the user.

### 16.2 `malaak_journey_plan`

Fields:
- `id uuid`
- `user_id uuid`
- `version integer`
- `primary_domain text null`
- `primary_goal text null`
- `support_domain text null`
- `support_goal text null`
- `monitor_domains text[]`
- `later_domains text[]`
- `reasoning_summary_ar text`
- `based_on_formulation_version integer`
- `review_due_at timestamptz`
- `status text` — `active | maintenance | paused`
- `created_at timestamptz`
- `updated_at timestamptz`

## 17. Journey Priority Rules

Priority is rule-based, not a single opaque “mental health score.”

### Tier 0 — Safety
Current violence, self-harm/harm risk, coercion, stalking, or severe loss of control routes out of ordinary journey planning.

### Tier 1 — Regulation readiness
If the user is repeatedly highly activated or functioning is substantially impaired, prioritize stabilization/regulation and do not open deep childhood/healing work.

### Tier 2 — User goal + repeated current-life impact
Choose the domain most directly linked to:
- the user’s stated goal;
- repeated observations;
- meaningful current-life consequences.

### Tier 3 — Maintaining mechanism
Choose one support path that is maintaining the primary difficulty.

Example:
- Primary: `attachment`
- Support: `overthinking`

### Tier 4 — Deeper historical themes
Childhood/healing domains can become primary only when:
- safety is adequate;
- user explicitly wants to work there;
- current regulation capacity is adequate;
- the app is using safe present-focused exercises only.

Otherwise they stay `Later` or `Monitor`.

## 18. Planner Examples

### Example A — apparent overthinking, relationship-triggered
Data:
- repeated worry begins after partner distance;
- checking/reassurance behavior repeated;
- user goal is a calmer marriage.

Plan:
- Primary: `attachment`
- Support: `overthinking`
- Monitor: `relationship`
- Later: `childhood`

### Example B — anger with sleep/overload vulnerability
Data:
- anger escalations cluster after severe overload/poor sleep;
- no violence risk;
- user recognizes need for rest but requests it only after exploding.

Plan:
- Primary: `anger`
- Support: `inner-peace` or `needs`, based on current observations
- Monitor: `relationship`

### Example C — current unsafe relationship
Data:
- partner prevents leaving or makes credible threats.

Plan:
- Ordinary Journey Planner suspended.
- Safety flow and human/local support guidance take priority.
- No couple communication exercise is offered as the solution.

## 19. Journey Review & Progress

Journey promotion is not based on content completion.

Review evidence types:
1. **Awareness** — recognizes the pattern/skill.
2. **Assisted skill** — can use it with Malaak.
3. **Independent behavior** — uses it without step-by-step help.
4. **Stability under pressure** — repeats it in real-life activation.

User-facing progression language remains:
- `أفهمها`
- `أتمرن عليها`
- `أطبقها`
- `أثبتها تحت الضغط`
- `صارت أقرب لطبيعتي`

A difficult week triggers `Support Mode`, not demotion or “failure.”

## 20. Non-Response Rule

If an intervention or journey target shows no meaningful benefit after repeated attempts:
- do not continue recommending the same card merely because it has a high evidence tier;
- inspect adherence/context/fit;
- try an eligible fallback;
- reassess formulation;
- if impact remains high or worsens, encourage appropriate human/professional support.

V5 must be able to say: “الخطة الحالية ما عم تعطينا النتيجة المطلوبة.”

## 21. Privacy & Consent

### 21.1 Data classes

Users can control at least:
- transcript storage;
- memory storage;
- pattern analysis;
- journal analysis;
- cloud sync.

### 21.2 Journal rule

Journal entries have three modes:
- `private` — never analyzed or sent to AI;
- `malaak_allowed` — may inform immediate Malaak response/memory according to settings;
- `reports_allowed` — may also contribute structured observations to reports/formulation.

### 21.3 “What Malaak knows about me”

The existing memory screen must later show:
- facts;
- goals;
- preferences;
- repeated patterns;
- hypotheses.

The user can correct/delete/reject any hypothesis. Rejecting a hypothesis must affect routing, not just hide a UI card.

## 22. Supabase Security & Data Integrity

All new user-data tables have RLS enabled and anon receives no user-data access. However, V5 does **not** give the Flutter client arbitrary write access to engine-owned psychological metadata.

### Client-writable/user-owned data
Where direct writes are genuinely needed, ownership is enforced with `(select auth.uid()) = user_id`. User-created observations/check-ins may be submitted through a narrow RPC that always derives `user_id` from the JWT rather than trusting a client-supplied user ID.

### Server-managed data
The following are read-only to ordinary clients and are mutated through validated RPC/Edge Function paths:
- hypothesis support counts/status/confidence;
- formulation versions;
- Journey Planner priority/status;
- intervention catalog status/version/evidence/licensing fields.

User correction/rejection of a hypothesis is submitted through a dedicated RPC that can change only the user-feedback fields; it cannot directly modify support counts or promote the hypothesis.

### Catalog access
The non-sensitive active catalog may expose read-only `SELECT` access when useful, but the mobile app is not trusted to determine eligibility. No client write access is granted. Catalog mutations remain outside the mobile app.

### Secrets
- no service-role secret in Flutter;
- no OpenAI secret in Flutter;
- server secrets remain in Supabase Edge Function secret storage;
- Edge Function remains JWT-protected.

## 23. Flutter Changes

V5 preserves the approved Figma style, bottom navigation, and Home-centered architecture.

### 23.1 Onboarding

Add a short progressive onboarding flow only for users without an `initial_map`.

Screens use existing design tokens/cards:
1. “شو أكتر شي تعبك هالفترة؟”
2. context / what happens in real life;
3. current impact;
4. desired change;
5. coaching style + privacy choices;
6. initial map result.

Safety questions are context-sensitive and do not become a dramatic 20-question screen for every user.

### 23.2 Initial map UI

Show at most:
- 2–3 linked observations;
- one suggested starting focus;
- uncertainty language;
- CTA: `ابدأ رحلتي`.

Never show percentages.

### 23.3 Journey screen

Existing Journey screen receives real planner data:
- Primary Path;
- Support Path;
- Maintenance/Monitor;
- Later.

### 23.4 Malaak chat

Chat remains visually unchanged except for existing `خطوتك الآن`/follow-up behavior. It gains context from formulation and catalog eligibility behind the scenes.

## 24. Local/Offline Behavior

Flutter keeps a local snapshot of:
- initial map;
- active journey plan;
- latest formulation summary safe for local display;
- recent observations needed for offline continuity;
- pending follow-ups.

When offline:
- no new cloud-only scientific card is invented;
- use the embedded low-risk fallback set;
- mark new observations pending sync;
- reconcile by immutable observation IDs rather than “last write wins” on event history.

## 25. Error Handling

### Catalog unavailable
Use embedded safe fallback cards only; do not show stale retired cards if server explicitly marks them prohibited when connectivity returns.

### Structured extraction failure
Store the user’s ordinary message/transcript as allowed, but do not fabricate an observation.

### Contradictory observations
Keep both; lower confidence or leave hypothesis candidate. Do not force a single narrative.

### User rejects pattern
Stop using it for routing until fresh evidence and user review.

### OpenAI unavailable
Use deterministic routing + eligible fallback where possible. No fake “AI insight.”

### Formulation unavailable
Journey continues from last safe plan; no automatic deep-work promotion.

## 26. Scientific Source Registry for V5 Design

These sources govern the design boundary; individual cards must additionally have card-level sources in `malaak_intervention_sources`.

1. World Health Organization. *Psychological self-help interventions: delivering self-help for individuals, featuring Step-by-Step and Doing What Matters in Times of Stress*. 2026. https://www.who.int/publications/i/item/9789240120785 — supports structured psychological self-help and guided/unguided delivery; commercial-use licensing must be reviewed separately.
2. World Health Organization. *Doing What Matters in Times of Stress*. https://www.who.int/publications-detail-redirect/9789240003927 — supports low-intensity skills such as grounding, unhooking from difficult thoughts, making room for emotions, values-based action, and self-kindness. Do not copy scripts without licensing review.
3. NICE CG113. *Generalised anxiety disorder and panic disorder in adults: management*. https://www.nice.org.uk/guidance/cg113/chapter/Recommendations — supports stepped care, CBT-based self-help, routine outcome monitoring, and stepping up with marked impairment/non-response.
4. NICE CG31. *Obsessive-compulsive disorder and body dysmorphic disorder: treatment*. https://www.nice.org.uk/guidance/cg31/chapter/Recommendations — supports CBT/ERP as a clinical treatment pathway and reinforces that such interventions require appropriate training/supervision; Malaak V5 does not implement an OCD ERP treatment protocol.
5. American Psychological Association. *Clinical Practice Guideline for the Treatment of PTSD in Adults*. 2025. https://www.apa.org/ptsd-guideline — used to draw the boundary between low-risk self-help and specialized trauma treatment.
6. APA. *Guidelines on Key Considerations for Working With Adults With PTSD and Traumatic Stress Disorders*. https://www.apa.org/about/policy/adults-ptsd-traumatic-stress-guidelines — supports contextual, trauma-aware practice and caution around trauma-related presentations.
7. SAMHSA. *Trauma-Informed Approaches and Programs*. https://www.samhsa.gov/mental-health/trauma-violence/trauma-informed-approaches-programs — used for safety, trust/transparency, choice, collaboration, empowerment, and avoiding re-traumatization.

## 27. Implementation Sequence

Implementation is intentionally split to reduce risk:

### V5A
- create catalog/source schema;
- seed 48 candidates with evidence/licensing metadata;
- replace hardcoded normal routing with catalog-backed eligibility;
- keep embedded fallback set;
- add catalog validation tests.

### V5B
- add onboarding initial-map model;
- add observations/hypotheses/formulations tables;
- add strict extraction contract;
- add deterministic evidence-status engine;
- add correction/rejection behavior;
- add formulation versioning.

### V5C
- add Journey Planner tables/rules;
- feed planner from active formulation + goals + impact;
- connect planner to existing Journey/Home UI;
- add review/support-mode behavior.

No phase may weaken V4 safety behavior.

## 28. Testing Strategy

### 28.1 Server unit tests

Required scenarios include:
- safety always overrides catalog routing;
- paused/retired/prohibited card never becomes eligible;
- high activation excludes reflective/deep cards;
- interpersonal danger excludes direct-confrontation cards;
- model cannot select a code absent from eligible candidates;
- missing catalog falls back only to embedded safe cards;
- private journal cannot create an observation;
- one event creates only candidate/low hypothesis;
- repeated events across days can create repeated/medium status;
- user rejection disables pattern routing;
- dormant pattern does not dominate current journey;
- planner outputs at most one Primary and one Support;
- high activation blocks childhood/healing as automatic Primary;
- non-response triggers reassessment/step-up logic rather than infinite repetition.

### 28.2 Database tests

Verify:
- RLS isolation between two test users;
- anon cannot access user tables;
- client cannot mutate intervention catalog;
- observation IDs are immutable/unique;
- formulation versions are append-only except active/archive status;
- deleted/rejected user insights stop appearing in planner input.

### 28.3 Flutter tests

Verify:
- onboarding only appears when required;
- initial map shows uncertainty language and no percentages;
- private journal setting prevents analysis flag;
- user can reject/correct a hypothesis;
- Journey UI renders Primary/Support/Monitor/Later correctly;
- pending follow-up still works after V5 state changes;
- app remains usable offline with safe fallback behavior.

### 28.4 Manual release scenarios

At minimum test Arabic scenarios for:
- “ماني فاهمة شو فيني”;
- partner delayed response + repeated checking;
- anger 9/10 without immediate violence threat;
- explicit violence/self-harm threat;
- “طفولتي مأثرة علي” with no known trauma details;
- current partner coercion/unsafe relationship;
- repeated rumination asking the same reassurance question;
- user says Malaak’s pattern interpretation is wrong;
- user is stable and asks for growth rather than healing.

## 29. Release Gates

V5 cannot be called production-ready until all are true:
- Flutter SDK tests/analyze/build run successfully in a real Flutter/Android environment;
- Supabase migrations are verified with RLS/security advisor review;
- Edge Function unit tests pass;
- intervention catalog contains no `review_required` or `restricted` card marked active;
- each active A/B/C card has at least one reviewed scientific source record;
- all D cards are explicitly coaching-only;
- X cards cannot be selected by code path or model;
- no OpenAI/service-role secret exists in Flutter or release ZIP;
- manual Arabic safety scenarios pass.

## 30. Success Criteria

V5 succeeds when a user can enter with a vague real-life problem, receive a safe and bounded first intervention, accumulate structured real-life observations over time, see hypotheses remain tentative until repeated/confirmed, and receive a simple journey plan that focuses on the most useful current target instead of presenting eleven unrelated problems.

The experience should still feel like one warm mobile coach. The scientific catalog, evidence registry, formulation engine, and planner complexity stay under the surface.
