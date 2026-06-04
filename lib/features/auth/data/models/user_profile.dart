// ignore_for_file: invalid_annotation_target
import 'package:freezed_annotation/freezed_annotation.dart';

part 'user_profile.freezed.dart';
part 'user_profile.g.dart';

@freezed
class UserProfile with _$UserProfile {
  const factory UserProfile({
    required int id,
    @JsonKey(name: 'full_name') required String fullName,
    required String phone,
    required String email,
    @JsonKey(name: 'patient_code') String? patientCode,
    String? gender,
    String? dob,
    @JsonKey(name: 'blood_group') String? bloodGroup,
    double? weight,
    double? height,
    @JsonKey(name: 'profile_picture') String? profilePicture,
    @JsonKey(name: 'emergency_contact_name') String? emergencyContactName,
    @JsonKey(name: 'emergency_contact_phone') String? emergencyContactPhone,
    @JsonKey(name: 'emergency_contact_relation') String? emergencyContactRelation,
  }) = _UserProfile;

  factory UserProfile.fromJson(Map<String, dynamic> json) =>
      _$UserProfileFromJson(json);
}
