import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../data/models/appointment.dart';

abstract class AppointmentsRepository {
  Future<Either<Failure, List<Appointment>>> getAppointments();
  Future<Either<Failure, void>> cancelAppointment(int appointmentId);
}
