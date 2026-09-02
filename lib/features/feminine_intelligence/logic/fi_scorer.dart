import '../data/fi_catalog.dart';

abstract final class FiScorer {
  static Map<String, int> score(Map<String, String> answers) {
    final scores = <String, int>{
      'peoplePleasing': 0,
      'controlRigidity': 0,
      'practicalIntelligence': 0,
      'relationalWisdom': 0,
    };

    for (final question in FiCatalog.assessmentQuestions) {
      final selectedId = answers[question.id];
      if (selectedId == null) continue;
      final selected = question.options.where((option) => option.id == selectedId).firstOrNull;
      if (selected == null) continue;
      scores['peoplePleasing'] = scores['peoplePleasing']! + selected.weights.peoplePleasing;
      scores['controlRigidity'] = scores['controlRigidity']! + selected.weights.controlRigidity;
      scores['practicalIntelligence'] = scores['practicalIntelligence']! + selected.weights.practicalIntelligence;
      scores['relationalWisdom'] = scores['relationalWisdom']! + selected.weights.relationalWisdom;
    }
    return scores;
  }

  static String route(Map<String, int> scores) {
    final pleasing = scores['peoplePleasing'] ?? 0;
    final rigidity = scores['controlRigidity'] ?? 0;
    final practical = scores['practicalIntelligence'] ?? 0;
    final relational = scores['relationalWisdom'] ?? 0;

    if (pleasing >= 10 && pleasing >= rigidity + 3) return 'feminine-naivety';
    if (rigidity >= 10 && rigidity >= pleasing + 3) return 'masculine-rigidity';
    if ((practical + relational) >= (pleasing + rigidity)) return 'advanced';
    return pleasing >= rigidity ? 'feminine-naivety' : 'masculine-rigidity';
  }
}

extension _FirstOrNull<T> on Iterable<T> {
  T? get firstOrNull {
    final iterator = this.iterator;
    if (!iterator.moveNext()) return null;
    return iterator.current;
  }
}
