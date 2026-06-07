import '../../../profile_records/data/models/profile_models.dart';
import '../../../appointments/data/models/appointment.dart';
import '../../../fit/data/models/fitness_models.dart';

abstract class DashboardState {
  const DashboardState();
}

class DashboardInitial extends DashboardState {}

class DashboardLoading extends DashboardState {}

class DashboardLoaded extends DashboardState {
  final PatientProfile profile;
  final List<Appointment> appointments;
  final FitnessSummary fitnessSummary;
  final OnboardingStatus onboardingStatus;

  const DashboardLoaded({
    required this.profile,
    required this.appointments,
    required this.fitnessSummary,
    required this.onboardingStatus,
  });

  Appointment? get nextAppointment {
    final upcoming = appointments
        .where((a) => ['scheduled', 'waiting', 'in_consultation'].contains(a.status))
        .toList();
    if (upcoming.isEmpty) return null;
    
    upcoming.sort((a, b) {
      final aDate = DateTime.tryParse('${a.appointmentDate}T${a.slotStart}');
      final bDate = DateTime.tryParse('${b.appointmentDate}T${b.slotStart}');
      if (aDate == null || bDate == null) return 0;
      return aDate.compareTo(bDate);
    });
    return upcoming.first;
  }
}

class DashboardError extends DashboardState {
  final String message;

  const DashboardError(this.message);
}
