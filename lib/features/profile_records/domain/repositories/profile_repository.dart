import '../../data/models/profile_models.dart';

abstract class ProfileRepository {
  Future<ProfileResponse> getProfile();
  Future<PatientProfile> updateProfile(Map<String, dynamic> updateData);
}
