import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/domain/entities/event.dart';
import '../../../../core/domain/repositories/event_repository.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecase/usecase.dart';

@lazySingleton
class CreateEvent implements UseCase<Event, Event> {
  final EventRepository _repository;

  CreateEvent(this._repository);

  @override
  Future<Either<Failure, Event>> call(Event params) {
    return _repository.createEvent(params);
  }
}
