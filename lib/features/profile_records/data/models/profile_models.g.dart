// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'profile_models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$LookupItemImpl _$$LookupItemImplFromJson(Map<String, dynamic> json) =>
    _$LookupItemImpl(
      id: (json['id'] as num).toInt(),
      name: json['name'] as String,
    );

Map<String, dynamic> _$$LookupItemImplToJson(_$LookupItemImpl instance) =>
    <String, dynamic>{'id': instance.id, 'name': instance.name};

_$PatientProfileImpl _$$PatientProfileImplFromJson(Map<String, dynamic> json) =>
    _$PatientProfileImpl(
      id: (json['id'] as num).toInt(),
      fullName: json['full_name'] as String,
      phone: json['phone'] as String,
      email: json['email'] as String?,
      fittoriaId: json['fittoria_id'] as String?,
      genderId: (json['gender_id'] as num?)?.toInt(),
      genderName: json['gender_name'] as String?,
      bloodGroupId: (json['blood_group_id'] as num?)?.toInt(),
      bloodGroupName: json['blood_group_name'] as String?,
      dateOfBirth: json['date_of_birth'] as String?,
      addressLine1: json['address_line1'] as String?,
      city: json['city'] as String?,
      state: json['state'] as String?,
      pincode: json['pincode'] as String?,
      emergencyName: json['emergency_name'] as String?,
      emergencyPhone: json['emergency_phone'] as String?,
      emergencyRelation: json['emergency_relation'] as String?,
      heightCm: (json['height_cm'] as num?)?.toDouble(),
      weightKg: (json['weight_kg'] as num?)?.toDouble(),
      allergies: json['allergies'] as String?,
      currentMedications: json['current_medications'] as String?,
      registeredAt: json['registered_at'] as String,
    );

Map<String, dynamic> _$$PatientProfileImplToJson(
  _$PatientProfileImpl instance,
) => <String, dynamic>{
  'id': instance.id,
  'full_name': instance.fullName,
  'phone': instance.phone,
  'email': instance.email,
  'fittoria_id': instance.fittoriaId,
  'gender_id': instance.genderId,
  'gender_name': instance.genderName,
  'blood_group_id': instance.bloodGroupId,
  'blood_group_name': instance.bloodGroupName,
  'date_of_birth': instance.dateOfBirth,
  'address_line1': instance.addressLine1,
  'city': instance.city,
  'state': instance.state,
  'pincode': instance.pincode,
  'emergency_name': instance.emergencyName,
  'emergency_phone': instance.emergencyPhone,
  'emergency_relation': instance.emergencyRelation,
  'height_cm': instance.heightCm,
  'weight_kg': instance.weightKg,
  'allergies': instance.allergies,
  'current_medications': instance.currentMedications,
  'registered_at': instance.registeredAt,
};

_$ProfileResponseImpl _$$ProfileResponseImplFromJson(
  Map<String, dynamic> json,
) => _$ProfileResponseImpl(
  patient: PatientProfile.fromJson(json['patient'] as Map<String, dynamic>),
  genders: (json['genders'] as List<dynamic>)
      .map((e) => LookupItem.fromJson(e as Map<String, dynamic>))
      .toList(),
  bloodGroups: (json['blood_groups'] as List<dynamic>)
      .map((e) => LookupItem.fromJson(e as Map<String, dynamic>))
      .toList(),
  medicalHistory: (json['medical_history'] as List<dynamic>)
      .map((e) => MedicalHistoryItem.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$$ProfileResponseImplToJson(
  _$ProfileResponseImpl instance,
) => <String, dynamic>{
  'patient': instance.patient,
  'genders': instance.genders,
  'blood_groups': instance.bloodGroups,
  'medical_history': instance.medicalHistory,
};
