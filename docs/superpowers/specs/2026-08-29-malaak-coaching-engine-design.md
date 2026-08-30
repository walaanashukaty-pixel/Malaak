# Malaak Coaching Engine V4 Design

Date: 2026-08-29

## Goal

Turn Malaak from a general conversational AI gateway into a constrained behavioral coaching orchestration system that follows the approved loop:

`SAFE -> STATE -> NEED -> PATTERN -> GOAL -> TOOL -> ACTION -> FOLLOW-UP`

The system must remain a coaching/self-help product, not a diagnostic or autonomous therapy system.

## Chosen Approach

Use a **hybrid rules-first architecture**.

1. Deterministic server code owns immediate safety routing, coarse state classification, candidate intervention eligibility, and hard exclusions.
2. A curated intervention library defines the only behavioral tools Malaak may recommend.
3. The OpenAI model personalizes wording and selects among eligible candidates using Structured Outputs with a strict JSON schema.
4. The server validates every returned intervention code and falls back to a deterministic safe response if validation fails.
5. Flutter receives a typed `CoachingTurn` instead of only free-form text and stores the action/follow-up as part of app state.

This is preferred over:
- **Prompt-only AI:** too unconstrained and hard to audit.
- **Fully deterministic rules:** safe but too rigid for nuanced Arabic coaching conversations.

## Scope for V4

V4 adds the orchestration foundation, not every future clinical/coaching skill.

### Initial intervention library

The first release contains a small, auditable library covering common flows:

- `REG_GROUND_001` — sensory grounding for high activation.
- `REG_MOVE_002` — short movement/reset when movement is appropriate.
- `ANGER_TIMEOUT_001` — non-punitive time-out with explicit return plan.
- `THOUGHT_FACTS_001` — separate event/facts from interpretation.
- `RUMINATION_EXIT_001` — stop circular analysis and return attention to action/life.
- `UNCERTAINTY_001` — tolerate uncertainty without repeated reassurance/checking.
- `NEED_NAME_001` — identify the need beneath distress without assuming another person must satisfy it.
- `REQUEST_DIRECT_001` — turn need into a concrete, non-blaming request.
- `BOUNDARY_001` — concise boundary and tolerate discomfort/disapproval.
- `PROBLEM_SOLVE_001` — define a solvable problem and one next step.

Each card includes framework, target, eligible states/patterns, exclusions, duration, evidence tier, coaching steps, action template, and fallback.

## Safety Architecture

Safety remains independent from the language model.

The Edge Function evaluates immediate-risk patterns before calling OpenAI. Safety mode must never expose ordinary coaching tools. It returns:

- `mode = safety`
- safety-oriented reply
- no intervention code
- immediate action focused on physical safety/human support
- follow-up question limited to current safety

V4 keeps this as a conservative first-pass safety layer. It is not a diagnosis system and does not claim exhaustive detection.

## Routing Model

### 1. SAFE

Immediate risk overrides all normal coaching.

### 2. STATE

The router estimates a broad current state from the message and allowed context:

- `high_activation`
- `moderate_activation`
- `reflective`
- `unknown`

High activation limits candidate tools to regulation/safety-compatible interventions.

### 3. NEED

Use broad non-diagnostic categories:

- safety
- regulation
- understanding
- connection
- rest
- respect
- autonomy
- clarity
- decision
- boundary
- support
- unknown

### 4. PATTERN

Patterns are hypotheses, never diagnoses:

- attachment_alarm
- reassurance_loop
- rumination
- anger_escalation
- people_pleasing
- control_overdrive
- thought_fusion
- unmet_need
- conflict_cycle
- practical_problem
- unknown

Known user patterns may raise confidence but may not be treated as facts.

### 5. GOAL

Every coaching turn has one small goal, for example:
- lower activation enough to avoid impulsive action
- distinguish facts from fear
- identify one real need
- prepare one direct request
- stop repetitive checking for one interval

### 6. TOOL

Only candidate intervention cards that pass eligibility/exclusion rules are sent to the model.

### 7. ACTION

One realistic action is returned. A second action is allowed only when necessary for safety or completion of the first.

### 8. FOLLOW-UP

A structured follow-up is returned with:
- prompt
- timing class: `later_today`, `tomorrow`, `after_event`, `none`
- related journey domain when known

V4 stores the follow-up locally/cloud as part of `AppStateData`. Automatic OS notification scheduling is out of scope for this version.

## OpenAI Contract

Use the Responses API with `gpt-5.6-luna` by default for cost-sensitive volume. The Responses API supports Structured Outputs through `text.format` with `type: json_schema`; strict schema adherence is enabled.

The model receives:
- the user message
- allowed context from Flutter
- a compact routing summary
- only eligible intervention cards
- coaching style and safety constraints

The model returns strict JSON:

```json
{
  "mode": "coach",
  "state": "moderate_activation",
  "need": "connection",
  "pattern": "attachment_alarm",
  "patternConfidence": "medium",
  "goal": "خفض الخوف قبل طلب الطمأنة",
  "interventionCode": "UNCERTAINTY_001",
  "reply": "...",
  "action": "...",
  "followUp": {
    "timing": "later_today",
    "prompt": "شو صار بعد ما جربتي تنتظري بدون فحص متكرر؟",
    "journeyDomainId": "attachment"
  }
}
```

Server validation rejects unknown intervention codes and invalid mode/tool combinations.

## Flutter Data Model

Add:

### `CoachingTurn`
- `id`
- `createdAt`
- `mode`
- `state`
- `need`
- `pattern`
- `patternConfidence`
- `goal`
- `interventionCode`
- `action`
- `followUp`

### `CoachingFollowUp`
- `timing`
- `prompt`
- `journeyDomainId`
- `createdAt`
- `completedAt` nullable

`AppStateData` gains:
- `coachingTurns`
- `pendingFollowUps`

Existing `MalaakMessage` remains the display transcript so the current UI does not need a redesign.

## Flutter UX Changes

Keep the approved Figma/mobile visual system.

### Malaak screen
After an assistant response, show at most one subtle coaching card when structured metadata exists:

- small label: `خطوتك الآن`
- action text
- optional tool label in user-friendly Arabic

Do not show technical intervention codes.

### Home
If a pending follow-up exists, surface the existing "ملاك عم تستنى تعرف شو صار" concept from real stored data rather than mock content.

### Journey progress
When a follow-up is completed successfully, V4 may mark a real-life practice event, but automatic promotion between journey stages remains out of scope.

## Persistence and Supabase

Extend the existing state-sync mechanism rather than adding an unrelated API.

Add tables:
- `malaak_coaching_turns`
- `malaak_followups`

Both use `user_id`, RLS, least-privilege grants, and are included in `malaak_get_state()` / `malaak_sync_state()`.

No OpenAI key, service-role key, or private server secret may be stored in Flutter.

## Error Handling

- No authenticated user: retain local demo fallback.
- Edge Function unavailable: deterministic local fallback reply; no fake structured metadata.
- OpenAI key missing: configuration response and local fallback.
- OpenAI/structured-output failure: server deterministic fallback from the highest-ranked eligible intervention.
- Unknown intervention code from model: ignore it and use the server-selected fallback candidate.
- Empty/invalid response: safe generic supportive response with no fabricated pattern.

## Testing

### Dart unit/widget tests
- parse valid/partial coaching turns safely
- controller stores coaching metadata and follow-up
- pending follow-up appears on Home
- completing follow-up persists state
- message transcript behavior remains intact

### Edge Function tests (Deno-compatible pure modules)
- immediate-risk message routes to safety without intervention candidates
- high activation excludes reflective/deep tools
- attachment/reassurance language yields uncertainty/regulation candidates
- anger escalation yields regulation/time-out candidates
- unknown intervention returned by AI is rejected
- deterministic fallback always selects from approved library

### Verification
- `flutter test`
- `flutter analyze`
- Edge pure-module tests / syntax checks
- Supabase RLS advisors after migration

## Non-Goals

V4 does not:
- diagnose PTSD, OCD, attachment disorders, or any mental illness
- perform exposure therapy, EMDR, trauma memory processing, or memory recovery
- generate arbitrary therapy exercises
- automatically schedule Android notifications
- implement clinician dashboards
- implement Couples Mode
- claim that routing hypotheses are psychological facts

## Acceptance Criteria

V4 is accepted when:
1. Ordinary Malaak turns return typed structured coaching data.
2. Safety turns bypass normal intervention selection.
3. Every recommended intervention exists in the curated library.
4. One concrete action can be stored and displayed.
5. Follow-up data survives app restart and Supabase sync.
6. Home can surface a real pending follow-up.
7. Existing 11 journeys, 9 quick tools, 4 bottom tabs, RTL styling, and no-sidebar architecture remain unchanged.
