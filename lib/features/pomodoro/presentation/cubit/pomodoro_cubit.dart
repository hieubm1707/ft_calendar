import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/notifications/index.dart';
import '../../../tasks/domain/index.dart';
import '../../domain/index.dart';

part 'pomodoro_state.dart';

/// Đồng hồ pomodoro: focus → nghỉ ngắn → ... → nghỉ dài.
/// Mỗi phiên FOCUS kết thúc (hoặc dừng sớm ≥ 1 phút) được lưu để làm report.
///
/// Singleton: đồng hồ phải sống độc lập với trang đang mở — đổi tab, ẩn cửa sổ
/// (macOS chạy tiếp ở menu bar) đều không được reset phiên đang chạy.
@lazySingleton
class PomodoroCubit extends Cubit<PomodoroState> {
  final SavePomodoroSession _saveSession;
  final GetPomodoroSessions _getSessions;
  final GetTaskInstances _getTaskInstances;
  final NotificationService _notifications;

  PomodoroCubit(
    this._saveSession,
    this._getSessions,
    this._getTaskInstances,
    this._notifications,
  ) : super(const PomodoroState());

  /// Id thông báo riêng cho pomodoro (tránh đụng id nhắc sự kiện).
  static const _notificationId = 900001;

  /// Phiên dừng sớm ngắn hơn mốc này thì không lưu.
  static const _minSavedSeconds = 60;

  Timer? _ticker;

  /// Mốc kết thúc theo đồng hồ thật — chính xác kể cả khi app bị treo/ngủ.
  DateTime? _deadline;

  /// Thời điểm bắt đầu phiên focus hiện tại.
  DateTime? _phaseStartedAt;

  /// Nạp thống kê hôm nay + danh sách task hôm nay (để chọn việc tập trung).
  Future<void> load() async {
    await Future.wait([_loadTodayStats(), _loadTodayTasks()]);
  }

  // ── Điều khiển đồng hồ ────────────────────────────────────────────────

  void start() {
    if (state.isRunning || state.remainingSeconds <= 0) return;
    _phaseStartedAt ??= DateTime.now();
    _deadline = DateTime.now().add(Duration(seconds: state.remainingSeconds));
    emit(state.copyWith(runStatus: PomodoroRunStatus.running));
    _startTicker();
  }

  void pause() {
    if (!state.isRunning) return;
    _stopTicker();
    emit(state.copyWith(
      runStatus: PomodoroRunStatus.paused,
      remainingSeconds: _remainingFromDeadline(),
    ));
  }

  /// Dừng hẳn giai đoạn hiện tại, quay về đầu giai đoạn.
  /// Phiên focus đã chạy ≥ 1 phút vẫn được ghi nhận (completed = false).
  Future<void> stop() async {
    final elapsed = _currentElapsed();
    _stopTicker();
    _deadline = null;

    if (state.isFocus && elapsed >= _minSavedSeconds) {
      await _persistSession(focusSeconds: elapsed, completed: false);
    }
    _phaseStartedAt = null;
    emit(state.copyWith(
      runStatus: PomodoroRunStatus.idle,
      remainingSeconds: _phaseSeconds(state.phase),
      totalSeconds: _phaseSeconds(state.phase),
    ));
  }

  /// Bỏ qua giai đoạn hiện tại, sang giai đoạn kế.
  Future<void> skip() async {
    final elapsed = _currentElapsed();
    _stopTicker();
    _deadline = null;

    if (state.isFocus && elapsed >= _minSavedSeconds) {
      await _persistSession(focusSeconds: elapsed, completed: false);
    }
    _phaseStartedAt = null;
    // Bỏ qua giữa chừng không tính là hoàn thành 1 vòng.
    _goToPhase(_nextPhase(countCurrentFocus: false));
  }

  // ── Cài đặt & mục tiêu ────────────────────────────────────────────────

  /// Đổi độ dài phiên focus (chỉ khi đang không chạy).
  void setFocusMinutes(int minutes) {
    if (!state.isIdle || minutes <= 0) return;
    final seconds = minutes * 60;
    emit(state.copyWith(
      focusMinutes: minutes,
      remainingSeconds: state.isFocus ? seconds : state.remainingSeconds,
      totalSeconds: state.isFocus ? seconds : state.totalSeconds,
    ));
  }

  void setBreakMinutes({int? short, int? long}) {
    if (!state.isIdle) return;
    final next = state.copyWith(
      shortBreakMinutes: short,
      longBreakMinutes: long,
    );
    final seconds = _phaseSecondsOf(next, next.phase);
    emit(next.copyWith(
      remainingSeconds: next.isFocus ? next.remainingSeconds : seconds,
      totalSeconds: next.isFocus ? next.totalSeconds : seconds,
    ));
  }

  /// Chọn việc cần tập trung. [taskScheduleId] null = nhãn tự nhập.
  void setTarget({String? label, int? taskScheduleId}) {
    final trimmed = label?.trim();
    if (trimmed == null || trimmed.isEmpty) {
      emit(state.copyWith(clearTarget: true));
      return;
    }
    emit(state.copyWith(label: trimmed, taskScheduleId: taskScheduleId));
  }

  // ── Nội bộ ────────────────────────────────────────────────────────────

  void _startTicker() {
    _ticker?.cancel();
    _ticker = Timer.periodic(const Duration(seconds: 1), (_) => _tick());
  }

  void _stopTicker() {
    _ticker?.cancel();
    _ticker = null;
  }

  void _tick() {
    if (isClosed) return;
    final remaining = _remainingFromDeadline();
    if (remaining > 0) {
      emit(state.copyWith(remainingSeconds: remaining));
      return;
    }
    _stopTicker();
    _deadline = null;
    unawaited(_completePhase());
  }

  int _remainingFromDeadline() {
    final deadline = _deadline;
    if (deadline == null) return state.remainingSeconds;
    final ms = deadline.difference(DateTime.now()).inMilliseconds;
    return ms <= 0 ? 0 : (ms / 1000).ceil();
  }

  int _currentElapsed() {
    final remaining =
        state.isRunning ? _remainingFromDeadline() : state.remainingSeconds;
    return (state.totalSeconds - remaining).clamp(0, state.totalSeconds);
  }

  /// Giai đoạn chạy hết giờ: lưu phiên focus, báo cho người dùng, sang giai đoạn kế.
  Future<void> _completePhase() async {
    final wasFocus = state.isFocus;
    if (wasFocus) {
      await _persistSession(
        focusSeconds: state.totalSeconds,
        completed: true,
      );
    }
    _phaseStartedAt = null;

    final next = _nextPhase(countCurrentFocus: wasFocus);
    _goToPhase(
      next,
      completedRounds:
          wasFocus ? state.completedRounds + 1 : state.completedRounds,
    );
    await _notify(finishedFocus: wasFocus, next: next);
  }

  PomodoroPhase _nextPhase({required bool countCurrentFocus}) {
    if (!state.isFocus) return PomodoroPhase.focus;
    final rounds =
        countCurrentFocus ? state.completedRounds + 1 : state.completedRounds;
    final needLong =
        countCurrentFocus && rounds % state.roundsBeforeLongBreak == 0;
    return needLong ? PomodoroPhase.longBreak : PomodoroPhase.shortBreak;
  }

  void _goToPhase(PomodoroPhase phase, {int? completedRounds}) {
    final seconds = _phaseSeconds(phase);
    emit(state.copyWith(
      phase: phase,
      runStatus: PomodoroRunStatus.idle,
      remainingSeconds: seconds,
      totalSeconds: seconds,
      completedRounds: completedRounds,
    ));
  }

  int _phaseSeconds(PomodoroPhase phase) => _phaseSecondsOf(state, phase);

  int _phaseSecondsOf(PomodoroState s, PomodoroPhase phase) {
    switch (phase) {
      case PomodoroPhase.focus:
        return s.focusMinutes * 60;
      case PomodoroPhase.shortBreak:
        return s.shortBreakMinutes * 60;
      case PomodoroPhase.longBreak:
        return s.longBreakMinutes * 60;
    }
  }

  Future<void> _persistSession({
    required int focusSeconds,
    required bool completed,
    DateTime? endedAt,
  }) async {
    final end = endedAt ?? DateTime.now();
    final session = PomodoroSession(
      startedAt:
          _phaseStartedAt ?? end.subtract(Duration(seconds: focusSeconds)),
      endedAt: end,
      focusSeconds: focusSeconds,
      plannedSeconds: state.totalSeconds,
      completed: completed,
      label: state.label,
      taskScheduleId: state.taskScheduleId,
    );

    final result = await _saveSession(session);
    if (isClosed) return;
    await result.fold(
      (failure) async => emit(state.copyWith(errorMessage: failure.message)),
      (_) async => _loadTodayStats(),
    );
  }

  Future<void> _loadTodayStats() async {
    final now = DateTime.now();
    final from = DateTime(now.year, now.month, now.day);
    final to = from.add(const Duration(days: 1));

    final result =
        await _getSessions(GetPomodoroSessionsParams(from: from, to: to));
    if (isClosed) return;
    result.fold(
      (failure) => emit(state.copyWith(errorMessage: failure.message)),
      (sessions) => emit(state.copyWith(
        todaySessions: sessions.length,
        todayFocusSeconds: sessions.fold<int>(0, (sum, s) => sum + s.focusSeconds),
      )),
    );
  }

  Future<void> _loadTodayTasks() async {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    final result =
        await _getTaskInstances(GetTaskInstancesParams(from: today, to: today));
    if (isClosed) return;
    result.fold(
      (failure) => emit(state.copyWith(errorMessage: failure.message)),
      (tasks) => emit(state.copyWith(todayTasks: tasks)),
    );
  }

  Future<void> _notify({
    required bool finishedFocus,
    required PomodoroPhase next,
  }) async {
    final title = finishedFocus ? 'Hết giờ tập trung 🎉' : 'Hết giờ nghỉ';
    final body = finishedFocus
        ? (next == PomodoroPhase.longBreak
            ? 'Nghỉ dài ${state.longBreakMinutes} phút nhé.'
            : 'Nghỉ ngắn ${state.shortBreakMinutes} phút nhé.')
        : 'Bắt đầu phiên tập trung ${state.focusMinutes} phút.';
    try {
      await _notifications.showNow(
          id: _notificationId, title: title, body: body);
    } catch (_) {
      // Best-effort: thiếu quyền thông báo không được làm hỏng đồng hồ.
    }
  }

  @override
  Future<void> close() {
    _stopTicker();
    return super.close();
  }
}
