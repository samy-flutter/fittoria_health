import '../../domain/repositories/lab_repository.dart';
import '../data_sources/lab_remote_data_source.dart';
import '../models/lab_referral.dart';
import '../models/lab_report.dart';

class LabRepositoryImpl implements LabRepository {
  final LabRemoteDataSource _remoteDataSource;

  LabRepositoryImpl(this._remoteDataSource);

  @override
  Future<LabReferralsResponse> getLabReferrals() {
    return _remoteDataSource.getLabReferrals();
  }

  @override
  Future<LabReferralDetailResponse> getLabReferralDetails(int id) {
    return _remoteDataSource.getLabReferralDetails(id);
  }

  @override
  Future<void> confirmLabReferral(int id) {
    return _remoteDataSource.confirmLabReferral(id);
  }

  @override
  Future<void> cancelLabReferral(int id) {
    return _remoteDataSource.cancelLabReferral(id);
  }

  @override
  Future<List<LabReport>> getLabReports() async {
    final response = await _remoteDataSource.getLabReports();
    return response.orders;
  }
}
