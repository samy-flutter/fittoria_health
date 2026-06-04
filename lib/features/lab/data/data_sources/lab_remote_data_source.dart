import '../../../../core/network/dio_client.dart';
import '../../../../core/network/api_endpoints.dart';
import '../models/lab_referral.dart';
import '../models/lab_report.dart';

abstract class LabRemoteDataSource {
  Future<LabReferralsResponse> getLabReferrals();
  Future<LabReferralDetailResponse> getLabReferralDetails(int id);
  Future<void> confirmLabReferral(int id);
  Future<void> cancelLabReferral(int id);
  Future<LabReportsResponse> getLabReports();
}

class LabRemoteDataSourceImpl implements LabRemoteDataSource {
  final DioClient _dioClient;

  LabRemoteDataSourceImpl(this._dioClient);

  @override
  Future<LabReferralsResponse> getLabReferrals() async {
    final response = await _dioClient.get(ApiEndpoints.labReferrals);
    return LabReferralsResponse.fromJson(response.data);
  }

  @override
  Future<LabReferralDetailResponse> getLabReferralDetails(int id) async {
    final response = await _dioClient.get(ApiEndpoints.labReferralDetails(id));
    return LabReferralDetailResponse.fromJson(response.data);
  }

  @override
  Future<void> confirmLabReferral(int id) async {
    await _dioClient.patch(
      ApiEndpoints.labReferralDetails(id),
      data: {'action': 'confirm'},
    );
  }

  @override
  Future<void> cancelLabReferral(int id) async {
    await _dioClient.patch(
      ApiEndpoints.labReferralDetails(id),
      data: {'action': 'cancel'},
    );
  }

  @override
  Future<LabReportsResponse> getLabReports() async {
    final response = await _dioClient.get(ApiEndpoints.labReports);
    return LabReportsResponse.fromJson(response.data);
  }
}
