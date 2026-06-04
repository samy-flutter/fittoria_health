// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'appointment.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$AppointmentImpl _$$AppointmentImplFromJson(Map<String, dynamic> json) =>
    _$AppointmentImpl(
      id: (json['id'] as num).toInt(),
      status: json['status'] as String,
      clinicName: json['clinic_name'] as String,
      doctorName: json['doctor_name'] as String,
      appointmentDate: json['appointment_date'] as String,
      slotStart: json['slot_start'] as String,
      slotEnd: json['slot_end'] as String?,
      clinicCity: json['clinic_city'] as String?,
      visitType: json['visit_type'] as String?,
      chiefComplaint: json['chief_complaint'] as String?,
      clinicPhone: json['clinic_phone'] as String?,
    );

Map<String, dynamic> _$$AppointmentImplToJson(_$AppointmentImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'status': instance.status,
      'clinic_name': instance.clinicName,
      'doctor_name': instance.doctorName,
      'appointment_date': instance.appointmentDate,
      'slot_start': instance.slotStart,
      'slot_end': instance.slotEnd,
      'clinic_city': instance.clinicCity,
      'visit_type': instance.visitType,
      'chief_complaint': instance.chiefComplaint,
      'clinic_phone': instance.clinicPhone,
    };
