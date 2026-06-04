import '../../domain/repositories/appointments_repository.dart';
import '../data_sources/appointments_remote_data_source.dart';
import '../models/appointment.dart';

class AppointmentsRepositoryImpl implements AppointmentsRepository {
  final AppointmentsRemoteDataSource _remoteDataSource;

  AppointmentsRepositoryImpl(this._remoteDataSource);

  @override
  Future<List<Appointment>> getAppointments() {
    return _remoteDataSource.getAppointments();
  }

  @override
  Future<void> cancelAppointment(int appointmentId) {
    return _remoteDataSource.cancelAppointment(appointmentId);
  }
}
