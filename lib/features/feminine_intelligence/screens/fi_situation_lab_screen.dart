import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../models/learning_journey_state.dart';
import '../../../state/app_scope.dart';
import '../../../widgets/premium_card.dart';
import '../data/fi_catalog.dart';

class FiSituationLabScreen extends StatefulWidget {
  const FiSituationLabScreen({super.key});

  @override
  State<FiSituationLabScreen> createState() => _FiSituationLabScreenState();
}

class _FiSituationLabScreenState extends State<FiSituationLabScreen> {
  final _controllers = List<TextEditingController>.generate(6, (_) => TextEditingController());
  bool _saving = false;

  static const _prompts = <String>[
    'شو صار؟ اكتبي الحدث مثل ما صورته كاميرا، بدون تفسير طويل.',
    'شو حاسة هلق؟ وإذا في أكتر من شعور، شو الأقوى؟',
    'هل هلق هو الوقت المناسب للتصرف أو الحوار؟ وليش؟',
    'شو ممكن يكون الطرف الآخر حاسس؟ وشو الدليل الحقيقي عندك، مو الافتراض؟',
    'شو نيتك من هالموقف: فهم، حل، حد، تعبير، ولا إثبات إنك صح؟',
    'شو التصرف اللي بيحمي حدك وهدفك بأقل خسارة غير ضرورية؟',
  ];

  @override
  void dispose() {
    for (final controller in _controllers) {
      controller.dispose();
    }
    super.dispose();
  }

  Future<void> _save() async {
    if (_saving) return;
    setState(() => _saving = true);
    final app = AppScope.of(context);
    final old = app.state.learningJourneys[FiCatalog.domainId] ??
        const LearningJourneyState(domainId: FiCatalog.domainId);
    final notes = Map<String, String>.from(old.notes);
    final body = <String>[];
    for (var i = 0; i < _prompts.length; i++) {
      final answer = _controllers[i].text.trim();
      if (answer.isNotEmpty) body.add('${i + 1}. ${_prompts[i]}\n$answer');
    }
    if (body.isNotEmpty) {
      notes['situation-lab-${DateTime.now().millisecondsSinceEpoch}'] = body.join('\n\n');
    }
    await app.saveLearningJourneyState(old.copyWith(notes: notes));
    if (!mounted) return;
    setState(() => _saving = false);
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('تم حفظ الموقف ضمن رحلتك ✨')));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('مختبر المواقف', style: TextStyle(fontSize: 17, fontWeight: FontWeight.w900))),
      body: ListView(
        padding: EdgeInsets.fromLTRB(18, 8, 18, 36 + MediaQuery.viewInsetsOf(context).bottom),
        children: [
          PremiumCard(
            gradient: AppColors.heroGradient,
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('عندي موقف الآن', style: TextStyle(fontSize: 19, fontWeight: FontWeight.w900, color: AppColors.plum)),
                SizedBox(height: 8),
                Text('ملاك ما رح تعطيكي جواب جاهز. منمشي بست خطوات حتى يصير قرارك أهدأ وأوضح.', style: TextStyle(fontSize: 12, height: 1.75, color: AppColors.softText)),
              ],
            ),
          ),
          const SizedBox(height: 14),
          for (var i = 0; i < _prompts.length; i++) ...[
            PremiumCard(
              padding: const EdgeInsets.all(15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('الخطوة ${i + 1}', style: const TextStyle(fontSize: 10.5, fontWeight: FontWeight.w900, color: AppColors.gold)),
                  const SizedBox(height: 6),
                  Text(_prompts[i], style: const TextStyle(fontSize: 12.5, height: 1.7, fontWeight: FontWeight.w800, color: AppColors.plum)),
                  const SizedBox(height: 10),
                  TextField(
                    controller: _controllers[i],
                    minLines: 2,
                    maxLines: 4,
                    decoration: const InputDecoration(hintText: 'اكتبي هون…'),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),
          ],
          const SizedBox(height: 6),
          InkWell(
            onTap: _saving ? null : _save,
            borderRadius: BorderRadius.circular(18),
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 14),
              decoration: BoxDecoration(gradient: AppColors.primaryGradient, borderRadius: BorderRadius.circular(18)),
              child: Center(
                child: _saving
                    ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                    : const Text('احفظي الموقف', style: TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.w900)),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
