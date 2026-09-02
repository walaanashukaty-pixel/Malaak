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
  });

  final String id;
  final String label;
  final FiWeights weights;
}

class FiAssessmentQuestion {
  const FiAssessmentQuestion({
    required this.id,
    required this.prompt,
    required this.options,
    this.contextPrompt,
  });

  final String id;
  final String prompt;
  final List<FiAssessmentOption> options;
  final String? contextPrompt;
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
  });

  final String id;
  final String title;
  final String subtitle;
  final String insight;
  final String prompt;
  final String practice;
  final List<String> choices;
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
