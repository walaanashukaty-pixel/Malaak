import 'dart:async';

import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../navigation/app_shell.dart';
import '../models/initial_map.dart';
import '../screens/onboarding/initial_map_flow.dart';
import '../state/app_controller.dart';
import 'auth_screen.dart';

class AuthGate extends StatefulWidget {
  const AuthGate({super.key, required this.controller});

  final AppController controller;

  @override
  State<AuthGate> createState() => _AuthGateState();
}

class _AuthGateState extends State<AuthGate> {
  late Session? _session;
  StreamSubscription<AuthState>? _subscription;
  bool _switching = false;

  @override
  void initState() {
    super.initState();
    final auth = Supabase.instance.client.auth;
    _session = auth.currentSession;
    _subscription = auth.onAuthStateChange.listen(
      (data) async {
        if (!mounted) return;
        setState(() {
          _session = data.session;
          _switching = true;
        });
        try {
          await widget.controller.reloadForSession();
        } finally {
          if (mounted) setState(() => _switching = false);
        }
      },
      onError: (Object error, StackTrace stackTrace) {
        // Keep the last known session on transient refresh/network failures.
        // Supabase will retry/refresh again; the UI must not crash.
        debugPrint('Malaak auth state error: $error');
      },
    );
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: widget.controller,
      builder: (context, _) {
        if (_switching || !widget.controller.loaded) {
          return const Scaffold(body: Center(child: CircularProgressIndicator()));
        }
        if (_session == null) return const AuthScreen();
        if (needsInitialMap(widget.controller.state.initialMap)) {
          return InitialMapFlow(controller: widget.controller);
        }
        return const AppShell();
      },
    );
  }
}
