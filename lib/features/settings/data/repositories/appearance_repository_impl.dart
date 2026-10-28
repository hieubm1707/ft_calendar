import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/error/index.dart';
import '../../domain/index.dart';
import '../datasources/appearance_local_datasource.dart';

@LazySingleton(as: AppearanceRepository)
class AppearanceRepositoryImpl implements AppearanceRepository {
  final AppearanceLocalDataSource _local;

  AppearanceRepositoryImpl(this._local);

  @override
  Future<Either<Failure, AppThemeMode>> getThemeMode() async {
    try {
      return Right(await _local.getThemeMode());
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    } catch (_) {
      return const Left(UnexpectedFailure());
    }
  }

  @override
  Future<Either<Failure, Unit>> saveThemeMode(AppThemeMode mode) async {
    try {
      await _local.saveThemeMode(mode);
      return const Right(unit);
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    } catch (_) {
      return const Left(UnexpectedFailure());
    }
  }
}
