import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../models/initial_map.dart';
import '../../widgets/premium_card.dart';
import '../../widgets/soft_icon.dart';

class InitialMapResultScreen extends StatefulWidget {
  const InitialMapResultScreen({super.key, required this.initialMap, required this.onConfirm});

  final InitialMap initialMap;
  final Future<void> Function() onConfirm;

  @override
  State<InitialMapResultScreen> createState() => _InitialMapResultScreenState();
}

class _InitialMapResultScreenState extends State<InitialMapResultScreen> {
  bool _saving = false;

  Future<void> _confirm() async {
    if (_saving) return;
    setState(() => _saving = true);
    try {
      await widget.onConfirm();
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final map = widget.initialMap;
    return Scaffold(
      backgroundColor: AppColors.cream,
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(18, 20, 18, 28),
          children: [
            const Center(child: SoftIcon(icon: Icons.explore_outlined, color: AppColors.lavender, size: 64)),
            const SizedBox(height: 18),
            const Text('خريطتك الأولية', textAlign: TextAlign.center, style: TextStyle(fontSize: 27, fontWeight: FontWeight.w900, color: AppColors.plum)),
            const SizedBox(height: 8),
            const Text(
              'هاي نقطة بداية من اللي شاركتيني ياه اليوم. مو تشخيص، ومو حكم ثابت عن شخصيتك. ملاك رح تعدّل فهمها مع مواقفك الحقيقية ومع تصحيحك إلها.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 12.5, height: 1.8, color: AppColors.mutedText),
            ),
            const SizedBox(height: 22),
            PremiumCard(
              gradient: AppColors.heroGradient,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _MapLine(icon: Icons.favorite_outline_rounded, label: 'أكتر شي جابك', value: InitialMap.concernLabel(map.primaryConcern), color: AppColors.rose),
                  const Divider(height: 26, color: AppColors.border),
                  _MapLine(icon: Icons.layers_outlined, label: 'السياق الأوضح', value: InitialMap.contextLabel(map.lifeContext), color: AppColors.lavender),
                  const Divider(height: 26, color: AppColors.border),
                  _MapLine(icon: Icons.monitor_heart_outlined, label: 'الأثر الحالي', value: InitialMap.impactLabel(map.currentImpact), color: AppColors.sage),
                  const Divider(height: 26, color: AppColors.border),
                  _MapLine(icon: Icons.auto_awesome_outlined, label: 'أسلوب الدعم اللي بتحبيه', value: InitialMap.preferenceLabel(map.coachingPreference), color: AppColors.gold),
                ],
              ),
            ),
            const SizedBox(height: 14),
            PremiumCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('🎯 الشي اللي بدك يتغيّر', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w900, color: AppColors.plum)),
                  const SizedBox(height: 8),
                  Text(map.desiredChange, style: const TextStyle(fontSize: 14, height: 1.75, color: AppColors.softText, fontWeight: FontWeight.w700)),
                ],
              ),
            ),
            const SizedBox(height: 14),
            PremiumCard(
              color: AppColors.muted.withOpacity(0.48),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('🌱 أفضل بداية حاليًا', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w900, color: AppColors.plum)),
                  const SizedBox(height: 8),
                  Text(map.startingFocus, style: const TextStyle(fontSize: 13, height: 1.75, color: AppColors.softText)),
                  const SizedBox(height: 10),
                  const Text('إذا الحياة الحقيقية أعطتنا صورة مختلفة، الخطة رح تتغيّر. ما رح نحاول نثبت أول انطباع.', style: TextStyle(fontSize: 11.5, height: 1.65, color: AppColors.mutedText)),
                ],
              ),
            ),
            if (map.currentImpact == 'high') ...[
              const SizedBox(height: 14),
              PremiumCard(
                color: AppColors.rose.withOpacity(0.08),
                borderColor: AppColors.rose.withOpacity(0.28),
                child: const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('🤝 الدعم الإضافي ممكن يكون مفيد', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w900, color: AppColors.plum)),
                    SizedBox(height: 7),
                    Text(
                      'لأن الأثر عم يضغط بقوة على يومك أو نومك أو علاقتك، ملاك رح تضل داعمة، لكن دعم بشري من مختص مؤهل ممكن يكون إضافة مهمة إذا استمر هالمستوى أو صار أصعب. هاد مو تشخيص.',
                      style: TextStyle(fontSize: 11.8, height: 1.7, color: AppColors.softText),
                    ),
                  ],
                ),
              ),
            ],
            const SizedBox(height: 22),
            SizedBox(
              height: 54,
              child: FilledButton.icon(
                onPressed: _saving ? null : _confirm,
                style: FilledButton.styleFrom(backgroundColor: AppColors.plum, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(19))),
                icon: _saving
                    ? const SizedBox(width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                    : const Icon(Icons.auto_awesome_rounded),
                label: Text(_saving ? 'عم نحفظ البداية…' : 'ابدئي رحلتي مع ملاك', style: const TextStyle(fontWeight: FontWeight.w900)),
              ),
            ),
            const SizedBox(height: 10),
            TextButton(onPressed: _saving ? null : () => Navigator.of(context).pop(), child: const Text('بدي أعدّل إجاباتي')),
          ],
        ),
      ),
    );
  }
}

class _MapLine extends StatelessWidget {
  const _MapLine({required this.icon, required this.label, required this.value, required this.color});

  final IconData icon;
  final String label;
  final String value;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SoftIcon(icon: icon, color: color, size: 40),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: const TextStyle(fontSize: 10.5, color: AppColors.mutedText, fontWeight: FontWeight.w700)),
              const SizedBox(height: 3),
              Text(value, style: const TextStyle(fontSize: 13.5, height: 1.55, color: AppColors.plum, fontWeight: FontWeight.w900)),
            ],
          ),
        ),
      ],
    );
  }
}
