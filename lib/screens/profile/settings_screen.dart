import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../core/theme/app_colors.dart';
import '../../state/app_scope.dart';
import '../../widgets/premium_card.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  Future<void> _editName(BuildContext context) async {
    final app = AppScope.of(context);
    final controller = TextEditingController(text: app.state.preferences.displayName);
    final result = await showDialog<String>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('اسمك داخل ملاك', style: TextStyle(fontWeight: FontWeight.w900)),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(hintText: 'الاسم أو اللقب اللي بتحبيه'),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(dialogContext), child: const Text('إلغاء')),
          FilledButton(onPressed: () => Navigator.pop(dialogContext, controller.text), child: const Text('حفظ')),
        ],
      ),
    );
    controller.dispose();
    if (result != null) await app.setDisplayName(result);
  }

  Future<void> _signOut(BuildContext context) async {
    final ok = await showDialog<bool>(
          context: context,
          builder: (dialogContext) => AlertDialog(
            title: const Text('تسجيل الخروج', style: TextStyle(fontWeight: FontWeight.w900)),
            content: const Text('بيانات الحساب تبقى محفوظة بالسحابة، والنسخة المحلية تبقى معزولة حسب الحساب.'),
            actions: [
              TextButton(onPressed: () => Navigator.pop(dialogContext, false), child: const Text('إلغاء')),
              FilledButton(onPressed: () => Navigator.pop(dialogContext, true), child: const Text('تسجيل الخروج')),
            ],
          ),
        ) ??
        false;
    if (ok) {
      Navigator.of(context).popUntil((route) => route.isFirst);
      await Supabase.instance.client.auth.signOut();
    }
  }

  String _syncLabel(BuildContext context) {
    final app = AppScope.of(context);
    if (app.syncing) return 'عم نزامن الآن...';
    if (app.hasPendingLocalChanges) return 'في تغييرات محفوظة محليًا تنتظر المزامنة';
    if (app.syncError != null) return 'آخر محاولة مزامنة واجهت مشكلة — بياناتك المحلية محفوظة';
    final last = app.lastSyncAt;
    if (last == null) return 'لسه ما صار أول تزامن';
    return "آخر مزامنة: ${last.hour.toString().padLeft(2, '0')}:${last.minute.toString().padLeft(2, '0')}";
  }

  @override
  Widget build(BuildContext context) {
    final app = AppScope.of(context);
    final name = app.state.preferences.displayName;
    return Scaffold(
      appBar: AppBar(title: const Text('الإعدادات', style: TextStyle(fontWeight: FontWeight.w900))),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(18, 6, 18, 32),
        children: [
          PremiumCard(
            onTap: () => _editName(context),
            child: Row(
              children: [
                const Icon(Icons.person_outline_rounded, color: AppColors.lavender),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('الاسم داخل التطبيق', style: TextStyle(fontWeight: FontWeight.w900, color: AppColors.plum)),
                      const SizedBox(height: 3),
                      Text(name.isEmpty ? 'اضغطي لإضافة اسمك' : name, style: const TextStyle(fontSize: 11.5, color: AppColors.softText)),
                    ],
                  ),
                ),
                const Icon(Icons.edit_rounded, size: 18, color: AppColors.mutedText),
              ],
            ),
          ),
          const SizedBox(height: 12),
          PremiumCard(
            color: AppColors.lavender.withOpacity(.06),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Row(
                  children: [
                    Icon(Icons.cloud_done_outlined, color: AppColors.lavender),
                    SizedBox(width: 10),
                    Text('الحساب والمزامنة', style: TextStyle(fontWeight: FontWeight.w900, color: AppColors.plum)),
                  ],
                ),
                const SizedBox(height: 10),
                Text(app.userEmail ?? 'غير مسجل', style: const TextStyle(fontSize: 11.5, color: AppColors.softText)),
                const SizedBox(height: 4),
                Text(_syncLabel(context), style: const TextStyle(fontSize: 10.5, height: 1.6, color: AppColors.mutedText)),
                const SizedBox(height: 12),
                OutlinedButton.icon(
                  onPressed: app.syncing ? null : app.syncNow,
                  icon: app.syncing
                      ? const SizedBox.square(dimension: 16, child: CircularProgressIndicator(strokeWidth: 2))
                      : const Icon(Icons.sync_rounded),
                  label: const Text('مزامنة الآن'),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          PremiumCard(
            color: AppColors.gold.withOpacity(0.07),
            child: const Text(
              'اليوميات والذاكرة والتقدم تتزامن مع Supabase عند تسجيل الدخول. إذا انقطع الإنترنت، تبقى التغييرات على الجهاز وتُرفع عند عودة الاتصال. نص اليوميات لا يُرسل لملاك الذكية إلا إذا فعّلتِ إذن تحليل اليوميات.',
              style: TextStyle(fontSize: 11.5, height: 1.7, color: AppColors.softText),
            ),
          ),
          const SizedBox(height: 20),
          OutlinedButton.icon(
            onPressed: () => _signOut(context),
            icon: const Icon(Icons.logout_rounded),
            label: const Text('تسجيل الخروج'),
          ),
        ],
      ),
    );
  }
}
