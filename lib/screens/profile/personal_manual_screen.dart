import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../models/memory_item.dart';
import '../../state/app_scope.dart';
import '../../widgets/premium_card.dart';
import '../../widgets/section_header.dart';

class PersonalManualScreen extends StatelessWidget {
  const PersonalManualScreen({super.key});

  String titleFor(MemoryType type) => switch (type) {
        MemoryType.fact => '🧾 حقائق اخترتِ حفظها',
        MemoryType.goal => '🎯 أهدافي الحالية',
        MemoryType.preference => '🌿 شو بيساعدني؟',
        MemoryType.pattern => '🔁 أنماطي المتكررة',
        MemoryType.hypothesis => '🧩 أشياء نحتاج نتحقق منها',
      };

  @override
  Widget build(BuildContext context) {
    final memories = AppScope.of(context).state.memories;
    return Scaffold(
      appBar: AppBar(title: const Text('دليلي الشخصي', style: TextStyle(fontWeight: FontWeight.w900))),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(18, 6, 18, 32),
        children: [
          const SectionHeader(title: 'ما تعلمته عن نفسي', subtitle: 'الدليل هون مبني فقط من الأشياء المحفوظة بذاكرة ملاك.'),
          const SizedBox(height: 12),
          if (memories.isEmpty)
            const PremiumCard(
              child: Text('لسه دليلك الشخصي فاضي. لما تحفظي هدف أو تفضيل أو نمط موثوق، رح يبدأ يتكوّن هون.', style: TextStyle(fontSize: 12, height: 1.7, color: AppColors.softText)),
            )
          else
            ...memories.map(
              (item) => Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: PremiumCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(titleFor(item.type), style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w900, color: AppColors.plum)),
                      const SizedBox(height: 7),
                      Text(item.value, style: const TextStyle(fontSize: 11.5, height: 1.7, color: AppColors.softText)),
                      if (item.type == MemoryType.pattern || item.type == MemoryType.hypothesis) ...[
                        const SizedBox(height: 7),
                        Text('الثقة: ${item.confidence}', style: const TextStyle(fontSize: 9.5, color: AppColors.mutedText)),
                      ],
                    ],
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
