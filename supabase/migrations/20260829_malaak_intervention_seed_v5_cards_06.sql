-- Generated deterministically from supabase/functions/malaak-ai/catalog_seed.ts
-- V5 intervention cards part 6 of 8. Do not hand-edit.

insert into public.malaak_interventions (
  code, version, status, title_ar, short_description_ar, framework, evidence_tier, content_origin, licensing_status,
  target_needs, target_patterns, eligible_states, journey_domains, exclusions, contraindication_notes_ar, duration_min,
  steps_ar, action_template_ar, measurement_spec, follow_up_spec, fallback_code, requires_user_confirmation, activated_at,
  scientific_review_status, clinical_boundary_review_status, requires_human_support
) values (
  'ANGER_CHAIN_003', 1, 'active', 'سلسلة الغضب كاملة', 'ربط عوامل الضعف والمحفز والتفسير والرغبة والسلوك والنتيجة.', 'CBT anger chain analysis', 'B', 'original_malaak', 'cleared_original',
  array['understanding','clarity']::text[], array['anger_escalation']::text[], array['reflective','moderate_activation']::text[], array['anger']::text[], '["Do not use chain analysis instead of immediate safety action when violence is imminent."]'::jsonb, 'نحلل بعد الأمان، مو أثناء خطر مباشر.', 10,
  '["شو كان وضعك قبل الموقف: نوم/تعب/حمل؟","شو المحفز؟","شو معنى الموقف بعقلك؟","شو الرغبة والسلوك؟","شو النتيجة القصيرة والطويلة؟"]'::jsonb, 'ارسمي سلسلة الغضب وحددي أول نقطة ممكن تغيّريها.', '{"before":["clarity_before"],"after":["clarity_after"],"outcome":["action_outcome","user_helpfulness"]}'::jsonb, '{"timing":"tomorrow","prompt":"شو صار بعد ما جربتي الخطوة؟"}'::jsonb, 'EMO_CHAIN_002', false, now(),
  'reviewed', 'reviewed', false
) on conflict (code, version) do nothing;

insert into public.malaak_interventions (
  code, version, status, title_ar, short_description_ar, framework, evidence_tier, content_origin, licensing_status,
  target_needs, target_patterns, eligible_states, journey_domains, exclusions, contraindication_notes_ar, duration_min,
  steps_ar, action_template_ar, measurement_spec, follow_up_spec, fallback_code, requires_user_confirmation, activated_at,
  scientific_review_status, clinical_boundary_review_status, requires_human_support
) values (
  'ANGER_ASSERT_004', 1, 'draft', 'حوّلي رسالة الغضب لحزم', 'استخدام معلومة الغضب لطلب أو حد واضح بدل عدوان أو كبت.', 'anger management / assertiveness', 'B', 'original_malaak', 'cleared_original',
  array['respect','boundary','clarity']::text[], array['anger_escalation','conflict_cycle']::text[], array['reflective','moderate_activation']::text[], array['anger']::text[], '["Do not use direct confrontation when interpersonal violence, coercion, stalking, or credible danger may be present."]'::jsonb, 'الحزم بعد ما تنخفض الشدة فقط، وفي الأمان فقط.', 8,
  '["شو الرسالة المفيدة بالغضب؟","هل هي حاجة، حد، ظلم، أو حمل زائد؟","حوّليها لجملة حازمة بدون تهديد."]'::jsonb, 'حوّلي معلومة الغضب لطلب أو حد واحد واضح.', '{"outcome":["behavior_completed","real_world_result"]}'::jsonb, '{"timing":"after_event","prompt":"شو صار بعد ما جربتي الخطوة؟"}'::jsonb, 'BOUNDARY_001', true, null,
  'reviewed', 'pending', false
) on conflict (code, version) do nothing;

insert into public.malaak_interventions (
  code, version, status, title_ar, short_description_ar, framework, evidence_tier, content_origin, licensing_status,
  target_needs, target_patterns, eligible_states, journey_domains, exclusions, contraindication_notes_ar, duration_min,
  steps_ar, action_template_ar, measurement_spec, follow_up_spec, fallback_code, requires_user_confirmation, activated_at,
  scientific_review_status, clinical_boundary_review_status, requires_human_support
) values (
  'ANGER_REPAIR_005', 1, 'draft', 'إصلاح بعد سلوك مؤذي', 'تحمّل المسؤولية وإصلاح ما يمكن بدون هروب للعار.', 'anger management / accountability coaching', 'C', 'original_malaak', 'cleared_original',
  array['respect','connection']::text[], array['anger_escalation']::text[], array['reflective']::text[], array['anger','relationship']::text[], '["Not a substitute for safeguarding after violence or child harm."]'::jsonb, 'إذا صار أذى جسدي أو تكرر فقد السيطرة، لازم تقييم ودعم بشري مناسب؛ الاعتذار وحده مو خطة أمان.', 10,
  '["سمّي شو عملتي بدون تبرير.","تأكدي من سلامة الشخص المتأذي.","اعتذري عن السلوك المحدد إذا مناسب.","اعملي خطوة تمنع التكرار واطلبي دعم إذا فقد السيطرة عم يتكرر."]'::jsonb, 'تحمّلي مسؤولية السلوك واعملِي خطوة إصلاح ومنع تكرار.', '{"outcome":["behavior_completed","real_world_result"]}'::jsonb, '{"timing":"after_event","prompt":"شو صار بعد ما جربتي الخطوة؟"}'::jsonb, 'ANGER_CHAIN_003', true, null,
  'reviewed', 'pending', true
) on conflict (code, version) do nothing;

insert into public.malaak_interventions (
  code, version, status, title_ar, short_description_ar, framework, evidence_tier, content_origin, licensing_status,
  target_needs, target_patterns, eligible_states, journey_domains, exclusions, contraindication_notes_ar, duration_min,
  steps_ar, action_template_ar, measurement_spec, follow_up_spec, fallback_code, requires_user_confirmation, activated_at,
  scientific_review_status, clinical_boundary_review_status, requires_human_support
) values (
  'CHILD_PRESENT_PAST_001', 1, 'draft', 'الماضي لمس الحاضر، بس الحاضر مو الماضي', 'تمييز التشابه بين محفز حالي وتعلّم قديم بدون افتراض قصة مخفية.', 'schema-informed present-focused coaching', 'C', 'original_malaak', 'cleared_original',
  array['clarity','regulation']::text[], array['thought_fusion','people_pleasing','attachment_alarm']::text[], array['reflective']::text[], array['childhood']::text[], '["Do not use for trauma exposure, memory recovery, imaginal reliving, EMDR, or to infer that a hidden event must have occurred."]'::jsonb, 'ممنوع استخدامه لاسترجاع ذاكرة مخفية أو إعادة عيش صدمة. إذا ظهرت أعراض صدمية شديدة، نوقف ونوجّه لدعم متخصص.', 8,
  '["شو الموقف الحالي فعلًا؟","شو الإحساس أو القاعدة القديمة اللي تشبهه؟","شو الاختلاف بين وقتها وهلأ؟","شو قدرة أو خيار عندك اليوم ما كان موجود قبل؟"]'::jsonb, 'اكتبي فرقين بين الماضي والحاضر قبل ما تتصرفي كأنهم نفس الشي.', '{"before":["clarity_before"],"after":["clarity_after"],"outcome":["action_outcome","user_helpfulness"]}'::jsonb, '{"timing":"tomorrow","prompt":"شو صار بعد ما جربتي الخطوة؟"}'::jsonb, 'THOUGHT_FACTS_001', true, null,
  'reviewed', 'pending', false
) on conflict (code, version) do nothing;

insert into public.malaak_interventions (
  code, version, status, title_ar, short_description_ar, framework, evidence_tier, content_origin, licensing_status,
  target_needs, target_patterns, eligible_states, journey_domains, exclusions, contraindication_notes_ar, duration_min,
  steps_ar, action_template_ar, measurement_spec, follow_up_spec, fallback_code, requires_user_confirmation, activated_at,
  scientific_review_status, clinical_boundary_review_status, requires_human_support
) values (
  'CHILD_OLD_BELIEF_002', 1, 'draft', 'معتقد قديم مو حقيقة نهائية', 'صياغة قاعدة قديمة كفرضية تعلّمتها، لا كحقيقة أو ذاكرة مؤكدة.', 'schema-informed cognitive coaching', 'C', 'original_malaak', 'cleared_original',
  array['clarity','understanding']::text[], array['people_pleasing','thought_fusion','attachment_alarm']::text[], array['reflective']::text[], array['childhood']::text[], '["Do not use for trauma exposure, memory recovery, imaginal reliving, EMDR, or to infer that a hidden event must have occurred."]'::jsonb, 'لا نسأل “شو لازم يكون صار؟” ولا نختلق أسباب طفولة. نشتغل فقط على الاعتقاد اللي المستخدم يلاحظ وجوده الآن.', 9,
  '["اكتبي القاعدة اللي بتطلع اليوم: مثل “لازم أرضي الكل”.","قولي: “يمكن تعلمت هالقاعدة بوقت سابق”.","اجمعي دليل من الحاضر معها وضدها.","اختاري قاعدة أوسع وأكثر مرونة."]'::jsonb, 'حوّلي القاعدة القديمة لفرضية قابلة للفحص بالحاضر.', '{"before":["belief_before"],"after":["belief_after"],"outcome":["action_outcome","user_helpfulness"]}'::jsonb, '{"timing":"tomorrow","prompt":"شو صار بعد ما جربتي الخطوة؟"}'::jsonb, 'THOUGHT_FACTS_001', true, null,
  'reviewed', 'pending', false
) on conflict (code, version) do nothing;

insert into public.malaak_interventions (
  code, version, status, title_ar, short_description_ar, framework, evidence_tier, content_origin, licensing_status,
  target_needs, target_patterns, eligible_states, journey_domains, exclusions, contraindication_notes_ar, duration_min,
  steps_ar, action_template_ar, measurement_spec, follow_up_spec, fallback_code, requires_user_confirmation, activated_at,
  scientific_review_status, clinical_boundary_review_status, requires_human_support
) values (
  'CHILD_SELF_COMPASSION_003', 1, 'draft', 'رحمة بالنفس مع مسؤولية اليوم', 'التعامل بلطف مع أثر التجربة القديمة بدون إعفاء السلوك الحالي من المسؤولية.', 'self-compassion / trauma-informed coaching', 'B', 'original_malaak', 'cleared_original',
  array['support','regulation']::text[], array['people_pleasing','anger_escalation','thought_fusion']::text[], array['reflective','moderate_activation']::text[], array['childhood']::text[], '["Do not use for trauma exposure, memory recovery, imaginal reliving, EMDR, or to infer that a hidden event must have occurred."]'::jsonb, 'الرحمة بالنفس ما تعني تبرير إيذاء الآخرين أو تفادي الإصلاح.', 7,
  '["سمّي اللي كان صعب عليك بدون جلد ذات.","قولي شو بتحتاجي تسمعيه بطريقة واقعية ولطيفة.","اسألي شو مسؤوليتك اليوم رغم فهم السبب."]'::jsonb, 'اكتبي جملة رحيمة وجملة مسؤولية لنفس الموقف.', '{"before":["intensity_before"],"after":["intensity_after"],"outcome":["action_outcome","user_helpfulness"]}'::jsonb, '{"timing":"tomorrow","prompt":"شو صار بعد ما جربتي الخطوة؟"}'::jsonb, 'EMO_NAME_001', true, null,
  'reviewed', 'pending', false
) on conflict (code, version) do nothing;

