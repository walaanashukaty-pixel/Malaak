# Malaak Skill Tree & Retention Design

## Status
Approved product direction for the next Malaak iteration.

## Goal
Turn Malaak from a set of short, mostly open lessons into a long-lived personal-development product where users move through one active journey at a time, unlock skills through real practice, return for follow-up, and continue into new journeys instead of finishing the app.

## Product principles
1. The app must feel like a real coach, not a quiz or button sequence.
2. Progress is earned through demonstrated practice, not by opening screens.
3. The user sees the wider Malaak world, but does not get every lesson or journey unlocked at once.
4. A user always has a meaningful next step after completing a lesson or journey.
5. The AI personalizes questions, feedback, examples, and follow-up inside an approved curriculum; it does not invent diagnoses or replace the curriculum.
6. The existing soft premium visual identity remains unchanged.
7. The four feminine-intelligence models are an educational framework, not a clinical diagnosis.

## Global app structure
The home experience should show the user's active journey first, then the wider life map.

### Active journey
Display:
- journey title
- current chapter/skill
- current step
- earned skills
- real-life applications
- open follow-up count
- next unlock condition

Only one primary journey is active at a time. The user may change the active journey from journey settings, but the app recommends a next journey based on progress.

### Life map
Show all Malaak domains grouped into understandable families, for example:
- أنا مع نفسي: السلام الداخلي، الاحتياجات، التشافي
- أنا مع الآخرين: العلاقة الزوجية، الحدود، التعلق
- أنا تحت الضغط: الغضب، التفكير الزائد، القرار
- ذكائي واتزاني: الذكاء الأنثوي، اتزان الأنوثة

Locked journeys remain visible with a lock icon and a short value proposition. Tapping a locked journey explains what it develops and how it can be unlocked. No dead-end or hidden catalog.

## Feminine-intelligence entry flow
The existing conversational assessment remains the entry point for this domain.

Flow:
1. Malaak asks situational questions in chat form.
2. Selecting an answer does not auto-advance.
3. User explicitly taps التالي; from question 2 onward السابق is available.
4. Previous answers can be edited before the result.
5. The result screen displays all four models:
   - السذاجة الأنثوية
   - التعصب الذكوري
   - الذكاء الذكوري
   - الذكاء الأنثوي
6. Malaak marks one model as the recommended starting point, but the user can choose any model.
7. Mixed results may show two close models while still recommending one starting point.
8. If feminine intelligence is already the strongest result, the app opens an advanced/deepening route rather than saying the user needs nothing.

## Skill-tree journey model
A route is not a flat list of lessons. It is a chapter-and-skill tree.

Example: التعصب الذكوري → الذكاء الأنثوي
1. أشوف نمطي
2. الاستعجال والسيطرة
3. التفكير المرن / مين قال؟
4. التفويض والثقة
5. النقد والتقدير
6. الوقت والمسافة
7. المشاعر والنية
8. الاختبار الواقعي
9. advanced practice / maintenance

Each chapter may contain multiple coaching sessions, simulations, reflections, and real-life missions.

### Lock states
Every node has one state:
- locked
- available
- in_progress
- mission_pending
- followup_ready
- mastered

Only the current available node and optional practice content are actionable. Future nodes remain visible but locked.

## Session experience
A training session should generally take about 10–15 minutes and include 5–8 meaningful interactions.

Typical session flow:
1. Coach framing message
2. Personal situation or choice
3. User response
4. Malaak reflection or one follow-up question
5. Scenario/simulation
6. Feedback based on the chosen response
7. Retry when the skill was not demonstrated
8. User reflection in their own words
9. Real-life mission

The user should not be able to finish a skill merely by tapping a completion button.

## Competency and mastery
A skill can require evidence across several dimensions:
- understanding the concept
- choosing a skillful response in simulation
- explaining the skill in the user's own words
- completing at least one real-life application
- returning for a follow-up

Critical skills may require two successful real-life applications before advanced content unlocks.

## Hybrid unlock timing
Malaak uses a hybrid progression system.

### Immediately after a session
Unlock one lightweight continuation so the app never feels blocked:
- a short scenario
- a reflection prompt
- a mini practice
- Situation Lab
- a relevant journal prompt

### Main next node
The next main chapter/skill stays locked until the mission is followed up.

Default timing:
- follow-up becomes ready after approximately 12–24 hours
- the UI shows when the follow-up will be ready
- the app must not require an exact 24-hour wait if the product later decides on a shorter threshold; use a configurable unlock window

### No opportunity handling
If the user reports "ما إجتني فرصة":
- do not punish or reset progress
- offer a strong simulation as substitute evidence
- after successful simulation, allow progression

If the user reports "نسيت" or "رجعت لطريقتي القديمة":
- provide a short repair/retry step
- keep the next main node locked until retry or substitute simulation is completed

## Return loop
The primary retention loop is:

learn → practice → real-life mission → wait/live life → return → follow-up → unlock → next skill

Malaak should remember recurring language/patterns and reuse them later, e.g. noticing repeated words such as "لازم" and suggesting the previously learned "مين قال؟" exercise.

## Journey completion
Completing a base route does not finish the product.

On route completion, unlock:
- advanced route for the same domain
- Situation Lab for ongoing real events
- maintenance check-ins
- monthly challenge
- recommended next journey/domain

Do not claim a user is "100%" a model or permanently transformed. Show behavior-based progress and evidence instead.

## Subscription value
Premium value comes from ongoing personalized development, not artificial blocking.

Premium can include:
- full skill tree
- AI-personalized coaching inside sessions
- Situation Lab
- follow-ups and history
- monthly compass/check-ins
- advanced routes
- additional domains/journeys
- progress analytics and behavior history

Free experience should provide enough value to establish trust: assessment, result, and a limited first coaching experience.

## Data model changes
Extend the learning state so progression is represented explicitly instead of inferred from whether a lesson was opened.

Suggested entities/fields:

### LearningJourneyState
- active route
- recommended route
- assessment answers/scores
- active chapter id
- active node id
- unlocked node ids
- mastered node ids
- route completion state
- next recommended journey

### LearningNodeProgress
- node id
- status
- session step
- attempts
- simulation results
- reflections
- mission text
- mission assigned at
- follow-up available at
- follow-up completed at
- real-life application count
- latest outcome
- mastery evidence

### LearningUnlockPolicy
- prerequisite node ids
- minimum simulation skill level
- required real-life applications
- follow-up delay
- whether substitute simulation is allowed

Persist the same state to Supabase under the authenticated user with RLS. Local persistence can remain as resilience/cache, but Supabase is the durable source for signed-in progress.

## AI boundaries
AI may:
- ask one deeper question based on the user's answer
- personalize wording and examples
- summarize patterns already evidenced by responses
- provide feedback against the current skill rubric
- choose from approved follow-up exercises
- reference the user's previous applications when useful

AI may not:
- diagnose a disorder or fixed personality type
- invent unsupported psychological causes
- freely change curriculum goals
- declare that the user has no need for development
- mark mastery without required evidence

## UI behavior
Preserve the current Malaak visual DNA: premium soft cards, gradients, rounded shapes, calm feminine palette, spacing, typography, and RTL behavior.

New visual elements:
- skill-tree/roadmap cards with locks
- clear current-step highlight
- lock explanations
- follow-up countdown/readiness indicator
- earned-skill badges
- real-life application count
- conversational session bubbles
- next-unlock requirement card

Avoid gamification that makes sensitive self-development feel childish. Progress indicators should feel calm and meaningful.

## Other domains
Only the feminine-intelligence domain receives the fully authored curriculum first. Other existing domains remain visible and intact while they are redesigned one by one using the same progression architecture.

Do not copy feminine-intelligence content into other domains. Reuse only the progression engine and UX pattern.

## Acceptance criteria for the first implementation
1. Future route nodes are visibly locked and cannot be opened early.
2. Completing a chat session alone does not unlock the next main node.
3. A real-life mission creates a mission-pending state.
4. A follow-up has a configurable ready time approximately 12–24 hours later.
5. While waiting, at least one meaningful optional activity remains available.
6. Successful follow-up unlocks the next node.
7. "No chance" can trigger a substitute simulation and then unlock progression after success.
8. Failure/old-pattern outcomes provide retry instead of falsely marking mastery.
9. The active route screen clearly shows current node, locked future nodes, earned skills, applications, and next unlock requirement.
10. Base-route completion opens advanced/maintenance experiences rather than ending the app.
11. Existing auth and correct Supabase project binding remain unchanged.
12. Existing non-feminine-intelligence domains are not deleted or converted into this curriculum.
