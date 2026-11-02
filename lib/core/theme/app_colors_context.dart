import 'package:flutter/material.dart';

import 'app_colors.dart';

/// Lấy bảng màu theo chế độ Sáng/Tối hiện tại: `context.colors.textPrimary`.
extension AppColorsContext on BuildContext {
  AppColors get colors => Theme.of(this).extension<AppColors>()!;
}

/// Chọn màu chữ/icon đọc được trên một nền màu bất kỳ (accent, màu mục tiêu…):
/// trắng hoặc chữ đậm của bảng màu, lấy bên có độ tương phản WCAG cao hơn.
extension ReadableForeground on Color {
  Color get readableForeground {
    const dark = Color(0xFF17142B); // = AppColors.light.textPrimary
    final bg = computeLuminance() + 0.05;
    final onWhite = 1.05 / bg;
    final onDark = bg / (dark.computeLuminance() + 0.05);
    return onWhite >= onDark ? Colors.white : dark;
  }
}
