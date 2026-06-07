// ignore_for_file: invalid_annotation_target
import 'package:freezed_annotation/freezed_annotation.dart';

part 'records.freezed.dart';
part 'records.g.dart';

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
class PatientRecordProfile with _$PatientRecordProfile {
  const factory PatientRecordProfile({
    @JsonKey(fromJson: _parseIntRequired) required int id,
    @JsonKey(name: 'full_name') required String fullName,
    String? allergies,
    @JsonKey(name: 'current_medications') String? currentMedications,
    @JsonKey(name: 'blood_group_id', fromJson: _parseInt) int? bloodGroupId,
    @JsonKey(name: 'blood_group_name') String? bloodGroupName,
    @JsonKey(name: 'height_cm', fromJson: _parseDouble) double? heightCm,
    @JsonKey(name: 'weight_kg', fromJson: _parseDouble) double? weightKg,
  }) = _PatientRecordProfile;

  factory PatientRecordProfile.fromJson(Map<String, dynamic> json) =>
      _$PatientRecordProfileFromJson(json);
}

@freezed
class CaseSheet with _$CaseSheet {
  const factory CaseSheet({
    @JsonKey(fromJson: _parseIntRequired) required int id,
    @JsonKey(name: 'chief_complaint') String? chiefComplaint,
    @JsonKey(name: 'history_of_illness') String? historyOfIllness,
    String? diagnosis,
    String? plan,
    @JsonKey(name: 'bp_systolic', fromJson: _parseDouble) double? bpSystolic,
    @JsonKey(name: 'bp_diastolic', fromJson: _parseDouble) double? bpDiastolic,
    @JsonKey(name: 'pulse_bpm', fromJson: _parseDouble) double? pulseBpm,
    @JsonKey(name: 'temperature_f', fromJson: _parseDouble) double? temperatureF,
    @JsonKey(name: 'spo2_percent', fromJson: _parseDouble) double? spo2Percent,
    @JsonKey(name: 'weight_kg', fromJson: _parseDouble) double? weightKg,
    @JsonKey(name: 'height_cm', fromJson: _parseDouble) double? heightCm,
    @JsonKey(fromJson: _parseDouble) double? bmi,
    @JsonKey(name: 'general_examination') String? generalExamination,
    @JsonKey(name: 'systemic_examination') String? systemicExamination,
    @JsonKey(name: 'follow_up_date') String? followUpDate,
    @JsonKey(name: 'created_at') required String createdAt,
    @JsonKey(name: 'doctor_name') required String doctorName,
    @JsonKey(name: 'clinic_name') required String clinicName,
    @JsonKey(name: 'clinic_city') String? clinicCity,
  }) = _CaseSheet;

  factory CaseSheet.fromJson(Map<String, dynamic> json) =>
      _$CaseSheetFromJson(json);
}

@freezed
class MedicalHistoryItem with _$MedicalHistoryItem {
  const factory MedicalHistoryItem({
    @JsonKey(fromJson: _parseIntRequired) required int id,
    @JsonKey(name: 'condition_name') required String conditionName,
    @JsonKey(name: 'diagnosed_at') String? diagnosedAt,
    String? notes,
    @JsonKey(name: 'created_at') required String createdAt,
  }) = _MedicalHistoryItem;

  factory MedicalHistoryItem.fromJson(Map<String, dynamic> json) =>
      _$MedicalHistoryItemFromJson(json);
}

@freezed
class RecordsResponse with _$RecordsResponse {
  const factory RecordsResponse({
    PatientRecordProfile? patient,
    @JsonKey(name: 'case_sheets') required List<CaseSheet> caseSheets,
    @JsonKey(name: 'medical_history') required List<MedicalHistoryItem> medicalHistory,
  }) = _RecordsResponse;

  factory RecordsResponse.fromJson(Map<String, dynamic> json) =>
      _$RecordsResponseFromJson(json);
}
