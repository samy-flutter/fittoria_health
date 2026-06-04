// ignore_for_file: invalid_annotation_target
import 'package:freezed_annotation/freezed_annotation.dart';

part 'lab_report.freezed.dart';
part 'lab_report.g.dart';

@freezed
class LabReportItem with _$LabReportItem {
  const factory LabReportItem({
    @JsonKey(name: 'test_name') required String testName,
    @JsonKey(name: 'test_code') String? testCode,
    @JsonKey(name: 'result_value') String? resultValue,
    @JsonKey(name: 'result_unit') String? resultUnit,
    @JsonKey(name: 'reference_range') String? referenceRange,
    @JsonKey(name: 'is_abnormal') @Default(false) bool isAbnormal,
  }) = _LabReportItem;

  factory LabReportItem.fromJson(Map<String, dynamic> json) =>
      _$LabReportItemFromJson(json);
}

@freezed
class LabReport with _$LabReport {
  const factory LabReport({
    required int id,
    required String status, // 'ordered' | 'collected' | 'processing' | 'completed'
    String? notes,
    @JsonKey(name: 'ordered_by_name') required String orderedByName,
    @JsonKey(name: 'clinic_name') required String clinicName,
    @JsonKey(name: 'ordered_at') required String orderedAt,
    required List<LabReportItem> items,
  }) = _LabReport;

  factory LabReport.fromJson(Map<String, dynamic> json) =>
      _$LabReportFromJson(json);
}

@freezed
class LabReportsResponse with _$LabReportsResponse {
  const factory LabReportsResponse({
    required List<LabReport> orders,
  }) = _LabReportsResponse;

  factory LabReportsResponse.fromJson(Map<String, dynamic> json) =>
      _$LabReportsResponseFromJson(json);
}
