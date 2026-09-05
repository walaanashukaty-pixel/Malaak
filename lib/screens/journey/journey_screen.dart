import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../data/app_catalog.dart';
import '../../features/feminine_intelligence/data/fi_catalog.dart';
import '../../features/feminine_intelligence/screens/feminine_intelligence_screen.dart';
import '../../models/journey_domain.dart';
import '../../models/journey_plan.dart';
import '../../models/learning_journey_state.dart';
import '../../state/app_scope.dart';
import '../../widgets/premium_card.dart';
import '../../widgets/section_header.dart';
import '../../widgets/soft_icon.dart';

class JourneyScreen extends StatelessWidget {
  const JourneyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final app = AppScope.of(context);
    final journeyPlan = app.state.journeyPlan;
    final learning = app.state.learningJourneys[FiCatalog.domainId] ??
        const LearningJourneyState(domainId: FiCatalog.domainId);
    final route = learning.routeId == null ? null : FiCatalog.routeById(learning.routeId!);
    final feminineDomain = AppCatalog.journeys.firstWhere((domain) => domain.id == FiCatalog.domainId);

    return SafeArea(
      bottom: false,
      child: ListView(
        padding: const EdgeInsets.fromLTRB(18, 16, 18, 122),
        children: [
          const _JourneyHeader(),
          if (journeyPlan?.isPaused == true) ...[
            const SizedBox(height: 14),
            _SafetyPauseCard(reasoning: journeyPlan?.reasoningSummaryAr ?? ''),
          ],
          const SizedBox(height: 22),
          const SectionHeader(
            title: 'رحلتك النشطة',
            subtitle: 'مسار واحد أساسي هلق. باقي الخريطة بتضل ظاهرة، بس مو كلها مفتوحة بنفس الوقت.',
          ),
          const SizedBox(height: 12),
          _ActiveJourneyCard(learning: learning, domain: feminineDomain),
          const SizedBox(height: 26),
          const SectionHeader(
            title: 'خريطة ملاك',
            subtitle: 'كل الأقسام موجودة قدامك. المقفول منها ما رح يتحول لدرس سريع؛ بينفتح كرحلة كاملة بوقتها.',
          ),
          const SizedBox(height: 12),
          ...AppCatalog.journeys.map((domain) => Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: _DomainRow(
                  domain: domain,
                  active: domain.id == FiCatalog.domainId && route != null,
                  available: domain.id == FiCatalog.domainId,
                  plan: journeyPlan,
                ),
              )),
        ],
      ),
    );
  }
}

class _JourneyHeader extends StatelessWidget {
  const _JourneyHeader();

  @override
  Widget build(BuildContext context) => PremiumCard(
        gradient: AppColors.heroGradient,
        child: const Row(
          children: [
            SoftIcon(icon: Icons.route_rounded, color: AppColors.lavender, size: 50),
            SizedBox(width: 13),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('رحلتي', style: TextStyle(fontSize: 22, fontWeight: FontWeight.w900, color: AppColors.plum)),
                  SizedBox(height: 4),
                  Text('تتعلمي، تطبقي بالحياة، ترجعي لملاك، وبعدها بس بتنفتح الخطوة الجديدة.', style: TextStyle(fontSize: 12, height: 1.6, color: AppColors.softText)),
                ],
              ),
            ),
          ],
        ),
      );
}

class _SafetyPauseCard extends StatelessWidget {
  const _SafetyPauseCard({required this.reasoning});
  final String reasoning;

  @override
  Widget build(BuildContext context) => PremiumCard(
        color: AppColors.rose.withOpacity(0.08),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SoftIcon(icon: Icons.health_and_safety_rounded, color: AppColors.rose, size: 44),
            const SizedBox(width: 11),
            Expanded(
              child: Text(
                reasoning.trim().isEmpty
                    ? 'الأمان والتثبيت أولًا. ملاك ممكن توقف فتح تحديات جديدة مؤقتًا حسب خريطة الدعم.'
                    : reasoning,
                style: const TextStyle(fontSize: 11.5, height: 1.65, color: AppColors.softText, fontWeight: FontWeight.w700),
              ),
            ),
          ],
        ),
      );
}

class _ActiveJourneyCard extends StatelessWidget {
  const _ActiveJourneyCard({required this.learning, required this.domain});

  final LearningJourneyState learning;
  final JourneyDomain domain;

  @override
  Widget build(BuildContext context) {
    final route = learning.routeId == null ? null : FiCatalog.routeById(learning.routeId!);
    final title = route?.title ?? 'بوصلة الذكاء الأنثوي';
    final subtitle = !learning.assessmentCompleted
        ? 'أول خطوة: جلسة بداية محادثية مع ملاك.'
        : route == null
            ? 'خريطتك جاهزة. شوفي النماذج الأربعة واختاري مسارك.'
            : 'هذا هو المسار المفتوح هلق. المراحل داخله بتنفتح بالإنجاز الحقيقي.';
    return PremiumCard(
      onTap: () => Navigator.of(context).push(
        MaterialPageRoute(builder: (_) => FeminineIntelligenceScreen(domain: domain)),
      ),
      borderColor: AppColors.lilac,
      padding: const EdgeInsets.all(19),
      child: Row(
        children: [
          const SoftIcon(icon: Icons.auto_awesome_rounded, color: AppColors.rose, size: 50),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('مفتوحة الآن', style: TextStyle(fontSize: 10, fontWeight: FontWeight.w900, color: AppColors.success)),
                const SizedBox(height: 4),
                Text(title, style: const TextStyle(fontSize: 16, height: 1.4, fontWeight: FontWeight.w900, color: AppColors.plum)),
                const SizedBox(height: 5),
                Text(subtitle, style: const TextStyle(fontSize: 11, height: 1.6, color: AppColors.softText)),
              ],
            ),
          ),
          const Icon(Icons.chevron_left_rounded, color: AppColors.lavender),
        ],
      ),
    );
  }
}

class _DomainRow extends StatelessWidget {
  const _DomainRow({
    required this.domain,
    required this.active,
    required this.available,
    required this.plan,
  });

  final JourneyDomain domain;
  final bool active;
  final bool available;
  final JourneyPlan? plan;

  String get plannerHint {
    if (plan?.primaryDomain == domain.id) return 'المسار الأساسي';
    if (plan?.supportDomain == domain.id) return 'مسار مساند';
    if (plan?.monitorDomains.contains(domain.id) == true) return 'مراقبة';
    if (plan?.laterDomains.contains(domain.id) == true) return 'لاحقًا';
    return '';
  }

  void _showLocked(BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      builder: (context) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 28),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SoftIcon(icon: domain.icon, color: domain.color, size: 48),
              const SizedBox(height: 12),
              Text(domain.title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w900, color: AppColors.plum)),
              const SizedBox(height: 7),
              Text(domain.subtitle, style: const TextStyle(fontSize: 12, height: 1.7, color: AppColors.softText)),
              const SizedBox(height: 14),
              const Text('مقفول مؤقتًا 🔒', style: TextStyle(fontSize: 12.5, fontWeight: FontWeight.w900, color: AppColors.gold)),
              const SizedBox(height: 5),
              const Text(
                'ملاك ما رح تفتحلك كل الأقسام دفعة وحدة. خلّي تركيزك على رحلتك النشطة، وكل قسم بيصير رحلة تفاعلية كاملة بدل صفحة قصيرة تنتهي بسرعة.',
                style: TextStyle(fontSize: 11.5, height: 1.7, color: AppColors.softText),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final statusText = active ? 'رحلتك الحالية' : available ? 'متاح' : 'مقفول';
    final statusColor = active ? AppColors.success : available ? AppColors.lilac : AppColors.mutedText;
    return PremiumCard(
      onTap: available
          ? () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => FeminineIntelligenceScreen(domain: domain)))
          : () => _showLocked(context),
      color: available ? Colors.white : AppColors.muted.withOpacity(0.42),
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 14),
      child: Row(
        children: [
          SoftIcon(icon: domain.icon, color: available ? domain.color : AppColors.mutedText, size: 40),
          const SizedBox(width: 11),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(domain.title, style: TextStyle(fontSize: 13.5, fontWeight: FontWeight.w900, color: available ? AppColors.plum : AppColors.mutedText)),
                const SizedBox(height: 3),
                Text(domain.subtitle, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(fontSize: 10.5, color: AppColors.mutedText)),
                if (plannerHint.isNotEmpty) ...[
                  const SizedBox(height: 3),
                  Text(plannerHint, style: const TextStyle(fontSize: 9.2, fontWeight: FontWeight.w800, color: AppColors.gold)),
                ],
              ],
            ),
          ),
          const SizedBox(width: 8),
          if (!available) const Icon(Icons.lock_rounded, color: AppColors.mutedText, size: 17),
          const SizedBox(width: 5),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 6),
            decoration: BoxDecoration(color: statusColor.withOpacity(0.10), borderRadius: BorderRadius.circular(14)),
            child: Text(statusText, style: TextStyle(fontSize: 9.5, fontWeight: FontWeight.w800, color: statusColor)),
          ),
        ],
      ),
    );
  }
}
