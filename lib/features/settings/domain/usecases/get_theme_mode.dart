import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/error/index.dart';
import '../../../../core/usecase/index.dart';
import '../entities/app_theme_mode.dart';
import '../repositories/appearance_repository.dart';

@lazySingleton
class GetThemeMode implements UseCase<AppThemeMode, NoParams> {
  final AppearanceRepository _repository;

  GetThemeMode(this._repository);

  @override
  Future<Either<Failure, AppThemeMode>> call(NoParams params) {
    return _repository.getThemeMode();
  }
}
