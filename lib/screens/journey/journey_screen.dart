import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../data/app_catalog.dart';
import '../../models/journey_domain.dart';
import '../../models/journey_plan.dart';
import '../../state/app_scope.dart';
import '../../widgets/premium_card.dart';
import '../../widgets/section_header.dart';
import '../../widgets/soft_icon.dart';
import 'domain_detail_screen.dart';

JourneyDomain? _journeyDomain(String? id) {
  if (id == null || id.trim().isEmpty) return null;
  for (final domain in AppCatalog.journeys) {
    if (domain.id == id) return domain;
  }
  return null;
}

class JourneyScreen extends StatelessWidget {
  const JourneyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final app = AppScope.of(context);
    final plan = app.state.journeyPlan;
    final primary = _journeyDomain(plan?.primaryDomain);
    final support = _journeyDomain(plan?.supportDomain);
    final monitors = (plan?.monitorDomains ?? const <String>[])
        .map(_journeyDomain)
        .whereType<JourneyDomain>()
        .take(2)
        .toList(growable: false);
    final later = (plan?.laterDomains ?? const <String>[])
        .map(_journeyDomain)
        .whereType<JourneyDomain>()
        .take(3)
        .toList(growable: false);

    return SafeArea(
      bottom: false,
      child: ListView(
        padding: const EdgeInsets.fromLTRB(18, 16, 18, 122),
        children: [
          const _JourneyHeader(),
          const SizedBox(height: 22),
          const SectionHeader(title: 'وين عم نشتغل هلأ؟', subtitle: 'مسار أساسي واحد، ومهارة مساندة واحدة فقط لما تكون مفيدة.'),
          const SizedBox(height: 12),
          if (plan == null)
            _PendingPlanCard(startingFocus: app.state.initialMap?.startingFocus)
          else if (plan.isPaused)
            _PausedPlanCard(reasoning: plan.reasoningSummaryAr)
          else if (primary == null)
            const _MaintenancePlanCard()
          else ...[
            _PriorityJourneyCard(
              domain: primary,
              label: '🎯 المسار الأساسي',
              note: plan.primaryGoal ?? primary.currentSkill,
            ),
            if (support != null) ...[
              const SizedBox(height: 12),
              _CompactJourneyCard(
                domain: support,
                label: '🟡 مسار مساند',
                note: plan.supportGoal ?? support.currentSkill,
              ),
            ],
            if (monitors.isNotEmpty) ...[
              const SizedBox(height: 22),
              const SectionHeader(title: 'مراقبة', subtitle: 'مهمين، بس ما رح نفتّح تدريب كامل عليهم هلق.'),
              const SizedBox(height: 10),
              ...monitors.map((domain) => Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: _CompactJourneyCard(domain: domain, label: '👀 مراقبة', note: 'منراقب إذا عم يزيد أثره أو يرجع كنمط متكرر.'),
                  )),
            ],
            if (later.isNotEmpty) ...[
              const SizedBox(height: 18),
              const SectionHeader(title: 'لاحقًا', subtitle: 'مواضيع ممكن نرجعلها لما يصير الوقت والسياق أنسب.'),
              const SizedBox(height: 10),
              ...later.map((domain) => Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: _CompactJourneyCard(domain: domain, label: '🕊️ لاحقًا', note: 'مهم، بس مو أولوية العمل الحالية.'),
                  )),
            ],
          ],
          if (plan != null && plan.reasoningSummaryAr.trim().isNotEmpty) ...[
            const SizedBox(height: 14),
            _ReasoningCard(text: plan.reasoningSummaryAr),
          ],
          const SizedBox(height: 26),
          const SectionHeader(title: 'خريطتي كاملة', subtitle: 'كل المجالات موجودة، بس حالتها تتحدد من خطتك الحالية بدون نسب أو تشخيص.'),
          const SizedBox(height: 12),
          ...AppCatalog.journeys.map((domain) => Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: _DomainRow(domain: domain, plan: plan),
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
                  Text('خطة واحدة تتغير حسب حياتك — مو مكتبة دروس لازم تكمليها كلها.', style: TextStyle(fontSize: 12, height: 1.6, color: AppColors.softText)),
                ],
              ),
            ),
          ],
        ),
      );
}

class _PendingPlanCard extends StatelessWidget {
  const _PendingPlanCard({this.startingFocus});
  final String? startingFocus;
  @override
  Widget build(BuildContext context) => PremiumCard(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SoftIcon(icon: Icons.auto_awesome_rounded, color: AppColors.lavender, size: 46),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('الخطة عم تتكوّن', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w900, color: AppColors.plum)),
                  const SizedBox(height: 5),
                  Text(startingFocus ?? 'منحتاج مواقف حقيقية أكتر قبل ما نثبت مسار أساسي.', style: const TextStyle(fontSize: 11.5, height: 1.65, color: AppColors.softText)),
                ],
              ),
            ),
          ],
        ),
      );
}

class _PausedPlanCard extends StatelessWidget {
  const _PausedPlanCard({required this.reasoning});
  final String reasoning;
  @override
  Widget build(BuildContext context) => PremiumCard(
        color: AppColors.rose.withOpacity(0.08),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SoftIcon(icon: Icons.health_and_safety_rounded, color: AppColors.rose, size: 46),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('وضع دعم وتثبيت', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w900, color: AppColors.plum)),
                  const SizedBox(height: 5),
                  Text(reasoning.isEmpty ? 'وقفنا أهداف النمو مؤقتًا. الأمان والاستقرار أهم من فتح تدريب جديد.' : reasoning, style: const TextStyle(fontSize: 11.5, height: 1.65, color: AppColors.softText)),
                ],
              ),
            ),
          ],
        ),
      );
}

class _MaintenancePlanCard extends StatelessWidget {
  const _MaintenancePlanCard();
  @override
  Widget build(BuildContext context) => PremiumCard(
        child: const Row(
          children: [
            SoftIcon(icon: Icons.eco_rounded, color: AppColors.sage, size: 46),
            SizedBox(width: 12),
            Expanded(child: Text('وضع المحافظة: ما في داعي نفتح مسار عميق جديد هلق. منتابع الاستقرار وملاك بتضل موجودة للأحداث الحقيقية.', style: TextStyle(fontSize: 12, height: 1.7, color: AppColors.softText, fontWeight: FontWeight.w700))),
          ],
        ),
      );
}

class _ReasoningCard extends StatelessWidget {
  const _ReasoningCard({required this.text});
  final String text;
  @override
  Widget build(BuildContext context) => PremiumCard(
        color: AppColors.lavender.withOpacity(0.07),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SoftIcon(icon: Icons.lightbulb_outline_rounded, color: AppColors.lavender, size: 40),
            const SizedBox(width: 11),
            Expanded(child: Text(text, style: const TextStyle(fontSize: 11.5, height: 1.7, color: AppColors.softText))),
          ],
        ),
      );
}

class _PriorityJourneyCard extends StatelessWidget {
  const _PriorityJourneyCard({required this.domain, required this.label, required this.note});
  final JourneyDomain domain;
  final String label;
  final String note;
  @override
  Widget build(BuildContext context) => PremiumCard(
        onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => DomainDetailScreen(domain: domain))),
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w800, color: AppColors.mutedText)),
            const SizedBox(height: 10),
            Row(
              children: [
                SoftIcon(icon: domain.icon, color: domain.color, size: 50),
                const SizedBox(width: 12),
                Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text(domain.title, style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w900, color: AppColors.plum)),
                  const SizedBox(height: 4),
                  Text('المرحلة: ${domain.currentStage}', style: const TextStyle(fontSize: 11.5, fontWeight: FontWeight.w700, color: AppColors.softText)),
                ])),
                const Icon(Icons.chevron_left_rounded, color: AppColors.lavender),
              ],
            ),
            const SizedBox(height: 14),
            Text(note, style: const TextStyle(fontSize: 12, height: 1.7, color: AppColors.softText)),
          ],
        ),
      );
}

class _CompactJourneyCard extends StatelessWidget {
  const _CompactJourneyCard({required this.domain, required this.label, required this.note});
  final JourneyDomain domain;
  final String label;
  final String note;
  @override
  Widget build(BuildContext context) => PremiumCard(
        onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => DomainDetailScreen(domain: domain))),
        padding: const EdgeInsets.all(16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SoftIcon(icon: domain.icon, color: domain.color, size: 42),
            const SizedBox(width: 11),
            Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(label, style: const TextStyle(fontSize: 10.5, fontWeight: FontWeight.w800, color: AppColors.mutedText)),
              const SizedBox(height: 4),
              Text(domain.title, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w900, color: AppColors.plum)),
              const SizedBox(height: 3),
              Text(note, style: const TextStyle(fontSize: 10.5, height: 1.55, color: AppColors.softText)),
            ])),
          ],
        ),
      );
}

class _DomainRow extends StatelessWidget {
  const _DomainRow({required this.domain, required this.plan});
  final JourneyDomain domain;
  final JourneyPlan? plan;

  String get state {
    if (plan?.primaryDomain == domain.id) return 'التركيز الحالي';
    if (plan?.supportDomain == domain.id) return 'مساند';
    if (plan?.monitorDomains.contains(domain.id) == true) return 'مراقبة';
    if (plan?.laterDomains.contains(domain.id) == true) return 'لاحقًا';
    if (plan?.isMaintenance == true) return 'محافظة';
    return 'غير مفتوح';
  }

  @override
  Widget build(BuildContext context) => PremiumCard(
        onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => DomainDetailScreen(domain: domain))),
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 14),
        child: Row(
          children: [
            SoftIcon(icon: domain.icon, color: domain.color, size: 40),
            const SizedBox(width: 11),
            Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(domain.title, style: const TextStyle(fontSize: 13.5, fontWeight: FontWeight.w900, color: AppColors.plum)),
              const SizedBox(height: 3),
              Text(domain.subtitle, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(fontSize: 10.5, color: AppColors.mutedText)),
            ])),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 6),
              decoration: BoxDecoration(color: domain.color.withOpacity(0.12), borderRadius: BorderRadius.circular(14)),
              child: Text(state, style: TextStyle(fontSize: 9.5, fontWeight: FontWeight.w800, color: domain.color)),
            ),
          ],
        ),
      );
}
