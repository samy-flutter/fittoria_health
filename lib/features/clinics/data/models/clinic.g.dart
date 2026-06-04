// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'clinic.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ClinicImpl _$$ClinicImplFromJson(Map<String, dynamic> json) => _$ClinicImpl(
  id: (json['id'] as num).toInt(),
  name: json['name'] as String,
  address: json['address'] as String?,
  city: json['city'] as String?,
  state: json['state'] as String?,
  phone: _parseString(json['phone']),
  clinicType: json['clinic_type'] as String?,
  latitude: _parseDouble(json['latitude']),
  longitude: _parseDouble(json['longitude']),
  rating: _parseDouble(json['rating']),
  doctorCount: _parseInt(json['doctor_count']),
  consultationFee: _parseDouble(json['consultation_fee']),
  logoUrl: json['logo_url'] as String?,
);

Map<String, dynamic> _$$ClinicImplToJson(_$ClinicImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'address': instance.address,
      'city': instance.city,
      'state': instance.state,
      'phone': instance.phone,
      'clinic_type': instance.clinicType,
      'latitude': instance.latitude,
      'longitude': instance.longitude,
      'rating': instance.rating,
      'doctor_count': instance.doctorCount,
      'consultation_fee': instance.consultationFee,
      'logo_url': instance.logoUrl,
    };
