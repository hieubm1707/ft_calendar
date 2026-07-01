import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/domain/index.dart';
import '../../../../core/error/index.dart';
import '../../../../core/usecase/index.dart';

@lazySingleton
class DeleteEvent implements UseCase<Unit, int> {
  final EventRepository _repository;

  DeleteEvent(this._repository);

  @override
  Future<Either<Failure, Unit>> call(int params) {
    return _repository.deleteEvent(params);
  }
}
