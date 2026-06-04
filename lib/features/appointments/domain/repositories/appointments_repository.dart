import '../../data/models/appointment.dart';

abstract class AppointmentsRepository {
  Future<List<Appointment>> getAppointments();
  Future<void> cancelAppointment(int appointmentId);
}
