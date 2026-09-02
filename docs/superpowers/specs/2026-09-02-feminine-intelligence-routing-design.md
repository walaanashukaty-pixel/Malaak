# Feminine Intelligence Routing Design

## Goal
Replace the current static `feminine-intelligence` journey detail with a guided, interactive learning system that first maps the user's current behavioral starting point, then routes her into a relevant development path toward feminine intelligence.

## Product model
The four podcast labels are learning states, not personality diagnoses or mandatory sequential levels. The destination is feminine intelligence. The first trial release implements:

- Start Map assessment.
- Route: `feminine-naivety` → feminine intelligence.
- Route: `masculine-rigidity` → feminine intelligence.
- Advanced result for users who already show stronger practical/feminine skills, with a small Situation Lab rather than forcing them through an irrelevant route.

The app must never state that a user "is" a label. UI copy uses phrases such as "نقطة بدايتك أقرب إلى..." and keeps results contextual and non-diagnostic.

## Start Map
The assessment uses scenario questions rather than direct trait questions. Each answer contributes hidden weights to four dimensions:

- `peoplePleasing`: self-abandonment / approval seeking / weak boundaries.
- `controlRigidity`: urgency / control / black-and-white thinking / criticism / over-responsibility.
- `practicalIntelligence`: pausing / prioritizing / information gathering / emotion regulation.
- `relationalWisdom`: timing / distance / emotional perspective / intention / flexible negotiation.

Routing rules:

1. High `peoplePleasing` relative to `controlRigidity` → `feminine-naivety` route.
2. High `controlRigidity` relative to `peoplePleasing` → `masculine-rigidity` route.
3. Otherwise, if practical/relational scores are stronger, show an advanced result and unlock a compact Situation Lab rather than inventing a deficit.

The assessment is a learning router, not a validated psychometric instrument.

## Route 1: Feminine naivety → feminine intelligence
Modules:

1. Where am I leaving myself?
2. Is this actually my responsibility?
3. Say no without self-rejection.
4. If they are upset, does that mean I am wrong?
5. What is my priority?
6. Internal evidence of self-respect.
7. Bridge: timing + distance + feelings + intention.

Each module contains a short insight, one scenario/choice or reflection exercise, a practical action, and a completion state.

## Route 2: Masculine rigidity → feminine intelligence
Modules:

1. Does this really have to happen now?
2. "Who said?" cognitive-flexibility exercise.
3. The goal or my method?
4. Delegate without micromanaging.
5. Help or criticism?
6. Win the argument or protect the goal?
7. I do not need to carry everything.
8. Let people have a role.
9. Bridge: timing + distance + feelings + intention.

## Advanced Situation Lab
For users who do not clearly match the first two routes, show a positive result: they already have stronger regulation/decision foundations. Unlock a compact reusable situation flow:

1. What happened?
2. What am I feeling?
3. Is now the right time?
4. What might the other person be feeling, and what evidence do I have?
5. What is my intention?
6. What action best protects both my boundary and the goal?

This is not open-ended therapy chat. It is structured practice.

## AI role in this release
The trial release keeps routing and lesson logic deterministic so the user can test the methodology reliably. Free-text reflections are stored. AI must not diagnose, change the route, or invent new psychological concepts. Future AI personalization can ask one follow-up, tailor examples, summarize a reflection, or select a vetted next exercise.

## Persistence
Learning progress must persist locally and for authenticated Supabase users. Use a dedicated `malaak_learning_states` table so the existing `malaak_sync_state` RPC does not overwrite or drop the new learning data.

One row per `(user_id, domain_id)` stores a JSONB state including assessment answers/scores, selected route, completed lessons, reflection notes and last update.

## UI constraints
- Preserve current Malaak visual identity: cream background, lavender/rose/gold palette, rounded premium cards, soft shadows, Arabic RTL copy and calm spacing.
- No redesign of app shell/navigation.
- `feminine-intelligence` opens the new interactive experience; other journey domains keep their existing detail screen.
- Mobile-safe scrolling and keyboard insets are required.

## Safety/content constraints
- Labels are educational frames from the podcast, not diagnoses.
- Do not claim podcast terminology is clinically validated.
- Do not present relationship separation, financial concessions or other high-impact life decisions as general prescriptions.
- Exercises should train boundaries, flexibility, timing, emotional awareness and decision quality without pretending to treat mental illness.

## Trial success criteria
- Start Map can be completed end-to-end.
- User is routed to an appropriate implemented path or advanced lab.
- Both first two routes are navigable and progress is saved.
- Leaving and reopening the section restores progress.
- Authenticated users persist learning state to Supabase.
- Existing app design and other journey domains remain intact.
