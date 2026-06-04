import '../../../../core/network/dio_client.dart';
import '../../../../core/network/api_endpoints.dart';
import '../models/prescription.dart';

abstract class PrescriptionsRemoteDataSource {
  Future<PrescriptionsResponse> getPrescriptions();
}

class PrescriptionsRemoteDataSourceImpl implements PrescriptionsRemoteDataSource {
  final DioClient _dioClient;

  PrescriptionsRemoteDataSourceImpl(this._dioClient);

  @override
  Future<PrescriptionsResponse> getPrescriptions() async {
    final response = await _dioClient.get(ApiEndpoints.prescriptions);
    // The response data is expected to contain { "prescriptions": [...] }
    return PrescriptionsResponse.fromJson(response.data);
  }
}
