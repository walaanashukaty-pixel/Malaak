import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../data/app_catalog.dart';
import '../../features/feminine_intelligence/data/fi_catalog.dart';
import '../../features/feminine_intelligence/logic/fi_progression.dart';
import '../../features/feminine_intelligence/screens/fi_route_screen.dart';
import '../../models/learning_journey_state.dart';
import '../../models/journey_domain.dart';
import '../../models/journey_plan.dart';
import '../../screens/journey/domain_detail_screen.dart';
import '../../screens/tools/tool_detail_screen.dart';
import '../../widgets/premium_card.dart';
import '../../widgets/section_header.dart';
import '../../widgets/soft_icon.dart';
import '../../state/app_scope.dart';

JourneyDomain? _journeyDomainOrNull(String? id) {
  if (id == null || id.trim().isEmpty) return null;
  for (final domain in AppCatalog.journeys) {
    if (domain.id == id) return domain;
  }
  return null;
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({
    super.key,
    required this.onOpenMalaak,
    required this.onOpenJourney,
    required this.onOpenProfile,
  });

  final ValueChanged<String?> onOpenMalaak;
  final VoidCallback onOpenJourney;
  final VoidCallback onOpenProfile;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String _mood = '🌿 منيحة نسبيًا';

  @override
  Widget build(BuildContext context) {
    final quickTools = AppCatalog.quickTools.take(6).toList();
    final app = AppScope.of(context);
    final fiLearning = app.state.learningJourneys[FiCatalog.domainId] ??
        const LearningJourneyState(domainId: FiCatalog.domainId);
    final fiRoute = fiLearning.routeId == null ? null : FiCatalog.routeById(fiLearning.routeId!);
    final journeyPlan = app.state.journeyPlan;
    final primaryDomain = _journeyDomainOrNull(journeyPlan?.primaryDomain);
    final supportDomain = _journeyDomainOrNull(journeyPlan?.supportDomain);
    final followUp = app.state.pendingFollowUps.isEmpty ? null : app.state.pendingFollowUps.last;
    final focusText = journeyPlan?.isPaused == true
        ? 'الأمان والتثبيت أولاً — ما رح نفتح تحدي تطوير جديد هلق.'
        : journeyPlan?.primaryGoal?.trim().isNotEmpty == true
            ? journeyPlan!.primaryGoal!
            : app.state.initialMap?.startingFocus ?? 'الخريطة عم تتكوّن من مواقفك الحقيقية خطوة بخطوة.';
    final insightText = journeyPlan?.reasoningSummaryAr.trim().isNotEmpty == true
        ? journeyPlan!.reasoningSummaryAr
        : 'لسه ما عنا بيانات كفاية لنثبت نمط. ملاك رح تراقب اللي يتكرر بدون ما تحول موقف واحد لحقيقة عنك.';

    return SafeArea(
      bottom: false,
      child: ListView(
        padding: const EdgeInsets.fromLTRB(18, 16, 18, 122),
        children: [
          _TopHeader(onProfile: widget.onOpenProfile, name: app.state.preferences.displayName),
          const SizedBox(height: 20),
          PremiumCard(
            gradient: AppColors.heroGradient,
            padding: const EdgeInsets.all(22),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Row(
                  children: [
                    SoftIcon(icon: Icons.favorite_rounded, color: AppColors.rose),
                    SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('كيف حالك من الداخل اليوم؟', style: TextStyle(fontSize: 19, fontWeight: FontWeight.w900, color: AppColors.plum)),
                          SizedBox(height: 4),
                          Text('مو لازم تعرفي اسم المشكلة. اختاري الأقرب.', style: TextStyle(fontSize: 12, color: AppColors.mutedText, height: 1.6)),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 18),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: ['😌 مرتاحة', '🌿 منيحة نسبيًا', '😕 في شي مضايقني', '🌪️ كل شي فوق بعض', '🔥 عم انفجر', '💔 صار معي شي']
                      .map((mood) => ChoiceChip(
                            selected: mood == _mood,
                            onSelected: (_) => setState(() => _mood = mood),
                            label: Text(mood),
                            side: BorderSide(color: mood == _mood ? AppColors.lavender : AppColors.border),
                            backgroundColor: Colors.white.withOpacity(0.72),
                            selectedColor: AppColors.lavender.withOpacity(0.16),
                            labelStyle: TextStyle(
                              fontWeight: mood == _mood ? FontWeight.w800 : FontWeight.w600,
                              color: mood == _mood ? AppColors.plum : AppColors.softText,
                              fontSize: 11.5,
                            ),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
                          ))
                      .toList(),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          _MalaakHero(onTap: () => widget.onOpenMalaak(null)),
          const SizedBox(height: 26),
          SectionHeader(
            title: 'رحلتك الحالية',
            subtitle: 'ملاك تختار لكِ الأولوية بدل ما تفتحي كل الأقسام مع بعض.',
            trailing: TextButton(onPressed: widget.onOpenJourney, child: const Text('كل الرحلة')),
          ),
          const SizedBox(height: 12),
          if (fiRoute != null)
            _FiHomeJourneyCard(state: fiLearning)
          else
            _HomeJourneyCard(
              plan: journeyPlan,
              primary: primaryDomain,
              support: supportDomain,
              onOpenJourney: widget.onOpenJourney,
            ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(child: _FocusCard(text: focusText)),
              const SizedBox(width: 12),
              Expanded(child: _FollowUpCard(
                prompt: followUp?.prompt,
                onTap: () => widget.onOpenMalaak(followUp?.prompt),
              )),
            ],
          ),
          const SizedBox(height: 16),
          _MalaakInsight(text: insightText),
          const SizedBox(height: 26),
          const SectionHeader(title: 'أدوات سريعة', subtitle: 'اختصارات لمواقف حقيقية — مو دروس منفصلة.'),
          const SizedBox(height: 12),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: quickTools.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 1.14,
            ),
            itemBuilder: (context, index) {
              final tool = quickTools[index];
              return PremiumCard(
                padding: const EdgeInsets.all(16),
                onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => ToolDetailScreen(tool: tool))),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SoftIcon(icon: tool.icon, color: tool.color, size: 40),
                    const Spacer(),
                    Text(tool.title, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w900, color: AppColors.plum)),
                    const SizedBox(height: 4),
                    Text(tool.subtitle, maxLines: 2, overflow: TextOverflow.ellipsis, style: const TextStyle(fontSize: 10.5, height: 1.5, color: AppColors.mutedText)),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

class _FiHomeJourneyCard extends StatelessWidget {
  const _FiHomeJourneyCard({required this.state});

  final LearningJourneyState state;

  @override
  Widget build(BuildContext context) {
    final route = FiCatalog.routeById(state.routeId!);
    final currentIndex = FiProgression.currentNodeIndex(lessons: route.lessons, state: state);
    final mastered = <FiNodeStatus>[
      for (var i = 0; i < route.lessons.length; i++)
        FiProgression.nodeStatus(index: i, lessons: route.lessons, state: state),
    ].where((status) => status == FiNodeStatus.mastered).length;
    final applications = route.lessons
        .map((lesson) => state.lessonProgress[lesson.id]?.realLifeApplications ?? 0)
        .fold<int>(0, (total, value) => total + value);
    final currentTitle = currentIndex >= 0 && currentIndex < route.lessons.length
        ? route.lessons[currentIndex].title
        : 'المسار المتقدم';
    return PremiumCard(
      onTap: () => Navigator.of(context).push(
        MaterialPageRoute(builder: (_) => FiRouteScreen(routeId: route.id)),
      ),
      borderColor: AppColors.lilac,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('رحلتك الحالية • Skill Tree', style: TextStyle(fontSize: 10.5, fontWeight: FontWeight.w900, color: AppColors.rose)),
          const SizedBox(height: 8),
          Row(
            children: [
              const SoftIcon(icon: Icons.route_rounded, color: AppColors.lilac, size: 48),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(route.title, style: const TextStyle(fontSize: 15.5, height: 1.4, fontWeight: FontWeight.w900, color: AppColors.plum)),
                    const SizedBox(height: 4),
                    Text('الخطوة الحالية: $currentTitle', style: const TextStyle(fontSize: 10.8, height: 1.55, color: AppColors.softText)),
                  ],
                ),
              ),
              const Icon(Icons.chevron_left_rounded, color: AppColors.lavender),
            ],
          ),
          const SizedBox(height: 13),
          Row(
            children: [
              Expanded(child: _FiHomeMetric(value: '$mastered/${route.lessons.length}', label: 'مهارات مكتسبة')),
              const SizedBox(width: 8),
              Expanded(child: _FiHomeMetric(value: '$applications', label: 'تطبيقات حقيقية')),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            FiProgression.nextUnlockReason(lessons: route.lessons, state: state),
            style: const TextStyle(fontSize: 10.5, height: 1.6, color: AppColors.mutedText, fontWeight: FontWeight.w700),
          ),
        ],
      ),
    );
  }
}

class _FiHomeMetric extends StatelessWidget {
  const _FiHomeMetric({required this.value, required this.label});
  final String value;
  final String label;

  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
        decoration: BoxDecoration(color: AppColors.muted.withOpacity(0.65), borderRadius: BorderRadius.circular(14)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(value, style: const TextStyle(fontSize: 13.5, fontWeight: FontWeight.w900, color: AppColors.plum)),
            Text(label, style: const TextStyle(fontSize: 9, fontWeight: FontWeight.w700, color: AppColors.mutedText)),
          ],
        ),
      );
}

class _HomeJourneyCard extends StatelessWidget {
  const _HomeJourneyCard({
    required this.plan,
    required this.primary,
    required this.support,
    required this.onOpenJourney,
  });

  final JourneyPlan? plan;
  final JourneyDomain? primary;
  final JourneyDomain? support;
  final VoidCallback onOpenJourney;

  @override
  Widget build(BuildContext context) {
    if (plan == null) {
      return PremiumCard(
        onTap: onOpenJourney,
        child: const Row(
          children: [
            SoftIcon(icon: Icons.route_rounded, color: AppColors.lavender, size: 48),
            SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('الخطة عم تتكوّن', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w900, color: AppColors.plum)),
                  SizedBox(height: 5),
                  Text('منستخدم مواقفك الحقيقية أولًا، وبعدين منثبت مسار واحد بدل ما نفترض من أول يوم.', style: TextStyle(fontSize: 11.5, height: 1.6, color: AppColors.softText)),
                ],
              ),
            ),
          ],
        ),
      );
    }

    if (plan!.isPaused) {
      return PremiumCard(
        onTap: onOpenJourney,
        color: AppColors.rose.withOpacity(0.08),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SoftIcon(icon: Icons.health_and_safety_rounded, color: AppColors.rose, size: 48),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('الأولوية الآن: الأمان والتثبيت', style: TextStyle(fontSize: 15.5, fontWeight: FontWeight.w900, color: AppColors.plum)),
                  const SizedBox(height: 5),
                  Text(plan!.reasoningSummaryAr, style: const TextStyle(fontSize: 11.5, height: 1.65, color: AppColors.softText)),
                ],
              ),
            ),
          ],
        ),
      );
    }

    if (primary == null) {
      return PremiumCard(
        onTap: onOpenJourney,
        child: const Row(
          children: [
            SoftIcon(icon: Icons.eco_rounded, color: AppColors.sage, size: 48),
            SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('وضع المحافظة', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w900, color: AppColors.plum)),
                  SizedBox(height: 5),
                  Text('ما في داعي نفتح مشكلة جديدة هلق. منراقب ونستخدم ملاك وقت الحياة لما تحتاجي.', style: TextStyle(fontSize: 11.5, height: 1.6, color: AppColors.softText)),
                ],
              ),
            ),
          ],
        ),
      );
    }

    return PremiumCard(
      onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => DomainDetailScreen(domain: primary!))),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              SoftIcon(icon: primary!.icon, color: primary!.color, size: 48),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('المسار الأساسي', style: TextStyle(fontSize: 10.5, color: AppColors.mutedText, fontWeight: FontWeight.w700)),
                    const SizedBox(height: 3),
                    Text(primary!.title, style: const TextStyle(fontSize: 17, color: AppColors.plum, fontWeight: FontWeight.w900)),
                    const SizedBox(height: 3),
                    Text(plan!.primaryGoal ?? primary!.currentSkill, style: const TextStyle(fontSize: 12, color: AppColors.softText)),
                  ],
                ),
              ),
              const Icon(Icons.chevron_left_rounded, color: AppColors.lavender),
            ],
          ),
          const SizedBox(height: 16),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(color: AppColors.muted.withOpacity(0.65), borderRadius: BorderRadius.circular(18)),
            child: Row(
              children: [
                Icon(support?.icon ?? Icons.check_circle_outline_rounded, color: support?.color ?? AppColors.sage, size: 20),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    support == null ? 'ما في مسار مساند مطلوب هلق — منثبت التركيز الحالي.' : 'المسار المساند: ${support!.title}',
                    style: const TextStyle(fontSize: 11.5, color: AppColors.softText, fontWeight: FontWeight.w700),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _TopHeader extends StatelessWidget {
  const _TopHeader({required this.onProfile, required this.name});
  final VoidCallback onProfile;
  final String name;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 46,
          height: 46,
          decoration: BoxDecoration(gradient: AppColors.primaryGradient, borderRadius: BorderRadius.circular(15)),
          child: const Icon(Icons.auto_awesome_rounded, color: Colors.white, size: 21),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(name.isEmpty ? 'صباح الخير 🌸' : 'صباح الخير، $name 🌸', style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w900, color: AppColors.plum)),
              const SizedBox(height: 2),
              const Text('ملاك معكِ اليوم خطوة بخطوة', style: TextStyle(fontSize: 11.5, color: AppColors.mutedText)),
            ],
          ),
        ),
        IconButton.filledTonal(onPressed: onProfile, icon: const Icon(Icons.person_outline_rounded, color: AppColors.lavender)),
      ],
    );
  }
}

class _MalaakHero extends StatelessWidget {
  const _MalaakHero({required this.onTap});
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return PremiumCard(
      gradient: AppColors.malaakGradient,
      borderColor: Colors.transparent,
      padding: EdgeInsets.zero,
      onTap: onTap,
      child: Stack(
        children: [
          Positioned(top: -35, left: -18, child: _Glow(color: AppColors.rose.withOpacity(0.18), size: 120)),
          Positioned(bottom: -45, right: 10, child: _Glow(color: AppColors.lavender.withOpacity(0.15), size: 130)),
          Padding(
            padding: const EdgeInsets.all(22),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(gradient: AppColors.primaryGradient, borderRadius: BorderRadius.circular(16)),
                      child: const Icon(Icons.auto_awesome_rounded, color: Colors.white),
                    ),
                    const SizedBox(width: 12),
                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('أحتاج ملاك الآن', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w900)),
                          SizedBox(height: 2),
                          Text('صار موقف؟ تخانقتوا؟ راسك ما عم يسكت؟', style: TextStyle(color: Color(0xFFD9C9EA), fontSize: 11.5)),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 18),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(15),
                  decoration: BoxDecoration(color: Colors.white.withOpacity(0.075), borderRadius: BorderRadius.circular(20), border: Border.all(color: Colors.white.withOpacity(0.08))),
                  child: const Text(
                    'احكيلي شو صار. أول شي منحدد: أمان؟ تهدئة؟ فهم؟ ولا قرار؟',
                    style: TextStyle(color: Color(0xFFF2EAFE), fontSize: 13, height: 1.7, fontWeight: FontWeight.w600),
                  ),
                ),
                const SizedBox(height: 14),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  decoration: BoxDecoration(gradient: AppColors.primaryGradient, borderRadius: BorderRadius.circular(18)),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.arrow_back_rounded, color: Colors.white, size: 17),
                      SizedBox(width: 7),
                      Text('ابدئي مع ملاك', style: TextStyle(color: Colors.white, fontSize: 12.5, fontWeight: FontWeight.w900)),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _Glow extends StatelessWidget {
  const _Glow({required this.color, required this.size});
  final Color color;
  final double size;

  @override
  Widget build(BuildContext context) => Container(width: size, height: size, decoration: BoxDecoration(shape: BoxShape.circle, color: color));
}

class _FocusCard extends StatelessWidget {
  const _FocusCard({required this.text});
  final String text;

  @override
  Widget build(BuildContext context) {
    return PremiumCard(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SoftIcon(icon: Icons.flag_rounded, color: AppColors.gold, size: 38),
          const SizedBox(height: 14),
          const Text('تركيزي الحالي', style: TextStyle(fontSize: 11, color: AppColors.mutedText, fontWeight: FontWeight.w700)),
          const SizedBox(height: 5),
          Text(text, style: const TextStyle(fontSize: 13, height: 1.5, color: AppColors.plum, fontWeight: FontWeight.w900)),
        ],
      ),
    );
  }
}

class _FollowUpCard extends StatelessWidget {
  const _FollowUpCard({required this.onTap, this.prompt});
  final VoidCallback onTap;
  final String? prompt;

  @override
  Widget build(BuildContext context) {
    final hasFollowUp = prompt?.trim().isNotEmpty == true;
    return PremiumCard(
      onTap: onTap,
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SoftIcon(icon: Icons.update_rounded, color: AppColors.lavender, size: 38),
          const SizedBox(height: 14),
          const Text('متابعة مفتوحة', style: TextStyle(fontSize: 11, color: AppColors.mutedText, fontWeight: FontWeight.w700)),
          const SizedBox(height: 5),
          Text(
            hasFollowUp ? prompt! : 'ما عندك متابعة معلقة هلق',
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(fontSize: 13, height: 1.5, color: AppColors.plum, fontWeight: FontWeight.w900),
          ),
          if (hasFollowUp) ...[
            const SizedBox(height: 8),
            const Text('أخبر ملاك شو صار', style: TextStyle(fontSize: 10.5, color: AppColors.lavender, fontWeight: FontWeight.w900)),
          ],
        ],
      ),
    );
  }
}

class _MalaakInsight extends StatelessWidget {
  const _MalaakInsight({required this.text});
  final String text;

  @override
  Widget build(BuildContext context) {
    return PremiumCard(
      color: AppColors.lavender.withOpacity(0.07),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SoftIcon(icon: Icons.lightbulb_rounded, color: AppColors.lavender, size: 42),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('ملاحظة من ملاك', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w900, color: AppColors.plum)),
                const SizedBox(height: 5),
                Text(text, style: const TextStyle(fontSize: 12, color: AppColors.softText, height: 1.7)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
