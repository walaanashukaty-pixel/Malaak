import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../models/journey_domain.dart';
import '../../../models/learning_journey_state.dart';
import '../../../state/app_scope.dart';
import '../../../widgets/premium_card.dart';
import '../../../widgets/section_header.dart';
import '../../../widgets/soft_icon.dart';
import '../data/fi_catalog.dart';
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
                  'ما رح نمشيك بمراحل ما بتشبهك. أول شي منعرف نقطة بدايتك من مواقف حقيقية، وبعدها ملاك بيفتحلك المسار الأقرب لإلك.',
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
                    'هذه خريطة تعليمية وليست تشخيصًا. النتيجة بتقول وين يبدأ تدريبك حاليًا، مو مين أنتِ كشخص.',
                    style: TextStyle(fontSize: 11.5, height: 1.65, fontWeight: FontWeight.w700, color: AppColors.plum),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 22),
          if (!state.assessmentCompleted) ...[
            const SectionHeader(
              title: 'خريطة البداية',
              subtitle: '12 موقف قصير. اختاري الأقرب لتصرفك الحقيقي، مو الجواب المثالي.',
            ),
            const SizedBox(height: 10),
            PremiumCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('نقطة بدايتك رح تحدد الرحلة', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w900, color: AppColors.plum)),
                  const SizedBox(height: 8),
                  const Text(
                    'ممكن يطلع تركيزك على إرضاء الآخرين، أو السيطرة والاستعجال، أو تكون عندك قاعدة متقدمة أصلًا. ما في نتيجة سيئة.',
                    style: TextStyle(fontSize: 12, height: 1.7, color: AppColors.softText),
                  ),
                  const SizedBox(height: 16),
                  _PrimaryButton(
                    label: state.answers.isEmpty ? 'ابدئي خريطة البداية' : 'كمّلي خريطة البداية',
                    icon: Icons.route_rounded,
                    onTap: () => Navigator.of(context).push(
                      MaterialPageRoute(builder: (_) => const FiAssessmentScreen()),
                    ),
                  ),
                ],
              ),
            ),
          ] else ...[
            const SectionHeader(title: 'نقطة بدايتك الحالية'),
            const SizedBox(height: 10),
            _ResultCard(state: state),
            const SizedBox(height: 22),
            if (state.routeId != 'advanced') ...[
              const SectionHeader(
                title: 'رحلتك الشخصية',
                subtitle: 'المسار ثابت وواضح، والتقدم بيتحفظ مع حسابك.',
              ),
              const SizedBox(height: 10),
              _RouteProgressCard(state: state),
            ] else ...[
              const SectionHeader(
                title: 'مختبر المواقف',
                subtitle: 'عندك أساس جيد؛ بدل ما نرجعك لورا، مندرّب الحكمة على موقف حقيقي.',
              ),
              const SizedBox(height: 10),
              _LabCard(state: state),
            ],
            const SizedBox(height: 18),
            Center(
              child: TextButton.icon(
                onPressed: () => Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => const FiAssessmentScreen(restart: true)),
                ),
                icon: const Icon(Icons.refresh_rounded, size: 18),
                label: const Text('إعادة خريطة البداية'),
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
    if (state.routeId == 'advanced') {
      return PremiumCard(
        color: AppColors.sage.withOpacity(0.13),
        child: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('عندك قاعدة قوية بالفعل 🌿', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w900, color: AppColors.plum)),
            SizedBox(height: 8),
            Text(
              'إجاباتك ما بتظهر حاجة واضحة لمسار السذاجة أو التعصب. لذلك ما رح نخترع مشكلة. بنبدأ مباشرة بتدريب الوقت، المسافة، المشاعر والنية على مواقف حقيقية.',
              style: TextStyle(fontSize: 12, height: 1.75, color: AppColors.softText),
            ),
          ],
        ),
      );
    }
    final route = FiCatalog.routeById(state.routeId ?? FiCatalog.feminineNaivetyRoute.id);
    return PremiumCard(
      color: AppColors.gold.withOpacity(0.08),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(route.resultTitle, style: const TextStyle(fontSize: 15.5, height: 1.45, fontWeight: FontWeight.w900, color: AppColors.plum)),
          const SizedBox(height: 9),
          Text(route.resultBody, style: const TextStyle(fontSize: 12, height: 1.75, color: AppColors.softText)),
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
    final completed = state.completedLessonIds.where((id) => route.lessons.any((lesson) => lesson.id == id)).length;
    final progress = route.lessons.isEmpty ? 0.0 : completed / route.lessons.length;
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
          const SizedBox(height: 9),
          Text('$completed من ${route.lessons.length} تدريبات مكتملة', style: const TextStyle(fontSize: 10.5, color: AppColors.mutedText, fontWeight: FontWeight.w700)),
        ],
      ),
    );
  }
}

class _LabCard extends StatelessWidget {
  const _LabCard({required this.state});

  final LearningJourneyState state;

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
                Text('6 خطوات منظمة تساعدك تفكري قبل ما تتصرفي.', style: TextStyle(fontSize: 11.5, height: 1.6, color: AppColors.softText)),
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
