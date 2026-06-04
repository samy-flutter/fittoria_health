import '../../../profile_records/data/models/profile_models.dart';

abstract class ProfileState {
  const ProfileState();
}

class ProfileInitial extends ProfileState {
  const ProfileInitial();
}

class ProfileLoading extends ProfileState {
  const ProfileLoading();
}

class ProfileLoaded extends ProfileState {
  final ProfileResponse response;
  final PatientProfile editedPatient;
  final bool isSaving;
  final String? successMessage;
  final String? errorMessage;

  const ProfileLoaded({
    required this.response,
    required this.editedPatient,
    this.isSaving = false,
    this.successMessage,
    this.errorMessage,
  });

  ProfileLoaded copyWith({
    ProfileResponse? response,
    PatientProfile? editedPatient,
    bool? isSaving,
    String? successMessage,
    bool clearSuccessMessage = false,
    String? errorMessage,
    bool clearErrorMessage = false,
  }) {
    return ProfileLoaded(
      response: response ?? this.response,
      editedPatient: editedPatient ?? this.editedPatient,
      isSaving: isSaving ?? this.isSaving,
      successMessage: clearSuccessMessage ? null : (successMessage ?? this.successMessage),
      errorMessage: clearErrorMessage ? null : (errorMessage ?? this.errorMessage),
    );
  }
}

class ProfileError extends ProfileState {
  final String message;
  const ProfileError(this.message);
}
