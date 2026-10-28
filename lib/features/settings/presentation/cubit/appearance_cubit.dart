import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/usecase/index.dart';
import '../../domain/index.dart';

/// Chế độ giao diện Sáng/Tối của toàn app. Singleton, cung cấp ở gốc `app.dart`.
@lazySingleton
class AppearanceCubit extends Cubit<AppThemeMode> {
  final GetThemeMode _getThemeMode;
  final SaveThemeMode _saveThemeMode;

  AppearanceCubit(this._getThemeMode, this._saveThemeMode)
      : super(AppThemeMode.light);

  /// Gọi trước `runApp` để mở app đúng chế độ, không bị chớp nền sáng.
  Future<void> load() async {
    final result = await _getThemeMode(const NoParams());
    result.fold((_) {}, emit);
  }

  /// Đổi giao diện ngay rồi mới lưu. Lưu lỗi thì vẫn giữ chế độ trong phiên này.
  Future<void> setMode(AppThemeMode mode) async {
    if (mode == state) return;
    emit(mode);
    await _saveThemeMode(mode);
  }
}
