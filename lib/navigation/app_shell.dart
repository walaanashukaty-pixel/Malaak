import 'package:flutter/material.dart';
import '../core/layout/mobile_insets.dart';
import '../screens/home/home_screen.dart';
import '../screens/journey/journey_screen.dart';
import '../screens/malaak/malaak_screen.dart';
import '../screens/profile/profile_screen.dart';
import '../widgets/app_bottom_nav.dart';

class AppShell extends StatefulWidget {
  const AppShell({super.key});

  @override
  State<AppShell> createState() => _AppShellState();
}

class _AppShellState extends State<AppShell> {
  int _index = 0;
  String? _malaakPreset;

  void _goTo(int index) {
    setState(() {
      if (index == 1) _malaakPreset = null;
      _index = index;
    });
  }

  void _openMalaak(String? preset) {
    setState(() {
      _malaakPreset = preset;
      _index = 1;
    });
  }

  @override
  Widget build(BuildContext context) {
    final keyboardOpen = MobileInsets.keyboardOpen(context);
    final pages = [
      HomeScreen(onOpenMalaak: _openMalaak, onOpenJourney: () => _goTo(2), onOpenProfile: () => _goTo(3)),
      MalaakScreen(initialPreset: _malaakPreset),
      const JourneyScreen(),
      const ProfileScreen(),
    ];

    return Scaffold(
      extendBody: true,
      resizeToAvoidBottomInset: true,
      body: IndexedStack(index: _index, children: pages),
      bottomNavigationBar: keyboardOpen ? null : AppBottomNav(index: _index, onChanged: _goTo),
    );
  }
}

class MalaakShellTestHost extends StatelessWidget {
  const MalaakShellTestHost({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(home: Directionality(textDirection: TextDirection.rtl, child: AppShell()));
  }
}
