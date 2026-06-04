// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'clinic.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

Clinic _$ClinicFromJson(Map<String, dynamic> json) {
  return _Clinic.fromJson(json);
}

/// @nodoc
mixin _$Clinic {
  int get id => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  String? get address => throw _privateConstructorUsedError;
  String? get city => throw _privateConstructorUsedError;
  String? get state => throw _privateConstructorUsedError;
  @JsonKey(fromJson: _parseString)
  String? get phone => throw _privateConstructorUsedError;
  @JsonKey(name: 'clinic_type')
  String? get clinicType => throw _privateConstructorUsedError;
  @JsonKey(fromJson: _parseDouble)
  double? get latitude => throw _privateConstructorUsedError;
  @JsonKey(fromJson: _parseDouble)
  double? get longitude => throw _privateConstructorUsedError;
  @JsonKey(fromJson: _parseDouble)
  double? get rating => throw _privateConstructorUsedError;
  @JsonKey(name: 'doctor_count', fromJson: _parseInt)
  int? get doctorCount => throw _privateConstructorUsedError;
  @JsonKey(name: 'consultation_fee', fromJson: _parseDouble)
  double? get consultationFee => throw _privateConstructorUsedError;
  @JsonKey(name: 'logo_url')
  String? get logoUrl => throw _privateConstructorUsedError;

  /// Serializes this Clinic to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Clinic
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ClinicCopyWith<Clinic> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ClinicCopyWith<$Res> {
  factory $ClinicCopyWith(Clinic value, $Res Function(Clinic) then) =
      _$ClinicCopyWithImpl<$Res, Clinic>;
  @useResult
  $Res call({
    int id,
    String name,
    String? address,
    String? city,
    String? state,
    @JsonKey(fromJson: _parseString) String? phone,
    @JsonKey(name: 'clinic_type') String? clinicType,
    @JsonKey(fromJson: _parseDouble) double? latitude,
    @JsonKey(fromJson: _parseDouble) double? longitude,
    @JsonKey(fromJson: _parseDouble) double? rating,
    @JsonKey(name: 'doctor_count', fromJson: _parseInt) int? doctorCount,
    @JsonKey(name: 'consultation_fee', fromJson: _parseDouble)
    double? consultationFee,
    @JsonKey(name: 'logo_url') String? logoUrl,
  });
}

/// @nodoc
class _$ClinicCopyWithImpl<$Res, $Val extends Clinic>
    implements $ClinicCopyWith<$Res> {
  _$ClinicCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Clinic
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? address = freezed,
    Object? city = freezed,
    Object? state = freezed,
    Object? phone = freezed,
    Object? clinicType = freezed,
    Object? latitude = freezed,
    Object? longitude = freezed,
    Object? rating = freezed,
    Object? doctorCount = freezed,
    Object? consultationFee = freezed,
    Object? logoUrl = freezed,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as int,
            name: null == name
                ? _value.name
                : name // ignore: cast_nullable_to_non_nullable
                      as String,
            address: freezed == address
                ? _value.address
                : address // ignore: cast_nullable_to_non_nullable
                      as String?,
            city: freezed == city
                ? _value.city
                : city // ignore: cast_nullable_to_non_nullable
                      as String?,
            state: freezed == state
                ? _value.state
                : state // ignore: cast_nullable_to_non_nullable
                      as String?,
            phone: freezed == phone
                ? _value.phone
                : phone // ignore: cast_nullable_to_non_nullable
                      as String?,
            clinicType: freezed == clinicType
                ? _value.clinicType
                : clinicType // ignore: cast_nullable_to_non_nullable
                      as String?,
            latitude: freezed == latitude
                ? _value.latitude
                : latitude // ignore: cast_nullable_to_non_nullable
                      as double?,
            longitude: freezed == longitude
                ? _value.longitude
                : longitude // ignore: cast_nullable_to_non_nullable
                      as double?,
            rating: freezed == rating
                ? _value.rating
                : rating // ignore: cast_nullable_to_non_nullable
                      as double?,
            doctorCount: freezed == doctorCount
                ? _value.doctorCount
                : doctorCount // ignore: cast_nullable_to_non_nullable
                      as int?,
            consultationFee: freezed == consultationFee
                ? _value.consultationFee
                : consultationFee // ignore: cast_nullable_to_non_nullable
                      as double?,
            logoUrl: freezed == logoUrl
                ? _value.logoUrl
                : logoUrl // ignore: cast_nullable_to_non_nullable
                      as String?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$ClinicImplCopyWith<$Res> implements $ClinicCopyWith<$Res> {
  factory _$$ClinicImplCopyWith(
    _$ClinicImpl value,
    $Res Function(_$ClinicImpl) then,
  ) = __$$ClinicImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    int id,
    String name,
    String? address,
    String? city,
    String? state,
    @JsonKey(fromJson: _parseString) String? phone,
    @JsonKey(name: 'clinic_type') String? clinicType,
    @JsonKey(fromJson: _parseDouble) double? latitude,
    @JsonKey(fromJson: _parseDouble) double? longitude,
    @JsonKey(fromJson: _parseDouble) double? rating,
    @JsonKey(name: 'doctor_count', fromJson: _parseInt) int? doctorCount,
    @JsonKey(name: 'consultation_fee', fromJson: _parseDouble)
    double? consultationFee,
    @JsonKey(name: 'logo_url') String? logoUrl,
  });
}

/// @nodoc
class __$$ClinicImplCopyWithImpl<$Res>
    extends _$ClinicCopyWithImpl<$Res, _$ClinicImpl>
    implements _$$ClinicImplCopyWith<$Res> {
  __$$ClinicImplCopyWithImpl(
    _$ClinicImpl _value,
    $Res Function(_$ClinicImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of Clinic
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? address = freezed,
    Object? city = freezed,
    Object? state = freezed,
    Object? phone = freezed,
    Object? clinicType = freezed,
    Object? latitude = freezed,
    Object? longitude = freezed,
    Object? rating = freezed,
    Object? doctorCount = freezed,
    Object? consultationFee = freezed,
    Object? logoUrl = freezed,
  }) {
    return _then(
      _$ClinicImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as int,
        name: null == name
            ? _value.name
            : name // ignore: cast_nullable_to_non_nullable
                  as String,
        address: freezed == address
            ? _value.address
            : address // ignore: cast_nullable_to_non_nullable
                  as String?,
        city: freezed == city
            ? _value.city
            : city // ignore: cast_nullable_to_non_nullable
                  as String?,
        state: freezed == state
            ? _value.state
            : state // ignore: cast_nullable_to_non_nullable
                  as String?,
        phone: freezed == phone
            ? _value.phone
            : phone // ignore: cast_nullable_to_non_nullable
                  as String?,
        clinicType: freezed == clinicType
            ? _value.clinicType
            : clinicType // ignore: cast_nullable_to_non_nullable
                  as String?,
        latitude: freezed == latitude
            ? _value.latitude
            : latitude // ignore: cast_nullable_to_non_nullable
                  as double?,
        longitude: freezed == longitude
            ? _value.longitude
            : longitude // ignore: cast_nullable_to_non_nullable
                  as double?,
        rating: freezed == rating
            ? _value.rating
            : rating // ignore: cast_nullable_to_non_nullable
                  as double?,
        doctorCount: freezed == doctorCount
            ? _value.doctorCount
            : doctorCount // ignore: cast_nullable_to_non_nullable
                  as int?,
        consultationFee: freezed == consultationFee
            ? _value.consultationFee
            : consultationFee // ignore: cast_nullable_to_non_nullable
                  as double?,
        logoUrl: freezed == logoUrl
            ? _value.logoUrl
            : logoUrl // ignore: cast_nullable_to_non_nullable
                  as String?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$ClinicImpl implements _Clinic {
  const _$ClinicImpl({
    required this.id,
    required this.name,
    this.address,
    this.city,
    this.state,
    @JsonKey(fromJson: _parseString) this.phone,
    @JsonKey(name: 'clinic_type') this.clinicType,
    @JsonKey(fromJson: _parseDouble) this.latitude,
    @JsonKey(fromJson: _parseDouble) this.longitude,
    @JsonKey(fromJson: _parseDouble) this.rating,
    @JsonKey(name: 'doctor_count', fromJson: _parseInt) this.doctorCount,
    @JsonKey(name: 'consultation_fee', fromJson: _parseDouble)
    this.consultationFee,
    @JsonKey(name: 'logo_url') this.logoUrl,
  });

  factory _$ClinicImpl.fromJson(Map<String, dynamic> json) =>
      _$$ClinicImplFromJson(json);

  @override
  final int id;
  @override
  final String name;
  @override
  final String? address;
  @override
  final String? city;
  @override
  final String? state;
  @override
  @JsonKey(fromJson: _parseString)
  final String? phone;
  @override
  @JsonKey(name: 'clinic_type')
  final String? clinicType;
  @override
  @JsonKey(fromJson: _parseDouble)
  final double? latitude;
  @override
  @JsonKey(fromJson: _parseDouble)
  final double? longitude;
  @override
  @JsonKey(fromJson: _parseDouble)
  final double? rating;
  @override
  @JsonKey(name: 'doctor_count', fromJson: _parseInt)
  final int? doctorCount;
  @override
  @JsonKey(name: 'consultation_fee', fromJson: _parseDouble)
  final double? consultationFee;
  @override
  @JsonKey(name: 'logo_url')
  final String? logoUrl;

  @override
  String toString() {
    return 'Clinic(id: $id, name: $name, address: $address, city: $city, state: $state, phone: $phone, clinicType: $clinicType, latitude: $latitude, longitude: $longitude, rating: $rating, doctorCount: $doctorCount, consultationFee: $consultationFee, logoUrl: $logoUrl)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ClinicImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.address, address) || other.address == address) &&
            (identical(other.city, city) || other.city == city) &&
            (identical(other.state, state) || other.state == state) &&
            (identical(other.phone, phone) || other.phone == phone) &&
            (identical(other.clinicType, clinicType) ||
                other.clinicType == clinicType) &&
            (identical(other.latitude, latitude) ||
                other.latitude == latitude) &&
            (identical(other.longitude, longitude) ||
                other.longitude == longitude) &&
            (identical(other.rating, rating) || other.rating == rating) &&
            (identical(other.doctorCount, doctorCount) ||
                other.doctorCount == doctorCount) &&
            (identical(other.consultationFee, consultationFee) ||
                other.consultationFee == consultationFee) &&
            (identical(other.logoUrl, logoUrl) || other.logoUrl == logoUrl));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    name,
    address,
    city,
    state,
    phone,
    clinicType,
    latitude,
    longitude,
    rating,
    doctorCount,
    consultationFee,
    logoUrl,
  );

  /// Create a copy of Clinic
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ClinicImplCopyWith<_$ClinicImpl> get copyWith =>
      __$$ClinicImplCopyWithImpl<_$ClinicImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ClinicImplToJson(this);
  }
}

abstract class _Clinic implements Clinic {
  const factory _Clinic({
    required final int id,
    required final String name,
    final String? address,
    final String? city,
    final String? state,
    @JsonKey(fromJson: _parseString) final String? phone,
    @JsonKey(name: 'clinic_type') final String? clinicType,
    @JsonKey(fromJson: _parseDouble) final double? latitude,
    @JsonKey(fromJson: _parseDouble) final double? longitude,
    @JsonKey(fromJson: _parseDouble) final double? rating,
    @JsonKey(name: 'doctor_count', fromJson: _parseInt) final int? doctorCount,
    @JsonKey(name: 'consultation_fee', fromJson: _parseDouble)
    final double? consultationFee,
    @JsonKey(name: 'logo_url') final String? logoUrl,
  }) = _$ClinicImpl;

  factory _Clinic.fromJson(Map<String, dynamic> json) = _$ClinicImpl.fromJson;

  @override
  int get id;
  @override
  String get name;
  @override
  String? get address;
  @override
  String? get city;
  @override
  String? get state;
  @override
  @JsonKey(fromJson: _parseString)
  String? get phone;
  @override
  @JsonKey(name: 'clinic_type')
  String? get clinicType;
  @override
  @JsonKey(fromJson: _parseDouble)
  double? get latitude;
  @override
  @JsonKey(fromJson: _parseDouble)
  double? get longitude;
  @override
  @JsonKey(fromJson: _parseDouble)
  double? get rating;
  @override
  @JsonKey(name: 'doctor_count', fromJson: _parseInt)
  int? get doctorCount;
  @override
  @JsonKey(name: 'consultation_fee', fromJson: _parseDouble)
  double? get consultationFee;
  @override
  @JsonKey(name: 'logo_url')
  String? get logoUrl;

  /// Create a copy of Clinic
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ClinicImplCopyWith<_$ClinicImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
