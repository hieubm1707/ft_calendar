// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pomodoro_dao.dart';

// ignore_for_file: type=lint
mixin _$PomodoroDaoMixin on DatabaseAccessor<AppDatabase> {
  $PomodoroSessionTableTable get pomodoroSessionTable =>
      attachedDatabase.pomodoroSessionTable;
  PomodoroDaoManager get managers => PomodoroDaoManager(this);
}

class PomodoroDaoManager {
  final _$PomodoroDaoMixin _db;
  PomodoroDaoManager(this._db);
  $$PomodoroSessionTableTableTableManager get pomodoroSessionTable =>
      $$PomodoroSessionTableTableTableManager(
        _db.attachedDatabase,
        _db.pomodoroSessionTable,
      );
}
