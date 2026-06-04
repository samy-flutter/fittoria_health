abstract class LabReferralsEvent {
  const LabReferralsEvent();
}

class LoadLabReferrals extends LabReferralsEvent {
  const LoadLabReferrals();
}

class LoadLabReferralDetails extends LabReferralsEvent {
  final int referralId;
  const LoadLabReferralDetails(this.referralId);
}

class ConfirmReferralBooking extends LabReferralsEvent {
  final int referralId;
  const ConfirmReferralBooking(this.referralId);
}

class CancelReferralBooking extends LabReferralsEvent {
  final int referralId;
  const CancelReferralBooking(this.referralId);
}
