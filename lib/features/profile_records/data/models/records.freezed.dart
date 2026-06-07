// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'records.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

PatientRecordProfile _$PatientRecordProfileFromJson(Map<String, dynamic> json) {
  return _PatientRecordProfile.fromJson(json);
}

/// @nodoc
mixin _$PatientRecordProfile {
  @JsonKey(fromJson: _parseIntRequired)
  int get id => throw _privateConstructorUsedError;
  @JsonKey(name: 'full_name')
  String get fullName => throw _privateConstructorUsedError;
  String? get allergies => throw _privateConstructorUsedError;
  @JsonKey(name: 'current_medications')
  String? get currentMedications => throw _privateConstructorUsedError;
  @JsonKey(name: 'blood_group_id', fromJson: _parseInt)
  int? get bloodGroupId => throw _privateConstructorUsedError;
  @JsonKey(name: 'blood_group_name')
  String? get bloodGroupName => throw _privateConstructorUsedError;
  @JsonKey(name: 'height_cm', fromJson: _parseDouble)
  double? get heightCm => throw _privateConstructorUsedError;
  @JsonKey(name: 'weight_kg', fromJson: _parseDouble)
  double? get weightKg => throw _privateConstructorUsedError;

  /// Serializes this PatientRecordProfile to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of PatientRecordProfile
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $PatientRecordProfileCopyWith<PatientRecordProfile> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PatientRecordProfileCopyWith<$Res> {
  factory $PatientRecordProfileCopyWith(
    PatientRecordProfile value,
    $Res Function(PatientRecordProfile) then,
  ) = _$PatientRecordProfileCopyWithImpl<$Res, PatientRecordProfile>;
  @useResult
  $Res call({
    @JsonKey(fromJson: _parseIntRequired) int id,
    @JsonKey(name: 'full_name') String fullName,
    String? allergies,
    @JsonKey(name: 'current_medications') String? currentMedications,
    @JsonKey(name: 'blood_group_id', fromJson: _parseInt) int? bloodGroupId,
    @JsonKey(name: 'blood_group_name') String? bloodGroupName,
    @JsonKey(name: 'height_cm', fromJson: _parseDouble) double? heightCm,
    @JsonKey(name: 'weight_kg', fromJson: _parseDouble) double? weightKg,
  });
}

/// @nodoc
class _$PatientRecordProfileCopyWithImpl<
  $Res,
  $Val extends PatientRecordProfile
>
    implements $PatientRecordProfileCopyWith<$Res> {
  _$PatientRecordProfileCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of PatientRecordProfile
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? fullName = null,
    Object? allergies = freezed,
    Object? currentMedications = freezed,
    Object? bloodGroupId = freezed,
    Object? bloodGroupName = freezed,
    Object? heightCm = freezed,
    Object? weightKg = freezed,
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
            allergies: freezed == allergies
                ? _value.allergies
                : allergies // ignore: cast_nullable_to_non_nullable
                      as String?,
            currentMedications: freezed == currentMedications
                ? _value.currentMedications
                : currentMedications // ignore: cast_nullable_to_non_nullable
                      as String?,
            bloodGroupId: freezed == bloodGroupId
                ? _value.bloodGroupId
                : bloodGroupId // ignore: cast_nullable_to_non_nullable
                      as int?,
            bloodGroupName: freezed == bloodGroupName
                ? _value.bloodGroupName
                : bloodGroupName // ignore: cast_nullable_to_non_nullable
                      as String?,
            heightCm: freezed == heightCm
                ? _value.heightCm
                : heightCm // ignore: cast_nullable_to_non_nullable
                      as double?,
            weightKg: freezed == weightKg
                ? _value.weightKg
                : weightKg // ignore: cast_nullable_to_non_nullable
                      as double?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$PatientRecordProfileImplCopyWith<$Res>
    implements $PatientRecordProfileCopyWith<$Res> {
  factory _$$PatientRecordProfileImplCopyWith(
    _$PatientRecordProfileImpl value,
    $Res Function(_$PatientRecordProfileImpl) then,
  ) = __$$PatientRecordProfileImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    @JsonKey(fromJson: _parseIntRequired) int id,
    @JsonKey(name: 'full_name') String fullName,
    String? allergies,
    @JsonKey(name: 'current_medications') String? currentMedications,
    @JsonKey(name: 'blood_group_id', fromJson: _parseInt) int? bloodGroupId,
    @JsonKey(name: 'blood_group_name') String? bloodGroupName,
    @JsonKey(name: 'height_cm', fromJson: _parseDouble) double? heightCm,
    @JsonKey(name: 'weight_kg', fromJson: _parseDouble) double? weightKg,
  });
}

/// @nodoc
class __$$PatientRecordProfileImplCopyWithImpl<$Res>
    extends _$PatientRecordProfileCopyWithImpl<$Res, _$PatientRecordProfileImpl>
    implements _$$PatientRecordProfileImplCopyWith<$Res> {
  __$$PatientRecordProfileImplCopyWithImpl(
    _$PatientRecordProfileImpl _value,
    $Res Function(_$PatientRecordProfileImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of PatientRecordProfile
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? fullName = null,
    Object? allergies = freezed,
    Object? currentMedications = freezed,
    Object? bloodGroupId = freezed,
    Object? bloodGroupName = freezed,
    Object? heightCm = freezed,
    Object? weightKg = freezed,
  }) {
    return _then(
      _$PatientRecordProfileImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as int,
        fullName: null == fullName
            ? _value.fullName
            : fullName // ignore: cast_nullable_to_non_nullable
                  as String,
        allergies: freezed == allergies
            ? _value.allergies
            : allergies // ignore: cast_nullable_to_non_nullable
                  as String?,
        currentMedications: freezed == currentMedications
            ? _value.currentMedications
            : currentMedications // ignore: cast_nullable_to_non_nullable
                  as String?,
        bloodGroupId: freezed == bloodGroupId
            ? _value.bloodGroupId
            : bloodGroupId // ignore: cast_nullable_to_non_nullable
                  as int?,
        bloodGroupName: freezed == bloodGroupName
            ? _value.bloodGroupName
            : bloodGroupName // ignore: cast_nullable_to_non_nullable
                  as String?,
        heightCm: freezed == heightCm
            ? _value.heightCm
            : heightCm // ignore: cast_nullable_to_non_nullable
                  as double?,
        weightKg: freezed == weightKg
            ? _value.weightKg
            : weightKg // ignore: cast_nullable_to_non_nullable
                  as double?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$PatientRecordProfileImpl implements _PatientRecordProfile {
  const _$PatientRecordProfileImpl({
    @JsonKey(fromJson: _parseIntRequired) required this.id,
    @JsonKey(name: 'full_name') required this.fullName,
    this.allergies,
    @JsonKey(name: 'current_medications') this.currentMedications,
    @JsonKey(name: 'blood_group_id', fromJson: _parseInt) this.bloodGroupId,
    @JsonKey(name: 'blood_group_name') this.bloodGroupName,
    @JsonKey(name: 'height_cm', fromJson: _parseDouble) this.heightCm,
    @JsonKey(name: 'weight_kg', fromJson: _parseDouble) this.weightKg,
  });

  factory _$PatientRecordProfileImpl.fromJson(Map<String, dynamic> json) =>
      _$$PatientRecordProfileImplFromJson(json);

  @override
  @JsonKey(fromJson: _parseIntRequired)
  final int id;
  @override
  @JsonKey(name: 'full_name')
  final String fullName;
  @override
  final String? allergies;
  @override
  @JsonKey(name: 'current_medications')
  final String? currentMedications;
  @override
  @JsonKey(name: 'blood_group_id', fromJson: _parseInt)
  final int? bloodGroupId;
  @override
  @JsonKey(name: 'blood_group_name')
  final String? bloodGroupName;
  @override
  @JsonKey(name: 'height_cm', fromJson: _parseDouble)
  final double? heightCm;
  @override
  @JsonKey(name: 'weight_kg', fromJson: _parseDouble)
  final double? weightKg;

  @override
  String toString() {
    return 'PatientRecordProfile(id: $id, fullName: $fullName, allergies: $allergies, currentMedications: $currentMedications, bloodGroupId: $bloodGroupId, bloodGroupName: $bloodGroupName, heightCm: $heightCm, weightKg: $weightKg)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PatientRecordProfileImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.fullName, fullName) ||
                other.fullName == fullName) &&
            (identical(other.allergies, allergies) ||
                other.allergies == allergies) &&
            (identical(other.currentMedications, currentMedications) ||
                other.currentMedications == currentMedications) &&
            (identical(other.bloodGroupId, bloodGroupId) ||
                other.bloodGroupId == bloodGroupId) &&
            (identical(other.bloodGroupName, bloodGroupName) ||
                other.bloodGroupName == bloodGroupName) &&
            (identical(other.heightCm, heightCm) ||
                other.heightCm == heightCm) &&
            (identical(other.weightKg, weightKg) ||
                other.weightKg == weightKg));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    fullName,
    allergies,
    currentMedications,
    bloodGroupId,
    bloodGroupName,
    heightCm,
    weightKg,
  );

  /// Create a copy of PatientRecordProfile
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$PatientRecordProfileImplCopyWith<_$PatientRecordProfileImpl>
  get copyWith =>
      __$$PatientRecordProfileImplCopyWithImpl<_$PatientRecordProfileImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$PatientRecordProfileImplToJson(this);
  }
}

abstract class _PatientRecordProfile implements PatientRecordProfile {
  const factory _PatientRecordProfile({
    @JsonKey(fromJson: _parseIntRequired) required final int id,
    @JsonKey(name: 'full_name') required final String fullName,
    final String? allergies,
    @JsonKey(name: 'current_medications') final String? currentMedications,
    @JsonKey(name: 'blood_group_id', fromJson: _parseInt)
    final int? bloodGroupId,
    @JsonKey(name: 'blood_group_name') final String? bloodGroupName,
    @JsonKey(name: 'height_cm', fromJson: _parseDouble) final double? heightCm,
    @JsonKey(name: 'weight_kg', fromJson: _parseDouble) final double? weightKg,
  }) = _$PatientRecordProfileImpl;

  factory _PatientRecordProfile.fromJson(Map<String, dynamic> json) =
      _$PatientRecordProfileImpl.fromJson;

  @override
  @JsonKey(fromJson: _parseIntRequired)
  int get id;
  @override
  @JsonKey(name: 'full_name')
  String get fullName;
  @override
  String? get allergies;
  @override
  @JsonKey(name: 'current_medications')
  String? get currentMedications;
  @override
  @JsonKey(name: 'blood_group_id', fromJson: _parseInt)
  int? get bloodGroupId;
  @override
  @JsonKey(name: 'blood_group_name')
  String? get bloodGroupName;
  @override
  @JsonKey(name: 'height_cm', fromJson: _parseDouble)
  double? get heightCm;
  @override
  @JsonKey(name: 'weight_kg', fromJson: _parseDouble)
  double? get weightKg;

  /// Create a copy of PatientRecordProfile
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PatientRecordProfileImplCopyWith<_$PatientRecordProfileImpl>
  get copyWith => throw _privateConstructorUsedError;
}

CaseSheet _$CaseSheetFromJson(Map<String, dynamic> json) {
  return _CaseSheet.fromJson(json);
}

/// @nodoc
mixin _$CaseSheet {
  @JsonKey(fromJson: _parseIntRequired)
  int get id => throw _privateConstructorUsedError;
  @JsonKey(name: 'chief_complaint')
  String? get chiefComplaint => throw _privateConstructorUsedError;
  @JsonKey(name: 'history_of_illness')
  String? get historyOfIllness => throw _privateConstructorUsedError;
  String? get diagnosis => throw _privateConstructorUsedError;
  String? get plan => throw _privateConstructorUsedError;
  @JsonKey(name: 'bp_systolic', fromJson: _parseDouble)
  double? get bpSystolic => throw _privateConstructorUsedError;
  @JsonKey(name: 'bp_diastolic', fromJson: _parseDouble)
  double? get bpDiastolic => throw _privateConstructorUsedError;
  @JsonKey(name: 'pulse_bpm', fromJson: _parseDouble)
  double? get pulseBpm => throw _privateConstructorUsedError;
  @JsonKey(name: 'temperature_f', fromJson: _parseDouble)
  double? get temperatureF => throw _privateConstructorUsedError;
  @JsonKey(name: 'spo2_percent', fromJson: _parseDouble)
  double? get spo2Percent => throw _privateConstructorUsedError;
  @JsonKey(name: 'weight_kg', fromJson: _parseDouble)
  double? get weightKg => throw _privateConstructorUsedError;
  @JsonKey(name: 'height_cm', fromJson: _parseDouble)
  double? get heightCm => throw _privateConstructorUsedError;
  @JsonKey(fromJson: _parseDouble)
  double? get bmi => throw _privateConstructorUsedError;
  @JsonKey(name: 'general_examination')
  String? get generalExamination => throw _privateConstructorUsedError;
  @JsonKey(name: 'systemic_examination')
  String? get systemicExamination => throw _privateConstructorUsedError;
  @JsonKey(name: 'follow_up_date')
  String? get followUpDate => throw _privateConstructorUsedError;
  @JsonKey(name: 'created_at')
  String get createdAt => throw _privateConstructorUsedError;
  @JsonKey(name: 'doctor_name')
  String get doctorName => throw _privateConstructorUsedError;
  @JsonKey(name: 'clinic_name')
  String get clinicName => throw _privateConstructorUsedError;
  @JsonKey(name: 'clinic_city')
  String? get clinicCity => throw _privateConstructorUsedError;

  /// Serializes this CaseSheet to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of CaseSheet
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $CaseSheetCopyWith<CaseSheet> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CaseSheetCopyWith<$Res> {
  factory $CaseSheetCopyWith(CaseSheet value, $Res Function(CaseSheet) then) =
      _$CaseSheetCopyWithImpl<$Res, CaseSheet>;
  @useResult
  $Res call({
    @JsonKey(fromJson: _parseIntRequired) int id,
    @JsonKey(name: 'chief_complaint') String? chiefComplaint,
    @JsonKey(name: 'history_of_illness') String? historyOfIllness,
    String? diagnosis,
    String? plan,
    @JsonKey(name: 'bp_systolic', fromJson: _parseDouble) double? bpSystolic,
    @JsonKey(name: 'bp_diastolic', fromJson: _parseDouble) double? bpDiastolic,
    @JsonKey(name: 'pulse_bpm', fromJson: _parseDouble) double? pulseBpm,
    @JsonKey(name: 'temperature_f', fromJson: _parseDouble)
    double? temperatureF,
    @JsonKey(name: 'spo2_percent', fromJson: _parseDouble) double? spo2Percent,
    @JsonKey(name: 'weight_kg', fromJson: _parseDouble) double? weightKg,
    @JsonKey(name: 'height_cm', fromJson: _parseDouble) double? heightCm,
    @JsonKey(fromJson: _parseDouble) double? bmi,
    @JsonKey(name: 'general_examination') String? generalExamination,
    @JsonKey(name: 'systemic_examination') String? systemicExamination,
    @JsonKey(name: 'follow_up_date') String? followUpDate,
    @JsonKey(name: 'created_at') String createdAt,
    @JsonKey(name: 'doctor_name') String doctorName,
    @JsonKey(name: 'clinic_name') String clinicName,
    @JsonKey(name: 'clinic_city') String? clinicCity,
  });
}

/// @nodoc
class _$CaseSheetCopyWithImpl<$Res, $Val extends CaseSheet>
    implements $CaseSheetCopyWith<$Res> {
  _$CaseSheetCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of CaseSheet
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? chiefComplaint = freezed,
    Object? historyOfIllness = freezed,
    Object? diagnosis = freezed,
    Object? plan = freezed,
    Object? bpSystolic = freezed,
    Object? bpDiastolic = freezed,
    Object? pulseBpm = freezed,
    Object? temperatureF = freezed,
    Object? spo2Percent = freezed,
    Object? weightKg = freezed,
    Object? heightCm = freezed,
    Object? bmi = freezed,
    Object? generalExamination = freezed,
    Object? systemicExamination = freezed,
    Object? followUpDate = freezed,
    Object? createdAt = null,
    Object? doctorName = null,
    Object? clinicName = null,
    Object? clinicCity = freezed,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as int,
            chiefComplaint: freezed == chiefComplaint
                ? _value.chiefComplaint
                : chiefComplaint // ignore: cast_nullable_to_non_nullable
                      as String?,
            historyOfIllness: freezed == historyOfIllness
                ? _value.historyOfIllness
                : historyOfIllness // ignore: cast_nullable_to_non_nullable
                      as String?,
            diagnosis: freezed == diagnosis
                ? _value.diagnosis
                : diagnosis // ignore: cast_nullable_to_non_nullable
                      as String?,
            plan: freezed == plan
                ? _value.plan
                : plan // ignore: cast_nullable_to_non_nullable
                      as String?,
            bpSystolic: freezed == bpSystolic
                ? _value.bpSystolic
                : bpSystolic // ignore: cast_nullable_to_non_nullable
                      as double?,
            bpDiastolic: freezed == bpDiastolic
                ? _value.bpDiastolic
                : bpDiastolic // ignore: cast_nullable_to_non_nullable
                      as double?,
            pulseBpm: freezed == pulseBpm
                ? _value.pulseBpm
                : pulseBpm // ignore: cast_nullable_to_non_nullable
                      as double?,
            temperatureF: freezed == temperatureF
                ? _value.temperatureF
                : temperatureF // ignore: cast_nullable_to_non_nullable
                      as double?,
            spo2Percent: freezed == spo2Percent
                ? _value.spo2Percent
                : spo2Percent // ignore: cast_nullable_to_non_nullable
                      as double?,
            weightKg: freezed == weightKg
                ? _value.weightKg
                : weightKg // ignore: cast_nullable_to_non_nullable
                      as double?,
            heightCm: freezed == heightCm
                ? _value.heightCm
                : heightCm // ignore: cast_nullable_to_non_nullable
                      as double?,
            bmi: freezed == bmi
                ? _value.bmi
                : bmi // ignore: cast_nullable_to_non_nullable
                      as double?,
            generalExamination: freezed == generalExamination
                ? _value.generalExamination
                : generalExamination // ignore: cast_nullable_to_non_nullable
                      as String?,
            systemicExamination: freezed == systemicExamination
                ? _value.systemicExamination
                : systemicExamination // ignore: cast_nullable_to_non_nullable
                      as String?,
            followUpDate: freezed == followUpDate
                ? _value.followUpDate
                : followUpDate // ignore: cast_nullable_to_non_nullable
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
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$CaseSheetImplCopyWith<$Res>
    implements $CaseSheetCopyWith<$Res> {
  factory _$$CaseSheetImplCopyWith(
    _$CaseSheetImpl value,
    $Res Function(_$CaseSheetImpl) then,
  ) = __$$CaseSheetImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    @JsonKey(fromJson: _parseIntRequired) int id,
    @JsonKey(name: 'chief_complaint') String? chiefComplaint,
    @JsonKey(name: 'history_of_illness') String? historyOfIllness,
    String? diagnosis,
    String? plan,
    @JsonKey(name: 'bp_systolic', fromJson: _parseDouble) double? bpSystolic,
    @JsonKey(name: 'bp_diastolic', fromJson: _parseDouble) double? bpDiastolic,
    @JsonKey(name: 'pulse_bpm', fromJson: _parseDouble) double? pulseBpm,
    @JsonKey(name: 'temperature_f', fromJson: _parseDouble)
    double? temperatureF,
    @JsonKey(name: 'spo2_percent', fromJson: _parseDouble) double? spo2Percent,
    @JsonKey(name: 'weight_kg', fromJson: _parseDouble) double? weightKg,
    @JsonKey(name: 'height_cm', fromJson: _parseDouble) double? heightCm,
    @JsonKey(fromJson: _parseDouble) double? bmi,
    @JsonKey(name: 'general_examination') String? generalExamination,
    @JsonKey(name: 'systemic_examination') String? systemicExamination,
    @JsonKey(name: 'follow_up_date') String? followUpDate,
    @JsonKey(name: 'created_at') String createdAt,
    @JsonKey(name: 'doctor_name') String doctorName,
    @JsonKey(name: 'clinic_name') String clinicName,
    @JsonKey(name: 'clinic_city') String? clinicCity,
  });
}

/// @nodoc
class __$$CaseSheetImplCopyWithImpl<$Res>
    extends _$CaseSheetCopyWithImpl<$Res, _$CaseSheetImpl>
    implements _$$CaseSheetImplCopyWith<$Res> {
  __$$CaseSheetImplCopyWithImpl(
    _$CaseSheetImpl _value,
    $Res Function(_$CaseSheetImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of CaseSheet
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? chiefComplaint = freezed,
    Object? historyOfIllness = freezed,
    Object? diagnosis = freezed,
    Object? plan = freezed,
    Object? bpSystolic = freezed,
    Object? bpDiastolic = freezed,
    Object? pulseBpm = freezed,
    Object? temperatureF = freezed,
    Object? spo2Percent = freezed,
    Object? weightKg = freezed,
    Object? heightCm = freezed,
    Object? bmi = freezed,
    Object? generalExamination = freezed,
    Object? systemicExamination = freezed,
    Object? followUpDate = freezed,
    Object? createdAt = null,
    Object? doctorName = null,
    Object? clinicName = null,
    Object? clinicCity = freezed,
  }) {
    return _then(
      _$CaseSheetImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as int,
        chiefComplaint: freezed == chiefComplaint
            ? _value.chiefComplaint
            : chiefComplaint // ignore: cast_nullable_to_non_nullable
                  as String?,
        historyOfIllness: freezed == historyOfIllness
            ? _value.historyOfIllness
            : historyOfIllness // ignore: cast_nullable_to_non_nullable
                  as String?,
        diagnosis: freezed == diagnosis
            ? _value.diagnosis
            : diagnosis // ignore: cast_nullable_to_non_nullable
                  as String?,
        plan: freezed == plan
            ? _value.plan
            : plan // ignore: cast_nullable_to_non_nullable
                  as String?,
        bpSystolic: freezed == bpSystolic
            ? _value.bpSystolic
            : bpSystolic // ignore: cast_nullable_to_non_nullable
                  as double?,
        bpDiastolic: freezed == bpDiastolic
            ? _value.bpDiastolic
            : bpDiastolic // ignore: cast_nullable_to_non_nullable
                  as double?,
        pulseBpm: freezed == pulseBpm
            ? _value.pulseBpm
            : pulseBpm // ignore: cast_nullable_to_non_nullable
                  as double?,
        temperatureF: freezed == temperatureF
            ? _value.temperatureF
            : temperatureF // ignore: cast_nullable_to_non_nullable
                  as double?,
        spo2Percent: freezed == spo2Percent
            ? _value.spo2Percent
            : spo2Percent // ignore: cast_nullable_to_non_nullable
                  as double?,
        weightKg: freezed == weightKg
            ? _value.weightKg
            : weightKg // ignore: cast_nullable_to_non_nullable
                  as double?,
        heightCm: freezed == heightCm
            ? _value.heightCm
            : heightCm // ignore: cast_nullable_to_non_nullable
                  as double?,
        bmi: freezed == bmi
            ? _value.bmi
            : bmi // ignore: cast_nullable_to_non_nullable
                  as double?,
        generalExamination: freezed == generalExamination
            ? _value.generalExamination
            : generalExamination // ignore: cast_nullable_to_non_nullable
                  as String?,
        systemicExamination: freezed == systemicExamination
            ? _value.systemicExamination
            : systemicExamination // ignore: cast_nullable_to_non_nullable
                  as String?,
        followUpDate: freezed == followUpDate
            ? _value.followUpDate
            : followUpDate // ignore: cast_nullable_to_non_nullable
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
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$CaseSheetImpl implements _CaseSheet {
  const _$CaseSheetImpl({
    @JsonKey(fromJson: _parseIntRequired) required this.id,
    @JsonKey(name: 'chief_complaint') this.chiefComplaint,
    @JsonKey(name: 'history_of_illness') this.historyOfIllness,
    this.diagnosis,
    this.plan,
    @JsonKey(name: 'bp_systolic', fromJson: _parseDouble) this.bpSystolic,
    @JsonKey(name: 'bp_diastolic', fromJson: _parseDouble) this.bpDiastolic,
    @JsonKey(name: 'pulse_bpm', fromJson: _parseDouble) this.pulseBpm,
    @JsonKey(name: 'temperature_f', fromJson: _parseDouble) this.temperatureF,
    @JsonKey(name: 'spo2_percent', fromJson: _parseDouble) this.spo2Percent,
    @JsonKey(name: 'weight_kg', fromJson: _parseDouble) this.weightKg,
    @JsonKey(name: 'height_cm', fromJson: _parseDouble) this.heightCm,
    @JsonKey(fromJson: _parseDouble) this.bmi,
    @JsonKey(name: 'general_examination') this.generalExamination,
    @JsonKey(name: 'systemic_examination') this.systemicExamination,
    @JsonKey(name: 'follow_up_date') this.followUpDate,
    @JsonKey(name: 'created_at') required this.createdAt,
    @JsonKey(name: 'doctor_name') required this.doctorName,
    @JsonKey(name: 'clinic_name') required this.clinicName,
    @JsonKey(name: 'clinic_city') this.clinicCity,
  });

  factory _$CaseSheetImpl.fromJson(Map<String, dynamic> json) =>
      _$$CaseSheetImplFromJson(json);

  @override
  @JsonKey(fromJson: _parseIntRequired)
  final int id;
  @override
  @JsonKey(name: 'chief_complaint')
  final String? chiefComplaint;
  @override
  @JsonKey(name: 'history_of_illness')
  final String? historyOfIllness;
  @override
  final String? diagnosis;
  @override
  final String? plan;
  @override
  @JsonKey(name: 'bp_systolic', fromJson: _parseDouble)
  final double? bpSystolic;
  @override
  @JsonKey(name: 'bp_diastolic', fromJson: _parseDouble)
  final double? bpDiastolic;
  @override
  @JsonKey(name: 'pulse_bpm', fromJson: _parseDouble)
  final double? pulseBpm;
  @override
  @JsonKey(name: 'temperature_f', fromJson: _parseDouble)
  final double? temperatureF;
  @override
  @JsonKey(name: 'spo2_percent', fromJson: _parseDouble)
  final double? spo2Percent;
  @override
  @JsonKey(name: 'weight_kg', fromJson: _parseDouble)
  final double? weightKg;
  @override
  @JsonKey(name: 'height_cm', fromJson: _parseDouble)
  final double? heightCm;
  @override
  @JsonKey(fromJson: _parseDouble)
  final double? bmi;
  @override
  @JsonKey(name: 'general_examination')
  final String? generalExamination;
  @override
  @JsonKey(name: 'systemic_examination')
  final String? systemicExamination;
  @override
  @JsonKey(name: 'follow_up_date')
  final String? followUpDate;
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
  String toString() {
    return 'CaseSheet(id: $id, chiefComplaint: $chiefComplaint, historyOfIllness: $historyOfIllness, diagnosis: $diagnosis, plan: $plan, bpSystolic: $bpSystolic, bpDiastolic: $bpDiastolic, pulseBpm: $pulseBpm, temperatureF: $temperatureF, spo2Percent: $spo2Percent, weightKg: $weightKg, heightCm: $heightCm, bmi: $bmi, generalExamination: $generalExamination, systemicExamination: $systemicExamination, followUpDate: $followUpDate, createdAt: $createdAt, doctorName: $doctorName, clinicName: $clinicName, clinicCity: $clinicCity)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CaseSheetImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.chiefComplaint, chiefComplaint) ||
                other.chiefComplaint == chiefComplaint) &&
            (identical(other.historyOfIllness, historyOfIllness) ||
                other.historyOfIllness == historyOfIllness) &&
            (identical(other.diagnosis, diagnosis) ||
                other.diagnosis == diagnosis) &&
            (identical(other.plan, plan) || other.plan == plan) &&
            (identical(other.bpSystolic, bpSystolic) ||
                other.bpSystolic == bpSystolic) &&
            (identical(other.bpDiastolic, bpDiastolic) ||
                other.bpDiastolic == bpDiastolic) &&
            (identical(other.pulseBpm, pulseBpm) ||
                other.pulseBpm == pulseBpm) &&
            (identical(other.temperatureF, temperatureF) ||
                other.temperatureF == temperatureF) &&
            (identical(other.spo2Percent, spo2Percent) ||
                other.spo2Percent == spo2Percent) &&
            (identical(other.weightKg, weightKg) ||
                other.weightKg == weightKg) &&
            (identical(other.heightCm, heightCm) ||
                other.heightCm == heightCm) &&
            (identical(other.bmi, bmi) || other.bmi == bmi) &&
            (identical(other.generalExamination, generalExamination) ||
                other.generalExamination == generalExamination) &&
            (identical(other.systemicExamination, systemicExamination) ||
                other.systemicExamination == systemicExamination) &&
            (identical(other.followUpDate, followUpDate) ||
                other.followUpDate == followUpDate) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.doctorName, doctorName) ||
                other.doctorName == doctorName) &&
            (identical(other.clinicName, clinicName) ||
                other.clinicName == clinicName) &&
            (identical(other.clinicCity, clinicCity) ||
                other.clinicCity == clinicCity));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hashAll([
    runtimeType,
    id,
    chiefComplaint,
    historyOfIllness,
    diagnosis,
    plan,
    bpSystolic,
    bpDiastolic,
    pulseBpm,
    temperatureF,
    spo2Percent,
    weightKg,
    heightCm,
    bmi,
    generalExamination,
    systemicExamination,
    followUpDate,
    createdAt,
    doctorName,
    clinicName,
    clinicCity,
  ]);

  /// Create a copy of CaseSheet
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$CaseSheetImplCopyWith<_$CaseSheetImpl> get copyWith =>
      __$$CaseSheetImplCopyWithImpl<_$CaseSheetImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$CaseSheetImplToJson(this);
  }
}

abstract class _CaseSheet implements CaseSheet {
  const factory _CaseSheet({
    @JsonKey(fromJson: _parseIntRequired) required final int id,
    @JsonKey(name: 'chief_complaint') final String? chiefComplaint,
    @JsonKey(name: 'history_of_illness') final String? historyOfIllness,
    final String? diagnosis,
    final String? plan,
    @JsonKey(name: 'bp_systolic', fromJson: _parseDouble)
    final double? bpSystolic,
    @JsonKey(name: 'bp_diastolic', fromJson: _parseDouble)
    final double? bpDiastolic,
    @JsonKey(name: 'pulse_bpm', fromJson: _parseDouble) final double? pulseBpm,
    @JsonKey(name: 'temperature_f', fromJson: _parseDouble)
    final double? temperatureF,
    @JsonKey(name: 'spo2_percent', fromJson: _parseDouble)
    final double? spo2Percent,
    @JsonKey(name: 'weight_kg', fromJson: _parseDouble) final double? weightKg,
    @JsonKey(name: 'height_cm', fromJson: _parseDouble) final double? heightCm,
    @JsonKey(fromJson: _parseDouble) final double? bmi,
    @JsonKey(name: 'general_examination') final String? generalExamination,
    @JsonKey(name: 'systemic_examination') final String? systemicExamination,
    @JsonKey(name: 'follow_up_date') final String? followUpDate,
    @JsonKey(name: 'created_at') required final String createdAt,
    @JsonKey(name: 'doctor_name') required final String doctorName,
    @JsonKey(name: 'clinic_name') required final String clinicName,
    @JsonKey(name: 'clinic_city') final String? clinicCity,
  }) = _$CaseSheetImpl;

  factory _CaseSheet.fromJson(Map<String, dynamic> json) =
      _$CaseSheetImpl.fromJson;

  @override
  @JsonKey(fromJson: _parseIntRequired)
  int get id;
  @override
  @JsonKey(name: 'chief_complaint')
  String? get chiefComplaint;
  @override
  @JsonKey(name: 'history_of_illness')
  String? get historyOfIllness;
  @override
  String? get diagnosis;
  @override
  String? get plan;
  @override
  @JsonKey(name: 'bp_systolic', fromJson: _parseDouble)
  double? get bpSystolic;
  @override
  @JsonKey(name: 'bp_diastolic', fromJson: _parseDouble)
  double? get bpDiastolic;
  @override
  @JsonKey(name: 'pulse_bpm', fromJson: _parseDouble)
  double? get pulseBpm;
  @override
  @JsonKey(name: 'temperature_f', fromJson: _parseDouble)
  double? get temperatureF;
  @override
  @JsonKey(name: 'spo2_percent', fromJson: _parseDouble)
  double? get spo2Percent;
  @override
  @JsonKey(name: 'weight_kg', fromJson: _parseDouble)
  double? get weightKg;
  @override
  @JsonKey(name: 'height_cm', fromJson: _parseDouble)
  double? get heightCm;
  @override
  @JsonKey(fromJson: _parseDouble)
  double? get bmi;
  @override
  @JsonKey(name: 'general_examination')
  String? get generalExamination;
  @override
  @JsonKey(name: 'systemic_examination')
  String? get systemicExamination;
  @override
  @JsonKey(name: 'follow_up_date')
  String? get followUpDate;
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

  /// Create a copy of CaseSheet
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CaseSheetImplCopyWith<_$CaseSheetImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

MedicalHistoryItem _$MedicalHistoryItemFromJson(Map<String, dynamic> json) {
  return _MedicalHistoryItem.fromJson(json);
}

/// @nodoc
mixin _$MedicalHistoryItem {
  @JsonKey(fromJson: _parseIntRequired)
  int get id => throw _privateConstructorUsedError;
  @JsonKey(name: 'condition_name')
  String get conditionName => throw _privateConstructorUsedError;
  @JsonKey(name: 'diagnosed_at')
  String? get diagnosedAt => throw _privateConstructorUsedError;
  String? get notes => throw _privateConstructorUsedError;
  @JsonKey(name: 'created_at')
  String get createdAt => throw _privateConstructorUsedError;

  /// Serializes this MedicalHistoryItem to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of MedicalHistoryItem
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $MedicalHistoryItemCopyWith<MedicalHistoryItem> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $MedicalHistoryItemCopyWith<$Res> {
  factory $MedicalHistoryItemCopyWith(
    MedicalHistoryItem value,
    $Res Function(MedicalHistoryItem) then,
  ) = _$MedicalHistoryItemCopyWithImpl<$Res, MedicalHistoryItem>;
  @useResult
  $Res call({
    @JsonKey(fromJson: _parseIntRequired) int id,
    @JsonKey(name: 'condition_name') String conditionName,
    @JsonKey(name: 'diagnosed_at') String? diagnosedAt,
    String? notes,
    @JsonKey(name: 'created_at') String createdAt,
  });
}

/// @nodoc
class _$MedicalHistoryItemCopyWithImpl<$Res, $Val extends MedicalHistoryItem>
    implements $MedicalHistoryItemCopyWith<$Res> {
  _$MedicalHistoryItemCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of MedicalHistoryItem
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? conditionName = null,
    Object? diagnosedAt = freezed,
    Object? notes = freezed,
    Object? createdAt = null,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as int,
            conditionName: null == conditionName
                ? _value.conditionName
                : conditionName // ignore: cast_nullable_to_non_nullable
                      as String,
            diagnosedAt: freezed == diagnosedAt
                ? _value.diagnosedAt
                : diagnosedAt // ignore: cast_nullable_to_non_nullable
                      as String?,
            notes: freezed == notes
                ? _value.notes
                : notes // ignore: cast_nullable_to_non_nullable
                      as String?,
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
abstract class _$$MedicalHistoryItemImplCopyWith<$Res>
    implements $MedicalHistoryItemCopyWith<$Res> {
  factory _$$MedicalHistoryItemImplCopyWith(
    _$MedicalHistoryItemImpl value,
    $Res Function(_$MedicalHistoryItemImpl) then,
  ) = __$$MedicalHistoryItemImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    @JsonKey(fromJson: _parseIntRequired) int id,
    @JsonKey(name: 'condition_name') String conditionName,
    @JsonKey(name: 'diagnosed_at') String? diagnosedAt,
    String? notes,
    @JsonKey(name: 'created_at') String createdAt,
  });
}

/// @nodoc
class __$$MedicalHistoryItemImplCopyWithImpl<$Res>
    extends _$MedicalHistoryItemCopyWithImpl<$Res, _$MedicalHistoryItemImpl>
    implements _$$MedicalHistoryItemImplCopyWith<$Res> {
  __$$MedicalHistoryItemImplCopyWithImpl(
    _$MedicalHistoryItemImpl _value,
    $Res Function(_$MedicalHistoryItemImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of MedicalHistoryItem
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? conditionName = null,
    Object? diagnosedAt = freezed,
    Object? notes = freezed,
    Object? createdAt = null,
  }) {
    return _then(
      _$MedicalHistoryItemImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as int,
        conditionName: null == conditionName
            ? _value.conditionName
            : conditionName // ignore: cast_nullable_to_non_nullable
                  as String,
        diagnosedAt: freezed == diagnosedAt
            ? _value.diagnosedAt
            : diagnosedAt // ignore: cast_nullable_to_non_nullable
                  as String?,
        notes: freezed == notes
            ? _value.notes
            : notes // ignore: cast_nullable_to_non_nullable
                  as String?,
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
class _$MedicalHistoryItemImpl implements _MedicalHistoryItem {
  const _$MedicalHistoryItemImpl({
    @JsonKey(fromJson: _parseIntRequired) required this.id,
    @JsonKey(name: 'condition_name') required this.conditionName,
    @JsonKey(name: 'diagnosed_at') this.diagnosedAt,
    this.notes,
    @JsonKey(name: 'created_at') required this.createdAt,
  });

  factory _$MedicalHistoryItemImpl.fromJson(Map<String, dynamic> json) =>
      _$$MedicalHistoryItemImplFromJson(json);

  @override
  @JsonKey(fromJson: _parseIntRequired)
  final int id;
  @override
  @JsonKey(name: 'condition_name')
  final String conditionName;
  @override
  @JsonKey(name: 'diagnosed_at')
  final String? diagnosedAt;
  @override
  final String? notes;
  @override
  @JsonKey(name: 'created_at')
  final String createdAt;

  @override
  String toString() {
    return 'MedicalHistoryItem(id: $id, conditionName: $conditionName, diagnosedAt: $diagnosedAt, notes: $notes, createdAt: $createdAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$MedicalHistoryItemImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.conditionName, conditionName) ||
                other.conditionName == conditionName) &&
            (identical(other.diagnosedAt, diagnosedAt) ||
                other.diagnosedAt == diagnosedAt) &&
            (identical(other.notes, notes) || other.notes == notes) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    conditionName,
    diagnosedAt,
    notes,
    createdAt,
  );

  /// Create a copy of MedicalHistoryItem
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$MedicalHistoryItemImplCopyWith<_$MedicalHistoryItemImpl> get copyWith =>
      __$$MedicalHistoryItemImplCopyWithImpl<_$MedicalHistoryItemImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$MedicalHistoryItemImplToJson(this);
  }
}

abstract class _MedicalHistoryItem implements MedicalHistoryItem {
  const factory _MedicalHistoryItem({
    @JsonKey(fromJson: _parseIntRequired) required final int id,
    @JsonKey(name: 'condition_name') required final String conditionName,
    @JsonKey(name: 'diagnosed_at') final String? diagnosedAt,
    final String? notes,
    @JsonKey(name: 'created_at') required final String createdAt,
  }) = _$MedicalHistoryItemImpl;

  factory _MedicalHistoryItem.fromJson(Map<String, dynamic> json) =
      _$MedicalHistoryItemImpl.fromJson;

  @override
  @JsonKey(fromJson: _parseIntRequired)
  int get id;
  @override
  @JsonKey(name: 'condition_name')
  String get conditionName;
  @override
  @JsonKey(name: 'diagnosed_at')
  String? get diagnosedAt;
  @override
  String? get notes;
  @override
  @JsonKey(name: 'created_at')
  String get createdAt;

  /// Create a copy of MedicalHistoryItem
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$MedicalHistoryItemImplCopyWith<_$MedicalHistoryItemImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

RecordsResponse _$RecordsResponseFromJson(Map<String, dynamic> json) {
  return _RecordsResponse.fromJson(json);
}

/// @nodoc
mixin _$RecordsResponse {
  PatientRecordProfile? get patient => throw _privateConstructorUsedError;
  @JsonKey(name: 'case_sheets')
  List<CaseSheet> get caseSheets => throw _privateConstructorUsedError;
  @JsonKey(name: 'medical_history')
  List<MedicalHistoryItem> get medicalHistory =>
      throw _privateConstructorUsedError;

  /// Serializes this RecordsResponse to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of RecordsResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $RecordsResponseCopyWith<RecordsResponse> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $RecordsResponseCopyWith<$Res> {
  factory $RecordsResponseCopyWith(
    RecordsResponse value,
    $Res Function(RecordsResponse) then,
  ) = _$RecordsResponseCopyWithImpl<$Res, RecordsResponse>;
  @useResult
  $Res call({
    PatientRecordProfile? patient,
    @JsonKey(name: 'case_sheets') List<CaseSheet> caseSheets,
    @JsonKey(name: 'medical_history') List<MedicalHistoryItem> medicalHistory,
  });

  $PatientRecordProfileCopyWith<$Res>? get patient;
}

/// @nodoc
class _$RecordsResponseCopyWithImpl<$Res, $Val extends RecordsResponse>
    implements $RecordsResponseCopyWith<$Res> {
  _$RecordsResponseCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of RecordsResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? patient = freezed,
    Object? caseSheets = null,
    Object? medicalHistory = null,
  }) {
    return _then(
      _value.copyWith(
            patient: freezed == patient
                ? _value.patient
                : patient // ignore: cast_nullable_to_non_nullable
                      as PatientRecordProfile?,
            caseSheets: null == caseSheets
                ? _value.caseSheets
                : caseSheets // ignore: cast_nullable_to_non_nullable
                      as List<CaseSheet>,
            medicalHistory: null == medicalHistory
                ? _value.medicalHistory
                : medicalHistory // ignore: cast_nullable_to_non_nullable
                      as List<MedicalHistoryItem>,
          )
          as $Val,
    );
  }

  /// Create a copy of RecordsResponse
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $PatientRecordProfileCopyWith<$Res>? get patient {
    if (_value.patient == null) {
      return null;
    }

    return $PatientRecordProfileCopyWith<$Res>(_value.patient!, (value) {
      return _then(_value.copyWith(patient: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$RecordsResponseImplCopyWith<$Res>
    implements $RecordsResponseCopyWith<$Res> {
  factory _$$RecordsResponseImplCopyWith(
    _$RecordsResponseImpl value,
    $Res Function(_$RecordsResponseImpl) then,
  ) = __$$RecordsResponseImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    PatientRecordProfile? patient,
    @JsonKey(name: 'case_sheets') List<CaseSheet> caseSheets,
    @JsonKey(name: 'medical_history') List<MedicalHistoryItem> medicalHistory,
  });

  @override
  $PatientRecordProfileCopyWith<$Res>? get patient;
}

/// @nodoc
class __$$RecordsResponseImplCopyWithImpl<$Res>
    extends _$RecordsResponseCopyWithImpl<$Res, _$RecordsResponseImpl>
    implements _$$RecordsResponseImplCopyWith<$Res> {
  __$$RecordsResponseImplCopyWithImpl(
    _$RecordsResponseImpl _value,
    $Res Function(_$RecordsResponseImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of RecordsResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? patient = freezed,
    Object? caseSheets = null,
    Object? medicalHistory = null,
  }) {
    return _then(
      _$RecordsResponseImpl(
        patient: freezed == patient
            ? _value.patient
            : patient // ignore: cast_nullable_to_non_nullable
                  as PatientRecordProfile?,
        caseSheets: null == caseSheets
            ? _value._caseSheets
            : caseSheets // ignore: cast_nullable_to_non_nullable
                  as List<CaseSheet>,
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
class _$RecordsResponseImpl implements _RecordsResponse {
  const _$RecordsResponseImpl({
    this.patient,
    @JsonKey(name: 'case_sheets') required final List<CaseSheet> caseSheets,
    @JsonKey(name: 'medical_history')
    required final List<MedicalHistoryItem> medicalHistory,
  }) : _caseSheets = caseSheets,
       _medicalHistory = medicalHistory;

  factory _$RecordsResponseImpl.fromJson(Map<String, dynamic> json) =>
      _$$RecordsResponseImplFromJson(json);

  @override
  final PatientRecordProfile? patient;
  final List<CaseSheet> _caseSheets;
  @override
  @JsonKey(name: 'case_sheets')
  List<CaseSheet> get caseSheets {
    if (_caseSheets is EqualUnmodifiableListView) return _caseSheets;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_caseSheets);
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
    return 'RecordsResponse(patient: $patient, caseSheets: $caseSheets, medicalHistory: $medicalHistory)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$RecordsResponseImpl &&
            (identical(other.patient, patient) || other.patient == patient) &&
            const DeepCollectionEquality().equals(
              other._caseSheets,
              _caseSheets,
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
    const DeepCollectionEquality().hash(_caseSheets),
    const DeepCollectionEquality().hash(_medicalHistory),
  );

  /// Create a copy of RecordsResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$RecordsResponseImplCopyWith<_$RecordsResponseImpl> get copyWith =>
      __$$RecordsResponseImplCopyWithImpl<_$RecordsResponseImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$RecordsResponseImplToJson(this);
  }
}

abstract class _RecordsResponse implements RecordsResponse {
  const factory _RecordsResponse({
    final PatientRecordProfile? patient,
    @JsonKey(name: 'case_sheets') required final List<CaseSheet> caseSheets,
    @JsonKey(name: 'medical_history')
    required final List<MedicalHistoryItem> medicalHistory,
  }) = _$RecordsResponseImpl;

  factory _RecordsResponse.fromJson(Map<String, dynamic> json) =
      _$RecordsResponseImpl.fromJson;

  @override
  PatientRecordProfile? get patient;
  @override
  @JsonKey(name: 'case_sheets')
  List<CaseSheet> get caseSheets;
  @override
  @JsonKey(name: 'medical_history')
  List<MedicalHistoryItem> get medicalHistory;

  /// Create a copy of RecordsResponse
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$RecordsResponseImplCopyWith<_$RecordsResponseImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
