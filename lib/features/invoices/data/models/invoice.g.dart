// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'invoice.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$PatientInvoiceImpl _$$PatientInvoiceImplFromJson(Map<String, dynamic> json) =>
    _$PatientInvoiceImpl(
      id: (json['id'] as num).toInt(),
      invoiceNo: json['invoice_no'] as String,
      totalAmount: (json['total_amount'] as num).toDouble(),
      paymentStatus: json['payment_status'] as String,
      paymentMode: json['payment_mode'] as String?,
      createdAt: json['created_at'] as String,
      appointmentId: (json['appointment_id'] as num?)?.toInt(),
      clinicName: json['clinic_name'] as String,
      itemsCount: (json['items_count'] as num?)?.toInt() ?? 1,
    );

Map<String, dynamic> _$$PatientInvoiceImplToJson(
  _$PatientInvoiceImpl instance,
) => <String, dynamic>{
  'id': instance.id,
  'invoice_no': instance.invoiceNo,
  'total_amount': instance.totalAmount,
  'payment_status': instance.paymentStatus,
  'payment_mode': instance.paymentMode,
  'created_at': instance.createdAt,
  'appointment_id': instance.appointmentId,
  'clinic_name': instance.clinicName,
  'items_count': instance.itemsCount,
};

_$InvoicesResponseImpl _$$InvoicesResponseImplFromJson(
  Map<String, dynamic> json,
) => _$InvoicesResponseImpl(
  invoices: (json['invoices'] as List<dynamic>)
      .map((e) => PatientInvoice.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$$InvoicesResponseImplToJson(
  _$InvoicesResponseImpl instance,
) => <String, dynamic>{'invoices': instance.invoices};
