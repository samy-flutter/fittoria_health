import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../data/models/lab_referral.dart';
import '../../data/models/lab_report.dart';

abstract class LabRepository {
  Future<Either<Failure, LabReferralsResponse>> getLabReferrals();
  Future<Either<Failure, LabReferralDetailResponse>> getLabReferralDetails(int id);
  Future<Either<Failure, void>> confirmLabReferral(int id);
  Future<Either<Failure, void>> cancelLabReferral(int id);
  Future<Either<Failure, List<LabReport>>> getLabReports();
}
