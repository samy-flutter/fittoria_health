// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'appointment.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

Appointment _$AppointmentFromJson(Map<String, dynamic> json) {
  return _Appointment.fromJson(json);
}

/// @nodoc
mixin _$Appointment {
  int get id => throw _privateConstructorUsedError;
  String get status =>
      throw _privateConstructorUsedError; // scheduled, waiting, in_consultation, completed, cancelled, no_show
  @JsonKey(name: 'clinic_name')
  String get clinicName => throw _privateConstructorUsedError;
  @JsonKey(name: 'doctor_name')
  String get doctorName => throw _privateConstructorUsedError;
  @JsonKey(name: 'appointment_date')
  String get appointmentDate => throw _privateConstructorUsedError;
  @JsonKey(name: 'slot_start')
  String get slotStart => throw _privateConstructorUsedError;
  @JsonKey(name: 'slot_end')
  String? get slotEnd => throw _privateConstructorUsedError;
  @JsonKey(name: 'clinic_city')
  String? get clinicCity => throw _privateConstructorUsedError;
  @JsonKey(name: 'visit_type')
  String? get visitType => throw _privateConstructorUsedError; // e.g. "online", "physical"
  @JsonKey(name: 'chief_complaint')
  String? get chiefComplaint => throw _privateConstructorUsedError;
  @JsonKey(name: 'clinic_phone')
  String? get clinicPhone => throw _privateConstructorUsedError;

  /// Serializes this Appointment to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Appointment
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $AppointmentCopyWith<Appointment> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AppointmentCopyWith<$Res> {
  factory $AppointmentCopyWith(
    Appointment value,
    $Res Function(Appointment) then,
  ) = _$AppointmentCopyWithImpl<$Res, Appointment>;
  @useResult
  $Res call({
    int id,
    String status,
    @JsonKey(name: 'clinic_name') String clinicName,
    @JsonKey(name: 'doctor_name') String doctorName,
    @JsonKey(name: 'appointment_date') String appointmentDate,
    @JsonKey(name: 'slot_start') String slotStart,
    @JsonKey(name: 'slot_end') String? slotEnd,
    @JsonKey(name: 'clinic_city') String? clinicCity,
    @JsonKey(name: 'visit_type') String? visitType,
    @JsonKey(name: 'chief_complaint') String? chiefComplaint,
    @JsonKey(name: 'clinic_phone') String? clinicPhone,
  });
}

/// @nodoc
class _$AppointmentCopyWithImpl<$Res, $Val extends Appointment>
    implements $AppointmentCopyWith<$Res> {
  _$AppointmentCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Appointment
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? status = null,
    Object? clinicName = null,
    Object? doctorName = null,
    Object? appointmentDate = null,
    Object? slotStart = null,
    Object? slotEnd = freezed,
    Object? clinicCity = freezed,
    Object? visitType = freezed,
    Object? chiefComplaint = freezed,
    Object? clinicPhone = freezed,
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
            clinicName: null == clinicName
                ? _value.clinicName
                : clinicName // ignore: cast_nullable_to_non_nullable
                      as String,
            doctorName: null == doctorName
                ? _value.doctorName
                : doctorName // ignore: cast_nullable_to_non_nullable
                      as String,
            appointmentDate: null == appointmentDate
                ? _value.appointmentDate
                : appointmentDate // ignore: cast_nullable_to_non_nullable
                      as String,
            slotStart: null == slotStart
                ? _value.slotStart
                : slotStart // ignore: cast_nullable_to_non_nullable
                      as String,
            slotEnd: freezed == slotEnd
                ? _value.slotEnd
                : slotEnd // ignore: cast_nullable_to_non_nullable
                      as String?,
            clinicCity: freezed == clinicCity
                ? _value.clinicCity
                : clinicCity // ignore: cast_nullable_to_non_nullable
                      as String?,
            visitType: freezed == visitType
                ? _value.visitType
                : visitType // ignore: cast_nullable_to_non_nullable
                      as String?,
            chiefComplaint: freezed == chiefComplaint
                ? _value.chiefComplaint
                : chiefComplaint // ignore: cast_nullable_to_non_nullable
                      as String?,
            clinicPhone: freezed == clinicPhone
                ? _value.clinicPhone
                : clinicPhone // ignore: cast_nullable_to_non_nullable
                      as String?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$AppointmentImplCopyWith<$Res>
    implements $AppointmentCopyWith<$Res> {
  factory _$$AppointmentImplCopyWith(
    _$AppointmentImpl value,
    $Res Function(_$AppointmentImpl) then,
  ) = __$$AppointmentImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    int id,
    String status,
    @JsonKey(name: 'clinic_name') String clinicName,
    @JsonKey(name: 'doctor_name') String doctorName,
    @JsonKey(name: 'appointment_date') String appointmentDate,
    @JsonKey(name: 'slot_start') String slotStart,
    @JsonKey(name: 'slot_end') String? slotEnd,
    @JsonKey(name: 'clinic_city') String? clinicCity,
    @JsonKey(name: 'visit_type') String? visitType,
    @JsonKey(name: 'chief_complaint') String? chiefComplaint,
    @JsonKey(name: 'clinic_phone') String? clinicPhone,
  });
}

/// @nodoc
class __$$AppointmentImplCopyWithImpl<$Res>
    extends _$AppointmentCopyWithImpl<$Res, _$AppointmentImpl>
    implements _$$AppointmentImplCopyWith<$Res> {
  __$$AppointmentImplCopyWithImpl(
    _$AppointmentImpl _value,
    $Res Function(_$AppointmentImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of Appointment
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? status = null,
    Object? clinicName = null,
    Object? doctorName = null,
    Object? appointmentDate = null,
    Object? slotStart = null,
    Object? slotEnd = freezed,
    Object? clinicCity = freezed,
    Object? visitType = freezed,
    Object? chiefComplaint = freezed,
    Object? clinicPhone = freezed,
  }) {
    return _then(
      _$AppointmentImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as int,
        status: null == status
            ? _value.status
            : status // ignore: cast_nullable_to_non_nullable
                  as String,
        clinicName: null == clinicName
            ? _value.clinicName
            : clinicName // ignore: cast_nullable_to_non_nullable
                  as String,
        doctorName: null == doctorName
            ? _value.doctorName
            : doctorName // ignore: cast_nullable_to_non_nullable
                  as String,
        appointmentDate: null == appointmentDate
            ? _value.appointmentDate
            : appointmentDate // ignore: cast_nullable_to_non_nullable
                  as String,
        slotStart: null == slotStart
            ? _value.slotStart
            : slotStart // ignore: cast_nullable_to_non_nullable
                  as String,
        slotEnd: freezed == slotEnd
            ? _value.slotEnd
            : slotEnd // ignore: cast_nullable_to_non_nullable
                  as String?,
        clinicCity: freezed == clinicCity
            ? _value.clinicCity
            : clinicCity // ignore: cast_nullable_to_non_nullable
                  as String?,
        visitType: freezed == visitType
            ? _value.visitType
            : visitType // ignore: cast_nullable_to_non_nullable
                  as String?,
        chiefComplaint: freezed == chiefComplaint
            ? _value.chiefComplaint
            : chiefComplaint // ignore: cast_nullable_to_non_nullable
                  as String?,
        clinicPhone: freezed == clinicPhone
            ? _value.clinicPhone
            : clinicPhone // ignore: cast_nullable_to_non_nullable
                  as String?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$AppointmentImpl implements _Appointment {
  const _$AppointmentImpl({
    required this.id,
    required this.status,
    @JsonKey(name: 'clinic_name') required this.clinicName,
    @JsonKey(name: 'doctor_name') required this.doctorName,
    @JsonKey(name: 'appointment_date') required this.appointmentDate,
    @JsonKey(name: 'slot_start') required this.slotStart,
    @JsonKey(name: 'slot_end') this.slotEnd,
    @JsonKey(name: 'clinic_city') this.clinicCity,
    @JsonKey(name: 'visit_type') this.visitType,
    @JsonKey(name: 'chief_complaint') this.chiefComplaint,
    @JsonKey(name: 'clinic_phone') this.clinicPhone,
  });

  factory _$AppointmentImpl.fromJson(Map<String, dynamic> json) =>
      _$$AppointmentImplFromJson(json);

  @override
  final int id;
  @override
  final String status;
  // scheduled, waiting, in_consultation, completed, cancelled, no_show
  @override
  @JsonKey(name: 'clinic_name')
  final String clinicName;
  @override
  @JsonKey(name: 'doctor_name')
  final String doctorName;
  @override
  @JsonKey(name: 'appointment_date')
  final String appointmentDate;
  @override
  @JsonKey(name: 'slot_start')
  final String slotStart;
  @override
  @JsonKey(name: 'slot_end')
  final String? slotEnd;
  @override
  @JsonKey(name: 'clinic_city')
  final String? clinicCity;
  @override
  @JsonKey(name: 'visit_type')
  final String? visitType;
  // e.g. "online", "physical"
  @override
  @JsonKey(name: 'chief_complaint')
  final String? chiefComplaint;
  @override
  @JsonKey(name: 'clinic_phone')
  final String? clinicPhone;

  @override
  String toString() {
    return 'Appointment(id: $id, status: $status, clinicName: $clinicName, doctorName: $doctorName, appointmentDate: $appointmentDate, slotStart: $slotStart, slotEnd: $slotEnd, clinicCity: $clinicCity, visitType: $visitType, chiefComplaint: $chiefComplaint, clinicPhone: $clinicPhone)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AppointmentImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.clinicName, clinicName) ||
                other.clinicName == clinicName) &&
            (identical(other.doctorName, doctorName) ||
                other.doctorName == doctorName) &&
            (identical(other.appointmentDate, appointmentDate) ||
                other.appointmentDate == appointmentDate) &&
            (identical(other.slotStart, slotStart) ||
                other.slotStart == slotStart) &&
            (identical(other.slotEnd, slotEnd) || other.slotEnd == slotEnd) &&
            (identical(other.clinicCity, clinicCity) ||
                other.clinicCity == clinicCity) &&
            (identical(other.visitType, visitType) ||
                other.visitType == visitType) &&
            (identical(other.chiefComplaint, chiefComplaint) ||
                other.chiefComplaint == chiefComplaint) &&
            (identical(other.clinicPhone, clinicPhone) ||
                other.clinicPhone == clinicPhone));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    status,
    clinicName,
    doctorName,
    appointmentDate,
    slotStart,
    slotEnd,
    clinicCity,
    visitType,
    chiefComplaint,
    clinicPhone,
  );

  /// Create a copy of Appointment
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$AppointmentImplCopyWith<_$AppointmentImpl> get copyWith =>
      __$$AppointmentImplCopyWithImpl<_$AppointmentImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$AppointmentImplToJson(this);
  }
}

abstract class _Appointment implements Appointment {
  const factory _Appointment({
    required final int id,
    required final String status,
    @JsonKey(name: 'clinic_name') required final String clinicName,
    @JsonKey(name: 'doctor_name') required final String doctorName,
    @JsonKey(name: 'appointment_date') required final String appointmentDate,
    @JsonKey(name: 'slot_start') required final String slotStart,
    @JsonKey(name: 'slot_end') final String? slotEnd,
    @JsonKey(name: 'clinic_city') final String? clinicCity,
    @JsonKey(name: 'visit_type') final String? visitType,
    @JsonKey(name: 'chief_complaint') final String? chiefComplaint,
    @JsonKey(name: 'clinic_phone') final String? clinicPhone,
  }) = _$AppointmentImpl;

  factory _Appointment.fromJson(Map<String, dynamic> json) =
      _$AppointmentImpl.fromJson;

  @override
  int get id;
  @override
  String get status; // scheduled, waiting, in_consultation, completed, cancelled, no_show
  @override
  @JsonKey(name: 'clinic_name')
  String get clinicName;
  @override
  @JsonKey(name: 'doctor_name')
  String get doctorName;
  @override
  @JsonKey(name: 'appointment_date')
  String get appointmentDate;
  @override
  @JsonKey(name: 'slot_start')
  String get slotStart;
  @override
  @JsonKey(name: 'slot_end')
  String? get slotEnd;
  @override
  @JsonKey(name: 'clinic_city')
  String? get clinicCity;
  @override
  @JsonKey(name: 'visit_type')
  String? get visitType; // e.g. "online", "physical"
  @override
  @JsonKey(name: 'chief_complaint')
  String? get chiefComplaint;
  @override
  @JsonKey(name: 'clinic_phone')
  String? get clinicPhone;

  /// Create a copy of Appointment
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$AppointmentImplCopyWith<_$AppointmentImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
