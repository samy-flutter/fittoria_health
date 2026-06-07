import '../../../../core/network/dio_client.dart';
import '../models/academy_models.dart';

abstract class AcademyRemoteDataSource {
  Future<List<AcademyVideo>> getVideos({
    required String audience,
    String? query,
    String? category,
  });

  Future<Map<String, dynamic>> toggleLike(int videoId);
}

class AcademyRemoteDataSourceImpl implements AcademyRemoteDataSource {
  final DioClient _apiClient;

  AcademyRemoteDataSourceImpl(this._apiClient);

  @override
  Future<List<AcademyVideo>> getVideos({
    required String audience,
    String? query,
    String? category,
  }) async {
    final queryParams = <String, dynamic>{
      'audience': audience,
    };
    if (query != null && query.isNotEmpty) {
      queryParams['q'] = query;
    }
    if (category != null && category.isNotEmpty) {
      queryParams['category'] = category;
    }

    final response = await _apiClient.get('/api/academy/feed', queryParameters: queryParams);
    final data = response.data['videos'] as List?;
    return data?.map((e) => AcademyVideo.fromJson(e)).toList() ?? [];
  }

  @override
  Future<Map<String, dynamic>> toggleLike(int videoId) async {
    final response = await _apiClient.post('/api/academy/feed/$videoId/like');
    return response.data;
  }
}
