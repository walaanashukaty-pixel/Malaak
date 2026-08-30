import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../data/app_catalog.dart';
import '../../widgets/premium_card.dart';
import '../../widgets/section_header.dart';
import '../../widgets/soft_icon.dart';
import 'tool_detail_screen.dart';

class ToolsScreen extends StatelessWidget {
  const ToolsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('أدواتي', style: TextStyle(fontWeight: FontWeight.w900))),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(18, 6, 18, 32),
        children: [
          const SectionHeader(title: 'اختاري حسب الموقف', subtitle: 'كل أداة معمولة لحاجة لحظية واضحة، مو كدورة منفصلة.'),
          const SizedBox(height: 12),
          ...AppCatalog.quickTools.map((tool) => Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: PremiumCard(
                  onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => ToolDetailScreen(tool: tool))),
                  padding: const EdgeInsets.all(15),
                  child: Row(
                    children: [
                      SoftIcon(icon: tool.icon, color: tool.color, size: 44),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(tool.title, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w900, color: AppColors.plum)),
                            const SizedBox(height: 3),
                            Text(tool.subtitle, style: const TextStyle(fontSize: 10.5, height: 1.5, color: AppColors.mutedText)),
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
}
