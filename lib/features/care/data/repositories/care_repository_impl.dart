import '../../../../core/error/exception_handler.dart';
import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../domain/repositories/care_repository.dart';
import '../data_sources/care_remote_data_source.dart';
import '../models/gym_model.dart';
import '../models/fitness_details_model.dart';
import '../models/nutrition_details_model.dart';
import '../models/meetings_model.dart';

class CareRepositoryImpl implements CareRepository {
  final CareRemoteDataSource _remoteDataSource;

  CareRepositoryImpl(this._remoteDataSource);

  @override
  Future<Either<Failure, GymData>> getGymData() async {
    try {
      final data = await _remoteDataSource.getGymData();
      return Right(data);
    } catch (e) {
      return Left(ExceptionHandler.handle(e));
    }
  }

  @override
  Future<Either<Failure, FitnessDetailsData>> getFitnessDetails() async {
    try {
      final data = await _remoteDataSource.getFitnessDetails();
      return Right(data);
    } catch (e) {
      return Left(ExceptionHandler.handle(e));
    }
  }

  @override
  Future<Either<Failure, NutritionDetailsData>> getNutritionDetails() async {
    try {
      final data = await _remoteDataSource.getNutritionDetails();
      return Right(data);
    } catch (e) {
      return Left(ExceptionHandler.handle(e));
    }
  }

  @override
  Future<Either<Failure, MeetingsData>> getMeetingsData() async {
    try {
      final data = await _remoteDataSource.getMeetingsData();
      return Right(data);
    } catch (e) {
      return Left(ExceptionHandler.handle(e));
    }
  }
}
