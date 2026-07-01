import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../error/failures.dart';

/// Contract chung cho mọi UseCase. Bloc chỉ gọi UseCase, không đụng Repository.
abstract class UseCase<T, Params> {
  Future<Either<Failure, T>> call(Params params);
}

/// Dùng cho usecase không cần tham số.
class NoParams extends Equatable {
  const NoParams();

  @override
  List<Object?> get props => [];
}
