import '../../domain/repositories/profile_repository.dart';
import '../data_sources/profile_remote_data_source.dart';
import '../models/profile_models.dart';

class ProfileRepositoryImpl implements ProfileRepository {
  final ProfileRemoteDataSource _remoteDataSource;

  ProfileRepositoryImpl(this._remoteDataSource);

  @override
  Future<ProfileResponse> getProfile() {
    return _remoteDataSource.getProfile();
  }

  @override
  Future<PatientProfile> updateProfile(Map<String, dynamic> updateData) {
    return _remoteDataSource.updateProfile(updateData);
  }
}
