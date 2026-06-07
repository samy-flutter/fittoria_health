// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'profile_models.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

LookupItem _$LookupItemFromJson(Map<String, dynamic> json) {
  return _LookupItem.fromJson(json);
}

/// @nodoc
mixin _$LookupItem {
  @JsonKey(fromJson: _parseIntRequired)
  int get id => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;

  /// Serializes this LookupItem to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of LookupItem
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $LookupItemCopyWith<LookupItem> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $LookupItemCopyWith<$Res> {
  factory $LookupItemCopyWith(
    LookupItem value,
    $Res Function(LookupItem) then,
  ) = _$LookupItemCopyWithImpl<$Res, LookupItem>;
  @useResult
  $Res call({@JsonKey(fromJson: _parseIntRequired) int id, String name});
}

/// @nodoc
class _$LookupItemCopyWithImpl<$Res, $Val extends LookupItem>
    implements $LookupItemCopyWith<$Res> {
  _$LookupItemCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of LookupItem
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? id = null, Object? name = null}) {
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
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$LookupItemImplCopyWith<$Res>
    implements $LookupItemCopyWith<$Res> {
  factory _$$LookupItemImplCopyWith(
    _$LookupItemImpl value,
    $Res Function(_$LookupItemImpl) then,
  ) = __$$LookupItemImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({@JsonKey(fromJson: _parseIntRequired) int id, String name});
}

/// @nodoc
class __$$LookupItemImplCopyWithImpl<$Res>
    extends _$LookupItemCopyWithImpl<$Res, _$LookupItemImpl>
    implements _$$LookupItemImplCopyWith<$Res> {
  __$$LookupItemImplCopyWithImpl(
    _$LookupItemImpl _value,
    $Res Function(_$LookupItemImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of LookupItem
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? id = null, Object? name = null}) {
    return _then(
      _$LookupItemImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as int,
        name: null == name
            ? _value.name
            : name // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$LookupItemImpl implements _LookupItem {
  const _$LookupItemImpl({
    @JsonKey(fromJson: _parseIntRequired) required this.id,
    required this.name,
  });

  factory _$LookupItemImpl.fromJson(Map<String, dynamic> json) =>
      _$$LookupItemImplFromJson(json);

  @override
  @JsonKey(fromJson: _parseIntRequired)
  final int id;
  @override
  final String name;

  @override
  String toString() {
    return 'LookupItem(id: $id, name: $name)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$LookupItemImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, name);

  /// Create a copy of LookupItem
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$LookupItemImplCopyWith<_$LookupItemImpl> get copyWith =>
      __$$LookupItemImplCopyWithImpl<_$LookupItemImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$LookupItemImplToJson(this);
  }
}

abstract class _LookupItem implements LookupItem {
  const factory _LookupItem({
    @JsonKey(fromJson: _parseIntRequired) required final int id,
    required final String name,
  }) = _$LookupItemImpl;

  factory _LookupItem.fromJson(Map<String, dynamic> json) =
      _$LookupItemImpl.fromJson;

  @override
  @JsonKey(fromJson: _parseIntRequired)
  int get id;
  @override
  String get name;

  /// Create a copy of LookupItem
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$LookupItemImplCopyWith<_$LookupItemImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

PatientProfile _$PatientProfileFromJson(Map<String, dynamic> json) {
  return _PatientProfile.fromJson(json);
}

/// @nodoc
mixin _$PatientProfile {
  @JsonKey(fromJson: _parseIntRequired)
  int get id => throw _privateConstructorUsedError;
  @JsonKey(name: 'full_name')
  String get fullName => throw _privateConstructorUsedError;
  String get phone => throw _privateConstructorUsedError;
  String? get email => throw _privateConstructorUsedError;
  @JsonKey(name: 'fittoria_id')
  String? get fittoriaId => throw _privateConstructorUsedError;
  @JsonKey(name: 'gender_id', fromJson: _parseInt)
  int? get genderId => throw _privateConstructorUsedError;
  @JsonKey(name: 'gender_name')
  String? get genderName => throw _privateConstructorUsedError;
  @JsonKey(name: 'blood_group_id', fromJson: _parseInt)
  int? get bloodGroupId => throw _privateConstructorUsedError;
  @JsonKey(name: 'blood_group_name')
  String? get bloodGroupName => throw _privateConstructorUsedError;
  @JsonKey(name: 'date_of_birth')
  String? get dateOfBirth => throw _privateConstructorUsedError;
  @JsonKey(name: 'address_line1')
  String? get addressLine1 => throw _privateConstructorUsedError;
  String? get city => throw _privateConstructorUsedError;
  String? get state => throw _privateConstructorUsedError;
  String? get pincode => throw _privateConstructorUsedError;
  @JsonKey(name: 'emergency_name')
  String? get emergencyName => throw _privateConstructorUsedError;
  @JsonKey(name: 'emergency_phone')
  String? get emergencyPhone => throw _privateConstructorUsedError;
  @JsonKey(name: 'emergency_relation')
  String? get emergencyRelation => throw _privateConstructorUsedError;
  @JsonKey(name: 'height_cm', fromJson: _parseDouble)
  double? get heightCm => throw _privateConstructorUsedError;
  @JsonKey(name: 'weight_kg', fromJson: _parseDouble)
  double? get weightKg => throw _privateConstructorUsedError;
  String? get allergies => throw _privateConstructorUsedError;
  @JsonKey(name: 'current_medications')
  String? get currentMedications => throw _privateConstructorUsedError;
  @JsonKey(name: 'registered_at')
  String get registeredAt => throw _privateConstructorUsedError;

  /// Serializes this PatientProfile to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of PatientProfile
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $PatientProfileCopyWith<PatientProfile> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PatientProfileCopyWith<$Res> {
  factory $PatientProfileCopyWith(
    PatientProfile value,
    $Res Function(PatientProfile) then,
  ) = _$PatientProfileCopyWithImpl<$Res, PatientProfile>;
  @useResult
  $Res call({
    @JsonKey(fromJson: _parseIntRequired) int id,
    @JsonKey(name: 'full_name') String fullName,
    String phone,
    String? email,
    @JsonKey(name: 'fittoria_id') String? fittoriaId,
    @JsonKey(name: 'gender_id', fromJson: _parseInt) int? genderId,
    @JsonKey(name: 'gender_name') String? genderName,
    @JsonKey(name: 'blood_group_id', fromJson: _parseInt) int? bloodGroupId,
    @JsonKey(name: 'blood_group_name') String? bloodGroupName,
    @JsonKey(name: 'date_of_birth') String? dateOfBirth,
    @JsonKey(name: 'address_line1') String? addressLine1,
    String? city,
    String? state,
    String? pincode,
    @JsonKey(name: 'emergency_name') String? emergencyName,
    @JsonKey(name: 'emergency_phone') String? emergencyPhone,
    @JsonKey(name: 'emergency_relation') String? emergencyRelation,
    @JsonKey(name: 'height_cm', fromJson: _parseDouble) double? heightCm,
    @JsonKey(name: 'weight_kg', fromJson: _parseDouble) double? weightKg,
    String? allergies,
    @JsonKey(name: 'current_medications') String? currentMedications,
    @JsonKey(name: 'registered_at') String registeredAt,
  });
}

/// @nodoc
class _$PatientProfileCopyWithImpl<$Res, $Val extends PatientProfile>
    implements $PatientProfileCopyWith<$Res> {
  _$PatientProfileCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of PatientProfile
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? fullName = null,
    Object? phone = null,
    Object? email = freezed,
    Object? fittoriaId = freezed,
    Object? genderId = freezed,
    Object? genderName = freezed,
    Object? bloodGroupId = freezed,
    Object? bloodGroupName = freezed,
    Object? dateOfBirth = freezed,
    Object? addressLine1 = freezed,
    Object? city = freezed,
    Object? state = freezed,
    Object? pincode = freezed,
    Object? emergencyName = freezed,
    Object? emergencyPhone = freezed,
    Object? emergencyRelation = freezed,
    Object? heightCm = freezed,
    Object? weightKg = freezed,
    Object? allergies = freezed,
    Object? currentMedications = freezed,
    Object? registeredAt = null,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as int,
            fullName: null == fullName
                ? _value.fullName
                : fullName // ignore: cast_nullable_to_non_nullable
                      as String,
            phone: null == phone
                ? _value.phone
                : phone // ignore: cast_nullable_to_non_nullable
                      as String,
            email: freezed == email
                ? _value.email
                : email // ignore: cast_nullable_to_non_nullable
                      as String?,
            fittoriaId: freezed == fittoriaId
                ? _value.fittoriaId
                : fittoriaId // ignore: cast_nullable_to_non_nullable
                      as String?,
            genderId: freezed == genderId
                ? _value.genderId
                : genderId // ignore: cast_nullable_to_non_nullable
                      as int?,
            genderName: freezed == genderName
                ? _value.genderName
                : genderName // ignore: cast_nullable_to_non_nullable
                      as String?,
            bloodGroupId: freezed == bloodGroupId
                ? _value.bloodGroupId
                : bloodGroupId // ignore: cast_nullable_to_non_nullable
                      as int?,
            bloodGroupName: freezed == bloodGroupName
                ? _value.bloodGroupName
                : bloodGroupName // ignore: cast_nullable_to_non_nullable
                      as String?,
            dateOfBirth: freezed == dateOfBirth
                ? _value.dateOfBirth
                : dateOfBirth // ignore: cast_nullable_to_non_nullable
                      as String?,
            addressLine1: freezed == addressLine1
                ? _value.addressLine1
                : addressLine1 // ignore: cast_nullable_to_non_nullable
                      as String?,
            city: freezed == city
                ? _value.city
                : city // ignore: cast_nullable_to_non_nullable
                      as String?,
            state: freezed == state
                ? _value.state
                : state // ignore: cast_nullable_to_non_nullable
                      as String?,
            pincode: freezed == pincode
                ? _value.pincode
                : pincode // ignore: cast_nullable_to_non_nullable
                      as String?,
            emergencyName: freezed == emergencyName
                ? _value.emergencyName
                : emergencyName // ignore: cast_nullable_to_non_nullable
                      as String?,
            emergencyPhone: freezed == emergencyPhone
                ? _value.emergencyPhone
                : emergencyPhone // ignore: cast_nullable_to_non_nullable
                      as String?,
            emergencyRelation: freezed == emergencyRelation
                ? _value.emergencyRelation
                : emergencyRelation // ignore: cast_nullable_to_non_nullable
                      as String?,
            heightCm: freezed == heightCm
                ? _value.heightCm
                : heightCm // ignore: cast_nullable_to_non_nullable
                      as double?,
            weightKg: freezed == weightKg
                ? _value.weightKg
                : weightKg // ignore: cast_nullable_to_non_nullable
                      as double?,
            allergies: freezed == allergies
                ? _value.allergies
                : allergies // ignore: cast_nullable_to_non_nullable
                      as String?,
            currentMedications: freezed == currentMedications
                ? _value.currentMedications
                : currentMedications // ignore: cast_nullable_to_non_nullable
                      as String?,
            registeredAt: null == registeredAt
                ? _value.registeredAt
                : registeredAt // ignore: cast_nullable_to_non_nullable
                      as String,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$PatientProfileImplCopyWith<$Res>
    implements $PatientProfileCopyWith<$Res> {
  factory _$$PatientProfileImplCopyWith(
    _$PatientProfileImpl value,
    $Res Function(_$PatientProfileImpl) then,
  ) = __$$PatientProfileImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    @JsonKey(fromJson: _parseIntRequired) int id,
    @JsonKey(name: 'full_name') String fullName,
    String phone,
    String? email,
    @JsonKey(name: 'fittoria_id') String? fittoriaId,
    @JsonKey(name: 'gender_id', fromJson: _parseInt) int? genderId,
    @JsonKey(name: 'gender_name') String? genderName,
    @JsonKey(name: 'blood_group_id', fromJson: _parseInt) int? bloodGroupId,
    @JsonKey(name: 'blood_group_name') String? bloodGroupName,
    @JsonKey(name: 'date_of_birth') String? dateOfBirth,
    @JsonKey(name: 'address_line1') String? addressLine1,
    String? city,
    String? state,
    String? pincode,
    @JsonKey(name: 'emergency_name') String? emergencyName,
    @JsonKey(name: 'emergency_phone') String? emergencyPhone,
    @JsonKey(name: 'emergency_relation') String? emergencyRelation,
    @JsonKey(name: 'height_cm', fromJson: _parseDouble) double? heightCm,
    @JsonKey(name: 'weight_kg', fromJson: _parseDouble) double? weightKg,
    String? allergies,
    @JsonKey(name: 'current_medications') String? currentMedications,
    @JsonKey(name: 'registered_at') String registeredAt,
  });
}

/// @nodoc
class __$$PatientProfileImplCopyWithImpl<$Res>
    extends _$PatientProfileCopyWithImpl<$Res, _$PatientProfileImpl>
    implements _$$PatientProfileImplCopyWith<$Res> {
  __$$PatientProfileImplCopyWithImpl(
    _$PatientProfileImpl _value,
    $Res Function(_$PatientProfileImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of PatientProfile
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? fullName = null,
    Object? phone = null,
    Object? email = freezed,
    Object? fittoriaId = freezed,
    Object? genderId = freezed,
    Object? genderName = freezed,
    Object? bloodGroupId = freezed,
    Object? bloodGroupName = freezed,
    Object? dateOfBirth = freezed,
    Object? addressLine1 = freezed,
    Object? city = freezed,
    Object? state = freezed,
    Object? pincode = freezed,
    Object? emergencyName = freezed,
    Object? emergencyPhone = freezed,
    Object? emergencyRelation = freezed,
    Object? heightCm = freezed,
    Object? weightKg = freezed,
    Object? allergies = freezed,
    Object? currentMedications = freezed,
    Object? registeredAt = null,
  }) {
    return _then(
      _$PatientProfileImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as int,
        fullName: null == fullName
            ? _value.fullName
            : fullName // ignore: cast_nullable_to_non_nullable
                  as String,
        phone: null == phone
            ? _value.phone
            : phone // ignore: cast_nullable_to_non_nullable
                  as String,
        email: freezed == email
            ? _value.email
            : email // ignore: cast_nullable_to_non_nullable
                  as String?,
        fittoriaId: freezed == fittoriaId
            ? _value.fittoriaId
            : fittoriaId // ignore: cast_nullable_to_non_nullable
                  as String?,
        genderId: freezed == genderId
            ? _value.genderId
            : genderId // ignore: cast_nullable_to_non_nullable
                  as int?,
        genderName: freezed == genderName
            ? _value.genderName
            : genderName // ignore: cast_nullable_to_non_nullable
                  as String?,
        bloodGroupId: freezed == bloodGroupId
            ? _value.bloodGroupId
            : bloodGroupId // ignore: cast_nullable_to_non_nullable
                  as int?,
        bloodGroupName: freezed == bloodGroupName
            ? _value.bloodGroupName
            : bloodGroupName // ignore: cast_nullable_to_non_nullable
                  as String?,
        dateOfBirth: freezed == dateOfBirth
            ? _value.dateOfBirth
            : dateOfBirth // ignore: cast_nullable_to_non_nullable
                  as String?,
        addressLine1: freezed == addressLine1
            ? _value.addressLine1
            : addressLine1 // ignore: cast_nullable_to_non_nullable
                  as String?,
        city: freezed == city
            ? _value.city
            : city // ignore: cast_nullable_to_non_nullable
                  as String?,
        state: freezed == state
            ? _value.state
            : state // ignore: cast_nullable_to_non_nullable
                  as String?,
        pincode: freezed == pincode
            ? _value.pincode
            : pincode // ignore: cast_nullable_to_non_nullable
                  as String?,
        emergencyName: freezed == emergencyName
            ? _value.emergencyName
            : emergencyName // ignore: cast_nullable_to_non_nullable
                  as String?,
        emergencyPhone: freezed == emergencyPhone
            ? _value.emergencyPhone
            : emergencyPhone // ignore: cast_nullable_to_non_nullable
                  as String?,
        emergencyRelation: freezed == emergencyRelation
            ? _value.emergencyRelation
            : emergencyRelation // ignore: cast_nullable_to_non_nullable
                  as String?,
        heightCm: freezed == heightCm
            ? _value.heightCm
            : heightCm // ignore: cast_nullable_to_non_nullable
                  as double?,
        weightKg: freezed == weightKg
            ? _value.weightKg
            : weightKg // ignore: cast_nullable_to_non_nullable
                  as double?,
        allergies: freezed == allergies
            ? _value.allergies
            : allergies // ignore: cast_nullable_to_non_nullable
                  as String?,
        currentMedications: freezed == currentMedications
            ? _value.currentMedications
            : currentMedications // ignore: cast_nullable_to_non_nullable
                  as String?,
        registeredAt: null == registeredAt
            ? _value.registeredAt
            : registeredAt // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$PatientProfileImpl implements _PatientProfile {
  const _$PatientProfileImpl({
    @JsonKey(fromJson: _parseIntRequired) required this.id,
    @JsonKey(name: 'full_name') required this.fullName,
    required this.phone,
    this.email,
    @JsonKey(name: 'fittoria_id') this.fittoriaId,
    @JsonKey(name: 'gender_id', fromJson: _parseInt) this.genderId,
    @JsonKey(name: 'gender_name') this.genderName,
    @JsonKey(name: 'blood_group_id', fromJson: _parseInt) this.bloodGroupId,
    @JsonKey(name: 'blood_group_name') this.bloodGroupName,
    @JsonKey(name: 'date_of_birth') this.dateOfBirth,
    @JsonKey(name: 'address_line1') this.addressLine1,
    this.city,
    this.state,
    this.pincode,
    @JsonKey(name: 'emergency_name') this.emergencyName,
    @JsonKey(name: 'emergency_phone') this.emergencyPhone,
    @JsonKey(name: 'emergency_relation') this.emergencyRelation,
    @JsonKey(name: 'height_cm', fromJson: _parseDouble) this.heightCm,
    @JsonKey(name: 'weight_kg', fromJson: _parseDouble) this.weightKg,
    this.allergies,
    @JsonKey(name: 'current_medications') this.currentMedications,
    @JsonKey(name: 'registered_at') required this.registeredAt,
  });

  factory _$PatientProfileImpl.fromJson(Map<String, dynamic> json) =>
      _$$PatientProfileImplFromJson(json);

  @override
  @JsonKey(fromJson: _parseIntRequired)
  final int id;
  @override
  @JsonKey(name: 'full_name')
  final String fullName;
  @override
  final String phone;
  @override
  final String? email;
  @override
  @JsonKey(name: 'fittoria_id')
  final String? fittoriaId;
  @override
  @JsonKey(name: 'gender_id', fromJson: _parseInt)
  final int? genderId;
  @override
  @JsonKey(name: 'gender_name')
  final String? genderName;
  @override
  @JsonKey(name: 'blood_group_id', fromJson: _parseInt)
  final int? bloodGroupId;
  @override
  @JsonKey(name: 'blood_group_name')
  final String? bloodGroupName;
  @override
  @JsonKey(name: 'date_of_birth')
  final String? dateOfBirth;
  @override
  @JsonKey(name: 'address_line1')
  final String? addressLine1;
  @override
  final String? city;
  @override
  final String? state;
  @override
  final String? pincode;
  @override
  @JsonKey(name: 'emergency_name')
  final String? emergencyName;
  @override
  @JsonKey(name: 'emergency_phone')
  final String? emergencyPhone;
  @override
  @JsonKey(name: 'emergency_relation')
  final String? emergencyRelation;
  @override
  @JsonKey(name: 'height_cm', fromJson: _parseDouble)
  final double? heightCm;
  @override
  @JsonKey(name: 'weight_kg', fromJson: _parseDouble)
  final double? weightKg;
  @override
  final String? allergies;
  @override
  @JsonKey(name: 'current_medications')
  final String? currentMedications;
  @override
  @JsonKey(name: 'registered_at')
  final String registeredAt;

  @override
  String toString() {
    return 'PatientProfile(id: $id, fullName: $fullName, phone: $phone, email: $email, fittoriaId: $fittoriaId, genderId: $genderId, genderName: $genderName, bloodGroupId: $bloodGroupId, bloodGroupName: $bloodGroupName, dateOfBirth: $dateOfBirth, addressLine1: $addressLine1, city: $city, state: $state, pincode: $pincode, emergencyName: $emergencyName, emergencyPhone: $emergencyPhone, emergencyRelation: $emergencyRelation, heightCm: $heightCm, weightKg: $weightKg, allergies: $allergies, currentMedications: $currentMedications, registeredAt: $registeredAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PatientProfileImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.fullName, fullName) ||
                other.fullName == fullName) &&
            (identical(other.phone, phone) || other.phone == phone) &&
            (identical(other.email, email) || other.email == email) &&
            (identical(other.fittoriaId, fittoriaId) ||
                other.fittoriaId == fittoriaId) &&
            (identical(other.genderId, genderId) ||
                other.genderId == genderId) &&
            (identical(other.genderName, genderName) ||
                other.genderName == genderName) &&
            (identical(other.bloodGroupId, bloodGroupId) ||
                other.bloodGroupId == bloodGroupId) &&
            (identical(other.bloodGroupName, bloodGroupName) ||
                other.bloodGroupName == bloodGroupName) &&
            (identical(other.dateOfBirth, dateOfBirth) ||
                other.dateOfBirth == dateOfBirth) &&
            (identical(other.addressLine1, addressLine1) ||
                other.addressLine1 == addressLine1) &&
            (identical(other.city, city) || other.city == city) &&
            (identical(other.state, state) || other.state == state) &&
            (identical(other.pincode, pincode) || other.pincode == pincode) &&
            (identical(other.emergencyName, emergencyName) ||
                other.emergencyName == emergencyName) &&
            (identical(other.emergencyPhone, emergencyPhone) ||
                other.emergencyPhone == emergencyPhone) &&
            (identical(other.emergencyRelation, emergencyRelation) ||
                other.emergencyRelation == emergencyRelation) &&
            (identical(other.heightCm, heightCm) ||
                other.heightCm == heightCm) &&
            (identical(other.weightKg, weightKg) ||
                other.weightKg == weightKg) &&
            (identical(other.allergies, allergies) ||
                other.allergies == allergies) &&
            (identical(other.currentMedications, currentMedications) ||
                other.currentMedications == currentMedications) &&
            (identical(other.registeredAt, registeredAt) ||
                other.registeredAt == registeredAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hashAll([
    runtimeType,
    id,
    fullName,
    phone,
    email,
    fittoriaId,
    genderId,
    genderName,
    bloodGroupId,
    bloodGroupName,
    dateOfBirth,
    addressLine1,
    city,
    state,
    pincode,
    emergencyName,
    emergencyPhone,
    emergencyRelation,
    heightCm,
    weightKg,
    allergies,
    currentMedications,
    registeredAt,
  ]);

  /// Create a copy of PatientProfile
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$PatientProfileImplCopyWith<_$PatientProfileImpl> get copyWith =>
      __$$PatientProfileImplCopyWithImpl<_$PatientProfileImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$PatientProfileImplToJson(this);
  }
}

abstract class _PatientProfile implements PatientProfile {
  const factory _PatientProfile({
    @JsonKey(fromJson: _parseIntRequired) required final int id,
    @JsonKey(name: 'full_name') required final String fullName,
    required final String phone,
    final String? email,
    @JsonKey(name: 'fittoria_id') final String? fittoriaId,
    @JsonKey(name: 'gender_id', fromJson: _parseInt) final int? genderId,
    @JsonKey(name: 'gender_name') final String? genderName,
    @JsonKey(name: 'blood_group_id', fromJson: _parseInt)
    final int? bloodGroupId,
    @JsonKey(name: 'blood_group_name') final String? bloodGroupName,
    @JsonKey(name: 'date_of_birth') final String? dateOfBirth,
    @JsonKey(name: 'address_line1') final String? addressLine1,
    final String? city,
    final String? state,
    final String? pincode,
    @JsonKey(name: 'emergency_name') final String? emergencyName,
    @JsonKey(name: 'emergency_phone') final String? emergencyPhone,
    @JsonKey(name: 'emergency_relation') final String? emergencyRelation,
    @JsonKey(name: 'height_cm', fromJson: _parseDouble) final double? heightCm,
    @JsonKey(name: 'weight_kg', fromJson: _parseDouble) final double? weightKg,
    final String? allergies,
    @JsonKey(name: 'current_medications') final String? currentMedications,
    @JsonKey(name: 'registered_at') required final String registeredAt,
  }) = _$PatientProfileImpl;

  factory _PatientProfile.fromJson(Map<String, dynamic> json) =
      _$PatientProfileImpl.fromJson;

  @override
  @JsonKey(fromJson: _parseIntRequired)
  int get id;
  @override
  @JsonKey(name: 'full_name')
  String get fullName;
  @override
  String get phone;
  @override
  String? get email;
  @override
  @JsonKey(name: 'fittoria_id')
  String? get fittoriaId;
  @override
  @JsonKey(name: 'gender_id', fromJson: _parseInt)
  int? get genderId;
  @override
  @JsonKey(name: 'gender_name')
  String? get genderName;
  @override
  @JsonKey(name: 'blood_group_id', fromJson: _parseInt)
  int? get bloodGroupId;
  @override
  @JsonKey(name: 'blood_group_name')
  String? get bloodGroupName;
  @override
  @JsonKey(name: 'date_of_birth')
  String? get dateOfBirth;
  @override
  @JsonKey(name: 'address_line1')
  String? get addressLine1;
  @override
  String? get city;
  @override
  String? get state;
  @override
  String? get pincode;
  @override
  @JsonKey(name: 'emergency_name')
  String? get emergencyName;
  @override
  @JsonKey(name: 'emergency_phone')
  String? get emergencyPhone;
  @override
  @JsonKey(name: 'emergency_relation')
  String? get emergencyRelation;
  @override
  @JsonKey(name: 'height_cm', fromJson: _parseDouble)
  double? get heightCm;
  @override
  @JsonKey(name: 'weight_kg', fromJson: _parseDouble)
  double? get weightKg;
  @override
  String? get allergies;
  @override
  @JsonKey(name: 'current_medications')
  String? get currentMedications;
  @override
  @JsonKey(name: 'registered_at')
  String get registeredAt;

  /// Create a copy of PatientProfile
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PatientProfileImplCopyWith<_$PatientProfileImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

ProfileResponse _$ProfileResponseFromJson(Map<String, dynamic> json) {
  return _ProfileResponse.fromJson(json);
}

/// @nodoc
mixin _$ProfileResponse {
  PatientProfile get patient => throw _privateConstructorUsedError;
  List<LookupItem> get genders => throw _privateConstructorUsedError;
  @JsonKey(name: 'blood_groups')
  List<LookupItem> get bloodGroups => throw _privateConstructorUsedError;
  @JsonKey(name: 'medical_history')
  List<MedicalHistoryItem> get medicalHistory =>
      throw _privateConstructorUsedError;

  /// Serializes this ProfileResponse to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ProfileResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ProfileResponseCopyWith<ProfileResponse> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ProfileResponseCopyWith<$Res> {
  factory $ProfileResponseCopyWith(
    ProfileResponse value,
    $Res Function(ProfileResponse) then,
  ) = _$ProfileResponseCopyWithImpl<$Res, ProfileResponse>;
  @useResult
  $Res call({
    PatientProfile patient,
    List<LookupItem> genders,
    @JsonKey(name: 'blood_groups') List<LookupItem> bloodGroups,
    @JsonKey(name: 'medical_history') List<MedicalHistoryItem> medicalHistory,
  });

  $PatientProfileCopyWith<$Res> get patient;
}

/// @nodoc
class _$ProfileResponseCopyWithImpl<$Res, $Val extends ProfileResponse>
    implements $ProfileResponseCopyWith<$Res> {
  _$ProfileResponseCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ProfileResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? patient = null,
    Object? genders = null,
    Object? bloodGroups = null,
    Object? medicalHistory = null,
  }) {
    return _then(
      _value.copyWith(
            patient: null == patient
                ? _value.patient
                : patient // ignore: cast_nullable_to_non_nullable
                      as PatientProfile,
            genders: null == genders
                ? _value.genders
                : genders // ignore: cast_nullable_to_non_nullable
                      as List<LookupItem>,
            bloodGroups: null == bloodGroups
                ? _value.bloodGroups
                : bloodGroups // ignore: cast_nullable_to_non_nullable
                      as List<LookupItem>,
            medicalHistory: null == medicalHistory
                ? _value.medicalHistory
                : medicalHistory // ignore: cast_nullable_to_non_nullable
                      as List<MedicalHistoryItem>,
          )
          as $Val,
    );
  }

  /// Create a copy of ProfileResponse
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $PatientProfileCopyWith<$Res> get patient {
    return $PatientProfileCopyWith<$Res>(_value.patient, (value) {
      return _then(_value.copyWith(patient: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$ProfileResponseImplCopyWith<$Res>
    implements $ProfileResponseCopyWith<$Res> {
  factory _$$ProfileResponseImplCopyWith(
    _$ProfileResponseImpl value,
    $Res Function(_$ProfileResponseImpl) then,
  ) = __$$ProfileResponseImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    PatientProfile patient,
    List<LookupItem> genders,
    @JsonKey(name: 'blood_groups') List<LookupItem> bloodGroups,
    @JsonKey(name: 'medical_history') List<MedicalHistoryItem> medicalHistory,
  });

  @override
  $PatientProfileCopyWith<$Res> get patient;
}

/// @nodoc
class __$$ProfileResponseImplCopyWithImpl<$Res>
    extends _$ProfileResponseCopyWithImpl<$Res, _$ProfileResponseImpl>
    implements _$$ProfileResponseImplCopyWith<$Res> {
  __$$ProfileResponseImplCopyWithImpl(
    _$ProfileResponseImpl _value,
    $Res Function(_$ProfileResponseImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of ProfileResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? patient = null,
    Object? genders = null,
    Object? bloodGroups = null,
    Object? medicalHistory = null,
  }) {
    return _then(
      _$ProfileResponseImpl(
        patient: null == patient
            ? _value.patient
            : patient // ignore: cast_nullable_to_non_nullable
                  as PatientProfile,
        genders: null == genders
            ? _value._genders
            : genders // ignore: cast_nullable_to_non_nullable
                  as List<LookupItem>,
        bloodGroups: null == bloodGroups
            ? _value._bloodGroups
            : bloodGroups // ignore: cast_nullable_to_non_nullable
                  as List<LookupItem>,
        medicalHistory: null == medicalHistory
            ? _value._medicalHistory
            : medicalHistory // ignore: cast_nullable_to_non_nullable
                  as List<MedicalHistoryItem>,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$ProfileResponseImpl implements _ProfileResponse {
  const _$ProfileResponseImpl({
    required this.patient,
    required final List<LookupItem> genders,
    @JsonKey(name: 'blood_groups') required final List<LookupItem> bloodGroups,
    @JsonKey(name: 'medical_history')
    required final List<MedicalHistoryItem> medicalHistory,
  }) : _genders = genders,
       _bloodGroups = bloodGroups,
       _medicalHistory = medicalHistory;

  factory _$ProfileResponseImpl.fromJson(Map<String, dynamic> json) =>
      _$$ProfileResponseImplFromJson(json);

  @override
  final PatientProfile patient;
  final List<LookupItem> _genders;
  @override
  List<LookupItem> get genders {
    if (_genders is EqualUnmodifiableListView) return _genders;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_genders);
  }

  final List<LookupItem> _bloodGroups;
  @override
  @JsonKey(name: 'blood_groups')
  List<LookupItem> get bloodGroups {
    if (_bloodGroups is EqualUnmodifiableListView) return _bloodGroups;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_bloodGroups);
  }

  final List<MedicalHistoryItem> _medicalHistory;
  @override
  @JsonKey(name: 'medical_history')
  List<MedicalHistoryItem> get medicalHistory {
    if (_medicalHistory is EqualUnmodifiableListView) return _medicalHistory;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_medicalHistory);
  }

  @override
  String toString() {
    return 'ProfileResponse(patient: $patient, genders: $genders, bloodGroups: $bloodGroups, medicalHistory: $medicalHistory)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ProfileResponseImpl &&
            (identical(other.patient, patient) || other.patient == patient) &&
            const DeepCollectionEquality().equals(other._genders, _genders) &&
            const DeepCollectionEquality().equals(
              other._bloodGroups,
              _bloodGroups,
            ) &&
            const DeepCollectionEquality().equals(
              other._medicalHistory,
              _medicalHistory,
            ));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    patient,
    const DeepCollectionEquality().hash(_genders),
    const DeepCollectionEquality().hash(_bloodGroups),
    const DeepCollectionEquality().hash(_medicalHistory),
  );

  /// Create a copy of ProfileResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ProfileResponseImplCopyWith<_$ProfileResponseImpl> get copyWith =>
      __$$ProfileResponseImplCopyWithImpl<_$ProfileResponseImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$ProfileResponseImplToJson(this);
  }
}

abstract class _ProfileResponse implements ProfileResponse {
  const factory _ProfileResponse({
    required final PatientProfile patient,
    required final List<LookupItem> genders,
    @JsonKey(name: 'blood_groups') required final List<LookupItem> bloodGroups,
    @JsonKey(name: 'medical_history')
    required final List<MedicalHistoryItem> medicalHistory,
  }) = _$ProfileResponseImpl;

  factory _ProfileResponse.fromJson(Map<String, dynamic> json) =
      _$ProfileResponseImpl.fromJson;

  @override
  PatientProfile get patient;
  @override
  List<LookupItem> get genders;
  @override
  @JsonKey(name: 'blood_groups')
  List<LookupItem> get bloodGroups;
  @override
  @JsonKey(name: 'medical_history')
  List<MedicalHistoryItem> get medicalHistory;

  /// Create a copy of ProfileResponse
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ProfileResponseImplCopyWith<_$ProfileResponseImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
