import 'package:dartz/dartz.dart';
import 'package:example_app/core/domain/entities/event.dart';
import 'package:example_app/core/domain/repositories/event_repository.dart';
import 'package:example_app/core/error/failures.dart';
import 'package:example_app/features/events/domain/usecases/get_scheduled_events.dart';
import 'package:flutter_test/flutter_test.dart';

/// Fake repository — chứng minh domain test được mà KHÔNG cần Drift/Flutter.
class _FakeEventRepository implements EventRepository {
  List<Event> stored = [];

  @override
  Future<Either<Failure, List<Event>>> getScheduledEvents({
    DateTime? from,
    DateTime? to,
  }) async =>
      Right(stored);

  @override
  Future<Either<Failure, Event>> createEvent(Event event) async {
    stored.add(event);
    return Right(event);
  }

  @override
  Future<Either<Failure, Event>> updateEvent(Event event) async {
    final i = stored.indexWhere((e) => e.id == event.id);
    if (i != -1) stored[i] = event;
    return Right(event);
  }

  @override
  Future<Either<Failure, Unit>> deleteEvent(int id) async {
    stored.removeWhere((e) => e.id == id);
    return const Right(unit);
  }
}

void main() {
  test('GetScheduledEvents trả về danh sách từ repository', () async {
    final repo = _FakeEventRepository();
    final now = DateTime(2026, 7, 1);
    repo.stored = [
      Event(id: 1, title: 'Họp', startTime: now, endTime: now),
    ];
    final usecase = GetScheduledEvents(repo);

    final result = await usecase(const GetScheduledEventsParams());

    expect(result.isRight(), true);
    result.fold(
      (_) => fail('không nên lỗi'),
      (events) => expect(events.length, 1),
    );
  });
}
