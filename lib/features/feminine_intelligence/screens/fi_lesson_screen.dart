import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../models/learning_journey_state.dart';
import '../../../state/app_scope.dart';
import '../../../widgets/premium_card.dart';
import '../data/fi_catalog.dart';
import '../models/fi_models.dart';

class FiLessonScreen extends StatefulWidget {
  const FiLessonScreen({super.key, required this.lesson});

  final FiLesson lesson;

  @override
  State<FiLessonScreen> createState() => _FiLessonScreenState();
}

class _FiLessonScreenState extends State<FiLessonScreen> {
  final _discoveryController = TextEditingController();
  final _reflectionController = TextEditingController();
  String? _selectedChoice;
  String? _scenarioChoiceId;
  int _sessionStep = 0;
  int _attempts = 0;
  bool _loaded = false;
  bool _saving = false;
  late LearningLessonProgress _initialProgress;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_loaded) return;
    final journey = AppScope.of(context).state.learningJourneys[FiCatalog.domainId];
    _initialProgress = journey?.lessonProgress[widget.lesson.id] ?? const LearningLessonProgress();
    _selectedChoice = _initialProgress.selectedChoice;
    _reflectionController.text = _initialProgress.reflection ?? '';
    _attempts = _initialProgress.attempts;
    _loaded = true;
  }

  @override
  void dispose() {
    _discoveryController.dispose();
    _reflectionController.dispose();
    super.dispose();
  }

  List<FiScenarioOption> get _scenarioOptions {
    if (widget.lesson.scenarioOptions.isNotEmpty) return widget.lesson.scenarioOptions;
    return const <FiScenarioOption>[
      FiScenarioOption(
        id: 'old-pattern',
        label: 'بتصرف بسرعة مثل ما بعمل عادةً.',
        feedback: 'هالاختيار مفهوم لأنه مألوف، بس ما عطانا فرصة نجرب المهارة الجديدة. خلينا نعيد الموقف ونختار استجابة فيها وقفة أو وضوح أكتر.',
        skillLevel: 0,
      ),
      FiScenarioOption(
        id: 'skillful',
        label: 'باخد وقفة وبطبق مهارة اليوم قبل ما أقرر.',
        feedback: 'هون عم تعملي الشي اللي عم نتدرب عليه: مساحة صغيرة بين الدافع وبين التصرف. مو ضمان لنتيجة مثالية، لكنه بيعطيكي خيار حقيقي.',
        skillLevel: 2,
      ),
      FiScenarioOption(
        id: 'avoid',
        label: 'بتجنب الموقف كليًا حتى ما أتعب.',
        feedback: 'الابتعاد ممكن يكون مفيد إذا كان مقصود ومؤقت، بس إذا صار هروب دائم ما منكون طبقنا المهارة. فكري بمسافة محددة وبعدين رجعة واعية للموقف.',
        skillLevel: 1,
      ),
    ];
  }

  FiScenarioOption? get _selectedScenario {
    final id = _scenarioChoiceId;
    if (id == null) return null;
    for (final option in _scenarioOptions) {
      if (option.id == id) return option;
    }
    return null;
  }

  bool get _canContinue {
    if (_sessionStep == 1) {
      if (widget.lesson.choices.isNotEmpty) return _selectedChoice != null;
      return _discoveryController.text.trim().isNotEmpty;
    }
    if (_sessionStep == 3) return _scenarioChoiceId != null;
    if (_sessionStep == 4) return (_selectedScenario?.skillLevel ?? 0) > 0;
    if (_sessionStep == 5) return _reflectionController.text.trim().isNotEmpty;
    return true;
  }

  void _next() {
    if (!_canContinue || _saving) return;
    if (_sessionStep >= 6) {
      _commitMission();
      return;
    }
    setState(() => _sessionStep += 1);
  }

  void _previous() {
    if (_sessionStep == 0 || _saving) return;
    setState(() => _sessionStep -= 1);
  }

  String _choiceReflection() {
    final selected = _selectedChoice ?? _discoveryController.text.trim();
    if (selected.isEmpty) return 'لسه عم نكتشف كيف هالمهارة بتظهر بحياتك.';
    final index = widget.lesson.choices.indexOf(selected);
    if (index >= 0 && index < widget.lesson.choiceReplies.length) {
      return widget.lesson.choiceReplies[index];
    }
    return 'جوابك بيساعدنا نحدد وين بيصير الضغط عندك. المهم هون مو نحكم عليه؛ المهم نلاحظ اللحظة اللي بيبلش فيها النمط ونخلق خيار جديد.';
  }

  Future<void> _commitMission() async {
    if (_saving) return;
    setState(() => _saving = true);
    final app = AppScope.of(context);
    final old = app.state.learningJourneys[FiCatalog.domainId] ??
        const LearningJourneyState(domainId: FiCatalog.domainId);
    final progress = Map<String, LearningLessonProgress>.from(old.lessonProgress);
    final previous = progress[widget.lesson.id] ?? _initialProgress;
    progress[widget.lesson.id] = previous.copyWith(
      stage: 'missionPending',
      sessionStep: 6,
      attempts: _attempts + 1,
      selectedChoice: _selectedChoice ?? _discoveryController.text.trim(),
      scenarioChoice: _scenarioChoiceId,
      reflection: _reflectionController.text.trim(),
      mission: widget.lesson.practice,
      updatedAt: DateTime.now(),
    );
    await app.saveLearningJourneyState(old.copyWith(lessonProgress: progress));
    if (!mounted) return;
    setState(() => _saving = false);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('حفظتلك المهمة 🌱 المرة الجاية منرجع نشوف شو صار بالحياة الحقيقية.')),
    );
    Navigator.of(context).pop();
  }

  Future<void> _saveFollowUp(String outcome) async {
    if (_saving) return;
    setState(() => _saving = true);
    final app = AppScope.of(context);
    final old = app.state.learningJourneys[FiCatalog.domainId] ??
        const LearningJourneyState(domainId: FiCatalog.domainId);
    final progress = Map<String, LearningLessonProgress>.from(old.lessonProgress);
    final previous = progress[widget.lesson.id] ?? _initialProgress;
    final tried = outcome == 'success' || outcome == 'difficult' || outcome == 'oldPattern';
    progress[widget.lesson.id] = previous.copyWith(
      stage: tried ? 'applied' : 'missionPending',
      realLifeApplications: previous.realLifeApplications + (tried ? 1 : 0),
      lastOutcome: outcome,
      updatedAt: DateTime.now(),
    );
    final completed = <String>{...old.completedLessonIds};
    if (tried) completed.add(widget.lesson.id);
    await app.saveLearningJourneyState(old.copyWith(
      lessonProgress: progress,
      completedLessonIds: completed.toList(growable: false),
    ));
    if (!mounted) return;
    setState(() => _saving = false);
    final message = switch (outcome) {
      'success' => 'ممتاز. اللي بهمنا مو الكمال؛ بهمنا إنك استخدمتي المهارة فعلًا بالحياة ✨',
      'difficult' => 'المحاولة الصعبة محسوبة. هاد دليل تطبيق، وهلأ منعرف وين بدنا نقوّي التدريب.',
      'oldPattern' => 'حتى رجوعك للنمط القديم معلومة مهمة. الفرق إنك هلق لاحظتيه، ومنقدر نتمرن عليه بدل ما يمر بدون وعي.',
      'noChance' => 'تمام، ما رح نعتبرها ناقصة. منخلي المهمة مفتوحة لحد ما يجي موقف مناسب.',
      _ => 'ولا يهمك. منخلي المهمة موجودة ونرجع نجربها بأول فرصة مناسبة.',
    };
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    if (!_loaded) return const Scaffold(body: Center(child: CircularProgressIndicator()));
    if (_initialProgress.missionPending) return _buildFollowUp(context);

    return Scaffold(
      appBar: AppBar(title: Text(widget.lesson.title, style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w900))),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(18, 6, 18, 8),
              child: Row(
                children: [
                  Text('جلسة تدريب • ${_sessionStep + 1}/7', style: const TextStyle(fontSize: 10.5, fontWeight: FontWeight.w800, color: AppColors.mutedText)),
                  const Spacer(),
                  if (_initialProgress.realLifeApplications > 0)
                    Text('تطبيقات حقيقية: ${_initialProgress.realLifeApplications}', style: const TextStyle(fontSize: 10.5, fontWeight: FontWeight.w900, color: AppColors.success)),
                ],
              ),
            ),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(18, 8, 18, 18),
                children: _buildSessionStep(),
              ),
            ),
            Container(
              padding: const EdgeInsets.fromLTRB(18, 10, 18, 14),
              decoration: BoxDecoration(color: Colors.white, border: Border(top: BorderSide(color: AppColors.border.withOpacity(0.8)))),
              child: Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: _sessionStep == 0 || _saving ? null : _previous,
                      child: const Text('السابق'),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    flex: 2,
                    child: FilledButton(
                      onPressed: _canContinue && !_saving ? _next : null,
                      child: _saving
                          ? const SizedBox(width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                          : Text(_sessionStep == 6 ? 'راح أجربها بالحياة' : 'كمّلي مع ملاك'),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildSessionStep() {
    final scenario = _selectedScenario;
    switch (_sessionStep) {
      case 0:
        return [
          _CoachBubble(text: 'اليوم ما رح نقرأ درس ونحط صح عليه. رح نفهم ${widget.lesson.title} على موقف من حياتك، نتدرب، وبعدين أعطيكي مهمة صغيرة نجربها برا التطبيق.'),
          const SizedBox(height: 12),
          _CoachBubble(text: widget.lesson.insight),
          if (_initialProgress.realLifeApplications > 0) ...[
            const SizedBox(height: 12),
            _CoachBubble(text: 'إنتِ طبقتي هالمهارة بالحياة ${_initialProgress.realLifeApplications} مرة. هالجلسة تقوية، مو إعادة من الصفر.'),
          ],
        ];
      case 1:
        return [
          _CoachBubble(text: widget.lesson.prompt),
          const SizedBox(height: 12),
          if (widget.lesson.choices.isNotEmpty)
            for (final choice in widget.lesson.choices) ...[
              _ChoiceCard(
                label: choice,
                selected: _selectedChoice == choice,
                onTap: () => setState(() => _selectedChoice = choice),
              ),
              const SizedBox(height: 8),
            ]
          else
            PremiumCard(
              child: TextField(
                controller: _discoveryController,
                minLines: 3,
                maxLines: 5,
                onChanged: (_) => setState(() {}),
                decoration: const InputDecoration(hintText: 'احكي لملاك عن موقف حقيقي…'),
              ),
            ),
        ];
      case 2:
        final answer = _selectedChoice ?? _discoveryController.text.trim();
        return [
          if (answer.isNotEmpty) _UserBubble(text: answer),
          if (answer.isNotEmpty) const SizedBox(height: 10),
          _CoachBubble(text: _choiceReflection()),
          const SizedBox(height: 12),
          _CoachBubble(text: 'هلق خلينا ما نكتفي بالفهم. بدي حطك بموقف صغير ونشوف شو بتختاري لما يصير الضغط.'),
        ];
      case 3:
        return [
          _Scenario(
            title: widget.lesson.scenarioPrompt ?? 'تخيلي إن نفس النمط ظهر اليوم بموقف حقيقي مرتبط بـ «${widget.lesson.title}». شو الأقرب لردك؟',
            options: _scenarioOptions,
            selectedId: _scenarioChoiceId,
            onSelect: (id) => setState(() => _scenarioChoiceId = id),
          ),
        ];
      case 4:
        return [
          if (scenario != null) _UserBubble(text: scenario.label),
          if (scenario != null) const SizedBox(height: 10),
          _CoachBubble(text: scenario?.feedback ?? 'خلينا نرجع للموقف ونختار بوعي.'),
          if ((scenario?.skillLevel ?? 0) == 0) ...[
            const SizedBox(height: 14),
            OutlinedButton.icon(
              onPressed: () => setState(() {
                _scenarioChoiceId = null;
                _attempts += 1;
                _sessionStep = 3;
              }),
              icon: const Icon(Icons.refresh_rounded, size: 18),
              label: const Text('جربي مرة تانية'),
            ),
          ] else ...[
            const SizedBox(height: 12),
            _CoachBubble(text: 'تمام. هلق بدنا ننقل المهارة من السيناريو لحياتك إنتِ، بكلماتك إنتِ.'),
          ],
        ];
      case 5:
        return [
          _CoachBubble(text: widget.lesson.reflectionPrompt),
          const SizedBox(height: 12),
          PremiumCard(
            child: TextField(
              controller: _reflectionController,
              minLines: 3,
              maxLines: 6,
              onChanged: (_) => setState(() {}),
              decoration: const InputDecoration(hintText: 'اكتبي بطريقتك… ما بدنا جواب مثالي.'),
            ),
          ),
        ];
      default:
        return [
          _CoachBubble(text: widget.lesson.coachClosing),
          const SizedBox(height: 12),
          PremiumCard(
            color: AppColors.sage.withOpacity(0.10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('مهمتك بالحياة 🌱', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w900, color: AppColors.plum)),
                const SizedBox(height: 7),
                Text(widget.lesson.practice, style: const TextStyle(fontSize: 12, height: 1.75, color: AppColors.softText)),
                const SizedBox(height: 10),
                const Text('ما رح نحسب المهارة منجزة الآن. لما ترجعي، ملاك رح تسألك شو صار فعلًا.', style: TextStyle(fontSize: 10.5, height: 1.6, fontWeight: FontWeight.w700, color: AppColors.mutedText)),
              ],
            ),
          ),
        ];
    }
  }

  Widget _buildFollowUp(BuildContext context) {
    final mission = _initialProgress.mission ?? widget.lesson.practice;
    return Scaffold(
      appBar: AppBar(title: Text(widget.lesson.title, style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w900))),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(18, 12, 18, 36),
        children: [
          const _CoachBubble(text: 'أهلين 🌷 المرة الماضية ما سكّرنا التدريب بزر "أنجزت". اتفقنا نجربه بالحياة الحقيقية.'),
          const SizedBox(height: 12),
          PremiumCard(
            color: AppColors.sage.withOpacity(0.10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('المهمة اللي اتفقنا عليها', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w900, color: AppColors.gold)),
                const SizedBox(height: 6),
                Text(mission, style: const TextStyle(fontSize: 12, height: 1.7, color: AppColors.plum, fontWeight: FontWeight.w700)),
              ],
            ),
          ),
          const SizedBox(height: 14),
          const _CoachBubble(text: 'كيف مشي التطبيق اللي اتفقنا عليه؟'),
          const SizedBox(height: 12),
          _FollowUpChoice(label: 'جربته ونجح معي', onTap: () => _saveFollowUp('success')),
          const SizedBox(height: 8),
          _FollowUpChoice(label: 'جربته، بس كان صعب', onTap: () => _saveFollowUp('difficult')),
          const SizedBox(height: 8),
          _FollowUpChoice(label: 'صار موقف ورجعت لطريقتي القديمة', onTap: () => _saveFollowUp('oldPattern')),
          const SizedBox(height: 8),
          _FollowUpChoice(label: 'ما إجتني فرصة مناسبة', onTap: () => _saveFollowUp('noChance')),
          const SizedBox(height: 8),
          _FollowUpChoice(label: 'نسيت أجربها', onTap: () => _saveFollowUp('forgot')),
          if (_saving) ...[
            const SizedBox(height: 14),
            const Center(child: CircularProgressIndicator()),
          ],
        ],
      ),
    );
  }
}

class _Scenario extends StatelessWidget {
  const _Scenario({required this.title, required this.options, required this.selectedId, required this.onSelect});
  final String title;
  final List<FiScenarioOption> options;
  final String? selectedId;
  final ValueChanged<String> onSelect;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _CoachBubble(text: title),
        const SizedBox(height: 12),
        for (final option in options) ...[
          _ChoiceCard(label: option.label, selected: selectedId == option.id, onTap: () => onSelect(option.id)),
          const SizedBox(height: 8),
        ],
      ],
    );
  }
}

class _ChoiceCard extends StatelessWidget {
  const _ChoiceCard({required this.label, required this.selected, required this.onTap});
  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return PremiumCard(
      onTap: onTap,
      color: selected ? AppColors.lavender.withOpacity(0.10) : Colors.white,
      borderColor: selected ? AppColors.lilac : AppColors.border,
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 13),
      child: Row(
        children: [
          Icon(selected ? Icons.check_circle_rounded : Icons.circle_outlined, size: 20, color: selected ? AppColors.lilac : AppColors.mutedText),
          const SizedBox(width: 10),
          Expanded(child: Text(label, style: const TextStyle(fontSize: 12, height: 1.55, fontWeight: FontWeight.w700, color: AppColors.plum))),
        ],
      ),
    );
  }
}

class _FollowUpChoice extends StatelessWidget {
  const _FollowUpChoice({required this.label, required this.onTap});
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return PremiumCard(
      onTap: onTap,
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 14),
      child: Row(
        children: [
          const Icon(Icons.chat_bubble_outline_rounded, size: 19, color: AppColors.lilac),
          const SizedBox(width: 10),
          Expanded(child: Text(label, style: const TextStyle(fontSize: 12, height: 1.5, fontWeight: FontWeight.w800, color: AppColors.plum))),
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
        child: Text(text, style: const TextStyle(fontSize: 12.2, height: 1.75, color: AppColors.plum, fontWeight: FontWeight.w700)),
      ),
    );
  }
}

class _UserBubble extends StatelessWidget {
  const _UserBubble({required this.text});
  final String text;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        constraints: const BoxConstraints(maxWidth: 315),
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 12),
        decoration: const BoxDecoration(
          gradient: AppColors.primaryGradient,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(22),
            topRight: Radius.circular(22),
            bottomRight: Radius.circular(22),
            bottomLeft: Radius.circular(6),
          ),
        ),
        child: Text(text, style: const TextStyle(fontSize: 12, height: 1.65, color: Colors.white, fontWeight: FontWeight.w800)),
      ),
    );
  }
}
