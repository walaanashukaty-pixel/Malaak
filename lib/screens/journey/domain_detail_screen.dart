import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../models/journey_domain.dart';
import '../../widgets/premium_card.dart';
import '../../widgets/section_header.dart';
import '../../widgets/soft_icon.dart';
import '../../state/app_scope.dart';
import '../../features/feminine_intelligence/screens/feminine_intelligence_screen.dart';

class DomainDetailScreen extends StatelessWidget {
  const DomainDetailScreen({super.key, required this.domain});
  final JourneyDomain domain;

  @override
  Widget build(BuildContext context) {
    if (domain.id == 'feminine-intelligence') {
      return FeminineIntelligenceScreen(domain: domain);
    }
    return Scaffold(
      appBar: AppBar(
        title: Text(domain.title, style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w900)),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(18, 8, 18, 36),
        children: [
          PremiumCard(
            gradient: AppColors.heroGradient,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SoftIcon(icon: domain.icon, color: domain.color, size: 56),
                const SizedBox(height: 16),
                Text(domain.title, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w900, color: AppColors.plum)),
                const SizedBox(height: 5),
                Text(domain.subtitle, style: const TextStyle(fontSize: 12.5, height: 1.7, color: AppColors.softText)),
                const SizedBox(height: 18),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(15),
                  decoration: BoxDecoration(color: Colors.white.withOpacity(0.72), borderRadius: BorderRadius.circular(20), border: Border.all(color: AppColors.border)),
                  child: Text(domain.goal, style: const TextStyle(fontSize: 12, height: 1.75, color: AppColors.plum, fontWeight: FontWeight.w600)),
                ),
              ],
            ),
          ),
          const SizedBox(height: 22),
          const SectionHeader(title: 'وين أنتِ هلق؟'),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(child: _MiniMetric(label: 'المرحلة الحالية', value: domain.currentStage, color: domain.color)),
              const SizedBox(width: 10),
              Expanded(child: _MiniMetric(label: 'المهارة الحالية', value: domain.currentSkill, color: AppColors.sage)),
            ],
          ),
          const SizedBox(height: 22),
          const SectionHeader(title: 'إشارات التغيير', subtitle: 'سلوكيات مفهومة بدل نسبة شفاء وهمية.'),
          const SizedBox(height: 10),
          PremiumCard(
            child: Column(
              children: [
                _SignalRow(icon: Icons.trending_up_rounded, text: domain.signalOne, color: AppColors.sage),
                const Divider(height: 24),
                _SignalRow(icon: Icons.construction_rounded, text: domain.signalTwo, color: AppColors.gold),
              ],
            ),
          ),
          const SizedBox(height: 22),
          const SectionHeader(title: 'الخطوة التالية'),
          const SizedBox(height: 10),
          PremiumCard(
            color: domain.color.withOpacity(0.08),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(domain.nextStep, style: const TextStyle(fontSize: 13, height: 1.75, fontWeight: FontWeight.w800, color: AppColors.plum)),
                const SizedBox(height: 16),
                InkWell(
                  onTap: () async {
                    await AppScope.of(context).completePractice(domain.id);
                    if (context.mounted) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('تم حفظ التدريب ضمن تقدم رحلتك 🌱')));
                  },
                  borderRadius: BorderRadius.circular(18),
                  child: Container(width: double.infinity,padding: const EdgeInsets.symmetric(vertical: 13),decoration: BoxDecoration(gradient: AppColors.primaryGradient,borderRadius: BorderRadius.circular(18)),child: const Center(child: Text('أنجزت التدريب',style: TextStyle(color: Colors.white,fontSize: 13,fontWeight: FontWeight.w900)))),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            'التقدم يُحفظ محليًا على جهازك. التخصيص السحابي والذكاء الاصطناعي الحقيقي يركبان لاحقًا فوق نفس البنية.',
            style: TextStyle(fontSize: 10.5, height: 1.6, color: AppColors.mutedText),
          ),
        ],
      ),
    );
  }
}

class _MiniMetric extends StatelessWidget {
  const _MiniMetric({required this.label, required this.value, required this.color});
  final String label;
  final String value;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return PremiumCard(
      padding: const EdgeInsets.all(15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(width: 30, height: 5, decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(9))),
          const SizedBox(height: 11),
          Text(label, style: const TextStyle(fontSize: 10, color: AppColors.mutedText, fontWeight: FontWeight.w700)),
          const SizedBox(height: 5),
          Text(value, maxLines: 2, overflow: TextOverflow.ellipsis, style: const TextStyle(fontSize: 12.5, height: 1.5, color: AppColors.plum, fontWeight: FontWeight.w900)),
        ],
      ),
    );
  }
}

class _SignalRow extends StatelessWidget {
  const _SignalRow({required this.icon, required this.text, required this.color});
  final IconData icon;
  final String text;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, color: color, size: 20),
        const SizedBox(width: 10),
        Expanded(child: Text(text, style: const TextStyle(fontSize: 12, color: AppColors.softText, height: 1.6, fontWeight: FontWeight.w700))),
      ],
    );
  }
}
