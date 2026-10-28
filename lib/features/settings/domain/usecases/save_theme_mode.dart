import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/error/index.dart';
import '../../../../core/usecase/index.dart';
import '../entities/app_theme_mode.dart';
import '../repositories/appearance_repository.dart';

@lazySingleton
class SaveThemeMode implements UseCase<Unit, AppThemeMode> {
  final AppearanceRepository _repository;

  SaveThemeMode(this._repository);

  @override
  Future<Either<Failure, Unit>> call(AppThemeMode params) {
    return _repository.saveThemeMode(params);
  }
}
