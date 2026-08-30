-- Generated deterministically from supabase/functions/malaak-ai/catalog_seed.ts
-- V5 intervention cards part 1 of 8. Do not hand-edit.

insert into public.malaak_interventions (
  code, version, status, title_ar, short_description_ar, framework, evidence_tier, content_origin, licensing_status,
  target_needs, target_patterns, eligible_states, journey_domains, exclusions, contraindication_notes_ar, duration_min,
  steps_ar, action_template_ar, measurement_spec, follow_up_spec, fallback_code, requires_user_confirmation, activated_at,
  scientific_review_status, clinical_boundary_review_status, requires_human_support
) values (
  'REG_GROUND_001', 1, 'active', 'تثبيت الحاضر', 'إرجاع الانتباه للحاضر قبل القرار أو التصرف.', 'grounding / distress tolerance', 'B', 'original_malaak', 'cleared_original',
  array['regulation','safety']::text[], array['anger_escalation','attachment_alarm','reassurance_loop','rumination','unknown']::text[], array['high_activation','moderate_activation','unknown']::text[], array['emotional-state','inner-peace']::text[], '["Not trauma processing."]'::jsonb, 'إذا زاد التركيز الحسي الضيق بدل أن يخففه، انتقلي لأداة تنظيم أخرى.', 2,
  '["وقفي القرار أو الرسالة للحظة.","سمّي 3 أشياء شايفتيها وشيئين عم تلمسيهم وشي عم تسمعيه.","قيّمي إذا الشدة نزلت ولو درجة."]'::jsonb, 'خدي دقيقتين تثبيت قبل أي تصرف جديد.', '{"before":["intensity_before"],"after":["intensity_after"],"outcome":["action_outcome","user_helpfulness"]}'::jsonb, '{"timing":"later_today","prompt":"شو صار بعد ما جربتي الخطوة؟"}'::jsonb, null, false, now(),
  'reviewed', 'reviewed', false
) on conflict (code, version) do nothing;

insert into public.malaak_interventions (
  code, version, status, title_ar, short_description_ar, framework, evidence_tier, content_origin, licensing_status,
  target_needs, target_patterns, eligible_states, journey_domains, exclusions, contraindication_notes_ar, duration_min,
  steps_ar, action_template_ar, measurement_spec, follow_up_spec, fallback_code, requires_user_confirmation, activated_at,
  scientific_review_status, clinical_boundary_review_status, requires_human_support
) values (
  'REG_MOVE_002', 1, 'active', 'حركة قصيرة للتنظيم', 'استخدام حركة هادئة قصيرة لتخفيف الاستنفار.', 'behavioral regulation', 'B', 'original_malaak', 'cleared_original',
  array['regulation','rest']::text[], array['anger_escalation','rumination','control_overdrive','unknown']::text[], array['high_activation','moderate_activation']::text[], array['inner-peace','anger']::text[], '["Modify when movement is medically inappropriate."]'::jsonb, 'إذا الحركة غير مناسبة صحيًا أو تزيد الدوخة/الألم، استخدمي تثبيت الحاضر بدلها.', 5,
  '["ابتعدي عن الشاشة أو الحوار الساخن.","امشي أو حرّكي جسمك بهدوء بدون تفريغ عدواني.","ارجعي قيّمي شدتك قبل الخطوة التالية."]'::jsonb, 'اعملي حركة هادئة 5 دقائق ثم قيّمي شدتك من جديد.', '{"before":["intensity_before"],"after":["intensity_after"],"outcome":["action_outcome","user_helpfulness"]}'::jsonb, '{"timing":"later_today","prompt":"شو صار بعد ما جربتي الخطوة؟"}'::jsonb, 'REG_GROUND_001', false, now(),
  'reviewed', 'reviewed', false
) on conflict (code, version) do nothing;

insert into public.malaak_interventions (
  code, version, status, title_ar, short_description_ar, framework, evidence_tier, content_origin, licensing_status,
  target_needs, target_patterns, eligible_states, journey_domains, exclusions, contraindication_notes_ar, duration_min,
  steps_ar, action_template_ar, measurement_spec, follow_up_spec, fallback_code, requires_user_confirmation, activated_at,
  scientific_review_status, clinical_boundary_review_status, requires_human_support
) values (
  'REG_BREATHE_003', 1, 'active', 'تنفّس بطيء مريح', 'إبطاء التنفس بلطف بدون فرض نمط صارم.', 'low-intensity regulation', 'C', 'original_malaak', 'cleared_original',
  array['regulation','rest']::text[], array['unknown','rumination','anger_escalation']::text[], array['moderate_activation','high_activation']::text[], array['emotional-state','inner-peace']::text[], '["Stop if breath focus increases panic, dizziness, or distress."]'::jsonb, 'مو مطلوب تعملي حبس نفس أو أرقام قاسية. إذا التركيز على النفس بيوترك، منبدّل الأداة فورًا.', 2,
  '["خلي الزفير أبطأ شوي من المعتاد بدون إجبار.","اعملي عدة أنفاس مريحة فقط.","إذا زاد الضيق، وقفي وانتقلي للتثبيت الحسي."]'::jsonb, 'جربي دقيقتين تنفّس مريح فقط إذا جسمك متقبله.', '{"before":["intensity_before"],"after":["intensity_after"],"outcome":["action_outcome","user_helpfulness"]}'::jsonb, '{"timing":"later_today","prompt":"شو صار بعد ما جربتي الخطوة؟"}'::jsonb, 'REG_GROUND_001', true, now(),
  'reviewed', 'reviewed', false
) on conflict (code, version) do nothing;

insert into public.malaak_interventions (
  code, version, status, title_ar, short_description_ar, framework, evidence_tier, content_origin, licensing_status,
  target_needs, target_patterns, eligible_states, journey_domains, exclusions, contraindication_notes_ar, duration_min,
  steps_ar, action_template_ar, measurement_spec, follow_up_spec, fallback_code, requires_user_confirmation, activated_at,
  scientific_review_status, clinical_boundary_review_status, requires_human_support
) values (
  'EMO_NAME_001', 1, 'active', 'سمّي الشعور تقريبًا', 'تحديد عائلة الشعور بدون ضغط للوصول لكلمة مثالية.', 'emotion awareness / emotion regulation', 'B', 'original_malaak', 'cleared_original',
  array['understanding','clarity']::text[], array['unknown','unmet_need','anger_escalation']::text[], array['moderate_activation','reflective','unknown']::text[], array['emotional-state']::text[], '["Do not force precision or interpret the emotion as diagnosis."]'::jsonb, 'إذا ما قدرتي تسمّيه، منبدأ من الجسم أو الرغبة بالسلوك بدل التخمين.', 3,
  '["اختاري أقرب عائلة: خوف/غضب/حزن/خجل/غيرة/راحة/غيرها.","قولي قدّيش شدته تقريبًا.","اتركي احتمال إن الاسم يتغير بعد ما نفهم الموقف."]'::jsonb, 'سمّي أقرب شعور وشدته، حتى لو الاسم مو مثالي.', '{"before":["clarity_before"],"after":["clarity_after"],"outcome":["action_outcome","user_helpfulness"]}'::jsonb, '{"timing":"later_today","prompt":"بعد ما سميتي الشعور، صار أوضح شو محتاجة؟"}'::jsonb, 'REG_GROUND_001', false, now(),
  'reviewed', 'reviewed', false
) on conflict (code, version) do nothing;

insert into public.malaak_interventions (
  code, version, status, title_ar, short_description_ar, framework, evidence_tier, content_origin, licensing_status,
  target_needs, target_patterns, eligible_states, journey_domains, exclusions, contraindication_notes_ar, duration_min,
  steps_ar, action_template_ar, measurement_spec, follow_up_spec, fallback_code, requires_user_confirmation, activated_at,
  scientific_review_status, clinical_boundary_review_status, requires_human_support
) values (
  'EMO_CHAIN_002', 1, 'active', 'سلسلة الموقف والمشاعر', 'فصل الحدث والتفسير والمشاعر والجسم والرغبة والسلوك.', 'CBT-informed emotion chain', 'B', 'original_malaak', 'cleared_original',
  array['understanding','clarity']::text[], array['anger_escalation','conflict_cycle','thought_fusion','unknown']::text[], array['moderate_activation','reflective']::text[], array['emotional-state','anger']::text[], '["Not for deep trauma reconstruction."]'::jsonb, 'منستخدم الحاضر والمعلومات المعروفة فقط، وما منرجّعك لذكريات صادمة للتفسير.', 7,
  '["شو صار كحدث؟","شو فسّره عقلك؟","شو شعرتي بالجسم والمشاعر؟","شو كانت الرغبة؟","شو عملتي أو بدك تعملي؟"]'::jsonb, 'اكتبي السلسلة بخمس أسطر قبل ما تحكمي على حالك.', '{"before":["clarity_before"],"after":["clarity_after"],"outcome":["action_outcome","user_helpfulness"]}'::jsonb, '{"timing":"tomorrow","prompt":"أي جزء من السلسلة كان أسهل نقطة للتغيير؟"}'::jsonb, 'THOUGHT_FACTS_001', false, now(),
  'reviewed', 'reviewed', false
) on conflict (code, version) do nothing;

insert into public.malaak_interventions (
  code, version, status, title_ar, short_description_ar, framework, evidence_tier, content_origin, licensing_status,
  target_needs, target_patterns, eligible_states, journey_domains, exclusions, contraindication_notes_ar, duration_min,
  steps_ar, action_template_ar, measurement_spec, follow_up_spec, fallback_code, requires_user_confirmation, activated_at,
  scientific_review_status, clinical_boundary_review_status, requires_human_support
) values (
  'LOAD_SORT_001', 1, 'active', 'الآن / لاحقًا / مو بإيدي', 'ترتيب الحمل بدل التعامل مع كل شيء كأنه عاجل.', 'problem solving / prioritization', 'B', 'original_malaak', 'cleared_original',
  array['clarity','rest','autonomy']::text[], array['control_overdrive','practical_problem','rumination']::text[], array['moderate_activation','reflective','unknown']::text[], array['inner-peace']::text[], '["Do not classify safety threats as “not in my control” and ignore them."]'::jsonb, 'إذا في خطر أو التزام عاجل حقيقي، الأولوية للسلامة/الفعل الضروري.', 6,
  '["اكتبي الأشياء اللي فوق بعض.","حطي كل واحدة: الآن / لاحقًا / مو بإيدي الآن.","اختاري شي واحد فقط من خانة الآن."]'::jsonb, 'رتّبي الحمل بثلاث خانات وخدي مهمة واحدة فقط هلق.', '{"before":["clarity_before"],"after":["clarity_after"],"outcome":["action_outcome","user_helpfulness"]}'::jsonb, '{"timing":"later_today","prompt":"شو صار بعد ما جربتي الخطوة؟"}'::jsonb, 'PROBLEM_SOLVE_001', false, now(),
  'reviewed', 'reviewed', false
) on conflict (code, version) do nothing;

