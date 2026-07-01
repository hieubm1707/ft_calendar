import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/domain/repositories/event_repository.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecase/usecase.dart';

@lazySingleton
class DeleteEvent implements UseCase<Unit, int> {
  final EventRepository _repository;

  DeleteEvent(this._repository);

  @override
  Future<Either<Failure, Unit>> call(int params) {
    return _repository.deleteEvent(params);
  }
}
