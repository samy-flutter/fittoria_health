import '../../../../core/network/dio_client.dart';
import '../../../../core/network/api_exceptions.dart';
import '../models/achievement_models.dart';

abstract class AchievementsRemoteDataSource {
  Future<AchievementsData> getAchievements();
}

class AchievementsRemoteDataSourceImpl implements AchievementsRemoteDataSource {
  final DioClient _apiClient;

  AchievementsRemoteDataSourceImpl(this._apiClient);

  @override
  Future<AchievementsData> getAchievements() async {
    try {
      final response = await _apiClient.get('/api/patient/points');
      return AchievementsData.fromJson(response.data);
    } on ApiException {
      rethrow;
    } catch (e) {
      throw ApiException(message: e.toString());
    }
  }
}
