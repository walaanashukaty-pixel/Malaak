import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../models/learning_journey_state.dart';
import '../../../state/app_scope.dart';
import '../../../widgets/premium_card.dart';
import '../data/fi_catalog.dart';
import '../logic/fi_scorer.dart';

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

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_index != 0 || _answersInitialized) return;
    final saved = AppScope.of(context).state.learningJourneys[FiCatalog.domainId];
    _answers = widget.restart ? <String, String>{} : Map<String, String>.from(saved?.answers ?? const {});
    if (_answers.isNotEmpty && !widget.restart) {
      final firstUnanswered = FiCatalog.assessmentQuestions.indexWhere((q) => !_answers.containsKey(q.id));
      _index = firstUnanswered < 0 ? FiCatalog.assessmentQuestions.length - 1 : firstUnanswered;
    }
    _answersInitialized = true;
  }

  bool _answersInitialized = false;

  Future<void> _choose(String optionId) async {
    if (_busy) return;
    final question = FiCatalog.assessmentQuestions[_index];
    setState(() {
      _answers[question.id] = optionId;
      _busy = true;
    });

    final app = AppScope.of(context);
    final old = app.state.learningJourneys[FiCatalog.domainId] ??
        const LearningJourneyState(domainId: FiCatalog.domainId);

    if (_index < FiCatalog.assessmentQuestions.length - 1) {
      await app.saveLearningJourneyState(old.copyWith(
        assessmentCompleted: false,
        answers: Map<String, String>.from(_answers),
      ));
      if (!mounted) return;
      setState(() {
        _index += 1;
        _busy = false;
      });
      return;
    }

    final scores = FiScorer.score(_answers);
    final routeId = FiScorer.route(scores);
    await app.saveLearningJourneyState(LearningJourneyState(
      domainId: FiCatalog.domainId,
      routeId: routeId,
      assessmentCompleted: true,
      scores: scores,
      answers: Map<String, String>.from(_answers),
      completedLessonIds: widget.restart ? const <String>[] : old.completedLessonIds,
      notes: widget.restart ? const <String, String>{} : old.notes,
      updatedAt: DateTime.now(),
    ));
    if (!mounted) return;
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    if (!_answersInitialized) return const Scaffold(body: Center(child: CircularProgressIndicator()));
    final question = FiCatalog.assessmentQuestions[_index];
    final progress = (_index + 1) / FiCatalog.assessmentQuestions.length;

    return Scaffold(
      appBar: AppBar(title: const Text('خريطة البداية', style: TextStyle(fontSize: 17, fontWeight: FontWeight.w900))),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(18, 8, 18, 36),
          children: [
            Row(
              children: [
                Expanded(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: LinearProgressIndicator(
                      value: progress,
                      minHeight: 8,
                      backgroundColor: AppColors.muted,
                      color: AppColors.lilac,
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Text('${_index + 1}/${FiCatalog.assessmentQuestions.length}', style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w800, color: AppColors.mutedText)),
              ],
            ),
            const SizedBox(height: 22),
            PremiumCard(
              gradient: AppColors.heroGradient,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('ما في جواب صح أو غلط', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w800, color: AppColors.gold)),
                  const SizedBox(height: 8),
                  Text(question.prompt, style: const TextStyle(fontSize: 18, height: 1.6, fontWeight: FontWeight.w900, color: AppColors.plum)),
                  const SizedBox(height: 6),
                  const Text('اختاري الأقرب لتصرفك الحقيقي غالبًا.', style: TextStyle(fontSize: 11.5, height: 1.6, color: AppColors.softText)),
                ],
              ),
            ),
            const SizedBox(height: 14),
            for (final option in question.options) ...[
              _OptionCard(
                label: option.label,
                selected: _answers[question.id] == option.id,
                disabled: _busy,
                onTap: () => _choose(option.id),
              ),
              const SizedBox(height: 10),
            ],
          ],
        ),
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
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      child: Row(
        children: [
          Container(
            width: 26,
            height: 26,
            decoration: BoxDecoration(
              color: selected ? AppColors.lavender : AppColors.muted,
              shape: BoxShape.circle,
            ),
            child: Icon(selected ? Icons.check_rounded : Icons.circle_outlined, size: 16, color: selected ? Colors.white : AppColors.mutedText),
          ),
          const SizedBox(width: 12),
          Expanded(child: Text(label, style: const TextStyle(fontSize: 12.5, height: 1.6, fontWeight: FontWeight.w700, color: AppColors.plum))),
        ],
      ),
    );
  }
}
