import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../widgets/premium_card.dart';
import '../../widgets/section_header.dart';
import '../../widgets/soft_icon.dart';
import '../journal/journal_screen.dart';
import '../reports/reports_screen.dart';
import '../tools/tools_screen.dart';
import 'memory_privacy_screen.dart';
import 'personal_manual_screen.dart';
import 'settings_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final items = <_ProfileItem>[
      _ProfileItem('يومياتي الذكية', 'المواقف والتعلم والأنماط', Icons.auto_stories_rounded, AppColors.rose, () => _push(context, const JournalScreen())),
      _ProfileItem('تقاريري', 'شو تغير؟ شو رجع؟ شو الخطوة الجاية؟', Icons.insights_rounded, AppColors.lavender, () => _push(context, const ReportsScreen())),
      _ProfileItem('دليلي الشخصي', 'المحفزات والاحتياجات وما يساعدني', Icons.menu_book_rounded, AppColors.sage, () => _push(context, const PersonalManualScreen())),
      _ProfileItem('أدواتي', 'مرآة الأفكار والغضب والقرار وغيرها', Icons.grid_view_rounded, AppColors.blue, () => _push(context, const ToolsScreen())),
      _ProfileItem('ذاكرة ملاك والخصوصية', 'شو بتتذكر ملاك وكيف تتحكمي فيه', Icons.memory_rounded, AppColors.gold, () => _push(context, const MemoryPrivacyScreen())),
      _ProfileItem('الإعدادات', 'المظهر والتفضيلات وحدود النسخة الحالية', Icons.settings_rounded, AppColors.mutedText, () => _push(context, const SettingsScreen())),
    ];

    return SafeArea(
      bottom: false,
      child: ListView(
        padding: const EdgeInsets.fromLTRB(18, 16, 18, 122),
        children: [
          PremiumCard(
            gradient: AppColors.heroGradient,
            child: Row(
              children: [
                Container(
                  width: 64,
                  height: 64,
                  decoration: BoxDecoration(gradient: AppColors.primaryGradient, borderRadius: BorderRadius.circular(22)),
                  child: const Icon(Icons.person_rounded, color: Colors.white, size: 29),
                ),
                const SizedBox(width: 14),
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('أنا وملاك', style: TextStyle(fontSize: 22, fontWeight: FontWeight.w900, color: AppColors.plum)),
                      SizedBox(height: 4),
                      Text('المكان اللي يجمع قصتك، أهدافك، وما تعلمتيه عن نفسك.', style: TextStyle(fontSize: 11.5, height: 1.65, color: AppColors.softText)),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 22),
          const SectionHeader(title: 'رؤيتي لنفسي'),
          const SizedBox(height: 10),
          PremiumCard(
            color: AppColors.lavender.withOpacity(0.07),
            child: const Text('أكون أهدأ بدون ما ألغي نفسي، أحب بدون ما أفقد حدي، وأعرف أرجع لاتزاني حتى وقت الضغط.', style: TextStyle(fontSize: 13, height: 1.8, fontWeight: FontWeight.w800, color: AppColors.plum)),
          ),
          const SizedBox(height: 22),
          const SectionHeader(title: 'مساحتي الشخصية'),
          const SizedBox(height: 10),
          ...items.map((item) => Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: PremiumCard(
                  onTap: item.onTap,
                  padding: const EdgeInsets.all(15),
                  child: Row(
                    children: [
                      SoftIcon(icon: item.icon, color: item.color, size: 44),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(item.title, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w900, color: AppColors.plum)),
                            const SizedBox(height: 3),
                            Text(item.subtitle, style: const TextStyle(fontSize: 10.5, height: 1.5, color: AppColors.mutedText)),
                          ],
                        ),
                      ),
                      const Icon(Icons.chevron_left_rounded, color: AppColors.lavender),
                    ],
                  ),
                ),
              )),
        ],
      ),
    );
  }

  static void _push(BuildContext context, Widget screen) => Navigator.of(context).push(MaterialPageRoute(builder: (_) => screen));
}

class _ProfileItem {
  const _ProfileItem(this.title, this.subtitle, this.icon, this.color, this.onTap);
  final String title;
  final String subtitle;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;
}
