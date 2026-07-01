import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/error/index.dart';
import '../../domain/index.dart';

part 'task_state.dart';

/// Quản lý danh sách task (instance sinh ảo) cho dải today..+60 ngày.
@injectable
class TaskCubit extends Cubit<TaskState> {
  final GetTaskInstances _getInstances;
  final CreateTaskSchedule _createSchedule;
  final SetTaskDone _setTaskDone;
  final RemoveTaskSchedule _removeSchedule;

  TaskCubit(
    this._getInstances,
    this._createSchedule,
    this._setTaskDone,
    this._removeSchedule,
  ) : super(const TaskState());

  bool _loaded = false;

  Future<void> load() async {
    final now = DateTime.now();
    final from = DateTime(now.year, now.month, now.day);
    final to = from.add(const Duration(days: 60));
    _loaded = true;
    emit(state.copyWith(status: TaskStatus.loading));

    final result = await _getInstances(GetTaskInstancesParams(from: from, to: to));
    result.fold(
      (failure) => emit(state.copyWith(
          status: TaskStatus.failure, errorMessage: failure.message)),
      (list) => emit(state.copyWith(
          status: TaskStatus.success, instancesByDay: _groupByDay(list))),
    );
  }

  Future<void> addSchedule(TaskSchedule schedule) =>
      _mutate(_createSchedule(schedule));

  Future<void> toggleDone(TaskInstance i) => _mutate(_setTaskDone(
      SetTaskDoneParams(scheduleId: i.scheduleId, date: i.date, done: !i.done)));

  /// Huỷ lịch lặp (hard=false) hoặc xoá hẳn (hard=true).
  Future<void> removeSchedule(int scheduleId, {required bool hard}) => _mutate(
      _removeSchedule(RemoveTaskScheduleParams(scheduleId: scheduleId, hard: hard)));

  Future<void> _mutate(Future<Either<Failure, Unit>> op) async {
    final result = await op;
    await result.fold(
      (failure) async => emit(state.copyWith(
          status: TaskStatus.failure, errorMessage: failure.message)),
      (_) async => _reload(),
    );
  }

  Future<void> _reload() async {
    if (_loaded) await load();
  }

  Map<DateTime, List<TaskInstance>> _groupByDay(List<TaskInstance> list) {
    final map = <DateTime, List<TaskInstance>>{};
    for (final i in list) {
      (map[i.date] ??= []).add(i);
    }
    return map;
  }
}
