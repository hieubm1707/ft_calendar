import 'package:injectable/injectable.dart';

import '../database/drift/app_database.dart';
import '../database/drift/daos/event_dao.dart';

/// Đăng ký các object không có annotation @injectable (thư viện bên thứ 3).
@module
abstract class RegisterModule {
  @lazySingleton
  AppDatabase get appDatabase => AppDatabase();

  @lazySingleton
  EventDao eventDao(AppDatabase db) => db.eventDao;
}
