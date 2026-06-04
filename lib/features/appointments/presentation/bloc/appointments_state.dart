import '../../data/models/appointment.dart';
import 'appointments_event.dart';

abstract class AppointmentsState {
  const AppointmentsState();
}

class AppointmentsInitial extends AppointmentsState {}

class AppointmentsLoading extends AppointmentsState {}

class AppointmentsLoaded extends AppointmentsState {
  final List<Appointment> allAppointments;
  final List<Appointment> filteredAppointments;
  final AppointmentFilter activeFilter;
  final Map<AppointmentFilter, int> counts;
  final int? cancellingId;

  const AppointmentsLoaded({
    required this.allAppointments,
    required this.filteredAppointments,
    required this.activeFilter,
    required this.counts,
    this.cancellingId,
  });

  AppointmentsLoaded copyWith({
    List<Appointment>? allAppointments,
    List<Appointment>? filteredAppointments,
    AppointmentFilter? activeFilter,
    Map<AppointmentFilter, int>? counts,
    int? cancellingId,
    bool clearCancellingId = false,
  }) {
    return AppointmentsLoaded(
      allAppointments: allAppointments ?? this.allAppointments,
      filteredAppointments: filteredAppointments ?? this.filteredAppointments,
      activeFilter: activeFilter ?? this.activeFilter,
      counts: counts ?? this.counts,
      cancellingId: clearCancellingId ? null : (cancellingId ?? this.cancellingId),
    );
  }
}

class AppointmentsError extends AppointmentsState {
  final String message;
  const AppointmentsError(this.message);
}

class AppointmentCancelSuccess extends AppointmentsState {
  final String message;
  const AppointmentCancelSuccess(this.message);
}
