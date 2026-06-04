// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'prescription.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

PrescriptionItem _$PrescriptionItemFromJson(Map<String, dynamic> json) {
  return _PrescriptionItem.fromJson(json);
}

/// @nodoc
mixin _$PrescriptionItem {
  @JsonKey(name: 'prescription_id')
  int get prescriptionId => throw _privateConstructorUsedError;
  @JsonKey(name: 'drug_name')
  String get drugName => throw _privateConstructorUsedError;
  @JsonKey(name: 'brand_name')
  String? get brandName => throw _privateConstructorUsedError;
  String? get dosage => throw _privateConstructorUsedError;
  String? get frequency => throw _privateConstructorUsedError;
  String? get duration => throw _privateConstructorUsedError;
  String? get route => throw _privateConstructorUsedError;
  String? get instructions => throw _privateConstructorUsedError;

  /// Serializes this PrescriptionItem to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of PrescriptionItem
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $PrescriptionItemCopyWith<PrescriptionItem> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PrescriptionItemCopyWith<$Res> {
  factory $PrescriptionItemCopyWith(
    PrescriptionItem value,
    $Res Function(PrescriptionItem) then,
  ) = _$PrescriptionItemCopyWithImpl<$Res, PrescriptionItem>;
  @useResult
  $Res call({
    @JsonKey(name: 'prescription_id') int prescriptionId,
    @JsonKey(name: 'drug_name') String drugName,
    @JsonKey(name: 'brand_name') String? brandName,
    String? dosage,
    String? frequency,
    String? duration,
    String? route,
    String? instructions,
  });
}

/// @nodoc
class _$PrescriptionItemCopyWithImpl<$Res, $Val extends PrescriptionItem>
    implements $PrescriptionItemCopyWith<$Res> {
  _$PrescriptionItemCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of PrescriptionItem
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? prescriptionId = null,
    Object? drugName = null,
    Object? brandName = freezed,
    Object? dosage = freezed,
    Object? frequency = freezed,
    Object? duration = freezed,
    Object? route = freezed,
    Object? instructions = freezed,
  }) {
    return _then(
      _value.copyWith(
            prescriptionId: null == prescriptionId
                ? _value.prescriptionId
                : prescriptionId // ignore: cast_nullable_to_non_nullable
                      as int,
            drugName: null == drugName
                ? _value.drugName
                : drugName // ignore: cast_nullable_to_non_nullable
                      as String,
            brandName: freezed == brandName
                ? _value.brandName
                : brandName // ignore: cast_nullable_to_non_nullable
                      as String?,
            dosage: freezed == dosage
                ? _value.dosage
                : dosage // ignore: cast_nullable_to_non_nullable
                      as String?,
            frequency: freezed == frequency
                ? _value.frequency
                : frequency // ignore: cast_nullable_to_non_nullable
                      as String?,
            duration: freezed == duration
                ? _value.duration
                : duration // ignore: cast_nullable_to_non_nullable
                      as String?,
            route: freezed == route
                ? _value.route
                : route // ignore: cast_nullable_to_non_nullable
                      as String?,
            instructions: freezed == instructions
                ? _value.instructions
                : instructions // ignore: cast_nullable_to_non_nullable
                      as String?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$PrescriptionItemImplCopyWith<$Res>
    implements $PrescriptionItemCopyWith<$Res> {
  factory _$$PrescriptionItemImplCopyWith(
    _$PrescriptionItemImpl value,
    $Res Function(_$PrescriptionItemImpl) then,
  ) = __$$PrescriptionItemImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    @JsonKey(name: 'prescription_id') int prescriptionId,
    @JsonKey(name: 'drug_name') String drugName,
    @JsonKey(name: 'brand_name') String? brandName,
    String? dosage,
    String? frequency,
    String? duration,
    String? route,
    String? instructions,
  });
}

/// @nodoc
class __$$PrescriptionItemImplCopyWithImpl<$Res>
    extends _$PrescriptionItemCopyWithImpl<$Res, _$PrescriptionItemImpl>
    implements _$$PrescriptionItemImplCopyWith<$Res> {
  __$$PrescriptionItemImplCopyWithImpl(
    _$PrescriptionItemImpl _value,
    $Res Function(_$PrescriptionItemImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of PrescriptionItem
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? prescriptionId = null,
    Object? drugName = null,
    Object? brandName = freezed,
    Object? dosage = freezed,
    Object? frequency = freezed,
    Object? duration = freezed,
    Object? route = freezed,
    Object? instructions = freezed,
  }) {
    return _then(
      _$PrescriptionItemImpl(
        prescriptionId: null == prescriptionId
            ? _value.prescriptionId
            : prescriptionId // ignore: cast_nullable_to_non_nullable
                  as int,
        drugName: null == drugName
            ? _value.drugName
            : drugName // ignore: cast_nullable_to_non_nullable
                  as String,
        brandName: freezed == brandName
            ? _value.brandName
            : brandName // ignore: cast_nullable_to_non_nullable
                  as String?,
        dosage: freezed == dosage
            ? _value.dosage
            : dosage // ignore: cast_nullable_to_non_nullable
                  as String?,
        frequency: freezed == frequency
            ? _value.frequency
            : frequency // ignore: cast_nullable_to_non_nullable
                  as String?,
        duration: freezed == duration
            ? _value.duration
            : duration // ignore: cast_nullable_to_non_nullable
                  as String?,
        route: freezed == route
            ? _value.route
            : route // ignore: cast_nullable_to_non_nullable
                  as String?,
        instructions: freezed == instructions
            ? _value.instructions
            : instructions // ignore: cast_nullable_to_non_nullable
                  as String?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$PrescriptionItemImpl implements _PrescriptionItem {
  const _$PrescriptionItemImpl({
    @JsonKey(name: 'prescription_id') required this.prescriptionId,
    @JsonKey(name: 'drug_name') required this.drugName,
    @JsonKey(name: 'brand_name') this.brandName,
    this.dosage,
    this.frequency,
    this.duration,
    this.route,
    this.instructions,
  });

  factory _$PrescriptionItemImpl.fromJson(Map<String, dynamic> json) =>
      _$$PrescriptionItemImplFromJson(json);

  @override
  @JsonKey(name: 'prescription_id')
  final int prescriptionId;
  @override
  @JsonKey(name: 'drug_name')
  final String drugName;
  @override
  @JsonKey(name: 'brand_name')
  final String? brandName;
  @override
  final String? dosage;
  @override
  final String? frequency;
  @override
  final String? duration;
  @override
  final String? route;
  @override
  final String? instructions;

  @override
  String toString() {
    return 'PrescriptionItem(prescriptionId: $prescriptionId, drugName: $drugName, brandName: $brandName, dosage: $dosage, frequency: $frequency, duration: $duration, route: $route, instructions: $instructions)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PrescriptionItemImpl &&
            (identical(other.prescriptionId, prescriptionId) ||
                other.prescriptionId == prescriptionId) &&
            (identical(other.drugName, drugName) ||
                other.drugName == drugName) &&
            (identical(other.brandName, brandName) ||
                other.brandName == brandName) &&
            (identical(other.dosage, dosage) || other.dosage == dosage) &&
            (identical(other.frequency, frequency) ||
                other.frequency == frequency) &&
            (identical(other.duration, duration) ||
                other.duration == duration) &&
            (identical(other.route, route) || other.route == route) &&
            (identical(other.instructions, instructions) ||
                other.instructions == instructions));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    prescriptionId,
    drugName,
    brandName,
    dosage,
    frequency,
    duration,
    route,
    instructions,
  );

  /// Create a copy of PrescriptionItem
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$PrescriptionItemImplCopyWith<_$PrescriptionItemImpl> get copyWith =>
      __$$PrescriptionItemImplCopyWithImpl<_$PrescriptionItemImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$PrescriptionItemImplToJson(this);
  }
}

abstract class _PrescriptionItem implements PrescriptionItem {
  const factory _PrescriptionItem({
    @JsonKey(name: 'prescription_id') required final int prescriptionId,
    @JsonKey(name: 'drug_name') required final String drugName,
    @JsonKey(name: 'brand_name') final String? brandName,
    final String? dosage,
    final String? frequency,
    final String? duration,
    final String? route,
    final String? instructions,
  }) = _$PrescriptionItemImpl;

  factory _PrescriptionItem.fromJson(Map<String, dynamic> json) =
      _$PrescriptionItemImpl.fromJson;

  @override
  @JsonKey(name: 'prescription_id')
  int get prescriptionId;
  @override
  @JsonKey(name: 'drug_name')
  String get drugName;
  @override
  @JsonKey(name: 'brand_name')
  String? get brandName;
  @override
  String? get dosage;
  @override
  String? get frequency;
  @override
  String? get duration;
  @override
  String? get route;
  @override
  String? get instructions;

  /// Create a copy of PrescriptionItem
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PrescriptionItemImplCopyWith<_$PrescriptionItemImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

Prescription _$PrescriptionFromJson(Map<String, dynamic> json) {
  return _Prescription.fromJson(json);
}

/// @nodoc
mixin _$Prescription {
  int get id => throw _privateConstructorUsedError;
  String? get notes => throw _privateConstructorUsedError;
  @JsonKey(name: 'created_at')
  String get createdAt => throw _privateConstructorUsedError;
  @JsonKey(name: 'doctor_name')
  String get doctorName => throw _privateConstructorUsedError;
  @JsonKey(name: 'clinic_name')
  String get clinicName => throw _privateConstructorUsedError;
  @JsonKey(name: 'clinic_city')
  String? get clinicCity => throw _privateConstructorUsedError;
  String? get diagnosis => throw _privateConstructorUsedError;
  List<PrescriptionItem> get items => throw _privateConstructorUsedError;

  /// Serializes this Prescription to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Prescription
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $PrescriptionCopyWith<Prescription> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PrescriptionCopyWith<$Res> {
  factory $PrescriptionCopyWith(
    Prescription value,
    $Res Function(Prescription) then,
  ) = _$PrescriptionCopyWithImpl<$Res, Prescription>;
  @useResult
  $Res call({
    int id,
    String? notes,
    @JsonKey(name: 'created_at') String createdAt,
    @JsonKey(name: 'doctor_name') String doctorName,
    @JsonKey(name: 'clinic_name') String clinicName,
    @JsonKey(name: 'clinic_city') String? clinicCity,
    String? diagnosis,
    List<PrescriptionItem> items,
  });
}

/// @nodoc
class _$PrescriptionCopyWithImpl<$Res, $Val extends Prescription>
    implements $PrescriptionCopyWith<$Res> {
  _$PrescriptionCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Prescription
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? notes = freezed,
    Object? createdAt = null,
    Object? doctorName = null,
    Object? clinicName = null,
    Object? clinicCity = freezed,
    Object? diagnosis = freezed,
    Object? items = null,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as int,
            notes: freezed == notes
                ? _value.notes
                : notes // ignore: cast_nullable_to_non_nullable
                      as String?,
            createdAt: null == createdAt
                ? _value.createdAt
                : createdAt // ignore: cast_nullable_to_non_nullable
                      as String,
            doctorName: null == doctorName
                ? _value.doctorName
                : doctorName // ignore: cast_nullable_to_non_nullable
                      as String,
            clinicName: null == clinicName
                ? _value.clinicName
                : clinicName // ignore: cast_nullable_to_non_nullable
                      as String,
            clinicCity: freezed == clinicCity
                ? _value.clinicCity
                : clinicCity // ignore: cast_nullable_to_non_nullable
                      as String?,
            diagnosis: freezed == diagnosis
                ? _value.diagnosis
                : diagnosis // ignore: cast_nullable_to_non_nullable
                      as String?,
            items: null == items
                ? _value.items
                : items // ignore: cast_nullable_to_non_nullable
                      as List<PrescriptionItem>,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$PrescriptionImplCopyWith<$Res>
    implements $PrescriptionCopyWith<$Res> {
  factory _$$PrescriptionImplCopyWith(
    _$PrescriptionImpl value,
    $Res Function(_$PrescriptionImpl) then,
  ) = __$$PrescriptionImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    int id,
    String? notes,
    @JsonKey(name: 'created_at') String createdAt,
    @JsonKey(name: 'doctor_name') String doctorName,
    @JsonKey(name: 'clinic_name') String clinicName,
    @JsonKey(name: 'clinic_city') String? clinicCity,
    String? diagnosis,
    List<PrescriptionItem> items,
  });
}

/// @nodoc
class __$$PrescriptionImplCopyWithImpl<$Res>
    extends _$PrescriptionCopyWithImpl<$Res, _$PrescriptionImpl>
    implements _$$PrescriptionImplCopyWith<$Res> {
  __$$PrescriptionImplCopyWithImpl(
    _$PrescriptionImpl _value,
    $Res Function(_$PrescriptionImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of Prescription
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? notes = freezed,
    Object? createdAt = null,
    Object? doctorName = null,
    Object? clinicName = null,
    Object? clinicCity = freezed,
    Object? diagnosis = freezed,
    Object? items = null,
  }) {
    return _then(
      _$PrescriptionImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as int,
        notes: freezed == notes
            ? _value.notes
            : notes // ignore: cast_nullable_to_non_nullable
                  as String?,
        createdAt: null == createdAt
            ? _value.createdAt
            : createdAt // ignore: cast_nullable_to_non_nullable
                  as String,
        doctorName: null == doctorName
            ? _value.doctorName
            : doctorName // ignore: cast_nullable_to_non_nullable
                  as String,
        clinicName: null == clinicName
            ? _value.clinicName
            : clinicName // ignore: cast_nullable_to_non_nullable
                  as String,
        clinicCity: freezed == clinicCity
            ? _value.clinicCity
            : clinicCity // ignore: cast_nullable_to_non_nullable
                  as String?,
        diagnosis: freezed == diagnosis
            ? _value.diagnosis
            : diagnosis // ignore: cast_nullable_to_non_nullable
                  as String?,
        items: null == items
            ? _value._items
            : items // ignore: cast_nullable_to_non_nullable
                  as List<PrescriptionItem>,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$PrescriptionImpl implements _Prescription {
  const _$PrescriptionImpl({
    required this.id,
    this.notes,
    @JsonKey(name: 'created_at') required this.createdAt,
    @JsonKey(name: 'doctor_name') required this.doctorName,
    @JsonKey(name: 'clinic_name') required this.clinicName,
    @JsonKey(name: 'clinic_city') this.clinicCity,
    this.diagnosis,
    required final List<PrescriptionItem> items,
  }) : _items = items;

  factory _$PrescriptionImpl.fromJson(Map<String, dynamic> json) =>
      _$$PrescriptionImplFromJson(json);

  @override
  final int id;
  @override
  final String? notes;
  @override
  @JsonKey(name: 'created_at')
  final String createdAt;
  @override
  @JsonKey(name: 'doctor_name')
  final String doctorName;
  @override
  @JsonKey(name: 'clinic_name')
  final String clinicName;
  @override
  @JsonKey(name: 'clinic_city')
  final String? clinicCity;
  @override
  final String? diagnosis;
  final List<PrescriptionItem> _items;
  @override
  List<PrescriptionItem> get items {
    if (_items is EqualUnmodifiableListView) return _items;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_items);
  }

  @override
  String toString() {
    return 'Prescription(id: $id, notes: $notes, createdAt: $createdAt, doctorName: $doctorName, clinicName: $clinicName, clinicCity: $clinicCity, diagnosis: $diagnosis, items: $items)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PrescriptionImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.notes, notes) || other.notes == notes) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.doctorName, doctorName) ||
                other.doctorName == doctorName) &&
            (identical(other.clinicName, clinicName) ||
                other.clinicName == clinicName) &&
            (identical(other.clinicCity, clinicCity) ||
                other.clinicCity == clinicCity) &&
            (identical(other.diagnosis, diagnosis) ||
                other.diagnosis == diagnosis) &&
            const DeepCollectionEquality().equals(other._items, _items));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    notes,
    createdAt,
    doctorName,
    clinicName,
    clinicCity,
    diagnosis,
    const DeepCollectionEquality().hash(_items),
  );

  /// Create a copy of Prescription
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$PrescriptionImplCopyWith<_$PrescriptionImpl> get copyWith =>
      __$$PrescriptionImplCopyWithImpl<_$PrescriptionImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$PrescriptionImplToJson(this);
  }
}

abstract class _Prescription implements Prescription {
  const factory _Prescription({
    required final int id,
    final String? notes,
    @JsonKey(name: 'created_at') required final String createdAt,
    @JsonKey(name: 'doctor_name') required final String doctorName,
    @JsonKey(name: 'clinic_name') required final String clinicName,
    @JsonKey(name: 'clinic_city') final String? clinicCity,
    final String? diagnosis,
    required final List<PrescriptionItem> items,
  }) = _$PrescriptionImpl;

  factory _Prescription.fromJson(Map<String, dynamic> json) =
      _$PrescriptionImpl.fromJson;

  @override
  int get id;
  @override
  String? get notes;
  @override
  @JsonKey(name: 'created_at')
  String get createdAt;
  @override
  @JsonKey(name: 'doctor_name')
  String get doctorName;
  @override
  @JsonKey(name: 'clinic_name')
  String get clinicName;
  @override
  @JsonKey(name: 'clinic_city')
  String? get clinicCity;
  @override
  String? get diagnosis;
  @override
  List<PrescriptionItem> get items;

  /// Create a copy of Prescription
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PrescriptionImplCopyWith<_$PrescriptionImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

PrescriptionsResponse _$PrescriptionsResponseFromJson(
  Map<String, dynamic> json,
) {
  return _PrescriptionsResponse.fromJson(json);
}

/// @nodoc
mixin _$PrescriptionsResponse {
  List<Prescription> get prescriptions => throw _privateConstructorUsedError;

  /// Serializes this PrescriptionsResponse to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of PrescriptionsResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $PrescriptionsResponseCopyWith<PrescriptionsResponse> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PrescriptionsResponseCopyWith<$Res> {
  factory $PrescriptionsResponseCopyWith(
    PrescriptionsResponse value,
    $Res Function(PrescriptionsResponse) then,
  ) = _$PrescriptionsResponseCopyWithImpl<$Res, PrescriptionsResponse>;
  @useResult
  $Res call({List<Prescription> prescriptions});
}

/// @nodoc
class _$PrescriptionsResponseCopyWithImpl<
  $Res,
  $Val extends PrescriptionsResponse
>
    implements $PrescriptionsResponseCopyWith<$Res> {
  _$PrescriptionsResponseCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of PrescriptionsResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? prescriptions = null}) {
    return _then(
      _value.copyWith(
            prescriptions: null == prescriptions
                ? _value.prescriptions
                : prescriptions // ignore: cast_nullable_to_non_nullable
                      as List<Prescription>,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$PrescriptionsResponseImplCopyWith<$Res>
    implements $PrescriptionsResponseCopyWith<$Res> {
  factory _$$PrescriptionsResponseImplCopyWith(
    _$PrescriptionsResponseImpl value,
    $Res Function(_$PrescriptionsResponseImpl) then,
  ) = __$$PrescriptionsResponseImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({List<Prescription> prescriptions});
}

/// @nodoc
class __$$PrescriptionsResponseImplCopyWithImpl<$Res>
    extends
        _$PrescriptionsResponseCopyWithImpl<$Res, _$PrescriptionsResponseImpl>
    implements _$$PrescriptionsResponseImplCopyWith<$Res> {
  __$$PrescriptionsResponseImplCopyWithImpl(
    _$PrescriptionsResponseImpl _value,
    $Res Function(_$PrescriptionsResponseImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of PrescriptionsResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? prescriptions = null}) {
    return _then(
      _$PrescriptionsResponseImpl(
        prescriptions: null == prescriptions
            ? _value._prescriptions
            : prescriptions // ignore: cast_nullable_to_non_nullable
                  as List<Prescription>,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$PrescriptionsResponseImpl implements _PrescriptionsResponse {
  const _$PrescriptionsResponseImpl({
    required final List<Prescription> prescriptions,
  }) : _prescriptions = prescriptions;

  factory _$PrescriptionsResponseImpl.fromJson(Map<String, dynamic> json) =>
      _$$PrescriptionsResponseImplFromJson(json);

  final List<Prescription> _prescriptions;
  @override
  List<Prescription> get prescriptions {
    if (_prescriptions is EqualUnmodifiableListView) return _prescriptions;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_prescriptions);
  }

  @override
  String toString() {
    return 'PrescriptionsResponse(prescriptions: $prescriptions)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PrescriptionsResponseImpl &&
            const DeepCollectionEquality().equals(
              other._prescriptions,
              _prescriptions,
            ));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    const DeepCollectionEquality().hash(_prescriptions),
  );

  /// Create a copy of PrescriptionsResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$PrescriptionsResponseImplCopyWith<_$PrescriptionsResponseImpl>
  get copyWith =>
      __$$PrescriptionsResponseImplCopyWithImpl<_$PrescriptionsResponseImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$PrescriptionsResponseImplToJson(this);
  }
}

abstract class _PrescriptionsResponse implements PrescriptionsResponse {
  const factory _PrescriptionsResponse({
    required final List<Prescription> prescriptions,
  }) = _$PrescriptionsResponseImpl;

  factory _PrescriptionsResponse.fromJson(Map<String, dynamic> json) =
      _$PrescriptionsResponseImpl.fromJson;

  @override
  List<Prescription> get prescriptions;

  /// Create a copy of PrescriptionsResponse
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PrescriptionsResponseImplCopyWith<_$PrescriptionsResponseImpl>
  get copyWith => throw _privateConstructorUsedError;
}
