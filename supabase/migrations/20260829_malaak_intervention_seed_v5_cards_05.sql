-- Generated deterministically from supabase/functions/malaak-ai/catalog_seed.ts
-- V5 intervention cards part 5 of 8. Do not hand-edit.

insert into public.malaak_interventions (
  code, version, status, title_ar, short_description_ar, framework, evidence_tier, content_origin, licensing_status,
  target_needs, target_patterns, eligible_states, journey_domains, exclusions, contraindication_notes_ar, duration_min,
  steps_ar, action_template_ar, measurement_spec, follow_up_spec, fallback_code, requires_user_confirmation, activated_at,
  scientific_review_status, clinical_boundary_review_status, requires_human_support
) values (
  'RUMINATION_EXIT_001', 1, 'active', 'الخروج من الحلقة', 'إيقاف جولة التحليل لما ما عاد تنتج معلومة أو قرار.', 'CBT / metacognitive disengagement', 'B', 'original_malaak', 'cleared_original',
  array['regulation','clarity']::text[], array['rumination','reassurance_loop']::text[], array['moderate_activation','reflective','unknown']::text[], array['overthinking']::text[], '["Do not use to suppress actionable safety information."]'::jsonb, 'إذا في معلومة أمنية/عملية جديدة، نتصرف عليها بدل إغلاق التفكير.', 4,
  '["اسألي: ظهر شي جديد؟","إذا لا، سمّي إنك داخل الحلقة.","وقفي الجولة الحالية.","ارجعي لنشاط محدد 10 دقايق."]'::jsonb, 'وقفي جولة التحليل وارجعي لنشاط محدد 10 دقائق.', '{"before":["urge_before"],"after":["urge_after"],"outcome":["recovery_minutes"]}'::jsonb, '{"timing":"later_today","prompt":"شو صار بعد ما جربتي الخطوة؟"}'::jsonb, 'REG_GROUND_001', false, now(),
  'reviewed', 'reviewed', false
) on conflict (code, version) do nothing;

insert into public.malaak_interventions (
  code, version, status, title_ar, short_description_ar, framework, evidence_tier, content_origin, licensing_status,
  target_needs, target_patterns, eligible_states, journey_domains, exclusions, contraindication_notes_ar, duration_min,
  steps_ar, action_template_ar, measurement_spec, follow_up_spec, fallback_code, requires_user_confirmation, activated_at,
  scientific_review_status, clinical_boundary_review_status, requires_human_support
) values (
  'PROBLEM_SOLVE_001', 1, 'active', 'مشكلة واحدة وخطوة واحدة', 'تحويل التفكير المفيد إلى فعل صغير قابل للتنفيذ.', 'CBT problem solving', 'A', 'original_malaak', 'cleared_original',
  array['decision','clarity','autonomy']::text[], array['practical_problem','control_overdrive','unknown']::text[], array['moderate_activation','reflective','unknown']::text[], array['inner-peace','overthinking']::text[], '["Not for immediate danger requiring safety action."]'::jsonb, 'إذا المشكلة مو قابلة للحل الآن، مننتقل لتحمل عدم اليقين أو القبول بدل المزيد من التخطيط.', 8,
  '["عرّفي المشكلة بجملة قابلة للحل.","افصلي شو بإيدك.","اختاري أصغر خطوة.","حددي متى تنفذيها."]'::jsonb, 'اختاري مشكلة وحدة تحت سيطرتك ونفذي أصغر خطوة.', '{"before":["clarity_before"],"after":["clarity_after"],"outcome":["behavior_completed","real_world_result"]}'::jsonb, '{"timing":"after_event","prompt":"شو صار بعد ما جربتي الخطوة؟"}'::jsonb, 'THOUGHT_FACTS_001', false, now(),
  'reviewed', 'reviewed', false
) on conflict (code, version) do nothing;

insert into public.malaak_interventions (
  code, version, status, title_ar, short_description_ar, framework, evidence_tier, content_origin, licensing_status,
  target_needs, target_patterns, eligible_states, journey_domains, exclusions, contraindication_notes_ar, duration_min,
  steps_ar, action_template_ar, measurement_spec, follow_up_spec, fallback_code, requires_user_confirmation, activated_at,
  scientific_review_status, clinical_boundary_review_status, requires_human_support
) values (
  'WORRY_POSTPONE_002', 1, 'active', 'أجّلي القلق لوقت محدد', 'تأجيل القلق غير العاجل بدل الاستجابة له طول اليوم.', 'CBT worry management', 'B', 'original_malaak', 'cleared_original',
  array['clarity','regulation']::text[], array['rumination']::text[], array['moderate_activation','reflective']::text[], array['overthinking']::text[], '["Do not postpone urgent safety or practical action."]'::jsonb, 'المقصود قلق متكرر غير عاجل، مو مهمة ضرورية أو خطر فعلي.', 5,
  '["اكتبي عنوان القلق بكلمتين.","حددي وقت قصير لاحق اليوم للرجوع له.","لما يرجع، ذكري حالك إنه محفوظ لوقته.","ارجعي للي عم تعمليه الآن."]'::jsonb, 'احفظي القلق لوقت محدد لاحقًا وارجعي لمهمتك الحالية.', '{"outcome":["recovery_minutes"],"before":["urge_before"],"after":["urge_after"]}'::jsonb, '{"timing":"later_today","prompt":"لما وصل وقت القلق، بقي بنفس القوة ولا تغيّر؟"}'::jsonb, 'RUMINATION_EXIT_001', false, now(),
  'reviewed', 'reviewed', false
) on conflict (code, version) do nothing;

insert into public.malaak_interventions (
  code, version, status, title_ar, short_description_ar, framework, evidence_tier, content_origin, licensing_status,
  target_needs, target_patterns, eligible_states, journey_domains, exclusions, contraindication_notes_ar, duration_min,
  steps_ar, action_template_ar, measurement_spec, follow_up_spec, fallback_code, requires_user_confirmation, activated_at,
  scientific_review_status, clinical_boundary_review_status, requires_human_support
) values (
  'DEFUSION_003', 1, 'active', 'هاي فكرة مو أمر', 'ملاحظة الفكرة كحدث ذهني بدل التعامل معها كحقيقة أو أمر للتصرف.', 'ACT cognitive defusion', 'B', 'original_malaak', 'cleared_original',
  array['clarity','regulation']::text[], array['thought_fusion','rumination']::text[], array['moderate_activation','reflective','unknown']::text[], array['overthinking']::text[], '["Not a substitute for evaluating credible external danger or factual evidence."]'::jsonb, 'إذا الفكرة تنبه لخطر فعلي، لازم نفحص الواقع بدل نعتبرها مجرد ذهن.', 4,
  '["قولي: “عم لاحظ فكرة إن…” بدل “أكيد…”.","لاحظي الشعور اللي بيجي معها.","اختاري إذا بدك تتصرفي حسب قيمك رغم وجود الفكرة."]'::jsonb, 'صيغيها: “عم لاحظ فكرة إن…” وخدي خطوة حسب قيمك مو حسب الخوف وحده.', '{"before":["urge_before"],"after":["urge_after"],"outcome":["action_outcome","user_helpfulness"]}'::jsonb, '{"timing":"later_today","prompt":"شو صار بعد ما جربتي الخطوة؟"}'::jsonb, 'THOUGHT_FACTS_001', false, now(),
  'reviewed', 'reviewed', false
) on conflict (code, version) do nothing;

insert into public.malaak_interventions (
  code, version, status, title_ar, short_description_ar, framework, evidence_tier, content_origin, licensing_status,
  target_needs, target_patterns, eligible_states, journey_domains, exclusions, contraindication_notes_ar, duration_min,
  steps_ar, action_template_ar, measurement_spec, follow_up_spec, fallback_code, requires_user_confirmation, activated_at,
  scientific_review_status, clinical_boundary_review_status, requires_human_support
) values (
  'REASSURANCE_BREAK_004', 1, 'active', 'هل الجواب عم يريحني خمس دقايق بس؟', 'كشف تكرار طلب نفس الجواب لما الطمأنة قصيرة العمر.', 'CBT / repetitive negative thinking management', 'B', 'original_malaak', 'cleared_original',
  array['regulation','clarity']::text[], array['reassurance_loop','rumination']::text[], array['moderate_activation','reflective']::text[], array['overthinking','attachment']::text[], '["Do not block appropriate one-time clarification or needed safety information."]'::jsonb, 'مو كل سؤال طمأنة مشكلة؛ الهدف التكرار اللي ما بيضيف معلومة.', 5,
  '["عدّي كم مرة رجع نفس السؤال.","اسألي شو مدة الراحة بعد آخر جواب.","إذا كانت قصيرة ورجع السؤال، سمي الحلقة.","اختاري أداة تحمل عدم اليقين أو الخروج من الحلقة."]'::jsonb, 'وقفي جواب جديد لنفس السؤال وجربي تحمل عدم اليقين شوي.', '{"outcome":["reassurance_count","checking_count"],"before":["urge_before"],"after":["urge_after"]}'::jsonb, '{"timing":"later_today","prompt":"شو صار بعد ما جربتي الخطوة؟"}'::jsonb, 'UNCERTAINTY_001', false, now(),
  'reviewed', 'reviewed', false
) on conflict (code, version) do nothing;

insert into public.malaak_interventions (
  code, version, status, title_ar, short_description_ar, framework, evidence_tier, content_origin, licensing_status,
  target_needs, target_patterns, eligible_states, journey_domains, exclusions, contraindication_notes_ar, duration_min,
  steps_ar, action_template_ar, measurement_spec, follow_up_spec, fallback_code, requires_user_confirmation, activated_at,
  scientific_review_status, clinical_boundary_review_status, requires_human_support
) values (
  'ANGER_THERMOMETER_002', 1, 'active', 'مقياس غضبي المبكر', 'اكتشاف علامات 3–6/10 قبل الوصول للانفجار.', 'anger self-monitoring', 'B', 'original_malaak', 'cleared_original',
  array['regulation','clarity']::text[], array['anger_escalation']::text[], array['moderate_activation','reflective','unknown']::text[], array['anger']::text[], '["Not a violence-risk assessment."]'::jsonb, 'إذا في خوف من أذى مباشر، رقم الغضب ما بكفي وننتقل لمسار الأمان.', 6,
  '["شو أول علامة بجسمك؟","شو أول فكرة؟","شو أول رغبة سلوكية؟","حددي مستوى تقريبي لازم عنده توقفي وتستخدمي مهارة."]'::jsonb, 'حددي 3 إشارات بتقول إن غضبك عم يطلع قبل الانفجار.', '{"before":["intensity_before"],"outcome":["recovery_minutes"]}'::jsonb, '{"timing":"tomorrow","prompt":"شو صار بعد ما جربتي الخطوة؟"}'::jsonb, 'REG_GROUND_001', false, now(),
  'reviewed', 'reviewed', false
) on conflict (code, version) do nothing;

