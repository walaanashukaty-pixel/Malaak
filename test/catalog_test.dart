import 'package:flutter_test/flutter_test.dart';
import 'package:malaak_balance/data/app_catalog.dart';

void main() {
  test('catalog exposes all approved journeys and quick tools', () {
    expect(AppCatalog.journeys.length, 11);
    expect(AppCatalog.quickTools.length, 9);
    expect(AppCatalog.journeys.map((e) => e.title), contains('نمط التعلق'));
    expect(AppCatalog.journeys.map((e) => e.title), contains('بوصلة الذكاء الأنثوي'));
  });
}
