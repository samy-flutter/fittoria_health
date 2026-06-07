// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'records.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$PatientRecordProfileImpl _$$PatientRecordProfileImplFromJson(
  Map<String, dynamic> json,
) => _$PatientRecordProfileImpl(
  id: _parseIntRequired(json['id']),
  fullName: json['full_name'] as String,
  allergies: json['allergies'] as String?,
  currentMedications: json['current_medications'] as String?,
  bloodGroupId: _parseInt(json['blood_group_id']),
  bloodGroupName: json['blood_group_name'] as String?,
  heightCm: _parseDouble(json['height_cm']),
  weightKg: _parseDouble(json['weight_kg']),
);

Map<String, dynamic> _$$PatientRecordProfileImplToJson(
  _$PatientRecordProfileImpl instance,
) => <String, dynamic>{
  'id': instance.id,
  'full_name': instance.fullName,
  'allergies': instance.allergies,
  'current_medications': instance.currentMedications,
  'blood_group_id': instance.bloodGroupId,
  'blood_group_name': instance.bloodGroupName,
  'height_cm': instance.heightCm,
  'weight_kg': instance.weightKg,
};

_$CaseSheetImpl _$$CaseSheetImplFromJson(Map<String, dynamic> json) =>
    _$CaseSheetImpl(
      id: _parseIntRequired(json['id']),
      chiefComplaint: json['chief_complaint'] as String?,
      historyOfIllness: json['history_of_illness'] as String?,
      diagnosis: json['diagnosis'] as String?,
      plan: json['plan'] as String?,
      bpSystolic: _parseDouble(json['bp_systolic']),
      bpDiastolic: _parseDouble(json['bp_diastolic']),
      pulseBpm: _parseDouble(json['pulse_bpm']),
      temperatureF: _parseDouble(json['temperature_f']),
      spo2Percent: _parseDouble(json['spo2_percent']),
      weightKg: _parseDouble(json['weight_kg']),
      heightCm: _parseDouble(json['height_cm']),
      bmi: _parseDouble(json['bmi']),
      generalExamination: json['general_examination'] as String?,
      systemicExamination: json['systemic_examination'] as String?,
      followUpDate: json['follow_up_date'] as String?,
      createdAt: json['created_at'] as String,
      doctorName: json['doctor_name'] as String,
      clinicName: json['clinic_name'] as String,
      clinicCity: json['clinic_city'] as String?,
    );

Map<String, dynamic> _$$CaseSheetImplToJson(_$CaseSheetImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'chief_complaint': instance.chiefComplaint,
      'history_of_illness': instance.historyOfIllness,
      'diagnosis': instance.diagnosis,
      'plan': instance.plan,
      'bp_systolic': instance.bpSystolic,
      'bp_diastolic': instance.bpDiastolic,
      'pulse_bpm': instance.pulseBpm,
      'temperature_f': instance.temperatureF,
      'spo2_percent': instance.spo2Percent,
      'weight_kg': instance.weightKg,
      'height_cm': instance.heightCm,
      'bmi': instance.bmi,
      'general_examination': instance.generalExamination,
      'systemic_examination': instance.systemicExamination,
      'follow_up_date': instance.followUpDate,
      'created_at': instance.createdAt,
      'doctor_name': instance.doctorName,
      'clinic_name': instance.clinicName,
      'clinic_city': instance.clinicCity,
    };

_$MedicalHistoryItemImpl _$$MedicalHistoryItemImplFromJson(
  Map<String, dynamic> json,
) => _$MedicalHistoryItemImpl(
  id: _parseIntRequired(json['id']),
  conditionName: json['condition_name'] as String,
  diagnosedAt: json['diagnosed_at'] as String?,
  notes: json['notes'] as String?,
  createdAt: json['created_at'] as String,
);

Map<String, dynamic> _$$MedicalHistoryItemImplToJson(
  _$MedicalHistoryItemImpl instance,
) => <String, dynamic>{
  'id': instance.id,
  'condition_name': instance.conditionName,
  'diagnosed_at': instance.diagnosedAt,
  'notes': instance.notes,
  'created_at': instance.createdAt,
};

_$RecordsResponseImpl _$$RecordsResponseImplFromJson(
  Map<String, dynamic> json,
) => _$RecordsResponseImpl(
  patient: json['patient'] == null
      ? null
      : PatientRecordProfile.fromJson(json['patient'] as Map<String, dynamic>),
  caseSheets: (json['case_sheets'] as List<dynamic>)
      .map((e) => CaseSheet.fromJson(e as Map<String, dynamic>))
      .toList(),
  medicalHistory: (json['medical_history'] as List<dynamic>)
      .map((e) => MedicalHistoryItem.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$$RecordsResponseImplToJson(
  _$RecordsResponseImpl instance,
) => <String, dynamic>{
  'patient': instance.patient,
  'case_sheets': instance.caseSheets,
  'medical_history': instance.medicalHistory,
};
