import 'package:flutter/material.dart';

class FiWeights {
  const FiWeights({
    this.peoplePleasing = 0,
    this.controlRigidity = 0,
    this.practicalIntelligence = 0,
    this.relationalWisdom = 0,
  });

  final int peoplePleasing;
  final int controlRigidity;
  final int practicalIntelligence;
  final int relationalWisdom;
}

class FiAssessmentOption {
  const FiAssessmentOption({
    required this.id,
    required this.label,
    required this.weights,
    this.coachReply = 'تمام، فهمت عليك. خلينا نكمل ونشوف الصورة من أكتر من موقف.',
  });

  final String id;
  final String label;
  final FiWeights weights;
  final String coachReply;
}

class FiAssessmentQuestion {
  const FiAssessmentQuestion({
    required this.id,
    required this.prompt,
    required this.options,
    this.contextPrompt,
    this.coachLead = 'خلينا ناخد موقف من الحياة اليومية…',
  });

  final String id;
  final String prompt;
  final List<FiAssessmentOption> options;
  final String? contextPrompt;
  final String coachLead;
}

class FiModelDescriptor {
  const FiModelDescriptor({
    required this.routeId,
    required this.title,
    required this.shortTitle,
    required this.description,
    required this.strength,
    required this.growthEdge,
    required this.icon,
  });

  final String routeId;
  final String title;
  final String shortTitle;
  final String description;
  final String strength;
  final String growthEdge;
  final IconData icon;
}

class FiScenarioOption {
  const FiScenarioOption({
    required this.id,
    required this.label,
    required this.feedback,
    this.skillLevel = 1,
  });

  final String id;
  final String label;
  final String feedback;
  final int skillLevel;
}

class FiLesson {
  const FiLesson({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.insight,
    required this.prompt,
    required this.practice,
    this.choices = const <String>[],
    this.choiceReplies = const <String>[],
    this.scenarioPrompt,
    this.scenarioOptions = const <FiScenarioOption>[],
    this.reflectionPrompt = 'لو بدنا نطبق هالمهارة على حياتك، شو أول شي حابة يتغير بطريقة تصرفك؟',
    this.coachClosing = 'ممتاز. هلق ما بدنا نعتبر المهارة "منجزة"؛ بدنا نجربها بالحياة ونرجع نشوف شو صار.',
  });

  final String id;
  final String title;
  final String subtitle;
  final String insight;
  final String prompt;
  final String practice;
  final List<String> choices;
  final List<String> choiceReplies;
  final String? scenarioPrompt;
  final List<FiScenarioOption> scenarioOptions;
  final String reflectionPrompt;
  final String coachClosing;
}

class FiRoute {
  const FiRoute({
    required this.id,
    required this.title,
    required this.resultTitle,
    required this.resultBody,
    required this.goal,
    required this.lessons,
  });

  final String id;
  final String title;
  final String resultTitle;
  final String resultBody;
  final String goal;
  final List<FiLesson> lessons;
}
