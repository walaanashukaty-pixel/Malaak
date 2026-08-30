import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../models/initial_map.dart';
import '../../state/app_controller.dart';
import '../../widgets/premium_card.dart';
import '../../widgets/soft_icon.dart';
import 'initial_map_result_screen.dart';

class InitialMapFlow extends StatefulWidget {
  const InitialMapFlow({super.key, required this.controller});

  final AppController controller;
  static const int totalSteps = 6;

  @override
  State<InitialMapFlow> createState() => _InitialMapFlowState();
}

class _InitialMapFlowState extends State<InitialMapFlow> {
  int _step = 0;
  String? _concern;
  String? _context;
  String? _impact;
  String? _safetyLevel;
  bool _safeNow = false;
  String? _preference;
  bool _patternAnalysis = true;
  final _desiredController = TextEditingController();

  @override
  void dispose() {
    _desiredController.dispose();
    super.dispose();
  }

  bool get _canContinue => switch (_step) {
        0 => _concern != null,
        1 => _context != null,
        2 => _impact != null,
        3 => _safetyLevel == 'none' || (_safetyLevel != null && _safeNow),
        4 => _desiredController.text.trim().length >= 3,
        _ => _preference != null,
      };

  void _selectSafety(String value) {
    setState(() {
      _safetyLevel = value;
      _safeNow = value == 'none';
    });
  }

  Future<void> _next() async {
    if (!_canContinue) return;
    if (_step < InitialMapFlow.totalSteps - 1) {
      setState(() => _step += 1);
      return;
    }

    final map = InitialMap(
      primaryConcern: _concern!,
      lifeContext: _context!,
      currentImpact: _impact!,
      immediateSafety: {'level': _safetyLevel, 'safeNow': _safeNow},
      desiredChange: _desiredController.text.trim(),
      coachingPreference: _preference!,
      privacyScope: {
        'patternAnalysis': _patternAnalysis,
        'journalAnalysis': false,
      },
    );

    if (!mounted) return;
    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (resultContext) => InitialMapResultScreen(
          initialMap: map,
          onConfirm: () async {
            await widget.controller.saveInitialMap(map);
            if (resultContext.mounted) {
              Navigator.of(resultContext).popUntil((route) => route.isFirst);
            }
          },
        ),
      ),
    );
  }

  void _back() {
    if (_step == 0) return;
    setState(() => _step -= 1);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.cream,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(18, 14, 18, 8),
              child: Row(
                children: [
                  Container(
                    width: 46,
                    height: 46,
                    decoration: BoxDecoration(
                      gradient: AppColors.primaryGradient,
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: const Icon(Icons.auto_awesome_rounded, color: Colors.white, size: 21),
                  ),
                  const SizedBox(width: 12),
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('خلّيني أعرفك شوي 🌷', style: TextStyle(fontSize: 19, fontWeight: FontWeight.w900, color: AppColors.plum)),
                        SizedBox(height: 2),
                        Text('مو لازم تعرفي اسم المشكلة. منرتّب البداية سوا.', style: TextStyle(fontSize: 11.5, color: AppColors.mutedText)),
                      ],
                    ),
                  ),
                  Text('الخطوة ${_step + 1} من ${InitialMapFlow.totalSteps}', style: const TextStyle(fontSize: 10.5, color: AppColors.mutedText, fontWeight: FontWeight.w700)),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
              child: Row(
                children: List.generate(InitialMapFlow.totalSteps, (index) {
                  final active = index <= _step;
                  return Expanded(
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 220),
                      height: 5,
                      margin: EdgeInsets.only(left: index == InitialMapFlow.totalSteps - 1 ? 0 : 5),
                      decoration: BoxDecoration(
                        color: active ? AppColors.lavender : AppColors.muted,
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  );
                }),
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(18, 12, 18, 24),
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 230),
                  child: KeyedSubtree(key: ValueKey(_step), child: _stepBody()),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(18, 10, 18, 20),
              child: Row(
                children: [
                  if (_step > 0) ...[
                    SizedBox(
                      width: 54,
                      height: 52,
                      child: OutlinedButton(
                        onPressed: _back,
                        style: OutlinedButton.styleFrom(
                          side: const BorderSide(color: AppColors.border),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
                        ),
                        child: const Icon(Icons.arrow_forward_rounded, color: AppColors.softText),
                      ),
                    ),
                    const SizedBox(width: 10),
                  ],
                  Expanded(
                    child: SizedBox(
                      height: 52,
                      child: FilledButton(
                        onPressed: _canContinue ? _next : null,
                        style: FilledButton.styleFrom(
                          backgroundColor: AppColors.plum,
                          disabledBackgroundColor: AppColors.muted,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
                        ),
                        child: Text(
                          _step == InitialMapFlow.totalSteps - 1 ? 'شوفي خريطتي الأولية' : 'كمّلي',
                          style: const TextStyle(fontWeight: FontWeight.w900),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _stepBody() => switch (_step) {
        0 => _choiceStep(
            icon: Icons.favorite_border_rounded,
            color: AppColors.rose,
            title: 'شو أكتر شي جابك لملاك هالفترة؟',
            subtitle: 'اختاري الأقرب، حتى لو حاسة إن في أكثر من شغلة.',
            value: _concern,
            options: const {
              'relationship': '💍 علاقتي أو زواجي',
              'overthinking': '🌀 عقلي ما عم يوقف',
              'anger': '🔥 عصبيتي وردود فعلي',
              'emotional_pain': '💔 تجربة عاطفية موجعتني',
              'needs': '❤️ ما بعرف شو بدي أو شو بحتاج',
              'inner_chaos': '🌪️ حاسّة داخلي فوضى',
              'attachment': '🤍 بتعلّق وبخاف من البعد',
              'childhood': '🧸 حاسّة الماضي مأثر عليّ',
              'war_mode': '🌷 حاسّة حالي طول الوقت بوضع حرب',
              'unsure': '❓ ما بعرف بالضبط… بس مو منيحة',
            },
            onChanged: (value) => setState(() => _concern = value),
          ),
        1 => _choiceStep(
            icon: Icons.layers_outlined,
            color: AppColors.lavender,
            title: 'وين عم يظهر التعب أكتر شي؟',
            subtitle: 'السياق بيفرق. نفس الشعور ممكن يحتاج طريقة مختلفة حسب المكان والعلاقة.',
            value: _context,
            options: const {
              'marriage': '💍 الزواج أو العلاقة',
              'family': '👨‍👩‍👧 العائلة',
              'work': '💼 العمل أو الدراسة',
              'self': '🌿 علاقتي مع حالي',
              'multiple': '🧩 أكثر من جانب بحياتي',
            },
            onChanged: (value) => setState(() => _context = value),
          ),
        2 => _choiceStep(
            icon: Icons.monitor_heart_outlined,
            color: AppColors.sage,
            title: 'قديش مأثر عليكِ حاليًا؟',
            subtitle: 'مو عم نقيس قيمتك ولا “درجة مشكلة”. بس بدنا نعرف قديش في مساحة للتدريب الآن.',
            value: _impact,
            options: const {
              'low': 'موجود بس ما عم يعطل حياتي',
              'moderate': 'مأثر بوضوح، بس لسه عم بقدر أكمل يومي',
              'high': 'مأثر بقوة على يومي أو علاقتي أو نومي',
            },
            onChanged: (value) => setState(() => _impact = value),
          ),
        3 => _safetyStep(),
        4 => _desiredChangeStep(),
        _ => _preferenceAndPrivacyStep(),
      };

  Widget _choiceStep({
    required IconData icon,
    required Color color,
    required String title,
    required String subtitle,
    required String? value,
    required Map<String, String> options,
    required ValueChanged<String> onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SoftIcon(icon: icon, color: color, size: 52),
        const SizedBox(height: 18),
        Text(title, style: const TextStyle(fontSize: 24, height: 1.35, fontWeight: FontWeight.w900, color: AppColors.plum)),
        const SizedBox(height: 8),
        Text(subtitle, style: const TextStyle(fontSize: 13, height: 1.75, color: AppColors.mutedText)),
        const SizedBox(height: 22),
        ...options.entries.map((entry) => Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: _ChoiceTile(
                label: entry.value,
                selected: value == entry.key,
                onTap: () => onChanged(entry.key),
              ),
            )),
      ],
    );
  }

  Widget _safetyStep() {
    final needsSafetySupport = _safetyLevel != null && _safetyLevel != 'none';
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SoftIcon(icon: Icons.shield_outlined, color: AppColors.blue, size: 52),
        const SizedBox(height: 18),
        const Text('قبل أي تدريب، بدي أتأكد من الأمان', style: TextStyle(fontSize: 24, height: 1.35, fontWeight: FontWeight.w900, color: AppColors.plum)),
        const SizedBox(height: 8),
        const Text('هاد سؤال أمان، مو تشخيص. إذا في خطر مباشر، الأولوية لدعم بشري ومكان آمن قبل أي تحليل.', style: TextStyle(fontSize: 13, height: 1.75, color: AppColors.mutedText)),
        const SizedBox(height: 22),
        _ChoiceTile(label: '🌿 لا، ما في خطر مباشر حاليًا', selected: _safetyLevel == 'none', onTap: () => _selectSafety('none')),
        const SizedBox(height: 10),
        _ChoiceTile(label: '🛡️ في خوف أو تهديد أو تحكم من شخص', selected: _safetyLevel == 'interpersonal_risk', onTap: () => _selectSafety('interpersonal_risk')),
        const SizedBox(height: 10),
        _ChoiceTile(label: '🚨 خايفة أؤذي نفسي أو شخص ثاني', selected: _safetyLevel == 'self_or_other_harm', onTap: () => _selectSafety('self_or_other_harm')),
        if (needsSafetySupport) ...[
          const SizedBox(height: 16),
          PremiumCard(
            color: AppColors.danger.withOpacity(0.06),
            borderColor: AppColors.danger.withOpacity(0.28),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('الأولوية الآن للأمان', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w900, color: AppColors.plum)),
                const SizedBox(height: 7),
                const Text('إذا الخطر مباشر، استخدمي خدمات الطوارئ المحلية أو تواصلي فورًا مع شخص موثوق يقدر يكون معك فعليًا. ملاك ما لازم تكون الدعم الوحيد بهالحالة.', style: TextStyle(fontSize: 12, height: 1.7, color: AppColors.softText)),
                const SizedBox(height: 12),
                CheckboxListTile(
                  contentPadding: EdgeInsets.zero,
                  value: _safeNow,
                  onChanged: (value) => setState(() => _safeNow = value ?? false),
                  activeColor: AppColors.plum,
                  title: const Text('أنا بمكان آمن الآن وبقدر أكمل الإعداد', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w800, color: AppColors.plum)),
                ),
              ],
            ),
          ),
        ],
      ],
    );
  }

  Widget _desiredChangeStep() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SoftIcon(icon: Icons.flag_outlined, color: AppColors.gold, size: 52),
        const SizedBox(height: 18),
        const Text('إذا ملاك ساعدتك فعلًا… شو بدك يتغيّر؟', style: TextStyle(fontSize: 24, height: 1.35, fontWeight: FontWeight.w900, color: AppColors.plum)),
        const SizedBox(height: 8),
        const Text('احكي بلغتك. مو لازم يكون الهدف “مثالي” أو مكتوب بطريقة نفسية.', style: TextStyle(fontSize: 13, height: 1.75, color: AppColors.mutedText)),
        const SizedBox(height: 22),
        PremiumCard(
          child: TextField(
            controller: _desiredController,
            onChanged: (_) => setState(() {}),
            minLines: 4,
            maxLines: 7,
            textInputAction: TextInputAction.newline,
            decoration: const InputDecoration(
              border: InputBorder.none,
              hintText: 'مثلاً: بدي وقت الخلاف أعرف أهدى وأحكي بدون ما أخسر حالي…',
              hintStyle: TextStyle(color: AppColors.mutedText, height: 1.6),
            ),
            style: const TextStyle(fontSize: 14, height: 1.8, color: AppColors.plum, fontWeight: FontWeight.w600),
          ),
        ),
      ],
    );
  }

  Widget _preferenceAndPrivacyStep() {
    const options = {
      'listen': '🫂 اسمعيني أول شي',
      'organize': '🧭 رتّبيلي الموضوع',
      'challenge_thoughts': '🧠 ساعديني أتحدى أفكاري',
      'act': '🎯 ساعديني أتصرف بخطوة واضحة',
      'calm': '🌿 هدّيني قبل أي تحليل',
    };
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SoftIcon(icon: Icons.auto_awesome_outlined, color: AppColors.rose, size: 52),
        const SizedBox(height: 18),
        const Text('كيف بتحبي ملاك تكون معك؟', style: TextStyle(fontSize: 24, height: 1.35, fontWeight: FontWeight.w900, color: AppColors.plum)),
        const SizedBox(height: 8),
        const Text('هالاختيار بيغيّر أسلوب الجلسة، مو الحقيقة اللي ملاك لازم تقولها.', style: TextStyle(fontSize: 13, height: 1.75, color: AppColors.mutedText)),
        const SizedBox(height: 20),
        ...options.entries.map((entry) => Padding(
              padding: const EdgeInsets.only(bottom: 9),
              child: _ChoiceTile(label: entry.value, selected: _preference == entry.key, onTap: () => setState(() => _preference = entry.key)),
            )),
        const SizedBox(height: 14),
        PremiumCard(
          color: AppColors.muted.withOpacity(0.45),
          child: SwitchListTile(
            contentPadding: EdgeInsets.zero,
            value: _patternAnalysis,
            onChanged: (value) => setState(() => _patternAnalysis = value),
            activeColor: AppColors.plum,
            title: const Text('اسمحي لملاك تتعلم الأنماط من المواقف اللي تختاري تحليلها', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w900, color: AppColors.plum)),
            subtitle: const Text('بتقدري توقفي هالشي لاحقًا. اليوميات الخاصة ما بتدخل بتحليل الأنماط تلقائيًا.', style: TextStyle(fontSize: 11.5, height: 1.65, color: AppColors.mutedText)),
          ),
        ),
      ],
    );
  }
}

class _ChoiceTile extends StatelessWidget {
  const _ChoiceTile({required this.label, required this.selected, required this.onTap});

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return PremiumCard(
      onTap: onTap,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 15),
      color: selected ? AppColors.lavender.withOpacity(0.11) : Colors.white,
      borderColor: selected ? AppColors.lavender : AppColors.border,
      child: Row(
        children: [
          Expanded(child: Text(label, style: TextStyle(fontSize: 13, fontWeight: selected ? FontWeight.w900 : FontWeight.w700, color: AppColors.plum))),
          const SizedBox(width: 10),
          AnimatedContainer(
            duration: const Duration(milliseconds: 180),
            width: 24,
            height: 24,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: selected ? AppColors.lavender : Colors.transparent,
              border: Border.all(color: selected ? AppColors.lavender : AppColors.border, width: 2),
            ),
            child: selected ? const Icon(Icons.check_rounded, size: 16, color: Colors.white) : null,
          ),
        ],
      ),
    );
  }
}
