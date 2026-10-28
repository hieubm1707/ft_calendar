import 'package:equatable/equatable.dart';

/// Điều kiện nhắc: tỉ lệ hoàn thành trong ngày nhỏ hơn / bằng [TrackingReminderRule.percent].
enum ReminderComparison { lessThan, equals }

/// Luật nhắc chung cho trang Tracking: tới [minutes] (phút từ 0h) mà tỉ lệ
/// mục tiêu đã hoàn thành trong ngày thoả điều kiện thì gửi thông báo.
class TrackingReminderRule extends Equatable {
  final int minutes;
  final ReminderComparison comparison;

  /// 0..100.
  final int percent;
  final bool enabled;

  const TrackingReminderRule({
    required this.minutes,
    this.comparison = ReminderComparison.lessThan,
    required this.percent,
    this.enabled = true,
  });

  /// Số luật tối đa (giới hạn số thông báo chờ — iOS chỉ giữ 64).
  static const maxRules = 8;

  /// Bộ nhắc mặc định khi người dùng chưa tuỳ chỉnh.
  static const defaults = [
    TrackingReminderRule(minutes: 20 * 60, percent: 50),
    TrackingReminderRule(minutes: 21 * 60, percent: 65),
    TrackingReminderRule(minutes: 22 * 60, percent: 80),
    TrackingReminderRule(minutes: 23 * 60, percent: 80),
  ];

  /// Có thoả điều kiện khi đã xong [done]/[total] mục tiêu không.
  /// "<" so chính xác theo tỉ lệ; "=" so theo % đã làm tròn.
  bool matches({required int done, required int total}) {
    if (total <= 0) return false;
    return switch (comparison) {
      ReminderComparison.lessThan => done * 100 < percent * total,
      ReminderComparison.equals => (done * 100 / total).round() == percent,
    };
  }

  TrackingReminderRule copyWith({
    int? minutes,
    ReminderComparison? comparison,
    int? percent,
    bool? enabled,
  }) => TrackingReminderRule(
    minutes: minutes ?? this.minutes,
    comparison: comparison ?? this.comparison,
    percent: percent ?? this.percent,
    enabled: enabled ?? this.enabled,
  );

  @override
  List<Object?> get props => [minutes, comparison, percent, enabled];
}
