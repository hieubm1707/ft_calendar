import 'package:dartz/dartz.dart';

import '../../../../core/error/index.dart';
import '../entities/pomodoro_session.dart';

abstract class PomodoroRepository {
  /// Lưu 1 phiên tập trung vừa kết thúc.
  Future<Either<Failure, Unit>> saveSession(PomodoroSession session);

  /// Phiên bắt đầu trong [from, to) — mới nhất trước.
  Future<Either<Failure, List<PomodoroSession>>> getSessions({
    required DateTime from,
    required DateTime to,
  });

  Future<Either<Failure, Unit>> deleteSession(int id);
}
