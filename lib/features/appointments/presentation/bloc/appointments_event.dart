
abstract class AppointmentsEvent {
  const AppointmentsEvent();
}

class LoadAppointments extends AppointmentsEvent {
  const LoadAppointments();
}

class CancelAppointment extends AppointmentsEvent {
  final int appointmentId;
  const CancelAppointment(this.appointmentId);
}

class ChangeFilter extends AppointmentsEvent {
  final AppointmentFilter filter;
  const ChangeFilter(this.filter);
}

enum AppointmentFilter { all, upcoming, completed, cancelled }
