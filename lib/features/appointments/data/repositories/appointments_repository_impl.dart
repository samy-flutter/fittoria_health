import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/error/exception_handler.dart';
import '../../domain/repositories/appointments_repository.dart';
import '../data_sources/appointments_remote_data_source.dart';
import '../models/appointment.dart';

class AppointmentsRepositoryImpl implements AppointmentsRepository {
  final AppointmentsRemoteDataSource _remoteDataSource;

  AppointmentsRepositoryImpl(this._remoteDataSource);

  @override
  Future<Either<Failure, List<Appointment>>> getAppointments() async {
    try {
      final appointments = await _remoteDataSource.getAppointments();
      return Right(appointments);
    } catch (e) {
      return Left(ExceptionHandler.handle(e));
    }
  }

  @override
  Future<Either<Failure, void>> cancelAppointment(int appointmentId) async {
    try {
      await _remoteDataSource.cancelAppointment(appointmentId);
      return const Right(null);
    } catch (e) {
      return Left(ExceptionHandler.handle(e));
    }
  }
}
