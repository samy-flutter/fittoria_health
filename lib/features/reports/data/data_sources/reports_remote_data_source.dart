import '../../../../core/network/dio_client.dart';
import '../models/report_model.dart';

abstract class ReportsRemoteDataSource {
  Future<List<ReportModel>> getReports();
}

class ReportsRemoteDataSourceImpl implements ReportsRemoteDataSource {
  final DioClient _apiClient;

  ReportsRemoteDataSourceImpl(this._apiClient);

  @override
  Future<List<ReportModel>> getReports() async {
    final response = await _apiClient.get('/api/patient/reports');
    final reportsList = (response.data['reports'] as List?) ?? [];
    return reportsList.map((e) => ReportModel.fromJson(e)).toList();
  }
}
