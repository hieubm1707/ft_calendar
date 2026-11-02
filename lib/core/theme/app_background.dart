import 'package:flutter/material.dart';

import 'app_colors_context.dart';

/// Nền gradient pastel của app (theo chế độ Sáng/Tối đang chọn).
///
/// `AppTheme` tự đặt nó dưới mọi route qua hiệu ứng chuyển trang; chỉ cần dùng
/// trực tiếp cho route tự dựng không qua `PageTransitionsTheme` (vd. PageRouteBuilder).
class AppBackground extends StatelessWidget {
  final Widget child;

  const AppBackground({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(gradient: context.colors.backgroundGradient),
      child: child,
    );
  }
}
