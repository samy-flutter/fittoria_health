import '../../../../core/error/exception_handler.dart';
import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../data_sources/achievements_remote_data_source.dart';
import '../../domain/repositories/achievements_repository.dart';
import '../models/achievement_models.dart';

class AchievementsRepositoryImpl implements AchievementsRepository {
  final AchievementsRemoteDataSource _remoteDataSource;

  AchievementsRepositoryImpl(this._remoteDataSource);

  @override
  Future<Either<Failure, AchievementsData>> getAchievementsData() async {
    try {
      final data = await _remoteDataSource.getAchievements();
      return Right(data);
    } catch (e) {
      return Left(ExceptionHandler.handle(e));
    }
  }
}
