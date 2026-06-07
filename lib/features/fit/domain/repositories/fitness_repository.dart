import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../data/models/fitness_models.dart';
import '../../data/models/fitness_hub_models.dart';

abstract class FitnessRepository {
  Future<Either<Failure, FitnessSummary>> getFitnessSummary();
  Future<Either<Failure, OnboardingStatus>> getOnboardingStatus();
  Future<Either<Failure, List<FitDevice>>> getDevices();
  Future<Either<Failure, List<FitGoalDetail>>> getGoals();
  Future<Either<Failure, List<FitChallengeDetail>>> getChallenges();
  Future<Either<Failure, FitBodyProgressData>> getBodyProgress();
  Future<Either<Failure, FitWorkoutData>> getWorkouts();
  Future<Either<Failure, void>> connectDevice(String provider, String displayName);
  Future<Either<Failure, void>> disconnectDevice(String provider);
  Future<Either<Failure, void>> joinChallenge(int challengeId);
}
