import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/domain/index.dart';
import '../../../../core/error/index.dart';
import '../../../../core/usecase/index.dart';

@lazySingleton
class CreateEvent implements UseCase<Event, Event> {
  final EventRepository _repository;

  CreateEvent(this._repository);

  @override
  Future<Either<Failure, Event>> call(Event params) {
    return _repository.createEvent(params);
  }
}
