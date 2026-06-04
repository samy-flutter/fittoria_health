// ignore_for_file: invalid_annotation_target
import 'package:freezed_annotation/freezed_annotation.dart';

part 'clinic.freezed.dart';
part 'clinic.g.dart';

@freezed
class Clinic with _$Clinic {
  const factory Clinic({
    required int id,
    required String name,
    String? address,
    String? city,
    String? state,
    @JsonKey(fromJson: _parseString) String? phone,
    @JsonKey(name: 'clinic_type') String? clinicType,
    @JsonKey(fromJson: _parseDouble) double? latitude,
    @JsonKey(fromJson: _parseDouble) double? longitude,
    @JsonKey(fromJson: _parseDouble) double? rating,
    @JsonKey(name: 'doctor_count', fromJson: _parseInt) int? doctorCount,
    @JsonKey(name: 'consultation_fee', fromJson: _parseDouble) double? consultationFee,
    @JsonKey(name: 'logo_url') String? logoUrl,
  }) = _Clinic;

  factory Clinic.fromJson(Map<String, dynamic> json) =>
      _$ClinicFromJson(json);
}

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

String? _parseString(dynamic value) {
  if (value == null) return null;
  return value.toString();
}
