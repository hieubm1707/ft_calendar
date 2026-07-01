import 'package:dartz/dartz.dart';

import '../../error/failures.dart';
import '../entities/event.dart';

/// Interface (contract) ở domain. Feature `events` sẽ implement ở lớp data.
/// Bất kỳ feature nào cũng phụ thuộc vào interface này, không phụ thuộc Drift.
abstract class EventRepository {
  Future<Either<Failure, List<Event>>> getScheduledEvents({
    DateTime? from,
    DateTime? to,
  });

  Future<Either<Failure, Event>> createEvent(Event event);

  Future<Either<Failure, Event>> updateEvent(Event event);

  Future<Either<Failure, Unit>> deleteEvent(int id);
}
