import 'package:flutter/material.dart';

import 'app_colors.dart';

/// Lấy bảng màu theo chế độ Sáng/Tối hiện tại: `context.colors.textPrimary`.
extension AppColorsContext on BuildContext {
  AppColors get colors => Theme.of(this).extension<AppColors>()!;
}
