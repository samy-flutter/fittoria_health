// ignore_for_file: invalid_annotation_target
import 'package:freezed_annotation/freezed_annotation.dart';
import 'records.dart'; // for MedicalHistoryItem

part 'profile_models.freezed.dart';
part 'profile_models.g.dart';

@freezed
class LookupItem with _$LookupItem {
  const factory LookupItem({
    required int id,
    required String name,
  }) = _LookupItem;

  factory LookupItem.fromJson(Map<String, dynamic> json) =>
      _$LookupItemFromJson(json);
}

@freezed
class PatientProfile with _$PatientProfile {
  const factory PatientProfile({
    required int id,
    @JsonKey(name: 'full_name') required String fullName,
    required String phone,
    String? email,
    @JsonKey(name: 'fittoria_id') String? fittoriaId,
    @JsonKey(name: 'gender_id') int? genderId,
    @JsonKey(name: 'gender_name') String? genderName,
    @JsonKey(name: 'blood_group_id') int? bloodGroupId,
    @JsonKey(name: 'blood_group_name') String? bloodGroupName,
    @JsonKey(name: 'date_of_birth') String? dateOfBirth,
    @JsonKey(name: 'address_line1') String? addressLine1,
    String? city,
    String? state,
    String? pincode,
    @JsonKey(name: 'emergency_name') String? emergencyName,
    @JsonKey(name: 'emergency_phone') String? emergencyPhone,
    @JsonKey(name: 'emergency_relation') String? emergencyRelation,
    @JsonKey(name: 'height_cm') double? heightCm,
    @JsonKey(name: 'weight_kg') double? weightKg,
    String? allergies,
    @JsonKey(name: 'current_medications') String? currentMedications,
    @JsonKey(name: 'registered_at') required String registeredAt,
  }) = _PatientProfile;

  factory PatientProfile.fromJson(Map<String, dynamic> json) =>
      _$PatientProfileFromJson(json);
}

@freezed
class ProfileResponse with _$ProfileResponse {
  const factory ProfileResponse({
    required PatientProfile patient,
    required List<LookupItem> genders,
    @JsonKey(name: 'blood_groups') required List<LookupItem> bloodGroups,
    @JsonKey(name: 'medical_history') required List<MedicalHistoryItem> medicalHistory,
  }) = _ProfileResponse;

  factory ProfileResponse.fromJson(Map<String, dynamic> json) =>
      _$ProfileResponseFromJson(json);
}
