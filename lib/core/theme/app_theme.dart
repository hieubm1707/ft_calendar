import 'package:flutter/material.dart';

import 'app_colors.dart';

/// Dựng `ThemeData` Sáng/Tối từ bảng màu [AppColors]. Các mặc định ở đây (AppBar,
/// NavigationBar, sheet, dialog, ô nhập…) giúp trang không phải tự tô màu nền.
class AppTheme {
  const AppTheme._();

  static ThemeData light() => _build(AppColors.light, Brightness.light);

  static ThemeData dark() => _build(AppColors.dark, Brightness.dark);

  static ThemeData _build(AppColors c, Brightness brightness) {
    final isDark = brightness == Brightness.dark;
    final scheme = ColorScheme.fromSeed(
      seedColor: c.accent,
      brightness: brightness,
    ).copyWith(
      // Ghim đúng màu thương hiệu (seed tự sinh ra tông khác) + chữ trắng trên
      // nút đặc ở cả 2 chế độ → mọi tính năng cùng một màu nhấn.
      primary: c.accent,
      onPrimary: Colors.white,
      surface: c.surface,
      onSurface: c.textPrimary,
      onSurfaceVariant: c.textMuted,
      outline: c.border,
      outlineVariant: c.divider,
      error: c.danger,
    );
    return ThemeData(
      useMaterial3: true,
      brightness: brightness,
      colorScheme: scheme,
      scaffoldBackgroundColor: c.background,
      dividerColor: c.divider,
      appBarTheme: AppBarTheme(
        backgroundColor: c.surface,
        surfaceTintColor: c.surface,
        foregroundColor: c.textPrimary,
        elevation: 0.5,
        scrolledUnderElevation: 0.5,
        iconTheme: IconThemeData(color: c.textPrimary),
        actionsIconTheme: IconThemeData(color: c.textPrimary),
        titleTextStyle: TextStyle(
          color: c.textPrimary,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: c.surface,
        surfaceTintColor: c.surface,
        indicatorColor: c.accent.withValues(alpha: 0.15),
        iconTheme: WidgetStateProperty.resolveWith(
          (s) => IconThemeData(
            color: s.contains(WidgetState.selected) ? c.accent : c.textMuted,
          ),
        ),
        labelTextStyle: WidgetStateProperty.resolveWith(
          (s) => TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: s.contains(WidgetState.selected)
                ? c.textPrimary
                : c.textMuted,
          ),
        ),
      ),
      cardTheme: CardThemeData(
        color: c.surface,
        surfaceTintColor: c.surface,
      ),
      bottomSheetTheme: BottomSheetThemeData(
        backgroundColor: c.surface,
        surfaceTintColor: c.surface,
        modalBackgroundColor: c.surface,
      ),
      dialogTheme: DialogThemeData(
        backgroundColor: c.surface,
        surfaceTintColor: c.surface,
      ),
      popupMenuTheme: PopupMenuThemeData(
        color: c.surface,
        surfaceTintColor: c.surface,
      ),
      snackBarTheme: SnackBarThemeData(
        backgroundColor: isDark
            ? c.surfaceAlt
            : const Color(0xFF323232),
        contentTextStyle: const TextStyle(color: Colors.white),
      ),
      inputDecorationTheme: InputDecorationTheme(
        fillColor: c.surfaceAlt,
        hintStyle: TextStyle(color: c.textMuted),
      ),
      dividerTheme: DividerThemeData(color: c.divider, space: 1),
      listTileTheme: ListTileThemeData(
        iconColor: c.textSecondary,
        textColor: c.textPrimary,
      ),
      extensions: [c],
    );
  }
}
