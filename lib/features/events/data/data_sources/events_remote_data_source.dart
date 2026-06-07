import '../../../../core/network/dio_client.dart';
import '../../../../core/network/api_exceptions.dart';
import '../models/event_models.dart';

abstract class EventsRemoteDataSource {
  Future<List<FitEvent>> getEvents({String? type, String? status});
  Future<Map<String, dynamic>> registerForEvent(int eventId);
}

class EventsRemoteDataSourceImpl implements EventsRemoteDataSource {
  final DioClient _apiClient;

  EventsRemoteDataSourceImpl(this._apiClient);

  @override
  Future<List<FitEvent>> getEvents({String? type, String? status}) async {
    try {
      final queryParams = <String, dynamic>{};
      if (type != null && type.isNotEmpty) queryParams['type'] = type;
      if (status != null && status.isNotEmpty) queryParams['status'] = status;

      final response = await _apiClient.get('/api/patient/events', queryParameters: queryParams);
      final data = response.data['events'] as List?;
      return data?.map((e) => FitEvent.fromJson(e)).toList() ?? [];
    } on ApiException {
      rethrow;
    } catch (e) {
      throw ApiException(message: e.toString());
    }
  }

  @override
  Future<Map<String, dynamic>> registerForEvent(int eventId) async {
    try {
      final response = await _apiClient.post('/api/patient/events/$eventId/register');
      return response.data as Map<String, dynamic>;
    } on ApiException {
      rethrow;
    } catch (e) {
      throw ApiException(message: e.toString());
    }
  }
}
