# Feminine Intelligence Conversational Training Design

## Goal
Transform the existing V6.6 feminine-intelligence feature from a short questionnaire plus one-click lesson completion into a conversational coaching journey that feels like a real guided session, preserves user agency, and measures practice and real-life application instead of button taps.

## Approved product behavior

### Assessment
- The starting map is presented as a conversation with Malaak, not a form or exam.
- Choosing an option never auto-advances.
- The user explicitly taps **التالي** to continue and can tap **السابق** to revisit and change any prior answer.
- Each selected answer appears as the user's chat bubble. Malaak may respond with a short, non-diagnostic coaching reflection before the user continues.
- Progress is shown softly as a percentage, not as a harsh exam counter.

### Result and route choice
- The result always displays all four educational models:
  1. Feminine naivety / self-abandonment.
  2. Masculine rigidity / control overdrive.
  3. Masculine intelligence / practical decision strength.
  4. Feminine intelligence / relational wisdom.
- Malaak recommends the closest starting model based on answers, but never declares it as identity or diagnosis.
- The user can choose any of the four routes, including a route different from the recommendation.
- Mixed answers are valid. The recommendation is only a starting suggestion; no result says the user "needs nothing".
- If feminine intelligence is already strongest, the route becomes an advanced deepening journey plus situation lab rather than ending the experience.

### Training journey
- A lesson is a conversational training session, not a content card plus "completed" button.
- Each session contains multiple interactions: discovery, reflection, a simulated scenario, feedback/retry, a personal response, a real-life mission, and later follow-up.
- A session is not counted as mastered merely because it was opened or read.
- After in-app practice, the lesson enters a **real-life mission pending** state.
- On the next visit, Malaak asks what happened in real life. The response records whether the skill was attempted, difficult, missed, or applied.
- Route progress shows meaningful indicators such as sessions practiced, real-life applications, and current skill status.
- Lesson status labels distinguish not started, in practice, mission pending, and applied in real life.

### Coaching boundaries
- Malaak speaks warmly and conversationally but does not diagnose, label personality, or invent causal psychological explanations.
- Podcast terminology remains an educational framing, not a scientific diagnosis.
- The app may reflect patterns in the user's answers but must phrase them as current tendencies or a recommended starting point.

### Existing app constraints
- Preserve the current premium visual DNA: soft cards, rounded corners, typography, spacing, palette, and RTL layout.
- Keep every other Malaak domain intact; only the feminine-intelligence domain is upgraded in this iteration.
- Preserve current Supabase project binding and Auth behavior.
- Reuse the existing `malaak_learning_states` JSON-backed persistence; no new database table is required for the richer lesson progress fields.
- Preserve backward compatibility with existing V6.6 saved learning state where practical.

## Architecture
- Extend `LearningJourneyState` with `recommendedRouteId` and per-lesson progress records.
- Extend feminine-intelligence models with model descriptors, coach replies, scenarios, scenario feedback, and route/session metadata.
- Replace the V6.6 scorer's `advanced` terminal route with four-route recommendation logic.
- Add a result/route-selection screen that shows all four models and stores the user's chosen route separately from Malaak's recommendation.
- Rewrite the assessment screen as a chat-style stepper with explicit previous/next controls.
- Rewrite the lesson screen as a multi-step coaching conversation and follow-up flow.
- Rewrite route progress UI around practice/application status, while continuing to use the existing lesson catalog and situation lab.

## Acceptance criteria
1. Answer selection never changes the assessment index automatically.
2. The user can go backward and edit an answer before submitting the assessment.
3. All four models are shown after assessment, with exactly one recommendation highlighted.
4. The user can choose any model and start that route.
5. No `advanced` route is used as a no-problem terminal state.
6. Every route is functional, including masculine-intelligence and feminine-intelligence routes.
7. A lesson requires several interactions before a real-life mission is assigned.
8. Finishing the in-app session does not immediately mark real-life mastery.
9. Returning to a pending lesson triggers a follow-up question about the real-life mission.
10. Route progress distinguishes practice from real-life application.
11. Existing Auth, Supabase binding, Android release safeguards, and other app sections remain unchanged.
