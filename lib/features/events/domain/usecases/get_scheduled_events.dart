import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/domain/entities/event.dart';
import '../../../../core/domain/repositories/event_repository.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecase/usecase.dart';

/// Lấy danh sách sự kiện đã lên lịch (tùy chọn lọc theo khoảng thời gian).
/// Được feature `events` VÀ feature `calendar` cùng dùng lại.
@lazySingleton
class GetScheduledEvents implements UseCase<List<Event>, GetScheduledEventsParams> {
  final EventRepository _repository;

  GetScheduledEvents(this._repository);

  @override
  Future<Either<Failure, List<Event>>> call(GetScheduledEventsParams params) {
    return _repository.getScheduledEvents(from: params.from, to: params.to);
  }
}

class GetScheduledEventsParams extends Equatable {
  final DateTime? from;
  final DateTime? to;

  const GetScheduledEventsParams({this.from, this.to});

  @override
  List<Object?> get props => [from, to];
}
