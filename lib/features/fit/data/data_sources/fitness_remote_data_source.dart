import '../../../../core/network/dio_client.dart';
import '../models/fitness_models.dart';
import '../models/fitness_hub_models.dart';

abstract class FitnessRemoteDataSource {
  Future<FitnessSummary> getFitnessSummary();
  Future<List<FitDevice>> getDevices();
  Future<List<FitGoalDetail>> getGoals();
  Future<List<FitChallengeDetail>> getChallenges();
  Future<FitBodyProgressData> getBodyProgress();
  Future<FitWorkoutData> getWorkouts();
  Future<OnboardingStatus> getOnboardingStatus();
  Future<void> connectDevice(String provider, String displayName);
  Future<void> disconnectDevice(String provider);
  Future<void> joinChallenge(int challengeId);
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
    return (response.data['devices'] as List?)?.map((e) => FitDevice.fromJson(e)).toList() ?? [];
  }

  @override
  Future<List<FitGoalDetail>> getGoals() async {
    final response = await _apiClient.get('/api/patient/fit/goals');
    return (response.data['goals'] as List?)?.map((e) => FitGoalDetail.fromJson(e)).toList() ?? [];
  }

  @override
  Future<List<FitChallengeDetail>> getChallenges() async {
    final response = await _apiClient.get('/api/patient/fit/challenges');
    return (response.data['challenges'] as List?)?.map((e) => FitChallengeDetail.fromJson(e)).toList() ?? [];
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
    await _apiClient.delete('/api/patient/fit/devices', queryParameters: {'provider': provider});
  }

  @override
  Future<void> joinChallenge(int challengeId) async {
    await _apiClient.post('/api/patient/fit/challenges', data: {'challengeId': challengeId});
  }
}
