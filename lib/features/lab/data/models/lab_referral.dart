// ignore_for_file: invalid_annotation_target
import 'package:freezed_annotation/freezed_annotation.dart';

part 'lab_referral.freezed.dart';
part 'lab_referral.g.dart';

@freezed
class LabReferral with _$LabReferral {
  const factory LabReferral({
    required int id,
    @JsonKey(name: 'test_name') required String testName,
    String? description,
    @JsonKey(name: 'service_mode') required String serviceMode, // 'lab_visit' | 'home_collection'
    required String status,
    @JsonKey(name: 'quoted_price') double? quotedPrice,
    @JsonKey(name: 'platform_commission') double? platformCommission,
    @JsonKey(name: 'slot_datetime') String? slotDatetime,
    @JsonKey(name: 'slot_notes') String? slotNotes,
    @JsonKey(name: 'report_url') String? reportUrl,
    @JsonKey(name: 'result_notes') String? resultNotes,
    @JsonKey(name: 'collection_address') String? collectionAddress,
    @JsonKey(name: 'collection_city') String? collectionCity,
    @JsonKey(name: 'collection_pincode') String? collectionPincode,
    @JsonKey(name: 'created_at') required String createdAt,
    @JsonKey(name: 'updated_at') String? updatedAt,
    @JsonKey(name: 'doctor_name') required String doctorName,
    @JsonKey(name: 'doctor_phone') String? doctorPhone,
    @JsonKey(name: 'clinic_name') required String clinicName,
    @JsonKey(name: 'clinic_phone') String? clinicPhone,
    @JsonKey(name: 'clinic_address') String? clinicAddress,
    @JsonKey(name: 'lab_name') String? labName,
    @JsonKey(name: 'lab_phone') String? labPhone,
    @JsonKey(name: 'lab_email') String? labEmail,
    @JsonKey(name: 'lab_address') String? labAddress,
    @JsonKey(name: 'lab_city') String? labCity,
    @JsonKey(name: 'nabl_accredited') int? nablAccredited,
    @JsonKey(name: 'iso_certified') int? isoCertified,
  }) = _LabReferral;

  factory LabReferral.fromJson(Map<String, dynamic> json) =>
      _$LabReferralFromJson(json);
}

@freezed
class LabReferralNotification with _$LabReferralNotification {
  const factory LabReferralNotification({
    required int id,
    @JsonKey(name: 'lab_referral_id') int? labReferralId,
    @JsonKey(name: 'event_type') required String eventType,
    required String title,
    required String body,
    @JsonKey(name: 'is_read') required int isRead,
    @JsonKey(name: 'created_at') required String createdAt,
  }) = _LabReferralNotification;

  factory LabReferralNotification.fromJson(Map<String, dynamic> json) =>
      _$LabReferralNotificationFromJson(json);
}

@freezed
class LabReferralsResponse with _$LabReferralsResponse {
  const factory LabReferralsResponse({
    required List<LabReferral> referrals,
    required List<LabReferralNotification> notifications,
  }) = _LabReferralsResponse;

  factory LabReferralsResponse.fromJson(Map<String, dynamic> json) =>
      _$LabReferralsResponseFromJson(json);
}

@freezed
class LabReferralDetailResponse with _$LabReferralDetailResponse {
  const factory LabReferralDetailResponse({
    required LabReferral referral,
    required List<LabReferralNotification> notifications,
  }) = _LabReferralDetailResponse;

  factory LabReferralDetailResponse.fromJson(Map<String, dynamic> json) =>
      _$LabReferralDetailResponseFromJson(json);
}
