import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/error/index.dart';
import '../../../../core/usecase/index.dart';
import '../entities/task_instance.dart';
import '../repositories/task_repository.dart';

@lazySingleton
class GetTaskInstances
    implements UseCase<List<TaskInstance>, GetTaskInstancesParams> {
  final TaskRepository _repository;

  GetTaskInstances(this._repository);

  @override
  Future<Either<Failure, List<TaskInstance>>> call(
      GetTaskInstancesParams params) {
    return _repository.getInstances(from: params.from, to: params.to);
  }
}

class GetTaskInstancesParams extends Equatable {
  final DateTime from;
  final DateTime to;

  const GetTaskInstancesParams({required this.from, required this.to});

  @override
  List<Object?> get props => [from, to];
}
