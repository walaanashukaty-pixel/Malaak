import '../../../models/learning_journey_state.dart';
import '../models/fi_models.dart';

enum FiNodeStatus {
  locked,
  available,
  inProgress,
  missionPending,
  followupReady,
  mastered,
}

abstract final class FiProgression {
  static const Duration followUpDelay = Duration(hours: 18);

  static bool isFollowUpReady(
    LearningLessonProgress progress, {
    DateTime? now,
  }) {
    final availableAt = progress.followUpAvailableAt;
    if (!progress.missionPending || availableAt == null) return false;
    final clock = now ?? DateTime.now();
    return !clock.isBefore(availableAt);
  }

  static FiNodeStatus nodeStatus({
    required int index,
    required List<FiLesson> lessons,
    required LearningJourneyState state,
    DateTime? now,
  }) {
    if (index < 0 || index >= lessons.length) return FiNodeStatus.locked;
    final lesson = lessons[index];
    final progress = state.lessonProgress[lesson.id] ?? const LearningLessonProgress();

    if (progress.mastered) return FiNodeStatus.mastered;
    if (progress.missionPending) {
      return isFollowUpReady(progress, now: now)
          ? FiNodeStatus.followupReady
          : FiNodeStatus.missionPending;
    }
    if (progress.hasStarted || progress.retryRequired || progress.substituteSimulationPending) {
      return FiNodeStatus.inProgress;
    }
    if (index == 0) return FiNodeStatus.available;

    final previous = state.lessonProgress[lessons[index - 1].id] ?? const LearningLessonProgress();
    return previous.mastered ? FiNodeStatus.available : FiNodeStatus.locked;
  }

  static bool isNodeActionable(FiNodeStatus status) => status != FiNodeStatus.locked;

  static bool isRouteMastered({
    required List<FiLesson> lessons,
    required LearningJourneyState state,
  }) {
    if (lessons.isEmpty) return false;
    return lessons.every((lesson) =>
        (state.lessonProgress[lesson.id] ?? const LearningLessonProgress()).mastered);
  }

  static int currentNodeIndex({
    required List<FiLesson> lessons,
    required LearningJourneyState state,
    DateTime? now,
  }) {
    for (var i = 0; i < lessons.length; i++) {
      if (nodeStatus(index: i, lessons: lessons, state: state, now: now) != FiNodeStatus.mastered) {
        return i;
      }
    }
    return -1;
  }

  static String nextUnlockReason({
    required List<FiLesson> lessons,
    required LearningJourneyState state,
    DateTime? now,
  }) {
    if (lessons.isEmpty) return 'ما في خطوة جديدة بهالمسار.';
    if (isRouteMastered(lessons: lessons, state: state)) {
      return 'المسار الأساسي اكتمل؛ هلق بينفتح فصل جديد بدل ما تنتهي الرحلة.';
    }
    final index = currentNodeIndex(lessons: lessons, state: state, now: now);
    if (index < 0) return 'المسار مكتمل.';
    final status = nodeStatus(index: index, lessons: lessons, state: state, now: now);
    final progress = state.lessonProgress[lessons[index].id] ?? const LearningLessonProgress();
    switch (status) {
      case FiNodeStatus.available:
        return 'ابدئي الجلسة الحالية حتى تنفتح رحلة التطبيق بالحياة.';
      case FiNodeStatus.inProgress:
        if (progress.substituteSimulationPending) {
          return 'أكملي المحاكاة البديلة بنجاح حتى تنفتح الخطوة التالية.';
        }
        if (progress.retryRequired) {
          return 'اعملي محاولة إصلاح قصيرة قبل فتح الخطوة التالية.';
        }
        return 'كمّلي جلسة التدريب الحالية.';
      case FiNodeStatus.missionPending:
        return 'جربي المهمة بالحياة، وبعد وقت المتابعة منرجع نشوف شو صار.';
      case FiNodeStatus.followupReady:
        return 'المتابعة جاهزة هلق؛ نتيجتها هي اللي بتحدد فتح الخطوة التالية.';
      case FiNodeStatus.mastered:
        return 'المهارة مكتسبة، والخطوة التالية مفتوحة.';
      case FiNodeStatus.locked:
        return 'الخطوة التالية بتنفتح بعد إتقان المهارة الحالية.';
    }
  }
}
