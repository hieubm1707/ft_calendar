/// Font của app, khai báo ở `pubspec.yaml`.
class AppFonts {
  const AppFonts._();

  /// Font chung, đặt sẵn trong `AppTheme`: trang không cần tự set.
  static const primary = 'BeVietnamPro';

  /// Số đều, chỉ có độ đậm w800. Dùng cho đồng hồ và số liệu thay đổi liên tục.
  /// Be Vietnam Pro không có `tnum` nên `FontFeature.tabularFigures()` không có
  /// tác dụng với [primary].
  static const tabular = 'BeVietnamProTabular';
}
