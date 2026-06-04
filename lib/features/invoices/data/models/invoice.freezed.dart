// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'invoice.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

PatientInvoice _$PatientInvoiceFromJson(Map<String, dynamic> json) {
  return _PatientInvoice.fromJson(json);
}

/// @nodoc
mixin _$PatientInvoice {
  int get id => throw _privateConstructorUsedError;
  @JsonKey(name: 'invoice_no')
  String get invoiceNo => throw _privateConstructorUsedError;
  @JsonKey(name: 'total_amount')
  double get totalAmount => throw _privateConstructorUsedError;
  @JsonKey(name: 'payment_status')
  String get paymentStatus => throw _privateConstructorUsedError; // paid, pending, partial, cancelled, refunded
  @JsonKey(name: 'payment_mode')
  String? get paymentMode => throw _privateConstructorUsedError;
  @JsonKey(name: 'created_at')
  String get createdAt => throw _privateConstructorUsedError;
  @JsonKey(name: 'appointment_id')
  int? get appointmentId => throw _privateConstructorUsedError;
  @JsonKey(name: 'clinic_name')
  String get clinicName => throw _privateConstructorUsedError;
  @JsonKey(name: 'items_count')
  int get itemsCount => throw _privateConstructorUsedError;

  /// Serializes this PatientInvoice to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of PatientInvoice
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $PatientInvoiceCopyWith<PatientInvoice> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PatientInvoiceCopyWith<$Res> {
  factory $PatientInvoiceCopyWith(
    PatientInvoice value,
    $Res Function(PatientInvoice) then,
  ) = _$PatientInvoiceCopyWithImpl<$Res, PatientInvoice>;
  @useResult
  $Res call({
    int id,
    @JsonKey(name: 'invoice_no') String invoiceNo,
    @JsonKey(name: 'total_amount') double totalAmount,
    @JsonKey(name: 'payment_status') String paymentStatus,
    @JsonKey(name: 'payment_mode') String? paymentMode,
    @JsonKey(name: 'created_at') String createdAt,
    @JsonKey(name: 'appointment_id') int? appointmentId,
    @JsonKey(name: 'clinic_name') String clinicName,
    @JsonKey(name: 'items_count') int itemsCount,
  });
}

/// @nodoc
class _$PatientInvoiceCopyWithImpl<$Res, $Val extends PatientInvoice>
    implements $PatientInvoiceCopyWith<$Res> {
  _$PatientInvoiceCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of PatientInvoice
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? invoiceNo = null,
    Object? totalAmount = null,
    Object? paymentStatus = null,
    Object? paymentMode = freezed,
    Object? createdAt = null,
    Object? appointmentId = freezed,
    Object? clinicName = null,
    Object? itemsCount = null,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as int,
            invoiceNo: null == invoiceNo
                ? _value.invoiceNo
                : invoiceNo // ignore: cast_nullable_to_non_nullable
                      as String,
            totalAmount: null == totalAmount
                ? _value.totalAmount
                : totalAmount // ignore: cast_nullable_to_non_nullable
                      as double,
            paymentStatus: null == paymentStatus
                ? _value.paymentStatus
                : paymentStatus // ignore: cast_nullable_to_non_nullable
                      as String,
            paymentMode: freezed == paymentMode
                ? _value.paymentMode
                : paymentMode // ignore: cast_nullable_to_non_nullable
                      as String?,
            createdAt: null == createdAt
                ? _value.createdAt
                : createdAt // ignore: cast_nullable_to_non_nullable
                      as String,
            appointmentId: freezed == appointmentId
                ? _value.appointmentId
                : appointmentId // ignore: cast_nullable_to_non_nullable
                      as int?,
            clinicName: null == clinicName
                ? _value.clinicName
                : clinicName // ignore: cast_nullable_to_non_nullable
                      as String,
            itemsCount: null == itemsCount
                ? _value.itemsCount
                : itemsCount // ignore: cast_nullable_to_non_nullable
                      as int,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$PatientInvoiceImplCopyWith<$Res>
    implements $PatientInvoiceCopyWith<$Res> {
  factory _$$PatientInvoiceImplCopyWith(
    _$PatientInvoiceImpl value,
    $Res Function(_$PatientInvoiceImpl) then,
  ) = __$$PatientInvoiceImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    int id,
    @JsonKey(name: 'invoice_no') String invoiceNo,
    @JsonKey(name: 'total_amount') double totalAmount,
    @JsonKey(name: 'payment_status') String paymentStatus,
    @JsonKey(name: 'payment_mode') String? paymentMode,
    @JsonKey(name: 'created_at') String createdAt,
    @JsonKey(name: 'appointment_id') int? appointmentId,
    @JsonKey(name: 'clinic_name') String clinicName,
    @JsonKey(name: 'items_count') int itemsCount,
  });
}

/// @nodoc
class __$$PatientInvoiceImplCopyWithImpl<$Res>
    extends _$PatientInvoiceCopyWithImpl<$Res, _$PatientInvoiceImpl>
    implements _$$PatientInvoiceImplCopyWith<$Res> {
  __$$PatientInvoiceImplCopyWithImpl(
    _$PatientInvoiceImpl _value,
    $Res Function(_$PatientInvoiceImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of PatientInvoice
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? invoiceNo = null,
    Object? totalAmount = null,
    Object? paymentStatus = null,
    Object? paymentMode = freezed,
    Object? createdAt = null,
    Object? appointmentId = freezed,
    Object? clinicName = null,
    Object? itemsCount = null,
  }) {
    return _then(
      _$PatientInvoiceImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as int,
        invoiceNo: null == invoiceNo
            ? _value.invoiceNo
            : invoiceNo // ignore: cast_nullable_to_non_nullable
                  as String,
        totalAmount: null == totalAmount
            ? _value.totalAmount
            : totalAmount // ignore: cast_nullable_to_non_nullable
                  as double,
        paymentStatus: null == paymentStatus
            ? _value.paymentStatus
            : paymentStatus // ignore: cast_nullable_to_non_nullable
                  as String,
        paymentMode: freezed == paymentMode
            ? _value.paymentMode
            : paymentMode // ignore: cast_nullable_to_non_nullable
                  as String?,
        createdAt: null == createdAt
            ? _value.createdAt
            : createdAt // ignore: cast_nullable_to_non_nullable
                  as String,
        appointmentId: freezed == appointmentId
            ? _value.appointmentId
            : appointmentId // ignore: cast_nullable_to_non_nullable
                  as int?,
        clinicName: null == clinicName
            ? _value.clinicName
            : clinicName // ignore: cast_nullable_to_non_nullable
                  as String,
        itemsCount: null == itemsCount
            ? _value.itemsCount
            : itemsCount // ignore: cast_nullable_to_non_nullable
                  as int,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$PatientInvoiceImpl implements _PatientInvoice {
  const _$PatientInvoiceImpl({
    required this.id,
    @JsonKey(name: 'invoice_no') required this.invoiceNo,
    @JsonKey(name: 'total_amount') required this.totalAmount,
    @JsonKey(name: 'payment_status') required this.paymentStatus,
    @JsonKey(name: 'payment_mode') this.paymentMode,
    @JsonKey(name: 'created_at') required this.createdAt,
    @JsonKey(name: 'appointment_id') this.appointmentId,
    @JsonKey(name: 'clinic_name') required this.clinicName,
    @JsonKey(name: 'items_count') this.itemsCount = 1,
  });

  factory _$PatientInvoiceImpl.fromJson(Map<String, dynamic> json) =>
      _$$PatientInvoiceImplFromJson(json);

  @override
  final int id;
  @override
  @JsonKey(name: 'invoice_no')
  final String invoiceNo;
  @override
  @JsonKey(name: 'total_amount')
  final double totalAmount;
  @override
  @JsonKey(name: 'payment_status')
  final String paymentStatus;
  // paid, pending, partial, cancelled, refunded
  @override
  @JsonKey(name: 'payment_mode')
  final String? paymentMode;
  @override
  @JsonKey(name: 'created_at')
  final String createdAt;
  @override
  @JsonKey(name: 'appointment_id')
  final int? appointmentId;
  @override
  @JsonKey(name: 'clinic_name')
  final String clinicName;
  @override
  @JsonKey(name: 'items_count')
  final int itemsCount;

  @override
  String toString() {
    return 'PatientInvoice(id: $id, invoiceNo: $invoiceNo, totalAmount: $totalAmount, paymentStatus: $paymentStatus, paymentMode: $paymentMode, createdAt: $createdAt, appointmentId: $appointmentId, clinicName: $clinicName, itemsCount: $itemsCount)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PatientInvoiceImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.invoiceNo, invoiceNo) ||
                other.invoiceNo == invoiceNo) &&
            (identical(other.totalAmount, totalAmount) ||
                other.totalAmount == totalAmount) &&
            (identical(other.paymentStatus, paymentStatus) ||
                other.paymentStatus == paymentStatus) &&
            (identical(other.paymentMode, paymentMode) ||
                other.paymentMode == paymentMode) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.appointmentId, appointmentId) ||
                other.appointmentId == appointmentId) &&
            (identical(other.clinicName, clinicName) ||
                other.clinicName == clinicName) &&
            (identical(other.itemsCount, itemsCount) ||
                other.itemsCount == itemsCount));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    invoiceNo,
    totalAmount,
    paymentStatus,
    paymentMode,
    createdAt,
    appointmentId,
    clinicName,
    itemsCount,
  );

  /// Create a copy of PatientInvoice
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$PatientInvoiceImplCopyWith<_$PatientInvoiceImpl> get copyWith =>
      __$$PatientInvoiceImplCopyWithImpl<_$PatientInvoiceImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$PatientInvoiceImplToJson(this);
  }
}

abstract class _PatientInvoice implements PatientInvoice {
  const factory _PatientInvoice({
    required final int id,
    @JsonKey(name: 'invoice_no') required final String invoiceNo,
    @JsonKey(name: 'total_amount') required final double totalAmount,
    @JsonKey(name: 'payment_status') required final String paymentStatus,
    @JsonKey(name: 'payment_mode') final String? paymentMode,
    @JsonKey(name: 'created_at') required final String createdAt,
    @JsonKey(name: 'appointment_id') final int? appointmentId,
    @JsonKey(name: 'clinic_name') required final String clinicName,
    @JsonKey(name: 'items_count') final int itemsCount,
  }) = _$PatientInvoiceImpl;

  factory _PatientInvoice.fromJson(Map<String, dynamic> json) =
      _$PatientInvoiceImpl.fromJson;

  @override
  int get id;
  @override
  @JsonKey(name: 'invoice_no')
  String get invoiceNo;
  @override
  @JsonKey(name: 'total_amount')
  double get totalAmount;
  @override
  @JsonKey(name: 'payment_status')
  String get paymentStatus; // paid, pending, partial, cancelled, refunded
  @override
  @JsonKey(name: 'payment_mode')
  String? get paymentMode;
  @override
  @JsonKey(name: 'created_at')
  String get createdAt;
  @override
  @JsonKey(name: 'appointment_id')
  int? get appointmentId;
  @override
  @JsonKey(name: 'clinic_name')
  String get clinicName;
  @override
  @JsonKey(name: 'items_count')
  int get itemsCount;

  /// Create a copy of PatientInvoice
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PatientInvoiceImplCopyWith<_$PatientInvoiceImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

InvoicesResponse _$InvoicesResponseFromJson(Map<String, dynamic> json) {
  return _InvoicesResponse.fromJson(json);
}

/// @nodoc
mixin _$InvoicesResponse {
  List<PatientInvoice> get invoices => throw _privateConstructorUsedError;

  /// Serializes this InvoicesResponse to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of InvoicesResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $InvoicesResponseCopyWith<InvoicesResponse> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $InvoicesResponseCopyWith<$Res> {
  factory $InvoicesResponseCopyWith(
    InvoicesResponse value,
    $Res Function(InvoicesResponse) then,
  ) = _$InvoicesResponseCopyWithImpl<$Res, InvoicesResponse>;
  @useResult
  $Res call({List<PatientInvoice> invoices});
}

/// @nodoc
class _$InvoicesResponseCopyWithImpl<$Res, $Val extends InvoicesResponse>
    implements $InvoicesResponseCopyWith<$Res> {
  _$InvoicesResponseCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of InvoicesResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? invoices = null}) {
    return _then(
      _value.copyWith(
            invoices: null == invoices
                ? _value.invoices
                : invoices // ignore: cast_nullable_to_non_nullable
                      as List<PatientInvoice>,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$InvoicesResponseImplCopyWith<$Res>
    implements $InvoicesResponseCopyWith<$Res> {
  factory _$$InvoicesResponseImplCopyWith(
    _$InvoicesResponseImpl value,
    $Res Function(_$InvoicesResponseImpl) then,
  ) = __$$InvoicesResponseImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({List<PatientInvoice> invoices});
}

/// @nodoc
class __$$InvoicesResponseImplCopyWithImpl<$Res>
    extends _$InvoicesResponseCopyWithImpl<$Res, _$InvoicesResponseImpl>
    implements _$$InvoicesResponseImplCopyWith<$Res> {
  __$$InvoicesResponseImplCopyWithImpl(
    _$InvoicesResponseImpl _value,
    $Res Function(_$InvoicesResponseImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of InvoicesResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? invoices = null}) {
    return _then(
      _$InvoicesResponseImpl(
        invoices: null == invoices
            ? _value._invoices
            : invoices // ignore: cast_nullable_to_non_nullable
                  as List<PatientInvoice>,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$InvoicesResponseImpl implements _InvoicesResponse {
  const _$InvoicesResponseImpl({required final List<PatientInvoice> invoices})
    : _invoices = invoices;

  factory _$InvoicesResponseImpl.fromJson(Map<String, dynamic> json) =>
      _$$InvoicesResponseImplFromJson(json);

  final List<PatientInvoice> _invoices;
  @override
  List<PatientInvoice> get invoices {
    if (_invoices is EqualUnmodifiableListView) return _invoices;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_invoices);
  }

  @override
  String toString() {
    return 'InvoicesResponse(invoices: $invoices)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$InvoicesResponseImpl &&
            const DeepCollectionEquality().equals(other._invoices, _invoices));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, const DeepCollectionEquality().hash(_invoices));

  /// Create a copy of InvoicesResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$InvoicesResponseImplCopyWith<_$InvoicesResponseImpl> get copyWith =>
      __$$InvoicesResponseImplCopyWithImpl<_$InvoicesResponseImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$InvoicesResponseImplToJson(this);
  }
}

abstract class _InvoicesResponse implements InvoicesResponse {
  const factory _InvoicesResponse({
    required final List<PatientInvoice> invoices,
  }) = _$InvoicesResponseImpl;

  factory _InvoicesResponse.fromJson(Map<String, dynamic> json) =
      _$InvoicesResponseImpl.fromJson;

  @override
  List<PatientInvoice> get invoices;

  /// Create a copy of InvoicesResponse
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$InvoicesResponseImplCopyWith<_$InvoicesResponseImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
