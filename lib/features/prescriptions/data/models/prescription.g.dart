// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'prescription.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$PrescriptionItemImpl _$$PrescriptionItemImplFromJson(
  Map<String, dynamic> json,
) => _$PrescriptionItemImpl(
  prescriptionId: (json['prescription_id'] as num).toInt(),
  drugName: json['drug_name'] as String,
  brandName: json['brand_name'] as String?,
  dosage: json['dosage'] as String?,
  frequency: json['frequency'] as String?,
  duration: json['duration'] as String?,
  route: json['route'] as String?,
  instructions: json['instructions'] as String?,
);

Map<String, dynamic> _$$PrescriptionItemImplToJson(
  _$PrescriptionItemImpl instance,
) => <String, dynamic>{
  'prescription_id': instance.prescriptionId,
  'drug_name': instance.drugName,
  'brand_name': instance.brandName,
  'dosage': instance.dosage,
  'frequency': instance.frequency,
  'duration': instance.duration,
  'route': instance.route,
  'instructions': instance.instructions,
};

_$PrescriptionImpl _$$PrescriptionImplFromJson(Map<String, dynamic> json) =>
    _$PrescriptionImpl(
      id: (json['id'] as num).toInt(),
      notes: json['notes'] as String?,
      createdAt: json['created_at'] as String,
      doctorName: json['doctor_name'] as String,
      clinicName: json['clinic_name'] as String,
      clinicCity: json['clinic_city'] as String?,
      diagnosis: json['diagnosis'] as String?,
      items: (json['items'] as List<dynamic>)
          .map((e) => PrescriptionItem.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$$PrescriptionImplToJson(_$PrescriptionImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'notes': instance.notes,
      'created_at': instance.createdAt,
      'doctor_name': instance.doctorName,
      'clinic_name': instance.clinicName,
      'clinic_city': instance.clinicCity,
      'diagnosis': instance.diagnosis,
      'items': instance.items,
    };

_$PrescriptionsResponseImpl _$$PrescriptionsResponseImplFromJson(
  Map<String, dynamic> json,
) => _$PrescriptionsResponseImpl(
  prescriptions: (json['prescriptions'] as List<dynamic>)
      .map((e) => Prescription.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$$PrescriptionsResponseImplToJson(
  _$PrescriptionsResponseImpl instance,
) => <String, dynamic>{'prescriptions': instance.prescriptions};
