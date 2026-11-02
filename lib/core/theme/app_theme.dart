import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'app_background.dart';
import 'app_colors.dart';
import 'app_fonts.dart';

/// Dựng `ThemeData` Sáng/Tối từ bảng màu [AppColors]. Các mặc định ở đây (AppBar,
/// NavigationBar, sheet, dialog, ô nhập…) giúp trang không phải tự tô màu nền.
///
/// Nền gradient: Scaffold trong suốt, còn mỗi route tự mang gradient của mình
/// (bọc trong hiệu ứng chuyển trang) → trang trượt vào đã có nền đặc, không lộ
/// trang cũ phía sau.
class AppTheme {
  const AppTheme._();

  static ThemeData light() => _build(AppColors.light, Brightness.light);

  static ThemeData dark() => _build(AppColors.dark, Brightness.dark);

  /// Bo góc chung: thẻ/sheet/dialog bo lớn, ô nhập/chip bo vừa.
  static const _radiusLarge = 24.0;
  static const _radiusMedium = 16.0;

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
      fontFamily: AppFonts.primary,
      brightness: brightness,
      colorScheme: scheme,
      scaffoldBackgroundColor: Colors.transparent,
      canvasColor: c.background,
      dividerColor: c.divider,
      pageTransitionsTheme: const PageTransitionsTheme(
        builders: {
          TargetPlatform.android: _BackgroundTransitionsBuilder(
            ZoomPageTransitionsBuilder(),
          ),
          TargetPlatform.iOS: _BackgroundTransitionsBuilder(
            CupertinoPageTransitionsBuilder(),
          ),
          TargetPlatform.macOS: _BackgroundTransitionsBuilder(
            CupertinoPageTransitionsBuilder(),
          ),
          TargetPlatform.windows: _BackgroundTransitionsBuilder(
            ZoomPageTransitionsBuilder(),
          ),
          TargetPlatform.linux: _BackgroundTransitionsBuilder(
            ZoomPageTransitionsBuilder(),
          ),
        },
      ),
      appBarTheme: AppBarTheme(
        // Trong suốt: tiêu đề nằm thẳng trên nền gradient như thiết kế.
        backgroundColor: Colors.transparent,
        surfaceTintColor: Colors.transparent,
        foregroundColor: c.textPrimary,
        elevation: 0,
        scrolledUnderElevation: 0,
        // Thanh trạng thái trong suốt để gradient lấp lên tận mép trên.
        systemOverlayStyle: (isDark
                ? SystemUiOverlayStyle.light
                : SystemUiOverlayStyle.dark)
            .copyWith(statusBarColor: Colors.transparent),
        iconTheme: IconThemeData(color: c.textPrimary),
        actionsIconTheme: IconThemeData(color: c.textPrimary),
        titleTextStyle: TextStyle(
          color: c.textPrimary,
          fontSize: 20,
          fontWeight: FontWeight.w700,
        ),
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: c.surface,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        shadowColor: c.shadow,
        indicatorColor: Colors.transparent,
        iconTheme: WidgetStateProperty.resolveWith(
          (s) => IconThemeData(
            color: s.contains(WidgetState.selected) ? c.accent : c.textMuted,
          ),
        ),
        labelTextStyle: WidgetStateProperty.resolveWith(
          (s) => TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: s.contains(WidgetState.selected) ? c.accent : c.textMuted,
          ),
        ),
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: c.accent,
        foregroundColor: Colors.white,
        elevation: 6,
        highlightElevation: 8,
        shape: const CircleBorder(),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(_radiusMedium),
          ),
        ),
      ),
      cardTheme: CardThemeData(
        color: c.surface,
        surfaceTintColor: Colors.transparent,
        shadowColor: c.shadow,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(_radiusLarge),
        ),
      ),
      bottomSheetTheme: BottomSheetThemeData(
        backgroundColor: c.surface,
        surfaceTintColor: Colors.transparent,
        modalBackgroundColor: c.surface,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(_radiusLarge + 4),
          ),
        ),
      ),
      dialogTheme: DialogThemeData(
        backgroundColor: c.surface,
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(_radiusLarge + 4),
        ),
      ),
      popupMenuTheme: PopupMenuThemeData(
        color: c.surface,
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(_radiusMedium),
        ),
      ),
      chipTheme: ChipThemeData(
        backgroundColor: c.surface,
        selectedColor: c.surfaceAlt,
        side: BorderSide(color: c.border),
        labelStyle: TextStyle(color: c.textPrimary),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      snackBarTheme: SnackBarThemeData(
        backgroundColor: isDark ? c.surfaceAlt : c.textPrimary,
        contentTextStyle: TextStyle(color: isDark ? c.textPrimary : c.surface),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(_radiusMedium),
        ),
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

/// Bọc hiệu ứng chuyển trang mặc định: thêm nền gradient [AppBackground] dưới
/// nội dung route, để Scaffold trong suốt vẫn có nền riêng khi trượt vào.
class _BackgroundTransitionsBuilder extends PageTransitionsBuilder {
  final PageTransitionsBuilder _inner;

  const _BackgroundTransitionsBuilder(this._inner);

  @override
  Widget buildTransitions<T>(
    PageRoute<T> route,
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    return _inner.buildTransitions(
      route,
      context,
      animation,
      secondaryAnimation,
      AppBackground(child: child),
    );
  }
}
