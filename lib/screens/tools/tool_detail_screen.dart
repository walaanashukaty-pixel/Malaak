import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../models/quick_tool.dart';
import '../../widgets/premium_card.dart';
import '../../widgets/soft_icon.dart';

class ToolDetailScreen extends StatefulWidget {
  const ToolDetailScreen({super.key, required this.tool});
  final QuickTool tool;

  @override
  State<ToolDetailScreen> createState() => _ToolDetailScreenState();
}

class _ToolDetailScreenState extends State<ToolDetailScreen> {
  int _step = 0;

  @override
  Widget build(BuildContext context) {
    final tool = widget.tool;
    final isLast = _step == tool.steps.length - 1;
    return Scaffold(
      appBar: AppBar(title: Text(tool.title, style: const TextStyle(fontWeight: FontWeight.w900))),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(18, 10, 18, 24),
        child: Column(
          children: [
            PremiumCard(
              gradient: AppColors.heroGradient,
              child: Row(
                children: [
                  SoftIcon(icon: tool.icon, color: tool.color, size: 54),
                  const SizedBox(width: 13),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(tool.title, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w900, color: AppColors.plum)),
                        const SizedBox(height: 4),
                        Text(tool.subtitle, style: const TextStyle(fontSize: 12, height: 1.6, color: AppColors.softText)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 18),
            Expanded(
              child: PremiumCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text('الخطوة ${_step + 1} من ${tool.steps.length}', style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w800, color: AppColors.mutedText)),
                        const Spacer(),
                        ...List.generate(tool.steps.length, (i) => Container(
                              width: 7,
                              height: 7,
                              margin: const EdgeInsetsDirectional.only(start: 4),
                              decoration: BoxDecoration(shape: BoxShape.circle, color: i <= _step ? tool.color : AppColors.muted),
                            )),
                      ],
                    ),
                    const Spacer(),
                    Icon(tool.icon, size: 36, color: tool.color),
                    const SizedBox(height: 14),
                    Text(tool.steps[_step], style: const TextStyle(fontSize: 22, height: 1.55, fontWeight: FontWeight.w900, color: AppColors.plum)),
                    const SizedBox(height: 12),
                    Text(
                      _helperText(tool.id, _step),
                      style: const TextStyle(fontSize: 12, height: 1.8, color: AppColors.softText),
                    ),
                    const Spacer(),
                    if (tool.id == 'anger-now' && _step == 0)
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(13),
                        decoration: BoxDecoration(color: AppColors.danger.withOpacity(0.08), borderRadius: BorderRadius.circular(18)),
                        child: const Text('إذا في خطر مباشر على نفسك أو أي شخص، الأولوية لمكان آمن ودعم بشري/طارئ مناسب — مو إكمال التمرين.', style: TextStyle(fontSize: 11, height: 1.6, color: AppColors.plum, fontWeight: FontWeight.w700)),
                      ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 14),
            Row(
              children: [
                if (_step > 0)
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => setState(() => _step--),
                      style: OutlinedButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 14), side: const BorderSide(color: AppColors.border)),
                      child: const Text('السابق'),
                    ),
                  ),
                if (_step > 0) const SizedBox(width: 10),
                Expanded(
                  flex: 2,
                  child: FilledButton(
                    onPressed: isLast ? () => Navigator.of(context).pop() : () => setState(() => _step++),
                    style: FilledButton.styleFrom(backgroundColor: AppColors.lavender, foregroundColor: Colors.white, padding: const EdgeInsets.symmetric(vertical: 14), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18))),
                    child: Text(isLast ? 'تم' : 'كمّلي'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  static String _helperText(String id, int step) {
    if (id == 'thought-mirror') {
      return const [
        'وصّفي الشي اللي ممكن كاميرا تسجله، بدون تفسير نية أو حكم.',
        'اكتبي الجملة اللي طلعها عقلك مباشرة، بدون تلطيفها.',
        'افصلي الدليل الموجود عن الأشياء اللي ما عندك جواب عنها.',
        'اختاري خطوة تخدمك بدل خطوة مبنية فقط على الخوف.',
      ][step];
    }
    if (id == 'chaos') {
      return const [
        'اختاري أكبر مصدر ضغط بدل محاولة ترتيب حياتك كلها دفعة واحدة.',
        'شو الشي اللي لو ما عملتيه اليوم فعلاً رح يسبب مشكلة؟',
        'التأجيل الواعي مو إهمال؛ هو تقليل حمل.',
        'مو كل شيء لازم يتحل اليوم، وبعض الأشياء أصلًا مو تحت سيطرتك.',
      ][step];
    }
    return 'جاوبي بهدوء قبل ما تنتقلي للخطوة التالية. الهدف نطلع بخطوة واقعية واحدة، مو تحليل طويل.';
  }
}
