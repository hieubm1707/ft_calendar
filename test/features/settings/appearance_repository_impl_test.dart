import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:example_app/features/settings/data/index.dart';
import 'package:example_app/features/settings/domain/index.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  late AppearanceRepositoryImpl repository;

  setUp(() {
    repository = AppearanceRepositoryImpl(AppearanceLocalDataSourceImpl());
  });

  test('chưa lưu lần nào → mặc định Sáng', () async {
    SharedPreferences.setMockInitialValues({});

    final result = await repository.getThemeMode();

    expect(result, const Right<dynamic, AppThemeMode>(AppThemeMode.light));
  });

  test('lưu Tối rồi đọc lại được Tối', () async {
    SharedPreferences.setMockInitialValues({});

    final saved = await repository.saveThemeMode(AppThemeMode.dark);
    final result = await repository.getThemeMode();

    expect(saved, const Right<dynamic, Unit>(unit));
    expect(result, const Right<dynamic, AppThemeMode>(AppThemeMode.dark));
  });

  test('giá trị lạ trong bộ nhớ → lùi về Sáng', () async {
    SharedPreferences.setMockInitialValues({'app_theme_mode': 'sepia'});

    final result = await repository.getThemeMode();

    expect(result, const Right<dynamic, AppThemeMode>(AppThemeMode.light));
  });
}
