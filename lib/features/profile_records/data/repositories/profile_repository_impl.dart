import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/error/exception_handler.dart';
import '../../domain/repositories/profile_repository.dart';
import '../data_sources/profile_remote_data_source.dart';
import '../models/profile_models.dart';

class ProfileRepositoryImpl implements ProfileRepository {
  final ProfileRemoteDataSource _remoteDataSource;

  ProfileRepositoryImpl(this._remoteDataSource);

  @override
  Future<Either<Failure, ProfileResponse>> getProfile() async {
    try {
      final response = await _remoteDataSource.getProfile();
      return Right(response);
    } catch (e) {
      return Left(ExceptionHandler.handle(e));
    }
  }

  @override
  Future<Either<Failure, PatientProfile>> updateProfile(Map<String, dynamic> updateData) async {
    try {
      final response = await _remoteDataSource.updateProfile(updateData);
      return Right(response);
    } catch (e) {
      return Left(ExceptionHandler.handle(e));
    }
  }
}
