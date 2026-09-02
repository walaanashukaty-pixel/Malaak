import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../models/learning_journey_state.dart';
import '../../../state/app_scope.dart';
import '../../../widgets/premium_card.dart';
import '../../../widgets/soft_icon.dart';
import '../data/fi_catalog.dart';
import '../models/fi_models.dart';
import 'fi_lesson_screen.dart';
import 'fi_situation_lab_screen.dart';

class FiRouteScreen extends StatelessWidget {
  const FiRouteScreen({super.key, required this.routeId});

  final String routeId;

  @override
  Widget build(BuildContext context) {
    final route = FiCatalog.routeById(routeId);
    final saved = AppScope.of(context).state.learningJourneys[FiCatalog.domainId] ??
        const LearningJourneyState(domainId: FiCatalog.domainId);
    final progressList = route.lessons.map((lesson) => saved.lessonProgress[lesson.id]).whereType<LearningLessonProgress>().toList();
    final practiced = progressList.where((progress) => progress.hasStarted).length;
    final applications = progressList.fold<int>(0, (total, progress) => total + progress.realLifeApplications);
    final missionPending = progressList.where((progress) => progress.missionPending).length;
    final progress = route.lessons.isEmpty ? 0.0 : practiced / route.lessons.length;

    return Scaffold(
      appBar: AppBar(title: const Text('رحلتي', style: TextStyle(fontSize: 17, fontWeight: FontWeight.w900))),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(18, 8, 18, 40),
        children: [
          PremiumCard(
            gradient: AppColors.heroGradient,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SoftIcon(icon: Icons.route_rounded, color: AppColors.rose, size: 54),
                const SizedBox(height: 14),
                Text(route.title, style: const TextStyle(fontSize: 20, height: 1.45, fontWeight: FontWeight.w900, color: AppColors.plum)),
                const SizedBox(height: 8),
                Text(route.goal, style: const TextStyle(fontSize: 12, height: 1.75, color: AppColors.softText)),
                const SizedBox(height: 16),
                ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: LinearProgressIndicator(value: progress, minHeight: 8, backgroundColor: AppColors.muted, color: AppColors.lilac),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(child: _Metric(value: '$practiced', label: 'جلسات تدريب')),
                    const SizedBox(width: 8),
                    Expanded(child: _Metric(value: '$applications', label: 'تطبيقات حقيقية')),
                    const SizedBox(width: 8),
                    Expanded(child: _Metric(value: '$missionPending', label: 'متابعة مفتوحة')),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 18),
          for (var i = 0; i < route.lessons.length; i++) ...[
            _LessonCard(
              index: i + 1,
              lesson: route.lessons[i],
              progress: saved.lessonProgress[route.lessons[i].id] ?? const LearningLessonProgress(),
            ),
            const SizedBox(height: 10),
          ],
          const SizedBox(height: 10),
          PremiumCard(
            onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => const FiSituationLabScreen())),
            color: AppColors.sage.withOpacity(0.10),
            child: const Row(
              children: [
                SoftIcon(icon: Icons.science_rounded, color: AppColors.sage, size: 46),
                SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('مختبر المواقف', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w900, color: AppColors.plum)),
                      SizedBox(height: 4),
                      Text('حتى بعد ما تتقني المهارة، كل موقف جديد بيخلي عندك مساحة تطبقيها بشكل أذكى.', style: TextStyle(fontSize: 11.5, height: 1.6, color: AppColors.softText)),
                    ],
                  ),
                ),
                Icon(Icons.chevron_left_rounded, color: AppColors.lavender),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _Metric extends StatelessWidget {
  const _Metric({required this.value, required this.label});
  final String value;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 9),
      decoration: BoxDecoration(color: Colors.white.withOpacity(0.70), borderRadius: BorderRadius.circular(14)),
      child: Column(
        children: [
          Text(value, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w900, color: AppColors.plum)),
          const SizedBox(height: 2),
          Text(label, textAlign: TextAlign.center, style: const TextStyle(fontSize: 8.8, fontWeight: FontWeight.w700, color: AppColors.mutedText)),
        ],
      ),
    );
  }
}

class _LessonCard extends StatelessWidget {
  const _LessonCard({required this.index, required this.lesson, required this.progress});

  final int index;
  final FiLesson lesson;
  final LearningLessonProgress progress;

  String get _status {
    if (progress.missionPending) return 'مهمة بالحياة — بانتظار المتابعة';
    if (progress.applied) return 'طُبقت بالحياة ${progress.realLifeApplications} مرة';
    if (progress.hasStarted) return 'جلسة تدريب بدأت';
    return 'جلسة جديدة';
  }

  Color get _statusColor {
    if (progress.applied) return AppColors.success;
    if (progress.missionPending) return AppColors.gold;
    return AppColors.lilac;
  }

  @override
  Widget build(BuildContext context) {
    return PremiumCard(
      onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => FiLessonScreen(lesson: lesson))),
      padding: const EdgeInsets.all(15),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: _statusColor.withOpacity(0.11),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Center(
              child: progress.applied
                  ? const Icon(Icons.eco_rounded, color: AppColors.success, size: 20)
                  : progress.missionPending
                      ? const Icon(Icons.schedule_rounded, color: AppColors.gold, size: 19)
                      : Text('$index', style: const TextStyle(fontWeight: FontWeight.w900, color: AppColors.lilac)),
            ),
          ),
          const SizedBox(width: 11),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(lesson.title, style: const TextStyle(fontSize: 13.5, fontWeight: FontWeight.w900, color: AppColors.plum)),
                const SizedBox(height: 3),
                Text(lesson.subtitle, style: const TextStyle(fontSize: 10.5, height: 1.5, color: AppColors.mutedText)),
                const SizedBox(height: 5),
                Text(_status, style: TextStyle(fontSize: 9.5, fontWeight: FontWeight.w900, color: _statusColor)),
              ],
            ),
          ),
          const Icon(Icons.chevron_left_rounded, color: AppColors.lavender),
        ],
      ),
    );
  }
}
