-- Generated deterministically from supabase/functions/malaak-ai/catalog_seed.ts
-- V5 intervention cards part 7 of 8. Do not hand-edit.

insert into public.malaak_interventions (
  code, version, status, title_ar, short_description_ar, framework, evidence_tier, content_origin, licensing_status,
  target_needs, target_patterns, eligible_states, journey_domains, exclusions, contraindication_notes_ar, duration_min,
  steps_ar, action_template_ar, measurement_spec, follow_up_spec, fallback_code, requires_user_confirmation, activated_at,
  scientific_review_status, clinical_boundary_review_status, requires_human_support
) values (
  'CHILD_PATTERN_EXPERIMENT_004', 1, 'draft', 'جرّبي عكس القاعدة القديمة بخطوة صغيرة', 'تجربة سلوكية منخفضة المخاطر لاختبار قاعدة قديمة بالحاضر.', 'CBT behavioral experiment / schema-informed coaching', 'B', 'original_malaak', 'cleared_original',
  array['autonomy','boundary','clarity']::text[], array['people_pleasing','control_overdrive','thought_fusion']::text[], array['reflective']::text[], array['childhood']::text[], '["Do not use for trauma exposure, memory recovery, imaginal reliving, EMDR, or to infer that a hidden event must have occurred.","Only low-risk present-day behavioral experiments; never exposure to traumatic memories."]'::jsonb, 'التجربة تكون بالحاضر وبموقف آمن وقابل للتراجع، مو مواجهة خطر أو صدمة.', 12,
  '["سمّي القاعدة القديمة وتوقعها.","اختاري خطوة صغيرة آمنة بعكسها.","اكتبي شو بتتوقعي يصير.","اعملي التجربة وسجلي شو صار فعلًا."]'::jsonb, 'اختاري تجربة صغيرة آمنة تختبر قاعدة قديمة بالحاضر.', '{"before":["belief_before"],"after":["belief_after"],"outcome":["behavior_completed","real_world_result"]}'::jsonb, '{"timing":"after_event","prompt":"شو صار بعد ما جربتي الخطوة؟"}'::jsonb, 'BOUNDARY_001', true, null,
  'reviewed', 'pending', false
) on conflict (code, version) do nothing;

insert into public.malaak_interventions (
  code, version, status, title_ar, short_description_ar, framework, evidence_tier, content_origin, licensing_status,
  target_needs, target_patterns, eligible_states, journey_domains, exclusions, contraindication_notes_ar, duration_min,
  steps_ar, action_template_ar, measurement_spec, follow_up_spec, fallback_code, requires_user_confirmation, activated_at,
  scientific_review_status, clinical_boundary_review_status, requires_human_support
) values (
  'HEAL_STABILIZE_001', 1, 'draft', 'ثبّت حياتك قبل تحليل القصة', 'حماية النوم/الوظائف اليومية وتقليل الاندفاع قبل تحليل جرح عاطفي.', 'trauma-informed stabilization coaching', 'C', 'original_malaak', 'cleared_original',
  array['regulation','rest','support']::text[], array['rumination','attachment_alarm','anger_escalation']::text[], array['high_activation','moderate_activation']::text[], array['healing']::text[], '["Do not use for trauma exposure, memory recovery, imaginal reliving, EMDR, or to infer that a hidden event must have occurred."]'::jsonb, 'إذا في PTSD محتمل شديد، تفكك، إيذاء نفس، أو تعطّل كبير، ما منفتح معالجة ذاتية عميقة ونوصي بتقييم متخصص.', 8,
  '["شو الوظيفة الأساسية اللي عم تنهار: نوم/أكل/شغل/أطفال؟","اختاري حماية واحدة لليوم.","خففي محفز ذاتي واحد مثل مراقبة مستمرة.","حددي شخص دعم أو مساعدة عملية إذا متاحة."]'::jsonb, 'احمي وظيفة أساسية اليوم قبل أي تحليل إضافي.', '{"outcome":["behavior_completed","recovery_minutes"],"before":["intensity_before"],"after":["intensity_after"]}'::jsonb, '{"timing":"tomorrow","prompt":"شو صار بعد ما جربتي الخطوة؟"}'::jsonb, 'REST_RECOVERY_001', true, null,
  'reviewed', 'pending', false
) on conflict (code, version) do nothing;

insert into public.malaak_interventions (
  code, version, status, title_ar, short_description_ar, framework, evidence_tier, content_origin, licensing_status,
  target_needs, target_patterns, eligible_states, journey_domains, exclusions, contraindication_notes_ar, duration_min,
  steps_ar, action_template_ar, measurement_spec, follow_up_spec, fallback_code, requires_user_confirmation, activated_at,
  scientific_review_status, clinical_boundary_review_status, requires_human_support
) values (
  'HEAL_FACTS_STORY_002', 1, 'draft', 'شو صار وشو قصتي عنه', 'فصل الوقائع والتفسير والمسؤوليات والمجهول بعد جرح عاطفي.', 'CBT-informed relational injury reflection', 'B', 'original_malaak', 'cleared_original',
  array['clarity','respect']::text[], array['rumination','thought_fusion']::text[], array['reflective','moderate_activation']::text[], array['healing']::text[], '["Do not use for trauma exposure, memory recovery, imaginal reliving, EMDR, or to infer that a hidden event must have occurred."]'::jsonb, 'مو جلسة كشف حقيقة مخفية ولا تحقيق قهري؛ إذا المعلومات غير متاحة، منترك “المجهول” موجود.', 10,
  '["شو الوقائع المعروفة؟","شو تفسيرك؟","شو مسؤوليتك الفعلية؟","شو مسؤولية الطرف الآخر؟","شو ما زال مجهول؟"]'::jsonb, 'رتّبي القصة لخمس خانات: حقيقة/تفسير/مسؤوليتي/مسؤوليته/مجهول.', '{"before":["clarity_before"],"after":["clarity_after"],"outcome":["action_outcome","user_helpfulness"]}'::jsonb, '{"timing":"tomorrow","prompt":"شو صار بعد ما جربتي الخطوة؟"}'::jsonb, 'THOUGHT_FACTS_001', true, null,
  'reviewed', 'pending', false
) on conflict (code, version) do nothing;

insert into public.malaak_interventions (
  code, version, status, title_ar, short_description_ar, framework, evidence_tier, content_origin, licensing_status,
  target_needs, target_patterns, eligible_states, journey_domains, exclusions, contraindication_notes_ar, duration_min,
  steps_ar, action_template_ar, measurement_spec, follow_up_spec, fallback_code, requires_user_confirmation, activated_at,
  scientific_review_status, clinical_boundary_review_status, requires_human_support
) values (
  'HEAL_GRIEF_003', 1, 'draft', 'شو خسرت فعلًا؟', 'تحديد أوجه الخسارة بدون فرض مراحل حزن ثابتة أو إجبار على النسيان.', 'grief-informed coaching', 'B', 'original_malaak', 'cleared_original',
  array['understanding','support']::text[], array['rumination','attachment_alarm']::text[], array['reflective','moderate_activation']::text[], array['healing']::text[], '["Do not use for trauma exposure, memory recovery, imaginal reliving, EMDR, or to infer that a hidden event must have occurred.","Not a treatment protocol for prolonged grief disorder."]'::jsonb, 'إذا الحزن شديد ومستمر ومُعطّل بشكل كبير، نوصي بتقييم مختص بدل زيادة تمارين ذاتية.', 10,
  '["اكتبي شو خسرتي غير الشخص نفسه: مستقبل/روتين/هوية/أمان/مجتمع.","اختاري أكثر خسارة مؤلمة اليوم.","اسألي شو تحتاج هاي الخسارة: وقت/دعم/قرار/تغيير روتين."]'::jsonb, 'سمّي أكثر شي خسرتيه فعلًا بدل اختصار كل الألم بـ“اشتقتله”.', '{"before":["clarity_before"],"after":["clarity_after"],"outcome":["action_outcome","user_helpfulness"]}'::jsonb, '{"timing":"tomorrow","prompt":"شو صار بعد ما جربتي الخطوة؟"}'::jsonb, 'EMO_NAME_001', true, null,
  'reviewed', 'pending', false
) on conflict (code, version) do nothing;

insert into public.malaak_interventions (
  code, version, status, title_ar, short_description_ar, framework, evidence_tier, content_origin, licensing_status,
  target_needs, target_patterns, eligible_states, journey_domains, exclusions, contraindication_notes_ar, duration_min,
  steps_ar, action_template_ar, measurement_spec, follow_up_spec, fallback_code, requires_user_confirmation, activated_at,
  scientific_review_status, clinical_boundary_review_status, requires_human_support
) values (
  'HEAL_SELF_WORTH_004', 1, 'draft', 'قرار شخص مو مقياس لقيمتي', 'فصل الرفض/الخيانة/الانفصال عن حكم شامل على قيمة الذات.', 'CBT / self-compassion informed coaching', 'B', 'original_malaak', 'cleared_original',
  array['respect','support','clarity']::text[], array['thought_fusion','attachment_alarm']::text[], array['reflective','moderate_activation']::text[], array['healing']::text[], '["Do not use for trauma exposure, memory recovery, imaginal reliving, EMDR, or to infer that a hidden event must have occurred."]'::jsonb, 'نقدر نتعلم من أخطائنا بالعلاقة بدون تحويل قرار شخص آخر لقياس لقيمتنا الإنسانية.', 8,
  '["اكتبي الحدث.","اكتبي الحكم اللي صار على قيمتك.","شو أشياء ممكن نتعلم منها فعلًا؟","شو أجزاء الحكم ما بيثبتها الحدث؟"]'::jsonb, 'افصلي درس العلاقة عن حكم “أنا ما بنحب/مو كفاية”.', '{"before":["belief_before"],"after":["belief_after"],"outcome":["clarity_after"]}'::jsonb, '{"timing":"tomorrow","prompt":"شو صار بعد ما جربتي الخطوة؟"}'::jsonb, 'THOUGHT_FACTS_001', true, null,
  'reviewed', 'pending', false
) on conflict (code, version) do nothing;

insert into public.malaak_interventions (
  code, version, status, title_ar, short_description_ar, framework, evidence_tier, content_origin, licensing_status,
  target_needs, target_patterns, eligible_states, journey_domains, exclusions, contraindication_notes_ar, duration_min,
  steps_ar, action_template_ar, measurement_spec, follow_up_spec, fallback_code, requires_user_confirmation, activated_at,
  scientific_review_status, clinical_boundary_review_status, requires_human_support
) values (
  'HEAL_TRUST_GRADUAL_005', 1, 'draft', 'ثقة متدرجة مو عمياء', 'إعطاء الثقة بحسب السلوك والاتساق والزمن.', 'relationship/healing coaching', 'C', 'original_malaak', 'cleared_original',
  array['connection','respect','clarity']::text[], array['attachment_alarm','conflict_cycle']::text[], array['reflective']::text[], array['healing','relationship']::text[], '["Do not pressure reconciliation, forgiveness, or renewed trust after abuse or betrayal.","Not trauma processing or memory-recovery work."]'::jsonb, 'الثقة تُبنى حسب الأدلة؛ وإذا العلاقة غير آمنة فالهدف حماية النفس مو تدريب الثقة.', 10,
  '["اختاري مجال ثقة واحد.","حددي السلوك اللي يثبت الاتساق.","حددي مدة مراجعة معقولة.","راجعي السلوك الفعلي بدل وعد عام."]'::jsonb, 'اختاري معيار ثقة واحد وخليه يُثبت بالسلوك عبر الوقت.', '{"outcome":["real_world_result"],"after":["clarity_after"]}'::jsonb, '{"timing":"tomorrow","prompt":"شو صار بعد ما جربتي الخطوة؟"}'::jsonb, 'ATT_REALITY_002', true, null,
  'reviewed', 'pending', false
) on conflict (code, version) do nothing;

