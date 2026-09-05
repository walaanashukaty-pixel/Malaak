import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../models/journey_domain.dart';
import '../../../models/learning_journey_state.dart';
import '../../../state/app_scope.dart';
import '../../../widgets/premium_card.dart';
import '../../../widgets/section_header.dart';
import '../../../widgets/soft_icon.dart';
import '../data/fi_catalog.dart';
import '../logic/fi_progression.dart';
import 'fi_assessment_result_screen.dart';
import 'fi_assessment_screen.dart';
import 'fi_route_screen.dart';
import 'fi_situation_lab_screen.dart';

class FeminineIntelligenceScreen extends StatelessWidget {
  const FeminineIntelligenceScreen({super.key, required this.domain});

  final JourneyDomain domain;

  @override
  Widget build(BuildContext context) {
    final app = AppScope.of(context);
    final state = app.state.learningJourneys[FiCatalog.domainId] ??
        const LearningJourneyState(domainId: FiCatalog.domainId);

    return Scaffold(
      appBar: AppBar(
        title: const Text('بوصلة الذكاء الأنثوي', style: TextStyle(fontSize: 17, fontWeight: FontWeight.w900)),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(18, 8, 18, 40),
        children: [
          PremiumCard(
            gradient: AppColors.heroGradient,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SoftIcon(icon: Icons.explore_rounded, color: AppColors.gold, size: 58),
                const SizedBox(height: 16),
                const Text('الذكاء الأنثوي هو الوجهة ✨', style: TextStyle(fontSize: 22, fontWeight: FontWeight.w900, color: AppColors.plum)),
                const SizedBox(height: 7),
                const Text(
                  'ملاك بتتعرف على طريقتك من محادثة قصيرة، بترشحلك نقطة بداية، وإنتِ بتختاري المسار. وبعدها التدريب بيصير جلسات ومهام بالحياة، مو مجرد قراءة وتكبيس.',
                  style: TextStyle(fontSize: 12.5, height: 1.8, color: AppColors.softText),
                ),
                const SizedBox(height: 16),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.74),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: AppColors.border),
                  ),
                  child: const Text(
                    'النماذج الأربعة إطار تعليمي، مو تشخيص. ممكن يختلف أسلوبك حسب العلاقة والموقف، وترشيح ملاك مجرد نقطة بداية قابلة للتغيير.',
                    style: TextStyle(fontSize: 11.5, height: 1.65, fontWeight: FontWeight.w700, color: AppColors.plum),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 22),
          if (!state.assessmentCompleted) ...[
            const SectionHeader(
              title: 'جلسة البداية مع ملاك',
              subtitle: 'محادثة قصيرة من مواقف حقيقية. فيكي ترجعي وتعدلي أي جواب قبل النتيجة.',
            ),
            const SizedBox(height: 10),
            PremiumCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('خلينا نتعرف عليك أولًا', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w900, color: AppColors.plum)),
                  const SizedBox(height: 8),
                  const Text(
                    'ما في جواب صح أو غلط. ملاك رح تسمع إجاباتك، تعكسلك اللي لاحظته، وبالنهاية تعرض النماذج الأربعة وتقدم ترشيحها فقط.',
                    style: TextStyle(fontSize: 12, height: 1.7, color: AppColors.softText),
                  ),
                  const SizedBox(height: 16),
                  _PrimaryButton(
                    label: state.answers.isEmpty ? 'ابدئي الجلسة' : 'كمّلي الجلسة',
                    icon: Icons.chat_bubble_outline_rounded,
                    onTap: () => Navigator.of(context).push(
                      MaterialPageRoute(builder: (_) => const FiAssessmentScreen()),
                    ),
                  ),
                ],
              ),
            ),
          ] else ...[
            const SectionHeader(title: 'خريطتك الحالية'),
            const SizedBox(height: 10),
            _ResultCard(state: state),
            const SizedBox(height: 12),
            if (state.routeId == null)
              _PrimaryButton(
                label: 'شوفي النماذج الأربعة واختاري مسارك',
                icon: Icons.route_rounded,
                onTap: () {
                  final recommended = state.recommendedRouteId ?? FiCatalog.feminineIntelligenceRoute.id;
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (_) => FiAssessmentResultScreen(recommendedRouteId: recommended),
                  ));
                },
              )
            else ...[
              const SectionHeader(
                title: 'رحلتك الحالية',
                subtitle: 'التقدم بيتحسب من التدريب والتطبيق بالحياة، مو من فتح الدرس.',
              ),
              const SizedBox(height: 10),
              _RouteProgressCard(state: state),
              const SizedBox(height: 18),
              const SectionHeader(
                title: 'مختبر المواقف',
                subtitle: 'استخدمي المهارات على موقف حقيقي بأي وقت.',
              ),
              const SizedBox(height: 10),
              const _LabCard(),
              const SizedBox(height: 14),
              Center(
                child: TextButton.icon(
                  onPressed: () {
                    final recommended = state.recommendedRouteId ?? state.routeId!;
                    Navigator.of(context).push(MaterialPageRoute(
                      builder: (_) => FiAssessmentResultScreen(recommendedRouteId: recommended),
                    ));
                  },
                  icon: const Icon(Icons.swap_horiz_rounded, size: 18),
                  label: const Text('تغيير المسار'),
                ),
              ),
            ],
            Center(
              child: TextButton.icon(
                onPressed: () => Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => const FiAssessmentScreen(restart: true)),
                ),
                icon: const Icon(Icons.refresh_rounded, size: 18),
                label: const Text('إعادة جلسة البداية'),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _ResultCard extends StatelessWidget {
  const _ResultCard({required this.state});

  final LearningJourneyState state;

  @override
  Widget build(BuildContext context) {
    final recommendedId = state.recommendedRouteId ?? state.routeId ?? FiCatalog.feminineIntelligenceRoute.id;
    final recommended = FiCatalog.modelByRouteId(recommendedId);
    final chosen = state.routeId == null ? null : FiCatalog.modelByRouteId(state.routeId!);
    return PremiumCard(
      color: AppColors.gold.withOpacity(0.08),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('⭐ ترشيح ملاك كبداية', style: TextStyle(fontSize: 10.5, fontWeight: FontWeight.w900, color: AppColors.gold)),
          const SizedBox(height: 5),
          Text(recommended.title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w900, color: AppColors.plum)),
          const SizedBox(height: 7),
          Text(recommended.description, style: const TextStyle(fontSize: 11.5, height: 1.7, color: AppColors.softText)),
          if (chosen != null) ...[
            const SizedBox(height: 12),
            Container(height: 1, color: AppColors.border),
            const SizedBox(height: 11),
            Text('المسار اللي اخترتيه: ${chosen.title}', style: const TextStyle(fontSize: 11.5, fontWeight: FontWeight.w900, color: AppColors.plum)),
          ],
        ],
      ),
    );
  }
}

class _RouteProgressCard extends StatelessWidget {
  const _RouteProgressCard({required this.state});

  final LearningJourneyState state;

  @override
  Widget build(BuildContext context) {
    final route = FiCatalog.routeById(state.routeId ?? FiCatalog.feminineNaivetyRoute.id);
    final progressEntries = route.lessons.map((lesson) => state.lessonProgress[lesson.id]).whereType<LearningLessonProgress>().toList();
    final mastered = <FiNodeStatus>[
      for (var i = 0; i < route.lessons.length; i++)
        FiProgression.nodeStatus(index: i, lessons: route.lessons, state: state),
    ].where((status) => status == FiNodeStatus.mastered).length;
    final applied = progressEntries.fold<int>(0, (total, progress) => total + progress.realLifeApplications);
    final progress = route.lessons.isEmpty ? 0.0 : mastered / route.lessons.length;
    return PremiumCard(
      onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => FiRouteScreen(routeId: route.id))),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const SoftIcon(icon: Icons.auto_awesome_rounded, color: AppColors.rose, size: 48),
              const SizedBox(width: 12),
              Expanded(child: Text(route.title, style: const TextStyle(fontSize: 14.5, height: 1.45, fontWeight: FontWeight.w900, color: AppColors.plum))),
              const Icon(Icons.chevron_left_rounded, color: AppColors.lavender),
            ],
          ),
          const SizedBox(height: 15),
          ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: LinearProgressIndicator(
              value: progress,
              minHeight: 8,
              backgroundColor: AppColors.muted,
              color: AppColors.lilac,
            ),
          ),
          const SizedBox(height: 11),
          Row(
            children: [
              Expanded(child: _MiniMetric(label: 'مهارات مكتسبة', value: '$mastered/${route.lessons.length}')),
              const SizedBox(width: 8),
              Expanded(child: _MiniMetric(label: 'تطبيقات حقيقية', value: '$applied')),
            ],
          ),
        ],
      ),
    );
  }
}

class _MiniMetric extends StatelessWidget {
  const _MiniMetric({required this.label, required this.value});
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 9),
      decoration: BoxDecoration(color: AppColors.muted.withOpacity(0.65), borderRadius: BorderRadius.circular(14)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(value, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w900, color: AppColors.plum)),
          Text(label, style: const TextStyle(fontSize: 9.5, fontWeight: FontWeight.w700, color: AppColors.mutedText)),
        ],
      ),
    );
  }
}

class _LabCard extends StatelessWidget {
  const _LabCard();

  @override
  Widget build(BuildContext context) {
    return PremiumCard(
      onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => const FiSituationLabScreen())),
      child: const Row(
        children: [
          SoftIcon(icon: Icons.science_rounded, color: AppColors.sage, size: 48),
          SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('عندي موقف الآن', style: TextStyle(fontSize: 14.5, fontWeight: FontWeight.w900, color: AppColors.plum)),
                SizedBox(height: 4),
                Text('مشي الموقف مع ملاك خطوة خطوة بدل ما تاخدي جواب جاهز.', style: TextStyle(fontSize: 11.5, height: 1.6, color: AppColors.softText)),
              ],
            ),
          ),
          Icon(Icons.chevron_left_rounded, color: AppColors.lavender),
        ],
      ),
    );
  }
}

class _PrimaryButton extends StatelessWidget {
  const _PrimaryButton({required this.label, required this.icon, required this.onTap});
  final String label;
  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(18),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
        decoration: BoxDecoration(gradient: AppColors.primaryGradient, borderRadius: BorderRadius.circular(18)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: Colors.white, size: 19),
            const SizedBox(width: 8),
            Text(label, style: const TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.w900)),
          ],
        ),
      ),
    );
  }
}
