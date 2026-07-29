import '../../../../core/network/dio_client.dart';
import '../models/fit_models.dart';
import '../models/fitness_models.dart';
import '../models/fitness_hub_models.dart';

abstract class FitnessRemoteDataSource {
  Future<FitnessSummary> getFitnessSummary();
  Future<List<FitDevice>> getDevices();
  Future<List<FitGoalDetail>> getGoals();
  Future<List<FitChallengeDetail>> getChallenges();
  Future<FitBodyProgressData> getBodyProgress();
  Future<FitWorkoutData> getWorkouts();
  Future<HeartRateData> getHeartRate();
  Future<void> logHeartRate(int bpm, String type);
  Future<SleepData> getSleep();
  Future<void> logSleep(
    DateTime date,
    int total,
    int rem,
    int light,
    int deep,
    int awake,
  );
  Future<NutritionData> getNutrition(String date);
  Future<void> logNutrition(
    String date,
    String mealType,
    String foodName,
    String quantity,
    int calories,
    int protein,
    int carbs,
    int fat,
  );
  Future<WaterData> getWater(String date);
  Future<void> logWater(String date, int ml);
  Future<MoodData> getMood();
  Future<void> logMood(String mood, int stress, int energy, String note);
  Future<OnboardingStatus> getOnboardingStatus();
  Future<void> connectDevice(String provider, String displayName);
  Future<void> disconnectDevice(String provider);
  Future<void> joinChallenge(int challengeId);
  Future<void> addGoal(String type, int target, String period);
  Future<void> deleteGoal(int goalId);
  Future<void> logWorkout(
    String type,
    String? title,
    int durationMin,
    double distanceKm,
    int caloriesKcal,
    int? avgHr,
  );
}

class FitnessRemoteDataSourceImpl implements FitnessRemoteDataSource {
  final DioClient _apiClient;

  FitnessRemoteDataSourceImpl(this._apiClient);

  @override
  Future<FitnessSummary> getFitnessSummary() async {
    final response = await _apiClient.get('/api/patient/fit/summary');
    return FitnessSummary.fromJson(response.data);
  }

  @override
  Future<List<FitDevice>> getDevices() async {
    final response = await _apiClient.get('/api/patient/fit/devices');
    return (response.data['devices'] as List?)
            ?.map((e) => FitDevice.fromJson(e))
            .toList() ??
        [];
  }

  @override
  Future<List<FitGoalDetail>> getGoals() async {
    final response = await _apiClient.get('/api/patient/fit/goals');
    return (response.data['goals'] as List?)
            ?.map((e) => FitGoalDetail.fromJson(e))
            .toList() ??
        [];
  }

  @override
  Future<List<FitChallengeDetail>> getChallenges() async {
    final response = await _apiClient.get('/api/patient/fit/challenges');
    return (response.data['challenges'] as List?)
            ?.map((e) => FitChallengeDetail.fromJson(e))
            .toList() ??
        [];
  }

  @override
  Future<FitBodyProgressData> getBodyProgress() async {
    final response = await _apiClient.get('/api/patient/body-progress');
    return FitBodyProgressData.fromJson(response.data);
  }

  @override
  Future<FitWorkoutData> getWorkouts() async {
    final response = await _apiClient.get('/api/patient/fit/workouts');
    return FitWorkoutData.fromJson(response.data);
  }

  @override
  Future<HeartRateData> getHeartRate() async {
    final response = await _apiClient.get('/api/patient/fit/heart-rate');
    return HeartRateData.fromJson(response.data);
  }

  @override
  Future<SleepData> getSleep() async {
    final response = await _apiClient.get('/api/patient/fit/sleep');
    return SleepData.fromJson(response.data);
  }

  @override
  Future<NutritionData> getNutrition(String date) async {
    final response = await _apiClient.get(
      '/api/patient/fit/nutrition?date=$date',
    );
    return NutritionData.fromJson(response.data);
  }

  @override
  Future<WaterData> getWater(String date) async {
    final response = await _apiClient.get('/api/patient/fit/water?date=$date');
    return WaterData.fromJson(response.data);
  }

  @override
  Future<MoodData> getMood() async {
    final response = await _apiClient.get('/api/patient/fit/mood');
    return MoodData.fromJson(response.data);
  }

  @override
  Future<OnboardingStatus> getOnboardingStatus() async {
    final response = await _apiClient.get('/api/patient/onboarding');
    return OnboardingStatus.fromJson(response.data);
  }

  @override
  Future<void> connectDevice(String provider, String displayName) async {
    await _apiClient.post(
      '/api/patient/fit/devices',
      data: {'provider': provider, 'display_name': displayName},
    );
  }

  @override
  Future<void> disconnectDevice(String provider) async {
    await _apiClient.delete(
      '/api/patient/fit/devices',
      queryParameters: {'provider': provider},
    );
  }

  @override
  Future<void> joinChallenge(int challengeId) async {
    await _apiClient.post(
      '/api/patient/fit/challenges',
      data: {'challengeId': challengeId},
    );
  }

  @override
  Future<void> addGoal(String type, int target, String period) async {
    await _apiClient.post(
      '/api/patient/fit/goals',
      data: {'goal_type': type, 'target_value': target, 'period': period},
    );
  }

  @override
  Future<void> deleteGoal(int goalId) async {
    await _apiClient.delete('/api/patient/fit/goals?id=$goalId');
  }

  @override
  Future<void> logWorkout(
    String type,
    String? title,
    int durationMin,
    double distanceKm,
    int caloriesKcal,
    int? avgHr,
  ) async {
    await _apiClient.post(
      '/api/patient/fit/workouts',
      data: {
        'workout_type': type,
        'title': title,
        'duration_min': durationMin,
        'distance_km': distanceKm,
        'calories_kcal': caloriesKcal,
        'avg_heart_rate': avgHr,
      },
    );
  }

  @override
  Future<void> logHeartRate(int bpm, String type) async {
    await _apiClient.post(
      '/api/patient/fit/heart-rate',
      data: {'bpm': bpm, 'type': type},
    );
  }

  @override
  Future<void> logSleep(
    DateTime date,
    int total,
    int rem,
    int light,
    int deep,
    int awake,
  ) async {
    await _apiClient.post(
      '/api/patient/fit/sleep',
      data: {
        'log_date': date.toIso8601String().substring(0, 10),
        'total_minutes': total,
        'rem_minutes': rem,
        'light_minutes': light,
        'deep_minutes': deep,
        'awake_minutes': awake,
      },
    );
  }

  @override
  Future<void> logNutrition(
    String date,
    String mealType,
    String foodName,
    String quantity,
    int calories,
    int protein,
    int carbs,
    int fat,
  ) async {
    await _apiClient.post(
      '/api/patient/fit/nutrition',
      data: {
        'log_date': date,
        'meal_type': mealType,
        'food_name': foodName,
        'quantity': quantity,
        'calories_kcal': calories,
        'protein_g': protein,
        'carbs_g': carbs,
        'fat_g': fat,
      },
    );
  }

  @override
  Future<void> logWater(String date, int ml) async {
    await _apiClient.post(
      '/api/patient/fit/water',
      data: {'log_date': date, 'ml': ml},
    );
  }

  @override
  Future<void> logMood(String mood, int stress, int energy, String note) async {
    await _apiClient.post(
      '/api/patient/fit/mood',
      data: {
        'mood': mood,
        'stress_level': stress,
        'energy_level': energy,
        'note': note,
      },
    );
  }
}
