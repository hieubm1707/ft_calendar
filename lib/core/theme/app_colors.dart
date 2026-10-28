import 'package:flutter/material.dart';

/// Bảng màu chung của app (color template) — mỗi token có 1 giá trị Sáng + 1 Tối.
/// Phong cách "soft-tech pastels": nền gradient hồng → oải hương, thẻ trắng ngả
/// tím, chữ đen ánh chàm, một màu nhấn xanh hoàng gia.
///
/// UI lấy màu qua `context.colors.<token>`, KHÔNG viết mã hex trực tiếp. Ngoại lệ:
/// màu do người dùng chọn (màu sự kiện, tag, cờ ưu tiên) vì đó là dữ liệu.
@immutable
class AppColors extends ThemeExtension<AppColors> {
  /// Nền trang (màu đặc — dùng khi không vẽ được gradient).
  final Color background;

  /// Nền gradient phía sau mọi trang (vẽ ở `AppBackground`).
  final LinearGradient backgroundGradient;

  /// Thẻ, thanh điều hướng, bottom sheet, dialog.
  final Color surface;

  /// Nền phụ: ô nhập, chip, hàng danh sách nằm trong thẻ.
  final Color surfaceAlt;

  /// Viền thẻ / ô nhập.
  final Color border;

  /// Đường kẻ phân cách.
  final Color divider;

  final Color textPrimary;
  final Color textSecondary;
  final Color textMuted;
  final Color textDisabled;

  /// Màu thương hiệu (xanh hoàng gia) — DÙNG CHUNG cho mọi tính năng: nút chính, chip
  /// đang chọn, icon đang chọn, ngày hôm nay, tiến độ…
  final Color accent;

  /// Pomodoro: giai đoạn nghỉ (để phân biệt với giai đoạn tập trung = accent).
  final Color breakTime;

  /// Thông tin / mát lạnh (xanh da trời) — vd. máy lạnh, nút giảm nhiệt độ.
  final Color info;

  final Color danger;
  final Color success;
  final Color warning;

  /// Đổ bóng nhẹ dưới thẻ.
  final Color shadow;

  const AppColors({
    required this.background,
    required this.backgroundGradient,
    required this.surface,
    required this.surfaceAlt,
    required this.border,
    required this.divider,
    required this.textPrimary,
    required this.textSecondary,
    required this.textMuted,
    required this.textDisabled,
    required this.accent,
    required this.breakTime,
    required this.info,
    required this.danger,
    required this.success,
    required this.warning,
    required this.shadow,
  });

  static const light = AppColors(
    background: Color(0xFFF3EDFC),
    backgroundGradient: LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [Color(0xFFFBEAF6), Color(0xFFF0E8FD), Color(0xFFE6E2FC)],
    ),
    surface: Color(0xFFFCFAFF),
    surfaceAlt: Color(0xFFEEE8FC),
    border: Color(0xFFE9E2F8),
    divider: Color(0xFFEDE8F7),
    textPrimary: Color(0xFF17142B),
    textSecondary: Color(0xFF4A4566),
    textMuted: Color(0xFF8A86A3),
    textDisabled: Color(0xFFC3BED8),
    accent: Color(0xFF3D6DF2),
    breakTime: Color(0xFF9B7BF0),
    info: Color(0xFF22A9E0),
    danger: Color(0xFFEF5B78),
    success: Color(0xFF2DBE8F),
    warning: Color(0xFFF2A33A),
    shadow: Color(0x147C5CC4),
  );

  static const dark = AppColors(
    background: Color(0xFF16122B),
    backgroundGradient: LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [Color(0xFF241A3D), Color(0xFF1A1533), Color(0xFF121027)],
    ),
    surface: Color(0xFF231E3D),
    surfaceAlt: Color(0xFF2E2852),
    border: Color(0xFF3A3360),
    divider: Color(0xFF332D57),
    textPrimary: Color(0xFFF3F0FF),
    textSecondary: Color(0xFFC9C3E6),
    textMuted: Color(0xFF9A94BC),
    textDisabled: Color(0xFF625C86),
    accent: Color(0xFF7B9BFF),
    breakTime: Color(0xFFB79CFF),
    info: Color(0xFF5CCBF5),
    danger: Color(0xFFFF7A93),
    success: Color(0xFF4FD8AA),
    warning: Color(0xFFFFB547),
    shadow: Color(0x66000000),
  );

  @override
  AppColors copyWith({
    Color? background,
    LinearGradient? backgroundGradient,
    Color? surface,
    Color? surfaceAlt,
    Color? border,
    Color? divider,
    Color? textPrimary,
    Color? textSecondary,
    Color? textMuted,
    Color? textDisabled,
    Color? accent,
    Color? breakTime,
    Color? info,
    Color? danger,
    Color? success,
    Color? warning,
    Color? shadow,
  }) {
    return AppColors(
      background: background ?? this.background,
      backgroundGradient: backgroundGradient ?? this.backgroundGradient,
      surface: surface ?? this.surface,
      surfaceAlt: surfaceAlt ?? this.surfaceAlt,
      border: border ?? this.border,
      divider: divider ?? this.divider,
      textPrimary: textPrimary ?? this.textPrimary,
      textSecondary: textSecondary ?? this.textSecondary,
      textMuted: textMuted ?? this.textMuted,
      textDisabled: textDisabled ?? this.textDisabled,
      accent: accent ?? this.accent,
      breakTime: breakTime ?? this.breakTime,
      info: info ?? this.info,
      danger: danger ?? this.danger,
      success: success ?? this.success,
      warning: warning ?? this.warning,
      shadow: shadow ?? this.shadow,
    );
  }

  @override
  AppColors lerp(ThemeExtension<AppColors>? other, double t) {
    if (other is! AppColors) return this;
    Color l(Color a, Color b) => Color.lerp(a, b, t)!;
    return AppColors(
      background: l(background, other.background),
      backgroundGradient: LinearGradient.lerp(
        backgroundGradient,
        other.backgroundGradient,
        t,
      )!,
      surface: l(surface, other.surface),
      surfaceAlt: l(surfaceAlt, other.surfaceAlt),
      border: l(border, other.border),
      divider: l(divider, other.divider),
      textPrimary: l(textPrimary, other.textPrimary),
      textSecondary: l(textSecondary, other.textSecondary),
      textMuted: l(textMuted, other.textMuted),
      textDisabled: l(textDisabled, other.textDisabled),
      accent: l(accent, other.accent),
      breakTime: l(breakTime, other.breakTime),
      info: l(info, other.info),
      danger: l(danger, other.danger),
      success: l(success, other.success),
      warning: l(warning, other.warning),
      shadow: l(shadow, other.shadow),
    );
  }
}
