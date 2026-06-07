// ignore_for_file: invalid_annotation_target
import 'package:freezed_annotation/freezed_annotation.dart';
import 'records.dart'; // for MedicalHistoryItem

part 'profile_models.freezed.dart';
part 'profile_models.g.dart';

double? _parseDouble(dynamic value) {
  if (value == null) return null;
  if (value is num) return value.toDouble();
  if (value is String) return double.tryParse(value);
  return null;
}

int? _parseInt(dynamic value) {
  if (value == null) return null;
  if (value is num) return value.toInt();
  if (value is String) return int.tryParse(value);
  return null;
}

int _parseIntRequired(dynamic value) {
  if (value is num) return value.toInt();
  if (value is String) return int.tryParse(value) ?? 0;
  return 0;
}


@freezed
class LookupItem with _$LookupItem {
  const factory LookupItem({
    @JsonKey(fromJson: _parseIntRequired) required int id,
    required String name,
  }) = _LookupItem;

  factory LookupItem.fromJson(Map<String, dynamic> json) =>
      _$LookupItemFromJson(json);
}

@freezed
class PatientProfile with _$PatientProfile {
  const factory PatientProfile({
    @JsonKey(fromJson: _parseIntRequired) required int id,
    @JsonKey(name: 'full_name') required String fullName,
    required String phone,
    String? email,
    @JsonKey(name: 'fittoria_id') String? fittoriaId,
    @JsonKey(name: 'gender_id', fromJson: _parseInt) int? genderId,
    @JsonKey(name: 'gender_name') String? genderName,
    @JsonKey(name: 'blood_group_id', fromJson: _parseInt) int? bloodGroupId,
    @JsonKey(name: 'blood_group_name') String? bloodGroupName,
    @JsonKey(name: 'date_of_birth') String? dateOfBirth,
    @JsonKey(name: 'address_line1') String? addressLine1,
    String? city,
    String? state,
    String? pincode,
    @JsonKey(name: 'emergency_name') String? emergencyName,
    @JsonKey(name: 'emergency_phone') String? emergencyPhone,
    @JsonKey(name: 'emergency_relation') String? emergencyRelation,
    @JsonKey(name: 'height_cm', fromJson: _parseDouble) double? heightCm,
    @JsonKey(name: 'weight_kg', fromJson: _parseDouble) double? weightKg,
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
