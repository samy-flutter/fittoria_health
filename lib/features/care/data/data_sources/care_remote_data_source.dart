import '../../../../core/network/dio_client.dart';
import '../models/gym_model.dart';

import '../models/gym_model.dart';
import '../models/fitness_details_model.dart';
import '../models/nutrition_details_model.dart';
import '../models/meetings_model.dart';

abstract class CareRemoteDataSource {
  Future<GymData> getGymData();
  Future<FitnessDetailsData> getFitnessDetails();
  Future<NutritionDetailsData> getNutritionDetails();
  Future<MeetingsData> getMeetingsData();
}

class CareRemoteDataSourceImpl implements CareRemoteDataSource {
  final DioClient _apiClient;

  CareRemoteDataSourceImpl(this._apiClient);

  @override
  Future<GymData> getGymData() async {
    final response = await _apiClient.get('/api/patient/gym');
    return GymData.fromJson(response.data);
  }

  @override
  Future<FitnessDetailsData> getFitnessDetails() async {
    final response = await _apiClient.get('/api/patient/fitness');
    return FitnessDetailsData.fromJson(response.data);
  }

  @override
  Future<NutritionDetailsData> getNutritionDetails() async {
    final response = await _apiClient.get('/api/patient/nutrition');
    return NutritionDetailsData.fromJson(response.data);
  }

  @override
  Future<MeetingsData> getMeetingsData() async {
    final response = await _apiClient.get('/api/patient/meetings');
    return MeetingsData.fromJson(response.data);
  }
}
