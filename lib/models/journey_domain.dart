import 'package:flutter/material.dart';

class JourneyDomain {
  const JourneyDomain({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.goal,
    required this.currentStage,
    required this.currentSkill,
    required this.nextStep,
    required this.icon,
    required this.color,
    required this.signalOne,
    required this.signalTwo,
  });

  final String id;
  final String title;
  final String subtitle;
  final String goal;
  final String currentStage;
  final String currentSkill;
  final String nextStep;
  final IconData icon;
  final Color color;
  final String signalOne;
  final String signalTwo;
}
