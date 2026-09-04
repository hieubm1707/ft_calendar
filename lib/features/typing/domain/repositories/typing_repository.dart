import 'package:dartz/dartz.dart';

import '../../../../core/error/index.dart';
import '../entities/typing_result.dart';

abstract class TypingRepository {
  /// Lưu 1 kết quả vừa làm xong.
  Future<Either<Failure, Unit>> saveResult(TypingResult result);

  /// Kết quả có `takenAt` trong [from, to) — mới nhất trước.
  Future<Either<Failure, List<TypingResult>>> getResults({
    required DateTime from,
    required DateTime to,
  });

  Future<Either<Failure, Unit>> deleteResult(int id);
}
