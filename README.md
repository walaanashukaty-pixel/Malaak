# Malaak Android Release Readiness — Source 0.6.1+9

The approved V5 coaching/formulation/journey engine is unchanged. This release hardens the Flutter source for a **real Android build** while preserving the same Figma-derived mobile visual language and Arabic RTL experience.

Android readiness added:

- Keyboard-aware mobile shell: the floating Bottom Navigation hides while the Android IME is open.
- Malaak chat composer uses safe-area/IME-aware spacing instead of a hard-coded bottom offset.
- Reproducible Android bootstrap with package id `com.malaak.malaak_balance` and app label `ملاك`.
- Release scripts run `flutter analyze`, `flutter test`, then build both **APK** and **AAB**.
- **GitHub Actions** workflow builds Android artifacts with pinned **Flutter 3.47.1** + Java 17.
- Android UI regression gates block Drawer/NavigationRail regressions and incorrect test package imports.
- `ANDROID_RELEASE_CHECKLIST.md` defines real-device RTL, keyboard, back-navigation, signing, APK and AAB verification.

Local Android build on a Flutter-capable machine:

```bash
bash scripts/build_android_release.sh
```

Windows:

```powershell
powershell -ExecutionPolicy Bypass -File scripts/build_android_release.ps1
```

CI build: run `.github/workflows/android-release.yml`. The workflow uploads APK and AAB artifacts. Production Google Play signing remains a separate release-environment responsibility; no signing secret is stored in this repository.

Final source readiness gate:

```bash
python scripts/verify_android_release_readiness.py
```

> This execution environment still does not contain Flutter/Android SDK, so an APK is not claimed as compiled here. The source and build pipeline are prepared so compilation can happen reproducibly on Flutter 3.47.1 or GitHub Actions.

---


## Android Doctor

Before the first local Android build, run the environment doctor:

```powershell
powershell -ExecutionPolicy Bypass -File scripts\android_doctor.ps1
```

On Linux/macOS CI environments:

```bash
bash scripts/android_doctor.sh
```

It checks Flutter, Java, the Android toolchain, and available devices. The project CI is pinned to **Flutter 3.47.1** so local differences are surfaced before Gradle/build errors. `scripts/verify_dart_source_integrity.py` also validates UTF-8 Dart files and local/package import targets as part of the release gate.

## Malaak V5C — Deterministic Journey Planner

V5C turns the V5 working formulation into one simple, server-managed journey plan instead of exposing every domain as a competing treatment path. Planning is deterministic: the language model may explain a plan, but it does **not** choose the Primary or Support domains.

Planner rules:

- `Safety` suspends ordinary planning immediately. A live safety message also pauses the stored journey plan before the safety response returns.
- At most one **Primary** and one **Support** path are emitted.
- Up to two **Monitor** domains may be watched without becoming active work.
- **Later** keeps relevant deeper themes visible without opening them too early.
- Current user goal, functioning/impact, and repeated current-life evidence outrank speculative historical themes.
- Childhood/healing cannot become automatic Primary work during high activation or inadequate readiness.
- Rejected and dormant hypotheses do not increase planner ranking.
- Difficult weeks use Support Mode rather than demoting progress. Repeated non-response triggers reassessment/step-up instead of repeating the same intervention indefinitely.
- Flutter receives a read-only snapshot of `malaak_journey_plans`; plan versioning and priority decisions remain server-managed.

Mobile UI:

- Home renders the real current Primary focus and Support skill.
- `رحلتي` renders **Primary / Support / Monitor / Later** with no fake psychological percentages.
- Paused/safety states override ordinary growth prompts.
- If evidence is not sufficient yet, the app says the plan is still forming instead of inventing a pattern.

Production checkpoint on 2026-08-29: migration `malaak_journey_planner_v5` is applied, `malaak_journey_plans` grants authenticated users SELECT only with own-row RLS, and `malaak-ai` Edge Function version 6 is ACTIVE with JWT verification. The complete server suite is **68/68 PASS** in this environment.

V5 release verification:

```bash
python scripts/verify_v5_release.py
```

Deployment reproducibility:

```bash
node scripts/build_malaak_edge_deploy_bundle.mjs
```

This creates an ignored deployment artifact from the checked-in Edge modules and smoke-tests independently before deployment. The checked-in TypeScript modules remain the source of truth.

## Malaak V5B — Progressive Assessment & Working Formulation

V5B adds a progressive assessment layer without turning onboarding or chat into a diagnostic test. The app now keeps **Initial Map, observations, hypotheses, and versioned working formulations** as separate data classes, so a single message cannot silently become a psychological fact.

Key rules:

- `Fact / Observation / Hypothesis / Repeated Pattern / User-validated insight` remain distinct.
- A model-extracted observation is bounded to event/thought/emotion/need/behavior fields and is discarded when pattern analysis is disabled or a journal entry is private.
- Hypothesis promotion is deterministic on the server; the model cannot set support counts, status, or confidence.
- One observation starts as a low-confidence candidate. Repetition requires independent evidence across time/context, and explicit user rejection removes the pattern from routing until it is reviewed again.
- Working formulations are append-only versions and change only after a material evidence/goal/context change, not after every message.
- The first-use flow is six short steps and the result is explicitly labeled **«خريطة أولية»**, with no diagnostic percentage or fake precision.
- The user can open **«مراجعة استنتاجات ملاك»** and choose **«هذا مو صحيح»** with optional feedback. Flutter cannot directly mutate hypothesis support/confidence.
- High current impact produces a non-diagnostic recommendation that additional human/professional support may be useful. Safety concerns remain ahead of normal coaching.

Production checkpoint on 2026-08-29: migration `malaak_formulation_v5` is applied, `malaak-ai` Edge Function version 5 is ACTIVE with JWT verification, and the Node server suite is 49/49 green in this environment.

V5B verification:

```bash
python scripts/verify_v5b_release.py
```

Flutter/Dart/Android SDK are not installed in this execution environment, so final `flutter test`, `flutter analyze`, and APK compilation still need a Flutter-capable machine.

## Malaak V5A — Scientific intervention catalog

V5A replaces the V4 normal hardcoded intervention list with a versioned Supabase catalog. The current registry contains 48 candidate intervention codes with evidence tier, licensing/review status, eligibility, exclusions, measurement and follow-up metadata. The Edge Function keeps deterministic safety/routing rules, loads only active eligible revisions, and returns exact catalog revision identifiers for auditability.

Production status on 2026-08-29: 48 catalog revisions (32 active / 16 draft), `malaak-ai` Edge Function version 4 ACTIVE with JWT verification, and all active A/B/C cards have reviewed source records.

The five-card embedded fallback is used only when the catalog cannot be loaded. Flutter cannot mutate catalog rows.

# ملاك — Flutter Android V4

تطبيق Android حقيقي مبني بـ **Flutter**، عربي RTL وMobile-first، بدون Sidebar/Drawer، مع **Home** كمركز إدارة التطبيق وBottom Navigation من أربع وجهات: **الرئيسية / ملاك / رحلتي / أنا**.

V4 تحوّل ملاك من محادثة AI عامة إلى **نظام Coaching منظم Rules-first**: السلامة والتوجيه واختيار الأدوات المسموح بها تُحسم على الخادم أولًا، ثم يستخدم النموذج الذكاء الاصطناعي لتخصيص الحوار ضمن هذه الحدود فقط.

## الجديد في V4

- Router حتمي قبل الـAI وفق المسار:
  `SAFE → STATE → NEED → PATTERN → GOAL → TOOL → ACTION → FOLLOW-UP`.
- Safety Mode يوقف coaching العادي عند مؤشرات الخطر ولا يسمح باختيار intervention عادي.
- مكتبة أولية من **10 تدخلات معتمدة داخل النظام**؛ النموذج لا يستطيع اختراع أداة جديدة.
- OpenAI يرجع Structured Output منظم، والخادم يعيد التحقق من `interventionCode` قبل قبول النتيجة.
- إذا رجع النموذج مخرجات غير صالحة أو أداة غير مسموحة، يستخدم النظام deterministic fallback من المكتبة نفسها.
- كل جلسة يمكن أن تنتج:
  - الحالة الحالية.
  - الحاجة.
  - النمط كفرضية بدرجة ثقة.
  - هدف الجلسة.
  - الأداة المختارة.
  - خطوة عملية الآن.
  - Follow-up لاحق.
- Flutter يخزن `CoachingTurn` و`CoachingFollowUp` محليًا وسحابيًا.
- الـHome تعرض متابعة فعلية من الجلسة بدل بطاقة تجريبية ثابتة.
- عند فتح المتابعة، تنتقل المستخدمة إلى ملاك بسياق المتابعة نفسها.
- Supabase V4 يضيف جداول مخصصة لدورات coaching والمتابعات مع RLS لكل مستخدمة.
- `malaak_get_state()` و`malaak_sync_state(jsonb)` صارا يزامنان بيانات V4 أيضًا.
- Edge Function `malaak-ai` منشورة كنسخة v3 ومحمية بـJWT.

## مكتبة التدخلات الأولية

```text
REG_GROUND_001       تثبيت الحاضر
REG_MOVE_002         حركة قصيرة للتنظيم
ANGER_TIMEOUT_001    توقف آمن مع موعد رجوع
THOUGHT_FACTS_001    الحدث أم التفسير؟
RUMINATION_EXIT_001  الخروج من الحلقة
UNCERTAINTY_001      تحمل جزء من عدم اليقين
NEED_NAME_001        تسمية الحاجة
REQUEST_DIRECT_001   طلب مباشر بدون لوم
BOUNDARY_001         حد واضح وقصير
PROBLEM_SOLVE_001    مشكلة واحدة وخطوة واحدة
```

هذه مكتبة بداية وليست ادعاء بأنها تغطي كل الرعاية النفسية. إضافة أي intervention جديد يجب أن تتم عبر بطاقة علمية ومراجعة واضحة، وليس من خلال Prompt حر للنموذج.

## الخصوصية والذاكرة

- نصوص اليوميات لا تدخل سياق Malaak AI إلا عند تفعيل الإذن الخاص بتحليل اليوميات.
- الأنماط والفرضيات لا تُرسل إذا أوقفت المستخدمة إذن الأنماط.
- `Fact ≠ Pattern ≠ Hypothesis` محفوظة كأنواع مختلفة.
- مفتاح OpenAI لا يدخل Flutter ولا APK.
- Flutter يحتوي فقط على Supabase publishable key المخصص لتطبيقات العميل، بينما الوصول للبيانات محمي بـRLS.

## Supabase V4

Migration الجديدة:

```text
supabase/migrations/20260829_malaak_coaching_v4.sql
```

الجداول الجديدة:

```text
malaak_coaching_turns
malaak_followups
```

وتستمر جداول V3:

```text
malaak_profiles
malaak_journals
malaak_journeys
malaak_memories
malaak_messages
```

الـRPCs:

```text
malaak_get_state()
malaak_sync_state(jsonb)
```

## تفعيل OpenAI

خزّني المفتاح على Supabase كـEdge Function Secret، وليس داخل التطبيق:

```text
OPENAI_API_KEY
```

اختياريًا:

```text
MALAAK_OPENAI_MODEL
```

القيمة الافتراضية الموجودة بالخادم حاليًا:

```text
gpt-5.6-luna
```

لا ترسلي المفتاح داخل المحادثة ولا تضعيه في Git.

## تشغيل المشروع

بعد تثبيت Flutter SDK وAndroid Studio/Android SDK:

```bash
flutter pub get
flutter test
flutter analyze
flutter run
```

على Windows يمكن البدء عبر:

```bat
scripts\bootstrap_android.bat
```

## بناء APK

بعد نجاح الاختبارات والتحليل على جهاز فيه Flutter:

```bash
flutter pub get
flutter test
flutter analyze
flutter build apk --release
```

الناتج عادةً:

```text
build/app/outputs/flutter-apk/app-release.apk
```

ولـGoogle Play:

```bash
flutter build appbundle --release
```

## التحقق الموجود داخل المشروع

فحص V4 الموحّد:

```bash
python scripts/verify_v4_release.py
```

ويشغّل فحوص V1–V4 واختبارات Router/Validator الفعلية عبر Node.

اختبارات Flutter الحقيقية موجودة أيضًا تحت `test/`، لكنها تحتاج Flutter SDK لتشغيلها.

## ملاحظات قبل الإطلاق العام

- ملاك أداة Coaching ومساعدة ذاتية وليست أداة تشخيص طبي أو بديلًا عن مختص أو خدمات الطوارئ.
- Safety Router الحالي طبقة مهمة لكنه ليس نهاية عمل السلامة؛ قبل الإطلاق العام يلزم توسيع سيناريوهات الاختبار، المراقبة، rate limiting، abuse prevention، والـregional crisis routing.
- مكتبة التدخلات يجب أن تخضع لمراجعة علمية/حقوق استخدام قبل وصف المنتج تجاريًا بأنه Evidence-based على نطاق واسع.
- المزامنة ما زالت Full-state RPC مناسبة لمرحلة مبكرة؛ قبل الاستخدام متعدد الأجهزة على نطاق واسع يفضّل Delta sync وحل تعارضات.

## بنية V4 المهمة

```text
lib/models/coaching_turn.dart
lib/models/coaching_follow_up.dart
lib/services/malaak_gateway.dart
lib/state/app_controller.dart
lib/screens/malaak/malaak_screen.dart
lib/screens/home/home_screen.dart
supabase/functions/malaak-ai/types.ts
supabase/functions/malaak-ai/interventions.ts
supabase/functions/malaak-ai/router.ts
supabase/functions/malaak-ai/coach.ts
supabase/migrations/20260829_malaak_coaching_v4.sql
scripts/verify_v4_release.py
```
