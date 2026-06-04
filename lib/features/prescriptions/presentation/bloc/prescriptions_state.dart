import '../../data/models/prescription.dart';

abstract class PrescriptionsState {
  const PrescriptionsState();
}

class PrescriptionsInitial extends PrescriptionsState {
  const PrescriptionsInitial();
}

class PrescriptionsLoading extends PrescriptionsState {
  const PrescriptionsLoading();
}

class PrescriptionsLoaded extends PrescriptionsState {
  final List<Prescription> prescriptions;
  const PrescriptionsLoaded(this.prescriptions);
}

class PrescriptionsError extends PrescriptionsState {
  final String message;
  const PrescriptionsError(this.message);
}
