// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'task_dao.dart';

// ignore_for_file: type=lint
mixin _$TaskDaoMixin on DatabaseAccessor<AppDatabase> {
  $TaskScheduleTableTable get taskScheduleTable =>
      attachedDatabase.taskScheduleTable;
  $TaskCompletionTableTable get taskCompletionTable =>
      attachedDatabase.taskCompletionTable;
  TaskDaoManager get managers => TaskDaoManager(this);
}

class TaskDaoManager {
  final _$TaskDaoMixin _db;
  TaskDaoManager(this._db);
  $$TaskScheduleTableTableTableManager get taskScheduleTable =>
      $$TaskScheduleTableTableTableManager(
        _db.attachedDatabase,
        _db.taskScheduleTable,
      );
  $$TaskCompletionTableTableTableManager get taskCompletionTable =>
      $$TaskCompletionTableTableTableManager(
        _db.attachedDatabase,
        _db.taskCompletionTable,
      );
}
