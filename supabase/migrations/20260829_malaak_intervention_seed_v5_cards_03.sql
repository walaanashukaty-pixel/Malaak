-- Generated deterministically from supabase/functions/malaak-ai/catalog_seed.ts
-- V5 intervention cards part 3 of 8. Do not hand-edit.

insert into public.malaak_interventions (
  code, version, status, title_ar, short_description_ar, framework, evidence_tier, content_origin, licensing_status,
  target_needs, target_patterns, eligible_states, journey_domains, exclusions, contraindication_notes_ar, duration_min,
  steps_ar, action_template_ar, measurement_spec, follow_up_spec, fallback_code, requires_user_confirmation, activated_at,
  scientific_review_status, clinical_boundary_review_status, requires_human_support
) values (
  'NO_TOLERATE_002', 1, 'active', 'أتحمل انزعاج كلمة لا', 'البقاء مع الشعور بالذنب أو عدم رضا الآخر بدون سحب حد معقول فورًا.', 'assertiveness / psychological flexibility', 'B', 'original_malaak', 'cleared_original',
  array['boundary','autonomy','respect']::text[], array['people_pleasing']::text[], array['moderate_activation','reflective']::text[], array['needs']::text[], '["Do not use to ignore evidence that the boundary itself was harmful or unfair."]'::jsonb, 'بنراجع الحد إذا كان مؤذي أو غير عادل، مو بس لأن وجود الذنب مزعج.', 8,
  '["لاحظي الذنب أو القلق بعد قول لا.","اسألي إذا الحد نفسه معقول أو إذا بس رد فعل الآخر مزعج.","إذا الحد معقول، خلي الشعور يمر بدون اعتذار تلقائي أو سحب الحد."]'::jsonb, 'خلي انزعاج ما بعد “لا” موجود شوي بدون ما تلغي حَدّك فورًا.', '{"before":["urge_before"],"after":["urge_after"],"outcome":["action_outcome","user_helpfulness"]}'::jsonb, '{"timing":"after_event","prompt":"شو صار بعد ما جربتي الخطوة؟"}'::jsonb, 'BOUNDARY_001', false, now(),
  'reviewed', 'reviewed', false
) on conflict (code, version) do nothing;

insert into public.malaak_interventions (
  code, version, status, title_ar, short_description_ar, framework, evidence_tier, content_origin, licensing_status,
  target_needs, target_patterns, eligible_states, journey_domains, exclusions, contraindication_notes_ar, duration_min,
  steps_ar, action_template_ar, measurement_spec, follow_up_spec, fallback_code, requires_user_confirmation, activated_at,
  scientific_review_status, clinical_boundary_review_status, requires_human_support
) values (
  'UNCERTAINTY_001', 1, 'active', 'تحمّل جزء من عدم اليقين', 'إيقاف الفحص المتكرر لفترة قصيرة مع إبقاء التواصل المناسب ممكنًا.', 'CBT / uncertainty tolerance', 'B', 'original_malaak', 'cleared_original',
  array['connection','clarity','regulation']::text[], array['attachment_alarm','reassurance_loop','rumination']::text[], array['moderate_activation','reflective','unknown']::text[], array['attachment','overthinking']::text[], '["Not when credible immediate danger requires fact-finding or safety action."]'::jsonb, 'إذا في دليل خطر فعلي أو سبب واقعي للتحقق، مننتقل للفعل/الأمان بدل تدريب عدم اليقين.', 10,
  '["سمّي الشي اللي ما بتعرفيه هلق.","اختاري فترة قصيرة بدون فحص أو طمأنة متكررة.","ارجعي لنشاط مهم خلال الفترة.","بعدها قرري إذا في تواصل مباشر واحد مطلوب."]'::jsonb, 'جربي 10–15 دقيقة بدون فحص متكرر، وبعدها قرري خطوة واحدة.', '{"before":["urge_before"],"after":["urge_after"],"outcome":["checking_count","reassurance_count","recovery_minutes"]}'::jsonb, '{"timing":"later_today","prompt":"شو صار بعد ما جربتي الخطوة؟"}'::jsonb, 'RUMINATION_EXIT_001', false, now(),
  'reviewed', 'reviewed', false
) on conflict (code, version) do nothing;

insert into public.malaak_interventions (
  code, version, status, title_ar, short_description_ar, framework, evidence_tier, content_origin, licensing_status,
  target_needs, target_patterns, eligible_states, journey_domains, exclusions, contraindication_notes_ar, duration_min,
  steps_ar, action_template_ar, measurement_spec, follow_up_spec, fallback_code, requires_user_confirmation, activated_at,
  scientific_review_status, clinical_boundary_review_status, requires_human_support
) values (
  'ATT_TRIGGER_001', 1, 'active', 'خريطة تفعيل التعلق', 'فهم المحفّز والخوف والسلوك بدون تحويل التعلق لهوية ثابتة.', 'attachment-informed coaching', 'C', 'original_malaak', 'cleared_original',
  array['connection','understanding']::text[], array['attachment_alarm','reassurance_loop']::text[], array['moderate_activation','reflective']::text[], array['attachment']::text[], '["Attachment pattern is not a diagnosis or fixed personality label."]'::jsonb, 'إذا العلاقة فعليًا غير آمنة أو غير موثوقة، ما منفسر كل الإنذار كأنه داخلي.', 7,
  '["شو اللي صار قبل الإنذار؟","شو الخوف اللي طلع؟","شو السلوك اللي حسّيتي بدك تعمليه؟","شو الحاجة اللي بدك توصلي إلها؟"]'::jsonb, 'اعملي خريطة: محفّز → خوف → سلوك → حاجة.', '{"before":["clarity_before"],"after":["clarity_after"],"outcome":["action_outcome","user_helpfulness"]}'::jsonb, '{"timing":"tomorrow","prompt":"شو صار بعد ما جربتي الخطوة؟"}'::jsonb, 'EMO_CHAIN_002', false, now(),
  'reviewed', 'reviewed', false
) on conflict (code, version) do nothing;

insert into public.malaak_interventions (
  code, version, status, title_ar, short_description_ar, framework, evidence_tier, content_origin, licensing_status,
  target_needs, target_patterns, eligible_states, journey_domains, exclusions, contraindication_notes_ar, duration_min,
  steps_ar, action_template_ar, measurement_spec, follow_up_spec, fallback_code, requires_user_confirmation, activated_at,
  scientific_review_status, clinical_boundary_review_status, requires_human_support
) values (
  'ATT_REALITY_002', 1, 'active', 'إنذار داخلي أم دليل بالعلاقة؟', 'فصل حساسية التعلق عن السلوك الخارجي الحقيقي.', 'attachment-informed reality testing', 'C', 'original_malaak', 'cleared_original',
  array['clarity','connection','respect']::text[], array['attachment_alarm']::text[], array['moderate_activation','reflective']::text[], array['attachment','relationship']::text[], '["Never use to dismiss coercion, violence, deception, or repeated objective unreliability."]'::jsonb, 'إذا في تهديد/عنف/إكراه أو نمط موثّق من عدم الأمان، الأولوية للواقع والأمان.', 7,
  '["اكتبي إشارات الإنذار اللي بجسمك وعقلك.","اكتبي السلوك الخارجي القابل للملاحظة.","اسألي شو معروف وشو مجهول.","اختاري استجابة تناسب الأدلة مو الخوف وحده."]'::jsonb, 'فرّقي بين اللي جسمك عم يحذرك منه وبين الدليل الخارجي الموجود فعلًا.', '{"before":["clarity_before"],"after":["clarity_after"],"outcome":["action_outcome","user_helpfulness"]}'::jsonb, '{"timing":"later_today","prompt":"شو صار بعد ما جربتي الخطوة؟"}'::jsonb, 'THOUGHT_FACTS_001', false, now(),
  'reviewed', 'reviewed', false
) on conflict (code, version) do nothing;

insert into public.malaak_interventions (
  code, version, status, title_ar, short_description_ar, framework, evidence_tier, content_origin, licensing_status,
  target_needs, target_patterns, eligible_states, journey_domains, exclusions, contraindication_notes_ar, duration_min,
  steps_ar, action_template_ar, measurement_spec, follow_up_spec, fallback_code, requires_user_confirmation, activated_at,
  scientific_review_status, clinical_boundary_review_status, requires_human_support
) values (
  'ATT_REASSURE_DELAY_003', 1, 'active', 'تأجيل الطمأنة المتكررة', 'إبطاء طلب الطمأنة أو الفحص المتكرر مع الحفاظ على تواصل طبيعي.', 'attachment-informed behavior change / uncertainty tolerance', 'B', 'original_malaak', 'cleared_original',
  array['connection','regulation']::text[], array['reassurance_loop','attachment_alarm']::text[], array['moderate_activation','reflective']::text[], array['attachment']::text[], '["Not for situations where a practical response is legitimately overdue or safety information is needed."]'::jsonb, 'الهدف مو منع التواصل؛ الهدف كسر التكرار اللي يعطي راحة دقائق ويرجع الخوف.', 12,
  '["لاحظي رغبة الفحص أو السؤال المتكرر.","نظّمي الشدة شوي.","حددي فترة تأجيل قصيرة.","إذا بقي في حاجة تواصل، اعملي تواصل واحد واضح."]'::jsonb, 'أجّلي الفحص/الطمأنة شوي ثم اختاري تواصل واحد إذا لزم.', '{"before":["urge_before"],"after":["urge_after"],"outcome":["checking_count","reassurance_count"]}'::jsonb, '{"timing":"later_today","prompt":"شو صار بعد ما جربتي الخطوة؟"}'::jsonb, 'UNCERTAINTY_001', false, now(),
  'reviewed', 'reviewed', false
) on conflict (code, version) do nothing;

insert into public.malaak_interventions (
  code, version, status, title_ar, short_description_ar, framework, evidence_tier, content_origin, licensing_status,
  target_needs, target_patterns, eligible_states, journey_domains, exclusions, contraindication_notes_ar, duration_min,
  steps_ar, action_template_ar, measurement_spec, follow_up_spec, fallback_code, requires_user_confirmation, activated_at,
  scientific_review_status, clinical_boundary_review_status, requires_human_support
) values (
  'ATT_REPAIR_004', 1, 'draft', 'رجوع بعد الخلاف بدون مطاردة أو انسحاب', 'تهيئة خطوة إصلاح واضحة بعد ما تنخفض الشدة.', 'attachment-informed relationship coaching', 'C', 'original_malaak', 'cleared_original',
  array['connection','respect']::text[], array['attachment_alarm','conflict_cycle']::text[], array['reflective','moderate_activation']::text[], array['attachment','relationship']::text[], '["Do not use direct confrontation when interpersonal violence, coercion, stalking, or credible danger may be present."]'::jsonb, 'يحتاج مراجعة حدود سريرية/علاقية قبل التفعيل العام. لا يستخدم في علاقة غير آمنة.', 8,
  '["تأكدي إن الشدة نزلت.","حددي شو بدك تصلحيه تحديدًا.","عبري عن مسؤوليتك أو حاجتك بدون مطاردة/تهديد.","اطلبي رجعة للحوار بوقت مناسب."]'::jsonb, 'حضّري جملة إصلاح واحدة وموعد رجوع للحوار.', '{"outcome":["behavior_completed","real_world_result","recovery_minutes"]}'::jsonb, '{"timing":"after_event","prompt":"شو صار بعد ما جربتي الخطوة؟"}'::jsonb, 'REQUEST_DIRECT_001', true, null,
  'reviewed', 'pending', false
) on conflict (code, version) do nothing;

