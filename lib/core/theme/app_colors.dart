import 'package:flutter/material.dart';

/// Bảng màu chung của app (color template) — mỗi token có 1 giá trị Sáng + 1 Tối.
///
/// UI lấy màu qua `context.colors.<token>`, KHÔNG viết mã hex trực tiếp. Ngoại lệ:
/// màu do người dùng chọn (màu sự kiện, tag, cờ ưu tiên) vì đó là dữ liệu.
@immutable
class AppColors extends ThemeExtension<AppColors> {
  /// Nền trang.
  final Color background;

  /// Thẻ, AppBar, thanh điều hướng, bottom sheet.
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

  /// Màu thương hiệu (coral) — DÙNG CHUNG cho mọi tính năng: nút chính, chip
  /// đang chọn, icon đang chọn, ngày hôm nay, tiến độ…
  final Color accent;

  /// Pomodoro: giai đoạn nghỉ (để phân biệt với giai đoạn tập trung = accent).
  final Color breakTime;

  /// Thông tin / mát lạnh (xanh dương) — vd. máy lạnh, nút giảm nhiệt độ.
  final Color info;

  final Color danger;
  final Color success;
  final Color warning;

  /// Đổ bóng nhẹ dưới thẻ.
  final Color shadow;

  const AppColors({
    required this.background,
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
    background: Color(0xFFFDF7F2),
    surface: Color(0xFFFFFFFF),
    surfaceAlt: Color(0xFFF5F5F7),
    border: Color(0xFFEFEFF4),
    divider: Color(0xFFEEEEEE),
    textPrimary: Color(0xFF1C1C1E),
    textSecondary: Color(0xFF5A5C69),
    textMuted: Color(0xFF8E8E93),
    textDisabled: Color(0xFFC7C7CC),
    accent: Color(0xFFFF5252),
    breakTime: Color(0xFF5C6BC0),
    info: Color(0xFF448AFF),
    danger: Color(0xFFE53935),
    success: Color(0xFF00C853),
    warning: Color(0xFFF57C00),
    shadow: Color(0x0D000000),
  );

  static const dark = AppColors(
    background: Color(0xFF121214),
    surface: Color(0xFF1E1E22),
    surfaceAlt: Color(0xFF2A2A30),
    border: Color(0xFF34343A),
    divider: Color(0xFF34343A),
    textPrimary: Color(0xFFF2F2F7),
    textSecondary: Color(0xFFC7C7CC),
    textMuted: Color(0xFF98989F),
    textDisabled: Color(0xFF6C6C73),
    accent: Color(0xFFFF6B6B),
    breakTime: Color(0xFF7986CB),
    info: Color(0xFF6FA4FF),
    danger: Color(0xFFEF5350),
    success: Color(0xFF3DDC84),
    warning: Color(0xFFFFA726),
    shadow: Color(0x4D000000),
  );

  @override
  AppColors copyWith({
    Color? background,
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
