part of 'pomodoro_cubit.dart';

/// Giai đoạn của chu kỳ pomodoro.
enum PomodoroPhase { focus, shortBreak, longBreak }

/// Trạng thái đồng hồ.
enum PomodoroRunStatus { idle, running, paused }

class PomodoroState extends Equatable {
  final PomodoroPhase phase;
  final PomodoroRunStatus runStatus;

  /// Số giây còn lại của giai đoạn hiện tại.
  final int remainingSeconds;

  /// Độ dài giai đoạn hiện tại (giây).
  final int totalSeconds;

  /// Cài đặt độ dài (phút).
  final int focusMinutes;
  final int shortBreakMinutes;
  final int longBreakMinutes;

  /// Số phiên focus trước khi được nghỉ dài.
  final int roundsBeforeLongBreak;

  /// Số phiên focus đã xong trong chu kỳ hiện tại.
  final int completedRounds;

  /// Việc đang tập trung (null = chưa chọn).
  final String? label;
  final int? taskScheduleId;

  /// Tag đang chọn (null = chưa chọn tag).
  final int? focusTagId;

  /// Tag tập trung có sẵn để chọn nhanh.
  final List<FocusTag> tags;

  /// Thống kê nhanh của hôm nay.
  final int todayFocusSeconds;
  final int todaySessions;

  /// Task hôm nay (để chọn việc cần tập trung).
  final List<TaskInstance> todayTasks;

  final String? errorMessage;

  const PomodoroState({
    this.phase = PomodoroPhase.focus,
    this.runStatus = PomodoroRunStatus.idle,
    this.remainingSeconds = 25 * 60,
    this.totalSeconds = 25 * 60,
    this.focusMinutes = 25,
    this.shortBreakMinutes = 5,
    this.longBreakMinutes = 15,
    this.roundsBeforeLongBreak = 4,
    this.completedRounds = 0,
    this.label,
    this.taskScheduleId,
    this.focusTagId,
    this.tags = const [],
    this.todayFocusSeconds = 0,
    this.todaySessions = 0,
    this.todayTasks = const [],
    this.errorMessage,
  });

  /// Tag đang chọn (null nếu chưa chọn hoặc tag đã bị xoá).
  FocusTag? get selectedTag {
    for (final t in tags) {
      if (t.id != null && t.id == focusTagId) return t;
    }
    return null;
  }

  bool get isFocus => phase == PomodoroPhase.focus;
  bool get isRunning => runStatus == PomodoroRunStatus.running;
  bool get isIdle => runStatus == PomodoroRunStatus.idle;

  /// Số giây đã trôi qua của giai đoạn hiện tại.
  int get elapsedSeconds => totalSeconds - remainingSeconds;

  /// Tiến độ 0..1 của giai đoạn hiện tại.
  double get progress =>
      totalSeconds == 0 ? 0 : (elapsedSeconds / totalSeconds).clamp(0.0, 1.0);

  /// mm:ss
  String get remainingLabel {
    final m = (remainingSeconds ~/ 60).toString().padLeft(2, '0');
    final s = (remainingSeconds % 60).toString().padLeft(2, '0');
    return '$m:$s';
  }

  PomodoroState copyWith({
    PomodoroPhase? phase,
    PomodoroRunStatus? runStatus,
    int? remainingSeconds,
    int? totalSeconds,
    int? focusMinutes,
    int? shortBreakMinutes,
    int? longBreakMinutes,
    int? roundsBeforeLongBreak,
    int? completedRounds,
    String? label,
    int? taskScheduleId,
    int? focusTagId,
    List<FocusTag>? tags,
    bool clearTarget = false,
    bool clearTaskScheduleId = false,
    bool clearFocusTagId = false,
    int? todayFocusSeconds,
    int? todaySessions,
    List<TaskInstance>? todayTasks,
    String? errorMessage,
  }) {
    return PomodoroState(
      phase: phase ?? this.phase,
      runStatus: runStatus ?? this.runStatus,
      remainingSeconds: remainingSeconds ?? this.remainingSeconds,
      totalSeconds: totalSeconds ?? this.totalSeconds,
      focusMinutes: focusMinutes ?? this.focusMinutes,
      shortBreakMinutes: shortBreakMinutes ?? this.shortBreakMinutes,
      longBreakMinutes: longBreakMinutes ?? this.longBreakMinutes,
      roundsBeforeLongBreak:
          roundsBeforeLongBreak ?? this.roundsBeforeLongBreak,
      completedRounds: completedRounds ?? this.completedRounds,
      label: clearTarget ? null : (label ?? this.label),
      taskScheduleId: clearTarget || clearTaskScheduleId
          ? null
          : (taskScheduleId ?? this.taskScheduleId),
      focusTagId: clearTarget || clearFocusTagId
          ? null
          : (focusTagId ?? this.focusTagId),
      tags: tags ?? this.tags,
      todayFocusSeconds: todayFocusSeconds ?? this.todayFocusSeconds,
      todaySessions: todaySessions ?? this.todaySessions,
      todayTasks: todayTasks ?? this.todayTasks,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [
        phase,
        runStatus,
        remainingSeconds,
        totalSeconds,
        focusMinutes,
        shortBreakMinutes,
        longBreakMinutes,
        roundsBeforeLongBreak,
        completedRounds,
        label,
        taskScheduleId,
        focusTagId,
        tags,
        todayFocusSeconds,
        todaySessions,
        todayTasks,
        errorMessage,
      ];
}
