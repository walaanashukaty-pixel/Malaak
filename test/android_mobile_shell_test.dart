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

Widget _host(MediaQueryData media) {
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
  testWidgets('Android keyboard hides floating bottom navigation', (tester) async {
    await tester.pumpWidget(_host(const MediaQueryData()));
    expect(find.text('الرئيسية'), findsOneWidget);

    await tester.pumpWidget(
      _host(const MediaQueryData(viewInsets: EdgeInsets.only(bottom: 320))),
    );
    await tester.pump();

    expect(find.text('الرئيسية'), findsNothing);
  });
}
