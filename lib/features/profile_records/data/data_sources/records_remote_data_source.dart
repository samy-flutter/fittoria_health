import '../../../../core/network/dio_client.dart';
import '../../../../core/network/api_endpoints.dart';
import '../models/records.dart';

abstract class RecordsRemoteDataSource {
  Future<RecordsResponse> getRecords();
}

class RecordsRemoteDataSourceImpl implements RecordsRemoteDataSource {
  final DioClient _dioClient;

  RecordsRemoteDataSourceImpl(this._dioClient);

  @override
  Future<RecordsResponse> getRecords() async {
    final response = await _dioClient.get(ApiEndpoints.records);
    return RecordsResponse.fromJson(response.data);
  }
}
