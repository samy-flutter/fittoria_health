import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/error/exception_handler.dart';
import '../../../../core/network/api_exceptions.dart';
import '../../domain/repositories/fitness_repository.dart';
import '../data_sources/fitness_remote_data_source.dart';
import '../models/fit_models.dart';
import '../models/fitness_models.dart';
import '../models/fitness_hub_models.dart';

class FitnessRepositoryImpl implements FitnessRepository {
  final FitnessRemoteDataSource _remoteDataSource;

  FitnessRepositoryImpl(this._remoteDataSource);

  @override
  Future<Either<Failure, FitnessSummary>> getFitnessSummary() async {
    try {
      final summary = await _remoteDataSource.getFitnessSummary();
      return Right(summary);
    } catch (e) {
      return Left(ExceptionHandler.handle(e));
    }
  }

  @override
  Future<Either<Failure, List<FitDevice>>> getDevices() async {
    try {
      final devices = await _remoteDataSource.getDevices();
      return Right(devices);
    } catch (e) {
      if (e is ApiException) return Left(ServerFailure(e.message));
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<FitGoalDetail>>> getGoals() async {
    try {
      final goals = await _remoteDataSource.getGoals();
      return Right(goals);
    } catch (e) {
      if (e is ApiException) return Left(ServerFailure(e.message));
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<FitChallengeDetail>>> getChallenges() async {
    try {
      final challenges = await _remoteDataSource.getChallenges();
      return Right(challenges);
    } catch (e) {
      if (e is ApiException) return Left(ServerFailure(e.message));
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, FitBodyProgressData>> getBodyProgress() async {
    try {
      final data = await _remoteDataSource.getBodyProgress();
      return Right(data);
    } catch (e) {
      if (e is ApiException) return Left(ServerFailure(e.message));
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, FitWorkoutData>> getWorkouts() async {
    try {
      final data = await _remoteDataSource.getWorkouts();
      return Right(data);
    } catch (e) {
      if (e is ApiException) return Left(ServerFailure(e.message));
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, HeartRateData>> getHeartRate() async {
    try {
      final data = await _remoteDataSource.getHeartRate();
      return Right(data);
    } catch (e) {
      if (e is ApiException) return Left(ServerFailure(e.message));
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, SleepData>> getSleep() async {
    try {
      final data = await _remoteDataSource.getSleep();
      return Right(data);
    } catch (e) {
      if (e is ApiException) return Left(ServerFailure(e.message));
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, NutritionData>> getNutrition(String date) async {
    try {
      final data = await _remoteDataSource.getNutrition(date);
      return Right(data);
    } catch (e) {
      if (e is ApiException) return Left(ServerFailure(e.message));
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, WaterData>> getWater(String date) async {
    try {
      final data = await _remoteDataSource.getWater(date);
      return Right(data);
    } catch (e) {
      if (e is ApiException) return Left(ServerFailure(e.message));
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, MoodData>> getMood() async {
    try {
      final data = await _remoteDataSource.getMood();
      return Right(data);
    } catch (e) {
      if (e is ApiException) return Left(ServerFailure(e.message));
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> connectDevice(
    String provider,
    String displayName,
  ) async {
    try {
      await _remoteDataSource.connectDevice(provider, displayName);
      return const Right(null);
    } catch (e) {
      if (e is ApiException) return Left(ServerFailure(e.message));
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> disconnectDevice(String provider) async {
    try {
      await _remoteDataSource.disconnectDevice(provider);
      return const Right(null);
    } catch (e) {
      if (e is ApiException) return Left(ServerFailure(e.message));
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> joinChallenge(int challengeId) async {
    try {
      await _remoteDataSource.joinChallenge(challengeId);
      return const Right(null);
    } catch (e) {
      if (e is ApiException) return Left(ServerFailure(e.message));
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, OnboardingStatus>> getOnboardingStatus() async {
    try {
      final status = await _remoteDataSource.getOnboardingStatus();
      return Right(status);
    } catch (e) {
      return Left(ExceptionHandler.handle(e));
    }
  }

  @override
  Future<Either<Failure, void>> addGoal(
    String type,
    int target,
    String period,
  ) async {
    try {
      await _remoteDataSource.addGoal(type, target, period);
      return const Right(null);
    } catch (e) {
      if (e is ApiException) return Left(ServerFailure(e.message));
      return const Left(
        ServerFailure(
          'Failed to add goal. Please check your connection and try again.',
        ),
      );
    }
  }

  @override
  Future<Either<Failure, void>> deleteGoal(int goalId) async {
    try {
      await _remoteDataSource.deleteGoal(goalId);
      return const Right(null);
    } catch (e) {
      if (e is ApiException) return Left(ServerFailure(e.message));
      return const Left(
        ServerFailure(
          'Failed to delete goal. Please check your connection and try again.',
        ),
      );
    }
  }

  @override
  Future<Either<Failure, void>> logWorkout(
    String type,
    String? title,
    int durationMin,
    double distanceKm,
    int caloriesKcal,
    int? avgHr,
  ) async {
    try {
      await _remoteDataSource.logWorkout(
        type,
        title,
        durationMin,
        distanceKm,
        caloriesKcal,
        avgHr,
      );
      return const Right(null);
    } catch (e) {
      if (e is ApiException) return Left(ServerFailure(e.message));
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> logHeartRate(int bpm, String type) async {
    try {
      await _remoteDataSource.logHeartRate(bpm, type);
      return const Right(null);
    } catch (e) {
      if (e is ApiException) return Left(ServerFailure(e.message));
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> logSleep(
    DateTime date,
    int total,
    int rem,
    int light,
    int deep,
    int awake,
  ) async {
    try {
      await _remoteDataSource.logSleep(date, total, rem, light, deep, awake);
      return const Right(null);
    } catch (e) {
      if (e is ApiException) return Left(ServerFailure(e.message));
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> logNutrition(
    String date,
    String mealType,
    String foodName,
    String quantity,
    int calories,
    int protein,
    int carbs,
    int fat,
  ) async {
    try {
      await _remoteDataSource.logNutrition(
        date,
        mealType,
        foodName,
        quantity,
        calories,
        protein,
        carbs,
        fat,
      );
      return const Right(null);
    } catch (e) {
      if (e is ApiException) return Left(ServerFailure(e.message));
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> logWater(String date, int ml) async {
    try {
      await _remoteDataSource.logWater(date, ml);
      return const Right(null);
    } catch (e) {
      if (e is ApiException) return Left(ServerFailure(e.message));
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> logMood(
    String mood,
    int stress,
    int energy,
    String note,
  ) async {
    try {
      await _remoteDataSource.logMood(mood, stress, energy, note);
      return const Right(null);
    } catch (e) {
      if (e is ApiException) return Left(ServerFailure(e.message));
      return Left(ServerFailure(e.toString()));
    }
  }
}
