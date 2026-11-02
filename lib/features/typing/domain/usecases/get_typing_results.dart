import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/error/index.dart';
import '../../../../core/usecase/index.dart';
import '../entities/typing_result.dart';
import '../repositories/typing_repository.dart';

@lazySingleton
class GetTypingResults
    implements UseCase<List<TypingResult>, GetTypingResultsParams> {
  final TypingRepository _repository;

  GetTypingResults(this._repository);

  @override
  Future<Either<Failure, List<TypingResult>>> call(
      GetTypingResultsParams params) {
    return _repository.getResults(from: params.from, to: params.to);
  }
}

class GetTypingResultsParams extends Equatable {
  /// Bao gồm [from], KHÔNG bao gồm [to].
  final DateTime from;
  final DateTime to;

  const GetTypingResultsParams({required this.from, required this.to});

  @override
  List<Object?> get props => [from, to];
}
