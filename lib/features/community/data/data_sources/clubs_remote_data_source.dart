import '../../../../core/network/dio_client.dart';
import '../../../../core/network/api_exceptions.dart';
import '../models/club_models.dart';

abstract class ClubsRemoteDataSource {
  Future<List<SocialClub>> getClubs();
  Future<Map<String, dynamic>> toggleClubMembership(int clubId);
  Future<List<ClubChatMessage>> getClubChat(int clubId, {int after = 0});
  Future<void> sendChatMessage(int clubId, String body);
}

class ClubsRemoteDataSourceImpl implements ClubsRemoteDataSource {
  final DioClient _apiClient;

  ClubsRemoteDataSourceImpl(this._apiClient);

  @override
  Future<List<SocialClub>> getClubs() async {
    try {
      final response = await _apiClient.get('/api/patient/clubs');
      final data = response.data['clubs'] as List?;
      return data?.map((e) => SocialClub.fromJson(e)).toList() ?? [];
    } on ApiException {
      rethrow;
    } catch (e) {
      throw ApiException(message: e.toString());
    }
  }

  @override
  Future<Map<String, dynamic>> toggleClubMembership(int clubId) async {
    try {
      final response = await _apiClient.post('/api/patient/clubs', data: {'clubId': clubId});
      return response.data as Map<String, dynamic>;
    } on ApiException {
      rethrow;
    } catch (e) {
      throw ApiException(message: e.toString());
    }
  }
  @override
  Future<List<ClubChatMessage>> getClubChat(int clubId, {int after = 0}) async {
    try {
      final queryParams = after > 0 ? {'after': after} : null;
      final response = await _apiClient.get('/api/patient/clubs/$clubId/chat', queryParameters: queryParams);
      final data = response.data['messages'] as List?;
      return data?.map((e) => ClubChatMessage.fromJson(e)).toList() ?? [];
    } on ApiException {
      rethrow;
    } catch (e) {
      throw ApiException(message: e.toString());
    }
  }

  @override
  Future<void> sendChatMessage(int clubId, String body) async {
    try {
      await _apiClient.post('/api/patient/clubs/$clubId/chat', data: {'body': body});
    } on ApiException {
      rethrow;
    } catch (e) {
      throw ApiException(message: e.toString());
    }
  }
}
