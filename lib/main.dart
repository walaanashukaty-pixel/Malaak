import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'auth/auth_gate.dart';
import 'config/supabase_config.dart';
import 'core/theme/app_theme.dart';
import 'services/malaak_gateway.dart';
import 'state/app_controller.dart';
import 'state/app_scope.dart';
import 'storage/supabase_app_repository.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Supabase.initialize(
    url: SupabaseConfig.url,
    publishableKey: SupabaseConfig.publishableKey,
  );

  final prefs = await SharedPreferences.getInstance();
  final client = Supabase.instance.client;
  final repository = SupabaseAppRepository(prefs: prefs, client: client);
  final controller = AppController(
    repository,
    malaakGateway: MalaakGateway(client),
  );
  await controller.load();

  runApp(MalaakApp(controller: controller));
}

class MalaakApp extends StatelessWidget {
  const MalaakApp({super.key, required this.controller});

  final AppController controller;

  @override
  Widget build(BuildContext context) {
    return AppScope(
      controller: controller,
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'ملاك — رحلة الاتزان',
        theme: AppTheme.light,
        locale: const Locale('ar'),
        builder: (context, child) => Directionality(
          textDirection: TextDirection.rtl,
          child: child ?? const SizedBox.shrink(),
        ),
        home: AuthGate(controller: controller),
      ),
    );
  }
}
