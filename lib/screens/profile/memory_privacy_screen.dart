import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../models/memory_item.dart';
import '../../state/app_scope.dart';
import '../../widgets/premium_card.dart';
import '../../widgets/section_header.dart';
import 'hypotheses_screen.dart';

class MemoryPrivacyScreen extends StatelessWidget {
  const MemoryPrivacyScreen({super.key});

  String label(MemoryType type) => switch (type) {
        MemoryType.fact => '🧾 حقيقة',
        MemoryType.goal => '🎯 هدف',
        MemoryType.preference => '🌿 تفضيل',
        MemoryType.pattern => '🔁 نمط',
        MemoryType.hypothesis => '🧩 فرضية',
      };

  Future<void> _addMemory(BuildContext context) async {
    final controller = TextEditingController();
    MemoryType selected = MemoryType.goal;
    final result = await showDialog<(MemoryType, String)>(
      context: context,
      builder: (dialogContext) => StatefulBuilder(
        builder: (dialogContext, setDialogState) => AlertDialog(
          title: const Text('احفظي معلومة لملاك', style: TextStyle(fontWeight: FontWeight.w900)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              DropdownButtonFormField<MemoryType>(
                value: selected,
                items: MemoryType.values
                    .map((type) => DropdownMenuItem(value: type, child: Text(label(type))))
                    .toList(),
                onChanged: (value) {
                  if (value != null) setDialogState(() => selected = value);
                },
              ),
              const SizedBox(height: 12),
              TextField(
                controller: controller,
                maxLines: 3,
                decoration: const InputDecoration(hintText: 'مثال: الحركة القصيرة تساعدني وقت التوتر'),
              ),
            ],
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(dialogContext), child: const Text('إلغاء')),
            FilledButton(
              onPressed: () => Navigator.pop(dialogContext, (selected, controller.text.trim())),
              child: const Text('حفظ'),
            ),
          ],
        ),
      ),
    );
    controller.dispose();
    if (result != null && result.$2.isNotEmpty) {
      await AppScope.of(context).addMemory(result.$1, result.$2);
    }
  }

  @override
  Widget build(BuildContext context) {
    final app = AppScope.of(context);
    final preferences = app.state.preferences;

    return Scaffold(
      appBar: AppBar(
        title: const Text('ذاكرة ملاك والخصوصية', style: TextStyle(fontWeight: FontWeight.w900)),
        actions: [IconButton(onPressed: () => _addMemory(context), icon: const Icon(Icons.add_rounded))],
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(18, 6, 18, 32),
        children: [
          const SectionHeader(
            title: 'إنتِ صاحبة الذاكرة',
            subtitle: 'Fact ≠ Pattern ≠ Hypothesis — وإنتِ تتحكمي بما يُحفظ وما يصل لملاك.',
          ),
          const SizedBox(height: 12),
          PremiumCard(
            child: Column(
              children: [
                SwitchListTile.adaptive(
                  value: preferences.allowPatterns,
                  onChanged: (value) => app.updatePreferences(preferences.copyWith(allowPatterns: value)),
                  title: const Text('اسمحي لملاك تلاحظ الأنماط'),
                ),
                SwitchListTile.adaptive(
                  value: preferences.allowJournalAnalysis,
                  onChanged: (value) => app.updatePreferences(preferences.copyWith(allowJournalAnalysis: value)),
                  title: const Text('اسمحي بتحليل اليوميات'),
                ),
                SwitchListTile.adaptive(
                  value: preferences.includeInReports,
                  onChanged: (value) => app.updatePreferences(preferences.copyWith(includeInReports: value)),
                  title: const Text('أدخلي التسجيلات الجديدة بالتقارير'),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          PremiumCard(
            onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => const HypothesesScreen())),
            color: AppColors.lavender.withOpacity(0.06),
            child: const Row(
              children: [
                Icon(Icons.fact_check_outlined, color: AppColors.lavender),
                SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('مراجعة استنتاجات ملاك', style: TextStyle(fontSize: 13.5, fontWeight: FontWeight.w900, color: AppColors.plum)),
                      SizedBox(height: 3),
                      Text('شوفي الإشارات والأنماط وصححي أي استنتاج ما بيمثلك.', style: TextStyle(fontSize: 11, height: 1.55, color: AppColors.mutedText)),
                    ],
                  ),
                ),
                Icon(Icons.chevron_left_rounded, color: AppColors.lavender),
              ],
            ),
          ),
          const SizedBox(height: 20),
          SectionHeader(
            title: 'شو بتتذكر ملاك؟',
            trailing: TextButton(onPressed: () => _addMemory(context), child: const Text('إضافة')),
          ),
          const SizedBox(height: 10),
          if (app.state.memories.isEmpty)
            PremiumCard(
              color: AppColors.lavender.withOpacity(.06),
              child: const Text(
                'ما في ذاكرة شخصية محفوظة بعد. أضيفي فقط الأشياء اللي بدك ملاك تتذكرها فعلًا.',
                style: TextStyle(height: 1.7, color: AppColors.softText),
              ),
            )
          else
            ...app.state.memories.map(
              (memory) => Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: PremiumCard(
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              label(memory.type),
                              style: const TextStyle(fontSize: 10.5, color: AppColors.mutedText, fontWeight: FontWeight.w800),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              memory.value,
                              style: const TextStyle(fontSize: 12, height: 1.6, color: AppColors.plum, fontWeight: FontWeight.w700),
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                        onPressed: () => app.deleteMemory(memory.id),
                        icon: const Icon(Icons.delete_outline_rounded, color: AppColors.mutedText),
                      ),
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
