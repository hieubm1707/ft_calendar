import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/error/index.dart';
import '../../../../core/notifications/index.dart';
import '../../../../core/usecase/index.dart';
import '../../domain/index.dart';
import '../reminders/tracking_reminder_sync.dart';
import '../widgets/tracking_format.dart';

part 'tracking_state.dart';

DateTime _today() {
  final n = DateTime.now();
  return DateTime(n.year, n.month, n.day);
}

/// Trang Tracking: mục tiêu + lượt hoàn thành + ngày đang xem. Mỗi thay đổi
/// gọi [TrackingReminderSync] để đặt lại bộ nhắc theo % hoàn thành.
@injectable
class TrackingCubit extends Cubit<TrackingState> {
  final GetTrackingOverview _getOverview;
  final SaveTrackingGoal _saveGoal;
  final DeleteTrackingGoal _deleteGoal;
  final SetTrackingCheckin _setCheckin;
  final NotificationService _notifications;
  final TrackingReminderSync _reminderSync;

  TrackingCubit(
    this._getOverview,
    this._saveGoal,
    this._deleteGoal,
    this._setCheckin,
    this._notifications,
    this._reminderSync,
  ) : super(TrackingState(selectedDay: _today()));

  Future<void> load() async {
    emit(state.copyWith(status: TrackingStatus.loading));
    final result = await _getOverview(const NoParams());
    result.fold(
      (failure) => emit(
        state.copyWith(
          status: TrackingStatus.failure,
          errorMessage: failure.message,
        ),
      ),
      (overview) {
        emit(
          state.copyWith(
            status: TrackingStatus.success,
            goals: overview.goals,
            checkins: overview.checkins,
            doneKeys: trackingDoneKeys(overview.checkins),
          ),
        );
        if (kShowGoalReminders) _cancelEndedReminders(overview.goals);
      },
    );
  }

  /// Chỉ xem được hôm nay và quá khứ — ngày tương lai chưa thể hoàn thành.
  void selectDay(DateTime day) {
    final d = DateTime(day.year, day.month, day.day);
    if (d.isAfter(_today())) return;
    emit(state.copyWith(selectedDay: d));
  }

  /// Đánh dấu/bỏ hoàn thành [goal] HÔM NAY. Ngày quá khứ chỉ để xem.
  Future<void> toggleToday(TrackingGoal goal) async {
    final today = _today();
    if (!goal.isDueOn(today)) return;
    await _mutate(
      _setCheckin(
        SetTrackingCheckinParams(
          goal: goal,
          date: today,
          done: !state.isDone(goal, today),
        ),
      ),
    );
  }

  Future<void> saveGoal(TrackingGoal goal) async {
    final result = await _saveGoal(goal);
    await result.fold(
      (failure) async => emit(
        state.copyWith(
          status: TrackingStatus.failure,
          errorMessage: failure.message,
        ),
      ),
      (id) async {
        if (kShowGoalReminders) {
          await _rescheduleReminders(goal.copyWith(id: id));
        }
        await load();
        _reminderSync.sync();
      },
    );
  }

  Future<void> deleteGoal(TrackingGoal goal) async {
    final id = goal.id;
    if (id == null || goal.isFromTask) return;
    await _notifications.cancelMany(_reminderIds(id));
    await _mutate(_deleteGoal(id));
  }

  Future<void> _mutate(Future<Either<Failure, Unit>> op) async {
    final result = await op;
    await result.fold(
      (failure) async => emit(
        state.copyWith(
          status: TrackingStatus.failure,
          errorMessage: failure.message,
        ),
      ),
      (_) async {
        await load();
        // Tỉ lệ hoàn thành đổi → đặt lại bộ nhắc theo %.
        _reminderSync.sync();
      },
    );
  }

  // ---- Nhắc riêng từng mục tiêu (đang ẩn — xem kShowGoalReminders) -------
  // Id thông báo: 500000000 + goalId*100 + thứ-tự-giờ*8 + thứ (0 = hằng ngày).
  // Tối đa [TrackingGoal.maxReminders] giờ × 8 = 40 < 100 → không đụng mục tiêu khác.

  static const _reminderBase = 500000000;

  static int _reminderId(int goalId, int index, int weekday) =>
      _reminderBase + goalId * 100 + index * 8 + weekday;

  static Iterable<int> _reminderIds(int goalId) => [
    for (var i = 0; i < TrackingGoal.maxReminders; i++)
      for (var w = 0; w <= 7; w++) _reminderId(goalId, i, w),
  ];

  bool _ended(TrackingGoal goal) =>
      goal.endDate != null && goal.endDate!.isBefore(_today());

  Future<void> _rescheduleReminders(TrackingGoal goal) async {
    final id = goal.id;
    if (id == null || goal.isFromTask) return;
    await _notifications.cancelMany(_reminderIds(id));
    if (_ended(goal)) return;

    final daily = goal.frequency == TrackingFrequency.daily;
    for (var i = 0; i < goal.reminders.length; i++) {
      final weekdays = daily ? const [0] : goal.activeWeekdays;
      for (final w in weekdays) {
        await _notifications.scheduleRepeatingReminder(
          id: _reminderId(id, i, w),
          title: 'Nhắc mục tiêu',
          body: goal.name,
          minutes: goal.reminders[i],
          weekday: w == 0 ? null : w,
          notBefore: goal.startDate,
        );
      }
    }
  }

  /// Nhắc lặp không tự dừng ở ngày kết thúc → mỗi lần mở trang huỷ giùm.
  Future<void> _cancelEndedReminders(List<TrackingGoal> goals) async {
    for (final g in goals) {
      if (!g.isFromTask &&
          g.id != null &&
          g.reminders.isNotEmpty &&
          _ended(g)) {
        await _notifications.cancelMany(_reminderIds(g.id!));
      }
    }
  }
}
