// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_profile.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$UserProfileImpl _$$UserProfileImplFromJson(Map<String, dynamic> json) =>
    _$UserProfileImpl(
      id: (json['id'] as num).toInt(),
      fullName: json['full_name'] as String,
      phone: json['phone'] as String,
      email: json['email'] as String,
      patientCode: json['patient_code'] as String?,
      gender: json['gender'] as String?,
      dob: json['dob'] as String?,
      bloodGroup: json['blood_group'] as String?,
      weight: (json['weight'] as num?)?.toDouble(),
      height: (json['height'] as num?)?.toDouble(),
      profilePicture: json['profile_picture'] as String?,
      emergencyContactName: json['emergency_contact_name'] as String?,
      emergencyContactPhone: json['emergency_contact_phone'] as String?,
      emergencyContactRelation: json['emergency_contact_relation'] as String?,
    );

Map<String, dynamic> _$$UserProfileImplToJson(_$UserProfileImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'full_name': instance.fullName,
      'phone': instance.phone,
      'email': instance.email,
      'patient_code': instance.patientCode,
      'gender': instance.gender,
      'dob': instance.dob,
      'blood_group': instance.bloodGroup,
      'weight': instance.weight,
      'height': instance.height,
      'profile_picture': instance.profilePicture,
      'emergency_contact_name': instance.emergencyContactName,
      'emergency_contact_phone': instance.emergencyContactPhone,
      'emergency_contact_relation': instance.emergencyContactRelation,
    };
