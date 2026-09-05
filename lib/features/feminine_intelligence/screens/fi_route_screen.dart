import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../models/learning_journey_state.dart';
import '../../../state/app_scope.dart';
import '../../../widgets/premium_card.dart';
import '../../../widgets/soft_icon.dart';
import '../data/fi_catalog.dart';
import '../logic/fi_progression.dart';
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
    final now = DateTime.now();
    final statuses = <FiNodeStatus>[
      for (var i = 0; i < route.lessons.length; i++)
        FiProgression.nodeStatus(index: i, lessons: route.lessons, state: saved, now: now),
    ];
    final progressList = route.lessons
        .map((lesson) => saved.lessonProgress[lesson.id])
        .whereType<LearningLessonProgress>()
        .toList();
    final mastered = statuses.where((status) => status == FiNodeStatus.mastered).length;
    final applications = progressList.fold<int>(0, (total, progress) => total + progress.realLifeApplications);
    final readyFollowUps = statuses.where((status) => status == FiNodeStatus.followupReady).length;
    final progress = route.lessons.isEmpty ? 0.0 : mastered / route.lessons.length;
    final activeIndex = FiProgression.currentNodeIndex(lessons: route.lessons, state: saved, now: now);
    final routeMastered = FiProgression.isRouteMastered(lessons: route.lessons, state: saved);

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
                  child: LinearProgressIndicator(
                    value: progress,
                    minHeight: 8,
                    backgroundColor: AppColors.muted,
                    color: AppColors.lilac,
                  ),
                ),
                const SizedBox(height: 10),
                const Text('جلسات تدريب موجودة داخل كل مهارة، بس ما بتنحسب إتقان إلا بعد التطبيق والمتابعة.', style: TextStyle(fontSize: 9.5, height: 1.5, color: AppColors.mutedText, fontWeight: FontWeight.w700)),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(child: _Metric(value: '$mastered', label: 'مهارات مكتسبة')),
                    const SizedBox(width: 8),
                    Expanded(child: _Metric(value: '$applications', label: 'تطبيقات حقيقية')),
                    const SizedBox(width: 8),
                    Expanded(child: _Metric(value: '$readyFollowUps', label: 'متابعة جاهزة')),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 14),
          PremiumCard(
            color: AppColors.gold.withOpacity(0.07),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SoftIcon(icon: Icons.key_rounded, color: AppColors.gold, size: 40),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('كيف بتنفتح الخطوة التالية؟', style: TextStyle(fontSize: 12.5, fontWeight: FontWeight.w900, color: AppColors.plum)),
                      const SizedBox(height: 5),
                      Text(
                        FiProgression.nextUnlockReason(lessons: route.lessons, state: saved, now: now),
                        style: const TextStyle(fontSize: 10.8, height: 1.65, color: AppColors.softText),
                      ),
                    ],
                  ),
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
              status: statuses[i],
              isCurrent: i == activeIndex,
            ),
            const SizedBox(height: 10),
          ],
          if (routeMastered) ...[
            const SizedBox(height: 10),
            PremiumCard(
              onTap: route.id == FiCatalog.feminineIntelligenceRoute.id
                  ? () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => const FiSituationLabScreen()))
                  : () async {
                      final app = AppScope.of(context);
                      final current = app.state.learningJourneys[FiCatalog.domainId] ?? saved;
                      await app.saveLearningJourneyState(
                        current.copyWith(routeId: FiCatalog.feminineIntelligenceRoute.id),
                      );
                      if (!context.mounted) return;
                      Navigator.of(context).pushReplacement(
                        MaterialPageRoute(
                          builder: (_) => FiRouteScreen(routeId: FiCatalog.feminineIntelligenceRoute.id),
                        ),
                      );
                    },
              gradient: AppColors.heroGradient,
              child: Row(
                children: [
                  const SoftIcon(icon: Icons.auto_awesome_rounded, color: AppColors.rose, size: 48),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('فصل جديد 🔓', style: TextStyle(fontSize: 10.5, fontWeight: FontWeight.w900, color: AppColors.success)),
                        const SizedBox(height: 4),
                        Text(
                          route.id == FiCatalog.feminineIntelligenceRoute.id
                              ? 'المستوى المتقدم • مختبر الحياة'
                              : 'المستوى المتقدم • تعميق الذكاء الأنثوي',
                          style: const TextStyle(fontSize: 14.5, fontWeight: FontWeight.w900, color: AppColors.plum),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          route.id == FiCatalog.feminineIntelligenceRoute.id
                              ? 'المسار ما خلص؛ من هون بصير التدريب على أحداثك الحقيقية وصيانة المهارة.'
                              : 'خلصتي الأساس. هلق منضيف التوقيت، المسافة، المشاعر والنية بمواقف أصعب.',
                          style: const TextStyle(fontSize: 10.8, height: 1.6, color: AppColors.softText),
                        ),
                      ],
                    ),
                  ),
                  const Icon(Icons.chevron_left_rounded, color: AppColors.lavender),
                ],
              ),
            ),
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
                      Text('مختبر المواقف — متاح دائمًا', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w900, color: AppColors.plum)),
                      SizedBox(height: 4),
                      Text('إذا المرحلة الأساسية ناطرة متابعة، فيكي تستخدمي هون موقف حقيقي بدون ما نفتّح المرحلة اللي بعدها.', style: TextStyle(fontSize: 11.5, height: 1.6, color: AppColors.softText)),
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
  const _LessonCard({
    required this.index,
    required this.lesson,
    required this.progress,
    required this.status,
    required this.isCurrent,
  });

  final int index;
  final FiLesson lesson;
  final LearningLessonProgress progress;
  final FiNodeStatus status;
  final bool isCurrent;

  String get _statusLabel {
    switch (status) {
      case FiNodeStatus.locked:
        return 'مقفولة — أتقني الخطوة اللي قبلها أولًا';
      case FiNodeStatus.available:
        return 'جاهزة للبدء';
      case FiNodeStatus.inProgress:
        if (progress.substituteSimulationPending) return 'محاكاة بديلة مطلوبة';
        if (progress.retryRequired) return 'محاولة إصلاح مطلوبة';
        return 'قيد التدريب';
      case FiNodeStatus.missionPending:
        return 'مهمة بالحياة — بانتظار وقت المتابعة';
      case FiNodeStatus.followupReady:
        return 'متابعة جاهزة — ارجعي لملاك';
      case FiNodeStatus.mastered:
        return 'مهارة مكتسبة • ${progress.realLifeApplications} تطبيق حقيقي';
    }
  }

  Color get _statusColor {
    switch (status) {
      case FiNodeStatus.mastered:
        return AppColors.success;
      case FiNodeStatus.followupReady:
      case FiNodeStatus.missionPending:
        return AppColors.gold;
      case FiNodeStatus.locked:
        return AppColors.mutedText;
      default:
        return AppColors.lilac;
    }
  }

  IconData get _icon {
    switch (status) {
      case FiNodeStatus.locked:
        return Icons.lock_rounded;
      case FiNodeStatus.mastered:
        return Icons.workspace_premium_rounded;
      case FiNodeStatus.followupReady:
        return Icons.notifications_active_rounded;
      case FiNodeStatus.missionPending:
        return Icons.schedule_rounded;
      case FiNodeStatus.inProgress:
        return Icons.psychology_alt_rounded;
      case FiNodeStatus.available:
        return Icons.play_arrow_rounded;
    }
  }

  @override
  Widget build(BuildContext context) {
    final actionable = FiProgression.isNodeActionable(status);
    return PremiumCard(
      onTap: status == FiNodeStatus.locked ? null : () {
        Navigator.of(context).push(MaterialPageRoute(builder: (_) => FiLessonScreen(lesson: lesson)));
      },
      borderColor: isCurrent && actionable ? AppColors.lilac : AppColors.border,
      color: status == FiNodeStatus.locked ? AppColors.muted.withOpacity(0.45) : Colors.white,
      padding: const EdgeInsets.all(15),
      child: Row(
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: _statusColor.withOpacity(0.11),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(_icon, color: _statusColor, size: 20),
          ),
          const SizedBox(width: 11),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    if (isCurrent && status != FiNodeStatus.mastered) ...[
                      const Text('الخطوة الحالية • ', style: TextStyle(fontSize: 9, fontWeight: FontWeight.w900, color: AppColors.rose)),
                    ],
                    Text('المرحلة $index', style: const TextStyle(fontSize: 9, fontWeight: FontWeight.w800, color: AppColors.mutedText)),
                  ],
                ),
                const SizedBox(height: 3),
                Text(lesson.title, style: TextStyle(fontSize: 13.5, fontWeight: FontWeight.w900, color: status == FiNodeStatus.locked ? AppColors.mutedText : AppColors.plum)),
                const SizedBox(height: 3),
                Text(lesson.subtitle, style: const TextStyle(fontSize: 10.5, height: 1.5, color: AppColors.mutedText)),
                const SizedBox(height: 5),
                Text(_statusLabel, style: TextStyle(fontSize: 9.5, height: 1.4, fontWeight: FontWeight.w900, color: _statusColor)),
              ],
            ),
          ),
          if (actionable)
            const Icon(Icons.chevron_left_rounded, color: AppColors.lavender)
          else
            const Icon(Icons.lock_outline_rounded, color: AppColors.mutedText, size: 18),
        ],
      ),
    );
  }
}
