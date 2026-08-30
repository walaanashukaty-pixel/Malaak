import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../models/hypothesis_item.dart';
import '../../state/app_scope.dart';
import '../../widgets/premium_card.dart';
import '../../widgets/section_header.dart';

class HypothesesScreen extends StatefulWidget {
  const HypothesesScreen({super.key});

  @override
  State<HypothesesScreen> createState() => _HypothesesScreenState();
}

class _HypothesesScreenState extends State<HypothesesScreen> {
  late Future<List<HypothesisItem>> _future;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _future = AppScope.of(context).loadHypotheses();
  }

  Future<void> _reload() async {
    setState(() => _future = AppScope.of(context).loadHypotheses());
    await _future;
  }

  Future<void> _reject(HypothesisItem item) async {
    final feedbackController = TextEditingController();
    final feedback = await showDialog<String?>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('هذا مو صحيح', style: TextStyle(fontWeight: FontWeight.w900)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'رح نوقف استخدام هالاستنتاج بالتوجيه. إذا بتحبي، اكتبي شو اللي مو دقيق حتى ملاك ما تعيد نفس الفهم.',
              style: TextStyle(height: 1.65),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: feedbackController,
              maxLines: 3,
              decoration: const InputDecoration(hintText: 'اختياري: شو الأدق بالنسبة إلك؟'),
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(dialogContext), child: const Text('إلغاء')),
          FilledButton(
            onPressed: () => Navigator.pop(dialogContext, feedbackController.text.trim()),
            child: const Text('أوقفي استخدامه'),
          ),
        ],
      ),
    );
    feedbackController.dispose();
    if (feedback == null || !mounted) return;

    try {
      await AppScope.of(context).rejectHypothesis(item.id, feedback: feedback);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('تم. ملاك ما رح تستخدم هالاستنتاج بالتوجيه.')),
      );
      await _reload();
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('ما قدرنا نحفظ التصحيح هلق. جرّبي مرة ثانية لما يكون الاتصال متاح.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('مراجعة استنتاجات ملاك', style: TextStyle(fontWeight: FontWeight.w900)),
      ),
      body: RefreshIndicator(
        onRefresh: _reload,
        child: FutureBuilder<List<HypothesisItem>>(
          future: _future,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return ListView(children: const [SizedBox(height: 260), Center(child: CircularProgressIndicator())]);
            }
            if (snapshot.hasError) {
              return ListView(
                padding: const EdgeInsets.fromLTRB(18, 18, 18, 32),
                children: [
                  PremiumCard(
                    color: AppColors.rose.withOpacity(0.07),
                    child: const Text(
                      'ما قدرنا نحمّل استنتاجات ملاك هلق. اسحبي الصفحة لتحديثها لما يرجع الاتصال.',
                      style: TextStyle(height: 1.7, color: AppColors.softText),
                    ),
                  ),
                ],
              );
            }

            final items = snapshot.data ?? const <HypothesisItem>[];
            return ListView(
              padding: const EdgeInsets.fromLTRB(18, 10, 18, 32),
              children: [
                const SectionHeader(
                  title: 'إنتِ المرجع النهائي عن تجربتك',
                  subtitle: 'هاي استنتاجات عمل مبنية على البيانات اللي سمحتي لملاك تستخدمها. مو تشخيصات، وممكن تصححيها بأي وقت.',
                ),
                const SizedBox(height: 12),
                if (items.isEmpty)
                  PremiumCard(
                    color: AppColors.lavender.withOpacity(0.06),
                    child: const Text(
                      'لسه ما في استنتاجات كافية للمراجعة. ملاك تحتاج مواقف حقيقية متكررة قبل ما تعرض نمط عنك.',
                      style: TextStyle(height: 1.7, color: AppColors.softText),
                    ),
                  )
                else ...[
                  _group('إشارة أولية', items.where((e) => e.status == HypothesisStatus.candidate).toList()),
                  _group('نمط متكرر', items.where((e) => e.status == HypothesisStatus.repeated).toList()),
                  _group('أكدتِ إنه بيمثلك', items.where((e) => e.status == HypothesisStatus.userValidated).toList()),
                  _group('هادئ حاليًا', items.where((e) => e.status == HypothesisStatus.dormant).toList()),
                  _group('رفضتيه', items.where((e) => e.status == HypothesisStatus.rejected).toList()),
                ],
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _group(String title, List<HypothesisItem> items) {
    if (items.isEmpty) return const SizedBox.shrink();
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w900, color: AppColors.plum)),
          const SizedBox(height: 9),
          ...items.map((item) => Padding(
                padding: const EdgeInsets.only(bottom: 9),
                child: _HypothesisCard(item: item, onReject: item.canReject ? () => _reject(item) : null),
              )),
        ],
      ),
    );
  }
}

class _HypothesisCard extends StatelessWidget {
  const _HypothesisCard({required this.item, required this.onReject});

  final HypothesisItem item;
  final VoidCallback? onReject;

  @override
  Widget build(BuildContext context) {
    return PremiumCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  item.statusLabel,
                  style: const TextStyle(fontSize: 10.5, fontWeight: FontWeight.w900, color: AppColors.mutedText),
                ),
              ),
              Text(_domainLabel(item.domain), style: const TextStyle(fontSize: 10.5, color: AppColors.lavender, fontWeight: FontWeight.w800)),
            ],
          ),
          const SizedBox(height: 7),
          Text(item.statementAr, style: const TextStyle(fontSize: 13.5, height: 1.7, fontWeight: FontWeight.w800, color: AppColors.plum)),
          const SizedBox(height: 7),
          Text(item.statusDescription, style: const TextStyle(fontSize: 11.5, height: 1.65, color: AppColors.mutedText)),
          if (item.userFeedback?.trim().isNotEmpty == true) ...[
            const SizedBox(height: 8),
            Text('تصحيحك: ${item.userFeedback}', style: const TextStyle(fontSize: 11.5, height: 1.6, color: AppColors.softText, fontWeight: FontWeight.w700)),
          ],
          if (onReject != null) ...[
            const SizedBox(height: 10),
            Align(
              alignment: Alignment.centerLeft,
              child: TextButton.icon(
                onPressed: onReject,
                icon: const Icon(Icons.edit_note_rounded, size: 18),
                label: const Text('هذا مو صحيح', style: TextStyle(fontWeight: FontWeight.w900)),
              ),
            ),
          ],
        ],
      ),
    );
  }

  static String _domainLabel(String domain) => switch (domain) {
        'attachment' => 'التعلق',
        'overthinking' => 'التفكير',
        'anger' => 'الغضب',
        'needs' => 'الاحتياجات',
        'relationship' => 'العلاقة',
        'feminine-balance' => 'الاتزان',
        'inner-peace' => 'السلام الداخلي',
        _ => 'الذات',
      };
}
