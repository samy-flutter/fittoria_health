// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'lab_referral.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$LabReferralImpl _$$LabReferralImplFromJson(Map<String, dynamic> json) =>
    _$LabReferralImpl(
      id: (json['id'] as num).toInt(),
      testName: json['test_name'] as String,
      description: json['description'] as String?,
      serviceMode: json['service_mode'] as String,
      status: json['status'] as String,
      quotedPrice: (json['quoted_price'] as num?)?.toDouble(),
      platformCommission: (json['platform_commission'] as num?)?.toDouble(),
      slotDatetime: json['slot_datetime'] as String?,
      slotNotes: json['slot_notes'] as String?,
      reportUrl: json['report_url'] as String?,
      resultNotes: json['result_notes'] as String?,
      collectionAddress: json['collection_address'] as String?,
      collectionCity: json['collection_city'] as String?,
      collectionPincode: json['collection_pincode'] as String?,
      createdAt: json['created_at'] as String,
      updatedAt: json['updated_at'] as String?,
      doctorName: json['doctor_name'] as String,
      doctorPhone: json['doctor_phone'] as String?,
      clinicName: json['clinic_name'] as String,
      clinicPhone: json['clinic_phone'] as String?,
      clinicAddress: json['clinic_address'] as String?,
      labName: json['lab_name'] as String?,
      labPhone: json['lab_phone'] as String?,
      labEmail: json['lab_email'] as String?,
      labAddress: json['lab_address'] as String?,
      labCity: json['lab_city'] as String?,
      nablAccredited: (json['nabl_accredited'] as num?)?.toInt(),
      isoCertified: (json['iso_certified'] as num?)?.toInt(),
    );

Map<String, dynamic> _$$LabReferralImplToJson(_$LabReferralImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'test_name': instance.testName,
      'description': instance.description,
      'service_mode': instance.serviceMode,
      'status': instance.status,
      'quoted_price': instance.quotedPrice,
      'platform_commission': instance.platformCommission,
      'slot_datetime': instance.slotDatetime,
      'slot_notes': instance.slotNotes,
      'report_url': instance.reportUrl,
      'result_notes': instance.resultNotes,
      'collection_address': instance.collectionAddress,
      'collection_city': instance.collectionCity,
      'collection_pincode': instance.collectionPincode,
      'created_at': instance.createdAt,
      'updated_at': instance.updatedAt,
      'doctor_name': instance.doctorName,
      'doctor_phone': instance.doctorPhone,
      'clinic_name': instance.clinicName,
      'clinic_phone': instance.clinicPhone,
      'clinic_address': instance.clinicAddress,
      'lab_name': instance.labName,
      'lab_phone': instance.labPhone,
      'lab_email': instance.labEmail,
      'lab_address': instance.labAddress,
      'lab_city': instance.labCity,
      'nabl_accredited': instance.nablAccredited,
      'iso_certified': instance.isoCertified,
    };

_$LabReferralNotificationImpl _$$LabReferralNotificationImplFromJson(
  Map<String, dynamic> json,
) => _$LabReferralNotificationImpl(
  id: (json['id'] as num).toInt(),
  labReferralId: (json['lab_referral_id'] as num?)?.toInt(),
  eventType: json['event_type'] as String,
  title: json['title'] as String,
  body: json['body'] as String,
  isRead: (json['is_read'] as num).toInt(),
  createdAt: json['created_at'] as String,
);

Map<String, dynamic> _$$LabReferralNotificationImplToJson(
  _$LabReferralNotificationImpl instance,
) => <String, dynamic>{
  'id': instance.id,
  'lab_referral_id': instance.labReferralId,
  'event_type': instance.eventType,
  'title': instance.title,
  'body': instance.body,
  'is_read': instance.isRead,
  'created_at': instance.createdAt,
};

_$LabReferralsResponseImpl _$$LabReferralsResponseImplFromJson(
  Map<String, dynamic> json,
) => _$LabReferralsResponseImpl(
  referrals: (json['referrals'] as List<dynamic>)
      .map((e) => LabReferral.fromJson(e as Map<String, dynamic>))
      .toList(),
  notifications: (json['notifications'] as List<dynamic>)
      .map((e) => LabReferralNotification.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$$LabReferralsResponseImplToJson(
  _$LabReferralsResponseImpl instance,
) => <String, dynamic>{
  'referrals': instance.referrals,
  'notifications': instance.notifications,
};

_$LabReferralDetailResponseImpl _$$LabReferralDetailResponseImplFromJson(
  Map<String, dynamic> json,
) => _$LabReferralDetailResponseImpl(
  referral: LabReferral.fromJson(json['referral'] as Map<String, dynamic>),
  notifications: (json['notifications'] as List<dynamic>)
      .map((e) => LabReferralNotification.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$$LabReferralDetailResponseImplToJson(
  _$LabReferralDetailResponseImpl instance,
) => <String, dynamic>{
  'referral': instance.referral,
  'notifications': instance.notifications,
};
