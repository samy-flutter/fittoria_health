// ignore_for_file: invalid_annotation_target
import 'package:freezed_annotation/freezed_annotation.dart';

part 'appointment.freezed.dart';
part 'appointment.g.dart';

@freezed
class Appointment with _$Appointment {
  const factory Appointment({
    required int id,
    required String status, // scheduled, waiting, in_consultation, completed, cancelled, no_show
    @JsonKey(name: 'clinic_name') required String clinicName,
    @JsonKey(name: 'doctor_name') required String doctorName,
    @JsonKey(name: 'appointment_date') required String appointmentDate,
    @JsonKey(name: 'slot_start') required String slotStart,
    @JsonKey(name: 'slot_end') String? slotEnd,
    @JsonKey(name: 'clinic_city') String? clinicCity,
    @JsonKey(name: 'visit_type') String? visitType, // e.g. "online", "physical"
    @JsonKey(name: 'chief_complaint') String? chiefComplaint,
    @JsonKey(name: 'clinic_phone') String? clinicPhone,
  }) = _Appointment;

  factory Appointment.fromJson(Map<String, dynamic> json) =>
      _$AppointmentFromJson(json);
}
