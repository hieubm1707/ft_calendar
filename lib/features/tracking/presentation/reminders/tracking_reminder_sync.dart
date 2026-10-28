import 'package:flutter/widgets.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/notifications/index.dart';
import '../../../../core/usecase/index.dart';
import '../../domain/index.dart';
import '../widgets/tracking_format.dart';

/// Đặt lại thông báo theo bộ nhắc Tracking (giờ + điều kiện % hoàn thành).
///
/// Thông báo cục bộ không tự xét điều kiện lúc nổ → mỗi lần dữ liệu có thể đổi
/// (mở app, app ra/vào nền, check-in, sửa mục tiêu, sửa bộ nhắc) thì huỷ hết rồi
/// đặt lại theo [planTrackingReminders]: hôm nay chỉ đặt luật đang thoả, các ngày
/// sau tính theo 0 lượt. Ra nền cũng đồng bộ vì check-in bên trang Tasks không
/// báo về đây.
@lazySingleton
class TrackingReminderSync with WidgetsBindingObserver {
  final GetTrackingOverview _getOverview;
  final GetTrackingReminderRules _getRules;
  final NotificationService _notifications;

  TrackingReminderSync(this._getOverview, this._getRules, this._notifications);

  /// Số ngày lên lịch trước (kể cả hôm nay) — không mở app quá chừng ấy ngày
  /// thì hết nhắc.
  static const lookaheadDays = 7;

  // Id thông báo: _base + ngày*20 + thứ-tự-luật (≤ 8 luật × 7 ngày).
  static const _base = 600000000;
  static const _range = 1000;

  // Nhắc riêng từng mục tiêu (TrackingCubit) — đang ẩn nên dọn nhắc cũ còn sót.
  static const _goalReminderBase = 500000000;

  bool _observing = false;
  Future<void>? _running;
  bool _dirty = false;

  /// Gọi 1 lần sau frame đầu: đồng bộ ngay + theo dõi vòng đời app.
  void start() {
    if (!_observing) {
      WidgetsBinding.instance.addObserver(this);
      _observing = true;
    }
    sync();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed ||
        state == AppLifecycleState.paused) {
      sync();
    }
  }

  /// Gọi dồn dập vẫn an toàn: đang chạy thì đánh dấu chạy lại 1 lượt sau đó.
  Future<void> sync() {
    final running = _running;
    if (running != null) {
      _dirty = true;
      return running;
    }
    return _running = _loop().whenComplete(() => _running = null);
  }

  Future<void> _loop() async {
    do {
      _dirty = false;
      await _syncOnce();
    } while (_dirty);
  }

  Future<void> _syncOnce() async {
    final overview = (await _getOverview(const NoParams())).toOption();
    final rules = (await _getRules(const NoParams())).toOption();
    // Đọc lỗi thì giữ nguyên lịch cũ, lần đồng bộ sau sẽ thử lại.
    if (overview.isNone() || rules.isNone()) return;
    final o = overview.toNullable()!;

    final plan = planTrackingReminders(
      rules: rules.toNullable()!,
      goals: o.goals,
      doneKeys: trackingDoneKeys(o.checkins),
      now: DateTime.now(),
      days: lookaheadDays,
    );

    // Plugin có thể ném lỗi (vd. Android không cho đặt báo thức chính xác) —
    // nhắc là phụ, không được làm hỏng luồng chính.
    try {
      final stale = (await _notifications.pendingIds()).where(
        (id) =>
            (id >= _base && id < _base + _range) ||
            (!kShowGoalReminders && id >= _goalReminderBase && id < _base),
      );
      await _notifications.cancelMany(stale);
      for (final p in plan) {
        await _notifications.scheduleOnce(
          id: _base + p.dayIndex * 20 + p.ruleIndex,
          title: 'Nhắc mục tiêu',
          body: _body(p),
          when: p.when,
        );
      }
    } catch (e) {
      debugPrint('TrackingReminderSync: $e');
    }
  }

  String _body(PlannedTrackingReminder p) => p.done == 0
      ? 'Bạn chưa hoàn thành mục tiêu nào hôm nay (0/${p.total}).'
      : 'Mới hoàn thành ${p.percent}% mục tiêu hôm nay '
            '(${p.done}/${p.total}) — cố lên!';
}
