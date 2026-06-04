import '../../../profile_records/data/models/profile_models.dart';
import '../../../appointments/data/models/appointment.dart';
import '../../../invoices/data/models/invoice.dart';
import '../../../clinics/data/models/clinic.dart';

abstract class DashboardState {
  const DashboardState();
}

class DashboardInitial extends DashboardState {}

class DashboardLoading extends DashboardState {}

class DashboardLoaded extends DashboardState {
  final PatientProfile profile;
  final List<Appointment> appointments;
  final Appointment? nextAppointment;
  final double? bmi;
  final String? bmiClassification;

  // Extended fields for full Next.js parity
  final List<PatientInvoice> invoices;
  final List<Clinic> clinics;
  final int pendingInvoiceCount;
  final List<Appointment> recentVisits; // last 3 completed appointments

  const DashboardLoaded({
    required this.profile,
    required this.appointments,
    this.nextAppointment,
    this.bmi,
    this.bmiClassification,
    this.invoices = const [],
    this.clinics = const [],
    this.pendingInvoiceCount = 0,
    this.recentVisits = const [],
  });

  List<Appointment> get upcomingAppointments => appointments
      .where((a) =>
          ['scheduled', 'waiting', 'in_consultation'].contains(a.status))
      .toList();

  int get totalVisits => appointments.length;
}

class DashboardError extends DashboardState {
  final String message;

  const DashboardError(this.message);
}
