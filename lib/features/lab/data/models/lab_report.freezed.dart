// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'lab_report.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

LabReportItem _$LabReportItemFromJson(Map<String, dynamic> json) {
  return _LabReportItem.fromJson(json);
}

/// @nodoc
mixin _$LabReportItem {
  @JsonKey(name: 'test_name')
  String get testName => throw _privateConstructorUsedError;
  @JsonKey(name: 'test_code')
  String? get testCode => throw _privateConstructorUsedError;
  @JsonKey(name: 'result_value')
  String? get resultValue => throw _privateConstructorUsedError;
  @JsonKey(name: 'result_unit')
  String? get resultUnit => throw _privateConstructorUsedError;
  @JsonKey(name: 'reference_range')
  String? get referenceRange => throw _privateConstructorUsedError;
  @JsonKey(name: 'is_abnormal')
  bool get isAbnormal => throw _privateConstructorUsedError;

  /// Serializes this LabReportItem to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of LabReportItem
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $LabReportItemCopyWith<LabReportItem> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $LabReportItemCopyWith<$Res> {
  factory $LabReportItemCopyWith(
    LabReportItem value,
    $Res Function(LabReportItem) then,
  ) = _$LabReportItemCopyWithImpl<$Res, LabReportItem>;
  @useResult
  $Res call({
    @JsonKey(name: 'test_name') String testName,
    @JsonKey(name: 'test_code') String? testCode,
    @JsonKey(name: 'result_value') String? resultValue,
    @JsonKey(name: 'result_unit') String? resultUnit,
    @JsonKey(name: 'reference_range') String? referenceRange,
    @JsonKey(name: 'is_abnormal') bool isAbnormal,
  });
}

/// @nodoc
class _$LabReportItemCopyWithImpl<$Res, $Val extends LabReportItem>
    implements $LabReportItemCopyWith<$Res> {
  _$LabReportItemCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of LabReportItem
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? testName = null,
    Object? testCode = freezed,
    Object? resultValue = freezed,
    Object? resultUnit = freezed,
    Object? referenceRange = freezed,
    Object? isAbnormal = null,
  }) {
    return _then(
      _value.copyWith(
            testName: null == testName
                ? _value.testName
                : testName // ignore: cast_nullable_to_non_nullable
                      as String,
            testCode: freezed == testCode
                ? _value.testCode
                : testCode // ignore: cast_nullable_to_non_nullable
                      as String?,
            resultValue: freezed == resultValue
                ? _value.resultValue
                : resultValue // ignore: cast_nullable_to_non_nullable
                      as String?,
            resultUnit: freezed == resultUnit
                ? _value.resultUnit
                : resultUnit // ignore: cast_nullable_to_non_nullable
                      as String?,
            referenceRange: freezed == referenceRange
                ? _value.referenceRange
                : referenceRange // ignore: cast_nullable_to_non_nullable
                      as String?,
            isAbnormal: null == isAbnormal
                ? _value.isAbnormal
                : isAbnormal // ignore: cast_nullable_to_non_nullable
                      as bool,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$LabReportItemImplCopyWith<$Res>
    implements $LabReportItemCopyWith<$Res> {
  factory _$$LabReportItemImplCopyWith(
    _$LabReportItemImpl value,
    $Res Function(_$LabReportItemImpl) then,
  ) = __$$LabReportItemImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    @JsonKey(name: 'test_name') String testName,
    @JsonKey(name: 'test_code') String? testCode,
    @JsonKey(name: 'result_value') String? resultValue,
    @JsonKey(name: 'result_unit') String? resultUnit,
    @JsonKey(name: 'reference_range') String? referenceRange,
    @JsonKey(name: 'is_abnormal') bool isAbnormal,
  });
}

/// @nodoc
class __$$LabReportItemImplCopyWithImpl<$Res>
    extends _$LabReportItemCopyWithImpl<$Res, _$LabReportItemImpl>
    implements _$$LabReportItemImplCopyWith<$Res> {
  __$$LabReportItemImplCopyWithImpl(
    _$LabReportItemImpl _value,
    $Res Function(_$LabReportItemImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of LabReportItem
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? testName = null,
    Object? testCode = freezed,
    Object? resultValue = freezed,
    Object? resultUnit = freezed,
    Object? referenceRange = freezed,
    Object? isAbnormal = null,
  }) {
    return _then(
      _$LabReportItemImpl(
        testName: null == testName
            ? _value.testName
            : testName // ignore: cast_nullable_to_non_nullable
                  as String,
        testCode: freezed == testCode
            ? _value.testCode
            : testCode // ignore: cast_nullable_to_non_nullable
                  as String?,
        resultValue: freezed == resultValue
            ? _value.resultValue
            : resultValue // ignore: cast_nullable_to_non_nullable
                  as String?,
        resultUnit: freezed == resultUnit
            ? _value.resultUnit
            : resultUnit // ignore: cast_nullable_to_non_nullable
                  as String?,
        referenceRange: freezed == referenceRange
            ? _value.referenceRange
            : referenceRange // ignore: cast_nullable_to_non_nullable
                  as String?,
        isAbnormal: null == isAbnormal
            ? _value.isAbnormal
            : isAbnormal // ignore: cast_nullable_to_non_nullable
                  as bool,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$LabReportItemImpl implements _LabReportItem {
  const _$LabReportItemImpl({
    @JsonKey(name: 'test_name') required this.testName,
    @JsonKey(name: 'test_code') this.testCode,
    @JsonKey(name: 'result_value') this.resultValue,
    @JsonKey(name: 'result_unit') this.resultUnit,
    @JsonKey(name: 'reference_range') this.referenceRange,
    @JsonKey(name: 'is_abnormal') this.isAbnormal = false,
  });

  factory _$LabReportItemImpl.fromJson(Map<String, dynamic> json) =>
      _$$LabReportItemImplFromJson(json);

  @override
  @JsonKey(name: 'test_name')
  final String testName;
  @override
  @JsonKey(name: 'test_code')
  final String? testCode;
  @override
  @JsonKey(name: 'result_value')
  final String? resultValue;
  @override
  @JsonKey(name: 'result_unit')
  final String? resultUnit;
  @override
  @JsonKey(name: 'reference_range')
  final String? referenceRange;
  @override
  @JsonKey(name: 'is_abnormal')
  final bool isAbnormal;

  @override
  String toString() {
    return 'LabReportItem(testName: $testName, testCode: $testCode, resultValue: $resultValue, resultUnit: $resultUnit, referenceRange: $referenceRange, isAbnormal: $isAbnormal)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$LabReportItemImpl &&
            (identical(other.testName, testName) ||
                other.testName == testName) &&
            (identical(other.testCode, testCode) ||
                other.testCode == testCode) &&
            (identical(other.resultValue, resultValue) ||
                other.resultValue == resultValue) &&
            (identical(other.resultUnit, resultUnit) ||
                other.resultUnit == resultUnit) &&
            (identical(other.referenceRange, referenceRange) ||
                other.referenceRange == referenceRange) &&
            (identical(other.isAbnormal, isAbnormal) ||
                other.isAbnormal == isAbnormal));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    testName,
    testCode,
    resultValue,
    resultUnit,
    referenceRange,
    isAbnormal,
  );

  /// Create a copy of LabReportItem
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$LabReportItemImplCopyWith<_$LabReportItemImpl> get copyWith =>
      __$$LabReportItemImplCopyWithImpl<_$LabReportItemImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$LabReportItemImplToJson(this);
  }
}

abstract class _LabReportItem implements LabReportItem {
  const factory _LabReportItem({
    @JsonKey(name: 'test_name') required final String testName,
    @JsonKey(name: 'test_code') final String? testCode,
    @JsonKey(name: 'result_value') final String? resultValue,
    @JsonKey(name: 'result_unit') final String? resultUnit,
    @JsonKey(name: 'reference_range') final String? referenceRange,
    @JsonKey(name: 'is_abnormal') final bool isAbnormal,
  }) = _$LabReportItemImpl;

  factory _LabReportItem.fromJson(Map<String, dynamic> json) =
      _$LabReportItemImpl.fromJson;

  @override
  @JsonKey(name: 'test_name')
  String get testName;
  @override
  @JsonKey(name: 'test_code')
  String? get testCode;
  @override
  @JsonKey(name: 'result_value')
  String? get resultValue;
  @override
  @JsonKey(name: 'result_unit')
  String? get resultUnit;
  @override
  @JsonKey(name: 'reference_range')
  String? get referenceRange;
  @override
  @JsonKey(name: 'is_abnormal')
  bool get isAbnormal;

  /// Create a copy of LabReportItem
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$LabReportItemImplCopyWith<_$LabReportItemImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

LabReport _$LabReportFromJson(Map<String, dynamic> json) {
  return _LabReport.fromJson(json);
}

/// @nodoc
mixin _$LabReport {
  int get id => throw _privateConstructorUsedError;
  String get status =>
      throw _privateConstructorUsedError; // 'ordered' | 'collected' | 'processing' | 'completed'
  String? get notes => throw _privateConstructorUsedError;
  @JsonKey(name: 'ordered_by_name')
  String get orderedByName => throw _privateConstructorUsedError;
  @JsonKey(name: 'clinic_name')
  String get clinicName => throw _privateConstructorUsedError;
  @JsonKey(name: 'ordered_at')
  String get orderedAt => throw _privateConstructorUsedError;
  List<LabReportItem> get items => throw _privateConstructorUsedError;

  /// Serializes this LabReport to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of LabReport
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $LabReportCopyWith<LabReport> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $LabReportCopyWith<$Res> {
  factory $LabReportCopyWith(LabReport value, $Res Function(LabReport) then) =
      _$LabReportCopyWithImpl<$Res, LabReport>;
  @useResult
  $Res call({
    int id,
    String status,
    String? notes,
    @JsonKey(name: 'ordered_by_name') String orderedByName,
    @JsonKey(name: 'clinic_name') String clinicName,
    @JsonKey(name: 'ordered_at') String orderedAt,
    List<LabReportItem> items,
  });
}

/// @nodoc
class _$LabReportCopyWithImpl<$Res, $Val extends LabReport>
    implements $LabReportCopyWith<$Res> {
  _$LabReportCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of LabReport
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? status = null,
    Object? notes = freezed,
    Object? orderedByName = null,
    Object? clinicName = null,
    Object? orderedAt = null,
    Object? items = null,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as int,
            status: null == status
                ? _value.status
                : status // ignore: cast_nullable_to_non_nullable
                      as String,
            notes: freezed == notes
                ? _value.notes
                : notes // ignore: cast_nullable_to_non_nullable
                      as String?,
            orderedByName: null == orderedByName
                ? _value.orderedByName
                : orderedByName // ignore: cast_nullable_to_non_nullable
                      as String,
            clinicName: null == clinicName
                ? _value.clinicName
                : clinicName // ignore: cast_nullable_to_non_nullable
                      as String,
            orderedAt: null == orderedAt
                ? _value.orderedAt
                : orderedAt // ignore: cast_nullable_to_non_nullable
                      as String,
            items: null == items
                ? _value.items
                : items // ignore: cast_nullable_to_non_nullable
                      as List<LabReportItem>,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$LabReportImplCopyWith<$Res>
    implements $LabReportCopyWith<$Res> {
  factory _$$LabReportImplCopyWith(
    _$LabReportImpl value,
    $Res Function(_$LabReportImpl) then,
  ) = __$$LabReportImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    int id,
    String status,
    String? notes,
    @JsonKey(name: 'ordered_by_name') String orderedByName,
    @JsonKey(name: 'clinic_name') String clinicName,
    @JsonKey(name: 'ordered_at') String orderedAt,
    List<LabReportItem> items,
  });
}

/// @nodoc
class __$$LabReportImplCopyWithImpl<$Res>
    extends _$LabReportCopyWithImpl<$Res, _$LabReportImpl>
    implements _$$LabReportImplCopyWith<$Res> {
  __$$LabReportImplCopyWithImpl(
    _$LabReportImpl _value,
    $Res Function(_$LabReportImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of LabReport
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? status = null,
    Object? notes = freezed,
    Object? orderedByName = null,
    Object? clinicName = null,
    Object? orderedAt = null,
    Object? items = null,
  }) {
    return _then(
      _$LabReportImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as int,
        status: null == status
            ? _value.status
            : status // ignore: cast_nullable_to_non_nullable
                  as String,
        notes: freezed == notes
            ? _value.notes
            : notes // ignore: cast_nullable_to_non_nullable
                  as String?,
        orderedByName: null == orderedByName
            ? _value.orderedByName
            : orderedByName // ignore: cast_nullable_to_non_nullable
                  as String,
        clinicName: null == clinicName
            ? _value.clinicName
            : clinicName // ignore: cast_nullable_to_non_nullable
                  as String,
        orderedAt: null == orderedAt
            ? _value.orderedAt
            : orderedAt // ignore: cast_nullable_to_non_nullable
                  as String,
        items: null == items
            ? _value._items
            : items // ignore: cast_nullable_to_non_nullable
                  as List<LabReportItem>,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$LabReportImpl implements _LabReport {
  const _$LabReportImpl({
    required this.id,
    required this.status,
    this.notes,
    @JsonKey(name: 'ordered_by_name') required this.orderedByName,
    @JsonKey(name: 'clinic_name') required this.clinicName,
    @JsonKey(name: 'ordered_at') required this.orderedAt,
    required final List<LabReportItem> items,
  }) : _items = items;

  factory _$LabReportImpl.fromJson(Map<String, dynamic> json) =>
      _$$LabReportImplFromJson(json);

  @override
  final int id;
  @override
  final String status;
  // 'ordered' | 'collected' | 'processing' | 'completed'
  @override
  final String? notes;
  @override
  @JsonKey(name: 'ordered_by_name')
  final String orderedByName;
  @override
  @JsonKey(name: 'clinic_name')
  final String clinicName;
  @override
  @JsonKey(name: 'ordered_at')
  final String orderedAt;
  final List<LabReportItem> _items;
  @override
  List<LabReportItem> get items {
    if (_items is EqualUnmodifiableListView) return _items;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_items);
  }

  @override
  String toString() {
    return 'LabReport(id: $id, status: $status, notes: $notes, orderedByName: $orderedByName, clinicName: $clinicName, orderedAt: $orderedAt, items: $items)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$LabReportImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.notes, notes) || other.notes == notes) &&
            (identical(other.orderedByName, orderedByName) ||
                other.orderedByName == orderedByName) &&
            (identical(other.clinicName, clinicName) ||
                other.clinicName == clinicName) &&
            (identical(other.orderedAt, orderedAt) ||
                other.orderedAt == orderedAt) &&
            const DeepCollectionEquality().equals(other._items, _items));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    status,
    notes,
    orderedByName,
    clinicName,
    orderedAt,
    const DeepCollectionEquality().hash(_items),
  );

  /// Create a copy of LabReport
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$LabReportImplCopyWith<_$LabReportImpl> get copyWith =>
      __$$LabReportImplCopyWithImpl<_$LabReportImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$LabReportImplToJson(this);
  }
}

abstract class _LabReport implements LabReport {
  const factory _LabReport({
    required final int id,
    required final String status,
    final String? notes,
    @JsonKey(name: 'ordered_by_name') required final String orderedByName,
    @JsonKey(name: 'clinic_name') required final String clinicName,
    @JsonKey(name: 'ordered_at') required final String orderedAt,
    required final List<LabReportItem> items,
  }) = _$LabReportImpl;

  factory _LabReport.fromJson(Map<String, dynamic> json) =
      _$LabReportImpl.fromJson;

  @override
  int get id;
  @override
  String get status; // 'ordered' | 'collected' | 'processing' | 'completed'
  @override
  String? get notes;
  @override
  @JsonKey(name: 'ordered_by_name')
  String get orderedByName;
  @override
  @JsonKey(name: 'clinic_name')
  String get clinicName;
  @override
  @JsonKey(name: 'ordered_at')
  String get orderedAt;
  @override
  List<LabReportItem> get items;

  /// Create a copy of LabReport
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$LabReportImplCopyWith<_$LabReportImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

LabReportsResponse _$LabReportsResponseFromJson(Map<String, dynamic> json) {
  return _LabReportsResponse.fromJson(json);
}

/// @nodoc
mixin _$LabReportsResponse {
  List<LabReport> get orders => throw _privateConstructorUsedError;

  /// Serializes this LabReportsResponse to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of LabReportsResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $LabReportsResponseCopyWith<LabReportsResponse> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $LabReportsResponseCopyWith<$Res> {
  factory $LabReportsResponseCopyWith(
    LabReportsResponse value,
    $Res Function(LabReportsResponse) then,
  ) = _$LabReportsResponseCopyWithImpl<$Res, LabReportsResponse>;
  @useResult
  $Res call({List<LabReport> orders});
}

/// @nodoc
class _$LabReportsResponseCopyWithImpl<$Res, $Val extends LabReportsResponse>
    implements $LabReportsResponseCopyWith<$Res> {
  _$LabReportsResponseCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of LabReportsResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? orders = null}) {
    return _then(
      _value.copyWith(
            orders: null == orders
                ? _value.orders
                : orders // ignore: cast_nullable_to_non_nullable
                      as List<LabReport>,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$LabReportsResponseImplCopyWith<$Res>
    implements $LabReportsResponseCopyWith<$Res> {
  factory _$$LabReportsResponseImplCopyWith(
    _$LabReportsResponseImpl value,
    $Res Function(_$LabReportsResponseImpl) then,
  ) = __$$LabReportsResponseImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({List<LabReport> orders});
}

/// @nodoc
class __$$LabReportsResponseImplCopyWithImpl<$Res>
    extends _$LabReportsResponseCopyWithImpl<$Res, _$LabReportsResponseImpl>
    implements _$$LabReportsResponseImplCopyWith<$Res> {
  __$$LabReportsResponseImplCopyWithImpl(
    _$LabReportsResponseImpl _value,
    $Res Function(_$LabReportsResponseImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of LabReportsResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? orders = null}) {
    return _then(
      _$LabReportsResponseImpl(
        orders: null == orders
            ? _value._orders
            : orders // ignore: cast_nullable_to_non_nullable
                  as List<LabReport>,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$LabReportsResponseImpl implements _LabReportsResponse {
  const _$LabReportsResponseImpl({required final List<LabReport> orders})
    : _orders = orders;

  factory _$LabReportsResponseImpl.fromJson(Map<String, dynamic> json) =>
      _$$LabReportsResponseImplFromJson(json);

  final List<LabReport> _orders;
  @override
  List<LabReport> get orders {
    if (_orders is EqualUnmodifiableListView) return _orders;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_orders);
  }

  @override
  String toString() {
    return 'LabReportsResponse(orders: $orders)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$LabReportsResponseImpl &&
            const DeepCollectionEquality().equals(other._orders, _orders));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, const DeepCollectionEquality().hash(_orders));

  /// Create a copy of LabReportsResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$LabReportsResponseImplCopyWith<_$LabReportsResponseImpl> get copyWith =>
      __$$LabReportsResponseImplCopyWithImpl<_$LabReportsResponseImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$LabReportsResponseImplToJson(this);
  }
}

abstract class _LabReportsResponse implements LabReportsResponse {
  const factory _LabReportsResponse({required final List<LabReport> orders}) =
      _$LabReportsResponseImpl;

  factory _LabReportsResponse.fromJson(Map<String, dynamic> json) =
      _$LabReportsResponseImpl.fromJson;

  @override
  List<LabReport> get orders;

  /// Create a copy of LabReportsResponse
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$LabReportsResponseImplCopyWith<_$LabReportsResponseImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
