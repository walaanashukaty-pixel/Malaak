import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../models/learning_journey_state.dart';
import '../../../state/app_scope.dart';
import '../../../widgets/premium_card.dart';
import '../data/fi_catalog.dart';
import '../logic/fi_scorer.dart';
import '../models/fi_models.dart';
import 'fi_assessment_result_screen.dart';

class FiAssessmentScreen extends StatefulWidget {
  const FiAssessmentScreen({super.key, this.restart = false});

  final bool restart;

  @override
  State<FiAssessmentScreen> createState() => _FiAssessmentScreenState();
}

class _FiAssessmentScreenState extends State<FiAssessmentScreen> {
  late Map<String, String> _answers;
  int _index = 0;
  bool _busy = false;
  bool _answersInitialized = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_answersInitialized) return;
    final saved = AppScope.of(context).state.learningJourneys[FiCatalog.domainId];
    _answers = widget.restart ? <String, String>{} : Map<String, String>.from(saved?.answers ?? const {});
    if (_answers.isNotEmpty && !widget.restart) {
      final firstUnanswered = FiCatalog.assessmentQuestions.indexWhere((q) => !_answers.containsKey(q.id));
      _index = firstUnanswered < 0 ? FiCatalog.assessmentQuestions.length - 1 : firstUnanswered;
    }
    _answersInitialized = true;
  }

  void _choose(String optionId) {
    if (_busy) return;
    final question = FiCatalog.assessmentQuestions[_index];
    setState(() => _answers[question.id] = optionId);
  }

  Future<void> _savePartial() async {
    final app = AppScope.of(context);
    final old = app.state.learningJourneys[FiCatalog.domainId] ??
        const LearningJourneyState(domainId: FiCatalog.domainId);
    await app.saveLearningJourneyState(old.copyWith(
      assessmentCompleted: false,
      answers: Map<String, String>.from(_answers),
      updatedAt: DateTime.now(),
    ));
  }

  Future<void> _goNext() async {
    if (_busy) return;
    final question = FiCatalog.assessmentQuestions[_index];
    if (!_answers.containsKey(question.id)) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('اختاري الجواب الأقرب إلك وبعدين كمّلي 🌷')));
      return;
    }
    setState(() => _busy = true);
    if (_index < FiCatalog.assessmentQuestions.length - 1) {
      await _savePartial();
      if (!mounted) return;
      setState(() {
        _index += 1;
        _busy = false;
      });
      return;
    }

    final app = AppScope.of(context);
    final old = app.state.learningJourneys[FiCatalog.domainId] ??
        const LearningJourneyState(domainId: FiCatalog.domainId);
    final scores = FiScorer.score(_answers);
    final recommendedRouteId = FiScorer.recommendRoute(scores);
    await app.saveLearningJourneyState(LearningJourneyState(
      domainId: FiCatalog.domainId,
      recommendedRouteId: recommendedRouteId,
      assessmentCompleted: true,
      scores: scores,
      answers: Map<String, String>.from(_answers),
      completedLessonIds: widget.restart ? old.completedLessonIds : old.completedLessonIds,
      notes: old.notes,
      lessonProgress: old.lessonProgress,
      updatedAt: DateTime.now(),
    ));
    if (!mounted) return;
    setState(() => _busy = false);
    await Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (_) => FiAssessmentResultScreen(recommendedRouteId: recommendedRouteId),
      ),
    );
  }

  void _goPrevious() {
    if (_busy || _index == 0) return;
    setState(() => _index -= 1);
  }

  String _coachReply(FiAssessmentOption option) {
    if (option.coachReply != 'تمام، فهمت عليك. خلينا نكمل ونشوف الصورة من أكتر من موقف.') {
      return option.coachReply;
    }
    final weights = option.weights;
    if (weights.peoplePleasing >= 2) {
      return 'فهمت عليك. بهالموقف راحة الطرف التاني أخدت مساحة قبل راحتك أو قرارك. ما رح نحكم من جواب واحد؛ خلينا نشوف باقي المواقف.';
    }
    if (weights.controlRigidity >= 2) {
      return 'تمام. بهالموقف الحسم أو السيطرة كانوا أقرب إلك. خلينا نشوف إذا هالشي بيتكرر ولا بيتغير حسب السياق.';
    }
    if (weights.relationalWisdom >= 2) {
      return 'حلو. هون عم تتركي مساحة للتوقيت أو للطرف التاني بدون ما تلغي حالك. خلينا نكمّل الصورة.';
    }
    return 'تمام. هون في وقفة وتفكير قبل القرار. خلينا نكمل ونشوف كيف بتتصرفي لما يصير ضغط أكبر.';
  }

  @override
  Widget build(BuildContext context) {
    if (!_answersInitialized) return const Scaffold(body: Center(child: CircularProgressIndicator()));
    final question = FiCatalog.assessmentQuestions[_index];
    final selectedId = _answers[question.id];
    final selected = selectedId == null
        ? null
        : question.options.where((option) => option.id == selectedId).firstOrNull;
    final progress = (_index + 1) / FiCatalog.assessmentQuestions.length;

    return Scaffold(
      appBar: AppBar(title: const Text('جلسة تعارف مع ملاك', style: TextStyle(fontSize: 17, fontWeight: FontWeight.w900))),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(18, 6, 18, 8),
              child: Column(
                children: [
                  Row(
                    children: [
                      const Text('عم نتعرف عليك أكتر ✨', style: TextStyle(fontSize: 10.5, fontWeight: FontWeight.w800, color: AppColors.mutedText)),
                      const Spacer(),
                      Text('${(progress * 100).round()}%', style: const TextStyle(fontSize: 10.5, fontWeight: FontWeight.w900, color: AppColors.lilac)),
                    ],
                  ),
                  const SizedBox(height: 7),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: LinearProgressIndicator(
                      value: progress,
                      minHeight: 6,
                      backgroundColor: AppColors.muted,
                      color: AppColors.lilac,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(18, 8, 18, 18),
                children: [
                  if (_index == 0) ...[
                    const _CoachBubble(
                      text: 'أنا ملاك 🌷 ما رح اختبرك ولا أدور على جواب مثالي. بدي بس أفهم كيف بتتصرفي فعلًا بالمواقف، وبعدها برشحلك نقطة بداية مناسبة وإنتِ بتختاري.',
                    ),
                    const SizedBox(height: 12),
                  ],
                  _CoachBubble(text: '${question.coachLead}\n\n${question.prompt}'),
                  const SizedBox(height: 12),
                  if (selected != null) ...[
                    _UserBubble(text: selected.label),
                    const SizedBox(height: 10),
                    _CoachBubble(text: _coachReply(selected)),
                    const SizedBox(height: 14),
                  ],
                  if (selected == null)
                    const Padding(
                      padding: EdgeInsets.only(bottom: 9),
                      child: Text('شو الأقرب إلك؟', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w900, color: AppColors.gold)),
                    )
                  else
                    const Padding(
                      padding: EdgeInsets.only(bottom: 9),
                      child: Text('إذا حابة تعدلي جوابك، اختاري جواب تاني:', style: TextStyle(fontSize: 10.5, fontWeight: FontWeight.w800, color: AppColors.mutedText)),
                    ),
                  for (final option in question.options) ...[
                    _OptionCard(
                      label: option.label,
                      selected: selectedId == option.id,
                      disabled: _busy,
                      onTap: () => _choose(option.id),
                    ),
                    const SizedBox(height: 8),
                  ],
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.fromLTRB(18, 10, 18, 14),
              decoration: BoxDecoration(color: Colors.white, border: Border(top: BorderSide(color: AppColors.border.withOpacity(0.8)))),
              child: Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: _index == 0 || _busy ? null : _goPrevious,
                      icon: const Icon(Icons.arrow_forward_rounded, size: 17),
                      label: const Text('السابق'),
                      style: OutlinedButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 13)),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    flex: 2,
                    child: FilledButton.icon(
                      onPressed: _busy ? null : _goNext,
                      icon: _busy
                          ? const SizedBox(width: 17, height: 17, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                          : const Icon(Icons.arrow_back_rounded, size: 17),
                      label: Text(_index == FiCatalog.assessmentQuestions.length - 1 ? 'شوفي خريطتك' : 'التالي'),
                      style: FilledButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 13)),
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
}

class _CoachBubble extends StatelessWidget {
  const _CoachBubble({required this.text});
  final String text;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerRight,
      child: Container(
        constraints: const BoxConstraints(maxWidth: 340),
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 13),
        decoration: BoxDecoration(
          color: AppColors.lavender.withOpacity(0.11),
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(22),
            topRight: Radius.circular(22),
            bottomLeft: Radius.circular(22),
            bottomRight: Radius.circular(6),
          ),
          border: Border.all(color: AppColors.border),
        ),
        child: Text(text, style: const TextStyle(fontSize: 12.3, height: 1.75, color: AppColors.plum, fontWeight: FontWeight.w700)),
      ),
    );
  }
}

class _UserBubble extends StatelessWidget {
  const _UserBubble({required this.text});
  final String text;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        constraints: const BoxConstraints(maxWidth: 315),
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 12),
        decoration: const BoxDecoration(
          gradient: AppColors.primaryGradient,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(22),
            topRight: Radius.circular(22),
            bottomRight: Radius.circular(22),
            bottomLeft: Radius.circular(6),
          ),
        ),
        child: Text(text, style: const TextStyle(fontSize: 12, height: 1.65, color: Colors.white, fontWeight: FontWeight.w800)),
      ),
    );
  }
}

class _OptionCard extends StatelessWidget {
  const _OptionCard({required this.label, required this.selected, required this.disabled, required this.onTap});
  final String label;
  final bool selected;
  final bool disabled;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return PremiumCard(
      onTap: disabled ? null : onTap,
      color: selected ? AppColors.lavender.withOpacity(0.10) : Colors.white,
      borderColor: selected ? AppColors.lavender : AppColors.border,
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 13),
      child: Row(
        children: [
          Icon(selected ? Icons.check_circle_rounded : Icons.circle_outlined, size: 20, color: selected ? AppColors.lilac : AppColors.mutedText),
          const SizedBox(width: 10),
          Expanded(child: Text(label, style: const TextStyle(fontSize: 12, height: 1.55, fontWeight: FontWeight.w700, color: AppColors.plum))),
        ],
      ),
    );
  }
}

extension _FirstOrNull<T> on Iterable<T> {
  T? get firstOrNull {
    final iterator = this.iterator;
    if (!iterator.moveNext()) return null;
    return iterator.current;
  }
}
