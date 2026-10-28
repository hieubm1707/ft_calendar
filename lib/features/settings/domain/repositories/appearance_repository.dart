import 'package:dartz/dartz.dart';

import '../../../../core/error/index.dart';
import '../entities/app_theme_mode.dart';

abstract class AppearanceRepository {
  /// Chế độ đã lưu; chưa lưu lần nào thì là [AppThemeMode.light].
  Future<Either<Failure, AppThemeMode>> getThemeMode();

  Future<Either<Failure, Unit>> saveThemeMode(AppThemeMode mode);
}
