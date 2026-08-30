-- Generated deterministically from supabase/functions/malaak-ai/catalog_seed.ts
-- V5 intervention cards part 4 of 8. Do not hand-edit.

insert into public.malaak_interventions (
  code, version, status, title_ar, short_description_ar, framework, evidence_tier, content_origin, licensing_status,
  target_needs, target_patterns, eligible_states, journey_domains, exclusions, contraindication_notes_ar, duration_min,
  steps_ar, action_template_ar, measurement_spec, follow_up_spec, fallback_code, requires_user_confirmation, activated_at,
  scientific_review_status, clinical_boundary_review_status, requires_human_support
) values (
  'REL_CYCLE_001', 1, 'draft', 'دائرة الخلاف بدل مين الغلطان', 'رسم تسلسل تفاعل الطرفين لفهم الحلقة المتكررة.', 'couple-therapy-informed coaching', 'B', 'original_malaak', 'cleared_original',
  array['clarity','connection']::text[], array['conflict_cycle']::text[], array['reflective','moderate_activation']::text[], array['relationship']::text[], '["Do not use direct confrontation when interpersonal violence, coercion, stalking, or credible danger may be present."]'::jsonb, 'لا نستخدم “الدائرة” لمعادلة المسؤولية بين عنف/إكراه وبين رد فعل الطرف المتضرر.', 10,
  '["شو عمل الطرف الأول؟","شو فهم الطرف الثاني وعمل؟","كيف رجع هذا السلوك أثّر على الأول؟","وين أصغر نقطة ممكن نكسر فيها الحلقة؟"]'::jsonb, 'ارسمي دائرة الخلاف كسلوك → رد → رد، بدون شتائم أو تشخيص.', '{"before":["clarity_before"],"after":["clarity_after"],"outcome":["action_outcome","user_helpfulness"]}'::jsonb, '{"timing":"tomorrow","prompt":"شو صار بعد ما جربتي الخطوة؟"}'::jsonb, 'EMO_CHAIN_002', true, null,
  'reviewed', 'pending', false
) on conflict (code, version) do nothing;

insert into public.malaak_interventions (
  code, version, status, title_ar, short_description_ar, framework, evidence_tier, content_origin, licensing_status,
  target_needs, target_patterns, eligible_states, journey_domains, exclusions, contraindication_notes_ar, duration_min,
  steps_ar, action_template_ar, measurement_spec, follow_up_spec, fallback_code, requires_user_confirmation, activated_at,
  scientific_review_status, clinical_boundary_review_status, requires_human_support
) values (
  'ANGER_TIMEOUT_001', 1, 'active', 'توقف آمن مع موعد رجوع', 'توقف غير عقابي أثناء التصعيد مع اتفاق رجوع واضح.', 'anger management / interpersonal effectiveness', 'B', 'original_malaak', 'cleared_original',
  array['regulation','respect']::text[], array['anger_escalation','conflict_cycle']::text[], array['high_activation','moderate_activation']::text[], array['anger','relationship']::text[], '["Not a silent-treatment punishment.","Not for immediate violence risk; use safety mode."]'::jsonb, 'إذا في احتمال أذى مباشر، مننتقل للأمان وما منكتفي بتقنية timeout.', 20,
  '["قولي إن الشدة عالية ولازم توقف مؤقت.","حددي وقت رجوع واضح إذا الوضع آمن.","استخدمي الوقت للتنظيم، مو لتجميع حجج جديدة."]'::jsonb, 'وقفي الحوار مؤقتًا وحددي موعد رجوع واضح.', '{"before":["intensity_before"],"after":["intensity_after"],"outcome":["behavior_completed","recovery_minutes"]}'::jsonb, '{"timing":"after_event","prompt":"شو صار بعد ما جربتي الخطوة؟"}'::jsonb, 'REG_GROUND_001', false, now(),
  'reviewed', 'reviewed', false
) on conflict (code, version) do nothing;

insert into public.malaak_interventions (
  code, version, status, title_ar, short_description_ar, framework, evidence_tier, content_origin, licensing_status,
  target_needs, target_patterns, eligible_states, journey_domains, exclusions, contraindication_notes_ar, duration_min,
  steps_ar, action_template_ar, measurement_spec, follow_up_spec, fallback_code, requires_user_confirmation, activated_at,
  scientific_review_status, clinical_boundary_review_status, requires_human_support
) values (
  'REL_SOFT_START_002', 1, 'draft', 'بداية هادئة لموضوع صعب', 'بدء الحوار بوصف الموقف والحاجة بدل الاتهام الشامل.', 'couple-therapy-informed assertiveness', 'B', 'original_malaak', 'cleared_original',
  array['connection','respect']::text[], array['conflict_cycle']::text[], array['reflective','moderate_activation']::text[], array['relationship']::text[], '["Do not use direct confrontation when interpersonal violence, coercion, stalking, or credible danger may be present."]'::jsonb, 'لا تُستخدم لمواجهة شخص قد يعاقب أو يؤذي بسبب التعبير.', 7,
  '["حددي موضوع واحد.","ابدئي بما حدث بدل “أنت دائمًا”.","قولي أثره عليك وحاجتك.","اطلبي خطوة قابلة للنقاش."]'::jsonb, 'حضّري أول جملتين من الحوار بدون اتهام شامل.', '{"outcome":["behavior_completed","real_world_result"]}'::jsonb, '{"timing":"after_event","prompt":"شو صار بعد ما جربتي الخطوة؟"}'::jsonb, 'REQUEST_DIRECT_001', true, null,
  'reviewed', 'pending', false
) on conflict (code, version) do nothing;

insert into public.malaak_interventions (
  code, version, status, title_ar, short_description_ar, framework, evidence_tier, content_origin, licensing_status,
  target_needs, target_patterns, eligible_states, journey_domains, exclusions, contraindication_notes_ar, duration_min,
  steps_ar, action_template_ar, measurement_spec, follow_up_spec, fallback_code, requires_user_confirmation, activated_at,
  scientific_review_status, clinical_boundary_review_status, requires_human_support
) values (
  'REL_REPAIR_003', 1, 'draft', 'إصلاح بعد الخلاف', 'مسؤولية محددة + أثر + خطوة إصلاح بدل اعتذار فارغ.', 'couple-therapy-informed repair', 'B', 'original_malaak', 'cleared_original',
  array['connection','respect']::text[], array['conflict_cycle']::text[], array['reflective','moderate_activation']::text[], array['relationship']::text[], '["Do not use direct confrontation when interpersonal violence, coercion, stalking, or credible danger may be present."]'::jsonb, 'الإصلاح لا يعني الضغط على الطرف المتضرر للمسامحة ولا يسقط الحاجة للأمان أو الحدود.', 10,
  '["سمّي السلوك اللي تتحملي مسؤوليته.","اعترفي بالأثر بدون “بس”.","قولي شو رح تعملي بشكل مختلف.","اسألي إذا في خطوة إصلاح مناسبة للطرفين."]'::jsonb, 'اعملي إصلاح محدد: مسؤولية + أثر + تغيير.', '{"outcome":["behavior_completed","real_world_result","recovery_minutes"]}'::jsonb, '{"timing":"after_event","prompt":"شو صار بعد ما جربتي الخطوة؟"}'::jsonb, 'REQUEST_DIRECT_001', true, null,
  'reviewed', 'pending', false
) on conflict (code, version) do nothing;

insert into public.malaak_interventions (
  code, version, status, title_ar, short_description_ar, framework, evidence_tier, content_origin, licensing_status,
  target_needs, target_patterns, eligible_states, journey_domains, exclusions, contraindication_notes_ar, duration_min,
  steps_ar, action_template_ar, measurement_spec, follow_up_spec, fallback_code, requires_user_confirmation, activated_at,
  scientific_review_status, clinical_boundary_review_status, requires_human_support
) values (
  'REL_TRUST_STEP_004', 1, 'draft', 'الثقة بخطوات قابلة للملاحظة', 'بناء الثقة من الاتساق والسلوك بدل إجبار النفس على ثقة عمياء.', 'relationship coaching / behavioral consistency', 'C', 'original_malaak', 'cleared_original',
  array['connection','respect','clarity']::text[], array['conflict_cycle','attachment_alarm']::text[], array['reflective']::text[], array['relationship','healing']::text[], '["Do not use to pressure reconciliation after betrayal or abuse."]'::jsonb, 'الثقة اختيار تدريجي مبني على سلوك؛ مو واجب، وخصوصًا بعد خيانة أو أذى.', 10,
  '["حددي السلوك اللي يحتاج يصير موثوق.","شو دليل الاتساق اللي ممكن ينشاف مع الوقت؟","شو حدّك إذا الاتساق ما صار؟","راجعي الأدلة بعد فترة بدل قرار ثقة شامل الآن."]'::jsonb, 'اختاري معيار ثقة سلوكي واحد تراقبيه عبر الوقت.', '{"outcome":["real_world_result"],"after":["clarity_after"]}'::jsonb, '{"timing":"tomorrow","prompt":"شو صار بعد ما جربتي الخطوة؟"}'::jsonb, 'ATT_REALITY_002', true, null,
  'reviewed', 'pending', false
) on conflict (code, version) do nothing;

insert into public.malaak_interventions (
  code, version, status, title_ar, short_description_ar, framework, evidence_tier, content_origin, licensing_status,
  target_needs, target_patterns, eligible_states, journey_domains, exclusions, contraindication_notes_ar, duration_min,
  steps_ar, action_template_ar, measurement_spec, follow_up_spec, fallback_code, requires_user_confirmation, activated_at,
  scientific_review_status, clinical_boundary_review_status, requires_human_support
) values (
  'THOUGHT_FACTS_001', 1, 'active', 'الحدث أم التفسير؟', 'فصل ما حصل فعليًا عما أضافه العقل من معنى.', 'CBT cognitive restructuring', 'A', 'original_malaak', 'cleared_original',
  array['understanding','clarity']::text[], array['thought_fusion','attachment_alarm','conflict_cycle','unknown']::text[], array['moderate_activation','reflective','unknown']::text[], array['overthinking']::text[], '["Avoid repetitive debate when reassurance/obsessional loop is primary."]'::jsonb, 'إذا عم نعيد نفس السؤال بدون معلومة جديدة، منوقف المناقشة وننتقل للخروج من الحلقة.', 6,
  '["اكتبي حقيقة ممكن الكاميرا تسجلها.","اكتبي تفسير عقلك.","اكتبي معلومة ما زالت مجهولة.","اختاري تفسير متوازن ما يحتاج يقين مزيف."]'::jsonb, 'افصلي بين حقيقة واحدة وتفسير واحد وشي مجهول.', '{"before":["clarity_before"],"after":["clarity_after"],"outcome":["action_outcome","user_helpfulness"]}'::jsonb, '{"timing":"later_today","prompt":"شو صار بعد ما جربتي الخطوة؟"}'::jsonb, 'RUMINATION_EXIT_001', false, now(),
  'reviewed', 'reviewed', false
) on conflict (code, version) do nothing;

