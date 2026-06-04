// ignore_for_file: invalid_annotation_target
import 'package:freezed_annotation/freezed_annotation.dart';

part 'invoice.freezed.dart';
part 'invoice.g.dart';

@freezed
class PatientInvoice with _$PatientInvoice {
  const factory PatientInvoice({
    required int id,
    @JsonKey(name: 'invoice_no') required String invoiceNo,
    @JsonKey(name: 'total_amount') required double totalAmount,
    @JsonKey(name: 'payment_status') required String paymentStatus, // paid, pending, partial, cancelled, refunded
    @JsonKey(name: 'payment_mode') String? paymentMode,
    @JsonKey(name: 'created_at') required String createdAt,
    @JsonKey(name: 'appointment_id') int? appointmentId,
    @JsonKey(name: 'clinic_name') required String clinicName,
    @JsonKey(name: 'items_count') @Default(1) int itemsCount,
  }) = _PatientInvoice;

  factory PatientInvoice.fromJson(Map<String, dynamic> json) =>
      _$PatientInvoiceFromJson(json);
}

@freezed
class InvoicesResponse with _$InvoicesResponse {
  const factory InvoicesResponse({
    required List<PatientInvoice> invoices,
  }) = _InvoicesResponse;

  factory InvoicesResponse.fromJson(Map<String, dynamic> json) =>
      _$InvoicesResponseFromJson(json);
}
