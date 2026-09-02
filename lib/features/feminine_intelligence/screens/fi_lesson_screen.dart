import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../models/learning_journey_state.dart';
import '../../../state/app_scope.dart';
import '../../../widgets/premium_card.dart';
import '../data/fi_catalog.dart';
import '../models/fi_models.dart';

class FiLessonScreen extends StatefulWidget {
  const FiLessonScreen({super.key, required this.lesson});

  final FiLesson lesson;

  @override
  State<FiLessonScreen> createState() => _FiLessonScreenState();
}

class _FiLessonScreenState extends State<FiLessonScreen> {
  final _note = TextEditingController();
  String? _selectedChoice;
  bool _loaded = false;
  bool _saving = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_loaded) return;
    final saved = AppScope.of(context).state.learningJourneys[FiCatalog.domainId];
    _note.text = saved?.notes[widget.lesson.id] ?? '';
    _loaded = true;
  }

  @override
  void dispose() {
    _note.dispose();
    super.dispose();
  }

  Future<void> _complete() async {
    if (_saving) return;
    setState(() => _saving = true);
    final app = AppScope.of(context);
    final old = app.state.learningJourneys[FiCatalog.domainId] ??
        const LearningJourneyState(domainId: FiCatalog.domainId);
    final completedLessonIds = <String>{...old.completedLessonIds, widget.lesson.id}.toList(growable: false);
    final notes = Map<String, String>.from(old.notes);
    final text = _note.text.trim();
    final reflection = [if (_selectedChoice != null) _selectedChoice!, if (text.isNotEmpty) text].join(' — ');
    if (reflection.isNotEmpty) notes[widget.lesson.id] = reflection;
    await app.saveLearningJourneyState(old.copyWith(
      completedLessonIds: completedLessonIds,
      notes: notes,
    ));
    if (!mounted) return;
    setState(() => _saving = false);
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('تم حفظ التدريب ضمن رحلتك 🌱')));
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final completedLessonIds = AppScope.of(context).state.learningJourneys[FiCatalog.domainId]?.completedLessonIds ?? const <String>[];
    final alreadyCompleted = completedLessonIds.contains(widget.lesson.id);
    return Scaffold(
      appBar: AppBar(title: Text(widget.lesson.title, style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w900))),
      body: ListView(
        padding: EdgeInsets.fromLTRB(18, 8, 18, 36 + MediaQuery.viewInsetsOf(context).bottom),
        children: [
          PremiumCard(
            gradient: AppColors.heroGradient,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(widget.lesson.subtitle, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w800, color: AppColors.gold)),
                const SizedBox(height: 9),
                Text(widget.lesson.insight, style: const TextStyle(fontSize: 14, height: 1.8, fontWeight: FontWeight.w800, color: AppColors.plum)),
              ],
            ),
          ),
          const SizedBox(height: 16),
          PremiumCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('طبقي على حالك', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w900, color: AppColors.plum)),
                const SizedBox(height: 8),
                Text(widget.lesson.prompt, style: const TextStyle(fontSize: 12.5, height: 1.75, color: AppColors.softText)),
                if (widget.lesson.choices.isNotEmpty) ...[
                  const SizedBox(height: 14),
                  for (final choice in widget.lesson.choices) ...[
                    InkWell(
                      onTap: () => setState(() => _selectedChoice = choice),
                      borderRadius: BorderRadius.circular(16),
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: _selectedChoice == choice ? AppColors.lavender.withOpacity(0.12) : AppColors.muted.withOpacity(0.55),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: _selectedChoice == choice ? AppColors.lavender : AppColors.border),
                        ),
                        child: Text(choice, style: const TextStyle(fontSize: 11.5, height: 1.55, fontWeight: FontWeight.w700, color: AppColors.plum)),
                      ),
                    ),
                    const SizedBox(height: 8),
                  ],
                ],
                const SizedBox(height: 10),
                TextField(
                  controller: _note,
                  maxLines: 4,
                  minLines: 2,
                  textInputAction: TextInputAction.newline,
                  decoration: const InputDecoration(hintText: 'اكتبي ملاحظة أو مثال من حياتك…'),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          PremiumCard(
            color: AppColors.sage.withOpacity(0.10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('تجربة بالحياة', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w900, color: AppColors.plum)),
                const SizedBox(height: 7),
                Text(widget.lesson.practice, style: const TextStyle(fontSize: 12, height: 1.75, color: AppColors.softText)),
              ],
            ),
          ),
          const SizedBox(height: 18),
          InkWell(
            onTap: _saving ? null : _complete,
            borderRadius: BorderRadius.circular(18),
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 14),
              decoration: BoxDecoration(gradient: AppColors.primaryGradient, borderRadius: BorderRadius.circular(18)),
              child: Center(
                child: _saving
                    ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                    : Text(alreadyCompleted ? 'احفظي التحديث' : 'أنجزت التدريب', style: const TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.w900)),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
