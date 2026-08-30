-- Generated deterministically from supabase/functions/malaak-ai/catalog_seed.ts
-- V5 intervention cards part 2 of 8. Do not hand-edit.

insert into public.malaak_interventions (
  code, version, status, title_ar, short_description_ar, framework, evidence_tier, content_origin, licensing_status,
  target_needs, target_patterns, eligible_states, journey_domains, exclusions, contraindication_notes_ar, duration_min,
  steps_ar, action_template_ar, measurement_spec, follow_up_spec, fallback_code, requires_user_confirmation, activated_at,
  scientific_review_status, clinical_boundary_review_status, requires_human_support
) values (
  'CONTROL_CIRCLE_001', 1, 'active', 'شو بإيدي وشو مو بإيدي', 'تمييز الفعل الممكن عن محاولة السيطرة على غير القابل للسيطرة.', 'problem solving / psychological flexibility', 'B', 'original_malaak', 'cleared_original',
  array['autonomy','clarity']::text[], array['control_overdrive','rumination','practical_problem']::text[], array['moderate_activation','reflective','unknown']::text[], array['inner-peace','feminine-balance']::text[], '["Does not mean accepting abuse, danger, or rights violations without action."]'::jsonb, 'القبول بعدم السيطرة على شخص ما لا يعني التنازل عن الحدود أو طلب الحماية.', 6,
  '["حددي الشي اللي بدك تتحكمي فيه.","شو جزء فعلي بإيدك؟","شو جزء قرار شخص آخر أو واقع ما فيكي تضمنيه؟","اعملي فعل واحد بإيدك واتركي الباقي بدون مطاردة."]'::jsonb, 'اختاري فعل واحد تحت سيطرتك واتركي محاولة إدارة رد فعل الآخر.', '{"before":["clarity_before"],"after":["clarity_after"],"outcome":["action_outcome","user_helpfulness"]}'::jsonb, '{"timing":"tomorrow","prompt":"شو صار بعد ما جربتي الخطوة؟"}'::jsonb, 'PROBLEM_SOLVE_001', false, now(),
  'reviewed', 'reviewed', false
) on conflict (code, version) do nothing;

insert into public.malaak_interventions (
  code, version, status, title_ar, short_description_ar, framework, evidence_tier, content_origin, licensing_status,
  target_needs, target_patterns, eligible_states, journey_domains, exclusions, contraindication_notes_ar, duration_min,
  steps_ar, action_template_ar, measurement_spec, follow_up_spec, fallback_code, requires_user_confirmation, activated_at,
  scientific_review_status, clinical_boundary_review_status, requires_human_support
) values (
  'REST_RECOVERY_001', 1, 'active', 'حد أدنى للتعافي اليوم', 'خطة صغيرة للراحة عندما الحمل أعلى من قدرة اليوم.', 'behavioral self-care / recovery planning', 'C', 'original_malaak', 'cleared_original',
  array['rest','support']::text[], array['control_overdrive','anger_escalation','unknown']::text[], array['moderate_activation','reflective','unknown']::text[], array['inner-peace','feminine-balance']::text[], '["Not a medical treatment for persistent fatigue, insomnia, or other health symptoms."]'::jsonb, 'إذا التعب شديد/مستمر أو معه أعراض صحية مقلقة، التطبيق ما بيستبدل التقييم الطبي.', 5,
  '["حددي شو الضروري جدًا اليوم.","شيلِي أو أجّلي شي واحد غير ضروري.","اختاري استراحة قصيرة واقعية أو اطلبي دعمًا محددًا."]'::jsonb, 'خففي حمل واحد وخدي استراحة واقعية صغيرة اليوم.', '{"before":["intensity_before"],"after":["intensity_after"],"outcome":["action_outcome","user_helpfulness"]}'::jsonb, '{"timing":"tomorrow","prompt":"هل خف الحمل فعلًا ولا بقيت الخطة على الورق؟"}'::jsonb, 'LOAD_SORT_001', false, now(),
  'reviewed', 'reviewed', false
) on conflict (code, version) do nothing;

insert into public.malaak_interventions (
  code, version, status, title_ar, short_description_ar, framework, evidence_tier, content_origin, licensing_status,
  target_needs, target_patterns, eligible_states, journey_domains, exclusions, contraindication_notes_ar, duration_min,
  steps_ar, action_template_ar, measurement_spec, follow_up_spec, fallback_code, requires_user_confirmation, activated_at,
  scientific_review_status, clinical_boundary_review_status, requires_human_support
) values (
  'NEED_NAME_001', 1, 'active', 'سمّي الحاجة', 'فهم الشي الناقص قبل اختيار الحل.', 'needs clarification / self-determination-informed', 'B', 'original_malaak', 'cleared_original',
  array['understanding','connection','rest','respect','autonomy','support']::text[], array['unmet_need','people_pleasing','conflict_cycle','unknown']::text[], array['moderate_activation','reflective','unknown']::text[], array['needs']::text[], '["A need does not create entitlement to control another person."]'::jsonb, 'منميّز بين صحة الحاجة وبين حق الشخص الآخر بالقبول أو الرفض ضمن الأمان والحقوق.', 5,
  '["سمّي الشعور الأقرب.","اسألي شو كان ناقص بالموقف.","اختاري كلمة حاجة: راحة/قرب/وضوح/احترام/استقلال/دعم/غيرها."]'::jsonb, 'سمّي حاجتك بكلمة واضحة قبل ما تختاري الحل.', '{"before":["clarity_before"],"after":["clarity_after"],"outcome":["action_outcome","user_helpfulness"]}'::jsonb, '{"timing":"later_today","prompt":"شو صار بعد ما جربتي الخطوة؟"}'::jsonb, 'THOUGHT_FACTS_001', false, now(),
  'reviewed', 'reviewed', false
) on conflict (code, version) do nothing;

insert into public.malaak_interventions (
  code, version, status, title_ar, short_description_ar, framework, evidence_tier, content_origin, licensing_status,
  target_needs, target_patterns, eligible_states, journey_domains, exclusions, contraindication_notes_ar, duration_min,
  steps_ar, action_template_ar, measurement_spec, follow_up_spec, fallback_code, requires_user_confirmation, activated_at,
  scientific_review_status, clinical_boundary_review_status, requires_human_support
) values (
  'NEED_STRATEGY_002', 1, 'active', 'الحاجة مو هي الحل', 'فصل الحاجة عن الاستراتيجية التي نطلبها من الآخر.', 'needs clarification / autonomy-supportive coaching', 'C', 'original_malaak', 'cleared_original',
  array['understanding','autonomy','connection']::text[], array['unmet_need','reassurance_loop','control_overdrive']::text[], array['moderate_activation','reflective','unknown']::text[], array['needs']::text[], '["Do not use to minimize legitimate agreements, duties, or safety needs."]'::jsonb, 'مثلاً الأمان حاجة؛ مراقبة هاتف شخص آخر استراتيجية مو حق تلقائي.', 5,
  '["اكتبي الشي اللي بدك الشخص يعمله.","اسألي: شو الحاجة تحته؟","طلّعي طريقتين أو ثلاث لتلبية جزء من الحاجة بدون السيطرة على الآخر."]'::jsonb, 'حوّلي طلبك من “لازم تعمل” إلى الحاجة اللي عم تحاولي تلبيها.', '{"before":["clarity_before"],"after":["clarity_after"],"outcome":["action_outcome","user_helpfulness"]}'::jsonb, '{"timing":"tomorrow","prompt":"شو صار بعد ما جربتي الخطوة؟"}'::jsonb, 'NEED_NAME_001', false, now(),
  'reviewed', 'reviewed', false
) on conflict (code, version) do nothing;

insert into public.malaak_interventions (
  code, version, status, title_ar, short_description_ar, framework, evidence_tier, content_origin, licensing_status,
  target_needs, target_patterns, eligible_states, journey_domains, exclusions, contraindication_notes_ar, duration_min,
  steps_ar, action_template_ar, measurement_spec, follow_up_spec, fallback_code, requires_user_confirmation, activated_at,
  scientific_review_status, clinical_boundary_review_status, requires_human_support
) values (
  'REQUEST_DIRECT_001', 1, 'active', 'طلب مباشر بدون لوم', 'طلب سلوك محدد بدل النقد أو قراءة النوايا.', 'assertiveness / interpersonal effectiveness', 'B', 'original_malaak', 'cleared_original',
  array['connection','respect','support']::text[], array['unmet_need','conflict_cycle','people_pleasing']::text[], array['moderate_activation','reflective']::text[], array['needs','relationship']::text[], '["Do not use direct confrontation when interpersonal violence, coercion, stalking, or credible danger may be present."]'::jsonb, 'إذا في خوف من عنف أو انتقام أو إكراه، ما منستخدم مواجهة مباشرة كحل.', 5,
  '["اذكري الحدث بدون حكم.","قولي تجربتك أو شعورك باختصار.","سمّي الحاجة.","اطلبي سلوك محدد وقابل للقبول أو الرفض."]'::jsonb, 'حوّلي حاجتك لطلب واحد محدد بدون اتهام.', '{"before":["clarity_before"],"after":["clarity_after"],"outcome":["behavior_completed","real_world_result"]}'::jsonb, '{"timing":"after_event","prompt":"شو صار لما طلبتي بشكل مباشر؟"}'::jsonb, 'NEED_NAME_001', false, now(),
  'reviewed', 'reviewed', false
) on conflict (code, version) do nothing;

insert into public.malaak_interventions (
  code, version, status, title_ar, short_description_ar, framework, evidence_tier, content_origin, licensing_status,
  target_needs, target_patterns, eligible_states, journey_domains, exclusions, contraindication_notes_ar, duration_min,
  steps_ar, action_template_ar, measurement_spec, follow_up_spec, fallback_code, requires_user_confirmation, activated_at,
  scientific_review_status, clinical_boundary_review_status, requires_human_support
) values (
  'BOUNDARY_001', 1, 'active', 'حد واضح وقصير', 'تحديد ما تقبلينه وما لا تقبلينه بدون تبرير طويل.', 'assertiveness / boundaries', 'B', 'original_malaak', 'cleared_original',
  array['boundary','autonomy','respect']::text[], array['people_pleasing','control_overdrive','conflict_cycle']::text[], array['moderate_activation','reflective','unknown']::text[], array['needs']::text[], '["Do not use direct confrontation when interpersonal violence, coercion, stalking, or credible danger may be present."]'::jsonb, 'الحد مو بديل عن خطة أمان إذا الطرف الآخر خطير.', 5,
  '["حددي السلوك المقبول وغير المقبول بالنسبة إلك.","صيغي جملة قصيرة وواضحة.","ما تدخلي بتبرير لا ينتهي."]'::jsonb, 'اكتبي جملة حد قصيرة تقدري تلتزمي فيها.', '{"before":["urge_before"],"after":["urge_after"],"outcome":["behavior_completed","real_world_result"]}'::jsonb, '{"timing":"after_event","prompt":"قدرتي تحافظي على الحد؟ شو صار بعدها؟"}'::jsonb, 'NEED_NAME_001', false, now(),
  'reviewed', 'reviewed', false
) on conflict (code, version) do nothing;

