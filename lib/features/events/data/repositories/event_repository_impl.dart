import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/domain/index.dart';
import '../../../../core/error/index.dart';
import '../datasources/event_local_datasource.dart';
import '../models/event_mapper.dart';

@LazySingleton(as: EventRepository)
class EventRepositoryImpl implements EventRepository {
  final EventLocalDataSource _local;

  EventRepositoryImpl(this._local);

  @override
  Future<Either<Failure, List<Event>>> getScheduledEvents({
    DateTime? from,
    DateTime? to,
  }) async {
    try {
      final rows = await _local.getScheduledEvents(from: from, to: to);
      return Right(rows.map((r) => r.toEntity()).toList());
    } on DatabaseException catch (e) {
      return Left(DatabaseFailure(e.message));
    } catch (_) {
      return const Left(UnexpectedFailure());
    }
  }

  @override
  Future<Either<Failure, Event>> createEvent(Event event) async {
    try {
      final row = await _local.createEvent(event.toCompanion());
      return Right(row.toEntity());
    } on DatabaseException catch (e) {
      return Left(DatabaseFailure(e.message));
    } catch (_) {
      return const Left(UnexpectedFailure());
    }
  }

  @override
  Future<Either<Failure, Event>> updateEvent(Event event) async {
    try {
      await _local.updateEvent(event.toCompanion());
      return Right(event);
    } on DatabaseException catch (e) {
      return Left(DatabaseFailure(e.message));
    } catch (_) {
      return const Left(UnexpectedFailure());
    }
  }

  @override
  Future<Either<Failure, Unit>> deleteEvent(int id) async {
    try {
      await _local.deleteEvent(id);
      return const Right(unit);
    } on DatabaseException catch (e) {
      return Left(DatabaseFailure(e.message));
    } catch (_) {
      return const Left(UnexpectedFailure());
    }
  }
}
