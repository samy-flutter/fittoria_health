import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/repositories/lab_repository.dart';
import 'lab_referrals_event.dart';
import 'lab_referrals_state.dart';

class LabReferralsBloc extends Bloc<LabReferralsEvent, LabReferralsState> {
  final LabRepository _repository;

  LabReferralsBloc(this._repository) : super(LabReferralsState.initial()) {
    on<LoadLabReferrals>(_onLoadLabReferrals);
    on<LoadLabReferralDetails>(_onLoadLabReferralDetails);
    on<ConfirmReferralBooking>(_onConfirmReferralBooking);
    on<CancelReferralBooking>(_onCancelReferralBooking);
  }

  Future<void> _onLoadLabReferrals(LoadLabReferrals event, Emitter<LabReferralsState> emit) async {
    emit(state.copyWith(isLoading: true, errorMessage: () => null, successMessage: () => null));
    try {
      final response = await _repository.getLabReferrals();
      emit(state.copyWith(
        referrals: response.referrals,
        notifications: response.notifications,
        isLoading: false,
      ));
    } catch (e) {
      emit(state.copyWith(
        isLoading: false,
        errorMessage: () => e.toString(),
      ));
    }
  }

  Future<void> _onLoadLabReferralDetails(LoadLabReferralDetails event, Emitter<LabReferralsState> emit) async {
    emit(state.copyWith(isLoading: true, errorMessage: () => null, successMessage: () => null));
    try {
      final response = await _repository.getLabReferralDetails(event.referralId);
      emit(state.copyWith(
        selectedReferral: () => response.referral,
        notifications: response.notifications,
        isLoading: false,
      ));
    } catch (e) {
      emit(state.copyWith(
        isLoading: false,
        errorMessage: () => e.toString(),
      ));
    }
  }

  Future<void> _onConfirmReferralBooking(ConfirmReferralBooking event, Emitter<LabReferralsState> emit) async {
    emit(state.copyWith(isActing: true, errorMessage: () => null, successMessage: () => null));
    try {
      await _repository.confirmLabReferral(event.referralId);
      emit(state.copyWith(
        isActing: false,
        successMessage: () => 'Booking confirmed!',
      ));
      // Reload details/list depending on what is active
      if (state.selectedReferral?.id == event.referralId) {
        add(LoadLabReferralDetails(event.referralId));
      } else {
        add(const LoadLabReferrals());
      }
    } catch (e) {
      emit(state.copyWith(
        isActing: false,
        errorMessage: () => e.toString(),
      ));
    }
  }

  Future<void> _onCancelReferralBooking(CancelReferralBooking event, Emitter<LabReferralsState> emit) async {
    emit(state.copyWith(isActing: true, errorMessage: () => null, successMessage: () => null));
    try {
      await _repository.cancelLabReferral(event.referralId);
      emit(state.copyWith(
        isActing: false,
        successMessage: () => 'Referral cancelled!',
      ));
      // Reload details/list depending on what is active
      if (state.selectedReferral?.id == event.referralId) {
        add(LoadLabReferralDetails(event.referralId));
      } else {
        add(const LoadLabReferrals());
      }
    } catch (e) {
      emit(state.copyWith(
        isActing: false,
        errorMessage: () => e.toString(),
      ));
    }
  }
}
