// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'lab_report.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$LabReportItemImpl _$$LabReportItemImplFromJson(Map<String, dynamic> json) =>
    _$LabReportItemImpl(
      testName: json['test_name'] as String,
      testCode: json['test_code'] as String?,
      resultValue: json['result_value'] as String?,
      resultUnit: json['result_unit'] as String?,
      referenceRange: json['reference_range'] as String?,
      isAbnormal: json['is_abnormal'] as bool? ?? false,
    );

Map<String, dynamic> _$$LabReportItemImplToJson(_$LabReportItemImpl instance) =>
    <String, dynamic>{
      'test_name': instance.testName,
      'test_code': instance.testCode,
      'result_value': instance.resultValue,
      'result_unit': instance.resultUnit,
      'reference_range': instance.referenceRange,
      'is_abnormal': instance.isAbnormal,
    };

_$LabReportImpl _$$LabReportImplFromJson(Map<String, dynamic> json) =>
    _$LabReportImpl(
      id: (json['id'] as num).toInt(),
      status: json['status'] as String,
      notes: json['notes'] as String?,
      orderedByName: json['ordered_by_name'] as String,
      clinicName: json['clinic_name'] as String,
      orderedAt: json['ordered_at'] as String,
      items: (json['items'] as List<dynamic>)
          .map((e) => LabReportItem.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$$LabReportImplToJson(_$LabReportImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'status': instance.status,
      'notes': instance.notes,
      'ordered_by_name': instance.orderedByName,
      'clinic_name': instance.clinicName,
      'ordered_at': instance.orderedAt,
      'items': instance.items,
    };

_$LabReportsResponseImpl _$$LabReportsResponseImplFromJson(
  Map<String, dynamic> json,
) => _$LabReportsResponseImpl(
  orders: (json['orders'] as List<dynamic>)
      .map((e) => LabReport.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$$LabReportsResponseImplToJson(
  _$LabReportsResponseImpl instance,
) => <String, dynamic>{'orders': instance.orders};
