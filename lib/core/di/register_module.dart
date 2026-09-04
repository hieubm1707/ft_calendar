import 'package:injectable/injectable.dart';

import '../database/drift/index.dart';

/// Đăng ký các object không có annotation @injectable (thư viện bên thứ 3).
@module
abstract class RegisterModule {
  @lazySingleton
  AppDatabase get appDatabase => AppDatabase();

  @lazySingleton
  EventDao eventDao(AppDatabase db) => db.eventDao;

  @lazySingleton
  TaskDao taskDao(AppDatabase db) => db.taskDao;

  @lazySingleton
  PomodoroDao pomodoroDao(AppDatabase db) => db.pomodoroDao;

  @lazySingleton
  FocusTagDao focusTagDao(AppDatabase db) => db.focusTagDao;

  @lazySingleton
  TypingDao typingDao(AppDatabase db) => db.typingDao;

  @lazySingleton
  TypingContentDao typingContentDao(AppDatabase db) => db.typingContentDao;
}
