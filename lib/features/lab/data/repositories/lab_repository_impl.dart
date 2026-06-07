import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/error/exception_handler.dart';
import '../../domain/repositories/lab_repository.dart';
import '../data_sources/lab_remote_data_source.dart';
import '../models/lab_referral.dart';
import '../models/lab_report.dart';

class LabRepositoryImpl implements LabRepository {
  final LabRemoteDataSource _remoteDataSource;

  LabRepositoryImpl(this._remoteDataSource);

  @override
  Future<Either<Failure, LabReferralsResponse>> getLabReferrals() async {
    try {
      final response = await _remoteDataSource.getLabReferrals();
      return Right(response);
    } catch (e) {
      return Left(ExceptionHandler.handle(e));
    }
  }

  @override
  Future<Either<Failure, LabReferralDetailResponse>> getLabReferralDetails(int id) async {
    try {
      final response = await _remoteDataSource.getLabReferralDetails(id);
      return Right(response);
    } catch (e) {
      return Left(ExceptionHandler.handle(e));
    }
  }

  @override
  Future<Either<Failure, void>> confirmLabReferral(int id) async {
    try {
      await _remoteDataSource.confirmLabReferral(id);
      return const Right(null);
    } catch (e) {
      return Left(ExceptionHandler.handle(e));
    }
  }

  @override
  Future<Either<Failure, void>> cancelLabReferral(int id) async {
    try {
      await _remoteDataSource.cancelLabReferral(id);
      return const Right(null);
    } catch (e) {
      return Left(ExceptionHandler.handle(e));
    }
  }

  @override
  Future<Either<Failure, List<LabReport>>> getLabReports() async {
    try {
      final response = await _remoteDataSource.getLabReports();
      return Right(response.orders);
    } catch (e) {
      return Left(ExceptionHandler.handle(e));
    }
  }
}
