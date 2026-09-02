import 'journal_entry.dart';
import 'journey_progress.dart';
import 'memory_item.dart';
import 'user_preferences.dart';
import 'malaak_message.dart';
import 'coaching_turn.dart';
import 'coaching_follow_up.dart';
import 'initial_map.dart';
import 'journey_plan.dart';
import 'learning_journey_state.dart';

class AppStateData {
  AppStateData({
    List<JournalEntry>? journals,
    Map<String, JourneyProgress>? journeys,
    List<MemoryItem>? memories,
    UserPreferences? preferences,
    List<MalaakMessage>? messages,
    List<CoachingTurn>? coachingTurns,
    List<CoachingFollowUp>? pendingFollowUps,
    this.initialMap,
    this.journeyPlan,
    Map<String, LearningJourneyState>? learningJourneys,
  })  : journals = journals ?? [],
        journeys = journeys ?? {},
        memories = memories ?? [],
        preferences = preferences ?? const UserPreferences(),
        messages = messages ?? [],
        coachingTurns = coachingTurns ?? [],
        pendingFollowUps = pendingFollowUps ?? [],
        learningJourneys = learningJourneys ?? {};

  final List<JournalEntry> journals;
  final Map<String, JourneyProgress> journeys;
  final List<MemoryItem> memories;
  final UserPreferences preferences;
  final List<MalaakMessage> messages;
  final List<CoachingTurn> coachingTurns;
  final List<CoachingFollowUp> pendingFollowUps;
  final InitialMap? initialMap;
  final JourneyPlan? journeyPlan;
  final Map<String, LearningJourneyState> learningJourneys;

  AppStateData copyWith({
    List<JournalEntry>? journals,
    Map<String, JourneyProgress>? journeys,
    List<MemoryItem>? memories,
    UserPreferences? preferences,
    List<MalaakMessage>? messages,
    List<CoachingTurn>? coachingTurns,
    List<CoachingFollowUp>? pendingFollowUps,
    InitialMap? initialMap,
    JourneyPlan? journeyPlan,
    Map<String, LearningJourneyState>? learningJourneys,
  }) =>
      AppStateData(
        journals: journals ?? this.journals,
        journeys: journeys ?? this.journeys,
        memories: memories ?? this.memories,
        preferences: preferences ?? this.preferences,
        messages: messages ?? this.messages,
        coachingTurns: coachingTurns ?? this.coachingTurns,
        pendingFollowUps: pendingFollowUps ?? this.pendingFollowUps,
        initialMap: initialMap ?? this.initialMap,
        journeyPlan: journeyPlan ?? this.journeyPlan,
        learningJourneys: learningJourneys ?? this.learningJourneys,
      );

  Map<String, dynamic> toJson() => {
        'journals': journals.map((e) => e.toJson()).toList(),
        'journeys': journeys.map((k, v) => MapEntry(k, v.toJson())),
        'memories': memories.map((e) => e.toJson()).toList(),
        'preferences': preferences.toJson(),
        'messages': messages.map((e) => e.toJson()).toList(),
        'coachingTurns': coachingTurns.map((e) => e.toJson()).toList(),
        'pendingFollowUps': pendingFollowUps.map((e) => e.toJson()).toList(),
        'initialMap': initialMap?.toJson(),
        'journeyPlan': journeyPlan?.toJson(),
        'learningJourneys': learningJourneys.map((key, value) => MapEntry(key, value.toJson())),
      };

  factory AppStateData.fromJson(Map<String, dynamic> json) {
    final journeysRaw = Map<String, dynamic>.from(json['journeys'] as Map? ?? const {});
    final learningRaw = Map<String, dynamic>.from(json['learningJourneys'] as Map? ?? const {});
    return AppStateData(
      journals: (json['journals'] as List? ?? const [])
          .map((e) => JournalEntry.fromJson(Map<String, dynamic>.from(e as Map)))
          .toList(),
      journeys: {
        for (final entry in journeysRaw.entries)
          entry.key: JourneyProgress.fromJson(Map<String, dynamic>.from(entry.value as Map)),
      },
      memories: (json['memories'] as List? ?? const [])
          .map((e) => MemoryItem.fromJson(Map<String, dynamic>.from(e as Map)))
          .toList(),
      preferences: UserPreferences.fromJson(
        Map<String, dynamic>.from(json['preferences'] as Map? ?? const {}),
      ),
      messages: (json['messages'] as List? ?? const [])
          .map((e) => MalaakMessage.fromJson(Map<String, dynamic>.from(e as Map)))
          .toList(),
      coachingTurns: (json['coachingTurns'] as List? ?? const [])
          .map((e) => CoachingTurn.fromJson(Map<String, dynamic>.from(e as Map)))
          .toList(),
      pendingFollowUps: (json['pendingFollowUps'] as List? ?? const [])
          .map((e) => CoachingFollowUp.fromJson(Map<String, dynamic>.from(e as Map)))
          .toList(),
      initialMap: json['initialMap'] is Map
          ? InitialMap.fromJson(Map<String, dynamic>.from(json['initialMap'] as Map))
          : null,
      journeyPlan: JourneyPlan.tryFromJson(json['journeyPlan']),
      learningJourneys: {
        for (final entry in learningRaw.entries)
          entry.key: LearningJourneyState.fromJson(Map<String, dynamic>.from(entry.value as Map)),
      },
    );
  }
}
