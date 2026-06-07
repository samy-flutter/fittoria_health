import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/error/exception_handler.dart';
import '../../domain/repositories/prescriptions_repository.dart';
import '../data_sources/prescriptions_remote_data_source.dart';
import '../models/prescription.dart';

class PrescriptionsRepositoryImpl implements PrescriptionsRepository {
  final PrescriptionsRemoteDataSource _remoteDataSource;

  PrescriptionsRepositoryImpl(this._remoteDataSource);

  @override
  Future<Either<Failure, List<Prescription>>> getPrescriptions() async {
    try {
      final response = await _remoteDataSource.getPrescriptions();
      return Right(response.prescriptions);
    } catch (e) {
      return Left(ExceptionHandler.handle(e));
    }
  }
}
