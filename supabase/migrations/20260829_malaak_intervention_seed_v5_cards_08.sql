-- Generated deterministically from supabase/functions/malaak-ai/catalog_seed.ts
-- V5 intervention cards part 8 of 8. Do not hand-edit.

insert into public.malaak_interventions (
  code, version, status, title_ar, short_description_ar, framework, evidence_tier, content_origin, licensing_status,
  target_needs, target_patterns, eligible_states, journey_domains, exclusions, contraindication_notes_ar, duration_min,
  steps_ar, action_template_ar, measurement_spec, follow_up_spec, fallback_code, requires_user_confirmation, activated_at,
  scientific_review_status, clinical_boundary_review_status, requires_human_support
) values (
  'BAL_WAR_MODE_001', 1, 'active', 'هل أنا بوضع حرب؟', 'تسمية حالة overdrive/دفاع ضمن نموذج Coaching بدون ادعاء أنها آلية أنثوية بيولوجية.', 'coaching_model / stress-overdrive reflection', 'D', 'coaching_only_original_malaak', 'cleared_original',
  array['clarity','rest','autonomy']::text[], array['control_overdrive','anger_escalation']::text[], array['moderate_activation','reflective','unknown']::text[], array['feminine-balance']::text[], '["Do not present feminine/masculine energy as established biology or clinical construct."]'::jsonb, 'القوة والحزم مو مشكلة بحد ذاتهم؛ السؤال عن الجمود والاستنفار والتكلفة.', 6,
  '["شو جسمك عم يعمل: شد/سرعة/استنفار؟","شو السلوك: سيطرة/نقد/استعجال/تحمل كل شي؟","هل الوضع فعلًا يحتاج قوة الآن ولا عادة الحرب اشتغلت؟"]'::jsonb, 'سمّي سلوك حرب واحد شغال هلق ووقفيه إذا مو ضروري.', '{"before":["clarity_before"],"after":["clarity_after"],"outcome":["action_outcome","user_helpfulness"]}'::jsonb, '{"timing":"later_today","prompt":"شو صار بعد ما جربتي الخطوة؟"}'::jsonb, 'CONTROL_CIRCLE_001', false, now(),
  'reviewed', 'reviewed', false
) on conflict (code, version) do nothing;

insert into public.malaak_interventions (
  code, version, status, title_ar, short_description_ar, framework, evidence_tier, content_origin, licensing_status,
  target_needs, target_patterns, eligible_states, journey_domains, exclusions, contraindication_notes_ar, duration_min,
  steps_ar, action_template_ar, measurement_spec, follow_up_spec, fallback_code, requires_user_confirmation, activated_at,
  scientific_review_status, clinical_boundary_review_status, requires_human_support
) values (
  'BAL_CONTROL_RESP_002', 1, 'active', 'سيطرة أم مسؤولية؟', 'الحفاظ على المسؤولية مع ترك إدارة كل تفاصيل الآخرين.', 'coaching_model / problem-solving and flexibility', 'D', 'coaching_only_original_malaak', 'cleared_original',
  array['autonomy','clarity']::text[], array['control_overdrive']::text[], array['moderate_activation','reflective']::text[], array['feminine-balance']::text[], '["Does not ask users to surrender legitimate responsibility or safety decisions."]'::jsonb, 'إذا المسؤولية قانونية/أبوية/مهنية فعلية، منحددها بوضوح وما منسميها سيطرة.', 7,
  '["شو مسؤوليتك الفعلية؟","شو الجزء اللي عم تديري فيه شخص ثاني؟","شو نتيجة جيدة كفاية بدل الكمال؟","اتركي تفصيل واحد لغيرك مع حد واضح."]'::jsonb, 'اعملي مسؤوليتك واتركي تفصيل واحد مو لازم تتحكمي فيه.', '{"outcome":["behavior_completed"],"before":["urge_before"],"after":["urge_after"]}'::jsonb, '{"timing":"after_event","prompt":"شو صار بعد ما جربتي الخطوة؟"}'::jsonb, 'CONTROL_CIRCLE_001', false, now(),
  'reviewed', 'reviewed', false
) on conflict (code, version) do nothing;

insert into public.malaak_interventions (
  code, version, status, title_ar, short_description_ar, framework, evidence_tier, content_origin, licensing_status,
  target_needs, target_patterns, eligible_states, journey_domains, exclusions, contraindication_notes_ar, duration_min,
  steps_ar, action_template_ar, measurement_spec, follow_up_spec, fallback_code, requires_user_confirmation, activated_at,
  scientific_review_status, clinical_boundary_review_status, requires_human_support
) values (
  'BAL_RECEIVE_REST_003', 1, 'active', 'استقبال وراحة بدون فقد الذات', 'تجربة مساعدة/راحة صغيرة بدون تحويلها لاتكالية أو “أنوثة واجبة”.', 'coaching_model / recovery and receiving support', 'D', 'coaching_only_original_malaak', 'cleared_original',
  array['rest','support','connection']::text[], array['control_overdrive']::text[], array['moderate_activation','reflective','unknown']::text[], array['feminine-balance']::text[], '["Do not frame passivity, financial dependence, or surrender of rights as femininity."]'::jsonb, 'الاستقبال اختيار، والاستقلال والقدرة على الرفض بيضلوا موجودين.', 6,
  '["اختاري مساعدة صغيرة آمنة ممكن تقبليها.","لاحظي إذا بيطلع ذنب/حاجة للرد فورًا.","اسمحي بالمساعدة بدون دين عاطفي تلقائي."]'::jsonb, 'اقبلي مساعدة صغيرة اليوم بدون ما ترجعي تدفعي ثمنها فورًا.', '{"outcome":["behavior_completed"],"before":["urge_before"],"after":["urge_after"]}'::jsonb, '{"timing":"after_event","prompt":"شو صار بعد ما جربتي الخطوة؟"}'::jsonb, 'REST_RECOVERY_001', false, now(),
  'reviewed', 'reviewed', false
) on conflict (code, version) do nothing;

insert into public.malaak_interventions (
  code, version, status, title_ar, short_description_ar, framework, evidence_tier, content_origin, licensing_status,
  target_needs, target_patterns, eligible_states, journey_domains, exclusions, contraindication_notes_ar, duration_min,
  steps_ar, action_template_ar, measurement_spec, follow_up_spec, fallback_code, requires_user_confirmation, activated_at,
  scientific_review_status, clinical_boundary_review_status, requires_human_support
) values (
  'FI_STATE_COMPASS_001', 1, 'active', 'شو الحالة اللي عم تقودني؟', 'استخدام نموذج الحالات الأربع كعدسة Coaching سياقية لا كتشخيص أو هوية.', 'coaching_model / feminine-intelligence taxonomy', 'D', 'coaching_only_original_malaak', 'cleared_original',
  array['clarity','autonomy']::text[], array['people_pleasing','control_overdrive','unknown']::text[], array['reflective','moderate_activation','unknown']::text[], array['feminine-intelligence']::text[], '["Taxonomy is not a validated psychological construct; never show a percentage or fixed identity label."]'::jsonb, 'النتيجة “يميل سلوكك بهالسياق” فقط، وما منعتبر الذكاء الذكوري مشكلة لازم تختفي.', 7,
  '["هل عم تفقدي نفسك لإرضاء الآخر؟","هل عم تحاولي تتحكمي بكل شي تحت ضغط؟","هل عم تستخدمي الحسم/الواقعية بمرونة؟","هل في قوة + حدود + مرونة + اتصال بالمشاعر؟"]'::jsonb, 'سمّي الحالة الأقرب لهالموقف فقط، مو لشخصيتك كلها.', '{"before":["clarity_before"],"after":["clarity_after"],"outcome":["action_outcome","user_helpfulness"]}'::jsonb, '{"timing":"tomorrow","prompt":"شو صار بعد ما جربتي الخطوة؟"}'::jsonb, 'CONTROL_CIRCLE_001', true, now(),
  'reviewed', 'reviewed', false
) on conflict (code, version) do nothing;

insert into public.malaak_interventions (
  code, version, status, title_ar, short_description_ar, framework, evidence_tier, content_origin, licensing_status,
  target_needs, target_patterns, eligible_states, journey_domains, exclusions, contraindication_notes_ar, duration_min,
  steps_ar, action_template_ar, measurement_spec, follow_up_spec, fallback_code, requires_user_confirmation, activated_at,
  scientific_review_status, clinical_boundary_review_status, requires_human_support
) values (
  'FI_TIME_DISTANCE_002', 1, 'active', 'الوقت والمسافة قبل الرد', 'إضافة توقيت ومسافة منظورية قبل القرار ضمن نموذج البوصلة.', 'coaching_model / perspective and timing', 'D', 'coaching_only_original_malaak', 'cleared_original',
  array['clarity','decision']::text[], array['anger_escalation','rumination','control_overdrive']::text[], array['moderate_activation','reflective']::text[], array['feminine-intelligence']::text[], '["Do not delay urgent safety, legal, medical, or time-sensitive action."]'::jsonb, 'المسافة مو انسحاب عقابي، والوقت مو تأجيل دائم للمشكلة.', 6,
  '["هل لازم أتصرف هلق فعلًا؟","شو بيتغير لو شفت الموقف من أسبوع لقدام؟","شو المهم بعيدًا عن حرارة اللحظة؟"]'::jsonb, 'اختاري إذا هاد وقت فعل أو وقت تهدئة وجمع منظور.', '{"before":["clarity_before"],"after":["clarity_after"],"outcome":["action_outcome","user_helpfulness"]}'::jsonb, '{"timing":"later_today","prompt":"شو صار بعد ما جربتي الخطوة؟"}'::jsonb, 'LOAD_SORT_001', false, now(),
  'reviewed', 'reviewed', false
) on conflict (code, version) do nothing;

insert into public.malaak_interventions (
  code, version, status, title_ar, short_description_ar, framework, evidence_tier, content_origin, licensing_status,
  target_needs, target_patterns, eligible_states, journey_domains, exclusions, contraindication_notes_ar, duration_min,
  steps_ar, action_template_ar, measurement_spec, follow_up_spec, fallback_code, requires_user_confirmation, activated_at,
  scientific_review_status, clinical_boundary_review_status, requires_human_support
) values (
  'FI_EMOTION_INTENTION_003', 1, 'active', 'المشاعر والنية', 'اعتبار الشعور معلومة ثم توضيح الهدف الحقيقي قبل التصرف.', 'coaching_model / emotion-informed intentional action', 'D', 'coaching_only_original_malaak', 'cleared_original',
  array['clarity','decision','respect']::text[], array['anger_escalation','people_pleasing','control_overdrive','unknown']::text[], array['moderate_activation','reflective']::text[], array['feminine-intelligence']::text[], '["Emotion is information, not proof; intention is a goal, not manifestation or magical causation."]'::jsonb, 'النية ما بتضمن النتيجة ولا “تجذب” الواقع؛ هي بس بتوضح شو النتيجة اللي بدك تخدميها.', 6,
  '["شو الشعور عم يخبرك؟","شو ما بيثبته الشعور؟","شو هدفك الحقيقي: انتقام/كرامة/إصلاح/حماية/وضوح؟","اختاري فعل يخدم الهدف."]'::jsonb, 'سمّي الشعور وبعدين سمّي الهدف الحقيقي قبل أي رد.', '{"before":["clarity_before"],"after":["clarity_after"],"outcome":["action_outcome","user_helpfulness"]}'::jsonb, '{"timing":"later_today","prompt":"شو صار بعد ما جربتي الخطوة؟"}'::jsonb, 'EMO_NAME_001', false, now(),
  'reviewed', 'reviewed', false
) on conflict (code, version) do nothing;

