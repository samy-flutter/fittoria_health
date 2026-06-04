// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'lab_referral.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

LabReferral _$LabReferralFromJson(Map<String, dynamic> json) {
  return _LabReferral.fromJson(json);
}

/// @nodoc
mixin _$LabReferral {
  int get id => throw _privateConstructorUsedError;
  @JsonKey(name: 'test_name')
  String get testName => throw _privateConstructorUsedError;
  String? get description => throw _privateConstructorUsedError;
  @JsonKey(name: 'service_mode')
  String get serviceMode => throw _privateConstructorUsedError; // 'lab_visit' | 'home_collection'
  String get status => throw _privateConstructorUsedError;
  @JsonKey(name: 'quoted_price')
  double? get quotedPrice => throw _privateConstructorUsedError;
  @JsonKey(name: 'platform_commission')
  double? get platformCommission => throw _privateConstructorUsedError;
  @JsonKey(name: 'slot_datetime')
  String? get slotDatetime => throw _privateConstructorUsedError;
  @JsonKey(name: 'slot_notes')
  String? get slotNotes => throw _privateConstructorUsedError;
  @JsonKey(name: 'report_url')
  String? get reportUrl => throw _privateConstructorUsedError;
  @JsonKey(name: 'result_notes')
  String? get resultNotes => throw _privateConstructorUsedError;
  @JsonKey(name: 'collection_address')
  String? get collectionAddress => throw _privateConstructorUsedError;
  @JsonKey(name: 'collection_city')
  String? get collectionCity => throw _privateConstructorUsedError;
  @JsonKey(name: 'collection_pincode')
  String? get collectionPincode => throw _privateConstructorUsedError;
  @JsonKey(name: 'created_at')
  String get createdAt => throw _privateConstructorUsedError;
  @JsonKey(name: 'updated_at')
  String? get updatedAt => throw _privateConstructorUsedError;
  @JsonKey(name: 'doctor_name')
  String get doctorName => throw _privateConstructorUsedError;
  @JsonKey(name: 'doctor_phone')
  String? get doctorPhone => throw _privateConstructorUsedError;
  @JsonKey(name: 'clinic_name')
  String get clinicName => throw _privateConstructorUsedError;
  @JsonKey(name: 'clinic_phone')
  String? get clinicPhone => throw _privateConstructorUsedError;
  @JsonKey(name: 'clinic_address')
  String? get clinicAddress => throw _privateConstructorUsedError;
  @JsonKey(name: 'lab_name')
  String? get labName => throw _privateConstructorUsedError;
  @JsonKey(name: 'lab_phone')
  String? get labPhone => throw _privateConstructorUsedError;
  @JsonKey(name: 'lab_email')
  String? get labEmail => throw _privateConstructorUsedError;
  @JsonKey(name: 'lab_address')
  String? get labAddress => throw _privateConstructorUsedError;
  @JsonKey(name: 'lab_city')
  String? get labCity => throw _privateConstructorUsedError;
  @JsonKey(name: 'nabl_accredited')
  int? get nablAccredited => throw _privateConstructorUsedError;
  @JsonKey(name: 'iso_certified')
  int? get isoCertified => throw _privateConstructorUsedError;

  /// Serializes this LabReferral to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of LabReferral
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $LabReferralCopyWith<LabReferral> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $LabReferralCopyWith<$Res> {
  factory $LabReferralCopyWith(
    LabReferral value,
    $Res Function(LabReferral) then,
  ) = _$LabReferralCopyWithImpl<$Res, LabReferral>;
  @useResult
  $Res call({
    int id,
    @JsonKey(name: 'test_name') String testName,
    String? description,
    @JsonKey(name: 'service_mode') String serviceMode,
    String status,
    @JsonKey(name: 'quoted_price') double? quotedPrice,
    @JsonKey(name: 'platform_commission') double? platformCommission,
    @JsonKey(name: 'slot_datetime') String? slotDatetime,
    @JsonKey(name: 'slot_notes') String? slotNotes,
    @JsonKey(name: 'report_url') String? reportUrl,
    @JsonKey(name: 'result_notes') String? resultNotes,
    @JsonKey(name: 'collection_address') String? collectionAddress,
    @JsonKey(name: 'collection_city') String? collectionCity,
    @JsonKey(name: 'collection_pincode') String? collectionPincode,
    @JsonKey(name: 'created_at') String createdAt,
    @JsonKey(name: 'updated_at') String? updatedAt,
    @JsonKey(name: 'doctor_name') String doctorName,
    @JsonKey(name: 'doctor_phone') String? doctorPhone,
    @JsonKey(name: 'clinic_name') String clinicName,
    @JsonKey(name: 'clinic_phone') String? clinicPhone,
    @JsonKey(name: 'clinic_address') String? clinicAddress,
    @JsonKey(name: 'lab_name') String? labName,
    @JsonKey(name: 'lab_phone') String? labPhone,
    @JsonKey(name: 'lab_email') String? labEmail,
    @JsonKey(name: 'lab_address') String? labAddress,
    @JsonKey(name: 'lab_city') String? labCity,
    @JsonKey(name: 'nabl_accredited') int? nablAccredited,
    @JsonKey(name: 'iso_certified') int? isoCertified,
  });
}

/// @nodoc
class _$LabReferralCopyWithImpl<$Res, $Val extends LabReferral>
    implements $LabReferralCopyWith<$Res> {
  _$LabReferralCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of LabReferral
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? testName = null,
    Object? description = freezed,
    Object? serviceMode = null,
    Object? status = null,
    Object? quotedPrice = freezed,
    Object? platformCommission = freezed,
    Object? slotDatetime = freezed,
    Object? slotNotes = freezed,
    Object? reportUrl = freezed,
    Object? resultNotes = freezed,
    Object? collectionAddress = freezed,
    Object? collectionCity = freezed,
    Object? collectionPincode = freezed,
    Object? createdAt = null,
    Object? updatedAt = freezed,
    Object? doctorName = null,
    Object? doctorPhone = freezed,
    Object? clinicName = null,
    Object? clinicPhone = freezed,
    Object? clinicAddress = freezed,
    Object? labName = freezed,
    Object? labPhone = freezed,
    Object? labEmail = freezed,
    Object? labAddress = freezed,
    Object? labCity = freezed,
    Object? nablAccredited = freezed,
    Object? isoCertified = freezed,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as int,
            testName: null == testName
                ? _value.testName
                : testName // ignore: cast_nullable_to_non_nullable
                      as String,
            description: freezed == description
                ? _value.description
                : description // ignore: cast_nullable_to_non_nullable
                      as String?,
            serviceMode: null == serviceMode
                ? _value.serviceMode
                : serviceMode // ignore: cast_nullable_to_non_nullable
                      as String,
            status: null == status
                ? _value.status
                : status // ignore: cast_nullable_to_non_nullable
                      as String,
            quotedPrice: freezed == quotedPrice
                ? _value.quotedPrice
                : quotedPrice // ignore: cast_nullable_to_non_nullable
                      as double?,
            platformCommission: freezed == platformCommission
                ? _value.platformCommission
                : platformCommission // ignore: cast_nullable_to_non_nullable
                      as double?,
            slotDatetime: freezed == slotDatetime
                ? _value.slotDatetime
                : slotDatetime // ignore: cast_nullable_to_non_nullable
                      as String?,
            slotNotes: freezed == slotNotes
                ? _value.slotNotes
                : slotNotes // ignore: cast_nullable_to_non_nullable
                      as String?,
            reportUrl: freezed == reportUrl
                ? _value.reportUrl
                : reportUrl // ignore: cast_nullable_to_non_nullable
                      as String?,
            resultNotes: freezed == resultNotes
                ? _value.resultNotes
                : resultNotes // ignore: cast_nullable_to_non_nullable
                      as String?,
            collectionAddress: freezed == collectionAddress
                ? _value.collectionAddress
                : collectionAddress // ignore: cast_nullable_to_non_nullable
                      as String?,
            collectionCity: freezed == collectionCity
                ? _value.collectionCity
                : collectionCity // ignore: cast_nullable_to_non_nullable
                      as String?,
            collectionPincode: freezed == collectionPincode
                ? _value.collectionPincode
                : collectionPincode // ignore: cast_nullable_to_non_nullable
                      as String?,
            createdAt: null == createdAt
                ? _value.createdAt
                : createdAt // ignore: cast_nullable_to_non_nullable
                      as String,
            updatedAt: freezed == updatedAt
                ? _value.updatedAt
                : updatedAt // ignore: cast_nullable_to_non_nullable
                      as String?,
            doctorName: null == doctorName
                ? _value.doctorName
                : doctorName // ignore: cast_nullable_to_non_nullable
                      as String,
            doctorPhone: freezed == doctorPhone
                ? _value.doctorPhone
                : doctorPhone // ignore: cast_nullable_to_non_nullable
                      as String?,
            clinicName: null == clinicName
                ? _value.clinicName
                : clinicName // ignore: cast_nullable_to_non_nullable
                      as String,
            clinicPhone: freezed == clinicPhone
                ? _value.clinicPhone
                : clinicPhone // ignore: cast_nullable_to_non_nullable
                      as String?,
            clinicAddress: freezed == clinicAddress
                ? _value.clinicAddress
                : clinicAddress // ignore: cast_nullable_to_non_nullable
                      as String?,
            labName: freezed == labName
                ? _value.labName
                : labName // ignore: cast_nullable_to_non_nullable
                      as String?,
            labPhone: freezed == labPhone
                ? _value.labPhone
                : labPhone // ignore: cast_nullable_to_non_nullable
                      as String?,
            labEmail: freezed == labEmail
                ? _value.labEmail
                : labEmail // ignore: cast_nullable_to_non_nullable
                      as String?,
            labAddress: freezed == labAddress
                ? _value.labAddress
                : labAddress // ignore: cast_nullable_to_non_nullable
                      as String?,
            labCity: freezed == labCity
                ? _value.labCity
                : labCity // ignore: cast_nullable_to_non_nullable
                      as String?,
            nablAccredited: freezed == nablAccredited
                ? _value.nablAccredited
                : nablAccredited // ignore: cast_nullable_to_non_nullable
                      as int?,
            isoCertified: freezed == isoCertified
                ? _value.isoCertified
                : isoCertified // ignore: cast_nullable_to_non_nullable
                      as int?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$LabReferralImplCopyWith<$Res>
    implements $LabReferralCopyWith<$Res> {
  factory _$$LabReferralImplCopyWith(
    _$LabReferralImpl value,
    $Res Function(_$LabReferralImpl) then,
  ) = __$$LabReferralImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    int id,
    @JsonKey(name: 'test_name') String testName,
    String? description,
    @JsonKey(name: 'service_mode') String serviceMode,
    String status,
    @JsonKey(name: 'quoted_price') double? quotedPrice,
    @JsonKey(name: 'platform_commission') double? platformCommission,
    @JsonKey(name: 'slot_datetime') String? slotDatetime,
    @JsonKey(name: 'slot_notes') String? slotNotes,
    @JsonKey(name: 'report_url') String? reportUrl,
    @JsonKey(name: 'result_notes') String? resultNotes,
    @JsonKey(name: 'collection_address') String? collectionAddress,
    @JsonKey(name: 'collection_city') String? collectionCity,
    @JsonKey(name: 'collection_pincode') String? collectionPincode,
    @JsonKey(name: 'created_at') String createdAt,
    @JsonKey(name: 'updated_at') String? updatedAt,
    @JsonKey(name: 'doctor_name') String doctorName,
    @JsonKey(name: 'doctor_phone') String? doctorPhone,
    @JsonKey(name: 'clinic_name') String clinicName,
    @JsonKey(name: 'clinic_phone') String? clinicPhone,
    @JsonKey(name: 'clinic_address') String? clinicAddress,
    @JsonKey(name: 'lab_name') String? labName,
    @JsonKey(name: 'lab_phone') String? labPhone,
    @JsonKey(name: 'lab_email') String? labEmail,
    @JsonKey(name: 'lab_address') String? labAddress,
    @JsonKey(name: 'lab_city') String? labCity,
    @JsonKey(name: 'nabl_accredited') int? nablAccredited,
    @JsonKey(name: 'iso_certified') int? isoCertified,
  });
}

/// @nodoc
class __$$LabReferralImplCopyWithImpl<$Res>
    extends _$LabReferralCopyWithImpl<$Res, _$LabReferralImpl>
    implements _$$LabReferralImplCopyWith<$Res> {
  __$$LabReferralImplCopyWithImpl(
    _$LabReferralImpl _value,
    $Res Function(_$LabReferralImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of LabReferral
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? testName = null,
    Object? description = freezed,
    Object? serviceMode = null,
    Object? status = null,
    Object? quotedPrice = freezed,
    Object? platformCommission = freezed,
    Object? slotDatetime = freezed,
    Object? slotNotes = freezed,
    Object? reportUrl = freezed,
    Object? resultNotes = freezed,
    Object? collectionAddress = freezed,
    Object? collectionCity = freezed,
    Object? collectionPincode = freezed,
    Object? createdAt = null,
    Object? updatedAt = freezed,
    Object? doctorName = null,
    Object? doctorPhone = freezed,
    Object? clinicName = null,
    Object? clinicPhone = freezed,
    Object? clinicAddress = freezed,
    Object? labName = freezed,
    Object? labPhone = freezed,
    Object? labEmail = freezed,
    Object? labAddress = freezed,
    Object? labCity = freezed,
    Object? nablAccredited = freezed,
    Object? isoCertified = freezed,
  }) {
    return _then(
      _$LabReferralImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as int,
        testName: null == testName
            ? _value.testName
            : testName // ignore: cast_nullable_to_non_nullable
                  as String,
        description: freezed == description
            ? _value.description
            : description // ignore: cast_nullable_to_non_nullable
                  as String?,
        serviceMode: null == serviceMode
            ? _value.serviceMode
            : serviceMode // ignore: cast_nullable_to_non_nullable
                  as String,
        status: null == status
            ? _value.status
            : status // ignore: cast_nullable_to_non_nullable
                  as String,
        quotedPrice: freezed == quotedPrice
            ? _value.quotedPrice
            : quotedPrice // ignore: cast_nullable_to_non_nullable
                  as double?,
        platformCommission: freezed == platformCommission
            ? _value.platformCommission
            : platformCommission // ignore: cast_nullable_to_non_nullable
                  as double?,
        slotDatetime: freezed == slotDatetime
            ? _value.slotDatetime
            : slotDatetime // ignore: cast_nullable_to_non_nullable
                  as String?,
        slotNotes: freezed == slotNotes
            ? _value.slotNotes
            : slotNotes // ignore: cast_nullable_to_non_nullable
                  as String?,
        reportUrl: freezed == reportUrl
            ? _value.reportUrl
            : reportUrl // ignore: cast_nullable_to_non_nullable
                  as String?,
        resultNotes: freezed == resultNotes
            ? _value.resultNotes
            : resultNotes // ignore: cast_nullable_to_non_nullable
                  as String?,
        collectionAddress: freezed == collectionAddress
            ? _value.collectionAddress
            : collectionAddress // ignore: cast_nullable_to_non_nullable
                  as String?,
        collectionCity: freezed == collectionCity
            ? _value.collectionCity
            : collectionCity // ignore: cast_nullable_to_non_nullable
                  as String?,
        collectionPincode: freezed == collectionPincode
            ? _value.collectionPincode
            : collectionPincode // ignore: cast_nullable_to_non_nullable
                  as String?,
        createdAt: null == createdAt
            ? _value.createdAt
            : createdAt // ignore: cast_nullable_to_non_nullable
                  as String,
        updatedAt: freezed == updatedAt
            ? _value.updatedAt
            : updatedAt // ignore: cast_nullable_to_non_nullable
                  as String?,
        doctorName: null == doctorName
            ? _value.doctorName
            : doctorName // ignore: cast_nullable_to_non_nullable
                  as String,
        doctorPhone: freezed == doctorPhone
            ? _value.doctorPhone
            : doctorPhone // ignore: cast_nullable_to_non_nullable
                  as String?,
        clinicName: null == clinicName
            ? _value.clinicName
            : clinicName // ignore: cast_nullable_to_non_nullable
                  as String,
        clinicPhone: freezed == clinicPhone
            ? _value.clinicPhone
            : clinicPhone // ignore: cast_nullable_to_non_nullable
                  as String?,
        clinicAddress: freezed == clinicAddress
            ? _value.clinicAddress
            : clinicAddress // ignore: cast_nullable_to_non_nullable
                  as String?,
        labName: freezed == labName
            ? _value.labName
            : labName // ignore: cast_nullable_to_non_nullable
                  as String?,
        labPhone: freezed == labPhone
            ? _value.labPhone
            : labPhone // ignore: cast_nullable_to_non_nullable
                  as String?,
        labEmail: freezed == labEmail
            ? _value.labEmail
            : labEmail // ignore: cast_nullable_to_non_nullable
                  as String?,
        labAddress: freezed == labAddress
            ? _value.labAddress
            : labAddress // ignore: cast_nullable_to_non_nullable
                  as String?,
        labCity: freezed == labCity
            ? _value.labCity
            : labCity // ignore: cast_nullable_to_non_nullable
                  as String?,
        nablAccredited: freezed == nablAccredited
            ? _value.nablAccredited
            : nablAccredited // ignore: cast_nullable_to_non_nullable
                  as int?,
        isoCertified: freezed == isoCertified
            ? _value.isoCertified
            : isoCertified // ignore: cast_nullable_to_non_nullable
                  as int?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$LabReferralImpl implements _LabReferral {
  const _$LabReferralImpl({
    required this.id,
    @JsonKey(name: 'test_name') required this.testName,
    this.description,
    @JsonKey(name: 'service_mode') required this.serviceMode,
    required this.status,
    @JsonKey(name: 'quoted_price') this.quotedPrice,
    @JsonKey(name: 'platform_commission') this.platformCommission,
    @JsonKey(name: 'slot_datetime') this.slotDatetime,
    @JsonKey(name: 'slot_notes') this.slotNotes,
    @JsonKey(name: 'report_url') this.reportUrl,
    @JsonKey(name: 'result_notes') this.resultNotes,
    @JsonKey(name: 'collection_address') this.collectionAddress,
    @JsonKey(name: 'collection_city') this.collectionCity,
    @JsonKey(name: 'collection_pincode') this.collectionPincode,
    @JsonKey(name: 'created_at') required this.createdAt,
    @JsonKey(name: 'updated_at') this.updatedAt,
    @JsonKey(name: 'doctor_name') required this.doctorName,
    @JsonKey(name: 'doctor_phone') this.doctorPhone,
    @JsonKey(name: 'clinic_name') required this.clinicName,
    @JsonKey(name: 'clinic_phone') this.clinicPhone,
    @JsonKey(name: 'clinic_address') this.clinicAddress,
    @JsonKey(name: 'lab_name') this.labName,
    @JsonKey(name: 'lab_phone') this.labPhone,
    @JsonKey(name: 'lab_email') this.labEmail,
    @JsonKey(name: 'lab_address') this.labAddress,
    @JsonKey(name: 'lab_city') this.labCity,
    @JsonKey(name: 'nabl_accredited') this.nablAccredited,
    @JsonKey(name: 'iso_certified') this.isoCertified,
  });

  factory _$LabReferralImpl.fromJson(Map<String, dynamic> json) =>
      _$$LabReferralImplFromJson(json);

  @override
  final int id;
  @override
  @JsonKey(name: 'test_name')
  final String testName;
  @override
  final String? description;
  @override
  @JsonKey(name: 'service_mode')
  final String serviceMode;
  // 'lab_visit' | 'home_collection'
  @override
  final String status;
  @override
  @JsonKey(name: 'quoted_price')
  final double? quotedPrice;
  @override
  @JsonKey(name: 'platform_commission')
  final double? platformCommission;
  @override
  @JsonKey(name: 'slot_datetime')
  final String? slotDatetime;
  @override
  @JsonKey(name: 'slot_notes')
  final String? slotNotes;
  @override
  @JsonKey(name: 'report_url')
  final String? reportUrl;
  @override
  @JsonKey(name: 'result_notes')
  final String? resultNotes;
  @override
  @JsonKey(name: 'collection_address')
  final String? collectionAddress;
  @override
  @JsonKey(name: 'collection_city')
  final String? collectionCity;
  @override
  @JsonKey(name: 'collection_pincode')
  final String? collectionPincode;
  @override
  @JsonKey(name: 'created_at')
  final String createdAt;
  @override
  @JsonKey(name: 'updated_at')
  final String? updatedAt;
  @override
  @JsonKey(name: 'doctor_name')
  final String doctorName;
  @override
  @JsonKey(name: 'doctor_phone')
  final String? doctorPhone;
  @override
  @JsonKey(name: 'clinic_name')
  final String clinicName;
  @override
  @JsonKey(name: 'clinic_phone')
  final String? clinicPhone;
  @override
  @JsonKey(name: 'clinic_address')
  final String? clinicAddress;
  @override
  @JsonKey(name: 'lab_name')
  final String? labName;
  @override
  @JsonKey(name: 'lab_phone')
  final String? labPhone;
  @override
  @JsonKey(name: 'lab_email')
  final String? labEmail;
  @override
  @JsonKey(name: 'lab_address')
  final String? labAddress;
  @override
  @JsonKey(name: 'lab_city')
  final String? labCity;
  @override
  @JsonKey(name: 'nabl_accredited')
  final int? nablAccredited;
  @override
  @JsonKey(name: 'iso_certified')
  final int? isoCertified;

  @override
  String toString() {
    return 'LabReferral(id: $id, testName: $testName, description: $description, serviceMode: $serviceMode, status: $status, quotedPrice: $quotedPrice, platformCommission: $platformCommission, slotDatetime: $slotDatetime, slotNotes: $slotNotes, reportUrl: $reportUrl, resultNotes: $resultNotes, collectionAddress: $collectionAddress, collectionCity: $collectionCity, collectionPincode: $collectionPincode, createdAt: $createdAt, updatedAt: $updatedAt, doctorName: $doctorName, doctorPhone: $doctorPhone, clinicName: $clinicName, clinicPhone: $clinicPhone, clinicAddress: $clinicAddress, labName: $labName, labPhone: $labPhone, labEmail: $labEmail, labAddress: $labAddress, labCity: $labCity, nablAccredited: $nablAccredited, isoCertified: $isoCertified)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$LabReferralImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.testName, testName) ||
                other.testName == testName) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.serviceMode, serviceMode) ||
                other.serviceMode == serviceMode) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.quotedPrice, quotedPrice) ||
                other.quotedPrice == quotedPrice) &&
            (identical(other.platformCommission, platformCommission) ||
                other.platformCommission == platformCommission) &&
            (identical(other.slotDatetime, slotDatetime) ||
                other.slotDatetime == slotDatetime) &&
            (identical(other.slotNotes, slotNotes) ||
                other.slotNotes == slotNotes) &&
            (identical(other.reportUrl, reportUrl) ||
                other.reportUrl == reportUrl) &&
            (identical(other.resultNotes, resultNotes) ||
                other.resultNotes == resultNotes) &&
            (identical(other.collectionAddress, collectionAddress) ||
                other.collectionAddress == collectionAddress) &&
            (identical(other.collectionCity, collectionCity) ||
                other.collectionCity == collectionCity) &&
            (identical(other.collectionPincode, collectionPincode) ||
                other.collectionPincode == collectionPincode) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt) &&
            (identical(other.doctorName, doctorName) ||
                other.doctorName == doctorName) &&
            (identical(other.doctorPhone, doctorPhone) ||
                other.doctorPhone == doctorPhone) &&
            (identical(other.clinicName, clinicName) ||
                other.clinicName == clinicName) &&
            (identical(other.clinicPhone, clinicPhone) ||
                other.clinicPhone == clinicPhone) &&
            (identical(other.clinicAddress, clinicAddress) ||
                other.clinicAddress == clinicAddress) &&
            (identical(other.labName, labName) || other.labName == labName) &&
            (identical(other.labPhone, labPhone) ||
                other.labPhone == labPhone) &&
            (identical(other.labEmail, labEmail) ||
                other.labEmail == labEmail) &&
            (identical(other.labAddress, labAddress) ||
                other.labAddress == labAddress) &&
            (identical(other.labCity, labCity) || other.labCity == labCity) &&
            (identical(other.nablAccredited, nablAccredited) ||
                other.nablAccredited == nablAccredited) &&
            (identical(other.isoCertified, isoCertified) ||
                other.isoCertified == isoCertified));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hashAll([
    runtimeType,
    id,
    testName,
    description,
    serviceMode,
    status,
    quotedPrice,
    platformCommission,
    slotDatetime,
    slotNotes,
    reportUrl,
    resultNotes,
    collectionAddress,
    collectionCity,
    collectionPincode,
    createdAt,
    updatedAt,
    doctorName,
    doctorPhone,
    clinicName,
    clinicPhone,
    clinicAddress,
    labName,
    labPhone,
    labEmail,
    labAddress,
    labCity,
    nablAccredited,
    isoCertified,
  ]);

  /// Create a copy of LabReferral
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$LabReferralImplCopyWith<_$LabReferralImpl> get copyWith =>
      __$$LabReferralImplCopyWithImpl<_$LabReferralImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$LabReferralImplToJson(this);
  }
}

abstract class _LabReferral implements LabReferral {
  const factory _LabReferral({
    required final int id,
    @JsonKey(name: 'test_name') required final String testName,
    final String? description,
    @JsonKey(name: 'service_mode') required final String serviceMode,
    required final String status,
    @JsonKey(name: 'quoted_price') final double? quotedPrice,
    @JsonKey(name: 'platform_commission') final double? platformCommission,
    @JsonKey(name: 'slot_datetime') final String? slotDatetime,
    @JsonKey(name: 'slot_notes') final String? slotNotes,
    @JsonKey(name: 'report_url') final String? reportUrl,
    @JsonKey(name: 'result_notes') final String? resultNotes,
    @JsonKey(name: 'collection_address') final String? collectionAddress,
    @JsonKey(name: 'collection_city') final String? collectionCity,
    @JsonKey(name: 'collection_pincode') final String? collectionPincode,
    @JsonKey(name: 'created_at') required final String createdAt,
    @JsonKey(name: 'updated_at') final String? updatedAt,
    @JsonKey(name: 'doctor_name') required final String doctorName,
    @JsonKey(name: 'doctor_phone') final String? doctorPhone,
    @JsonKey(name: 'clinic_name') required final String clinicName,
    @JsonKey(name: 'clinic_phone') final String? clinicPhone,
    @JsonKey(name: 'clinic_address') final String? clinicAddress,
    @JsonKey(name: 'lab_name') final String? labName,
    @JsonKey(name: 'lab_phone') final String? labPhone,
    @JsonKey(name: 'lab_email') final String? labEmail,
    @JsonKey(name: 'lab_address') final String? labAddress,
    @JsonKey(name: 'lab_city') final String? labCity,
    @JsonKey(name: 'nabl_accredited') final int? nablAccredited,
    @JsonKey(name: 'iso_certified') final int? isoCertified,
  }) = _$LabReferralImpl;

  factory _LabReferral.fromJson(Map<String, dynamic> json) =
      _$LabReferralImpl.fromJson;

  @override
  int get id;
  @override
  @JsonKey(name: 'test_name')
  String get testName;
  @override
  String? get description;
  @override
  @JsonKey(name: 'service_mode')
  String get serviceMode; // 'lab_visit' | 'home_collection'
  @override
  String get status;
  @override
  @JsonKey(name: 'quoted_price')
  double? get quotedPrice;
  @override
  @JsonKey(name: 'platform_commission')
  double? get platformCommission;
  @override
  @JsonKey(name: 'slot_datetime')
  String? get slotDatetime;
  @override
  @JsonKey(name: 'slot_notes')
  String? get slotNotes;
  @override
  @JsonKey(name: 'report_url')
  String? get reportUrl;
  @override
  @JsonKey(name: 'result_notes')
  String? get resultNotes;
  @override
  @JsonKey(name: 'collection_address')
  String? get collectionAddress;
  @override
  @JsonKey(name: 'collection_city')
  String? get collectionCity;
  @override
  @JsonKey(name: 'collection_pincode')
  String? get collectionPincode;
  @override
  @JsonKey(name: 'created_at')
  String get createdAt;
  @override
  @JsonKey(name: 'updated_at')
  String? get updatedAt;
  @override
  @JsonKey(name: 'doctor_name')
  String get doctorName;
  @override
  @JsonKey(name: 'doctor_phone')
  String? get doctorPhone;
  @override
  @JsonKey(name: 'clinic_name')
  String get clinicName;
  @override
  @JsonKey(name: 'clinic_phone')
  String? get clinicPhone;
  @override
  @JsonKey(name: 'clinic_address')
  String? get clinicAddress;
  @override
  @JsonKey(name: 'lab_name')
  String? get labName;
  @override
  @JsonKey(name: 'lab_phone')
  String? get labPhone;
  @override
  @JsonKey(name: 'lab_email')
  String? get labEmail;
  @override
  @JsonKey(name: 'lab_address')
  String? get labAddress;
  @override
  @JsonKey(name: 'lab_city')
  String? get labCity;
  @override
  @JsonKey(name: 'nabl_accredited')
  int? get nablAccredited;
  @override
  @JsonKey(name: 'iso_certified')
  int? get isoCertified;

  /// Create a copy of LabReferral
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$LabReferralImplCopyWith<_$LabReferralImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

LabReferralNotification _$LabReferralNotificationFromJson(
  Map<String, dynamic> json,
) {
  return _LabReferralNotification.fromJson(json);
}

/// @nodoc
mixin _$LabReferralNotification {
  int get id => throw _privateConstructorUsedError;
  @JsonKey(name: 'lab_referral_id')
  int? get labReferralId => throw _privateConstructorUsedError;
  @JsonKey(name: 'event_type')
  String get eventType => throw _privateConstructorUsedError;
  String get title => throw _privateConstructorUsedError;
  String get body => throw _privateConstructorUsedError;
  @JsonKey(name: 'is_read')
  int get isRead => throw _privateConstructorUsedError;
  @JsonKey(name: 'created_at')
  String get createdAt => throw _privateConstructorUsedError;

  /// Serializes this LabReferralNotification to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of LabReferralNotification
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $LabReferralNotificationCopyWith<LabReferralNotification> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $LabReferralNotificationCopyWith<$Res> {
  factory $LabReferralNotificationCopyWith(
    LabReferralNotification value,
    $Res Function(LabReferralNotification) then,
  ) = _$LabReferralNotificationCopyWithImpl<$Res, LabReferralNotification>;
  @useResult
  $Res call({
    int id,
    @JsonKey(name: 'lab_referral_id') int? labReferralId,
    @JsonKey(name: 'event_type') String eventType,
    String title,
    String body,
    @JsonKey(name: 'is_read') int isRead,
    @JsonKey(name: 'created_at') String createdAt,
  });
}

/// @nodoc
class _$LabReferralNotificationCopyWithImpl<
  $Res,
  $Val extends LabReferralNotification
>
    implements $LabReferralNotificationCopyWith<$Res> {
  _$LabReferralNotificationCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of LabReferralNotification
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? labReferralId = freezed,
    Object? eventType = null,
    Object? title = null,
    Object? body = null,
    Object? isRead = null,
    Object? createdAt = null,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as int,
            labReferralId: freezed == labReferralId
                ? _value.labReferralId
                : labReferralId // ignore: cast_nullable_to_non_nullable
                      as int?,
            eventType: null == eventType
                ? _value.eventType
                : eventType // ignore: cast_nullable_to_non_nullable
                      as String,
            title: null == title
                ? _value.title
                : title // ignore: cast_nullable_to_non_nullable
                      as String,
            body: null == body
                ? _value.body
                : body // ignore: cast_nullable_to_non_nullable
                      as String,
            isRead: null == isRead
                ? _value.isRead
                : isRead // ignore: cast_nullable_to_non_nullable
                      as int,
            createdAt: null == createdAt
                ? _value.createdAt
                : createdAt // ignore: cast_nullable_to_non_nullable
                      as String,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$LabReferralNotificationImplCopyWith<$Res>
    implements $LabReferralNotificationCopyWith<$Res> {
  factory _$$LabReferralNotificationImplCopyWith(
    _$LabReferralNotificationImpl value,
    $Res Function(_$LabReferralNotificationImpl) then,
  ) = __$$LabReferralNotificationImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    int id,
    @JsonKey(name: 'lab_referral_id') int? labReferralId,
    @JsonKey(name: 'event_type') String eventType,
    String title,
    String body,
    @JsonKey(name: 'is_read') int isRead,
    @JsonKey(name: 'created_at') String createdAt,
  });
}

/// @nodoc
class __$$LabReferralNotificationImplCopyWithImpl<$Res>
    extends
        _$LabReferralNotificationCopyWithImpl<
          $Res,
          _$LabReferralNotificationImpl
        >
    implements _$$LabReferralNotificationImplCopyWith<$Res> {
  __$$LabReferralNotificationImplCopyWithImpl(
    _$LabReferralNotificationImpl _value,
    $Res Function(_$LabReferralNotificationImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of LabReferralNotification
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? labReferralId = freezed,
    Object? eventType = null,
    Object? title = null,
    Object? body = null,
    Object? isRead = null,
    Object? createdAt = null,
  }) {
    return _then(
      _$LabReferralNotificationImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as int,
        labReferralId: freezed == labReferralId
            ? _value.labReferralId
            : labReferralId // ignore: cast_nullable_to_non_nullable
                  as int?,
        eventType: null == eventType
            ? _value.eventType
            : eventType // ignore: cast_nullable_to_non_nullable
                  as String,
        title: null == title
            ? _value.title
            : title // ignore: cast_nullable_to_non_nullable
                  as String,
        body: null == body
            ? _value.body
            : body // ignore: cast_nullable_to_non_nullable
                  as String,
        isRead: null == isRead
            ? _value.isRead
            : isRead // ignore: cast_nullable_to_non_nullable
                  as int,
        createdAt: null == createdAt
            ? _value.createdAt
            : createdAt // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$LabReferralNotificationImpl implements _LabReferralNotification {
  const _$LabReferralNotificationImpl({
    required this.id,
    @JsonKey(name: 'lab_referral_id') this.labReferralId,
    @JsonKey(name: 'event_type') required this.eventType,
    required this.title,
    required this.body,
    @JsonKey(name: 'is_read') required this.isRead,
    @JsonKey(name: 'created_at') required this.createdAt,
  });

  factory _$LabReferralNotificationImpl.fromJson(Map<String, dynamic> json) =>
      _$$LabReferralNotificationImplFromJson(json);

  @override
  final int id;
  @override
  @JsonKey(name: 'lab_referral_id')
  final int? labReferralId;
  @override
  @JsonKey(name: 'event_type')
  final String eventType;
  @override
  final String title;
  @override
  final String body;
  @override
  @JsonKey(name: 'is_read')
  final int isRead;
  @override
  @JsonKey(name: 'created_at')
  final String createdAt;

  @override
  String toString() {
    return 'LabReferralNotification(id: $id, labReferralId: $labReferralId, eventType: $eventType, title: $title, body: $body, isRead: $isRead, createdAt: $createdAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$LabReferralNotificationImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.labReferralId, labReferralId) ||
                other.labReferralId == labReferralId) &&
            (identical(other.eventType, eventType) ||
                other.eventType == eventType) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.body, body) || other.body == body) &&
            (identical(other.isRead, isRead) || other.isRead == isRead) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    labReferralId,
    eventType,
    title,
    body,
    isRead,
    createdAt,
  );

  /// Create a copy of LabReferralNotification
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$LabReferralNotificationImplCopyWith<_$LabReferralNotificationImpl>
  get copyWith =>
      __$$LabReferralNotificationImplCopyWithImpl<
        _$LabReferralNotificationImpl
      >(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$LabReferralNotificationImplToJson(this);
  }
}

abstract class _LabReferralNotification implements LabReferralNotification {
  const factory _LabReferralNotification({
    required final int id,
    @JsonKey(name: 'lab_referral_id') final int? labReferralId,
    @JsonKey(name: 'event_type') required final String eventType,
    required final String title,
    required final String body,
    @JsonKey(name: 'is_read') required final int isRead,
    @JsonKey(name: 'created_at') required final String createdAt,
  }) = _$LabReferralNotificationImpl;

  factory _LabReferralNotification.fromJson(Map<String, dynamic> json) =
      _$LabReferralNotificationImpl.fromJson;

  @override
  int get id;
  @override
  @JsonKey(name: 'lab_referral_id')
  int? get labReferralId;
  @override
  @JsonKey(name: 'event_type')
  String get eventType;
  @override
  String get title;
  @override
  String get body;
  @override
  @JsonKey(name: 'is_read')
  int get isRead;
  @override
  @JsonKey(name: 'created_at')
  String get createdAt;

  /// Create a copy of LabReferralNotification
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$LabReferralNotificationImplCopyWith<_$LabReferralNotificationImpl>
  get copyWith => throw _privateConstructorUsedError;
}

LabReferralsResponse _$LabReferralsResponseFromJson(Map<String, dynamic> json) {
  return _LabReferralsResponse.fromJson(json);
}

/// @nodoc
mixin _$LabReferralsResponse {
  List<LabReferral> get referrals => throw _privateConstructorUsedError;
  List<LabReferralNotification> get notifications =>
      throw _privateConstructorUsedError;

  /// Serializes this LabReferralsResponse to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of LabReferralsResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $LabReferralsResponseCopyWith<LabReferralsResponse> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $LabReferralsResponseCopyWith<$Res> {
  factory $LabReferralsResponseCopyWith(
    LabReferralsResponse value,
    $Res Function(LabReferralsResponse) then,
  ) = _$LabReferralsResponseCopyWithImpl<$Res, LabReferralsResponse>;
  @useResult
  $Res call({
    List<LabReferral> referrals,
    List<LabReferralNotification> notifications,
  });
}

/// @nodoc
class _$LabReferralsResponseCopyWithImpl<
  $Res,
  $Val extends LabReferralsResponse
>
    implements $LabReferralsResponseCopyWith<$Res> {
  _$LabReferralsResponseCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of LabReferralsResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? referrals = null, Object? notifications = null}) {
    return _then(
      _value.copyWith(
            referrals: null == referrals
                ? _value.referrals
                : referrals // ignore: cast_nullable_to_non_nullable
                      as List<LabReferral>,
            notifications: null == notifications
                ? _value.notifications
                : notifications // ignore: cast_nullable_to_non_nullable
                      as List<LabReferralNotification>,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$LabReferralsResponseImplCopyWith<$Res>
    implements $LabReferralsResponseCopyWith<$Res> {
  factory _$$LabReferralsResponseImplCopyWith(
    _$LabReferralsResponseImpl value,
    $Res Function(_$LabReferralsResponseImpl) then,
  ) = __$$LabReferralsResponseImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    List<LabReferral> referrals,
    List<LabReferralNotification> notifications,
  });
}

/// @nodoc
class __$$LabReferralsResponseImplCopyWithImpl<$Res>
    extends _$LabReferralsResponseCopyWithImpl<$Res, _$LabReferralsResponseImpl>
    implements _$$LabReferralsResponseImplCopyWith<$Res> {
  __$$LabReferralsResponseImplCopyWithImpl(
    _$LabReferralsResponseImpl _value,
    $Res Function(_$LabReferralsResponseImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of LabReferralsResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? referrals = null, Object? notifications = null}) {
    return _then(
      _$LabReferralsResponseImpl(
        referrals: null == referrals
            ? _value._referrals
            : referrals // ignore: cast_nullable_to_non_nullable
                  as List<LabReferral>,
        notifications: null == notifications
            ? _value._notifications
            : notifications // ignore: cast_nullable_to_non_nullable
                  as List<LabReferralNotification>,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$LabReferralsResponseImpl implements _LabReferralsResponse {
  const _$LabReferralsResponseImpl({
    required final List<LabReferral> referrals,
    required final List<LabReferralNotification> notifications,
  }) : _referrals = referrals,
       _notifications = notifications;

  factory _$LabReferralsResponseImpl.fromJson(Map<String, dynamic> json) =>
      _$$LabReferralsResponseImplFromJson(json);

  final List<LabReferral> _referrals;
  @override
  List<LabReferral> get referrals {
    if (_referrals is EqualUnmodifiableListView) return _referrals;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_referrals);
  }

  final List<LabReferralNotification> _notifications;
  @override
  List<LabReferralNotification> get notifications {
    if (_notifications is EqualUnmodifiableListView) return _notifications;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_notifications);
  }

  @override
  String toString() {
    return 'LabReferralsResponse(referrals: $referrals, notifications: $notifications)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$LabReferralsResponseImpl &&
            const DeepCollectionEquality().equals(
              other._referrals,
              _referrals,
            ) &&
            const DeepCollectionEquality().equals(
              other._notifications,
              _notifications,
            ));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    const DeepCollectionEquality().hash(_referrals),
    const DeepCollectionEquality().hash(_notifications),
  );

  /// Create a copy of LabReferralsResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$LabReferralsResponseImplCopyWith<_$LabReferralsResponseImpl>
  get copyWith =>
      __$$LabReferralsResponseImplCopyWithImpl<_$LabReferralsResponseImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$LabReferralsResponseImplToJson(this);
  }
}

abstract class _LabReferralsResponse implements LabReferralsResponse {
  const factory _LabReferralsResponse({
    required final List<LabReferral> referrals,
    required final List<LabReferralNotification> notifications,
  }) = _$LabReferralsResponseImpl;

  factory _LabReferralsResponse.fromJson(Map<String, dynamic> json) =
      _$LabReferralsResponseImpl.fromJson;

  @override
  List<LabReferral> get referrals;
  @override
  List<LabReferralNotification> get notifications;

  /// Create a copy of LabReferralsResponse
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$LabReferralsResponseImplCopyWith<_$LabReferralsResponseImpl>
  get copyWith => throw _privateConstructorUsedError;
}

LabReferralDetailResponse _$LabReferralDetailResponseFromJson(
  Map<String, dynamic> json,
) {
  return _LabReferralDetailResponse.fromJson(json);
}

/// @nodoc
mixin _$LabReferralDetailResponse {
  LabReferral get referral => throw _privateConstructorUsedError;
  List<LabReferralNotification> get notifications =>
      throw _privateConstructorUsedError;

  /// Serializes this LabReferralDetailResponse to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of LabReferralDetailResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $LabReferralDetailResponseCopyWith<LabReferralDetailResponse> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $LabReferralDetailResponseCopyWith<$Res> {
  factory $LabReferralDetailResponseCopyWith(
    LabReferralDetailResponse value,
    $Res Function(LabReferralDetailResponse) then,
  ) = _$LabReferralDetailResponseCopyWithImpl<$Res, LabReferralDetailResponse>;
  @useResult
  $Res call({
    LabReferral referral,
    List<LabReferralNotification> notifications,
  });

  $LabReferralCopyWith<$Res> get referral;
}

/// @nodoc
class _$LabReferralDetailResponseCopyWithImpl<
  $Res,
  $Val extends LabReferralDetailResponse
>
    implements $LabReferralDetailResponseCopyWith<$Res> {
  _$LabReferralDetailResponseCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of LabReferralDetailResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? referral = null, Object? notifications = null}) {
    return _then(
      _value.copyWith(
            referral: null == referral
                ? _value.referral
                : referral // ignore: cast_nullable_to_non_nullable
                      as LabReferral,
            notifications: null == notifications
                ? _value.notifications
                : notifications // ignore: cast_nullable_to_non_nullable
                      as List<LabReferralNotification>,
          )
          as $Val,
    );
  }

  /// Create a copy of LabReferralDetailResponse
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $LabReferralCopyWith<$Res> get referral {
    return $LabReferralCopyWith<$Res>(_value.referral, (value) {
      return _then(_value.copyWith(referral: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$LabReferralDetailResponseImplCopyWith<$Res>
    implements $LabReferralDetailResponseCopyWith<$Res> {
  factory _$$LabReferralDetailResponseImplCopyWith(
    _$LabReferralDetailResponseImpl value,
    $Res Function(_$LabReferralDetailResponseImpl) then,
  ) = __$$LabReferralDetailResponseImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    LabReferral referral,
    List<LabReferralNotification> notifications,
  });

  @override
  $LabReferralCopyWith<$Res> get referral;
}

/// @nodoc
class __$$LabReferralDetailResponseImplCopyWithImpl<$Res>
    extends
        _$LabReferralDetailResponseCopyWithImpl<
          $Res,
          _$LabReferralDetailResponseImpl
        >
    implements _$$LabReferralDetailResponseImplCopyWith<$Res> {
  __$$LabReferralDetailResponseImplCopyWithImpl(
    _$LabReferralDetailResponseImpl _value,
    $Res Function(_$LabReferralDetailResponseImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of LabReferralDetailResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? referral = null, Object? notifications = null}) {
    return _then(
      _$LabReferralDetailResponseImpl(
        referral: null == referral
            ? _value.referral
            : referral // ignore: cast_nullable_to_non_nullable
                  as LabReferral,
        notifications: null == notifications
            ? _value._notifications
            : notifications // ignore: cast_nullable_to_non_nullable
                  as List<LabReferralNotification>,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$LabReferralDetailResponseImpl implements _LabReferralDetailResponse {
  const _$LabReferralDetailResponseImpl({
    required this.referral,
    required final List<LabReferralNotification> notifications,
  }) : _notifications = notifications;

  factory _$LabReferralDetailResponseImpl.fromJson(Map<String, dynamic> json) =>
      _$$LabReferralDetailResponseImplFromJson(json);

  @override
  final LabReferral referral;
  final List<LabReferralNotification> _notifications;
  @override
  List<LabReferralNotification> get notifications {
    if (_notifications is EqualUnmodifiableListView) return _notifications;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_notifications);
  }

  @override
  String toString() {
    return 'LabReferralDetailResponse(referral: $referral, notifications: $notifications)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$LabReferralDetailResponseImpl &&
            (identical(other.referral, referral) ||
                other.referral == referral) &&
            const DeepCollectionEquality().equals(
              other._notifications,
              _notifications,
            ));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    referral,
    const DeepCollectionEquality().hash(_notifications),
  );

  /// Create a copy of LabReferralDetailResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$LabReferralDetailResponseImplCopyWith<_$LabReferralDetailResponseImpl>
  get copyWith =>
      __$$LabReferralDetailResponseImplCopyWithImpl<
        _$LabReferralDetailResponseImpl
      >(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$LabReferralDetailResponseImplToJson(this);
  }
}

abstract class _LabReferralDetailResponse implements LabReferralDetailResponse {
  const factory _LabReferralDetailResponse({
    required final LabReferral referral,
    required final List<LabReferralNotification> notifications,
  }) = _$LabReferralDetailResponseImpl;

  factory _LabReferralDetailResponse.fromJson(Map<String, dynamic> json) =
      _$LabReferralDetailResponseImpl.fromJson;

  @override
  LabReferral get referral;
  @override
  List<LabReferralNotification> get notifications;

  /// Create a copy of LabReferralDetailResponse
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$LabReferralDetailResponseImplCopyWith<_$LabReferralDetailResponseImpl>
  get copyWith => throw _privateConstructorUsedError;
}
