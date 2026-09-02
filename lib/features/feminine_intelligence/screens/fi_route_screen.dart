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
    final completed = saved.completedLessonIds.where((id) => route.lessons.any((lesson) => lesson.id == id)).length;
    final progress = completed / route.lessons.length;

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
                const SizedBox(height: 8),
                Text('$completed من ${route.lessons.length}', style: const TextStyle(fontSize: 10.5, fontWeight: FontWeight.w800, color: AppColors.mutedText)),
              ],
            ),
          ),
          const SizedBox(height: 18),
          for (var i = 0; i < route.lessons.length; i++) ...[
            _LessonCard(
              index: i + 1,
              lesson: route.lessons[i],
              completed: saved.completedLessonIds.contains(route.lessons[i].id),
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
                      Text('جرّبي مختبر المواقف', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w900, color: AppColors.plum)),
                      SizedBox(height: 4),
                      Text('طبقي اللي عم تتعلميه على موقف حقيقي من حياتك.', style: TextStyle(fontSize: 11.5, height: 1.6, color: AppColors.softText)),
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

class _LessonCard extends StatelessWidget {
  const _LessonCard({required this.index, required this.lesson, required this.completed});

  final int index;
  final FiLesson lesson;
  final bool completed;

  @override
  Widget build(BuildContext context) {
    return PremiumCard(
      onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => FiLessonScreen(lesson: lesson))),
      padding: const EdgeInsets.all(15),
      child: Row(
        children: [
          Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              color: completed ? AppColors.sage.withOpacity(0.18) : AppColors.lavender.withOpacity(0.12),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Center(
              child: completed
                  ? const Icon(Icons.check_rounded, color: AppColors.success, size: 20)
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
                Text(lesson.subtitle, style: const TextStyle(fontSize: 10.5, height: 1.55, color: AppColors.mutedText)),
              ],
            ),
          ),
          const Icon(Icons.chevron_left_rounded, color: AppColors.lavender),
        ],
      ),
    );
  }
}
