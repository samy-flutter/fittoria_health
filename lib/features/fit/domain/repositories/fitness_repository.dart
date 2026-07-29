import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../data/models/fit_models.dart';
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
  Future<Either<Failure, HeartRateData>> getHeartRate();
  Future<Either<Failure, void>> logHeartRate(int bpm, String type);
  Future<Either<Failure, SleepData>> getSleep();
  Future<Either<Failure, void>> logSleep(
    DateTime date,
    int total,
    int rem,
    int light,
    int deep,
    int awake,
  );
  Future<Either<Failure, NutritionData>> getNutrition(String date);
  Future<Either<Failure, void>> logNutrition(
    String date,
    String mealType,
    String foodName,
    String quantity,
    int calories,
    int protein,
    int carbs,
    int fat,
  );
  Future<Either<Failure, WaterData>> getWater(String date);
  Future<Either<Failure, void>> logWater(String date, int ml);
  Future<Either<Failure, MoodData>> getMood();
  Future<Either<Failure, void>> logMood(
    String mood,
    int stress,
    int energy,
    String note,
  );
  Future<Either<Failure, void>> connectDevice(
    String provider,
    String displayName,
  );
  Future<Either<Failure, void>> disconnectDevice(String provider);
  Future<Either<Failure, void>> joinChallenge(int challengeId);
  Future<Either<Failure, void>> addGoal(String type, int target, String period);
  Future<Either<Failure, void>> deleteGoal(int goalId);
  Future<Either<Failure, void>> logWorkout(
    String type,
    String? title,
    int durationMin,
    double distanceKm,
    int caloriesKcal,
    int? avgHr,
  );
}
