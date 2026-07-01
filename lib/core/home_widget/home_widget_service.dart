import 'package:flutter/material.dart';
import 'package:home_widget/home_widget.dart';
import 'package:injectable/injectable.dart';

import '../domain/index.dart';
import 'widget_calendar_view.dart';

/// Render UI lịch (Dart) ra ảnh và đẩy cho native widget (home/lock screen).
/// Dùng EventRepository ở core/domain để không phụ thuộc feature.
@lazySingleton
class HomeWidgetService {
  final EventRepository _repository;

  HomeWidgetService(this._repository);

  static const _appGroupId = 'group.com.example.exampleApp';
  static const _iOSWidgetName = 'CalendarWidget';
  static const _androidProvider =
      'com.example.example_app.CalendarWidgetProvider';

  Future<void> init() async {
    await HomeWidget.setAppGroupId(_appGroupId);
  }

  /// Render lại cả 3 cỡ rồi yêu cầu native cập nhật. Best-effort (nuốt lỗi).
  Future<void> refreshAll() async {
    final today = DateTime.now();
    try {
      await _render(WidgetMode.week, today, _WidgetSpec(const Size(360, 200)));
      await _render(
          WidgetMode.twoWeeks, today, _WidgetSpec(const Size(360, 300)));
      await _render(WidgetMode.month, today, _WidgetSpec(const Size(360, 430)));
      await HomeWidget.updateWidget(
        iOSName: _iOSWidgetName,
        qualifiedAndroidName: _androidProvider,
      );
    } catch (e, st) {
      // Widget là phụ trợ — lỗi render/update không được làm sập app.
      debugPrint('HomeWidgetService.refreshAll error: $e\n$st');
    }
  }

  Future<void> _render(WidgetMode mode, DateTime today, _WidgetSpec spec) async {
    final (from, to) = _rangeFor(mode, today);
    final result = await _repository.getScheduledEvents(from: from, to: to);
    final events = result.fold((_) => <Event>[], (list) => list);

    await HomeWidget.renderFlutterWidget(
      WidgetCalendarView(
          mode: mode, today: today, events: events, size: spec.size),
      key: 'cal_${mode.name}',
      logicalSize: spec.size,
    );
  }

  (DateTime, DateTime) _rangeFor(WidgetMode mode, DateTime today) {
    final d = DateTime(today.year, today.month, today.day);
    final startOfWeek = d.subtract(Duration(days: d.weekday - 1));
    switch (mode) {
      case WidgetMode.week:
        return (startOfWeek, startOfWeek.add(const Duration(days: 7)));
      case WidgetMode.twoWeeks:
        return (startOfWeek, startOfWeek.add(const Duration(days: 14)));
      case WidgetMode.month:
        final first = DateTime(today.year, today.month, 1);
        final last = DateTime(today.year, today.month,
            DateUtils.getDaysInMonth(today.year, today.month), 23, 59, 59);
        return (first, last);
    }
  }
}

class _WidgetSpec {
  final Size size;
  const _WidgetSpec(this.size);
}
