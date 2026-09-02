import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../models/learning_journey_state.dart';
import '../../../state/app_scope.dart';
import '../../../widgets/premium_card.dart';
import '../../../widgets/soft_icon.dart';
import '../data/fi_catalog.dart';
import '../models/fi_models.dart';

class FiAssessmentResultScreen extends StatefulWidget {
  const FiAssessmentResultScreen({super.key, required this.recommendedRouteId});

  final String recommendedRouteId;

  @override
  State<FiAssessmentResultScreen> createState() => _FiAssessmentResultScreenState();
}

class _FiAssessmentResultScreenState extends State<FiAssessmentResultScreen> {
  String? _selectedRouteId;
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    _selectedRouteId = widget.recommendedRouteId;
  }

  Future<void> _startRoute() async {
    final selected = _selectedRouteId;
    if (selected == null || _saving) return;
    setState(() => _saving = true);
    final app = AppScope.of(context);
    final old = app.state.learningJourneys[FiCatalog.domainId] ??
        const LearningJourneyState(domainId: FiCatalog.domainId);
    await app.saveLearningJourneyState(old.copyWith(
      routeId: selected,
      recommendedRouteId: widget.recommendedRouteId,
      updatedAt: DateTime.now(),
    ));
    if (!mounted) return;
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final recommended = FiCatalog.modelByRouteId(widget.recommendedRouteId);
    return Scaffold(
      appBar: AppBar(title: const Text('خريطة البداية', style: TextStyle(fontSize: 17, fontWeight: FontWeight.w900))),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(18, 8, 18, 40),
        children: [
          const _CoachBubble(
            text: 'هلق صارت عندي صورة أوضح من إجاباتك. رح أعرضلك النماذج الأربعة، وبقولك أي واحد بشوفه أنسب كبداية. بس الاختيار بالنهاية إلك 🌷',
          ),
          const SizedBox(height: 12),
          PremiumCard(
            gradient: AppColors.heroGradient,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('ترشيح ملاك كبداية', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w900, color: AppColors.gold)),
                const SizedBox(height: 7),
                Text(recommended.title, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w900, color: AppColors.plum)),
                const SizedBox(height: 6),
                Text(
                  'هذا ترشيح تعليمي مبني على إجاباتك الحالية، مو تشخيص ولا وصف ثابت لشخصيتك. فيكي تختاري أي مسار بتحسيه أقرب لحاجتك.',
                  style: const TextStyle(fontSize: 11.5, height: 1.7, color: AppColors.softText),
                ),
              ],
            ),
          ),
          const SizedBox(height: 18),
          for (final model in FiCatalog.models) ...[
            _ModelCard(
              model: model,
              recommended: model.routeId == widget.recommendedRouteId,
              selected: model.routeId == _selectedRouteId,
              onTap: () => setState(() => _selectedRouteId = model.routeId),
            ),
            const SizedBox(height: 10),
          ],
          const SizedBox(height: 10),
          InkWell(
            onTap: _saving ? null : _startRoute,
            borderRadius: BorderRadius.circular(18),
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 15),
              decoration: BoxDecoration(gradient: AppColors.primaryGradient, borderRadius: BorderRadius.circular(18)),
              child: Center(
                child: _saving
                    ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                    : const Text('ابدئي المسار اللي اخترتيه', style: TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.w900)),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ModelCard extends StatelessWidget {
  const _ModelCard({
    required this.model,
    required this.recommended,
    required this.selected,
    required this.onTap,
  });

  final FiModelDescriptor model;
  final bool recommended;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return PremiumCard(
      onTap: onTap,
      color: selected ? AppColors.lavender.withOpacity(0.10) : Colors.white,
      borderColor: selected ? AppColors.lilac : AppColors.border,
      padding: const EdgeInsets.all(15),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SoftIcon(icon: model.icon, color: recommended ? AppColors.gold : AppColors.lilac, size: 46),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(child: Text(model.title.toString(), style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w900, color: AppColors.plum))),
                    if (recommended)
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(color: AppColors.gold.withOpacity(0.12), borderRadius: BorderRadius.circular(20)),
                        child: const Text('ترشيح ملاك ⭐', style: TextStyle(fontSize: 9, fontWeight: FontWeight.w900, color: AppColors.gold)),
                      ),
                  ],
                ),
                const SizedBox(height: 5),
                Text(model.description.toString(), style: const TextStyle(fontSize: 11.2, height: 1.65, color: AppColors.softText)),
                const SizedBox(height: 7),
                Text('قوتك: ${model.strength}', style: const TextStyle(fontSize: 10.5, height: 1.5, fontWeight: FontWeight.w700, color: AppColors.plum)),
                const SizedBox(height: 3),
                Text('رح نطور: ${model.growthEdge}', style: const TextStyle(fontSize: 10.5, height: 1.5, color: AppColors.mutedText)),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Icon(selected ? Icons.radio_button_checked_rounded : Icons.radio_button_off_rounded, color: selected ? AppColors.lilac : AppColors.mutedText),
        ],
      ),
    );
  }
}

class _CoachBubble extends StatelessWidget {
  const _CoachBubble({required this.text});
  final String text;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerRight,
      child: Container(
        constraints: const BoxConstraints(maxWidth: 340),
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 13),
        decoration: BoxDecoration(
          color: AppColors.lavender.withOpacity(0.11),
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(22),
            topRight: Radius.circular(22),
            bottomLeft: Radius.circular(22),
            bottomRight: Radius.circular(6),
          ),
          border: Border.all(color: AppColors.border),
        ),
        child: Text(text, style: const TextStyle(fontSize: 12.3, height: 1.75, color: AppColors.plum, fontWeight: FontWeight.w700)),
      ),
    );
  }
}
