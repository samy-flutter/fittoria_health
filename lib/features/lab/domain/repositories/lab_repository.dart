import '../../data/models/lab_referral.dart';
import '../../data/models/lab_report.dart';

abstract class LabRepository {
  Future<LabReferralsResponse> getLabReferrals();
  Future<LabReferralDetailResponse> getLabReferralDetails(int id);
  Future<void> confirmLabReferral(int id);
  Future<void> cancelLabReferral(int id);
  Future<List<LabReport>> getLabReports();
}
