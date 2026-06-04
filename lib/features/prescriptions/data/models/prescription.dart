// ignore_for_file: invalid_annotation_target
import 'package:freezed_annotation/freezed_annotation.dart';

part 'prescription.freezed.dart';
part 'prescription.g.dart';

@freezed
class PrescriptionItem with _$PrescriptionItem {
  const factory PrescriptionItem({
    @JsonKey(name: 'prescription_id') required int prescriptionId,
    @JsonKey(name: 'drug_name') required String drugName,
    @JsonKey(name: 'brand_name') String? brandName,
    String? dosage,
    String? frequency,
    String? duration,
    String? route,
    String? instructions,
  }) = _PrescriptionItem;

  factory PrescriptionItem.fromJson(Map<String, dynamic> json) =>
      _$PrescriptionItemFromJson(json);
}

@freezed
class Prescription with _$Prescription {
  const factory Prescription({
    required int id,
    String? notes,
    @JsonKey(name: 'created_at') required String createdAt,
    @JsonKey(name: 'doctor_name') required String doctorName,
    @JsonKey(name: 'clinic_name') required String clinicName,
    @JsonKey(name: 'clinic_city') String? clinicCity,
    String? diagnosis,
    required List<PrescriptionItem> items,
  }) = _Prescription;

  factory Prescription.fromJson(Map<String, dynamic> json) =>
      _$PrescriptionFromJson(json);
}

@freezed
class PrescriptionsResponse with _$PrescriptionsResponse {
  const factory PrescriptionsResponse({
    required List<Prescription> prescriptions,
  }) = _PrescriptionsResponse;

  factory PrescriptionsResponse.fromJson(Map<String, dynamic> json) =>
      _$PrescriptionsResponseFromJson(json);
}
