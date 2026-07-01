part of 'task_cubit.dart';

enum TaskStatus { initial, loading, success, failure }

class TaskState extends Equatable {
  final TaskStatus status;

  /// Task gom theo ngày (key = ngày chuẩn hoá).
  final Map<DateTime, List<TaskInstance>> instancesByDay;
  final String? errorMessage;

  const TaskState({
    this.status = TaskStatus.initial,
    this.instancesByDay = const {},
    this.errorMessage,
  });

  /// Các ngày có task, sắp tăng dần.
  List<DateTime> get sortedDays =>
      instancesByDay.keys.toList()..sort((a, b) => a.compareTo(b));

  TaskState copyWith({
    TaskStatus? status,
    Map<DateTime, List<TaskInstance>>? instancesByDay,
    String? errorMessage,
  }) {
    return TaskState(
      status: status ?? this.status,
      instancesByDay: instancesByDay ?? this.instancesByDay,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, instancesByDay, errorMessage];
}
