import 'package:flutter/material.dart';

import '../../core/layout/mobile_insets.dart';
import '../../core/theme/app_colors.dart';
import '../../models/coaching_turn.dart';
import '../../state/app_scope.dart';
import '../../widgets/premium_card.dart';

class MalaakScreen extends StatefulWidget {
  const MalaakScreen({super.key, this.initialPreset});

  final String? initialPreset;

  @override
  State<MalaakScreen> createState() => _MalaakScreenState();
}

class _MalaakScreenState extends State<MalaakScreen> {
  final controller = TextEditingController();
  final scrollController = ScrollController();
  bool sending = false;

  static const _interventionLabels = <String, String>{
    'REG_GROUND_001': 'تثبيت الحاضر',
    'REG_MOVE_002': 'حركة قصيرة للتنظيم',
    'ANGER_TIMEOUT_001': 'توقف آمن مع موعد رجوع',
    'THOUGHT_FACTS_001': 'الحدث أم التفسير؟',
    'RUMINATION_EXIT_001': 'الخروج من الحلقة',
    'UNCERTAINTY_001': 'تحمّل جزء من عدم اليقين',
    'NEED_NAME_001': 'سمّي الحاجة',
    'REQUEST_DIRECT_001': 'طلب مباشر بدون لوم',
    'BOUNDARY_001': 'حد واضح وقصير',
    'PROBLEM_SOLVE_001': 'مشكلة واحدة وخطوة واحدة',
  };

  @override
  void initState() {
    super.initState();
    _applyPreset(widget.initialPreset);
  }

  @override
  void didUpdateWidget(covariant MalaakScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.initialPreset != widget.initialPreset) {
      _applyPreset(widget.initialPreset);
    }
  }

  void _applyPreset(String? preset) {
    if (preset?.trim().isNotEmpty == true) {
      controller.text = preset!.trim();
      controller.selection = TextSelection.collapsed(offset: controller.text.length);
    }
  }

  @override
  void dispose() {
    controller.dispose();
    scrollController.dispose();
    super.dispose();
  }

  Future<void> send([String? preset]) async {
    final text = (preset ?? controller.text).trim();
    if (text.isEmpty || sending) return;
    setState(() => sending = true);
    controller.clear();
    try {
      await AppScope.of(context).sendToMalaak(text);
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (scrollController.hasClients) {
          scrollController.animateTo(
            scrollController.position.maxScrollExtent,
            duration: const Duration(milliseconds: 250),
            curve: Curves.easeOut,
          );
        }
      });
    } finally {
      if (mounted) setState(() => sending = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final app = AppScope.of(context);
    final messages = app.state.messages;
    final latestTurn = app.state.coachingTurns.isEmpty ? null : app.state.coachingTurns.last;
    final showAction = latestTurn != null && latestTurn.action.trim().isNotEmpty;

    return SafeArea(
      bottom: false,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(18, 16, 18, 10),
            child: PremiumCard(
              gradient: AppColors.malaakGradient,
              borderColor: Colors.transparent,
              child: const Row(
                children: [
                  Icon(Icons.auto_awesome_rounded, color: Colors.white),
                  SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('ملاك', style: TextStyle(fontSize: 18, color: Colors.white, fontWeight: FontWeight.w900)),
                        Text('محادثة مرتبطة بحسابك — وملاك تستخدم فقط السياق اللي سمحتي بحفظه ومشاركته.', style: TextStyle(fontSize: 10.5, color: Color(0xFFD7C8E8), height: 1.4)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(
            height: 42,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 18),
              children: ['🌿 هدّيني', '🧭 رتبيلي الموضوع', '🧠 تحديني بأفكاري', '🎯 ساعديني أتصرف']
                  .map((text) => Padding(
                        padding: const EdgeInsetsDirectional.only(end: 8),
                        child: ActionChip(
                          onPressed: sending ? null : () => send(text),
                          label: Text(text, style: const TextStyle(fontSize: 10.5)),
                        ),
                      ))
                  .toList(),
            ),
          ),
          Expanded(
            child: ListView.builder(
              controller: scrollController,
              padding: const EdgeInsets.fromLTRB(18, 8, 18, 130),
              itemCount: messages.isEmpty ? 1 : messages.length + (showAction ? 1 : 0),
              itemBuilder: (context, index) {
                if (messages.isEmpty) {
                  return const Align(
                    alignment: Alignment.centerRight,
                    child: _Bubble(
                      text: 'أنا معكِ. احكيلي شو صار بدون ما تحتاجي تعرفي اسم المشكلة.',
                      user: false,
                    ),
                  );
                }
                if (showAction && index == messages.length) {
                  return _CoachingActionCard(
                    turn: latestTurn,
                    toolLabel: latestTurn.interventionCode == null
                        ? null
                        : _interventionLabels[latestTurn.interventionCode!],
                  );
                }
                final message = messages[index];
                return Align(
                  alignment: message.isUser ? Alignment.centerLeft : Alignment.centerRight,
                  child: _Bubble(text: message.text, user: message.isUser),
                );
              },
            ),
          ),
          Container(
            padding: EdgeInsets.fromLTRB(16, 10, 16, MobileInsets.composerBottomPadding(context)),
            decoration: const BoxDecoration(
              color: AppColors.cream,
              border: Border(top: BorderSide(color: AppColors.border)),
            ),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: controller,
                    minLines: 1,
                    maxLines: 4,
                    onSubmitted: (_) => send(),
                    decoration: const InputDecoration(hintText: 'احكي لملاك شو صار...'),
                  ),
                ),
                const SizedBox(width: 8),
                IconButton.filled(
                  onPressed: sending ? null : send,
                  icon: sending
                      ? const SizedBox.square(
                          dimension: 18,
                          child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                        )
                      : const Icon(Icons.send_rounded),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _CoachingActionCard extends StatelessWidget {
  const _CoachingActionCard({required this.turn, this.toolLabel});

  final CoachingTurn turn;
  final String? toolLabel;

  @override
  Widget build(BuildContext context) {
    return PremiumCard(
      color: AppColors.lavender.withOpacity(0.07),
      borderColor: AppColors.lavender.withOpacity(0.20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('خطوتك الآن', style: TextStyle(fontSize: 12, color: AppColors.mutedText, fontWeight: FontWeight.w800)),
          if (toolLabel != null) ...[
            const SizedBox(height: 4),
            Text(toolLabel!, style: const TextStyle(fontSize: 13, color: AppColors.lavender, fontWeight: FontWeight.w900)),
          ],
          const SizedBox(height: 8),
          Text(turn.action, style: const TextStyle(fontSize: 13, height: 1.7, color: AppColors.plum, fontWeight: FontWeight.w700)),
        ],
      ),
    );
  }
}

class _Bubble extends StatelessWidget {
  const _Bubble({required this.text, required this.user});

  final String text;
  final bool user;

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(maxWidth: MediaQuery.sizeOf(context).width * .82),
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 12),
      decoration: BoxDecoration(
        gradient: user ? AppColors.primaryGradient : null,
        color: user ? null : Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: user ? null : Border.all(color: AppColors.border),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 13,
          height: 1.7,
          color: user ? Colors.white : AppColors.plum,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
