import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../profile_records/domain/repositories/profile_repository.dart';
import '../../../profile_records/data/models/profile_models.dart';
import 'profile_state.dart';

class ProfileCubit extends Cubit<ProfileState> {
  final ProfileRepository _repository;

  ProfileCubit(this._repository) : super(const ProfileInitial());

  Future<void> loadProfile() async {
    emit(const ProfileLoading());
    try {
      final response = await _repository.getProfile();
      emit(ProfileLoaded(
        response: response,
        editedPatient: response.patient,
      ));
    } catch (e) {
      emit(ProfileError(e.toString()));
    }
  }

  void updateField(PatientProfile updatedPatient) {
    final currentState = state;
    if (currentState is ProfileLoaded) {
      emit(currentState.copyWith(editedPatient: updatedPatient));
    }
  }

  Future<void> saveProfile() async {
    final currentState = state;
    if (currentState is! ProfileLoaded) return;

    emit(currentState.copyWith(
      isSaving: true,
      clearSuccessMessage: true,
      clearErrorMessage: true,
    ));

    try {
      // Create request payload from editedPatient
      final p = currentState.editedPatient;
      final payload = {
        'full_name': p.fullName,
        'email': p.email,
        'date_of_birth': p.dateOfBirth,
        'gender_id': p.genderId,
        'blood_group_id': p.bloodGroupId,
        'address_line1': p.addressLine1,
        'city': p.city,
        'state': p.state,
        'pincode': p.pincode,
        'emergency_name': p.emergencyName,
        'emergency_phone': p.emergencyPhone,
        'emergency_relation': p.emergencyRelation,
        'height_cm': p.heightCm,
        'weight_kg': p.weightKg,
        'allergies': p.allergies,
        'current_medications': p.currentMedications,
      };

      final updatedPatient = await _repository.updateProfile(payload);
      
      // Update local state with saved data
      final newResponse = currentState.response.copyWith(patient: updatedPatient);
      emit(ProfileLoaded(
        response: newResponse,
        editedPatient: updatedPatient,
        successMessage: 'Profile updated successfully',
      ));

      // Auto clear success message after 2.5s
      await Future.delayed(const Duration(milliseconds: 2500));
      clearMessages();
    } catch (e) {
      emit((state as ProfileLoaded).copyWith(
        isSaving: false,
        errorMessage: e.toString(),
      ));
    }
  }

  void clearMessages() {
    final currentState = state;
    if (currentState is ProfileLoaded) {
      emit(currentState.copyWith(
        clearSuccessMessage: true,
        clearErrorMessage: true,
      ));
    }
  }
}
