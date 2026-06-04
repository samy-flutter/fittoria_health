import '../../data/models/lab_referral.dart';

class LabReferralsState {
  final List<LabReferral> referrals;
  final List<LabReferralNotification> notifications;
  final LabReferral? selectedReferral;
  final bool isLoading;
  final bool isActing;
  final String? errorMessage;
  final String? successMessage;

  const LabReferralsState({
    required this.referrals,
    required this.notifications,
    this.selectedReferral,
    required this.isLoading,
    required this.isActing,
    this.errorMessage,
    this.successMessage,
  });

  factory LabReferralsState.initial() {
    return const LabReferralsState(
      referrals: [],
      notifications: [],
      isLoading: false,
      isActing: false,
    );
  }

  LabReferralsState copyWith({
    List<LabReferral>? referrals,
    List<LabReferralNotification>? notifications,
    LabReferral? Function()? selectedReferral,
    bool? isLoading,
    bool? isActing,
    String? Function()? errorMessage,
    String? Function()? successMessage,
  }) {
    return LabReferralsState(
      referrals: referrals ?? this.referrals,
      notifications: notifications ?? this.notifications,
      selectedReferral: selectedReferral != null ? selectedReferral() : this.selectedReferral,
      isLoading: isLoading ?? this.isLoading,
      isActing: isActing ?? this.isActing,
      errorMessage: errorMessage != null ? errorMessage() : this.errorMessage,
      successMessage: successMessage != null ? successMessage() : this.successMessage,
    );
  }
}
