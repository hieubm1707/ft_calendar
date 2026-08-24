import 'package:drift/drift.dart';

import '../../../../core/database/drift/index.dart';
import '../../domain/index.dart';

extension PomodoroSessionRowMapper on PomodoroSessionTableData {
  PomodoroSession toEntity() => PomodoroSession(
        id: id,
        startedAt: startedAt,
        endedAt: endedAt,
        focusSeconds: focusSeconds,
        plannedSeconds: plannedSeconds,
        completed: completed,
        label: label,
        taskScheduleId: taskScheduleId,
      );
}

extension PomodoroSessionEntityMapper on PomodoroSession {
  PomodoroSessionTableCompanion toInsertCompanion() =>
      PomodoroSessionTableCompanion.insert(
        startedAt: startedAt,
        endedAt: endedAt,
        focusSeconds: focusSeconds,
        plannedSeconds: plannedSeconds,
        completed: Value(completed),
        label: Value(label),
        taskScheduleId: Value(taskScheduleId),
      );
}
