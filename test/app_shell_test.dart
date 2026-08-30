import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:malaak_balance/models/app_state.dart';
import 'package:malaak_balance/navigation/app_shell.dart';
import 'package:malaak_balance/state/app_controller.dart';
import 'package:malaak_balance/state/app_scope.dart';
import 'package:malaak_balance/storage/app_repository.dart';

class _MemoryRepository implements AppRepository {
  AppStateData state = AppStateData();

  @override
  Future<AppStateData> load() async => state;

  @override
  Future<void> save(AppStateData next) async {
    state = next;
  }
}

Widget _host({MediaQueryData media = const MediaQueryData()}) {
  final controller = AppController(_MemoryRepository());
  return AppScope(
    controller: controller,
    child: MaterialApp(
      home: MediaQuery(
        data: media,
        child: const Directionality(
          textDirection: TextDirection.rtl,
          child: AppShell(),
        ),
      ),
    ),
  );
}

void main() {
  testWidgets('mobile shell has exactly four bottom destinations and no drawer', (tester) async {
    await tester.pumpWidget(_host());
    expect(find.text('الرئيسية'), findsOneWidget);
    expect(find.text('ملاك'), findsWidgets);
    expect(find.text('رحلتي'), findsOneWidget);
    expect(find.text('أنا'), findsOneWidget);
    expect(find.byType(Drawer), findsNothing);
    expect(find.byType(NavigationRail), findsNothing);
  });
}
