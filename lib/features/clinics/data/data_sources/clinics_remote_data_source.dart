import 'package:dio/dio.dart';
import '../../../../core/network/dio_client.dart';
import '../../../../core/network/api_endpoints.dart';
import '../../../../core/network/api_exceptions.dart';
import '../models/clinic.dart';

abstract class ClinicsRemoteDataSource {
  Future<List<Clinic>> searchClinics({
    String? query,
    String? type,
    double? lat,
    double? lng,
  });
}

class ClinicsRemoteDataSourceImpl implements ClinicsRemoteDataSource {
  final DioClient _client;

  ClinicsRemoteDataSourceImpl(this._client);

  @override
  Future<List<Clinic>> searchClinics({
    String? query,
    String? type,
    double? lat,
    double? lng,
  }) async {
    try {
      final queryParams = <String, dynamic>{};
      if (query != null && query.isNotEmpty) queryParams['q'] = query;
      if (type != null && type.isNotEmpty) queryParams['type'] = type;
      if (lat != null) queryParams['lat'] = lat;
      if (lng != null) queryParams['lng'] = lng;

      final response = await _client.get(
        ApiEndpoints.clinics,
        queryParameters: queryParams,
      );
      final list = response.data?['clinics'] as List? ?? response.data as List? ?? [];
      return list.map((item) => Clinic.fromJson(item)).toList();
    } on DioException catch (e) {
      throw ApiException.fromDioError(e);
    }
  }
}
