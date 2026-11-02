import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../core/error/index.dart';
import '../../domain/index.dart';

abstract class AppearanceLocalDataSource {
  Future<AppThemeMode> getThemeMode();

  Future<void> saveThemeMode(AppThemeMode mode);
}

/// Lưu chế độ giao diện vào SharedPreferences dưới dạng tên enum ('light'/'dark').
@LazySingleton(as: AppearanceLocalDataSource)
class AppearanceLocalDataSourceImpl implements AppearanceLocalDataSource {
  static const _key = 'app_theme_mode';

  @override
  Future<AppThemeMode> getThemeMode() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final name = prefs.getString(_key);
      return AppThemeMode.values.firstWhere(
        (m) => m.name == name,
        orElse: () => AppThemeMode.light,
      );
    } catch (e) {
      throw CacheException(e.toString());
    }
  }

  @override
  Future<void> saveThemeMode(AppThemeMode mode) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_key, mode.name);
    } catch (e) {
      throw CacheException(e.toString());
    }
  }
}
