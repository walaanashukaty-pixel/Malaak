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

  static String recommendRoute(Map<String, int> scores) {
    final ranked = rankedRoutes(scores);
    return ranked.isEmpty ? FiCatalog.feminineIntelligenceRoute.id : ranked.first;
  }

  static List<String> rankedRoutes(Map<String, int> scores) {
    final weighted = <MapEntry<String, int>>[
      MapEntry(FiCatalog.feminineNaivetyRoute.id, scores['peoplePleasing'] ?? 0),
      MapEntry(FiCatalog.masculineRigidityRoute.id, scores['controlRigidity'] ?? 0),
      MapEntry(FiCatalog.masculineIntelligenceRoute.id, scores['practicalIntelligence'] ?? 0),
      MapEntry(FiCatalog.feminineIntelligenceRoute.id, scores['relationalWisdom'] ?? 0),
    ];
    weighted.sort((a, b) {
      final scoreCompare = b.value.compareTo(a.value);
      if (scoreCompare != 0) return scoreCompare;
      // In ties prefer the more integrative route, while keeping the result a recommendation only.
      const priority = <String, int>{
        'feminine-intelligence-advanced': 4,
        'masculine-intelligence': 3,
        'feminine-naivety': 2,
        'masculine-rigidity': 1,
      };
      return (priority[b.key] ?? 0).compareTo(priority[a.key] ?? 0);
    });
    return weighted.map((entry) => entry.key).toList(growable: false);
  }
}

extension _FirstOrNull<T> on Iterable<T> {
  T? get firstOrNull {
    final iterator = this.iterator;
    if (!iterator.moveNext()) return null;
    return iterator.current;
  }
}
