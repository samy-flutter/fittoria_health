import 'package:dio/dio.dart';
import '../../../../core/network/dio_client.dart';
import '../../../../core/network/api_endpoints.dart';
import '../../../../core/network/api_exceptions.dart';
import '../models/profile_models.dart';

abstract class ProfileRemoteDataSource {
  Future<ProfileResponse> getProfile();
  Future<PatientProfile> updateProfile(Map<String, dynamic> updateData);
}

class ProfileRemoteDataSourceImpl implements ProfileRemoteDataSource {
  final DioClient _client;

  ProfileRemoteDataSourceImpl(this._client);

  @override
  Future<ProfileResponse> getProfile() async {
    try {
      final response = await _client.get(ApiEndpoints.profile);
      final data = response.data?['data'] ?? response.data;
      if (data != null) {
        return ProfileResponse.fromJson(data);
      }
      throw ApiException(message: 'Profile fetch returned empty response');
    } on DioException catch (e) {
      throw ApiException.fromDioError(e);
    }
  }

  @override
  Future<PatientProfile> updateProfile(Map<String, dynamic> updateData) async {
    try {
      final response = await _client.patch(ApiEndpoints.profile, data: updateData);
      final data = response.data?['data'] ?? response.data;
      if (data != null) {
        // Next.js client shows patientApi.updateProfile(patient) returns updated profile.
        // Let's assume the response structure returns updated patient info directly or as a sub-key 'patient'.
        // To be safe, we parse it:
        final patientData = data['patient'] ?? data;
        return PatientProfile.fromJson(patientData);
      }
      throw ApiException(message: 'Profile update returned empty response');
    } on DioException catch (e) {
      throw ApiException.fromDioError(e);
    }
  }
}
