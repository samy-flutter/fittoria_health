import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/network/api_exceptions.dart';
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
    } on ApiException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
