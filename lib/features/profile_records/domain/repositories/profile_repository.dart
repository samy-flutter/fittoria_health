import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../data/models/profile_models.dart';

abstract class ProfileRepository {
  Future<Either<Failure, ProfileResponse>> getProfile();
  Future<Either<Failure, PatientProfile>> updateProfile(Map<String, dynamic> updateData);
}
